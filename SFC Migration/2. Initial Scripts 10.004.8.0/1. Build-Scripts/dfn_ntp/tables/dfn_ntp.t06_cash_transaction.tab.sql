CREATE TABLE dfn_ntp.t06_cash_transaction
(
    t06_id                         NUMBER (18, 0) NOT NULL,
    t06_cash_acc_id_u06            NUMBER (18, 0),
    t06_code                       VARCHAR2 (10 BYTE),
    t06_date                       TIMESTAMP (7),
    t06_cust_ref_no                VARCHAR2 (50 BYTE),
    t06_narration                  NVARCHAR2 (1000),
    t06_payment_method             VARCHAR2 (20 BYTE),
    t06_txn_code_m03               CHAR (3 BYTE),
    t06_amt_in_txn_currency        NUMBER (18, 5),
    t06_settle_currency_rate_m04   NUMBER (18, 5) DEFAULT 1,
    t06_cheque_no                  VARCHAR2 (20 BYTE),
    t06_cheque_date                DATE,
    t06_settlement_date            DATE,
    t06_beneficiary_id_u08         NUMBER (10, 0),
    t06_other_cash_acc_id_u06      NUMBER (5, 0),
    t06_entered_by_id_u17          NUMBER (10, 0),
    t06_entered_date               DATE,
    t06_last_changed_by_id_u17     NUMBER (10, 0),
    t06_last_changed_date          DATE,
    t06_cash_log_acc_id_u30        NUMBER (18, 0),
    t06_status_id                  NUMBER (3, 0) DEFAULT 0,
    t06_bank_id_m93                NUMBER (5, 0),
    t06_acc_name                   VARCHAR2 (255 BYTE),
    t06_branch                     VARCHAR2 (100 BYTE),
    t06_type_id                    NUMBER (2, 0),
    t06_chk_printed_by             NUMBER (5, 0),
    t06_chk_printed_date           DATE,
    t06_extrnl_ref                 VARCHAR2 (20 BYTE),
    t06_req_media                  NUMBER (3, 0),
    t06_location                   VARCHAR2 (30 BYTE),
    t06_auto_generate              NUMBER (1, 0) DEFAULT 0,
    t06_available_buy_power        NUMBER (1, 0) DEFAULT 0,
    t06_online_ft                  NUMBER (5, 0) DEFAULT -1,
    t06_ft_status                  NUMBER (1, 0) DEFAULT 0,
    t06_message_type               NUMBER (1, 0) DEFAULT 0,
    t06_stp_type                   NUMBER (2, 0) DEFAULT 0,
    t06_stp_status                 NUMBER (5, 0) DEFAULT 0,
    t06_stp_narration              VARCHAR2 (250 BYTE),
    t06_cust_bank_acc_id           NUMBER (18, 0) DEFAULT 0,
    t06_settlement_key             NUMBER (18, 0) DEFAULT 0,
    t06_txn_type                   NUMBER (5, 0) DEFAULT -1,
    t06_reversed_by_id_u17         NUMBER (10, 0),
    t06_reversed_date              DATE,
    t06_payment_initiated_time     DATE,
    t06_settle_currency_code_m03   CHAR (3 BYTE),
    t06_amt_in_settle_currency     NUMBER (18, 5),
    t06_related_txn_id             NUMBER (18, 0) DEFAULT 0,
    t06_overdrawn_amt              NUMBER (18, 5) DEFAULT 0,
    t06_poa_id_u47                 NUMBER (10, 0),
    t06_exchange_fee               NUMBER (18, 5) DEFAULT 0,
    t06_broker_fee                 NUMBER (18, 5) DEFAULT 0,
    t06_thirdparty_fee             NUMBER (18, 5) DEFAULT 0,
    t06_to_cash_acc_id             NUMBER (18, 0),
    t06_client_channel_id_v29      NUMBER (5, 0),
    t06_sub_login_id_u09           NUMBER (20, 0),
    t06_sub_login_name             NVARCHAR2 (50),
    t06_b2b_txn_id_m97             NUMBER (18, 0),
    t06_bypass_txn_restriction     NUMBER (1, 0) DEFAULT 0,
    t06_third_party_txn_id         NUMBER (18, 0) DEFAULT 0,
    t06_is_live                    NUMBER (1, 0) DEFAULT 1,
    t06_no_of_approval             NUMBER (3, 0),
    t06_current_approval_level     NUMBER (3, 0),
    t06_deposit_bank_id_m16        NUMBER (5, 0),
    t06_deposit_bank_no            VARCHAR2 (30 BYTE),
    t06_function_id_m88            NUMBER (5, 0),
    t06_reject_reason              VARCHAR2 (100 BYTE),
    t06_exg_vat                    NUMBER (18, 5),
    t06_brk_vat                    NUMBER (18, 5),
    t06_institute_id_m02           NUMBER (10, 0),
    t06_symbol_code_m20            VARCHAR2 (50 BYTE),
    t06_symbol_id_m20              VARCHAR2 (20 BYTE),
    t06_ref_id                     NUMBER (18, 0),
    t06_ref_master_id              VARCHAR2 (50 BYTE),
    t06_ref_type                   VARCHAR2 (50 BYTE),
    t06_is_allow_overdraw          NUMBER (1, 0)
)
/


COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_bypass_txn_restriction IS
    'Bypass t03_transaction_restriction.'
/
COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_extrnl_ref IS
    'Voucher/Receipt No'
/
COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_function_id_m88 IS
    'FK from M88'
/
COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_poa_id_u47 IS
    'Power Of Attorney ID'
/
COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_req_media IS
    'fk from m135, saudi specific'
/
COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_status_id IS
    '1 - PENDING | 101 - APPROVED-L1 | 102 - APPROVED-L2 | 103 - CANCELLED | 104 - REVERSED | 105 - REJECTED | 106 - PENDING FROM BANK'
/
COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_sub_login_id_u09 IS
    'fK m04_sub_account_logins.m04_id'
/
COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_sub_login_name IS
    'fK m04_sub_account_logins.m04_login_name | fK m04_logins.m04_login_name'
/

COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_status_id IS ''
/

COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_type_id IS
    'If Beneficiary then U08_Account_Type_V01_Id'
/
COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_req_media IS ''
/
COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_online_ft IS
    '1 : PROCESSING | 2 : SIGNATURE1 APPROVED |  3 : SIGNATURE2 APPROVED | 4 : COMPLETED | 5 : CANCELLED'
/
COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_stp_type IS
    '1 : DUBAI BANK | 2 : SWIFT'
/
COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_stp_status IS
    '1 : NEW | 2 : SIGNATURE1 APPROVED | 3 : PROCESSING | 4 : SENT | 5 : FAILED FROM OMS | 6 : ACKNOWLEDGE BY SWIFT | 7 : BANK HAS RECEIVED | 8 : FAILED FROM SWIFT | 9 : EXECUTED IN BANK | 10 : FAILED IN BANK'
/
COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_txn_type IS
    'Payment Methods : 1 - Cash | 2 - Check | 3 - Transfer'
/
COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_status_id IS
    'NTP IDs: 1 - PENDING | 101 - APPROVED-L1 | 2 - APPROVED-L2 | 19 - CANCELLED | 3 - REJECTED | 7 - PENDING FROM BANK'
/

ALTER TABLE dfn_ntp.T06_CASH_TRANSACTION
 ADD (
  T06_EXG_DISCOUNT NUMBER (18, 5),
  T06_BRK_DISCOUNT NUMBER (18, 5)
 )
/

CREATE INDEX dfn_ntp.idx_t06_last_changed_date
    ON dfn_ntp.t06_cash_transaction (t06_last_changed_date DESC)
/

ALTER TABLE dfn_ntp.t06_cash_transaction
 ADD (
  t06_is_archive_ready NUMBER (1, 0) DEFAULT 0 NOT NULL
 )
/
COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_is_archive_ready IS
    'flag to check before archive'
/

COMMENT ON COLUMN dfn_ntp.t06_cash_transaction.t06_status_id IS
    'NTP IDs: 1 - PENDING | 101 - APPROVED-L1 | 2 - APPROVED-L2 | 19 - CANCELLED | 3 - REJECTED | 7 - PENDING FROM BANK | 29 - BANK RESPONSE RECEIVED'
/

ALTER TABLE dfn_ntp.t06_cash_transaction
 ADD (
  t06_b2b_message VARCHAR2 (500)
 )
/

ALTER TABLE dfn_ntp.T06_CASH_TRANSACTION 
 ADD (
  t06_contract_id_t75 NUMBER (18, 0)
 )
/
COMMENT ON COLUMN dfn_ntp.T06_CASH_TRANSACTION.t06_contract_id_t75 IS 'Murabaha Contract Id'
/

ALTER TABLE dfn_ntp.T06_CASH_TRANSACTION 
 ADD (
  T06_SYSTEM_APPROVAL NUMBER (2) DEFAULT 1
 )
/
COMMENT ON COLUMN dfn_ntp.T06_CASH_TRANSACTION.T06_SYSTEM_APPROVAL IS 'OMS Approval Required'
/

ALTER TABLE dfn_ntp.T06_CASH_TRANSACTION 
 ADD (
  T06_PARENT_REF_ID VARCHAR2 (255)
 )
/

UPDATE dfn_ntp.T06_CASH_TRANSACTION  SET T06_REF_ID = null;
COMMIT;

ALTER TABLE dfn_ntp.T06_CASH_TRANSACTION 
 MODIFY (
  T06_REF_ID VARCHAR2 (255)

 )
/

DECLARE
    l_count       NUMBER := 0;
    l_ddl_temp    VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.T06_CASH_TRANSACTION ADD (t06_channel_id_temp NUMBER (10))';
    l_dml         VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.T06_CASH_TRANSACTION SET t06_channel_id_temp = t06_client_channel_id_v29';
    l_ddl_alter   VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.T06_CASH_TRANSACTION MODIFY ( t06_client_channel_id_v29 NUMBER (10))';
    l_dml_1       VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.T06_CASH_TRANSACTION SET t06_client_channel_id_v29 = t06_channel_id_temp';
    l_ddl_del     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.T06_CASH_TRANSACTION DROP COLUMN t06_channel_id_temp';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
    WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('T06_CASH_TRANSACTION')
           AND column_name = UPPER ('t06_client_channel_id_v29');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl_temp;

        EXECUTE IMMEDIATE l_dml;


        UPDATE dfn_ntp.T06_CASH_TRANSACTION
           SET t06_client_channel_id_v29 = NULL;

        COMMIT;
 
        EXECUTE IMMEDIATE l_ddl_alter;

        EXECUTE IMMEDIATE l_dml_1;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_del;
    END IF;
END;
 /

ALTER TABLE DFN_NTP.T06_CASH_TRANSACTION ADD CONSTRAINT PK_T06_ID
  PRIMARY KEY (
  T06_ID
)
 ENABLE 
 VALIDATE 
/


DECLARE
    l_count       NUMBER := 0;
    l_ddl_temp    VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.T06_CASH_TRANSACTION ADD (t06_narration_temp VARCHAR2 (1000))';
    l_dml         VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.T06_CASH_TRANSACTION SET t06_narration_temp = T06_NARRATION';
    l_ddl_alter   VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.T06_CASH_TRANSACTION MODIFY ( T06_NARRATION VARCHAR2 (1000))';
    l_dml_1       VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.T06_CASH_TRANSACTION SET T06_NARRATION = t06_narration_temp';
    l_ddl_del     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.T06_CASH_TRANSACTION DROP COLUMN t06_narration_temp';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
    WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('T06_CASH_TRANSACTION')
           AND column_name = UPPER ('T06_NARRATION');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl_temp;

        EXECUTE IMMEDIATE l_dml;


        UPDATE dfn_ntp.T06_CASH_TRANSACTION
           SET T06_NARRATION = NULL;

        COMMIT;
 
        EXECUTE IMMEDIATE l_ddl_alter;

        EXECUTE IMMEDIATE l_dml_1;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_del;
    END IF;
END;
 /
 
ALTER TABLE dfn_ntp.T06_CASH_TRANSACTION 
 MODIFY (
  T06_SYSTEM_APPROVAL DEFAULT 0
 )
/

DECLARE
    l_count    NUMBER := 0;
    l_script   VARCHAR2 (1000)
        := 'ALTER TABLE DFN_NTP.T06_CASH_TRANSACTION ADD (T06_FROM_CUST_ID_U01 NUMBER (10))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T06_CASH_TRANSACTION')
           AND column_name = UPPER ('T06_FROM_CUST_ID_U01');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_script;
    END IF;
END;
/

ALTER TABLE dfn_ntp.t06_cash_transaction
 ADD (
  t06_narration_lang VARCHAR2 (1000)
 )
/

ALTER TABLE dfn_ntp.t06_cash_transaction
 MODIFY (
  t06_other_cash_acc_id_u06 NUMBER (10, 0)

 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.T06_CASH_TRANSACTION  ADD (  T06_IP VARCHAR2 (50 BYTE) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('T06_CASH_TRANSACTION')
           AND column_name = UPPER ('T06_IP');
    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
