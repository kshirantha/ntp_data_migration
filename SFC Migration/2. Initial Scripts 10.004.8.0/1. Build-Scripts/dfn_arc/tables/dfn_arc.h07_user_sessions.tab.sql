DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.h07_user_sessions
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
    h07_institute_id_m02   NUMBER (3, 0) DEFAULT 1,
    h07_login_date         DATE,
    h07_last_upd_date      DATE
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (h07_last_upd_date)
    INTERVAL ( NUMTOYMINTERVAL (1, ''MONTH'') )
    (
        PARTITION h07_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (
                           ADD_MONTHS (
                               LAST_DAY (TRUNC (l_min_partition_date)) + 1,
                               -1),
                           'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_h07_last_updated ON dfn_arc.h07_user_sessions (h07_last_upd_date DESC) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.h07_user_sessions TO dfn_ntp
/

GRANT INSERT ON dfn_arc.h07_user_sessions TO dfn_ntp
/

CREATE INDEX idx_arc_h07_login_time
    ON dfn_arc.h07_user_sessions (h07_login_date)
/

CREATE INDEX idx_arc_h07_login_id
    ON dfn_arc.h07_user_sessions (h07_login_id)
/

CREATE INDEX idx_arc_h07_channel_id
    ON dfn_arc.h07_user_sessions (h07_channel_id)
/

ALTER TABLE dfn_arc.h07_user_sessions
 MODIFY (
  h07_ip VARCHAR2 (30 BYTE)

 )
/

ALTER TABLE dfn_arc.h07_user_sessions
 ADD (
  h07_operating_system VARCHAR2 (60 BYTE),
  h07_location VARCHAR2 (60 BYTE),
  h07_browser VARCHAR2 (60 BYTE)
  
 )
/