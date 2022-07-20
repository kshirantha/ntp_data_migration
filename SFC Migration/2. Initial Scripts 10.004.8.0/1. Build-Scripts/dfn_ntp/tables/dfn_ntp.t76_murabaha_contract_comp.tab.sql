CREATE TABLE dfn_ntp.t76_murabaha_contract_comp
(
    t76_id                   NUMBER (10, 0) NOT NULL,
    t76_contract_id_t75      NUMBER (10, 0) NOT NULL,
    t76_exchange_id_m01      CHAR (10 BYTE),
    t76_symbol_code_m20      VARCHAR2 (40 BYTE) NOT NULL,
    t76_percentage           NUMBER (5, 2),
    t76_allowed_change       NUMBER (1, 0) DEFAULT 0,
    t76_created_by_id_u17    NUMBER (10, 0),
    t76_created_date         DATE DEFAULT SYSDATE,
    t76_modified_by_id_u17   NUMBER (10, 0),
    t76_modified_date        DATE,
    t76_status_id_v01        NUMBER (2, 0),
    t76_custom_type          VARCHAR2 (50 BYTE) DEFAULT 1,
    t76_symbol_id_m20        NUMBER (10, 0) NOT NULL
)
/

ALTER TABLE dfn_ntp.T76_MURABAHA_CONTRACT_COMP 
 ADD (
  T76_Exchange_code_m01 VARCHAR2 (40 BYTE) NOT NULL
 )
/

ALTER TABLE dfn_ntp.T76_MURABAHA_CONTRACT_COMP 
 ADD (
  T76_exp_buy_order_value NUMBER (18, 5),
  T76_rem_buy_order_value NUMBER (18, 5),
  T76_buy_order_status_v30 CHAR (1 BYTE)
 )
/
COMMENT ON COLUMN dfn_ntp.T76_MURABAHA_CONTRACT_COMP.T76_exp_buy_order_value IS 'Expected Buy Order Value'
/
COMMENT ON COLUMN dfn_ntp.T76_MURABAHA_CONTRACT_COMP.T76_rem_buy_order_value IS 'Remaining Buy Order Value'
/

ALTER TABLE dfn_ntp.T76_MURABAHA_CONTRACT_COMP 
 ADD (
  t76_cum_buy_order_value NUMBER (18, 5),
  t76_cum_buy_order_qty NUMBER (18, 0)
 )
/

ALTER TABLE dfn_ntp.T76_MURABAHA_CONTRACT_COMP 
 ADD (
  T76_BUY_PENDING_QTY NUMBER (18, 0),
  T76_AVERAGE_COST NUMBER (18, 5),
  T76_CUM_COMMISSION NUMBER (18, 5),
  T76_TOTAL_CHARGES NUMBER (18, 5)
 )
/

COMMENT ON COLUMN dfn_ntp.T76_MURABAHA_CONTRACT_COMP.T76_TOTAL_CHARGES IS 'Share transfer + Cash transfer fees'
/

ALTER TABLE dfn_ntp.t76_murabaha_contract_comp
 ADD (
  t76_sell_order_status_v30 CHAR (1 BYTE),
  t76_custodian_id_m26 NUMBER (5, 0)
 )
/

ALTER TABLE dfn_ntp.T76_MURABAHA_CONTRACT_COMP
 MODIFY (
  T76_BUY_ORDER_STATUS_V30 DEFAULT 'X',
  T76_CUM_BUY_ORDER_VALUE DEFAULT 0,
  T76_CUM_BUY_ORDER_QTY DEFAULT 0,
  T76_BUY_PENDING_QTY DEFAULT 0,
  T76_AVERAGE_COST DEFAULT 0,
  T76_CUM_COMMISSION DEFAULT 0,
  T76_SELL_ORDER_STATUS_V30 DEFAULT 'X'
 )
/
