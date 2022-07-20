CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_discount_charge_groups
(
    m165_id,
    m165_name,
    m165_description,
    m165_created_date,
    m165_created_by_id_u17,
    m165_status_changed_date,
    m165_status_changed_by_id_u17,
    m165_modified_date,
    m165_modified_by_id_u17,
    m165_status_id_v01,
    m165_is_default,
    m165_custom_type,
    m165_institute_id_m02,
    created_by_name,
    modified_by_name,
    status_changed_by_name,
    status,
    is_default
)
AS
    SELECT m165.m165_id,
           m165.m165_name,
           m165.m165_description,
           m165.m165_created_date,
           m165.m165_created_by_id_u17,
           m165.m165_status_changed_date,
           m165.m165_status_changed_by_id_u17,
           m165.m165_modified_date,
           m165.m165_modified_by_id_u17,
           m165.m165_status_id_v01,
           m165.m165_is_default,
           m165.m165_custom_type,
           m165.m165_institute_id_m02,
           u17_c.u17_full_name AS created_by_name,
           u17_m.u17_full_name AS modified_by_name,
           u17_s.u17_full_name AS status_changed_by_name,
           status_list.v01_description AS status,
           CASE m165.m165_is_default WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
               AS is_default
      FROM m165_discount_charge_groups m165,
           u17_employee u17_c,
           u17_employee u17_m,
           u17_employee u17_s,
           vw_status_list status_list
     WHERE     m165.m165_created_by_id_u17 = u17_c.u17_id
           AND m165.m165_modified_by_id_u17 = u17_m.u17_id
           AND m165.m165_status_changed_by_id_u17 = u17_s.u17_id
           AND m165.m165_status_id_v01 = status_list.v01_id
/
