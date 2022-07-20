CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_market_code
(
    m29_exchange_code_m01,
    m29_market_code,
    m29_exchange_id_m01,
    m29_primary_institution_id_m02
)
AS
    SELECT a.m29_exchange_code_m01,
           a.m29_market_code,
           m29_exchange_id_m01,
           m29_primary_institution_id_m02
      FROM m29_markets a
/
