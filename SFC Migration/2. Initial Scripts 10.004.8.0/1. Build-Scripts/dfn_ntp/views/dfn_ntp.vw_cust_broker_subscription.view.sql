CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_cust_broker_subscription
(
    u01_id,
    u01_customer_no,
    u01_external_ref_no,
    u01_full_name,
    m07_name,
    m90_name,
    u09_login_name,
    u09_price_user_name,
    m152_product_id_v35,
    m152_product_code,
    m152_product_name,
    price_user_type,
    t56_product_id_m152,
    t56_from_date,
    t56_to_date,
    t56_status,
    status,
    t56_service_fee,
    t56_broker_fee,
    t56_datetime,
    t56_vat_service_fee,
    t56_vat_broker_fee,
    uniqueid,
    t56_id,
    t56_is_auto_subcription,
    is_auto_subcription,
    t56_is_subscribed,
    is_subscribed
)
AS
    SELECT u01.u01_id,
           u01.u01_customer_no,
           u01.u01_external_ref_no,
           u01.u01_full_name,
           m07.m07_name,
           m90.m90_name,
           u09.u09_login_name,
           u09.u09_price_user_name,
           m152_product_id_v35,
           v35.v35_product_code AS m152_product_code,
           v35.v35_product_name AS m152_product_name,
           CASE
               WHEN NVL (m158.m158_customer_type_v01, 0) = 1 THEN 'Private'
               ELSE 'Business'
           END
               AS price_user_type,
           t56.t56_product_id_m152,
           t56.t56_from_date,
           t56.t56_to_date,
           t56.t56_status,
           CASE
               WHEN t56.t56_status = 1 THEN 'Approved'
               WHEN t56.t56_status = 0 THEN 'Suspended'
           END
               AS status,
           t56.t56_service_fee,
           t56.t56_broker_fee,
           t56.t56_datetime,
           t56.t56_vat_service_fee,
           t56.t56_vat_broker_fee,
           t56.t56_product_id_m152 || '_' || t56.t56_customer_id_u01
               AS uniqueid,
           t56_id,
           t56_is_auto_subcription,
           CASE
               WHEN t56_is_auto_subcription = 1 THEN 'Yes'
               WHEN t56_is_auto_subcription = 0 THEN 'No'
           END
               AS is_auto_subcription,
           t56_is_subscribed,
           CASE
               WHEN t56_is_subscribed = 1 THEN 'Subscribed'
               WHEN t56_is_subscribed = 0 THEN 'Unsubscribed'
           END
               AS is_subscribed
      FROM t56_product_subscription_data t56
           LEFT JOIN u01_customer u01 ON t56.t56_customer_id_u01 = u01.u01_id
           LEFT JOIN u09_customer_login u09
               ON u09.u09_customer_id_u01 = u01.u01_id
           LEFT JOIN m152_products m152
               ON m152.m152_id = t56.t56_product_id_m152
           JOIN v35_products v35 ON m152_product_id_v35 = v35_id
           LEFT JOIN m158_priceuser_agreement m158
               ON m158.m158_customer_id_u01 = u01.u01_id
           LEFT JOIN m07_location m07
               ON m07.m07_id = u01.u01_signup_location_id_m07
           LEFT JOIN m90_region m90 ON m90.m90_id = m07.m07_region_id_m90
/