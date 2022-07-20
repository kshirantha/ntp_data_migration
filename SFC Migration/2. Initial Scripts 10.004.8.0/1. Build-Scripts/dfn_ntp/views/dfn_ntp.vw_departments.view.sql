CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_departments
(
    m12_id,
    m12_name,
    m12_name_lang,
    m12_institute_id_m02,
    institute_name,
    m12_created_by_id_u17,
    m12_modified_date,
    m12_status_id_v01,
    m12_status_changed_by_id_u17,
    m12_status_changed_date,
    m12_code,
    m12_external_ref,
    m12_modified_by_id_u17,
    status_description,
    status_description_lang,
    status_changed_by_full_name
)
AS
    SELECT m12_id,
           m12_name,
           m12_name_lang,
           m12_institute_id_m02,
           m02_institute.m02_name AS institute_name,
           m12_created_by_id_u17,
           m12_created_date m12_modified_date,
           m12_status_id_v01,
           m12_status_changed_by_id_u17,
           m12_status_changed_date,
           m12_code,
           m12_external_ref,
           m12_modified_by_id_u17,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name
      FROM m12_employee_department m12
           JOIN u17_employee u17_status_changed_by
               ON m12.m12_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           JOIN vw_status_list status_list
               ON m12.m12_status_id_v01 = status_list.v01_id
           LEFT JOIN m02_institute
               ON m02_institute.m02_id = m12.m12_institute_id_m02;
/
