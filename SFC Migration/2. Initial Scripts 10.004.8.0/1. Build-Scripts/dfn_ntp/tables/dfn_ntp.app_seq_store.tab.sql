-- Table DFN_NTP.APP_SEQ_STORE

CREATE TABLE dfn_ntp.app_seq_store
(
    app_seq_name    VARCHAR2 (255),
    app_seq_value   NUMBER (10)
)
/

-- Constraints for  DFN_NTP.APP_SEQ_STORE


  ALTER TABLE dfn_ntp.app_seq_store MODIFY (app_seq_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.app_seq_store MODIFY (app_seq_value NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.app_seq_store ADD CONSTRAINT pk_app_seq_store PRIMARY KEY (app_seq_name)
  USING INDEX  ENABLE
/



-- End of DDL Script for Table DFN_NTP.APP_SEQ_STORE

ALTER TABLE dfn_ntp.app_seq_store
 ADD (
  app_seq_refurbish NUMBER (1)
 )
/
COMMENT ON COLUMN app_seq_store.app_seq_refurbish IS
    'Update Value via DB Scripts : 0 - No | 1 - Dynamic | 2 - Manual'
/

ALTER TABLE dfn_ntp.app_seq_store
 MODIFY (
  app_seq_value NUMBER (25, 0)

 )
/

ALTER TABLE dfn_ntp.app_seq_store
RENAME COLUMN app_seq_refurbish TO app_seq_refresh
/

CREATE TABLE dfn_ntp.app_seq_store_temp
AS
    SELECT * FROM dfn_ntp.app_seq_store
/

DROP TABLE dfn_ntp.app_seq_store;


CREATE TABLE dfn_ntp.app_seq_store
(
    app_seq_name      VARCHAR2 (255 BYTE) NOT NULL,
    app_seq_value     NUMBER (25, 0) NOT NULL,
    app_seq_refresh   NUMBER (1, 0),
    CONSTRAINT pk_app_seq_name PRIMARY KEY (app_seq_name)
)
ORGANIZATION INDEX
/

COMMENT ON COLUMN dfn_ntp.app_seq_store.app_seq_refresh IS
    'Update Value via DB Scripts : 0 - No | 1 - Dynamic | 2 - Manual'
/

INSERT INTO dfn_ntp.app_seq_store
    SELECT * FROM dfn_ntp.app_seq_store_temp
/

DROP TABLE dfn_ntp.app_seq_store_temp
/
