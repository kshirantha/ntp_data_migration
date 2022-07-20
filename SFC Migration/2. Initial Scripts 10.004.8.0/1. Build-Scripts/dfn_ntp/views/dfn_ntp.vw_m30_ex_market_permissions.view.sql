CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m30_ex_market_permissions
(
    m30_id,
    m30_market_code_m29,
    m30_market_status_id_v19,
    market_status,
    market_code_market_status,
    m30_exchange_code_m01,
    m30_cancel_order_allowed,
    cancel_order_allowed,
    m30_amend_order_allowed,
    amend_order_allowed,
    m30_create_order_allowed,
    create_order_allowed,
    m01_institute_id_m02,
    m30_exchange_id_m01
)
AS
    (SELECT m30.m30_id,
            m30.m30_market_code_m29,
            m30.m30_market_status_id_v19,
            v19.v19_status AS market_status,
            (m30.m30_market_code_m29 || '  ' || v19.v19_status)
                AS market_code_market_status,
            m30.m30_exchange_code_m01,
            m30.m30_cancel_order_allowed,
            CASE m30.m30_cancel_order_allowed
                WHEN 0 THEN 'No'
                WHEN 1 THEN 'Yes'
            END
                AS cancel_order_allowed,
            m30.m30_amend_order_allowed,
            CASE m30.m30_amend_order_allowed
                WHEN 0 THEN 'No'
                WHEN 1 THEN 'Yes'
            END
                AS amend_order_allowed,
            m30.m30_create_order_allowed,
            CASE m30.m30_create_order_allowed
                WHEN 0 THEN 'No'
                WHEN 1 THEN 'Yes'
            END
                AS create_order_allowed,
            m01.m01_institute_id_m02,
            m30_exchange_id_m01
     FROM v19_market_status v19
          JOIN m30_ex_market_permissions m30
              ON v19.v19_id = m30.m30_market_status_id_v19
          JOIN m01_exchanges m01 ON m30.m30_exchange_id_m01 = m01.m01_id)
/