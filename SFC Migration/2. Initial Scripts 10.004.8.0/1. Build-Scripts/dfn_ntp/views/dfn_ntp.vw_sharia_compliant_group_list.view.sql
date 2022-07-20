CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_sharia_compliant_group_list
(
    m120_id,
    m120_name,
    m120_institute_id_m02,
    m120_created_by_id_u17,
    created_by_name,
    m120_created_date,
    m120_modified_by_id_u17,
    modified_by_name,
    m120_modified_date,
    m120_status_id_v01,
    status,
    m120_status_changed_by_id_u17,
    status_changed_by_name,
    m120_status_changed_date,
    m120_is_default,
    is_default
)
AS
    (SELECT m120.m120_id,
            m120.m120_name,
            m120.m120_institute_id_m02,
            m120.m120_created_by_id_u17,
            u17_created_by.u17_full_name AS created_by_name,
            m120.m120_created_date,
            m120.m120_modified_by_id_u17,
            u17_modified_by.u17_full_name AS modified_by_name,
            m120.m120_modified_date,
            m120.m120_status_id_v01,
            vw_status_list.v01_description AS status,
            m120.m120_status_changed_by_id_u17,
            u17_status_changed_by.u17_full_name AS status_changed_by_name,
            m120.m120_status_changed_date,
            m120.m120_is_default,
            CASE m120.m120_is_default WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END
                AS is_default
       FROM m120_sharia_compliant_group m120
            LEFT JOIN u17_employee u17_created_by
                ON m120.m120_created_by_id_u17 = u17_created_by.u17_id
            LEFT JOIN u17_employee u17_modified_by
                ON m120.m120_modified_by_id_u17 = u17_modified_by.u17_id
            LEFT JOIN vw_status_list
                ON m120.m120_status_id_v01 = vw_status_list.v01_id
            LEFT JOIN u17_employee u17_status_changed_by
                ON m120.m120_status_changed_by_id_u17 =
                       u17_status_changed_by.u17_id);
/
