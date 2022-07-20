DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.t58_cache_clear_request
(
    t58_id                NUMBER (10, 0),
    t58_table_id          VARCHAR2 (100),
    t58_store_keys_json   VARCHAR2 (1000),
    t58_clear_all         NUMBER (2, 0) DEFAULT 0,
    t58_custom_type       NUMBER (1, 0) DEFAULT 1,
    t58_status            NUMBER (3, 0) DEFAULT 0,
    t58_created_date      TIMESTAMP (6) DEFAULT SYSDATE
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (t58_created_date)
    INTERVAL ( NUMTOYMINTERVAL (3, ''MONTH'') )
    (
        PARTITION t58_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_t58_created_date ON dfn_arc.t58_cache_clear_request (t58_created_date DESC) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.t58_cache_clear_request TO dfn_ntp
/

GRANT INSERT ON dfn_arc.t58_cache_clear_request TO dfn_ntp
/

