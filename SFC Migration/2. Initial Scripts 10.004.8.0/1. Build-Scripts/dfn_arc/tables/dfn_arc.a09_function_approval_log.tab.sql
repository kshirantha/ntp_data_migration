DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.a09_function_approval_log
(
    a09_id                  NUMBER (18, 0) NOT NULL,
    a09_function_id_m88     NUMBER (5, 0) NOT NULL,
    a09_function_name_m88   VARCHAR2 (50) NOT NULL,
    a09_request_id          NUMBER (18, 0) NOT NULL,
    a09_status_id_v01       NUMBER (5, 0) NOT NULL,
    a09_action_by_id_u17    NUMBER (5, 0) NOT NULL,
    a09_action_date         TIMESTAMP (7) NOT NULL,
    a09_created_by_id_u17   NUMBER (5, 0) NOT NULL,
    a09_created_date        DATE NOT NULL,
    a09_narration           VARCHAR2 (100),
    a09_reject_reason       VARCHAR2 (100),
    a09_custom_type         VARCHAR2 (50) DEFAULT 1
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (a09_created_date)
    INTERVAL ( NUMTOYMINTERVAL (3, ''MONTH'') )
    (
        PARTITION a09_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_a09_action_date ON dfn_arc.a09_function_approval_log (a09_created_date) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.a09_function_approval_log TO dfn_ntp
/

GRANT INSERT ON dfn_arc.a09_function_approval_log TO dfn_ntp
/

CREATE INDEX dfn_arc.idx_arc_a09_function_id_m88
    ON dfn_arc.a09_function_approval_log (a09_function_id_m88)
/


CREATE INDEX dfn_arc.idx_arc_a09_action_by_id_u17
    ON dfn_arc.a09_function_approval_log (a09_action_by_id_u17)
/

CREATE INDEX dfn_arc.idx_arc_a09_status_id_v01
    ON dfn_arc.a09_function_approval_log (a09_status_id_v01)
/

CREATE INDEX dfn_arc.idx_arc_a09_request_id
    ON dfn_arc.a09_function_approval_log (a09_request_id)
/