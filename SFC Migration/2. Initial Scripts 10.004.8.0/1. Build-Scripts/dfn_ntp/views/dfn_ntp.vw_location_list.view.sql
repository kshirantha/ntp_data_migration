CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_location_list
(
    m07_id,
    m07_institute_id_m02,
    m07_name,
    m07_name_lang,
    m07_created_by_id_u17,
    m07_created_date,
    m07_status_id_v01,
    m07_modified_by_id_u17,
    m07_modified_date,
    m07_status_changed_by_id_u17,
    m07_status_changed_date,
    m07_external_ref
)
AS
    SELECT m07_id,
           m07_institute_id_m02,
           m07_name,
           m07_name_lang,
           m07_created_by_id_u17,
           m07_created_date,
           m07_status_id_v01,
           m07_modified_by_id_u17,
           m07_modified_date,
           m07_status_changed_by_id_u17,
           m07_status_changed_date,
           m07_external_ref
      FROM m07_location;
/
