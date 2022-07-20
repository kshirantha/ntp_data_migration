CREATE OR REPLACE PROCEDURE dfn_ntp.sp_coporate_act_hold_adjst (
    p_view         OUT SYS_REFCURSOR,
    prows          OUT NUMBER,
    pm141_id           NUMBER,
    pinstitution       NUMBER)
IS
    lcount    NUMBER;
    lformat   VARCHAR (100);
BEGIN
    OPEN p_view FOR
        SELECT t42.t42_id,
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
               CASE m142.m142_adj_mode
                   WHEN 1 THEN 'Pay'
                   WHEN 2 THEN 'Deduct'
               END
                   AS hold_adj_type,
               status_list.v01_description AS status,
               status_list.v01_description_lang AS status_lang,
               u07.u07_display_name
          FROM t42_cust_corp_act_hold_adjust t42
               JOIN m142_corp_act_hold_adjustments m142
                   ON t42.t42_corp_act_adj_id_m142 = m142.m142_id
               JOIN u07_trading_account u07
                   ON t42.t42_trading_acc_id_u07 = u07.u07_id
               JOIN vw_status_list status_list
                   ON t42.t42_status_id_v01 = status_list.v01_id
         WHERE     t42.t42_cust_corp_act_id_m141 = pm141_id
               AND t42.t42_institute_id_m02 = pinstitution;
END;
/