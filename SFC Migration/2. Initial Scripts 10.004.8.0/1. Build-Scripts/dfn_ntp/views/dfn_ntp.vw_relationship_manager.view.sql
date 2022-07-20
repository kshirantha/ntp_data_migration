CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_relationship_manager
(
    m10_id,
    m10_institute_id_m02,
    inst_name,
    m10_fax,
    m10_telephone,
    m10_location_id_m07,
    m10_code,
    m10_name,
    m10_name_lang,
    m10_incentive_group_id_m162,
    created_by_full_name,
    m10_created_date,
    m10_status_id_v01,
    status_description,
    status_description_lang,
    modified_by_full_name,
    m10_modified_by_id_u17,
    m10_modified_date,
    status_changed_by_full_name,
    m10_status_changed_date,
    m10_external_ref,
    m07_name,
    location_code_m07,
    m162_description
)
AS
    SELECT m10_id,
           m10_institute_id_m02,
           m02_institute.m02_name AS inst_name,
           m10_fax,
           m10_telephone,
           m10_location_id_m07,
           m10_code,
           m10_name,
           m10_name_lang,
           m10_incentive_group_id_m162,
           u17_created_by.u17_full_name AS created_by_full_name,
           m10_created_date,
           m10_status_id_v01,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           m10_modified_by_id_u17,
           m10_modified_date,
           u_17_status_changed_by.u17_full_name
               AS status_changed_by_full_name,
           m10_status_changed_date,
           m10_external_ref,
           m07_location.m07_name,
           m07_location.m07_location_code AS location_code_m07,
           m162.m162_description
      FROM m10_relationship_manager m10
           LEFT JOIN u17_employee u17_created_by
               ON m10.m10_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m10.m10_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN u17_employee u_17_status_changed_by
               ON m10.m10_status_changed_by_id_u17 =
                      u_17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON m10.m10_status_id_v01 = status_list.v01_id
           LEFT JOIN m02_institute
               ON m10.m10_institute_id_m02 = m02_institute.m02_id
           LEFT JOIN m07_location
               ON m10.m10_location_id_m07 = m07_location.m07_id
           LEFT JOIN m162_incentive_group m162
               ON m10.m10_incentive_group_id_m162 = m162.m162_id
/