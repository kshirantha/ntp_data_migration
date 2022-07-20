-- Table DFN_NTP.M92_OMS_CACHE_STORE_MAP

CREATE TABLE dfn_ntp.m92_oms_cache_store_map
(
    m92_table_id           VARCHAR2 (100),
    m92_oms_mapped_names   VARCHAR2 (100),
    m92_description        VARCHAR2 (50),
    m39_cache_prefix       VARCHAR2 (50),
    m92_key_params         VARCHAR2 (200)
)
/



-- Comments for  DFN_NTP.M92_OMS_CACHE_STORE_MAP

COMMENT ON COLUMN dfn_ntp.m92_oms_cache_store_map.m39_cache_prefix IS
    'Prefix of the cache store'
/
COMMENT ON COLUMN dfn_ntp.m92_oms_cache_store_map.m92_key_params IS
    'Key parameters pattern as (commma seperated)'
/
-- End of DDL Script for Table DFN_NTP.M92_OMS_CACHE_STORE_MAP
