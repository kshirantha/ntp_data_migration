CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m140_corp_action_templates
(
    m140_id,
    m140_description,
    m140_description_lang,
    m140_institute_id_m02,
    m140_created_by_id_u17,
    m140_created_date,
    m140_modified_by_id_u17,
    m140_modified_date,
    m140_status_id_v01,
    m140_status_changed_by_id_u17,
    m140_status_changed_date,
    m140_nostro_account_req,
    m140_coupon_date_req,
    m140_notification_pref_req,
    m140_charge_req,
    m140_charge_amount,
    m140_tax_percentage,
    m140_charge_currency_code_m03,
    m140_charge_currency_id_m03,
    m140_hold_adjustment_req,
    m140_hold_adj_ratio_req,
    m140_hold_adj_par_val_req,
    m140_hold_payment_req,
    m140_hold_pay_no_of_payments,
    m140_cash_adjustment_req,
    m140_cash_adj_type,
    m140_hold_adj_type,
    m140_reinvest_t41,
    m140_amount_type,
    m140_pre_defined,
    status,
    status_lang,
    created_by_full_name,
    modified_by_full_name,
    status_changed_by_full_name,
    nostro_account_req,
    coupon_date_req,
    notification_pref_req,
    charge_req,
    hold_adjustment_req,
    hold_adj_ratio_req,
    hold_adj_par_val_req,
    hold_payment_req,
    cash_adjustment_req,
    cash_adj_type,
    amount_type,
    pre_defined
)
AS
    SELECT m140.m140_id,
           m140.m140_description,
           m140.m140_description_lang,
           m140.m140_institute_id_m02,
           m140.m140_created_by_id_u17,
           m140.m140_created_date,
           m140.m140_modified_by_id_u17,
           m140.m140_modified_date,
           m140.m140_status_id_v01,
           m140.m140_status_changed_by_id_u17,
           m140.m140_status_changed_date,
           m140.m140_nostro_account_req,
           m140.m140_coupon_date_req,
           m140.m140_notification_pref_req,
           m140.m140_charge_req,
           m140.m140_charge_amount,
           m140.m140_tax_percentage,
           m140.m140_charge_currency_code_m03,
           m140.m140_charge_currency_id_m03,
           m140.m140_hold_adjustment_req,
           m140.m140_hold_adj_ratio_req,
           m140.m140_hold_adj_par_val_req,
           m140.m140_hold_payment_req,
           m140.m140_hold_pay_no_of_payments,
           m140.m140_cash_adjustment_req,
           m140.m140_cash_adj_type,
           m140.m140_hold_adj_type,
           m140.m140_reinvest_t41,
           m140.m140_amount_type,
           m140.m140_pre_defined,
           status_list.v01_description AS status,
           status_list.v01_description_lang AS status_lang,
           u17_created_by.u17_full_name AS created_by_full_name,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           CASE m140.m140_nostro_account_req
               WHEN 0 THEN 'No'
               WHEN 1 THEN 'Yes'
           END
               AS nostro_account_req,
           CASE m140.m140_coupon_date_req
               WHEN 0 THEN 'No'
               WHEN 1 THEN 'Yes'
           END
               AS coupon_date_req,
           CASE m140.m140_notification_pref_req
               WHEN 0 THEN 'No'
               WHEN 1 THEN 'Yes'
           END
               AS notification_pref_req,
           CASE m140.m140_charge_req WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
               AS charge_req,
           CASE m140.m140_hold_adjustment_req
               WHEN 0 THEN 'No'
               WHEN 1 THEN 'Yes'
           END
               AS hold_adjustment_req,
           CASE m140.m140_hold_adj_ratio_req
               WHEN 0 THEN 'No'
               WHEN 1 THEN 'Yes'
           END
               AS hold_adj_ratio_req,
           CASE m140.m140_hold_adj_par_val_req
               WHEN 0 THEN 'No'
               WHEN 1 THEN 'Yes'
           END
               AS hold_adj_par_val_req,
           CASE m140.m140_hold_payment_req
               WHEN 0 THEN 'No'
               WHEN 1 THEN 'Yes'
           END
               AS hold_payment_req,
           CASE m140.m140_cash_adjustment_req
               WHEN 0 THEN 'No'
               WHEN 1 THEN 'Yes'
           END
               AS cash_adjustment_req,
           CASE m140.m140_cash_adj_type
               WHEN 1 THEN 'Pay'
               WHEN 2 THEN 'Deduct'
           END
               AS cash_adj_type,
           CASE m140.m140_amount_type
               WHEN 1 THEN 'Amount'
               WHEN 2 THEN 'Percentage'
           END
               AS amount_type,
           CASE m140.m140_pre_defined WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
               AS pre_defined
      FROM m140_corp_action_templates m140
           JOIN vw_status_list status_list
               ON m140.m140_status_id_v01 = status_list.v01_id
           JOIN u17_employee u17_created_by
               ON m140.m140_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m140.m140_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN u17_employee u17_status_changed_by
               ON m140.m140_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id;
/