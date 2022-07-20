CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m116_hijri_adjustments_list
(
    m116_id,
    m116_from_date,
    m116_to_date,
    m116_created_by_id_u17,
    m116_created_date,
    m116_adjustment,
   m116_institute_id_m02,
    created_by_name,
    modified_by_name,
    status_changed_by_name,
    v01_description,
    v01_description_lang
)
AS
    (SELECT m116.m116_id,
            m116.m116_from_date,
            m116.m116_to_date,
            m116.m116_created_by_id_u17,
            m116.m116_created_date,
            m116.m116_adjustment,
        m116.m116_institute_id_m02,
            u17_created.u17_full_name AS created_by_name,
            u17_modified.u17_full_name AS modified_by_name,
            u17_status_changed.u17_full_name AS status_changed_by_name,
            status_list.v01_description,
            status_list.v01_description_lang
       FROM m116_hijri_adjustments m116,
            vw_status_list status_list,
            u17_employee u17_created,
            u17_employee u17_modified,
            u17_employee u17_status_changed
      WHERE     m116.m116_status_id_v01 = status_list.v01_id(+)
            AND m116.m116_created_by_id_u17 = u17_created.u17_id(+)
            AND m116.m116_modified_by_id_u17 = u17_modified.u17_id(+)
            AND m116.m116_status_changed_by_id_u17 =
                    u17_status_changed.u17_id(+));
/
