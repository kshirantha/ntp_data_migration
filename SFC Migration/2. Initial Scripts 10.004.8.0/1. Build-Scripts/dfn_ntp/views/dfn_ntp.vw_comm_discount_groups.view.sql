CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_comm_discount_groups
(
    m24_id,
    m24_name,
    m24_name_lang,
    m24_description,
    m24_created_by_id_u17,
    m24_created_date,
    m24_modified_by_id_u17,
    m24_modified_date,
    m24_status_id_v01,
    m24_status_changed_by_id_u17,
    m24_status_changed_date,
    m24_external_ref,
    m24_institution_id_m02,
    status,
    status_changed_by_full_name,
    created_by_full_name,
    modified_by_full_name
)
AS
    SELECT a.m24_id,
           a.m24_name,
           a.m24_name_lang,
           a.m24_description,
           a.m24_created_by_id_u17,
           a.m24_created_date,
           a.m24_modified_by_id_u17,
           a.m24_modified_date,
           a.m24_status_id_v01,
           a.m24_status_changed_by_id_u17,
           a.m24_status_changed_date,
           a.m24_external_ref,
           a.m24_institution_id_m02,
           status_list.v01_description AS status,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           u17_created_by.u17_full_name AS created_by_full_name,
           u17_modified_by.u17_full_name AS modified_by_full_name
      FROM m24_commission_discount_group a
           LEFT JOIN u17_employee u17_status_changed_by
               ON a.m24_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN u17_employee u17_created_by
               ON a.m24_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON a.m24_status_id_v01 = status_list.v01_id
           LEFT JOIN u17_employee u17_modified_by
               ON a.m24_modified_by_id_u17 = u17_modified_by.u17_id;
/
