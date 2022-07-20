CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_markets
(
    m29_exchange_code_m01,
    m29_current_mkt_status_id_v19,
    m29_market_code,
    m29_last_status_updated,
    m29_is_default,
    is_default,
    m29_is_active,
    is_active,
    m29_preopen_allowed,
    preopen_allowed,
    m29_status_id_v01,
    status_description,
    m29_id,
    m29_exchange_id_m01,
    m29_primary_institution_id_m02
)
AS
    (SELECT m29.m29_exchange_code_m01,
            m29.m29_current_mkt_status_id_v19,
            m29.m29_market_code,
            m29.m29_last_status_updated,
            m29.m29_is_default,
            CASE m29.m29_is_default WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
                AS is_default,
            m29.m29_is_active,
            CASE m29.m29_is_active WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
                AS is_active,
            m29.m29_preopen_allowed,
            CASE m29.m29_preopen_allowed
                WHEN 0 THEN 'No'
                WHEN 1 THEN 'Yes'
            END
                AS preopen_allowed,
            m29.m29_status_id_v01,
            status_list.v01_description AS status_description,
            m29.m29_id,
            m29.m29_exchange_id_m01,
            m29_primary_institution_id_m02
       FROM m29_markets m29
            LEFT JOIN vw_status_list status_list
                ON m29.m29_status_id_v01 = status_list.v01_id
            INNER JOIN m01_exchanges m01
                ON m29.m29_exchange_id_m01 = m01.m01_id)
/
