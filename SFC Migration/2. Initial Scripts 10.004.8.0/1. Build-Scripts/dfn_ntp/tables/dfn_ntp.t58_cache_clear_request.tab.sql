CREATE TABLE dfn_ntp.t58_cache_clear_request
(
    t58_id                NUMBER (10, 0),
    t58_table_id          VARCHAR2 (100 BYTE),
    t58_store_keys_json   VARCHAR2 (1000 BYTE),
    t58_clear_all         NUMBER (2, 0) DEFAULT 0,
    t58_custom_type       NUMBER (1, 0) DEFAULT 1,
    t58_status            NUMBER (3, 0) DEFAULT 0,
    t58_created_date      TIMESTAMP (6) DEFAULT SYSDATE
)
/

CREATE INDEX dfn_ntp.idx_t58_created_date
    ON dfn_ntp.t58_cache_clear_request (t58_created_date DESC)
/

ALTER TABLE dfn_ntp.t58_cache_clear_request 
 ADD (
  t58_priority NUMBER DEFAULT 0 NOT NULL
 )
/

ALTER TABLE dfn_ntp.t58_cache_clear_request 
 ADD (
  t58_server_id VARCHAR2 (100 BYTE)
 )
/