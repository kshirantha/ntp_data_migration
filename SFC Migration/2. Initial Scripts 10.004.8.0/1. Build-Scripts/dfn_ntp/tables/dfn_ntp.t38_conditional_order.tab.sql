CREATE TABLE dfn_ntp.t38_conditional_order
    (t38_cond_order_id               VARCHAR2(22) NOT NULL,
    t38_trading_acc_id_u07         NUMBER(10,0),
    t38_customer_id_u01            NUMBER(10,0),
    t38_cash_acc_id_u06            NUMBER(10,0) NOT NULL,
    t38_fix_msg                    VARCHAR2(500),
    t38_condition                  VARCHAR2(250),
    t38_condition_status           NUMBER(10,0),
    t38_expiry_date                DATE,
    t38_created_date               DATE,
    t38_triggered_date             DATE,
    t38_dealer_id_u17              NUMBER(10,0),
    t38_reject_reason              VARCHAR2(500),
    t38_instrument_type_code       VARCHAR2(4))
/




ALTER TABLE dfn_ntp.t38_conditional_order ADD
(

    t38_strategy_name            VARCHAR2 (20 BYTE),
    t38_orig_cl_ord_id           VARCHAR2 (22 BYTE),
    t38_symbol_code_m20          VARCHAR2 (25 BYTE),
    t38_quantity                 NUMBER (15, 0),
    t38_price                    NUMBER (25, 10) DEFAULT 0,
    t38_side                     NUMBER (5, 0),
    t38_ord_type_id_v06          VARCHAR2 (2 BYTE),
    t38_tif_id_v10               NUMBER (10, 0),
    t38_exchange_code_m01        VARCHAR2 (15 BYTE),
    t38_start_time               DATE,
    t38_cum_quantity             NUMBER (15, 0) DEFAULT 0,
    t38_trig_qty                 NUMBER (25, 0) DEFAULT 0,
    t38_ord_channel_id_v29       NUMBER (2, 0),
    t38_desk_order_ref_t52       VARCHAR2 (18 BYTE),
    t38_institution_id_m02       NUMBER (5, 0),
    t38_exec_type                NUMBER (2, 0),
    t38_trig_interval            NUMBER (10, 0) DEFAULT NULL,
    t38_block_size               NUMBER (10, 0) DEFAULT NULL,
    t38_cum_net_value            NUMBER (25, 5) DEFAULT 0,
    t38_cum_netstl               NUMBER (25, 5) DEFAULT 0,
    t38_trig_ord_count           NUMBER (25, 0) DEFAULT 0,
    t38_server_id                VARCHAR2 (2 BYTE),
    t38_ord_no                   VARCHAR2 (22 BYTE),
    t38_last_updated_date_time   TIMESTAMP (6),
    t38_ord_category             NUMBER (2, 0),
    t38_customer_no              VARCHAR2 (25 BYTE),
    t38_stop_px                  NUMBER (25, 10),
    t38_takeprofit_px            NUMBER (25, 10)
)
/

ALTER TABLE dfn_ntp.T38_CONDITIONAL_ORDER 
RENAME COLUMN T38_FIX_MSG TO T38_SYMBOL_ID_M20
/

ALTER TABLE dfn_ntp.T38_CONDITIONAL_ORDER 
 MODIFY (
  T38_CONDITION_STATUS VARCHAR2 (10),
  T38_EXPIRY_DATE VARCHAR2 (100),
  T38_TRIGGERED_DATE VARCHAR2 (100)
 )
/

ALTER TABLE dfn_ntp.T38_CONDITIONAL_ORDER 
 ADD (
  T38_CURRENCY VARCHAR2 (5)
 )
/

ALTER TABLE dfn_ntp.T38_CONDITIONAL_ORDER 
 ADD (
  T38_TRIGGERED_TIME TIMESTAMP (6),
  T38_TRIGGERED_PRICE NUMBER (25, 10) DEFAULT 0
 )
/

ALTER TABLE dfn_ntp.t38_conditional_order
 MODIFY (
  t38_customer_no VARCHAR2 (50 BYTE)
 )
/

CREATE Unique INDEX DFN_NTP.IDX_T38_T38_COND_ORDER_ID
    ON DFN_NTP.T38_CONDITIONAL_ORDER (T38_COND_ORDER_ID DESC)
/

ALTER TABLE dfn_ntp.T38_CONDITIONAL_ORDER 
 ADD (
  T38_EXCHANGE_ID_M01 NUMBER (10, 0)
 )
/

ALTER TABLE dfn_ntp.T38_CONDITIONAL_ORDER 
 MODIFY (
  T38_CONDITION VARCHAR2 (2000)

 )
/

ALTER TABLE dfn_ntp.T38_CONDITIONAL_ORDER 
 ADD (
  T38_COND_EXP_TIME VARCHAR2 (100)
 )
/