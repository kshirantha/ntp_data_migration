DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.a07_approval_column_audit
(
    a07_id                       NUMBER (18, 0),
    a07_table                    VARCHAR2 (50),
    a07_table_row_id             NUMBER (10, 0),
    a07_status_id_v01            NUMBER (5, 0),
    a07_next_status_id_v01       NUMBER (5, 0),
    a07_current_approval_level   NUMBER (2, 0),
    a07_no_of_approval           NUMBER (2, 0),
    a07_is_approval_completed    NUMBER (1, 0),
    a07_table_id_m53             NUMBER (10, 0),
    a07_table_description        VARCHAR2 (50),
    a07_column_description_m83   VARCHAR2 (100),
    a07_column_name_m83          VARCHAR2 (50),
    a07_current_value            VARCHAR2 (2000),
    a07_new_value                VARCHAR2 (2000),
    a07_last_updated_date        DATE,
    a07_last_update_by_id_u17    NUMBER (5, 0),
    a07_class                    VARCHAR2 (100),
    a07_line_id_a03              NUMBER (18, 0),
    a07_created_date             DATE,
    a07_created_by_id_u17        NUMBER (5, 0),
    a07_comment                  VARCHAR2 (100),
    a07_action_on_approval       NUMBER (1, 0),
    a07_use_a03_ready_to_save    NUMBER (1, 0) DEFAULT 1,
    a07_ready_to_save_value      CLOB,
    a07_custom_type              VARCHAR2 (50) DEFAULT 1,
    a07_institute_id_m02         NUMBER (5, 0),
    a07_dependant_no             NUMBER (2, 0)
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (a07_last_updated_date)
    INTERVAL ( NUMTOYMINTERVAL (3, ''MONTH'') )
    (
        PARTITION a07_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_a07_last_updated_date ON dfn_arc.a07_approval_column_audit (a07_last_updated_date) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.a07_approval_column_audit TO dfn_ntp
/

GRANT INSERT ON dfn_arc.a07_approval_column_audit TO dfn_ntp
/

ALTER TABLE dfn_arc.a07_approval_column_audit
 ADD (
  a07_is_sensitive_data NUMBER (1, 0) DEFAULT 0,
  a07_entitlement_id_v04 NUMBER
 )
/

CREATE INDEX dfn_arc.idx_arc_a07_id
    ON dfn_arc.a07_approval_column_audit (a07_id)
/

CREATE INDEX dfn_arc.idx_arc_a07_line_id_a03
    ON dfn_arc.a07_approval_column_audit (a07_line_id_a03)
/

CREATE INDEX dfn_arc.idx_arc_a07_dependant_no
    ON dfn_arc.a07_approval_column_audit (a07_dependant_no)
/

ALTER TABLE dfn_arc.a07_approval_column_audit
 MODIFY (
  a07_id NOT NULL
 )
/
