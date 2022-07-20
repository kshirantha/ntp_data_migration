CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t59_product_subscripton_log
(
    t59_id,
    t59_customer_id_u01,
    u01_customer_no,
    u01_display_name,
    u01_display_name_lang,
    u01_external_ref_no,
    t59_customer_login_u09,
    t59_product_id_m152,
    t59_no_of_months,
    t59_service_fee,
    t59_broker_fee,
    t59_vat_service_fee,
    t59_vat_broker_fee,
    t59_datetime,
    t59_prod_subscription_id_t56,
    m152_product_name,
    m152_product_name_lang,
    u09_login_name,
    u09_price_user_name,
    t59_institute_id_m02,
    t59_to_date
)
AS
    SELECT t59_id,
           t59_customer_id_u01,
           u01.u01_customer_no,
           u01.u01_display_name,
           u01.u01_display_name_lang,
           u01.u01_external_ref_no,
           t59_customer_login_u09,
           t59_product_id_m152,
           t59_no_of_months,
           t59_service_fee,
           t59_broker_fee,
           t59_vat_service_fee,
           t59_vat_broker_fee,
           t59_datetime,
           t59_prod_subscription_id_t56,
           v35_product_name AS m152_product_name,
           v35_product_name_lang AS m152_product_name_lang,
           u09_login_name,
           u09_price_user_name,
           t59_institute_id_m02,
           t59_to_date
      FROM t59_product_subscripti_log_all t59
           LEFT JOIN u01_customer u01
               ON t59.t59_customer_id_u01 = u01.u01_id
           LEFT JOIN m152_products m152
               ON t59.t59_product_id_m152 = m152_id
           JOIN v35_products v35
               ON m152_product_id_v35 = v35_id
           LEFT JOIN u09_customer_login u09
               ON t59.t59_customer_login_u09 = u09_id
/
