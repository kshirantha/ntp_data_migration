CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m131_mkt_maker_groups
(
    m131_id,
    m131_name,
    m131_created_by_id_u17,
    created_by_full_name,
    m131_created_date,
    m131_modified_by_id_u17,
    modified_by_full_name,
    m131_modified_date,
    m131_status_id_v01,
    status_description,
    m131_status_changed_by_id_u17,
    status_changed_by_full_name,
    m131_status_changed_date,
    m131_institute_id_m02
)
AS
    SELECT m131.m131_id,
           m131.m131_name,
           m131.m131_created_by_id_u17,
           u17_created_by.u17_full_name AS created_by_full_name,
           m131.m131_created_date,
           m131.m131_modified_by_id_u17,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           m131.m131_modified_date,
           m131.m131_status_id_v01,
           status_list.v01_description AS status_description,
           m131.m131_status_changed_by_id_u17,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           m131.m131_status_changed_date,
           m131_institute_id_m02
      FROM m131_market_maker_grps m131
           JOIN u17_employee u17_created_by
               ON m131.m131_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m131.m131_modified_by_id_u17 = u17_modified_by.u17_id
           JOIN u17_employee u17_status_changed_by
               ON m131.m131_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON m131.m131_status_id_v01 = status_list.v01_id
/