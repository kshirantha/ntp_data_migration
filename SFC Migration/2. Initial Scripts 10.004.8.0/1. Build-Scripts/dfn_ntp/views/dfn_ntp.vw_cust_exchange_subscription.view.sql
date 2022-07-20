CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_cust_exchange_subscription
(
    u01_id,
    u01_customer_no,
    u01_external_ref_no,
    u01_full_name,
    m07_name,
    m90_name,
    u09_login_name,
    u09_price_user_name,
    price_user_type,
    t57_from_date,
    t57_to_date,
    t57_datetime,
    t57_status,
    status,
    t57_exchange_fee,
    t57_vat_exchange_fee,
    t57_id
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
           CASE
               WHEN NVL (m158.m158_customer_type_v01, 0) = 1 THEN 'Private'
               ELSE 'Business'
           END
               AS price_user_type,
           t57.t57_from_date,
           t57.t57_to_date,
           t57.t57_datetime,
           t57.t57_status,
           CASE
               WHEN t57.t57_status = 1 THEN 'Approved'
               WHEN t57.t57_status = 0 THEN 'Suspended'
           END
               AS status,
           t57.t57_exchange_fee,
           t57.t57_vat_exchange_fee,
           t57.t57_id
      FROM t57_exchange_subscription_data t57
           LEFT JOIN u01_customer u01
               ON t57.t57_customer_id_u01 = u01.u01_id
           LEFT JOIN u09_customer_login u09
               ON u09.u09_id = t57.t57_customer_login_u09
           LEFT JOIN m158_priceuser_agreement m158
               ON m158.m158_customer_id_u01 = u01.u01_id
           LEFT JOIN m07_location m07
               ON m07.m07_id = u01.u01_signup_location_id_m07
           LEFT JOIN m90_region m90
               ON m90.m90_id = m07.m07_region_id_m90
/
