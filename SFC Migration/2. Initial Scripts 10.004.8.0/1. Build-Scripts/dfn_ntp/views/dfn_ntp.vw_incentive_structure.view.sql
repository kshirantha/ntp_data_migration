CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_incentive_structure
(
    m163_id,
    m163_created_by_id_u17,
    m163_created_date,
    m163_modified_by_id_u17,
    m163_modified_date,
    m163_status_id_v01,
    m163_status_changed_by_id_u17,
    m163_currency_id_m03,
    m163_incentive_group_id_m162,
    m163_currency_code_m03,
    status,
    m163_from,
    m163_to,
    m163_percentage,
    m163_exchange_id_m01,
    m163_exchange_code_m01
)
AS
    SELECT a.m163_id,
           a.m163_created_by_id_u17,
           a.m163_created_date,
           a.m163_modified_by_id_u17,
           a.m163_modified_date,
           a.m163_status_id_v01,
           a.m163_status_changed_by_id_u17,
           a.m163_currency_id_m03,
           a.m163_incentive_group_id_m162,
           a.m163_currency_code_m03,
           status_list.v01_description AS status,
           a.m163_from,
           a.m163_to,
           a.m163_percentage,
           a.m163_exchange_id_m01,
           a.m163_exchange_code_m01
      FROM m163_incentive_slabs a
           LEFT JOIN vw_status_list status_list
               ON a.m163_status_id_v01 = status_list.v01_id
/