CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_boards
(
    m54_exchange_code_m01,
    m54_code,
    m54_is_default,
    is_default,
    m54_is_active,
    is_active,
    m54_preopen_allowed,
    preopen_allowed,
    m54_status_id_v01,
    status_description,
    m54_id,
    m54_exchange_id_m01,
    m54_primary_institution_id_m02
)
AS
    (SELECT m54.m54_exchange_code_m01,
            m54.m54_code,
            m54.m54_is_default,
            CASE m54.m54_is_default WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
                AS is_default,
            m54.m54_is_active,
            CASE m54.m54_is_active WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
                AS is_active,
            m54.m54_preopen_allowed,
            CASE m54.m54_preopen_allowed
                WHEN 0 THEN 'No'
                WHEN 1 THEN 'Yes'
            END
                AS preopen_allowed,
            m54.m54_status_id_v01,
            status_list.v01_description AS status_description,
            m54.m54_id,
            m54.m54_exchange_id_m01,
            m54_primary_institution_id_m02
       FROM m54_boards m54
            LEFT JOIN vw_status_list status_list
                ON m54.m54_status_id_v01 = status_list.v01_id
            INNER JOIN m01_exchanges m01
                ON m54.m54_exchange_id_m01 = m01.m01_id)
/