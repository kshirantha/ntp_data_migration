CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t42_cust_corp_act_hold_pen
(
   t42_id,
   t42_cust_corp_act_id_m141,
   t42_cust_distr_id_t41,
   t42_corp_act_adj_id_m142,
   t42_trading_acc_id_u07,
   t42_adj_mode,
   t42_exchange_id_m01,
   t42_exchange_code_m01,
   t42_symbol_id_m20,
   t42_symbol_code_m20,
   t42_from_ratio,
   t42_to_ratio,
   ratio,
   t42_eligible_quantity,
   t42_approved_quantity,
   t42_avg_cost,
   t42_narration,
   t42_status_id_v01,
   t42_status_changed_by_id_u17,
   t42_status_changed_date,
   t42_custodian_id_m26,
   t42_created_by_id_u17,
   t42_created_date,
   hold_adj_type,
   status,
   status_lang,
   u07_display_name,
   new_approved_quantity,
   new_avg_cost,
   new_eligible_quantity
)
AS
   (SELECT t42.t42_id,
           t42.t42_cust_corp_act_id_m141,
           t42.t42_cust_distr_id_t41,
           t42.t42_corp_act_adj_id_m142,
           t42.t42_trading_acc_id_u07,
           t42.t42_adj_mode,
           t42.t42_exchange_id_m01,
           t42.t42_exchange_code_m01,
           t42.t42_symbol_id_m20,
           t42.t42_symbol_code_m20,
           t42.t42_from_ratio,
           t42.t42_to_ratio,
           t42.t42_from_ratio || ':' || t42.t42_to_ratio AS ratio,
           t42.t42_eligible_quantity,
           t42.t42_approved_quantity,
           t42.t42_avg_cost,
           t42.t42_narration,
           t42.t42_status_id_v01,
           t42.t42_status_changed_by_id_u17,
           t42.t42_status_changed_date,
           t42.t42_custodian_id_m26,
           t42.t42_created_by_id_u17,
           t42.t42_created_date,
           CASE m142.m142_adj_mode WHEN 1 THEN 'Pay' WHEN 2 THEN 'Deduct' END
              AS hold_adj_type,
           status_list.v01_description AS status,
           status_list.v01_description_lang AS status_lang,
           u07.u07_display_name,
           t46.t46_approved_quantity_t42 AS new_approved_quantity,
           t46.t46_avg_cost_t42 AS new_avg_cost,
           t46.t46_eligible_quantity_t42 AS new_eligible_quantity
      FROM t42_cust_corp_act_hold_adjust t42
           JOIN m142_corp_act_hold_adjustments m142
              ON t42.t42_corp_act_adj_id_m142 = m142.m142_id
           JOIN u07_trading_account u07
              ON t42.t42_trading_acc_id_u07 = u07.u07_id
           JOIN vw_status_list status_list
              ON t42.t42_status_id_v01 = status_list.v01_id
           JOIN t46_pending_ca_hold_adjustment t46
              ON     t42.t42_cust_distr_id_t41 = t46.t46_id_t41
                 AND t46.t46_is_approved = 0
                 AND t42.t42_corp_act_adj_id_m142 = t46.t46_id_m142)
/