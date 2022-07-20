CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_routing_data
(
    m19_id,
    m19_connection_status,
    connection_status,
    m19_fix_tag_49,
    m19_fix_tag_56,
    m19_fix_tag_50,
    m19_connection_alias,
    m19_fix_tag_142,
    m19_created_by_id_u17,
    m19_created_date,
    created_by_full_name,
    m19_modified_by_id_u17,
    modified_by_full_name,
    m19_modified_date,
    m19_status_id_v01,
    m19_status_changed_by_id_u17,
    status_changed_by_full_name,
    m19_status_changed_date,
    m19_primary_institute_id_m02,
    m19_default_exchange_code_m01,
    m19_default_exchange_id_m01,
    status_description,
    m19_gmt_offset_trade
)
AS
    (SELECT m19_id,
            m19_connection_status,
            CASE
                WHEN m19_connection_status = 1 THEN 'Connected'
                WHEN m19_connection_status = 0 THEN 'Disconnected'
            END
                AS connection_status,
            m19_fix_tag_49,
            m19_fix_tag_56,
            m19_fix_tag_50,
            m19_connection_alias,
            m19_fix_tag_142,
            m19_created_by_id_u17,
            m19.m19_created_date,
            created_by.u17_full_name AS created_by_full_name,
            m19_modified_by_id_u17,
            modified_by.u17_full_name AS modified_by_full_name,
            m19_modified_date,
            m19_status_id_v01,
            m19_status_changed_by_id_u17,
            status_changed_by.u17_full_name AS status_changed_by_full_name,
            m19_status_changed_date,
            m19.m19_primary_institute_id_m02,
            m19.m19_default_exchange_code_m01,
            m19.m19_default_exchange_id_m01,
            status_list.v01_description AS status_description,
            m19.m19_gmt_offset_trade
       FROM m19_routing_data m19
            LEFT JOIN u17_employee created_by
                ON m19.m19_created_by_id_u17 = created_by.u17_id
            LEFT JOIN u17_employee modified_by
                ON m19.m19_modified_by_id_u17 = modified_by.u17_id
            LEFT JOIN u17_employee status_changed_by
                ON m19.m19_status_changed_by_id_u17 =
                       status_changed_by.u17_id
            LEFT JOIN vw_status_list status_list
                ON m19.m19_status_id_v01 = status_list.v01_id)
/