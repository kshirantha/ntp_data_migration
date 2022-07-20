CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m155_product_waveof_details
(
    m155_id,
    m155_group_id_m154,
    m155_product_id_m152,
    m155_currency_code_m03,
    m155_currency_id_m03,
    m155_service_fee_waiveof_amnt,
    m155_service_fee_waiveof_pct,
    m155_broker_fee_waiveof_amnt,
    m155_broker_fee_waiveof_pct,
    m155_created_date,
    m155_created_by_id_u17,
    m155_modified_date,
    m155_modified_by_id_u17,
    m155_custom_type,
    created_by,
    modified_by,
    status_changed_by,
    m155_status_id_v01,
    status,
    m155_status_changed_by_id_u17,
    m155_status_changed_date
)
AS
    SELECT a.m155_id,
           a.m155_group_id_m154,
           a.m155_product_id_m152,
           a.m155_currency_code_m03,
           a.m155_currency_id_m03,
           a.m155_service_fee_waiveof_amnt,
           a.m155_service_fee_waiveof_pct,
           a.m155_broker_fee_waiveof_amnt,
           a.m155_broker_fee_waiveof_pct,
           a.m155_created_date,
           a.m155_created_by_id_u17,
           a.m155_modified_date,
           a.m155_modified_by_id_u17,
           a.m155_custom_type,
           u17.u17_full_name created_by,
           u17e.u17_full_name modified_by,
           u17s.u17_full_name status_changed_by,
           m155_status_id_v01,
           status_list.v01_description AS status,
           a.m155_status_changed_by_id_u17,
           a.m155_status_changed_date
      FROM m155_product_waiveoff_details a
           JOIN u17_employee u17
               ON a.m155_created_by_id_u17 = u17.u17_id
           LEFT JOIN u17_employee u17e
               ON a.m155_modified_by_id_u17 = u17e.u17_id
           JOIN u17_employee u17s
               ON a.m155_status_changed_by_id_u17 = u17s.u17_id
           LEFT JOIN vw_status_list status_list
               ON m155_status_id_v01 = status_list.v01_id
/