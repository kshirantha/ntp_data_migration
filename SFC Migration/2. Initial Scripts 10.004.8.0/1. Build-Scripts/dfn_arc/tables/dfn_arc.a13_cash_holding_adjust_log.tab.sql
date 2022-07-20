DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.a13_cash_holding_adjust_log
(
    a13_id                        NUMBER (18, 0) NOT NULL,
    a13_adjust_status             NUMBER (1, 0) DEFAULT 0 NOT NULL,
    a13_job_id_v07                NUMBER (4, 0) NOT NULL,
    a13_created_date              DATE DEFAULT SYSDATE NOT NULL,
    a13_cash_account_id_u06       NUMBER (18, 0),
    a13_u06_balance               NUMBER (25, 10) DEFAULT 0,
    a13_u06_payable_blocked       NUMBER (18, 5) DEFAULT 0,
    a13_u06_receivable_amount     NUMBER (18, 5) DEFAULT 0,
    a13_u06_net_receivable        NUMBER (18, 5) DEFAULT 0,
    a13_u24_trading_acnt_id_u07   NUMBER (18, 0),
    a13_u24_custodian_id_m26      NUMBER (10, 0),
    a13_u24_symbol_id_m20         NUMBER (10, 0),
    a13_u24_receivable_holding    NUMBER (18, 0) DEFAULT 0,
    a13_u24_payable_holding       NUMBER (18, 0) DEFAULT 0,
    a13_u24_net_receivable        NUMBER (18, 0) DEFAULT 0,
    a13_u24_symbol_code_m20       VARCHAR2 (25),
    a13_u24_exchange_code_m01     VARCHAR2 (10),
    a13_code_m97                  VARCHAR2 (10),
    a13_created_date_time         DATE DEFAULT SYSDATE,
    a13_impact_type               NUMBER (1, 0),
    a13_t02_required              NUMBER (1, 0),
    a13_u24_net_holding           NUMBER (18, 0),
    a13_narration                 VARCHAR2 (1000)
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (a13_created_date)
    INTERVAL ( NUMTOYMINTERVAL (3, ''MONTH'') )
    (
        PARTITION a13_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_a13_created_date ON dfn_arc.a13_cash_holding_adjust_log (a13_created_date) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.a13_cash_holding_adjust_log TO dfn_ntp
/

GRANT INSERT ON dfn_arc.a13_cash_holding_adjust_log TO dfn_ntp
/

ALTER TABLE dfn_arc.a13_cash_holding_adjust_log
 ADD (
  a13_fixing_price NUMBER (18, 5),
  a13_initial_margin_value NUMBER (18, 5),
  a13_notional_value NUMBER (18, 5)
 )
/

COMMENT ON COLUMN dfn_arc.A13_CASH_HOLDING_ADJUST_LOG.A13_IMPACT_TYPE IS '1 - Order | 2 - Cash | 3 - Holdings | 4 - Derivative M2M | 5 - Derivative Symbol Expiry'
/

ALTER TABLE dfn_arc.A13_CASH_HOLDING_ADJUST_LOG 
 ADD (
  a13_u06_loan_amount NUMBER (18, 5) DEFAULT 0
 )
/

ALTER TABLE dfn_arc.A13_CASH_HOLDING_ADJUST_LOG 
 ADD (
  A13_FAILED_ATTEMPTS NUMBER (1, 0) DEFAULT 0
 )
/

ALTER TABLE dfn_arc.A13_CASH_HOLDING_ADJUST_LOG 
 ADD (
  A13_FAILED_REASON VARCHAR2 (1000 BYTE)
 )
/

ALTER TABLE dfn_arc.a13_cash_holding_adjust_log
 ADD (
  a13_narration_lang VARCHAR2 (1000)
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := ' ALTER TABLE dfn_arc.a13_cash_holding_adjust_log
 ADD (
  a13_broker_tax NUMBER (18, 5)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('a13_cash_holding_adjust_log')
           AND column_name = UPPER ('a13_broker_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
