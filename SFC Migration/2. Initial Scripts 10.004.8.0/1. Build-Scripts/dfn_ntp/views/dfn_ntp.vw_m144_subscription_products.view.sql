CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m144_subscription_products
(
    m144_id,
    m144_product_id_v35,
    m144_product_name,
    m144_product_name_lang,
    m144_retry_month,
    m144_status_id_v01,
    m144_rank,
    m144_premium_product,
    m144_price_product_code,
    v35_product_name,
    v35_product_name_lang
)
AS
    SELECT m144.m144_id,
           TO_NUMBER (m144.m144_product_id_v35) AS m144_product_id_v35,
           m144.m144_product_name,
           m144.m144_product_name_lang,
           m144.m144_retry_month,
           m144.m144_status_id_v01,
           m144.m144_rank,
           m144.m144_premium_product,
           m144.m144_price_product_code,
           v35.v35_product_name,
           v35.v35_product_name_lang
      FROM m144_subscription_products m144
           JOIN v35_products v35 ON m144.m144_product_id_v35 = v35.v35_id
/