-- Table DFN_NTP.T12_SHARE_TRANSACTION

CREATE TABLE dfn_ntp.t12_share_transaction
(
    t12_id                        NUMBER (18, 0),
    t12_exchange_code_m01         VARCHAR2 (10),
    t12_symbol_code_m20           VARCHAR2 (20),
    t12_quantity                  NUMBER (18, 0),
    t12_avgcost                   NUMBER (18, 5),
    t12_trading_acc_id_u07        NUMBER (10, 0),
    t12_seller_exchange_ac        VARCHAR2 (30),
    t12_customer_id_u01           VARCHAR2 (10),
    t12_status_id_v01             NUMBER (5, 0) DEFAULT 1,
    t12_timestamp                 DATE DEFAULT SYSDATE,
    t12_txn_type                  NUMBER (2, 0) DEFAULT 0,
    t12_pending_req_id            NUMBER (18, 0),
    t12_inst_id_m02               NUMBER (5, 0),
    t12_narration                 VARCHAR2 (500),
    t12_buyer_trading_ac_id_u07   NUMBER (10, 0),
    t12_buyer_exchange_ac         VARCHAR2 (30),
    t12_send_to_exchange          NUMBER (1, 0) DEFAULT 0,
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
    t12_is_b_file                 NUMBER (1, 0)
)
/

-- Constraints for  DFN_NTP.T12_SHARE_TRANSACTION


  ALTER TABLE dfn_ntp.t12_share_transaction MODIFY (t12_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t12_share_transaction MODIFY (t12_send_to_exchange NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.T12_SHARE_TRANSACTION

COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_trading_acc_id_u07 IS
    'seller portfolio id fk from u07'
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_seller_exchange_ac IS
    'seller exchange account from u06(u06_exchange_ac)'
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_status_id_v01 IS ''
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_txn_type IS
    '1 - Stock Deposit | 2 - Stock Withdraw | 3 - Bonus Issue | 4 - Stock Adjustment | 5 - Stock Split | 6 - Reverse Split | 7 - Stock Transfer | 13 - Rights Subscription | 14 - Rights Conversion | 15 - Rights Reversal'
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_narration IS 'narration'
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_buyer_trading_ac_id_u07 IS
    'buyer portfolio id, fk fom u07'
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_buyer_exchange_ac IS
    'buyer exchange account from u06(u06_exchange_ac)'
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_book_keeper_id IS
    'fk from m100'
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_exng_fee IS
    'Exchange Fee'
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_brk_fee IS 'Broker Fee'
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_txn_category IS
    '1=within Customer 2=between OMS customers 3=between Brokers'
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_poa_id_u47 IS
    'Power Of Attorney ID'
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_txn_source IS
    '0 - Normal | 1 - Weekly File | 2 - CA Local TDWL File'
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_channel_id_v29 IS
    'Request channel'
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_include_gl IS
    'GS- include to GL or not'
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_function_id_m88 IS
    'Function Id'
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_final_approval IS
    '1=Yes, 0=No'
/
COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_is_b_file IS 'B File = 1'
/
COMMENT ON TABLE dfn_ntp.t12_share_transaction IS
    'this table keeps all the stock transactions. all 1=Stock Deposit,2=Stock Withdraw,3=Bonus issue,4=Stock Adjustment, 5=Stock Split,6=Reverse Split,7=Stock transfer transactions are maintained in this table.
Buyer* columns are applicable only if the txn_type=7'
/
-- End of DDL Script for Table DFN_NTP.T12_SHARE_TRANSACTION

ALTER TABLE dfn_ntp.t12_share_transaction
 ADD (
  t12_symbol_id_m20 NUMBER (10),
  t12_exchange_id_m01 NUMBER (10)
 )
/

ALTER TABLE dfn_ntp.t12_share_transaction 
 ADD (
  T12_BULK_MASTER_ID_T61 VARCHAR2 (50)
 )
/

ALTER TABLE dfn_ntp.T12_SHARE_TRANSACTION
 ADD (
  T12_EXG_DISCOUNT NUMBER (18, 5),
  T12_BRK_DISCOUNT NUMBER (18, 5)
 )
/

CREATE INDEX dfn_ntp.idx_t12_timestamp
    ON dfn_ntp.t12_share_transaction (t12_timestamp DESC)
/




ALTER TABLE dfn_ntp.t12_share_transaction
 MODIFY (
  t12_symbol_code_m20 VARCHAR2 (50 BYTE)

 )
/

ALTER TABLE dfn_ntp.t12_share_transaction
 MODIFY (
  T12_FUNCTION_ID_M88 NUMBER (5, 0)
 )
/

ALTER TABLE dfn_ntp.T12_SHARE_TRANSACTION 
 ADD (
  T12_CONTRACT_ID_T75 NUMBER (18, 0)
 )
/
COMMENT ON COLUMN dfn_ntp.T12_SHARE_TRANSACTION.T12_CONTRACT_ID_T75 IS 'Murabaha Contract Id'
/

DECLARE

    l_count   NUMBER := 0;

    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE dfn_ntp.t12_share_transaction

ADD (

  t12_code_m97 VARCHAR2 (10)

)';

BEGIN

    SELECT COUNT (*)

      INTO l_count

      FROM all_tab_columns

     WHERE     owner = UPPER ('dfn_ntp')

           AND table_name = UPPER ('t12_share_transaction')

           AND column_name = UPPER ('t12_code_m97');

 

    IF l_count = 0

    THEN

        EXECUTE IMMEDIATE l_ddl;

    END IF;

END;

/

 

COMMENT ON COLUMN dfn_ntp.t12_share_transaction.t12_code_m97 IS 'm97_code'

/

DECLARE
    l_count       NUMBER := 0;
    l_ddl_temp    VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t12_share_transaction ADD (t12_share_temp NUMBER (10))';
    l_dml         VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.t12_share_transaction SET t12_share_temp = t12_channel_id_v29';
    l_ddl_alter   VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t12_share_transaction MODIFY ( t12_channel_id_v29 NUMBER (10))';
    l_dml_1       VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.t12_share_transaction SET t12_channel_id_v29 = t12_share_temp';
    l_ddl_del     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t12_share_transaction DROP COLUMN t12_share_temp';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
    WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t12_share_transaction')
           AND column_name = UPPER ('t12_channel_id_v29');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl_temp;

        EXECUTE IMMEDIATE l_dml;


        UPDATE dfn_ntp.t12_share_transaction
           SET t12_channel_id_v29 = NULL;

        COMMIT;
 
        EXECUTE IMMEDIATE l_ddl_alter;

        EXECUTE IMMEDIATE l_dml_1;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_del;
    END IF;
END;
 /

ALTER TABLE DFN_NTP.T12_SHARE_TRANSACTION ADD CONSTRAINT PK_T12_ID
  PRIMARY KEY (
  T12_ID
)
 ENABLE
 VALIDATE
/

ALTER TABLE dfn_ntp.t12_share_transaction
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
        := 'ALTER TABLE dfn_ntp.T12_SHARE_TRANSACTION  ADD (  T12_IP VARCHAR2 (50 BYTE) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('T12_SHARE_TRANSACTION')
           AND column_name = UPPER ('T12_IP');
    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
