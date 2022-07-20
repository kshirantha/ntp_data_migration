CREATE TABLE dfn_ntp.u46_user_sessions
(
    u46_session_id         VARCHAR2 (60 BYTE) NOT NULL,
    u46_channel_id_v29     NUMBER (5, 0),
    u46_login_id_u09       NUMBER (10, 0) NOT NULL,
    u46_auth_status        NUMBER (3, 0),
    u46_login_time         TIMESTAMP (6),
    u46_last_updated       TIMESTAMP (6),
    u46_ip                 VARCHAR2 (20 BYTE),
    u46_expiry_time        TIMESTAMP (6),
    u46_entity_id          NUMBER (7, 0),
    u46_entity_type        NUMBER (2, 0),
    u46_institute_id_m02   NUMBER (3, 0) DEFAULT 1
)
/



ALTER TABLE dfn_ntp.u46_user_sessions
ADD CONSTRAINT uk_u46 UNIQUE (u46_channel_id_v29, u46_login_id_u09,
  u46_entity_type)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.u46_user_sessions.u46_entity_id IS
    'Ccustomer ID/ User Id'
/
COMMENT ON COLUMN dfn_ntp.u46_user_sessions.u46_entity_type IS
    '1 - Customer / 2 - User'
/

ALTER TABLE dfn_ntp.u46_user_sessions
 ADD (
  u46_login_date DATE,
  u46_last_upd_date DATE
 )
/

ALTER TABLE dfn_ntp.u46_user_sessions
 MODIFY (
  u46_ip VARCHAR2 (30 BYTE)

 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE dfn_ntp.u46_user_sessions
 ADD (
  u46_operating_system VARCHAR2 (20)
 )
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('u46_user_sessions')
           AND column_name = UPPER ('u46_operating_system');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE dfn_ntp.u46_user_sessions
 ADD (
  U46_LOCATION VARCHAR2 (50)
 )
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('u46_user_sessions')
           AND column_name = UPPER ('U46_LOCATION');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE dfn_ntp.u46_user_sessions
 ADD (
  U46_BROWSER VARCHAR2 (20)
 )
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('u46_user_sessions')
           AND column_name = UPPER ('U46_BROWSER');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
