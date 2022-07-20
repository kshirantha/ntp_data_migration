CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m21_introducing_broker
(
    m21_id,
    m21_name,
    m21_name_lang,
    m21_office_telephone,
    m21_mobile,
    m21_fax,
    m21_email,
    m21_additional_details,
    m21_incentive_group_id_m162,
    m162_description,
    m21_created_by_id_u17,
    m21_created_date,
    m21_modified_by_id_u17,
    m21_modified_date,
    m21_status_id_v01,
    m21_status_changed_date,
    m21_status_changed_by_id_u17,
    m21_institute_id_m02,
    created_by_full_name,
    modified_by_full_name,
    status_description,
    status_description_lang
)
AS
    SELECT m21.m21_id,
           m21.m21_name,
           m21.m21_name_lang,
           m21.m21_office_telephone,
           m21.m21_mobile,
           m21.m21_fax,
           m21.m21_email,
           m21.m21_additional_details,
           m21.m21_incentive_group_id_m162,
           m162.m162_description,
           m21.m21_created_by_id_u17,
           m21.m21_created_date,
           m21.m21_modified_by_id_u17,
           m21.m21_modified_date,
           m21.m21_status_id_v01,
           m21.m21_status_changed_date,
           m21.m21_status_changed_by_id_u17,
           m21.m21_institute_id_m02,
           u17_created_by.u17_full_name AS created_by_full_name,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang
      FROM m21_introducing_broker m21
           JOIN u17_employee u17_created_by
               ON m21.m21_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m21.m21_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON m21.m21_status_id_v01 = status_list.v01_id
           LEFT JOIN m162_incentive_group m162
               ON m21.m21_incentive_group_id_m162 = m162.m162_id
/