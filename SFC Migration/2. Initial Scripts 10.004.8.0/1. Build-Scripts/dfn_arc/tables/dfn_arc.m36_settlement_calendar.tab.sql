DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.m36_settlement_calendar
(
    m36_buy_cash_settle_date         DATE,
    m36_buy_holdings_settle_date     DATE,
    m36_sell_cash_settle_date        DATE,
    m36_sell_holdings_settle_date    DATE,
    m36_month_end                    DATE,
    m36_week_end                     DATE,
    m36_date                         DATE,
    m36_exchange_code_m01            VARCHAR2 (10 BYTE),
    m36_instrument_type_code_v09     VARCHAR2 (20 BYTE),
    m36_symbol_settle_category_v11   NUMBER (10, 2),
    m36_cust_settle_group_id_m35     NUMBER (10, 2),
    m36_description                  VARCHAR2 (200 BYTE),
    m36_holiday                      NUMBER (1, 0),
    m36_working_day                  NUMBER (5, 0),
    m36_institution_id_m02           NUMBER (5, 0),
    m36_instrument_type_id_v09       NUMBER (10, 0),
    m36_year                         NUMBER (5, 0),
    is_temp_record                   NUMBER (1, 0) DEFAULT 0,
    m36_settle_cal_conf_id_m95       NUMBER (10, 0)
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (m36_date)
    INTERVAL ( NUMTOYMINTERVAL (3, ''MONTH'') )
    (
        PARTITION m36_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Y'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_m36_date ON dfn_arc.m36_settlement_calendar (m36_date DESC) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.m36_settlement_calendar TO dfn_ntp
/

GRANT INSERT ON dfn_arc.m36_settlement_calendar TO dfn_ntp
/

ALTER TABLE dfn_arc.m36_settlement_calendar
 MODIFY (
  m36_date NOT NULL,
  m36_exchange_code_m01 NOT NULL,
  m36_instrument_type_code_v09 NOT NULL,
  m36_symbol_settle_category_v11 NOT NULL,
  m36_cust_settle_group_id_m35 NOT NULL,
  m36_year NOT NULL
 )
/
