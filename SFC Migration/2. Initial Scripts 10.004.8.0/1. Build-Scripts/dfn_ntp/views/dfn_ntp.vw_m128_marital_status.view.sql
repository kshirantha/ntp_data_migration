CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m128_marital_status
(
    m128_id,
    m128_description,
    m128_created_by_id_u17,
    m128_created_date,
    m128_modified_by_id_u17,
    m128_modified_date,
    m128_status_id_v01,
    m128_status_changed_by_id_u17,
    m128_status_changed_date,
    status,
    created_by_full_name,
    modified_by_full_name,
    status_changed_by_full_name
)
AS
    SELECT m128_id,
           m128_description,
           m128_created_by_id_u17,
           m128_created_date,
           m128_modified_by_id_u17,
           m128_modified_date,
           m128_status_id_v01,
           m128_status_changed_by_id_u17,
           m128_status_changed_date,
           status_list.v01_description AS status,
           u17_created_by.u17_full_name AS created_by_full_name,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name
      FROM m128_marital_status m128
           JOIN u17_employee u17_created_by
               ON m128.m128_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m128.m128_modified_by_id_u17 = u17_modified_by.u17_id
           JOIN u17_employee u17_status_changed_by
               ON m128.m128_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON m128.m128_status_id_v01 = status_list.v01_id;
/
