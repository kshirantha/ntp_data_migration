CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_price_qty_factors
(
    m39_id,
    m39_name,
    m39_name_lang,
    m39_price_ratio,
    m39_lot_size,
    m39_status_id_v01,
    status_description,
    status_description_lang,
    created_by_full_name,
    m39_created_date,
    modified_by_full_name,
    m39_modified_date,
    status_changed_by_full_name,
    m39_status_changed_date
)
AS
    ( (SELECT m39.m39_id,
              m39.m39_name,
              m39.m39_name_lang,
              m39.m39_price_ratio,
              m39.m39_lot_size,
              m39.m39_status_id_v01,
              status_list.v01_description AS status_description,
              status_list.v01_description_lang AS status_description_lang,
              u17_created_by.u17_full_name AS created_by_full_name,
              m39.m39_created_date,
              u17_modified_by.u17_full_name AS modified_by_full_name,
              m39.m39_modified_date,
              u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
              m39.m39_status_changed_date
         FROM m39_price_qty_factors m39
              LEFT JOIN u17_employee u17_created_by
                  ON m39.m39_created_by_id_u17 = u17_created_by.u17_id
              LEFT JOIN u17_employee u17_modified_by
                  ON m39.m39_modified_by_id_u17 = u17_modified_by.u17_id
              LEFT JOIN u17_employee u17_status_changed_by
                  ON m39.m39_status_changed_by_id_u17 =
                         u17_status_changed_by.u17_id
              LEFT JOIN vw_status_list status_list
                  ON m39.m39_status_id_v01 = status_list.v01_id))
/