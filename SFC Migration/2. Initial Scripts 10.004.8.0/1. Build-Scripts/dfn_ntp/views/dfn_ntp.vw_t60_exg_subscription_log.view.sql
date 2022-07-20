CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t60_exg_subscription_log
(
    t60_id,
    t60_customer_id_u01,
    u01_customer_no,
    u01_display_name,
    u01_display_name_lang,
    u01_external_ref_no,
    t60_customer_login_u09,
    t60_exchange_product_id_m153,
    t60_no_of_months,
    t60_exchange_fee,
    t60_vat_exchange_fee,
    t60_datetime,
    t60_exg_subscription_id_t57,
    m153_exchange_id_m01,
    m153_exchange_code_m01,
    m153_currency_code_m03,
    u09_login_name,
    u09_price_user_name,
    t60_institute_id_m02

)
AS
    SELECT t60_id,
           t60_customer_id_u01,
           u01_customer_no,
           u01_display_name,
           u01_display_name_lang,
           u01_external_ref_no,
           t60_customer_login_u09,
           t60_exchange_product_id_m153,
           t60_no_of_months,
           t60_exchange_fee,
           t60_vat_exchange_fee,
           t60_datetime,
           t60_exg_subscription_id_t57,
           m153_exchange_id_m01,
           m153_exchange_code_m01,
           m153_currency_code_m03,
           u09_login_name,
           u09_price_user_name,
           t60_institute_id_m02
      FROM t60_exchange_subscription_log t60
           LEFT JOIN u01_customer u01
               ON t60.t60_customer_id_u01 = u01.u01_id
           LEFT JOIN m153_exchange_subscription_prd m153
               ON t60.t60_exchange_product_id_m153 = m153_id
           LEFT JOIN u09_customer_login u09
               ON t60.t60_customer_login_u09 = u09_id
/
