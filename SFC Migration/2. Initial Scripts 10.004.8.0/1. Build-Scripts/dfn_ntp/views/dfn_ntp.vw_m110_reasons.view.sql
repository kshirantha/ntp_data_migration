CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m110_reasons
(
    m110_id,
    m110_type,
    reason_type,
    m110_reason_text,
    m110_created_by_id_u17,
    created_by,
    m110_created_date,
    m110_modified_by_id_u17,
    modified_by,
    m110_modified_date,
    m110_status_changed_by_id_u17,
    status_changed_by,
    m110_status_changed_date,
    m110_status_id_v01,
    status,
   status_lang,
   m110_institute_id_m02 )
AS
    (SELECT m110.m110_id,
            m110.m110_type,
            CASE m110.m110_type
                WHEN 1 THEN 'Cash Transfer Block'
                WHEN 2 THEN 'Holding Pledge'
                WHEN 3 THEN 'Cash Transfer'
                WHEN 4 THEN 'Customer Suspension'
                WHEN 5 THEN 'Cash Transaction Block'
                WHEN 6 THEN 'Stock Transaction Block'
                WHEN 7 THEN 'Stock Transfer Block'
                WHEN 8 THEN 'Pledge Transaction Block'
                WHEN 9 THEN 'Trading Transaction Block'
                WHEN 15 THEN 'Account Closure Reject'
            END
                AS reason_type,
            m110.m110_reason_text,
            m110.m110_created_by_id_u17,
            u17_created_by.u17_full_name AS created_by,
            m110.m110_created_date,
            m110.m110_modified_by_id_u17,
            u17_modified_by.u17_full_name AS modified_by,
            m110.m110_modified_date,
            m110.m110_status_changed_by_id_u17,
            u17_status_changed_by.u17_full_name AS status_changed_by,
            m110.m110_status_changed_date,
            m110.m110_status_id_v01,
            status_list.v01_description AS status,
       status_list.v01_description_lang AS status_lang,
       m110.m110_institute_id_m02
       FROM m110_reasons m110
            LEFT JOIN u17_employee u17_created_by
                ON m110.m110_created_by_id_u17 = u17_created_by.u17_id
            LEFT JOIN u17_employee u17_modified_by
                ON m110.m110_modified_by_id_u17 = u17_modified_by.u17_id
            LEFT JOIN u17_employee u17_status_changed_by
                ON m110.m110_status_changed_by_id_u17 =
                       u17_status_changed_by.u17_id
            LEFT JOIN vw_status_list status_list
                ON m110.m110_status_id_v01 = status_list.v01_id);
/
