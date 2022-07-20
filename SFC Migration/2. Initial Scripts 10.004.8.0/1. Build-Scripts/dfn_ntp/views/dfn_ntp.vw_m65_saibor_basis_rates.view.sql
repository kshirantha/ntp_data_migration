CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m65_saibor_basis_rates
(
    m65_id,
    m65_description,
    m65_type,
    rate_type,
    m65_duration_id_m64,
    duration,
    m65_rate,
    m65_institution_id_m02,
    m65_status_id_v01,
    status_description,
    status_description_lang,
    m65_status_changed_by_id_u17,
    status_changed_by_full_name,
    m65_status_changed_date,
    m65_created_by_id_u17,
    created_by_full_name,
    m65_created_date,
    m65_modified_by_id_u17,
    modified_by_full_name,
    m65_modified_date,
    m65_tax
)
AS
    SELECT m65.m65_id,
           m65.m65_description,
           m65.m65_type,
           v01.v01_description AS rate_type,
           m65.m65_duration_id_m64,
           m64.m64_duration AS duration,
           m65.m65_rate,
           m65.m65_institution_id_m02,
           m65.m65_status_id_v01,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           m65.m65_status_changed_by_id_u17,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           m65.m65_status_changed_date,
           m65.m65_created_by_id_u17,
           u17_created_by.u17_full_name AS created_by_full_name,
           m65.m65_created_date,
           m65.m65_modified_by_id_u17,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           m65.m65_modified_date,
           m65.m65_tax
      FROM m65_saibor_basis_rates m65
           LEFT JOIN u17_employee u17_created_by
               ON m65.m65_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m65.m65_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN u17_employee u17_status_changed_by
               ON m65.m65_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON m65.m65_status_id_v01 = status_list.v01_id
           LEFT JOIN m64_saibor_basis_durations m64
               ON m65.m65_duration_id_m64 = m64.m64_id
           LEFT JOIN v01_system_master_data v01
               ON v01.v01_type = 79 AND m65.m65_type = v01.v01_id;
/