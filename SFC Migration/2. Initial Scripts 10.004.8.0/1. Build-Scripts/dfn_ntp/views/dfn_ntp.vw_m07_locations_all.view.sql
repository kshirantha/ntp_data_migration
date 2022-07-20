CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m07_locations_all
(
    m07_id,
    m07_location_code,
    m07_name,
    m07_name_lang,
    status,
    m07_status_id_v01,
    m02_name,
    region,
    m07_region_id_m90,
    created_by,
    m07_created_date,
    m07_modified_date,
    m07_status_changed_date,
    m07_external_ref,
    modified_by,
    status_changed_by,
    m07_institute_id_m02,
    m07_order_value_per_day,
    m07_order_volume_per_day,
    m07_default_currency_code_m03,
    m07_default_currency_id_m03
)
AS
    SELECT m07.m07_id,
           m07.m07_location_code,
           m07.m07_name,
           m07.m07_name_lang,
           status.v01_description AS status,
           m07.m07_status_id_v01,
           m02.m02_name,
           m90.m90_name AS region,
           m07.m07_region_id_m90,
           u17_created_by.u17_full_name AS created_by,
           m07.m07_created_date,
           m07.m07_modified_date,
           m07.m07_status_changed_date,
           m07.m07_external_ref,
           u17_modified_by.u17_full_name AS modified_by,
           u17_status_changed_by.u17_full_name AS status_changed_by,
           m07.m07_institute_id_m02,
           m07.m07_order_value_per_day,
           m07.m07_order_volume_per_day,
           m07.m07_default_currency_code_m03,
           m07.m07_default_currency_id_m03
      FROM m07_location m07
           INNER JOIN m02_institute m02
               ON m02.m02_id = m07.m07_institute_id_m02
           LEFT JOIN m90_region m90
               ON m90.m90_id = m07.m07_region_id_m90
           INNER JOIN vw_status_list status
               ON status.v01_id = m07.m07_status_id_v01
           JOIN u17_employee u17_created_by
               ON m07.m07_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m07.m07_modified_by_id_u17 = u17_modified_by.u17_id
           JOIN u17_employee u17_status_changed_by
               ON m07.m07_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
/
