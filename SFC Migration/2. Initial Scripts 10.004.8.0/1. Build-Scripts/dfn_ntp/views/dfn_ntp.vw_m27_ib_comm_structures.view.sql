CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m27_ib_comm_structures
(
    m27_id,
    m27_ib_grp_id_m21,
    description,
    m27_exchange_code_m01,
    m27_exchange_id_m01,
    m27_comm_group_id_m22,
    m27_created_by_id_u17,
    m27_created_date,
    m27_modified_by_id_u17,
    m27_modified_date,
    m27_status_id_v01,
    created_by_full_name,
    modified_by_full_name,
    status_description,
    status_description_lang
)
AS
    SELECT m27.m27_id,
           m27.m27_ib_grp_id_m21,
           m22.m22_description AS description,
           m27.m27_exchange_code_m01,
           m27.m27_exchange_id_m01,
           m27.m27_comm_group_id_m22,
           m27.m27_created_by_id_u17,
           m27.m27_created_date,
           m27.m27_modified_by_id_u17,
           m27.m27_modified_date,
           m27.m27_status_id_v01,
           u17_created_by.u17_full_name AS created_by_full_name,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang
      FROM m27_ib_commission_structures m27
           JOIN u17_employee u17_created_by
               ON m27.m27_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m27.m27_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON m27.m27_status_id_v01 = status_list.v01_id
           JOIN m22_commission_group m22
               ON m27.m27_comm_group_id_m22 = m22.m22_id;
/
