CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m152_products_list
(
    m152_id,
    m152_product_code,
    m152_product_name,
    m152_product_name_lang,
    m152_institution_id_m02,
    m152_is_active,
    is_active,
    m152_duration,
    m152_currency_code_m03,
    m152_currency_id_m03,
    m152_service_fee,
    m152_broker_fee,
    m152_vat_pct,
    m152_created_date,
    m152_created_by_id_u17,
    m152_modified_date,
    m152_modified_by_id_u17,
    m152_custom_type,
    m152_product_id_v35,
    created_by,
    modified_by,
    status_changed_by,
    status,
    m152_status_changed_by_id_u17,
    m152_status_changed_date,
    m152_status_id_v01,
    m152_product_id_m144,
    m152_exchange_fee,
    m152_other_fee,
    m152_sub_agreement_type,
    user_type,
    m144_product_name,
    m144_product_id_v35,
    m152_description
)
AS
    SELECT a.m152_id,
           a.m152_product_code,
           a.m152_product_name,
           a.m152_product_name_lang,
           a.m152_institution_id_m02,
           a.m152_is_active,
           CASE WHEN a.m152_is_active = 1 THEN 'Yes' ELSE 'No' END
               AS is_active,
           a.m152_duration,
           a.m152_currency_code_m03,
           TO_NUMBER (a.m152_currency_id_m03) AS m152_currency_id_m03,
           a.m152_service_fee,
           a.m152_broker_fee,
           a.m152_vat_pct,
           a.m152_created_date,
           a.m152_created_by_id_u17,
           a.m152_modified_date,
           a.m152_modified_by_id_u17,
           a.m152_custom_type,
           a.m152_product_id_v35,
           u17.u17_full_name created_by,
           u17e.u17_full_name modified_by,
           u17s.u17_full_name status_changed_by,
           status_list.v01_description AS status,
           a.m152_status_changed_by_id_u17,
           a.m152_status_changed_date,
           a.m152_status_id_v01,
           a.m152_product_id_m144,
           a.m152_exchange_fee,
           a.m152_other_fee,
           a.m152_sub_agreement_type,
           CASE
               WHEN a.m152_sub_agreement_type = 0 THEN 'Business'
               WHEN a.m152_sub_agreement_type = 1 THEN 'Private'
           END
               AS user_type,
           m144.m144_product_name,
           m144.m144_product_id_v35,
           a.m152_description
      FROM m152_products a
           JOIN u17_employee u17 ON a.m152_created_by_id_u17 = u17.u17_id
           JOIN m144_subscription_products m144
               ON a.m152_product_id_m144 = m144.m144_id
           LEFT JOIN u17_employee u17e
               ON a.m152_modified_by_id_u17 = u17e.u17_id
           LEFT JOIN u17_employee u17s
               ON a.m152_status_changed_by_id_u17 = u17s.u17_id
           LEFT JOIN vw_status_list status_list
               ON m152_status_id_v01 = status_list.v01_id
/