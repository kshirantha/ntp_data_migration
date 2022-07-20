DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.a06_audit
(
    a06_id                  NUMBER (38, 0),
    a06_date                DATE DEFAULT SYSDATE NOT NULL,
    a06_user_id_u17         NUMBER (10, 0) NOT NULL,
    a06_activity_id_m82     NUMBER (7, 0) NOT NULL,
    a06_description         VARCHAR2 (2000),
    a06_reference_no        VARCHAR2 (400),
    a06_channel_v29         NUMBER (3, 0),
    a06_customer_id_u01     NUMBER (18, 0),
    a06_login_id_u09        NUMBER (20, 0),
    a06_user_login_id_u17   NUMBER (20, 0),
    a06_ip                  VARCHAR2 (100),
    a06_connected_machine   VARCHAR2 (100),
    a06_custom_type         VARCHAR2 (50) DEFAULT 1,
    a06_institute_id_m02    NUMBER (3, 0) DEFAULT 1
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (a06_date)
    INTERVAL ( NUMTOYMINTERVAL (1, ''MONTH'') )
    (
        PARTITION a06_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_a06_date ON dfn_arc.a06_audit (a06_date) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.a06_audit TO dfn_ntp
/

GRANT INSERT ON dfn_arc.a06_audit TO dfn_ntp
/

CREATE INDEX dfn_arc.idx_arc_a06_user_id_u17
    ON dfn_arc.a06_audit (a06_user_id_u17)
/
