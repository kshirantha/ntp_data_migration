DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.t22_order_audit
(
    t22_id                    NUMBER (20, 0) NOT NULL,
    t22_cl_ord_id_t01         NUMBER (18, 0) NOT NULL,
    t22_ord_no_t01            NUMBER (18, 0) NOT NULL,
    t22_date_time             DATE,
    t22_status_id_v30         CHAR (1) NOT NULL,
    t22_exchange_message_id   VARCHAR2 (50),
    t22_performed_by_id_u17   VARCHAR2 (10),
    t22_tenant_code           VARCHAR2 (50),
    t22_institution_id_m02    NUMBER (3, 0) DEFAULT 1
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (t22_date_time)
    INTERVAL ( NUMTOYMINTERVAL (1, ''MONTH'') )
    (
        PARTITION t22_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_t22_date_time ON dfn_arc.t22_order_audit (t22_date_time DESC) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.t22_order_audit TO dfn_ntp
/

GRANT INSERT ON dfn_arc.t22_order_audit TO dfn_ntp
/

ALTER TABLE DFN_ARC.T22_ORDER_AUDIT 
 ADD (
  T22_NARATION VARCHAR2 (500)
 )
/

ALTER TABLE DFN_ARC.T22_ORDER_AUDIT 
 ADD (
  T22_SEQUENCE_ID_T02 NUMBER (20)
 )
/

