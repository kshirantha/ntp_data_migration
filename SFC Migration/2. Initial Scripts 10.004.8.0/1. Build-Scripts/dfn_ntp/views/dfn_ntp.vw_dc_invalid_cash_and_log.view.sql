CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_dc_invalid_cash_and_log
(
    u06_customer_no_u01,
    u06_id,
    u06_display_name,
    u06_balance,
    u06_institute_id_m02,
    t02_cash_acnt_id_u06,
    cash_log_bal,
    diff
)
AS
    SELECT u06.u06_customer_no_u01,
           u06.u06_id,
           u06.u06_display_name,
           u06.u06_balance,
           u06.u06_institute_id_m02,
           t02.t02_cash_acnt_id_u06,
           t02.cash_log_bal,
           NVL (cash_log_bal, 0) - u06_balance AS diff
      FROM (SELECT a.u06_customer_no_u01,
                   a.u06_id,
                   a.u06_display_name,
                   a.u06_balance,
                   a.u06_institute_id_m02
              FROM dfn_ntp.u06_cash_account a) u06,
           (  SELECT t02_cash_acnt_id_u06,
                     SUM (b.t02_amnt_in_stl_currency) cash_log_bal
                FROM dfn_ntp.t02_transact_log_cash_arc_all b
            GROUP BY t02_cash_acnt_id_u06) t02
     WHERE     u06.u06_id = t02_cash_acnt_id_u06
           AND NVL (cash_log_bal, 0) - u06_balance <> 0
/
