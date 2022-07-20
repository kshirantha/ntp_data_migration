CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m141_cust_corporate_action
(
    m141_id,
    m141_template_id_m140,
    m141_description,
    m141_exchange_id_m01,
    m141_exchange_code_m01,
    m141_symbol_id_m20,
    m141_symbol_code_m20,
    m141_custodian_id_m26,
    m141_custodian_acc_id_m72,
    m141_coupon_date,
    m141_announcement_date,
    m141_ex_date,
    m141_record_date,
    m141_pay_date,
    m141_narration,
    m141_notify_on_announce_date,
    m141_notify_on_ex_date,
    m141_notify_on_record_date,
    m141_notify_on_pay_date,
    m141_no_of_payments,
    m141_created_by_id_u17,
    m141_created_date,
    m141_modified_by_id_u17,
    m141_modified_date,
    m141_status_id_v01,
    m141_status_changed_by_id_u17,
    m141_status_changed_date,
    m141_external_ref,
    m141_institute_id_m02,
    corp_act_temp_desc,
    corp_act_temp_desc_lang,
    symbol_short_desc,
    symbol_short_desc_lang,
    custodian_name,
    custodian_acc_no,
    notify_on_anounce_date,
    notify_on_ex_date,
    notify_on_record_date,
    notify_on_pay_date,
    status,
    status_lang,
    created_by_full_name,
    modified_by_full_name,
    status_changed_by_full_name,
    m20_isincode,
    m20_instrument_type_code_v09,
    v09_description,
    last_trade_price,
    m20_currency_code_m03,
    m140_nostro_account_req,
    m140_hold_adjustment_req,
    m140_hold_payment_req,
    m140_cash_adjustment_req,
    m140_hold_adj_ratio_req,
    m140_hold_adj_par_val_req
)
AS
    SELECT m141.m141_id,
           m141.m141_template_id_m140,
           m141.m141_description,
           m141.m141_exchange_id_m01,
           m141.m141_exchange_code_m01,
           m141.m141_symbol_id_m20,
           m141.m141_symbol_code_m20,
           m141.m141_custodian_id_m26,
           m141.m141_custodian_acc_id_m72,
           m141.m141_coupon_date,
           m141.m141_announcement_date,
           m141.m141_ex_date,
           m141.m141_record_date,
           m141.m141_pay_date,
           m141.m141_narration,
           m141.m141_notify_on_announce_date,
           m141.m141_notify_on_ex_date,
           m141.m141_notify_on_record_date,
           m141.m141_notify_on_pay_date,
           m141.m141_no_of_payments,
           m141.m141_created_by_id_u17,
           m141.m141_created_date,
           m141.m141_modified_by_id_u17,
           m141.m141_modified_date,
           m141.m141_status_id_v01,
           m141.m141_status_changed_by_id_u17,
           m141.m141_status_changed_date,
           m141.m141_external_ref,
           m141.m141_institute_id_m02,
           m140.m140_description AS corp_act_temp_desc,
           m140.m140_description_lang AS corp_act_temp_desc_lang,
           m20.m20_short_description AS symbol_short_desc,
           m20.m20_short_description_lang AS symbol_short_desc_lang,
           m26.m26_name AS custodian_name,
           m72.m72_accountno AS custodian_acc_no,
           CASE m141.m141_notify_on_announce_date
               WHEN 0 THEN 'No'
               WHEN 1 THEN 'Yes'
           END
               AS notify_on_anounce_date,
           CASE m141.m141_notify_on_ex_date
               WHEN 0 THEN 'No'
               WHEN 1 THEN 'Yes'
           END
               AS notify_on_ex_date,
           CASE m141.m141_notify_on_record_date
               WHEN 0 THEN 'No'
               WHEN 1 THEN 'Yes'
           END
               AS notify_on_record_date,
           CASE m141.m141_notify_on_pay_date
               WHEN 0 THEN 'No'
               WHEN 1 THEN 'Yes'
           END
               AS notify_on_pay_date,
           status_list.v01_description AS status,
           status_list.v01_description_lang AS status_lang,
           u17_created_by.u17_full_name AS created_by_full_name,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           m20.m20_isincode,
           m20.m20_instrument_type_code_v09,
           v09.v09_description,
           m20.m20_lasttradeprice AS last_trade_price,
           m20.m20_currency_code_m03,
           m140.m140_nostro_account_req,
           m140.m140_hold_adjustment_req,
           m140.m140_hold_payment_req,
           m140.m140_cash_adjustment_req,
           m140.m140_hold_adj_ratio_req,
           m140.m140_hold_adj_par_val_req
      FROM m141_cust_corporate_action m141
           JOIN m140_corp_action_templates m140
               ON m141.m141_template_id_m140 = m140.m140_id
           JOIN m20_symbol m20 ON m141.m141_symbol_id_m20 = m20.m20_id
           JOIN v09_instrument_types v09
               ON m20.m20_instrument_type_code_v09 = v09.v09_code
           JOIN m26_executing_broker m26
               ON m141.m141_custodian_id_m26 = m26.m26_id
           LEFT JOIN m72_exec_broker_cash_account m72
               ON m141.m141_custodian_acc_id_m72 = m72.m72_id
           JOIN vw_status_list status_list
               ON m141.m141_status_id_v01 = status_list.v01_id
           JOIN u17_employee u17_created_by
               ON m141.m141_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m141.m141_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN u17_employee u17_status_changed_by
               ON m141.m141_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
/