CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_currencies
(
    m03_id,
    m03_code,
    m03_description,
    m03_description_lang,
    m03_sub_unit_description,
    m03_sub_unit_description_lang,
    m03_decimal_places,
    m03_display_format,
    m03_created_by_id_u17,
    created_by_full_name,
    m03_created_date,
    m03_status_id_v01,
    status_description,
    status_description_lang,
    m03_modified_by_id_u17,
    modified_by_full_name,
    m03_modified_date,
    m03_status_changed_by_id_u17,
    status_changed_by_full_name,
    m03_status_changed_date
)
AS
    SELECT m03_id,
           m03_code,
           m03_description,
           m03_description_lang,
           m03_sub_unit_description,
           m03_sub_unit_description_lang,
           m03_decimal_places,
           m03_display_format,
           m03_created_by_id_u17,
           u17_created_by.u17_full_name AS created_by_full_name,
           m03_created_date,
           m03_status_id_v01,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           m03_modified_by_id_u17,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           m03_modified_date,
           m03_status_changed_by_id_u17,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           m03_status_changed_date
      FROM m03_currency m03
           LEFT JOIN u17_employee u17_created_by
               ON m03.m03_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m03.m03_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN u17_employee u17_status_changed_by
               ON m03.m03_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON m03.m03_status_id_v01 = status_list.v01_id;
/
