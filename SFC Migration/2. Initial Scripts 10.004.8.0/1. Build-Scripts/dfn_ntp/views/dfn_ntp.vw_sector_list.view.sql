CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_sector_list
(
    m63_id,
    m63_exchange_id_m01,
    m63_exchange_code_m01,
    m63_sector_code,
    m63_description,
    m63_description_lang,
    m63_shortdescription,
    m63_shortdescription_lang,
    m63_created_by_id_u17,
    m63_created_date,
    m63_modified_by_id_u17,
    m63_modified_date,
    m63_status_id_v01,
    m63_status_changed_by_id_u17,
    m63_status_changed_date,
    created_by_name,
    modified_by_name,
    status_changed_by_name,
    v01_description,
    v01_description_lang,
    m01_institute_id_m02
)
AS
      SELECT m63_id,
             m63_exchange_id_m01,
             m63_exchange_code_m01,
             m63_sector_code,
             m63_description,
             m63_description_lang,
             m63_shortdescription,
             m63_shortdescription_lang,
             m63_created_by_id_u17,
             m63_created_date,
             m63_modified_by_id_u17,
             m63_modified_date,
             m63_status_id_v01,
             m63_status_changed_by_id_u17,
             m63_status_changed_date,
             u17_created.u17_full_name AS created_by_name,
             u17_modified.u17_full_name AS modified_by_name,
             u17_status_changed.u17_full_name AS status_changed_by_name,
             status_list.v01_description,
             status_list.v01_description_lang,
             m01.m01_institute_id_m02
        FROM m63_sectors m63,
             vw_status_list status_list,
             u17_employee u17_created,
             u17_employee u17_modified,
             u17_employee u17_status_changed,
             m01_exchanges m01
       WHERE     m63.m63_exchange_id_m01 = m01.m01_id
             AND m63_status_id_v01 = status_list.v01_id
             AND m63.m63_created_by_id_u17 = u17_created.u17_id
             AND m63.m63_modified_by_id_u17 = u17_modified.u17_id(+)
             AND m63.m63_status_changed_by_id_u17 = u17_status_changed.u17_id
    ORDER BY m63_exchange_code_m01
/