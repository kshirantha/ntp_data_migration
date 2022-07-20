CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_cust_cash_summary (
    p_view                     OUT SYS_REFCURSOR,
    prows                      OUT NUMBER,
    pcustomerid             IN     NUMBER,
    pcurrency               IN     VARCHAR2,
    puserid                        NUMBER DEFAULT NULL,
    p_user_filter_enabled          NUMBER DEFAULT 0)
IS
    status      NUMBER;
    l_qry       VARCHAR2 (15000);
    userfiler   NUMBER := NULL;
BEGIN
    status := 0;

    IF puserid IS NOT NULL AND p_user_filter_enabled <> 0
    THEN
        userfiler := 1;
    END IF;

    l_qry :=
           'SELECT u06.u06_currency_code_m03,
                       u06.u06_display_name,
                       u06.u06_blocked,
                       (u06.u06_balance + u06.u06_payable_blocked - u06.u06_receivable_amount)
                           AS balance,
                       NVL (
                             (  u06.u06_balance
                              + u06.u06_payable_blocked
                              - u06.u06_receivable_amount)
                           * NVL (m04.m04_rate, 1),
                           0)
                           AS balance_cur,
                       NVL (m04.m04_rate, 1) AS m04_rate
                  FROM vw_u06_cash_account_base u06
                       LEFT JOIN (SELECT *
                                    FROM m04_currency_rate
                                   WHERE m04_to_currency_code_m03 = '''
        || pcurrency
        || ''') m04
                           ON u06.u06_currency_code_m03 = m04.m04_from_currency_code_m03'
        || fn_get_cash_acc_filter (
               pcash_column            => 'u06_id',
               ptab_alies              => 'u06',
               puser_id                => puserid,
               p_user_filter_enabled   => p_user_filter_enabled)
        || ' WHERE u06_customer_id_u01 = '
        || pcustomerid;

    OPEN p_view FOR l_qry;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        status := -2;
    WHEN OTHERS
    THEN
        status := -3;
END;
/