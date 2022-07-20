DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.t09_error_records
(
    t09_db_seq_id                  NUMBER (20, 0),
    t09_audit_key                  VARCHAR2 (200),
    t09_col_values                 CLOB,
    created_date                   DATE DEFAULT SYSDATE,
    t09_error                      VARCHAR2 (4000 BYTE),
    t09_original_exchange_ord_id   VARCHAR2 (16) DEFAULT ''0''
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (created_date)
    INTERVAL ( NUMTOYMINTERVAL (3, ''MONTH'') )
    (
        PARTITION t09_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_t09_created_date ON dfn_arc.t09_error_records (created_date DESC) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.t09_error_records TO dfn_ntp
/

GRANT INSERT ON dfn_arc.t09_error_records TO dfn_ntp
/

