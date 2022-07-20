DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.a04_approval_audit_log
(
    a04_id                       NUMBER (18, 0),
    a04_table_row_id             NUMBER (10, 0),
    a04_status_id_v01            NUMBER (5, 0),
    a04_action_by_id_u17         NUMBER (5, 0),
    a04_approval_master_id_a03   NUMBER (18, 0),
    a04_table_id_m53             NUMBER (5, 0),
    a04_created_by_id_u17        NUMBER (5, 0),
    a04_created_date             DATE,
    a04_action_date              DATE,
    a04_custom_type              VARCHAR2 (50) DEFAULT 1,
    a04_institute_id_m02         NUMBER (5, 0)
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (a04_created_date)
    INTERVAL ( NUMTOYMINTERVAL (3, ''MONTH'') )
    (
        PARTITION a04_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_a04_created_date ON dfn_arc.a04_approval_audit_log (a04_created_date) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.a04_approval_audit_log TO dfn_ntp
/

GRANT INSERT ON dfn_arc.a04_approval_audit_log TO dfn_ntp
/

CREATE INDEX dfn_arc.idx_arc_a04_id
    ON dfn_arc.a04_approval_audit_log (a04_id)
/

CREATE INDEX dfn_arc.idx_arc_a04_appr_master_id_a03
    ON dfn_arc.a04_approval_audit_log (a04_approval_master_id_a03)
/

CREATE INDEX dfn_arc.idx_arc_a04_status_id_v01
    ON dfn_arc.a04_approval_audit_log (a04_status_id_v01)
/

ALTER TABLE dfn_arc.a04_approval_audit_log
 MODIFY (
  a04_id NOT NULL
 )
/
