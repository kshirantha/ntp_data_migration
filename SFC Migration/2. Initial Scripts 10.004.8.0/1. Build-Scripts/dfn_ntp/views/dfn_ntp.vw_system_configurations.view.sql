CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_system_configurations
(
    v00_id,
    v00_value,
    v00_key,
    v00_description,
    v00_status_id_v01,
    v00_status_changed_by_id_u17,
    v00_status_changed_date,
    v00_modified_by_id_u17,
    v00_modified_date,
    status,
    status_changed_by_full_name,
    primary_institution_id_m02,
    is_broker_wise
)
AS
    (SELECT v00.v00_id,
            v00.v00_value,
            v00.v00_key,
            v00.v00_description,
            v00.v00_status_id_v01,
            v00.v00_status_changed_by_id_u17,
            v00.v00_status_changed_date,
            v00.v00_modified_by_id_u17,
            v00.v00_modified_date,
            status_list.v01_description AS status,
            u17.u17_full_name AS status_changed_by_full_name,
            NULL AS primary_institution_id_m02,
            0 AS is_broker_wise
       FROM v00_sys_config v00
            LEFT JOIN vw_status_list status_list
                ON status_list.v01_id = v00.v00_status_id_v01
            LEFT JOIN u17_employee u17
                ON u17_id = v00.v00_status_changed_by_id_u17
     UNION ALL
     SELECT v00.v00_id,
            v00.v00_value,
            v00.v00_key,
            v00.v00_description,
            v00.v00_status_id_v01,
            v00.v00_status_changed_by_id_u17,
            v00.v00_status_changed_date,
            v00.v00_modified_by_id_u17,
            v00.v00_modified_date,
            status_list.v01_description AS status,
            u17.u17_full_name AS status_changed_by_full_name,
            v00_primary_institution_id_m02 AS primary_institution_id_m02,
            1 AS is_broker_wise
       FROM v00_sys_config_broker_wise v00
            LEFT JOIN vw_status_list status_list
                ON status_list.v01_id = v00.v00_status_id_v01
            LEFT JOIN u17_employee u17
                ON u17_id = v00.v00_status_changed_by_id_u17)
/
