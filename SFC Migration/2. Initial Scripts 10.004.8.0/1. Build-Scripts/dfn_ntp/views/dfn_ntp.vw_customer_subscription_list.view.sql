CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_customer_subscription_list
(
    u01_id,
    u01_customer_no,
    u01_display_name,
    u09_login_name,
    t56_product_id_m152,
    m152_product_code,
    m152_product_name,
    t56_from_date,
    t56_to_date,
    t56_status,
    status,
    u09_price_user_name,
    u01_external_ref_no,
    t60_vat_exchange_fee,
    t59_vat_service_fee,
    t59_vat_broker_fee,
    t60_exchange_fee,
    t59_service_fee,
    t59_broker_fee,
    u01_institute_id_m02
)
AS
      SELECT u01.u01_id,
             u01.u01_customer_no,
             u01.u01_display_name,
             u09.u09_login_name,
             t56.t56_product_id_m152,
             v35.v35_product_code AS m152_product_code,
             v35.v35_product_name AS m152_product_name,
             t56.t56_from_date,
             t56.t56_to_date,
             t56.t56_status,
             CASE
                 WHEN t56_status = 1 THEN 'Approved'
                 WHEN t56_status = 0 THEN 'Suspended'
             END
                 AS status,
             u09.u09_price_user_name,
             u01.u01_external_ref_no,
             t60.t60_vat_exchange_fee,
             t59.t59_vat_service_fee,
             t59.t59_vat_broker_fee,
             t60.t60_exchange_fee,
             t59.t59_service_fee,
             t59.t59_broker_fee,
             u01.u01_institute_id_m02

        FROM u01_customer u01
             JOIN t56_product_subscription_data t56
                 ON u01.u01_id = t56.t56_customer_id_u01
             JOIN t57_exchange_subscription_data t57
                 ON u01.u01_id = t57.t57_customer_id_u01
             JOIN t59_product_subscription_log t59
             ON t56.t56_id = t59.t59_prod_subscription_id_t56
             JOIN u09_customer_login u09
                 ON u01.u01_id = u09.u09_customer_id_u01
             JOIN m152_products m152
                 ON t56.t56_product_id_m152 = m152.m152_id
             JOIN v35_products v35
                 ON m152_product_id_v35 = v35_id
             JOIN t60_exchange_subscription_log t60
                 ON t57.t57_id = t60.t60_exg_subscription_id_t57
    ORDER BY u01.u01_id, t56.t56_product_id_m152
/
