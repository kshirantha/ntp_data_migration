CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m59_exchange_market_status
(
    v19_id,
    v19_status,
    m59_id,
    m59_exchange_id_m01,
    m59_market_status_id_v19,
    enabled
)
AS
    SELECT v19.v19_id,
           v19.v19_status,
           m59.m59_id,
           m59.m59_exchange_id_m01,
           m59.m59_market_status_id_v19,
           CASE WHEN m59.m59_id IS NULL THEN 0 ELSE 1 END AS enabled
      FROM     v19_market_status v19
           LEFT JOIN
               m59_exchange_market_status m59
           ON v19.v19_id = m59.m59_market_status_id_v19;
/
