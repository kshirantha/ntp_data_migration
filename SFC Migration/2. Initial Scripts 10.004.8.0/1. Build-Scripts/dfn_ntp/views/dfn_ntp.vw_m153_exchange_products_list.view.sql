CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m153_exchange_products_list
(
    m153_id,
    m153_exchange_id_m01,
    m153_exchange_code_m01,
    m153_institution_id_m02,
    m153_customer_type,
    customer_type,
    m153_is_active,
    is_active,
    m153_duration,
    m153_premium_product,
    premium_product,
    m153_exchange_fee,
    m153_vat_pct,
    m153_currency_code_m03,
    m153_currency_id_m03,
    m153_created_date,
    m153_created_by_id_u17,
    m153_modified_date,
    m153_modified_by_id_u17,
    m153_custom_type,
    created_by,
    modified_by
)
AS
    SELECT a.m153_id,
           a.m153_exchange_id_m01,
           a.m153_exchange_code_m01,
           a.m153_institution_id_m02,
           a.m153_customer_type,
           CASE
               WHEN a.m153_customer_type = 0 THEN 'Business'
               ELSE 'Private'
           END
               AS customer_type,
           a.m153_is_active,
           CASE WHEN a.m153_is_active = 1 THEN 'Yes' ELSE 'No' END
               AS is_active,
           a.m153_duration,
           a.m153_premium_product,
           CASE WHEN a.m153_premium_product = 1 THEN 'Yes' ELSE 'No' END
               AS premium_product,
           a.m153_exchange_fee,
           a.m153_vat_pct,
           a.m153_currency_code_m03,
           a.m153_currency_id_m03,
           a.m153_created_date,
           a.m153_created_by_id_u17,
           a.m153_modified_date,
           a.m153_modified_by_id_u17,
           a.m153_custom_type,
           u17.u17_full_name created_by,
           u17e.u17_full_name modified_by
      FROM m153_exchange_subscription_prd a
           JOIN u17_employee u17 ON a.m153_created_by_id_u17 = u17.u17_id
           LEFT JOIN u17_employee u17e
               ON a.m153_modified_by_id_u17 = u17e.u17_id
/