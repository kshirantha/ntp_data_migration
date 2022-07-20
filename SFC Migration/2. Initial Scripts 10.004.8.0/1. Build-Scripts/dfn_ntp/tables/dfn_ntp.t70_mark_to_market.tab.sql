CREATE TABLE dfn_ntp.t70_mark_to_market
(
   t70_id                   NUMBER (18, 0),
   t70_date                 DATE,
   t70_trading_acc_id_u07   NUMBER (10, 0),
   t70_exchange_code_m01    VARCHAR2 (10 BYTE),
   t70_symbol_code_m20      VARCHAR2 (50 BYTE),
   t70_own_holdings         NUMBER (18, 0),
   t70_vwap                 NUMBER (18, 5),
   t70_settle_price         NUMBER (18, 5),
   t70_m2m_gain_loss        NUMBER (18, 5),
   t70_im_value             NUMBER (18, 5) DEFAULT 0,
   t70_order_no             NUMBER (18, 0),
   t70_exec_id              VARCHAR2 (50 BYTE),
   t70_order_side           VARCHAR2 (2 BYTE),
   t70_position_effect      VARCHAR2 (2 BYTE),
   t70_notional_value       NUMBER (18, 0),
   t70_custom_type          VARCHAR2 (50 BYTE) DEFAULT 1
)
/



CREATE UNIQUE INDEX dfn_ntp.idx_t70_mtm
   ON dfn_ntp.t70_mark_to_market (t70_trading_acc_id_u07 ASC,
                                  t70_exchange_code_m01 ASC,
                                  t70_symbol_code_m20 ASC
                                 )
/


ALTER TABLE dfn_ntp.t70_mark_to_market
   ADD CONSTRAINT t70_pk PRIMARY KEY (t70_id) USING INDEX
/