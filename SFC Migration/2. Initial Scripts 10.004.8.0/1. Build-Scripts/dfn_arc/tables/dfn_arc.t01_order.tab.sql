DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.t01_order
(
    t01_ord_no                      VARCHAR2 (22) NOT NULL,
    t01_date_time                   TIMESTAMP (6),
    t01_date                        DATE,
    t01_cl_ord_id                   VARCHAR2 (22) NOT NULL,
    t01_orig_cl_ord_id              VARCHAR2 (17),
    t01_exchange_ord_id             VARCHAR2 (16),
    t01_remote_cl_ord_id            VARCHAR2 (22),
    t01_remote_orig_cl_ord_id       VARCHAR2 (22),
    t01_trading_acc_id_u07          NUMBER (10, 0) NOT NULL,
    t01_symbol_id_m20               NUMBER (5, 0) NOT NULL,
    t01_ord_type_id_v06             VARCHAR2 (2),
    t01_side                        NUMBER (5, 0) NOT NULL,
    t01_quantity                    NUMBER (15, 0) NOT NULL,
    t01_price                       NUMBER (25, 10) DEFAULT 0,
    t01_min_quantity                NUMBER (15, 0),
    t01_market_code_m29             VARCHAR2 (10),
    t01_status_id_v30               CHAR (1) NOT NULL,
    t01_ord_channel_id_v29          NUMBER (2, 0),
    t01_instruction_type            NUMBER (1, 0),
    t01_commission                  NUMBER (25, 10) DEFAULT 0 NOT NULL,
    t01_orig_commission             NUMBER (25, 10) DEFAULT 0,
    t01_discount                    NUMBER (25, 10) DEFAULT 0,
    t01_exec_brk_commission         NUMBER (25, 10) DEFAULT 0,
    t01_avg_price                   NUMBER (25, 10) DEFAULT 0,
    t01_block_amount                NUMBER (25, 10) DEFAULT 0,
    t01_settle_currency_rate        NUMBER (25, 10),
    t01_expiry_date                 DATE,
    t01_dealer_id_u17               NUMBER (10, 0),
    t01_customer_login_id_u09       NUMBER (10, 0),
    t01_cum_quantity                NUMBER (15, 0) DEFAULT 0,
    t01_cum_ord_value               NUMBER (25, 10) DEFAULT 0,
    t01_cum_commission              NUMBER (25, 10) DEFAULT 0,
    t01_cum_exec_brk_commission     NUMBER (25, 10) DEFAULT 0,
    t01_cum_accrued_interest        NUMBER (25, 10) DEFAULT 0,
    t01_accrued_interest            NUMBER (25, 10) DEFAULT 0,
    t01_exec_broker_id_m26          NUMBER (5, 0),
    t01_custodian_id_m26            NUMBER (5, 0),
    t01_emp_trading_id_u19          NUMBER (10, 0),
    t01_position_effect             VARCHAR2 (5),
    t01_remarks                     VARCHAR2 (250),
    t01_last_updated_date_time      TIMESTAMP (6),
    t01_tag_remote_sub_comp_id      VARCHAR2 (50),
    t01_remote_tag_22               VARCHAR2 (50),
    t01_remote_tag_100              VARCHAR2 (50),
    t01_remote_sid                  VARCHAR2 (20),
    t01_cum_netstl                  NUMBER (25, 10) DEFAULT 0,
    t01_tenant_code                 VARCHAR2 (15),
    t01_cash_acc_id_u06             NUMBER (10, 0) NOT NULL,
    t01_instrument_type_code        VARCHAR2 (4),
    t01_order_mode                  NUMBER (1, 0),
    t01_fix_msg_type                VARCHAR2 (10),
    t01_disclose_qty                NUMBER (10, 0),
    t01_price_inst_type             NUMBER (3, 0),
    t01_ord_exec_seq                NUMBER (20, 0),
    t01_db_created_date             DATE,
    t01_last_updated_by             VARCHAR2 (30),
    t01_db_last_updated_date        DATE,
    t01_last_db_seq_id              NUMBER (20, 0),
    t01_exchange_code_m01           VARCHAR2 (15),
    t01_customer_id_u01             NUMBER (10, 0),
    t01_tif_id_v10                  NUMBER (10, 0),
    t01_symbol_code_m20             VARCHAR2 (25),
    t01_exec_instruction            VARCHAR2 (50),
    t01_brker_fix_id                VARCHAR2 (100),
    t01_trading_acntno_u07          VARCHAR2 (50),
    t01_ord_value                   NUMBER (25, 10) DEFAULT 0,
    t01_ord_net_value               NUMBER (25, 10) DEFAULT 0,
    t01_ord_net_settle              NUMBER (25, 10) DEFAULT 0,
    t01_settle_currency             VARCHAR2 (5),
    t01_gainloss                    NUMBER (18, 5) DEFAULT 0,
    t01_is_active_order             NUMBER (1, 0),
    t01_fail_mngmnt_status          NUMBER (1, 0) DEFAULT 0,
    t01_fail_mngmnt_clord_id        VARCHAR2 (50),
    t01_fail_mngmnt_exec_id         VARCHAR2 (100),
    t01_reject_reason               VARCHAR2 (500),
    t01_symbol_currency_code_m03    VARCHAR2 (5),
    t01_profit_loss_for_this_exec   NUMBER (18, 5) DEFAULT 0,
    t01_profit_loss                 NUMBER (18, 5) DEFAULT 0,
    t01_broker_tax                  NUMBER (18, 5) DEFAULT 0,
    t01_exchange_tax                NUMBER (18, 5) DEFAULT 0,
    t01_cum_broker_tax              NUMBER (18, 5) DEFAULT 0,
    t01_cum_exchange_tax            NUMBER (18, 5) DEFAULT 0,
    t01_leaves_qty                  NUMBER (15, 0) DEFAULT 0,
    t01_server_id                   VARCHAR2 (2),
    t01_last_shares                 NUMBER (15, 0) DEFAULT 0,
    t01_last_price                  NUMBER (15, 10) DEFAULT 0,
    t01_act_broker_tax              NUMBER (18, 5) DEFAULT 0,
    t01_act_exchange_tax            NUMBER (18, 5) DEFAULT 0,
    t01_cum_net_value               NUMBER (25, 5) DEFAULT 0,
    t01_cum_act_broker_tax          NUMBER (18, 5) DEFAULT 0,
    t01_cum_act_exchange_tax        NUMBER (18, 5) DEFAULT 0,
    t01_wfa_level                   NUMBER (1, 0),
    t01_institution_id_m02          NUMBER (5, 0),
    t01_ib_commission               NUMBER (18, 5) DEFAULT 0,
    t01_cum_ib_commission           NUMBER (18, 5) DEFAULT 0,
    t01_custodian_type_v01          NUMBER (5, 0),
    t01_cash_settle_date            DATE,
    t01_holding_settle_date         DATE,
    t01_unsettle_qty                NUMBER (15, 0) DEFAULT 0,
    t01_desk_order_ref_t52          VARCHAR2 (18) DEFAULT NULL,
    t01_desk_order_no_t52           VARCHAR2 (18) DEFAULT NULL,
    t01_trade_process_stat_id_v01   NUMBER (5, 0) DEFAULT 1,
    t01_approved_by_id_u17          NUMBER (5, 0) DEFAULT -1,
    t01_algo_ord_ref_t54            VARCHAR2 (18),
    t01_wfa_current_value           NUMBER (25, 10),
    t01_wfa_expected_value          NUMBER (25, 10),
    t01_remote_sec_source_id        VARCHAR2 (25),
    t01_tag50                       VARCHAR2 (25),
    t01_orig_exg_commission         NUMBER (18, 5),
    t01_cum_discount                NUMBER (25, 5) DEFAULT 0,
    t01_original_exchange_ord_id    VARCHAR2 (16),
    t01_poa_id_u47                  VARCHAR2 (18),
    t01_wfa_reason                  VARCHAR2 (100),
    t01_con_ord_ref_t38             VARCHAR2 (22) DEFAULT NULL,
    t01_parent_ord_category_t38     NUMBER (2, 0)
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (t01_date)
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
           'CREATE INDEX idx_arc_t01_date ON dfn_arc.t01_order (t01_date DESC) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.t01_order TO dfn_ntp
/

GRANT INSERT ON dfn_arc.t01_order TO dfn_ntp
/

CREATE INDEX idx_arc_t01_cl_ord_id
    ON dfn_arc.t01_order (t01_cl_ord_id)
/

CREATE INDEX idx_arc_t01_customer_id_u01
    ON dfn_arc.t01_order (t01_customer_id_u01)
/

CREATE INDEX idx_arc_t01_ord_no
    ON dfn_arc.t01_order (t01_ord_no)
/

CREATE INDEX idx_arc_t01_exchange_code_m01
    ON dfn_arc.t01_order (t01_exchange_code_m01)
/

CREATE INDEX idx_arc_t01_symbol_code_m20
    ON dfn_arc.t01_order (t01_symbol_code_m20)
/

ALTER TABLE dfn_arc.t01_order
 ADD (
  t01_is_archive_ready NUMBER (1, 0) DEFAULT 0 NOT NULL
 )
/
COMMENT ON COLUMN dfn_arc.t01_order.t01_is_archive_ready IS
    'flag to check before archive'
/

ALTER TABLE DFN_ARC.T01_ORDER 
 ADD (
  T01_ORIG_EXG_TAX NUMBER (20, 5),
  T01_ORIG_BRK_TAX NUMBER (20, 5)
 )
/

ALTER TABLE dfn_arc.t01_order
 ADD (
  t01_initial_margin_amount NUMBER (18, 5),
  t01_maintain_margin_amount NUMBER (18, 5),
  t01_cum_initial_margin_amount NUMBER (18, 5),
  t01_cum_maintain_margin_amount NUMBER (18, 5)
 )
/

ALTER TABLE dfn_arc.t01_order
ADD (
  t01_maintain_margin_block NUMBER (18, 5),
  t01_cum_maintain_margin_block NUMBER (18, 5)
)
/

ALTER TABLE dfn_arc.T01_ORDER 
 ADD (
  T01_ORDER_AVG_PRICE NUMBER (18, 5)
 )
/
COMMENT ON COLUMN dfn_arc.T01_ORDER.T01_ORDER_AVG_PRICE IS 'Order Average Price'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_cma_tax NUMBER (18, 5) DEFAULT 0
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_cma_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_cpp_tax NUMBER (18, 5) DEFAULT 0
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_cpp_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_dcm_tax NUMBER (18, 5) DEFAULT 0
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_dcm_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_cum_cma_tax NUMBER (18, 5) DEFAULT 0
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_cum_cma_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_cum_cpp_tax NUMBER (18, 5) DEFAULT 0
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_cum_cpp_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_cum_dcm_tax NUMBER (18, 5) DEFAULT 0
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_cum_dcm_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_act_cma_tax NUMBER (18, 5) DEFAULT 0
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_act_cma_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_act_cpp_tax NUMBER (18, 5) DEFAULT 0
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_act_cpp_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_act_dcm_tax NUMBER (18, 5) DEFAULT 0
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_act_dcm_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_cum_act_cma_tax NUMBER (18, 5) DEFAULT 0
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_cum_act_cma_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_cum_act_cpp_tax NUMBER (18, 5) DEFAULT 0
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_cum_act_cpp_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_cum_act_dcm_tax NUMBER (18, 5) DEFAULT 0
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_cum_act_dcm_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_cma_commission NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_cma_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_cpp_commission NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_cpp_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_dcm_commission NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_dcm_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_cma_cum_commission NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_cma_cum_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/



/* Formatted on 19-Feb-2020 14:55:21 (QP5 v5.206) */
DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_cpp_cum_commission NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_cpp_cum_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_dcm_cum_commission NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_dcm_cum_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

ALTER TABLE dfn_arc.t01_order 
 MODIFY (
  T01_CMA_COMMISSION DEFAULT 0,
  T01_CPP_COMMISSION DEFAULT 0,
  T01_DCM_COMMISSION DEFAULT 0,
  T01_CMA_CUM_COMMISSION DEFAULT 0,
  T01_CPP_CUM_COMMISSION DEFAULT 0,
  T01_DCM_CUM_COMMISSION DEFAULT 0

 )
/

ALTER TABLE dfn_arc.t01_order 
 MODIFY (
  t01_symbol_id_m20 NUMBER(10, 0),
  t01_symbol_code_m20 VARCHAR2(50)
)
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE DFN_ARC.t01_order
ADD (
  t01_order_avg_price NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_ARC')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_order_avg_price');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

ALTER TABLE dfn_arc.T01_ORDER 
 ADD (
  T01_CONTRACT_ID_T75 NUMBER (18, 0) DEFAULT NULL
 )
/
COMMENT ON COLUMN dfn_arc.T01_ORDER.T01_CONTRACT_ID_T75 IS 'Murabaha Contract Id'
/

ALTER TABLE dfn_arc.T01_ORDER 
RENAME COLUMN T01_ORDER_AVG_PRICE TO T01_HOLDING_AVG_PRICE
/

ALTER TABLE dfn_arc.T01_ORDER 
 ADD (
  T01_HOLDING_AVG_COST NUMBER (18)
 )
/

ALTER TABLE dfn_arc.T01_ORDER 
 ADD (
  T01_AVG_COST NUMBER (18)
 )
/

ALTER TABLE dfn_arc.T01_ORDER 
 MODIFY (
  T01_ORD_EXEC_SEQ DEFAULT 0
 )
/

ALTER TABLE dfn_arc.t01_order
ADD (
  t01_exchange_id_m01 NUMBER (10, 0)
);

ALTER TABLE dfn_arc.t01_order 
 MODIFY (
  t01_ord_channel_id_v29 NUMBER(10, 0)
)
/

ALTER TABLE dfn_arc.t01_order
ADD (
  t01_negotiated_request_id_t85 NUMBER (18)
)
/

ALTER TABLE dfn_arc.t01_order
 ADD (
  t01_board_code_m54 VARCHAR2 (6)
 )
/

ALTER TABLE dfn_arc.T01_ORDER 
 ADD (
  T01_SHORT_SELL_ENABLE NUMBER (2, 0) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_arc.T01_ORDER.T01_SHORT_SELL_ENABLE IS '0 - dissable, 1 - enable'
/

ALTER TABLE dfn_arc.t01_order
 MODIFY (
  t01_remote_cl_ord_id VARCHAR2 (25 BYTE),
  t01_remote_orig_cl_ord_id VARCHAR2 (25 BYTE)
 )
/

ALTER TABLE dfn_arc.t01_order
 MODIFY (
  t01_board_code_m54 VARCHAR2 (10 BYTE)

 )
/

ALTER TABLE dfn_arc.T01_ORDER 
 ADD (
  T01_BYPASS_RMS_VALIDATION NUMBER (1) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_arc.T01_ORDER.T01_BYPASS_RMS_VALIDATION IS '0 - NO, 1 - YES'
/

ALTER TABLE dfn_arc.T01_ORDER 
 ADD (
  T01_INTEGRATION_EXT_REF_NO NUMBER (20)
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.T01_ORDER  ADD (  T01_ALGO_COMMISSION NUMBER (18, 5) DEFAULT 0 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('T01_ORDER')
           AND column_name = UPPER ('T01_ALGO_COMMISSION');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.T01_ORDER  ADD (  T01_ALGO_TAX NUMBER (18, 5) DEFAULT 0 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('T01_ORDER')
           AND column_name = UPPER ('T01_ALGO_TAX');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.T01_ORDER  ADD (  T01_ALGO_CUM_COMMISSION NUMBER (18, 5) DEFAULT 0 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('T01_ORDER')
           AND column_name = UPPER ('T01_ALGO_CUM_COMMISSION');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.T01_ORDER  ADD (  T01_ALGO_CUM_TAX NUMBER (18, 5) DEFAULT 0 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('T01_ORDER')
           AND column_name = UPPER ('T01_ALGO_CUM_TAX');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t01_order RENAME COLUMN t01_algo_commission TO t01_other_commission';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_algo_commission');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t01_order RENAME COLUMN t01_algo_tax TO t01_other_tax';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_algo_tax');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t01_order RENAME COLUMN t01_algo_cum_commission TO t01_other_cum_commission';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_algo_cum_commission');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.t01_order RENAME COLUMN t01_algo_cum_tax TO t01_other_cum_tax';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('t01_order')
           AND column_name = UPPER ('t01_algo_cum_tax');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
