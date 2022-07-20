CREATE OR REPLACE PROCEDURE dfn_ntp.sp_customer_restriction (
    pu01_id               IN NUMBER,
    pnarration            IN VARCHAR,
    pnarration_lang       IN VARCHAR,
    prestriction_source   IN NUMBER,
    pm02_id               IN NUMBER)
IS
    l_count                   NUMBER;
    l_pkey                    NUMBER;
    stmt                      VARCHAR2 (1000);
    l_m71_stock_trading       m71_institute_restrictions.m71_stock_trading%TYPE;
    l_m71_stock_transaction   m71_institute_restrictions.m71_stock_transaction%TYPE;
    l_m71_stock_transfer      m71_institute_restrictions.m71_stock_transfer%TYPE;
    l_m71_pledge              m71_institute_restrictions.m71_pledge%TYPE;
    l_m71_cash_transactions   m71_institute_restrictions.m71_cash_transactions%TYPE;
    l_m71_cash_transfer       m71_institute_restrictions.m71_cash_transfer%TYPE;
    l_rec_count               NUMBER;
BEGIN
    SELECT COUNT (m71_restriction_id)
      INTO l_rec_count
      FROM m71_institute_restrictions m71
     WHERE     m71.m71_institution_id_m02 = pm02_id
           AND m71.m71_type = prestriction_source;

    IF l_rec_count = 1
    THEN
        SELECT m71.m71_stock_trading,
               m71.m71_stock_transaction,
               m71.m71_stock_transfer,
               m71.m71_pledge,
               m71.m71_cash_transactions,
               m71.m71_cash_transfer
          INTO l_m71_stock_trading,
               l_m71_stock_transaction,
               l_m71_stock_transfer,
               l_m71_pledge,
               l_m71_cash_transactions,
               l_m71_cash_transfer
          FROM m71_institute_restrictions m71
         WHERE     m71.m71_institution_id_m02 = pm02_id
               AND m71.m71_type = prestriction_source;


        FOR i IN (SELECT u07_id
                    FROM u07_trading_account
                   WHERE u07_customer_id_u01 = pu01_id)
        LOOP
            sp_trading_acc_wise_restrict (
                pu07_id                  => i.u07_id,
                pm71_stock_trading       => l_m71_stock_trading,
                pm71_stock_transaction   => l_m71_stock_transaction,
                pm71_stock_transfer      => l_m71_stock_transfer,
                pm71_pledge              => l_m71_pledge,
                pnarration               => pnarration,
                pnarration_lang          => pnarration_lang,
                prestriction_source      => prestriction_source);
        END LOOP;

        FOR j IN (SELECT u06_id
                    FROM u06_cash_account
                   WHERE u06_cash_account.u06_customer_id_u01 = pu01_id)
        LOOP
            sp_cash_acc_wise_restrict (
                pu06_id                  => j.u06_id,
                pm71_cash_transactions   => l_m71_cash_transactions,
                pm71_cash_transfer       => l_m71_cash_transfer,
                pnarration               => pnarration,
                pnarration_lang          => pnarration_lang,
                prestriction_source      => prestriction_source);
        END LOOP;
    END IF;
END;
/
/
