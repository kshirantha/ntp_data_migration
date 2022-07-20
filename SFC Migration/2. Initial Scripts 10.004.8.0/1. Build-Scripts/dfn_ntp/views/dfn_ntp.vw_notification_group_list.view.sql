CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_notification_group_list
(
    m52_id,
    m52_institute_id_m02,
    m52_name,
    m52_name_lang,
    m52_description,
    m52_created_by_id_u17,
    m52_created_date,
    m52_status_id_v01,
    m52_modified_by_id_u17,
    m52_modified_date,
    m52_status_changed_by_id_u17,
    m52_status_changed_date,
    status,
    created_by,
    status_changed_by,
    modified_by
)
AS
    (SELECT a.m52_id,
            a.m52_institute_id_m02,
            a.m52_name,
            a.m52_name_lang,
            a.m52_description,
            a.m52_created_by_id_u17,
            a.m52_created_date,
            a.m52_status_id_v01,
            a.m52_modified_by_id_u17,
            a.m52_modified_date,
            a.m52_status_changed_by_id_u17,
            a.m52_status_changed_date,
            status.v01_description,
            created_by.u17_full_name,
            u17_status_changed_by.u17_full_name,
            modified_by.u17_full_name
       FROM m52_notification_group a
            JOIN vw_status_list status
                ON a.m52_status_id_v01 = status.v01_id
            JOIN u17_employee created_by
                ON a.m52_created_by_id_u17 = created_by.u17_id
            LEFT JOIN u17_employee u17_status_changed_by
                ON a.m52_status_changed_by_id_u17 =
                       u17_status_changed_by.u17_id
            LEFT JOIN u17_employee modified_by
                ON a.m52_modified_by_id_u17 = modified_by.u17_id)
/