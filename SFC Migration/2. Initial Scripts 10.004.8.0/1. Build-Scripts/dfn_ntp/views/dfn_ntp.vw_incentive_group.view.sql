CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_incentive_group
(
    m162_id,
    m162_description,
    m162_additional_details,
    m162_institute_id_m02,
    m162_is_default,
    m162_group_type_id_v01,
    group_type,
    group_type_lang,
    m162_frequency_id_v01,
    m162_commission_type_id_v01,
    m162_status_id_v01,
    status,
    status_changed_by_full_name
)
AS
    SELECT m162.m162_id AS m162_id,
           m162.m162_description,
           m162.m162_additional_details,
           m162.m162_institute_id_m02,
           m162.m162_is_default,
           m162.m162_group_type_id_v01,
           group_type.v01_description AS group_type,
           group_type.v01_description_lang AS group_type_lang,
           m162.m162_frequency_id_v01,
           m162.m162_commission_type_id_v01,
           m162.m162_status_id_v01,
           status_list.v01_description AS status,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name
      FROM m162_incentive_group m162
           LEFT JOIN u17_employee u17_status_changed_by
               ON m162.m162_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON m162.m162_status_id_v01 = status_list.v01_id
           LEFT JOIN v01_system_master_data group_type
               ON     m162.m162_group_type_id_v01 = group_type.v01_id
                  AND group_type.v01_type = 74
/