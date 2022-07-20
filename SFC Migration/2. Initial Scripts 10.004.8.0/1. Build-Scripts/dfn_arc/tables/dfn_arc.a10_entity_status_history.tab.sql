DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.a10_entity_status_history
(
    a10_id                         NUMBER (20, 0) NOT NULL,
    a10_approval_entity_id         NUMBER (20, 0) NOT NULL,
    a10_entity_pk                  VARCHAR2 (255) NOT NULL,
    a10_approval_status_id_v01     NUMBER (20, 0) NOT NULL,
    a10_status_changed_by_id_u17   NUMBER (20, 0) NOT NULL,
    a10_status_changed_date        DATE NOT NULL
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (a10_status_changed_date)
    INTERVAL ( NUMTOYMINTERVAL (1, ''MONTH'') )
    (
        PARTITION a10_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_a10_status_chang_date ON dfn_arc.a10_entity_status_history (a10_status_changed_date) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.a10_entity_status_history TO dfn_ntp
/

GRANT INSERT ON dfn_arc.a10_entity_status_history TO dfn_ntp
/


CREATE INDEX dfn_arc.idx_arc_a10_stat_chn_by_id_u17
    ON dfn_arc.a10_entity_status_history (a10_status_changed_by_id_u17)
/
