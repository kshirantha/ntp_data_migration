CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_stock_concentration_group
(
    m75_id,
    m75_institute_id_m02,
    m75_type,
    m75_description,
    m75_additional_details,
    m75_status_id_v01,
    status,
    m75_exchange_id_m01,
    m75_exchange_code_m01,
    m75_created_by_id_u17,
    created_by_full_name,
    m75_created_date,
    m75_modified_by_id_u17,
    modified_by_full_name,
    m75_modified_date,
    sts_chngd_by_full_name,
    m75_status_changed_date,
    m75_global_concentration_pct
)
AS
    SELECT m75.m75_id,
           m75.m75_institute_id_m02,
           m75.m75_type,
           m75.m75_description,
           m75.m75_additional_details,
           m75.m75_status_id_v01,
           vw_status_list.v01_description AS status,
           m75.m75_exchange_id_m01,
           m75.m75_exchange_code_m01,
           m75.m75_created_by_id_u17,
           u17_created_by.u17_full_name AS created_by_full_name,
           m75.m75_created_date,
           m75.m75_modified_by_id_u17,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           m75.m75_modified_date,
           u17_st_chg_by.u17_full_name AS sts_chngd_by_full_name,
           m75.m75_status_changed_date,
           m75_global_concentration_pct
      FROM m75_stock_concentration_group m75
           LEFT JOIN u17_employee u17_created_by
               ON m75.m75_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m75.m75_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN u17_employee u17_st_chg_by
               ON m75.m75_modified_by_id_u17 = u17_st_chg_by.u17_id
           LEFT JOIN vw_status_list
               ON m75.m75_status_id_v01 = vw_status_list.v01_id
     WHERE m75.m75_type = 1
/