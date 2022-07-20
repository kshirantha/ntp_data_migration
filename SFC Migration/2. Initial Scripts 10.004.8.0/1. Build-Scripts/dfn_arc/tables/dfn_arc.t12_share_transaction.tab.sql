DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.t12_share_transaction
(
    t12_id                        NUMBER (18, 0) NOT NULL,
    t12_exchange_code_m01         VARCHAR2 (10),
    t12_symbol_code_m20           VARCHAR2 (20),
    t12_quantity                  NUMBER (18, 0),
    t12_avgcost                   NUMBER (18, 5),
    t12_trading_acc_id_u07        NUMBER (10, 0),
    t12_seller_exchange_ac        VARCHAR2 (30 BYTE),
    t12_customer_id_u01           VARCHAR2 (10),
    t12_status_id_v01             NUMBER (5, 0) DEFAULT 1,
    t12_timestamp                 DATE DEFAULT SYSDATE,
    t12_txn_type                  NUMBER (2, 0) DEFAULT 0,
    t12_pending_req_id            NUMBER (18, 0),
    t12_inst_id_m02               NUMBER (5, 0),
    t12_narration                 VARCHAR2 (500),
    t12_buyer_trading_ac_id_u07   NUMBER (10, 0),
    t12_buyer_exchange_ac         VARCHAR2 (30),
    t12_send_to_exchange          NUMBER (1, 0) DEFAULT 0 NOT NULL,
    t12_book_keeper_id            NUMBER (10, 0),
    t12_fees                      NUMBER (18, 5) DEFAULT 0,
    t12_reference_id_t06          VARCHAR2 (255),
    t12_transfer_date             DATE,
    t12_exng_fee                  NUMBER (18, 5),
    t12_brk_fee                   NUMBER (18, 5),
    t12_custodian_id_m26          NUMBER (10, 0) DEFAULT 0,
    t12_transaction_fee           NUMBER (18, 5) DEFAULT 0,
    t12_txn_category              NUMBER (1, 0),
    t12_reject_reason             VARCHAR2 (200),
    t12_poa_id_u47                NUMBER (10, 0),
    t12_txn_source                NUMBER (1, 0) DEFAULT 0,
    t12_movement_type             VARCHAR2 (5),
    t12_seller_memebr_code        VARCHAR2 (25),
    t12_seller_nin                VARCHAR2 (25),
    t12_buyer_member_code         VARCHAR2 (25),
    t12_buyer_nin                 VARCHAR2 (25),
    t12_channel_id_v29            NUMBER (2, 0),
    t12_umsg_id_t19               NUMBER (18, 0),
    t12_include_gl                NUMBER (1, 0) DEFAULT 1,
    t12_last_changed_by_id_u17    NUMBER (10, 0),
    t12_last_changed_date         DATE DEFAULT NULL,
    t12_no_of_approval            NUMBER (3, 0),
    t12_current_approval_level    NUMBER (3, 0),
    t12_function_id_m88           NUMBER (3, 0),
    t12_final_approval            NUMBER (1, 0) DEFAULT 0,
    t12_exg_vat                   NUMBER (18, 5),
    t12_brk_vat                   NUMBER (18, 5),
    t12_is_b_file                 NUMBER (1, 0),
    t12_symbol_id_m20             NUMBER (10, 0),
    t12_exchange_id_m01           NUMBER (10, 0),
    t12_bulk_master_id_t61        VARCHAR2 (50),
    t12_exg_discount              NUMBER (18, 5),
    t12_brk_discount              NUMBER (18, 5)
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (t12_timestamp)
    INTERVAL ( NUMTOYMINTERVAL (3, ''MONTH'') )
    (
        PARTITION t12_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_t12_timestamp ON dfn_arc.t12_share_transaction (t12_timestamp DESC) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.t12_share_transaction TO dfn_ntp
/

GRANT INSERT ON dfn_arc.t12_share_transaction TO dfn_ntp
/

ALTER TABLE dfn_arc.t12_share_transaction
 MODIFY (
  T12_FUNCTION_ID_M88 NUMBER (5, 0)
 )
/

ALTER TABLE dfn_arc.T12_SHARE_TRANSACTION 
 ADD (
  T12_CONTRACT_ID_T75 NUMBER (18, 0)
 )
/
COMMENT ON COLUMN dfn_arc.T12_SHARE_TRANSACTION.T12_CONTRACT_ID_T75 IS 'Murabaha Contract Id'
/

ALTER TABLE dfn_arc.t12_share_transaction
 MODIFY (
  t12_channel_id_v29 NUMBER (10, 0)
 )
/

ALTER TABLE dfn_arc.T12_SHARE_TRANSACTION ADD CONSTRAINT PK_T12_ID
  PRIMARY KEY (
  T12_ID
)
 ENABLE 
 VALIDATE 
/

ALTER TABLE dfn_arc.t12_share_transaction
 ADD (
  t12_narration_lang VARCHAR2 (1000)
 )
 MODIFY (
  t12_narration VARCHAR2 (1000 BYTE)
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_arc.T12_SHARE_TRANSACTION  ADD (  T12_IP VARCHAR2 (50 BYTE) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_arc')
           AND table_name = UPPER ('T12_SHARE_TRANSACTION')
           AND column_name = UPPER ('T12_IP');
    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
