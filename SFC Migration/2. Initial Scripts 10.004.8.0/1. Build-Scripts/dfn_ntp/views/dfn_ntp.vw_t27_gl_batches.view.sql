CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t27_gl_batches
(
    t27_id,
    t27_institute_id_m02,
    t27_date,
    t27_event_cat_id_m136,
    t27_created_by_id_u17,
    t27_created_date,
    t27_status_id_v01,
    t27_status_changed_by_id_u17,
    t27_status_changed_date,
    event_category_desc,
    event_category_desc_lang,
    m136_type,
    created_by_full_name,
    status,
    status_lang,
    status_changed_by_full_name
)
AS
    SELECT t27.t27_id,
           t27.t27_institute_id_m02,
           t27.t27_date,
           t27.t27_event_cat_id_m136,
           t27.t27_created_by_id_u17,
           t27.t27_created_date,
           t27.t27_status_id_v01,
           t27.t27_status_changed_by_id_u17,
           t27.t27_status_changed_date,
           m136.m136_description AS event_category_desc,
           m136.m136_description_lang AS event_category_desc_lang,
           m136.m136_type,
           u17.u17_full_name AS created_by_full_name,
           status_list.v01_description AS status,
           status_list.v01_description_lang AS status_lang,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name
      FROM t27_gl_batches t27
           JOIN vw_status_list status_list
               ON t27.t27_status_id_v01 = status_list.v01_id
           JOIN m136_gl_event_categories m136
               ON t27.t27_event_cat_id_m136 = m136.m136_id
           LEFT JOIN u17_employee u17
               ON t27.t27_created_by_id_u17 = u17.u17_id
           LEFT JOIN u17_employee u17_status_changed_by
               ON t27.t27_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
/