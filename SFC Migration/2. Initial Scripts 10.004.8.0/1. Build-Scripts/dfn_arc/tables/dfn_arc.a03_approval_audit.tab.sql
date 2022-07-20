DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.a03_approval_audit
(
    a03_id                       NUMBER (18, 0),
    a03_table                    VARCHAR2 (50),
    a03_table_row_id             NUMBER (10, 0),
    a03_status_id_v01            NUMBER (5, 0),
    a03_where_clause             VARCHAR2 (200),
    a03_created_date             DATE,
    a03_last_updated_date        DATE,
    a03_class                    VARCHAR2 (1000),
    a03_current_approval_level   NUMBER (2, 0),
    a03_no_of_approval           NUMBER (2, 0),
    a03_new_value                CLOB,
    a03_current_value            CLOB,
    a03_ready_to_save_value      CLOB,
    a03_description              VARCHAR2 (250),
    a03_is_approval_completed    NUMBER (1, 0) DEFAULT 0,
    a03_table_id_m53             NUMBER (5, 0),
    a03_table_description        VARCHAR2 (100),
    a03_display_code             VARCHAR2 (50),
    a03_next_status_id_v01       NUMBER (3, 0),
    a03_approval_type            NUMBER (1, 0),
    a03_created_by_id_u17        NUMBER (5, 0),
    a03_last_updated_by_id_u17   NUMBER (5, 0),
    a03_comment                  VARCHAR2 (100),
    a03_custom_type              VARCHAR2 (50) DEFAULT 1,
    a03_institute_id_m02         NUMBER (5, 0)
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (a03_last_updated_date)
    INTERVAL ( NUMTOYMINTERVAL (3, ''MONTH'') )
    (
        PARTITION a03_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_a03_last_update_date ON dfn_arc.a03_approval_audit (a03_last_updated_date) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.a03_approval_audit TO dfn_ntp
/

GRANT INSERT ON dfn_arc.a03_approval_audit TO dfn_ntp
/
/


CREATE INDEX dfn_arc.idx_arc_a03_table
    ON dfn_arc.a03_approval_audit (a03_table)
/

CREATE INDEX dfn_arc.idx_arc_a03_status_id_v01
    ON dfn_arc.a03_approval_audit (a03_status_id_v01)
/

CREATE INDEX dfn_arc.idx_arc_a03_institute_id_m02
    ON dfn_arc.a03_approval_audit (a03_institute_id_m02)
/

CREATE INDEX dfn_arc.idx_arc_a03_id
    ON dfn_arc.a03_approval_audit (a03_id)
/

CREATE INDEX dfn_arc.idx_arc_a03_table_id_m53
    ON dfn_arc.a03_approval_audit (a03_table_id_m53)
/

ALTER TABLE dfn_arc.a03_approval_audit
 MODIFY (
  a03_id NOT NULL
 )
/
