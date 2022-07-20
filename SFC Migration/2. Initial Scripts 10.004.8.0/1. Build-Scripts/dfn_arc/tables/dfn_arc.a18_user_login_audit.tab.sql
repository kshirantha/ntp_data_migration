DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.a18_user_login_audit
(
    a18_channel_id_v29     NUMBER (5, 0),
    a18_appsvr_id          NUMBER (5, 0),
    a18_ip                 VARCHAR2 (32),
    a18_login_name         VARCHAR2 (100),
    a18_password           VARCHAR2 (500),
    a18_version            VARCHAR2 (40) DEFAULT NULL,
    a18_login_time         TIMESTAMP (6),
    a18_status_id_v01      NUMBER (5, 0),
    a18_login_id           NUMBER (30, 0),
    a18_narration          VARCHAR2 (250),
    a18_failed_attempts    NUMBER (5, 0) DEFAULT 0,
    a18_password_b         VARCHAR2 (200),
    a18_entity_type        NUMBER (2, 0),
    a18_institute_id_m02   NUMBER (3, 0) DEFAULT 1,
    a18_login_date         DATE
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (a18_login_date)
    INTERVAL ( NUMTOYMINTERVAL (1, ''MONTH'') )
    (
        PARTITION a18_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_a18_login_time ON dfn_arc.a18_user_login_audit (a18_login_date) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.a18_user_login_audit TO dfn_ntp
/

GRANT INSERT ON dfn_arc.a18_user_login_audit TO dfn_ntp
/


CREATE INDEX dfn_arc.idx_arc_a18_login_id
    ON dfn_arc.a18_user_login_audit (a18_login_id)
/

CREATE INDEX dfn_arc.idx_arc_a18_channel_id_v29
    ON dfn_arc.a18_user_login_audit (a18_channel_id_v29)
/
