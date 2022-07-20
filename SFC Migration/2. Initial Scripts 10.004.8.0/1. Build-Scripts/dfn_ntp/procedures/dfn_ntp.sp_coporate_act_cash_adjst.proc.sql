CREATE OR REPLACE PROCEDURE dfn_ntp.sp_coporate_act_cash_adjst (
    p_view         OUT SYS_REFCURSOR,
    prows          OUT NUMBER,
    pm141_id           NUMBER,
    pinstitution       NUMBER)
IS
    lcount    NUMBER;
    lformat   VARCHAR (100);
BEGIN
    OPEN p_view FOR
        SELECT t43.t43_id,
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
               status_list.v01_description_lang AS status_lang
          FROM t43_cust_corp_act_cash_adjust t43
               JOIN u06_cash_account u06
                   ON t43.t43_cash_account_id_u06 = u06.u06_id
               JOIN m143_corp_act_cash_adjustments m143
                   ON t43.t43_corp_act_adj_id_m143 = m143.m143_id
               JOIN vw_status_list status_list
                   ON t43.t43_status_id_v01 = status_list.v01_id
         WHERE     t43.t43_cust_corp_act_id_m141 = pm141_id
               AND t43.t43_institute_id_m02 = pinstitution;
END;
/
