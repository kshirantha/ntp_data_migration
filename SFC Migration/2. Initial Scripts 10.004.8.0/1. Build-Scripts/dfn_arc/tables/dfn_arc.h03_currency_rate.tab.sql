DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.h03_currency_rate
(
    h03_from_currency_code_m03   CHAR (3 BYTE) NOT NULL,
    h03_to_currency_code_m03     CHAR (3 BYTE) NOT NULL,
    h03_rate                     NUMBER (13, 8) NOT NULL,
    h03_buy_rate                 NUMBER (13, 8) NOT NULL,
    h03_sell_rate                NUMBER (13, 8) NOT NULL,
    h03_spread                   NUMBER (13, 8) NOT NULL,
    h03_institute_id_m02         NUMBER (3, 0) NOT NULL,
    h03_status_id_v01            NUMBER (5, 0) NOT NULL,
    h03_id                       NUMBER (5, 0),
    h03_from_currency_id_m03     NUMBER (5, 0) NOT NULL,
    h03_to_currency_id_m03       NUMBER (5, 0) NOT NULL,
    h03_date                     DATE
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (h03_date)
    INTERVAL ( NUMTOYMINTERVAL (3, ''MONTH'') )
    (
        PARTITION h03_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_h03_date ON dfn_arc.h03_currency_rate (h03_date DESC) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.h03_currency_rate TO dfn_ntp
/

GRANT INSERT ON dfn_arc.h03_currency_rate TO dfn_ntp
/


ALTER TABLE dfn_arc.h03_currency_rate
 ADD (
  h03_category_m89 NUMBER (5) DEFAULT 0
 )
/

COMMENT ON COLUMN dfn_arc.h03_currency_rate.h03_category_m89 IS
    'fk m89_id | 0 - Default | 1 - Staff'
/

ALTER TABLE dfn_arc.h03_currency_rate
RENAME COLUMN h03_category_m89 TO h03_category_v01
/

COMMENT ON COLUMN dfn_arc.h03_currency_rate.h03_category_v01 IS
    'v01_type = 86 | 0 - Default | 1 - Staff'
/
