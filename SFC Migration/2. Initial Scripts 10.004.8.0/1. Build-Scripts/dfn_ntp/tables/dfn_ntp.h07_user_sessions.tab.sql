CREATE TABLE dfn_ntp.h07_user_sessions
(
    h07_session_id         VARCHAR2 (60 BYTE),
    h07_channel_id         NUMBER (5, 0),
    h07_login_id           NUMBER (10, 0),
    h07_auth_status        NUMBER (2, 0),
    h07_login_time         TIMESTAMP (6),
    h07_last_updated       TIMESTAMP (6),
    h07_logout_time        TIMESTAMP (6),
    h07_ip                 VARCHAR2 (20 BYTE),
    h07_expiry_time        TIMESTAMP (6),
    h07_entity_id          NUMBER (7, 0),
    h07_entity_type        NUMBER (2, 0),
    h07_institute_id_m02   NUMBER (3, 0) DEFAULT 1
)
/



COMMENT ON COLUMN dfn_ntp.h07_user_sessions.h07_entity_id IS
    'Ccustomer ID/ User Id'
/
COMMENT ON COLUMN dfn_ntp.h07_user_sessions.h07_entity_type IS
    '1 - Customer / 2 - User'
/

CREATE INDEX dfn_ntp.idx_h07_last_updated
    ON dfn_ntp.h07_user_sessions (h07_last_updated DESC)
/


ALTER TABLE dfn_ntp.h07_user_sessions
 ADD (
  h07_login_date DATE,
  h07_last_upd_date DATE
 )
/

CREATE INDEX dfn_ntp.idx_h07_last_upd_date
    ON dfn_ntp.h07_user_sessions (h07_last_upd_date)
/

ALTER TABLE dfn_ntp.h07_user_sessions
 MODIFY (
  h07_ip VARCHAR2 (30 BYTE)

 )
/

ALTER TABLE dfn_ntp.h07_user_sessions
 ADD (
  h07_operating_system VARCHAR2 (60 BYTE),
  h07_location VARCHAR2 (60 BYTE),
  h07_browser VARCHAR2 (60 BYTE)
  
 )
/
