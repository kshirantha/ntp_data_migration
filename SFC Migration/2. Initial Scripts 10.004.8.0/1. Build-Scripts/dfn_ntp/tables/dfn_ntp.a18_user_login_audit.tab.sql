-- Table DFN_NTP.A18_USER_LOGIN_AUDIT

CREATE TABLE dfn_ntp.a18_user_login_audit
(
    a18_channel_id_v29    NUMBER (5, 0),
    a18_appsvr_id         NUMBER (5, 0),
    a18_ip                VARCHAR2 (32),
    a18_login_name        VARCHAR2 (100),
    a18_password          VARCHAR2 (500),
    a18_version           VARCHAR2 (40) DEFAULT NULL,
    a18_login_time        TIMESTAMP (6),
    a18_status_id_v01     NUMBER (5, 0),
    a18_login_id          NUMBER (30, 0),
    a18_narration         VARCHAR2 (250),
    a18_failed_attempts   NUMBER (5, 0) DEFAULT 0,
    a18_password_b        VARCHAR2 (200)
)
/



-- End of DDL Script for Table DFN_NTP.A18_USER_LOGIN_AUDIT

ALTER TABLE dfn_ntp.a18_user_login_audit
 ADD (
  a18_entity_type NUMBER (2)
 )
/
COMMENT ON COLUMN dfn_ntp.a18_user_login_audit.a18_entity_type IS
    'Customer-1 ,User-2'
/

ALTER TABLE DFN_NTP.A18_USER_LOGIN_AUDIT 
 ADD (
  A18_INSTITUTE_ID_M02 NUMBER (3)
 )
/

ALTER TABLE dfn_ntp.a18_user_login_audit
    MODIFY (a18_institute_id_m02 DEFAULT 1)
/

ALTER TABLE dfn_ntp.a18_user_login_audit
 ADD (
  a18_login_date DATE
 )
/

CREATE INDEX dfn_ntp.idx_a18_login_id
    ON dfn_ntp.a18_user_login_audit (a18_login_id)
/

CREATE INDEX dfn_ntp.idx_a18_channel_id_v29
    ON dfn_ntp.a18_user_login_audit (a18_channel_id_v29)
/

CREATE INDEX dfn_ntp.idx_a18_login_date
    ON dfn_ntp.a18_user_login_audit (a18_login_date DESC)
/
