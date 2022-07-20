CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_cash_acc_filter (
    pcash_column            IN VARCHAR2,
    ptab_alies              IN VARCHAR2 DEFAULT NULL,
    p_user_filter_enabled   IN NUMBER DEFAULT 0,
    puser_id                IN u17_employee.u17_id%TYPE)
    RETURN VARCHAR2
IS
    l_qry   VARCHAR2 (15000);
BEGIN
    IF p_user_filter_enabled != 1 OR puser_id IS NULL
    THEN
    RETURN '';
    END IF;

    l_qry :=
           ' JOIN (  SELECT u07_cash_account_id_u06
                 FROM (SELECT u07.u07_cash_account_id_u06
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
                       SELECT u43_cash_account_id_u06 AS u07_cash_account_id_u06
                         FROM     dfn_ntp.u43_user_cash_accounts u43
                        WHERE u43.u43_user_id_u17 = '
                   || puser_id
               ELSE
                   ' '
           END
        || CASE
               WHEN fn_filter_unasgnd_cash_acc () = 1
               THEN
                   ' UNION ALL
                   SELECT u06_id AS u07_cash_account_id_u06
                      FROM u06_cash_account
                     WHERE u06_is_unasgnd_account = 1'
               ELSE
                   ' '
           END
        || ' )
                        GROUP BY u07_cash_account_id_u06) u071
                            ON '
        || CASE
               WHEN ptab_alies IS NOT NULL THEN ptab_alies || '.'
               ELSE ''
           END
        || pcash_column
        || ' = u071.u07_cash_account_id_u06 ';

    RETURN l_qry;
END;
/
