CREATE TABLE dfn_ntp.t17_trade_processing_requests
(
    t17_id                         VARCHAR2 (22 BYTE) NOT NULL,
    t17_ord_no_t01                 VARCHAR2 (22 BYTE) NOT NULL,
    t17_cl_ord_id_t01              VARCHAR2 (22 BYTE) NOT NULL,
    t17_avg_price                  NUMBER (25, 10) DEFAULT 0,
    t17_quantity                   NUMBER (15, 0),
    t17_ord_value                  NUMBER (25, 10) DEFAULT 0,
    t17_commission                 NUMBER (25, 10) DEFAULT 0,
    t17_exec_brk_commission        NUMBER (25, 10) DEFAULT 0,
    t17_broker_commission          NUMBER (25, 10) DEFAULT 0,
    t17_netstl                     NUMBER (25, 10) DEFAULT 0,
    t17_net_value                  NUMBER (25, 10) DEFAULT 0,
    t17_broker_tax                 NUMBER (18, 5),
    t17_exchange_tax               NUMBER (18, 5),
    t17_status_id_v01              NUMBER (5, 0) DEFAULT 1 NOT NULL,
    t17_symbol_code_m20            VARCHAR2 (10 BYTE),
    t17_side                       NUMBER (5, 0) NOT NULL,
    t17_tenant_code                VARCHAR2 (15 BYTE),
    t17_institution_id_m02         NUMBER (5, 0),
    t17_exchange_code_m01          VARCHAR2 (15 BYTE),
    t17_cash_settle_date           DATE,
    t17_holding_settle_date        DATE,
    t17_status_changed_date        DATE,
    t17_status_changed_by          NUMBER (15, 0),
    t17_old_avg_price              NUMBER (25, 10),
    t17_old_quantity               NUMBER (15, 0),
    t17_old_ord_value              NUMBER (25, 10) DEFAULT 0,
    t17_old_commission             NUMBER (25, 10) DEFAULT 0,
    t17_old_exec_brk_commission    NUMBER (25, 10) DEFAULT 0,
    t17_old_broker_commission      NUMBER (25, 10) DEFAULT 0,
    t17_old_netstl                 NUMBER (25, 10) DEFAULT 0,
    t17_old_net_value              NUMBER (25, 10) DEFAULT 0,
    t17_old_broker_tax             NUMBER (18, 5),
    t17_old_exchange_tax           NUMBER (18, 5),
    t17_old_cash_settle_date       DATE,
    t17_old_holding_settle_date    DATE,
    t17_settle_currency_rate       NUMBER (10, 0) DEFAULT 1,
    t17_old_settle_currency_rate   NUMBER (10, 0) DEFAULT 1,
    t17_date                       DATE,
    t17_order_date                 DATE,
    t17_old_order_date             DATE
)
/



COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_cl_ord_id_t01 IS
    'T01_CL_ORD_ID'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_date IS
    'Request Created Date'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_exchange_code_m01 IS
    'T01_EXCHANGE_CODE_M01'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_id IS
    'Request Unique ID'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_institution_id_m02 IS
    'T01_INSTITUTION_ID_M02'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_old_avg_price IS
    'T01_AVG_PRICE'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_old_broker_commission IS
    'T01_CUM_COMMISSION - T01_CUM_EXEC_BRK_COMMISSION'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_old_broker_tax IS
    'T01_CUM_BROKER_TAX'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_old_cash_settle_date IS
    'T01_CASH_SETTLE_DATE'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_old_commission IS
    'T01_CUM_COMMISSION'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_old_exchange_tax IS
    'T01_CUM_EXCHANGE_TAX'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_old_exec_brk_commission IS
    'T01_CUM_EXEC_BRK_COMMISSION'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_old_holding_settle_date IS
    'T01_HOLDING_SETTLE_DATE'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_old_net_value IS
    'T01_CUM_NET_VALUE'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_old_netstl IS
    'T01_CUM_NETSTL'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_old_ord_value IS
    'T01_CUM_ORD_VALUE'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_old_order_date IS
    'T01_DATE'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_old_quantity IS
    'T01_CUM_QUANTITY'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_old_settle_currency_rate IS
    'T01_SETTLE_CURRENCY_RATE'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_ord_no_t01 IS
    'T01_ORD_NO'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_side IS
    'T01_SIDE'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_status_id_v01 IS
    'Pending = 1,
  Pending_Approve = 21,
  Approved = 2,
  Rejected = 3,
  Pending_Settle  = 24,
  Settled = 25'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_symbol_code_m20 IS
    'M20_SYMBOL_CODE'
/
COMMENT ON COLUMN dfn_ntp.t17_trade_processing_requests.t17_tenant_code IS
    'T01_TENANT_CODE'
/

ALTER TABLE dfn_ntp.t17_trade_processing_requests ADD (t17_current_approval_level NUMBER(2,0))
/
ALTER TABLE dfn_ntp.t17_trade_processing_requests ADD (t17_no_of_approval NUMBER(2,0))
/

ALTER TABLE dfn_ntp.t17_trade_processing_requests
 ADD (
  t17_symbol_id_m20 NUMBER (10),
  t17_exchange_id_m01 NUMBER (10)
 )
/

ALTER TABLE dfn_ntp.T17_TRADE_PROCESSING_REQUESTS 
 ADD (
  T17_is_order NUMBER (1)
 )
/

COMMENT ON COLUMN dfn_ntp.T17_TRADE_PROCESSING_REQUESTS.T17_is_order IS '1=true, 0=false'
/

ALTER TABLE dfn_ntp.T17_TRADE_PROCESSING_REQUESTS 
 ADD (
  T17_OLD_ORDER_AVG_PRICE NUMBER (25, 10),
  T17_ORDER_AVG_PRICE NUMBER (25, 10),
  T17_OLD_CUM_NET_VALUE NUMBER (25, 10),
  T17_cum_NET_VALUE NUMBER (25, 10),
  T17_old_cum_NET_Sttle NUMBER (25, 10),
  T17_cum_NET_STTle NUMBER (25, 10),
  t17_old_cum_qty NUMBER (25, 10),
  t17_cum_qty NUMBER (25, 10),
  t17_old_cum_comm NUMBER (25, 10),
  t17_cum_comm NUMBER (25, 10)
 )
/
COMMENT ON COLUMN dfn_ntp.T17_TRADE_PROCESSING_REQUESTS.T17_OLD_ORDER_AVG_PRICE IS 'Avg Price of total order'
/
COMMENT ON COLUMN dfn_ntp.T17_TRADE_PROCESSING_REQUESTS.T17_OLD_CUM_NET_VALUE IS 'cum net value of total order'
/
COMMENT ON COLUMN dfn_ntp.T17_TRADE_PROCESSING_REQUESTS.T17_old_cum_NET_Sttle IS 'cum net settle of total order'
/
COMMENT ON COLUMN dfn_ntp.T17_TRADE_PROCESSING_REQUESTS.t17_old_cum_qty IS 'cum qty of total order'
/
COMMENT ON COLUMN dfn_ntp.T17_TRADE_PROCESSING_REQUESTS.t17_old_cum_comm IS 'cum commission of total order'
/
ALTER TABLE dfn_ntp.T17_TRADE_PROCESSING_REQUESTS 
 ADD (
  T17_OLD_ORD_QTY NUMBER (25, 10),
  T17_ORD_QTY NUMBER (25, 10)
 )
/
COMMENT ON COLUMN dfn_ntp.T17_TRADE_PROCESSING_REQUESTS.T17_OLD_ORD_QTY IS 'qty of order'
/

ALTER TABLE dfn_ntp.T17_TRADE_PROCESSING_REQUESTS 
 ADD (
  T17_OLD_CUM_BRK_COMM NUMBER (25, 10),
  T17_CUM_BRK_COMM NUMBER (25, 10)
 )
/
COMMENT ON COLUMN dfn_ntp.T17_TRADE_PROCESSING_REQUESTS.T17_OLD_CUM_BRK_COMM IS 'cum broker commission of total order'
/

ALTER TABLE dfn_ntp.t17_trade_processing_requests
    MODIFY (t17_symbol_code_m20 VARCHAR2 (25 BYTE))
/

ALTER TABLE dfn_ntp.T17_TRADE_PROCESSING_REQUESTS 
 ADD (
  T17_TRADE_CONFIRM_NO_T02 NUMBER (20)
 )
/

ALTER TABLE dfn_ntp.T17_TRADE_PROCESSING_REQUESTS 
 ADD (
  T17_UPDATE_TYPE NUMBER (1, 0) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.T17_TRADE_PROCESSING_REQUESTS.T17_UPDATE_TYPE IS '0= By OMS 1= By BOS (Approvel)'
/

ALTER TABLE dfn_ntp.T17_TRADE_PROCESSING_REQUESTS 
 MODIFY (
  T17_SETTLE_CURRENCY_RATE NUMBER (18, 8),
  T17_OLD_SETTLE_CURRENCY_RATE NUMBER (18, 8)

 )
/

CREATE UNIQUE INDEX dfn_ntp.idx_t17_t17_id
    ON dfn_ntp.t17_trade_processing_requests (t17_id DESC)
/

ALTER TABLE dfn_ntp.T17_TRADE_PROCESSING_REQUESTS 
 ADD (
  t17_old_cum_brk_tax number (18, 5),
  t17_cum_brk_tax number (18, 5),
  t17_old_cum_exg_tax number (18, 5),
  t17_cum_exg_tax number (18, 5)
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.T17_TRADE_PROCESSING_REQUESTS ADD (t17_acc_intrst NUMBER (18, 5))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T17_TRADE_PROCESSING_REQUESTS')
           AND column_name = UPPER ('t17_acc_intrst');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.T17_TRADE_PROCESSING_REQUESTS ADD (t17_old_acc_intrst NUMBER (18, 5))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T17_TRADE_PROCESSING_REQUESTS')
           AND column_name = UPPER ('t17_old_acc_intrst');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.T17_TRADE_PROCESSING_REQUESTS ADD (t17_cum_acc_intrst NUMBER (18, 5))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T17_TRADE_PROCESSING_REQUESTS')
           AND column_name = UPPER ('t17_cum_acc_intrst');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.T17_TRADE_PROCESSING_REQUESTS ADD (t17_old_cum_acc_intrst NUMBER (18, 5))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T17_TRADE_PROCESSING_REQUESTS')
           AND column_name = UPPER ('t17_old_cum_acc_intrst');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/