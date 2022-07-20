CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m156_exchange_waveof_detail
(
    m156_id,
    m156_group_id_m154,
    m156_exchange_prd_id_m153,
    m156_currency_code_m03,
    m156_currency_id_m03,
    m156_exchange_fee_waiveof_amnt,
    m156_exchange_fee_waiveof_pct,
    m156_created_date,
    m156_created_by_id_u17,
    m156_modified_date,
    m156_modified_by_id_u17,
    m156_custom_type,
    m156_status_id_v01,
    m156_status_changed_by_id_u17,
    m156_status_changed_date,
    created_by,
    modified_by,
    status_changed_by,
    status
)
AS
    SELECT a.m156_id,
           a.m156_group_id_m154,
           a.m156_exchange_prd_id_m153,
           a.m156_currency_code_m03,
           a.m156_currency_id_m03,
           a.m156_exchange_fee_waiveof_amnt,
           a.m156_exchange_fee_waiveof_pct,
           a.m156_created_date,
           a.m156_created_by_id_u17,
           a.m156_modified_date,
           a.m156_modified_by_id_u17,
           a.m156_custom_type,
           a.m156_status_id_v01,
           a.m156_status_changed_by_id_u17,
           a.m156_status_changed_date,
           u17.u17_full_name created_by,
           u17e.u17_full_name modified_by,
           u17s.u17_full_name status_changed_by,
           status_list.v01_description AS status
      FROM m156_exchange_waiveoff_details a
           JOIN u17_employee u17
               ON a.m156_created_by_id_u17 = u17.u17_id
           LEFT JOIN u17_employee u17e
               ON a.m156_modified_by_id_u17 = u17e.u17_id
           JOIN u17_employee u17s
               ON a.m156_status_changed_by_id_u17 = u17s.u17_id
           LEFT JOIN vw_status_list status_list
               ON m156_status_id_v01 = status_list.v01_id
/