CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t41_ca_cust_distribution
(
   t41_id,
   u01_customer_no,
   u01_display_name,
   u01_display_name_lang,
   t41_cust_corp_act_id_m141,
   t41_trading_acc_id_u07,
   u07_display_name,
   t41_status_id_v01,
   status,
   v01_description_lang,
   t41_status_changed_by_id_u17,
   status_changed_by,
   t41_status_changed_date,
   t41_hold_on_rec_date,
   t41_avg_cost_on_ex_date,
   t41_is_notified,
   notified,
   t41_reinvest,
   reinvest,
   t41_customer_id_u01,
   t41_cash_acc_id_u06,
   u06_display_name,
   t41_created_by_id_u17,
   created_by,
   t41_created_date,
   t41_modified_by_id_u17,
   modified_by,
   t41_modified_date,
   t41_pending_adjustment,
   t41_institute_id_m02
)
AS
   SELECT t41_id,
          u01.u01_customer_no,
          u01.u01_display_name,
          u01.u01_display_name_lang,
          t41_cust_corp_act_id_m141,
          t41_trading_acc_id_u07,
          u07.u07_display_name,
          t41_status_id_v01,
          v01.v01_description AS status,
          v01.v01_description_lang,
          t41_status_changed_by_id_u17,
          u17c.u17_full_name AS status_changed_by,
          t41_status_changed_date,
          t41_hold_on_rec_date,
          t41_avg_cost_on_ex_date,
          t41_is_notified,
          CASE t41.t41_is_notified WHEN 1 THEN 'Yes' ELSE 'No' END
             AS notified,
          t41_reinvest,
          CASE t41.t41_reinvest WHEN 1 THEN 'Yes' ELSE 'No' END AS reinvest,
          t41_customer_id_u01,
          t41_cash_acc_id_u06,
          u06.u06_display_name,
          t41_created_by_id_u17,
          u17a.u17_full_name AS created_by,
          t41_created_date,
          t41_modified_by_id_u17,
          u17b.u17_full_name AS modified_by,
          t41_modified_date,
          t41.t41_pending_adjustment,
          t41.t41_institute_id_m02
     FROM t41_cust_corp_act_distribution t41
          INNER JOIN u01_customer u01 ON t41.t41_customer_id_u01 = u01.u01_id
          INNER JOIN vw_status_list v01 ON t41.t41_status_id_v01 = v01_id
          INNER JOIN u06_cash_account u06
             ON t41.t41_cash_acc_id_u06 = u06.u06_id
          INNER JOIN u07_trading_account u07
             ON t41.t41_trading_acc_id_u07 = u07.u07_id
          INNER JOIN u17_employee u17a
             ON t41.t41_created_by_id_u17 = u17a.u17_id
          LEFT OUTER JOIN u17_employee u17b
             ON t41.t41_modified_by_id_u17 = u17b.u17_id
          LEFT OUTER JOIN u17_employee u17c
             ON t41.t41_status_changed_by_id_u17 = u17c.u17_id
/