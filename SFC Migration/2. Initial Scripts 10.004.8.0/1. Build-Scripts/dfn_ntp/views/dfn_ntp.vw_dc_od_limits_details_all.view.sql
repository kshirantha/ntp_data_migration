CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_dc_od_limits_details_all
(
    u06_institute_id_m02,
    u06_customer_id_u01,
    u06_customer_no_u01,
    u06_display_name_u01,
    u06_display_name,
    u06_currency_code_m03,
    u06_balance,
    u06_blocked,
    u06_primary_od_limit,
    utilization,
    is_risky
)
AS
    SELECT b.u06_institute_id_m02,
           b.u06_customer_id_u01,
           b.u06_customer_no_u01,
           b.u06_display_name_u01,
           b.u06_display_name,
           b.u06_currency_code_m03,
           b.u06_balance + b.u06_payable_blocked - b.u06_receivable_amount
               AS u06_balance,
           b.u06_blocked,
           a.u06_primary_od_limit,
           (a.utilization * 100) AS utilization,
           CASE WHEN a.utilization > .6 THEN 'YES' ELSE 'NO' END AS is_risky
      FROM vw_trading_limit_utilized a, u06_cash_account b
     WHERE a.u06_id = b.u06_id
/