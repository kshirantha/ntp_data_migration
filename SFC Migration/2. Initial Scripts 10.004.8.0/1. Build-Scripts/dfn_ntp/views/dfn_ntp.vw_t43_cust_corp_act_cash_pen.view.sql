CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t43_cust_corp_act_cash_pen
(
   t43_id,
   t43_cust_corp_act_id_m141,
   t43_cust_distr_id_t41,
   t43_corp_act_adj_id_m143,
   t43_cash_account_id_u06,
   t43_adj_mode,
   t43_amnt_in_txn_currency,
   t43_fx_rate,
   t43_amnt_in_stl_currency,
   t43_tax_amount,
   t43_status_id_v01,
   t43_status_changed_by_id_u17,
   t43_status_changed_date,
   t43_narration,
   u06_display_name,
   t43_created_date,
   t43_created_by_id_u17,
   cash_type,
   cash_adj_type,
   status,
   status_lang,
   new_amnt_in_stl_currency,
   new_amnt_in_txn_currency,
   new_fx_rate
)
AS
   ( (SELECT t43.t43_id,
             t43.t43_cust_corp_act_id_m141,
             t43.t43_cust_distr_id_t41,
             t43.t43_corp_act_adj_id_m143,
             t43.t43_cash_account_id_u06,
             t43.t43_adj_mode,
             t43.t43_amnt_in_txn_currency,
             t43.t43_fx_rate,
             t43.t43_amnt_in_stl_currency,
             t43.t43_tax_amount,
             t43.t43_status_id_v01,
             t43.t43_status_changed_by_id_u17,
             t43.t43_status_changed_date,
             t43.t43_narration,
             u06.u06_display_name,
             t43.t43_created_date,
             t43.t43_created_by_id_u17,
             CASE m143.m143_type
                WHEN 1 THEN 'Charge'
                WHEN 2 THEN 'Cash Adjustment'
             END
                AS cash_type,
             CASE m143.m143_adj_mode
                WHEN 1 THEN 'Pay'
                WHEN 2 THEN 'Deduct'
             END
                AS cash_adj_type,
             status_list.v01_description AS status,
             status_list.v01_description_lang AS status_lang,
             t45.t45_amnt_in_stl_currency_t43 AS new_amnt_in_stl_currency,
             t45.t45_amnt_in_txn_currency_t43 AS new_amnt_in_txn_currency,
             t45.t45_fx_rate_t43 AS new_fx_rate
        FROM t43_cust_corp_act_cash_adjust t43
             JOIN u06_cash_account u06
                ON t43.t43_cash_account_id_u06 = u06.u06_id
             JOIN m143_corp_act_cash_adjustments m143
                ON t43.t43_corp_act_adj_id_m143 = m143.m143_id
             JOIN vw_status_list status_list
                ON t43.t43_status_id_v01 = status_list.v01_id
             JOIN t45_pending_ca_cash_adjustment t45
                ON     t43.t43_cust_distr_id_t41 = t45.t45_id_t41
                   AND t45.t45_is_approved = 0
                   AND t43.t43_corp_act_adj_id_m143 = t45.t45_id_m143))
/