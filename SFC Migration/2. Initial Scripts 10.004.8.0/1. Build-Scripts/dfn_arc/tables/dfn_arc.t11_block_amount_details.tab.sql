DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.t11_block_amount_details
(
    t11_trns_id              NUMBER (18, 0) NOT NULL,
    t11_cash_trns_id_t06     NUMBER (18, 0),
    t11_trns_date            DATE,
    t11_value_date           DATE,
    t11_trans_code           VARCHAR2 (10),
    t11_trans_description    VARCHAR2 (100),
    t11_trans_amount         NUMBER (18, 5),
    t11_adjusted_amount      NUMBER (18, 5),
    t11_created_date         DATE,
    t11_created_by           NUMBER (18, 0),
    t11_status               NUMBER (3, 0) DEFAULT 0,
    t11_status_change_date   DATE,
    t11_status_change_by     NUMBER (18, 0),
    t11_id_u06               NUMBER (18, 0) NOT NULL,
    t11_balance_u06          NUMBER (25, 5),
    t11_institute_id_m02     NUMBER (3, 0) DEFAULT 1
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (t11_value_date)
    INTERVAL ( NUMTOYMINTERVAL (3, ''MONTH'') )
    (
        PARTITION t11_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_t11_value_date ON dfn_arc.t11_block_amount_details (t11_value_date DESC) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.t11_block_amount_details TO dfn_ntp
/

GRANT INSERT ON dfn_arc.t11_block_amount_details TO dfn_ntp
/

ALTER TABLE dfn_arc.t11_block_amount_details
 ADD (
  t11_is_archive_ready NUMBER (1, 0) DEFAULT 0 NOT NULL
 )
/

COMMENT ON COLUMN dfn_arc.t11_block_amount_details.t11_is_archive_ready IS
    'flag to check before archive'
/
