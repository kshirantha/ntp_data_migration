CREATE TABLE dfn_ntp.u07_trading_account
(
    u07_id                           NUMBER (10, 0) NOT NULL,
    u07_institute_id_m02             NUMBER (3, 0) NOT NULL,
    u07_customer_id_u01              NUMBER (10, 0) NOT NULL,
    u07_cash_account_id_u06          NUMBER (10, 0) NOT NULL,
    u07_exchange_code_m01            VARCHAR2 (10 BYTE) NOT NULL,
    u07_display_name_u06             VARCHAR2 (50 BYTE) NOT NULL,
    u07_customer_no_u01              VARCHAR2 (10 BYTE) NOT NULL,
    u07_display_name_u01             VARCHAR2 (1000 BYTE) NOT NULL,
    u07_default_id_no_u01            VARCHAR2 (20 BYTE) NOT NULL,
    u07_is_default                   NUMBER (1, 0) NOT NULL,
    u07_type                         NUMBER (1, 0) NOT NULL,
    u07_trading_enabled              NUMBER (1, 0) NOT NULL,
    u07_sharia_compliant             NUMBER (1, 0) DEFAULT 0 NOT NULL,
    u07_trading_group_id_m08         NUMBER (5, 0) NOT NULL,
    u07_created_by_id_u17            NUMBER (10, 0) NOT NULL,
    u07_created_date                 TIMESTAMP (6) NOT NULL,
    u07_status_id_v01                NUMBER (5, 0) NOT NULL,
    u07_commission_group_id_m22      NUMBER (5, 0) NOT NULL,
    u07_discount_percentage          NUMBER (10, 5) DEFAULT 0,
    u07_commission_dis_grp_id_m24    NUMBER (5, 0),
    u07_modified_by_id_u17           NUMBER (10, 0),
    u07_modified_date                TIMESTAMP (6),
    u07_status_changed_by_id_u17     NUMBER (10, 0),
    u07_status_changed_date          TIMESTAMP (6),
    u07_exe_broker_id_m26            NUMBER (5, 0),
    u07_display_name                 VARCHAR2 (50 BYTE),
    u07_exchange_account_no          VARCHAR2 (50 BYTE),
    u07_txn_fee                      NUMBER (18, 5) DEFAULT 0,
    u07_cust_settle_group_id_m35     NUMBER (5, 0) DEFAULT 1,
    u07_custodian_id_m26             NUMBER (10, 0),
    u07_exchange_id_m01              NUMBER (5, 0),
    u07_pending_restriction          NUMBER (1, 0) DEFAULT 0,
    u07_external_ref_no              VARCHAR2 (50 BYTE),
    u07_trade_rejection_enabled      NUMBER (1, 0) DEFAULT 0,
    u07_short_selling_enabled        NUMBER (1, 0) DEFAULT 0,
    u07_market_segment_v01           NUMBER (5, 0),
    u07_sharia_compliant_grp_m120    NUMBER (5, 0),
    u07_ca_charge_enabled            NUMBER (1, 0) DEFAULT 0,
    u07_status_changed_reason        VARCHAR2 (255 BYTE),
    u07_exchange_customer_name       VARCHAR2 (1000 BYTE),
    u07_account_category             NUMBER (2, 0),
    u07_trading_enabled_date         DATE,
    u07_custodian_type_v01           NUMBER (2, 0),
    u07_parent_trading_acc_id_u07    NUMBER (10, 0),
    u07_forgn_bank_account           NUMBER (18, 0) DEFAULT -1,
    u07_market_maker_enabled         NUMBER (1, 0) DEFAULT 0,
    u07_market_maker_group_id_m131   NUMBER (5, 0) DEFAULT -1,
    u07_custom_type                  VARCHAR2 (50 BYTE) DEFAULT 1,
    u07_trade_conf_config_id_m151    NUMBER (5, 0),
    u07_trade_conf_format_id_v12     NUMBER (5, 0),
    u07_discount_prec_from_date      DATE,
    u07_discount_prec_to_date        DATE,
    u07_allocation_eligible          NUMBER (1, 0) DEFAULT 0,
    PRIMARY KEY (u07_id)
)
ORGANIZATION INDEX
NOCOMPRESS
OVERFLOW
/



CREATE INDEX dfn_ntp.u07_u07_u01_id
    ON dfn_ntp.u07_trading_account (u07_customer_id_u01 ASC)
/

CREATE INDEX dfn_ntp.u07_u07_u06_id
    ON dfn_ntp.u07_trading_account (u07_cash_account_id_u06 ASC)
/

CREATE INDEX dfn_ntp.u07_u07_m08_id
    ON dfn_ntp.u07_trading_account (u07_trading_group_id_m08 ASC)
/



COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_account_category IS
    '1 - Global, 2 - Member Account,3 - Plus SME'
/
COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_allocation_eligible IS
    '1=Trade Allocation Eligible'
/
COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_ca_charge_enabled IS
    '0 - No | 1 - Yes (Charge Fee is Enabled for Corporate Actions)'
/
COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_custodian_type_v01 IS
    'Type =57  0 -None 1 - ICM /Full'
/
COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_external_ref_no IS
    'represents remote trading account no'
/
COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_forgn_bank_account IS
    'fk from u08'
/
COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_market_maker_enabled IS
    '0 - No | 1- Yes'
/
COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_market_maker_group_id_m131 IS
    'FK From M131'
/
COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_market_segment_v01 IS
    '0 - Main Market Only | 1 - Main and Second (Both Markets) | 2 - Second Market Only'
/
COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_pending_restriction IS
    '1- Available, 0- Not Available'
/
COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_sharia_compliant_grp_m120 IS
    'fk from m120'
/
COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_short_selling_enabled IS
    '1=Short Selling Account, TDWL specific change'
/
COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_trade_rejection_enabled IS
    '1=Trade Rejection Account, TDWL specific change'
/

ALTER TABLE dfn_ntp.u07_trading_account
 MODIFY (
  u07_default_id_no_u01 NULL

 )
/

ALTER TABLE dfn_ntp.u07_trading_account
 ADD (u07_maintenance_margin_value NUMBER (18, 5) DEFAULT 0,
   u07_prefred_inst_type_id NUMBER (1) DEFAULT 0)
/

COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_prefred_inst_type_id IS
    '0 - Others, 1 - FUT'
/

ALTER TABLE dfn_ntp.u07_trading_account 
 ADD (
  u07_sms_notification NUMBER (2)
 )
/
COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_sms_notification IS
    'YES-1 ,NO-0'
/

ALTER TABLE dfn_ntp.u07_trading_account 
 ADD (
  u07_email_notification NUMBER (2)
 )
/
COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_email_notification IS
    'YES-1 ,NO-0'
/

ALTER TABLE dfn_ntp.U07_TRADING_ACCOUNT 
 ADD (
  U07_MURABAHA_MARGIN_ENABLED NUMBER (1, 0) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.U07_TRADING_ACCOUNT.U07_MURABAHA_MARGIN_ENABLED IS '0 - No | 1- Yes'
/

ALTER TABLE dfn_ntp.u07_trading_account
 MODIFY (
  u07_customer_no_u01 VARCHAR2 (25 BYTE)

 )
/

CREATE INDEX DFN_NTP.IDX_U07_U07_CUSTOMER_NO_U01 ON DFN_NTP.U07_TRADING_ACCOUNT
   (  U07_CUSTOMER_NO_U01 ASC  ) 
/


 ALTER TABLE dfn_ntp.u07_trading_account
 MODIFY (
  u07_customer_no_u01 VARCHAR2 (50 BYTE)
 )
/


ALTER TABLE dfn_ntp.u07_trading_account
 ADD (
  u07_exg_acc_type_id_v37 NUMBER (5)
 )
/
COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_exg_acc_type_id_v37 IS
    '1- Client | 3- House | 101 - Market Maker | 102- Repurchasing | 103 - Triangular | 104 Liquidity Provider | 105 - Liquidity Contract'
/

ALTER TABLE dfn_ntp.u07_trading_account
 MODIFY (
  u07_display_name_u06 NULL
 )
/

ALTER TABLE dfn_ntp.u07_trading_account
 MODIFY (
  u07_exg_acc_type_id_v37 VARCHAR2 (3 BYTE)
 )
/

ALTER TABLE dfn_ntp.u07_trading_account
 ADD (
  u07_clearing_acc_m86 NUMBER (10)
 )
/
CREATE INDEX dfn_ntp.idx_u07_inst_id
    ON dfn_ntp.u07_trading_account (u07_institute_id_m02)
/



DECLARE
    l_is_nullable   NUMBER := 0;
    l_script        VARCHAR2 (1000)
        := 'ALTER TABLE DFN_NTP.U07_TRADING_ACCOUNT MODIFY (U07_DISPLAY_NAME_U01 NULL)';
BEGIN
    SELECT DECODE (nullable, 'Y', 1, 0)
      INTO l_is_nullable
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('U07_TRADING_ACCOUNT')
           AND column_name = UPPER ('U07_DISPLAY_NAME_U01');

    IF l_is_nullable = 0
    THEN
        EXECUTE IMMEDIATE l_script;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := ' ALTER TABLE dfn_ntp.u07_trading_account
 ADD (
  u07_pref_mkt_ids_m29 VARCHAR2 (50)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('u07_trading_account')
           AND column_name = UPPER ('u07_pref_mkt_ids_m29');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_pref_mkt_ids_m29 IS
    'Comma separated M29 IDs'
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE dfn_ntp.U07_TRADING_ACCOUNT
 ADD (
  U07_OTHER_COMMSION_GRP_ID_M22 NUMBER (3, 0) 
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('U07_TRADING_ACCOUNT')
           AND column_name = UPPER ('U07_OTHER_COMMSION_GRP_ID_M22');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.u07_trading_account.u07_other_commsion_grp_id_m22 IS
    'Algo Commission group, other commission group'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.U07_TRADING_ACCOUNT  ADD (  U07_UPDATE_EXTENAL_SYSTEM_B NUMBER (1) DEFAULT 0 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('u07_trading_account')
           AND column_name = UPPER ('U07_UPDATE_EXTENAL_SYSTEM_B');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.U07_TRADING_ACCOUNT.U07_UPDATE_EXTENAL_SYSTEM_B IS '1=Sucess, 2=Failed'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'CREATE INDEX dfn_ntp.idx_u07_exchange_account_no ON dfn_ntp.u07_trading_account (u07_exchange_account_no ASC)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_indexes
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('u07_trading_account')
           AND index_name = UPPER ('idx_u07_exchange_account_no');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.u07_trading_account ADD (   u07_order_approval_type        NUMBER(1,0) DEFAULT 0 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('U07_TRADING_ACCOUNT')
           AND column_name = UPPER ('u07_order_approval_type');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
