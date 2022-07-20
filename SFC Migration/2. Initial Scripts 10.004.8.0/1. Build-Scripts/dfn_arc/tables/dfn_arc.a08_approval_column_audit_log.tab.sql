DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.a08_approval_column_audit_log
(
    a08_id                      NUMBER (18, 0),
    a08_approval_audit_id_a07   NUMBER (18, 0),
    a08_table_id_m53            NUMBER (5, 0),
    a08_table_row_id            NUMBER (10, 0),
    a08_status_id_v01           NUMBER (5, 0),
    a08_action_by_id_u17        NUMBER (7, 0),
    a08_action_date             DATE,
    a08_created_by_id_u17       NUMBER (5, 0),
    a08_created_date            DATE,
    a08_custom_type             VARCHAR2 (50) DEFAULT 1,
    a08_institute_id_m02        NUMBER (5, 0)
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (a08_action_date)
    INTERVAL ( NUMTOYMINTERVAL (3, ''MONTH'') )
    (
        PARTITION a08_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_a08_action_date ON dfn_arc.a08_approval_column_audit_log (a08_action_date) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.a08_approval_column_audit_log TO dfn_ntp
/

GRANT INSERT ON dfn_arc.a08_approval_column_audit_log TO dfn_ntp
/

CREATE INDEX dfn_arc.idx_arc_a08_app_audit_id_a07
    ON dfn_arc.a08_approval_column_audit_log (a08_approval_audit_id_a07)
/
