CREATE OR REPLACE PROCEDURE dfn_ntp.sp_add_accont_closure_restrict (
    pu07_id   IN NUMBER)
IS
    l_m71_stock_trading         m71_institute_restrictions.m71_stock_trading%TYPE;
    l_m71_stock_transaction     m71_institute_restrictions.m71_stock_transaction%TYPE;
    l_m71_stock_transfer        m71_institute_restrictions.m71_stock_transfer%TYPE;
    l_m71_pledge                m71_institute_restrictions.m71_pledge%TYPE;
    l_m71_cash_transactions     m71_institute_restrictions.m71_cash_transactions%TYPE;
    l_m71_cash_transfer         m71_institute_restrictions.m71_cash_transfer%TYPE;
    l_rec_count                 NUMBER (10);
    l_u07_institute_id_m02      NUMBER (10);
    l_u07_cash_account_id_u06   NUMBER (10);
    l_trading_acc_count         NUMBER (10);
BEGIN
    SELECT COUNT (u07_id)
      INTO l_trading_acc_count
      FROM u07_trading_account
     WHERE u07_id = pu07_id;

    IF l_trading_acc_count = 1
    THEN
        SELECT u07.u07_institute_id_m02, u07.u07_cash_account_id_u06
          INTO l_u07_institute_id_m02, l_u07_cash_account_id_u06
          FROM u07_trading_account u07
         WHERE u07.u07_id = pu07_id;

        --** CLOSE Trading Account --** disable Trading

        UPDATE u07_trading_account u07
           SET u07.u07_status_id_v01 = 22, u07_trading_enabled = 0
         WHERE u07.u07_id = pu07_id;

        --** Add Restrictions

        SELECT COUNT (m71_restriction_id)
          INTO l_rec_count
          FROM m71_institute_restrictions m71
         WHERE     m71.m71_institution_id_m02 = l_u07_institute_id_m02
               AND m71.m71_type = 5;

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
             WHERE     m71.m71_institution_id_m02 = l_u07_institute_id_m02
                   AND m71.m71_type = 5;

            sp_trading_acc_wise_restrict (
                pu07_id                  => pu07_id,
                pm71_stock_trading       => l_m71_stock_trading,
                pm71_stock_transaction   => l_m71_stock_transaction,
                pm71_stock_transfer      => l_m71_stock_transfer,
                pm71_pledge              => l_m71_pledge,
                pnarration               => 'Trading Account has been Closed - Account Closure',
                pnarration_lang          => 'Trading Account has been Closed - Account Closure',
                prestriction_source      => 5);
        /*sp_cash_acc_wise_restrict (
            pu06_id                  => l_u07_cash_account_id_u06,
            pm71_cash_transactions   => l_m71_cash_transactions,
            pm71_cash_transfer       => l_m71_cash_transfer,
            pnarration               => 'Trading Account has been Closed - Account Closure',
            pnarration_lang          => 'Trading Account has been Closed - Account Closure',
            prestriction_source      => 5);*/
        END IF;
    END IF;
END;
/