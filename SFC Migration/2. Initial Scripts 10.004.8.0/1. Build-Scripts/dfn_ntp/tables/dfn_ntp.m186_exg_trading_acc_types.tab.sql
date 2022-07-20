CREATE TABLE dfn_ntp.m186_exg_trading_acc_types
(
    m185_id                    NUMBER (4, 0),
    m185_exchange_id_m01       NUMBER (10, 0),
    m185_account_type_id_v37   NUMBER (2, 0),
    m185_exchange_code_m01     VARCHAR2 (10 BYTE),
    m185_is_default            NUMBER (1, 0),
	m185_custom_type           VARCHAR2 (50 BYTE) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.m186_exg_trading_acc_types
  RENAME COLUMN m185_id TO m186_id;
  
ALTER TABLE dfn_ntp.m186_exg_trading_acc_types
  RENAME COLUMN m185_exchange_id_m01 TO m186_exchange_id_m01;
  
ALTER TABLE dfn_ntp.m186_exg_trading_acc_types
  RENAME COLUMN m185_exchange_code_m01 TO m186_exchange_code_m01;

ALTER TABLE dfn_ntp.m186_exg_trading_acc_types
  RENAME COLUMN m185_account_type_id_v37 TO m186_account_type_id_v37;

ALTER TABLE dfn_ntp.m186_exg_trading_acc_types
  RENAME COLUMN m185_is_default TO m186_is_default;
  
CREATE INDEX dfn_ntp.idx_m186_exchange_id_m01
ON dfn_ntp.m186_exg_trading_acc_types (m186_exchange_id_m01)
/

ALTER TABLE dfn_ntp.M186_EXG_TRADING_ACC_TYPES 
 ADD (
  M186_CUSTOM_TYPE VARCHAR2 (50 BYTE) DEFAULT 1
 )
/