CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_customer_filter (
    pcust_column            IN VARCHAR2,
    ptab_alies              IN VARCHAR2 DEFAULT NULL,
    puser_id                IN u17_employee.u17_id%TYPE,
    p_user_filter_enabled   IN NUMBER DEFAULT 0)
    RETURN VARCHAR2
IS
    l_qry   VARCHAR2 (15000);
BEGIN
    IF p_user_filter_enabled != 1 OR puser_id IS NULL
    THEN
        RETURN '';
    END IF;

    l_qry :=
           ' JOIN (  SELECT u07_customer_id_u01
                 FROM (SELECT u07.u07_customer_id_u01
                         FROM     dfn_ntp.m51_employee_trading_groups m51
                              JOIN
                                  dfn_ntp.u07_trading_account u07
                              ON m51.m51_trading_group_id_m08 =
                                     u07.u07_trading_group_id_m08
                        WHERE m51_employee_id_u17 = '
        || puser_id
        || CASE
               WHEN dfn_ntp.fn_get_cash_user_filter_apply () = 1
               THEN
                      ' UNION ALL
                       SELECT u06_customer_id_u01 AS u07_customer_id_u01
                         FROM     dfn_ntp.u43_user_cash_accounts u43
                              JOIN
                                  dfn_ntp.u06_cash_account u06
                              ON u43.u43_cash_account_id_u06 = u06.u06_id
                        WHERE u43.u43_user_id_u17 = '
                   || puser_id
               ELSE
                   ' '
           END
        || CASE
               WHEN fn_filter_unasgnd_cash_acc () = 1
               THEN
                   ' UNION ALL
                   SELECT u06_customer_id_u01 AS u07_customer_id_u01
                      FROM u06_cash_account
                     WHERE u06_is_unasgnd_account = 1'
               ELSE
                   ' '
           END
        || ' )
                        GROUP BY u07_customer_id_u01) u071
                            ON '
        || CASE
               WHEN ptab_alies IS NOT NULL THEN ptab_alies || '.'
               ELSE ''
           END
        || pcust_column
        || ' = u071.u07_customer_id_u01 ';

    RETURN l_qry;
END;
/
