CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_od_limit_accounts (
    p_view                OUT SYS_REFCURSOR,
    prows                 OUT NUMBER,
    pcustomer_id_u01   IN     NUMBER,
    pinstitute         IN     NUMBER)
IS
BEGIN
    OPEN p_view FOR
        SELECT   b.u06_customer_id_u01,
                 b.u06_customer_no_u01,
                 b.u06_display_name_u01,
                 b.u06_display_name,
                 b.u06_currency_code_m03,
                   b.u06_balance
                 + b.u06_payable_blocked
                 - b.u06_receivable_amount
                     AS u06_balance,
                 b.u06_blocked,
                 a.u06_primary_od_limit AS od_limit,
                 a.u06_primary_od_limit,
                 a.u06_secondary_od_limit,
                 (a.utilization * 100) AS utilization,
                 CASE WHEN a.utilization > .6 THEN 'YES' ELSE 'NO' END
                     AS is_risky
            FROM vw_trading_limit_utilized a, u06_cash_account b
           WHERE     a.u06_id = b.u06_id
                 AND a.u06_customer_id_u01 = pcustomer_id_u01
                 AND b.u06_institute_id_m02 = pinstitute
        ORDER BY utilization DESC;
END;
/