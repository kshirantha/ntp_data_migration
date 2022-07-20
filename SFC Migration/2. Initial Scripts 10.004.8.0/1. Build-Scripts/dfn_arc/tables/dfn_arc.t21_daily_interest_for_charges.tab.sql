DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.t21_daily_interest_for_charges
(
    t21_id                        NUMBER (18, 0) NOT NULL,
    t21_cash_account_id_u06       NUMBER (18, 0) NOT NULL,
    t21_charges_id_m97            NUMBER (5, 0) NOT NULL,
    t21_interest_charge_amt       NUMBER (18, 5) NOT NULL,
    t21_created_date              DATE DEFAULT SYSDATE NOT NULL,
    t21_value_date                DATE DEFAULT SYSDATE NOT NULL,
    t21_status                    NUMBER (1, 0) DEFAULT 0 NOT NULL,
    t21_remarks                   VARCHAR2 (2000) DEFAULT NULL,
    t21_cash_transaction_id_t06   NUMBER (18, 0),
    t21_ovedraw_amt               NUMBER (18, 5) DEFAULT 0,
    t21_interest_rate             NUMBER (4, 2),
    t21_posted_date               DATE,
    t21_frequency_id              NUMBER (1, 0) DEFAULT 1,
    t21_charges_code_m97          VARCHAR2 (10),
    t21_created_by_id_u17         NUMBER (18, 0),
    t21_trans_value_date          DATE,
    t21_approved_by_id_u17        NUMBER (18, 0),
    t21_approved_date             DATE,
    t21_custom_type               VARCHAR2 (50) DEFAULT 1,
    t21_institute_id_m02          NUMBER (3, 0) DEFAULT 1,
    t21_custodian_id_m26          NUMBER (5, 0),
    t21_u24_symbol_code_m20       VARCHAR2 (25),
    t21_net_holding               NUMBER (18, 0),
    t21_u24_symbol_id_m20         NUMBER (5, 0),
    t21_u24_exchange_code_m01     VARCHAR2 (10)
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (t21_value_date)
    INTERVAL ( NUMTOYMINTERVAL (3, ''MONTH'') )
    (
        PARTITION t21_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_t21_value_date ON dfn_arc.t21_daily_interest_for_charges (t21_value_date DESC) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.t21_daily_interest_for_charges TO dfn_ntp
/

GRANT INSERT ON dfn_arc.t21_daily_interest_for_charges TO dfn_ntp
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := ' ALTER TABLE dfn_arc.t21_daily_interest_for_charges
 ADD (
  t21_tax_rate_m65 NUMBER (10, 5)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t21_daily_interest_for_charges')
           AND column_name = UPPER ('t21_tax_rate_m65');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := ' ALTER TABLE dfn_arc.t21_daily_interest_for_charges
 ADD (
  t21_tax_amount NUMBER (18, 5)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t21_daily_interest_for_charges')
           AND column_name = UPPER ('t21_tax_amount');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t21_daily_interest_for_charges RENAME COLUMN t21_tax_rate_m65 TO t21_tax_rate';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t21_daily_interest_for_charges')
           AND column_name = UPPER ('t21_tax_rate_m65');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_arc.t21_daily_interest_for_charges.t21_tax_rate IS
    'Tax rate from M65 or M118'
/

ALTER TABLE dfn_arc.t21_daily_interest_for_charges MODIFY (t21_u24_symbol_id_m20 NUMBER (10))
/
