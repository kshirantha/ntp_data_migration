DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.t02_transaction_log
(
    t02_amnt_in_txn_currency        NUMBER (18, 5),
    t02_amnt_in_stl_currency        NUMBER (18, 5),
    t02_cash_acnt_id_u06            NUMBER (10, 0),
    t02_cash_block                  NUMBER (18, 5),
    t02_cash_block_orig             NUMBER (18, 5),
    t02_cash_block_adjst            NUMBER (18, 5),
    t02_cash_balance                NUMBER (18, 5),
    t02_cash_acnt_seq_id            VARCHAR2 (20),
    t02_trd_acnt_id_u07             NUMBER (10, 0),
    t02_holding_net                 NUMBER (18, 0),
    t02_holding_block               NUMBER (18, 0),
    t02_holding_block_adjst         NUMBER (18, 0),
    t02_holding_net_adjst           NUMBER (18, 0),
    t02_symbol_code_m20             VARCHAR2 (25),
    t02_exchange_code_m01           VARCHAR2 (10),
    t02_custodian_id_m26            NUMBER (10, 0),
    t02_holding_avg_cost            NUMBER (18, 5),
    t02_inst_id_m02                 NUMBER (5, 0),
    t02_txn_entry_status            VARCHAR2 (10) DEFAULT 0 NOT NULL,
    t02_last_shares                 NUMBER (18, 0),
    t02_create_datetime             DATE,
    t02_create_date                 DATE,
    t02_cliordid_t01                VARCHAR2 (50),
    t02_last_price                  NUMBER (18, 5),
    t02_avgprice                    NUMBER (18, 5),
    t02_cum_commission              NUMBER (18, 5),
    t02_commission_adjst            NUMBER (18, 5),
    t02_order_no                    VARCHAR2 (50),
    t02_order_exec_id               VARCHAR2 (50),
    t02_txn_currency                VARCHAR2 (10),
    t02_settle_currency             VARCHAR2 (10),
    t02_exg_commission              NUMBER (18, 5),
    t02_txn_code                    VARCHAR2 (50),
    t02_fx_rate                     NUMBER (18, 5),
    t02_gl_posted_date              DATE,
    t02_gl_posted_status            NUMBER (5, 0),
    t02_discount                    NUMBER (18, 5),
    t02_cashtxn_id                  NUMBER (18, 0),
    t02_holdingtxn_id               NUMBER (18, 0),
    t02_customer_id_u01             NUMBER (18, 0),
    t02_customer_no                 VARCHAR2 (100),
    t02_ordqty                      NUMBER (18, 0),
    t02_pay_method                  VARCHAR2 (50),
    t02_narration                   VARCHAR2 (500),
    t02_cash_settle_date            DATE,
    t02_holding_settle_date         DATE,
    t02_buy_pending                 NUMBER (18, 0),
    t02_sell_pending                NUMBER (18, 0),
    t02_instrument_type             VARCHAR2 (10),
    t02_cum_qty                     NUMBER (18, 0),
    t02_holding_manual_block        NUMBER (18, 0),
    t02_possision_type              NUMBER (5, 0),
    t02_accrude_interest            NUMBER (18, 5),
    t02_accrude_interest_adjst      NUMBER (18, 5),
    t02_counter_broker              VARCHAR2 (50),
    t02_txn_time                    TIMESTAMP (3),
    t02_leaves_qty                  NUMBER (18, 0),
    t02_text                        VARCHAR2 (500),
    t02_cumord_value                NUMBER (18, 5),
    t02_cumord_netvalue             NUMBER (18, 5),
    t02_cumord_netsettle            NUMBER (18, 5),
    t02_audit_key                   VARCHAR2 (200),
    t02_pledge_qty                  NUMBER (18, 0),
    t02_side                        NUMBER (5, 0),
    t02_symbol_id_m20               NUMBER (5, 0),
    t02_gainloss                    NUMBER (18, 5),
    t02_broker_tax                  NUMBER (18, 5) DEFAULT 0,
    t02_exchange_tax                NUMBER (18, 5) DEFAULT 0,
    t02_update_type                 NUMBER (1, 0),
    t02_db_create_date              DATE,
    t02_ord_status_v30              VARCHAR2 (2),
    t02_fail_management_status      NUMBER (1, 0) DEFAULT 0,
    t02_ord_value_adjst             NUMBER (18, 5),
    t02_trade_match_id              VARCHAR2 (100),
    t02_exg_ord_id                  VARCHAR2 (18),
    t02_act_broker_tax              NUMBER (18, 5),
    t02_act_exchange_tax            NUMBER (18, 5),
    t02_cash_settle_date_orig       DATE,
    t02_holding_settle_date_orig    DATE,
    t02_ib_commission               NUMBER (18, 5),
    t02_custodian_type_v01          NUMBER (2, 0) DEFAULT 0,
    t02_base_symbol_code_m20        VARCHAR2 (10),
    t02_base_sym_exchange_m01       VARCHAR2 (10),
    t02_base_holding_block          NUMBER (18, 0) DEFAULT 0,
    t02_unsettle_qty                NUMBER (15, 0) DEFAULT 0,
    t02_cash_balance_orig           NUMBER (18, 5),
    t02_trade_process_stat_id_v01   NUMBER (5, 0) DEFAULT 25,
    t02_last_db_seq_id              NUMBER (20, 0),
    t02_bank_id_m93                 VARCHAR2 (18),
    t02_settle_cal_conf_id_m95      NUMBER (10, 0),
    t02_original_exchange_ord_id    VARCHAR2 (16),
    t02_trade_confirm_no            NUMBER (20, 0),
    t02_origin_txn_id               VARCHAR2 (50),
    t02_txn_refrence_id             VARCHAR2 (50),
    t02_allocated_qty               NUMBER (18, 0) DEFAULT 0,
    t02_exec_broker_id_m26          NUMBER (10, 0),
    t02_option_base_holding_block   NUMBER (18, 0),
    t02_option_base_cash_block      NUMBER (18, 0),
    t02_reference_type              VARCHAR2 (200),
    t02_master_ref                  NUMBER (20, 0)
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (t02_create_date)
    INTERVAL ( NUMTOYMINTERVAL (1, ''MONTH'') )
    (
        PARTITION t01_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_t02_create_date ON dfn_arc.t02_transaction_log (t02_create_date DESC) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.t02_transaction_log TO dfn_ntp
/

GRANT INSERT ON dfn_arc.t02_transaction_log TO dfn_ntp
/

CREATE INDEX dfn_arc.idx_arc_t02_txn_code
    ON dfn_arc.t02_transaction_log (t02_txn_code)
/

CREATE INDEX dfn_arc.idx_arc_t02_exchange_code_m01
    ON dfn_arc.t02_transaction_log (t02_exchange_code_m01)
/

CREATE INDEX dfn_arc.idx_arc_t02_txn_time
    ON dfn_arc.t02_transaction_log (t02_txn_time)
/

CREATE INDEX dfn_arc.idx_arc_t02_inst_id_m02
    ON dfn_arc.t02_transaction_log (t02_inst_id_m02)
/

CREATE INDEX dfn_arc.idx_arc_t02_cliordid_t01
    ON dfn_arc.t02_transaction_log (t02_cliordid_t01)
/

CREATE INDEX dfn_arc.idx_arc_t02_order_no
    ON dfn_arc.t02_transaction_log (t02_order_no)
/

CREATE INDEX dfn_arc.idx_arc_t02_symbol_code_m20
    ON dfn_arc.t02_transaction_log (t02_symbol_code_m20)
/

CREATE INDEX dfn_arc.idx_arc_t02_trd_acnt_id_u07
    ON dfn_arc.t02_transaction_log (t02_trd_acnt_id_u07)
/

CREATE INDEX dfn_arc.idx_arc_t02_cash_settle_date
    ON dfn_arc.t02_transaction_log (t02_cash_settle_date)
/

CREATE INDEX dfn_arc.idx_arc_t02_update_type
    ON dfn_arc.t02_transaction_log (t02_update_type)
/

CREATE INDEX dfn_arc.idx_arc_t02_cash_acnt_id_u06
    ON dfn_arc.t02_transaction_log (t02_cash_acnt_id_u06)
/

ALTER TABLE DFN_ARC.T02_TRANSACTION_LOG 
 ADD (
  T02_ORIG_EXG_TAX NUMBER (20, 5),
  T02_ORIG_BRK_TAX NUMBER (20, 5)
 )
/

ALTER TABLE dfn_arc.t02_transaction_log
 ADD (
  t02_is_archive_ready NUMBER (1, 0) DEFAULT 0
 )
/

COMMENT ON COLUMN dfn_arc.t02_transaction_log.t02_is_archive_ready IS
    'flag to check before archive'
/


ALTER TABLE dfn_arc.t02_transaction_log
 ADD (
  t02_fixing_price NUMBER (18, 5),
  t02_m2m_gain NUMBER (18, 5),
  t02_initial_margin_charge NUMBER (18, 5),
  t02_notional_value NUMBER (18, 5)
 )
/

ALTER TABLE dfn_arc.t02_transaction_log
 ADD (
  t02_exec_initial_margin_value NUMBER (18, 5),
  t02_exec_maintain_margin_value NUMBER (18, 5)
 )
/

ALTER TABLE dfn_arc.T02_TRANSACTION_LOG 
 ADD (
  t02_loan_amount NUMBER (18, 5)
 )
/
COMMENT ON COLUMN dfn_arc.T02_TRANSACTION_LOG.t02_loan_amount IS 'u06_loan_amount'
/

ALTER TABLE dfn_arc.t02_transaction_log 
 MODIFY ( 
  t02_symbol_id_m20 NUMBER(10, 0),
  t02_symbol_code_m20 VARCHAR(50),
  t02_base_symbol_code_m20 VARCHAR(50)
)
/

ALTER TABLE dfn_arc.T02_TRANSACTION_LOG 
 ADD (
  t02_withdr_overdrawn_amt NUMBER (18, 5),
  t02_incident_overdrawn_amt NUMBER (18, 5)
 )
/
COMMENT ON COLUMN dfn_arc.T02_TRANSACTION_LOG.t02_withdr_overdrawn_amt IS 'u06_withdr_overdrawn_amt'
/
COMMENT ON COLUMN dfn_arc.T02_TRANSACTION_LOG.t02_incident_overdrawn_amt IS 'u06_incident_overdrawn_amt'
/

ALTER TABLE dfn_arc.t02_transaction_log
 MODIFY (
  t02_exg_ord_id VARCHAR2 (25 BYTE),
  t02_last_price NUMBER (20, 5) DEFAULT 0

 )
/

ALTER TABLE dfn_arc.t02_transaction_log
 ADD (
  t02_exchange_id_m01 NUMBER (10, 0)
)
/

ALTER TABLE dfn_arc.t02_transaction_log
 MODIFY (
  t02_original_exchange_ord_id VARCHAR2 (25 BYTE)
 )
/

DECLARE
    l_count       NUMBER := 0;
    l_ddl_temp    VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t02_transaction_log ADD (t02_master_ref_temp VARCHAR2 (100))';
    l_dml         VARCHAR2 (1000)
        := 'UPDATE dfn_arc.t02_transaction_log SET t02_master_ref_temp = t02_master_ref';
    l_ddl_alter   VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t02_transaction_log MODIFY ( t02_master_ref VARCHAR2 (100))';
    l_dml_1       VARCHAR2 (1000)
        := 'UPDATE dfn_arc.t02_transaction_log SET t02_master_ref = t02_master_ref_temp';
    l_ddl_del     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t02_transaction_log DROP COLUMN t02_master_ref_temp';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
    WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t02_transaction_log')
           AND column_name = UPPER ('t02_master_ref');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl_temp;

        EXECUTE IMMEDIATE l_dml;


        UPDATE dfn_arc.t02_transaction_log
           SET t02_master_ref = NULL;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_alter;

        EXECUTE IMMEDIATE l_dml_1;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_del;
    END IF;
END;
 /
 
ALTER TABLE dfn_arc.t02_transaction_log
ADD (
  t02_ord_channel_id_v29 NUMBER (5, 0)
)
/

ALTER TABLE dfn_arc.t02_transaction_log
ADD (
  t02_dealer_id_u17 NUMBER (5, 0)
)
/

CREATE INDEX dfn_arc.idx_arc_t02_exchange_id_m01
    ON dfn_arc.t02_transaction_log (t02_exchange_id_m01)
/

ALTER TABLE dfn_arc.t02_transaction_log
 MODIFY (
  t02_narration VARCHAR2 (500)
 )
 ADD (
  t02_narration_lang VARCHAR2 (500)
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t02_transaction_log ADD (  t02_algo_commission NUMBER (18, 5) DEFAULT 0 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t02_transaction_log')
           AND column_name = UPPER ('t02_algo_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t02_transaction_log ADD (  t02_algo_tax NUMBER (18, 5) DEFAULT 0 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t02_transaction_log')
           AND column_name = UPPER ('t02_algo_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t02_transaction_log ADD (  t02_algo_cum_commission NUMBER (18, 5) DEFAULT 0 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t02_transaction_log')
           AND column_name = UPPER ('t02_algo_cum_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t02_transaction_log ADD (  t02_algo_cum_tax NUMBER (18, 5) DEFAULT 0 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t02_transaction_log')
           AND column_name = UPPER ('t02_algo_cum_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t02_transaction_log ADD (  t02_exec_algo_commission NUMBER (18, 5) DEFAULT 0 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t02_transaction_log')
           AND column_name = UPPER ('t02_exec_algo_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t02_transaction_log ADD (  t02_exec_algo_tax NUMBER (18, 5) DEFAULT 0 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t02_transaction_log')
           AND column_name = UPPER ('t02_exec_algo_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t02_transaction_log RENAME COLUMN t02_algo_commission TO t02_other_commission';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t02_transaction_log')
           AND column_name = UPPER ('t02_algo_commission');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t02_transaction_log RENAME COLUMN t02_algo_tax TO t02_other_tax';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t02_transaction_log')
           AND column_name = UPPER ('t02_algo_tax');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t02_transaction_log RENAME COLUMN t02_algo_cum_commission TO t02_other_cum_commission';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t02_transaction_log')
           AND column_name = UPPER ('t02_algo_cum_commission');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t02_transaction_log RENAME COLUMN t02_algo_cum_tax TO t02_other_cum_tax';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t02_transaction_log')
           AND column_name = UPPER ('t02_algo_cum_tax');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t02_transaction_log RENAME COLUMN t02_exec_algo_commission TO t02_exec_other_commission';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t02_transaction_log')
           AND column_name = UPPER ('t02_exec_algo_commission');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t02_transaction_log RENAME COLUMN t02_exec_algo_tax TO t02_exec_other_tax';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t02_transaction_log')
           AND column_name = UPPER ('t02_exec_algo_tax');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/



DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t02_transaction_log ADD (  t02_eod_bulk_post_b NUMBER (1, 0) DEFAULT 0)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t02_transaction_log')
           AND column_name = UPPER ('t02_eod_bulk_post_b');


    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_arc.t02_transaction_log.t02_eod_bulk_post_b IS
    '1=EOD Picked, 2=Update B2B, 3=Update GL'
/