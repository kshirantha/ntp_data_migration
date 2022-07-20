-- Table DFN_NTP.A05_CACHE_MON_AUDIT_LOG

CREATE TABLE dfn_ntp.a05_cache_mon_audit_log
(
    a05_id                NUMBER,
    a05_username          VARCHAR2 (50),
    a05_user_ip           VARCHAR2 (50),
    a05_original_string   VARCHAR2 (4000),
    a05_updated_string    VARCHAR2 (4000),
    a05_updated_time      TIMESTAMP (7),
    a05_cache_name        VARCHAR2 (100),
    a05_tenant_code       VARCHAR2 (100)
)
/

-- Constraints for  DFN_NTP.A05_CACHE_MON_AUDIT_LOG


  ALTER TABLE dfn_ntp.a05_cache_mon_audit_log ADD CONSTRAINT pk_a05_id PRIMARY KEY (a05_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.a05_cache_mon_audit_log MODIFY (a05_id NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.A05_CACHE_MON_AUDIT_LOG
ALTER TABLE dfn_ntp.a05_cache_mon_audit_log
 MODIFY (
  a05_id NUMBER (10)

 )
/