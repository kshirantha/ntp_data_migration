CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t73_om_margin_requests_list
(
    t73_id,
    t73_cash_account_id_u06,
    t73_customer_id_u01,
    u01_customer_no,
    u01_external_ref_no,
    u06_display_name,
    t73_margin_product_id_m73,
    margin_product,
    t73_max_margin_limit,
    t73_currency_code_m03,
    t73_margin_expiry_date,
    t73_margin_percentage,
    t73_required_margin,
    t73_tenor,
    t73_margin_profit,
    t73_no_of_approval,
    t73_is_approval_completed,
    t73_current_approval_level,
    t73_next_status,
    t73_created_date,
    t73_status_changed_date,
    t73_status_id_v01,
    v01_description,
    v01_description_lang,
    t73_status_changed_by_id_u17,
    t73_institute_id_m02,
    t73_murahaba_basket_id_m181,
    created_by,
    status_changed_by,
    m73_risk_approval_limit,
    m73_margin_category_id_v01
)
AS
    SELECT t73.t73_id,
           t73.t73_cash_account_id_u06,
           t73.t73_customer_id_u01,
           u01.u01_customer_no,
           u01.u01_external_ref_no,
           u06.u06_display_name,
           t73.t73_margin_product_id_m73,
           m73.m73_name AS margin_product,
           t73.t73_max_margin_limit,
           t73.t73_currency_code_m03,
           t73.t73_margin_expiry_date,
           t73.t73_margin_percentage,
           t73.t73_required_margin,
           t73.t73_tenor,
           t73.t73_margin_profit,
           t73.t73_no_of_approval,
           t73.t73_is_approval_completed,
           t73.t73_current_approval_level,
           t73.t73_next_status,
           t73.t73_created_date,
           t73.t73_status_changed_date,
           t73.t73_status_id_v01,
           status_list.v01_description,
           status_list.v01_description_lang,
           t73.t73_status_changed_by_id_u17,
           t73.t73_institute_id_m02,
           t73.t73_murahaba_basket_id_m181,
           u17_create.u17_full_name AS created_by,
           u17_update.u17_full_name AS status_changed_by,
           m73.m73_risk_approval_limit,
           m73.m73_margin_category_id_v01
      FROM t73_om_margin_trading_request t73
           JOIN u01_customer u01
               ON t73.t73_customer_id_u01 = u01.u01_id
           JOIN u06_cash_account u06
               ON t73.t73_cash_account_id_u06 = u06.u06_id
           JOIN m73_margin_products m73
               ON t73.t73_margin_product_id_m73 = m73_id
           LEFT JOIN u17_employee u17_create
               ON t73.t73_created_by_id_u17 = u17_create.u17_id
           LEFT JOIN u17_employee u17_update
               ON t73.t73_status_changed_by_id_u17 = u17_update.u17_id
           LEFT JOIN vw_status_list status_list
               ON t73.t73_status_id_v01 = status_list.v01_id
     WHERE t73.t73_institute_id_m02 = u01.u01_institute_id_m02
/
