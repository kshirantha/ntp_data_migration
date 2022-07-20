CREATE TABLE dfn_ntp.u24_holdings
(
    u24_custodian_id_m26        NUMBER (10, 0) NOT NULL,
    u24_holding_block           NUMBER (18, 0) DEFAULT 0 NOT NULL,
    u24_sell_pending            NUMBER (18, 0),
    u24_buy_pending             NUMBER (18, 0),
    u24_weighted_avg_price      NUMBER (18, 5),
    u24_avg_price               NUMBER (18, 5),
    u24_weighted_avg_cost       NUMBER (18, 5),
    u24_avg_cost                NUMBER (18, 5),
    u24_receivable_holding      NUMBER (18, 0) DEFAULT 0 NOT NULL,
    u24_payable_holding         NUMBER (18, 0) DEFAULT 0 NOT NULL,
    u24_net_holding             NUMBER (18, 0) DEFAULT 0 NOT NULL,
    u24_trading_acnt_id_u07     NUMBER (10, 0) NOT NULL,
    u24_symbol_code_m20         VARCHAR2 (10 BYTE),
    u24_exchange_code_m01       VARCHAR2 (10 BYTE) DEFAULT NULL NOT NULL,
    u24_last_update_datetime    DATE,
    u24_custodian_code_m26      VARCHAR2 (50 BYTE),
    u24_realized_gain_lost      NUMBER (18, 5),
    u24_currency_code_m03       VARCHAR2 (5 BYTE),
    u24_price_inst_type         NUMBER (5, 0),
    u24_dbseqid                 NUMBER (10, 0),
    u24_ordexecseq              NUMBER (20, 0),
    u24_symbol_id_m20           NUMBER (10, 0) NOT NULL,
    u24_pledge_qty              NUMBER (18, 0) DEFAULT 0 NOT NULL,
    u24_manual_block            NUMBER (18, 5) DEFAULT 0 NOT NULL,
    u24_subscribed_qty          NUMBER (18, 0) DEFAULT 0,
    u24_pending_subscribe_qty   NUMBER (18, 0),
    u24_short_holdings          NUMBER (18, 0) DEFAULT 0
)
/



CREATE INDEX dfn_ntp.ind_exc
    ON dfn_ntp.u24_holdings (u24_last_update_datetime ASC)
    NOPARALLEL
    LOGGING
/


ALTER TABLE dfn_ntp.u24_holdings
ADD CONSTRAINT pk_u24_holdings PRIMARY KEY (u24_custodian_id_m26,
  u24_trading_acnt_id_u07, u24_exchange_code_m01, u24_symbol_id_m20)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.u24_holdings.u24_manual_block IS
    'U24_MANUAL_BLOCK (Other Block)'
/
COMMENT ON COLUMN dfn_ntp.u24_holdings.u24_pending_subscribe_qty IS
    'pending subscribed qty'
/
COMMENT ON COLUMN dfn_ntp.u24_holdings.u24_price_inst_type IS
    'Price Instrument Type'
/
COMMENT ON COLUMN dfn_ntp.u24_holdings.u24_short_holdings IS 'Short Holdings'
/
COMMENT ON COLUMN dfn_ntp.u24_holdings.u24_subscribed_qty IS 'Subscribed Qty'
/
ALTER TABLE dfn_ntp.u24_holdings
 MODIFY (
  u24_symbol_code_m20 NOT NULL

 )
/

ALTER TABLE dfn_ntp.u24_holdings
 ADD (
  u24_net_receivable NUMBER (18, 0) DEFAULT 0
 )
/

ALTER TABLE DFN_NTP.U24_HOLDINGS 
 MODIFY (
  U24_DBSEQID NUMBER (20, 0)

 )
/

ALTER TABLE dfn_ntp.U24_HOLDINGS 
 MODIFY (
  U24_WEIGHTED_AVG_PRICE NUMBER (21, 8),
  U24_AVG_PRICE NUMBER (21, 8),
  U24_WEIGHTED_AVG_COST NUMBER (21, 8),
  U24_AVG_COST NUMBER (21, 8)

 )
/

ALTER TABLE DFN_NTP.U24_HOLDINGS 
 ADD (
  U24_BASE_HOLDING_BLOCK NUMBER (18),
  U24_BASE_CASH_BLOCK NUMBER (18)
 )
/
COMMENT ON COLUMN DFN_NTP.U24_HOLDINGS.U24_BASE_HOLDING_BLOCK IS 'Option Base Holding Block'
/
COMMENT ON COLUMN DFN_NTP.U24_HOLDINGS.U24_BASE_CASH_BLOCK IS 'Option Base Cash Block'
/


ALTER TABLE DFN_NTP.U24_HOLDINGS 
 MODIFY (
  U24_BASE_HOLDING_BLOCK DEFAULT 0,
  U24_BASE_CASH_BLOCK DEFAULT 0

 )
/

ALTER TABLE DFN_NTP.U24_HOLDINGS 
 ADD (
  U24_SHORT_HOLDING_BLOCK NUMBER (18)
 )
/

ALTER TABLE DFN_NTP.u24_holdings
 ADD (
  u24_maintain_margin_charged NUMBER (18, 0) DEFAULT 0,
  u24_maintain_margin_block NUMBER (18, 0) DEFAULT 0,
  u24_m2m_profit NUMBER (18, 0) DEFAULT 0,
  u24_derivative_fixing_price NUMBER (18, 5) DEFAULT 0
 )
/

ALTER TABLE dfn_ntp.u24_holdings
 MODIFY (
  u24_symbol_code_m20 VARCHAR2 (50 BYTE)

 )
/

ALTER TABLE dfn_ntp.u24_holdings
 ADD (
  u24_long_holdings NUMBER (18, 0) DEFAULT 0
)
/

ALTER TABLE dfn_ntp.u24_holdings
 ADD (
  u24_cash_account_id_u06 NUMBER (10, 0)
)
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.u24_holdings DROP CONSTRAINT pk_u24_holdings';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_constraints
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('u24_holdings')
           AND constraint_name = UPPER ('pk_u24_holdings');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.u24_holdings ADD CONSTRAINT pk_u24_holdings PRIMARY KEY (u24_trading_acnt_id_u07, u24_exchange_code_m01, u24_symbol_id_m20, u24_custodian_id_m26) USING INDEX';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_constraints
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('u24_holdings')
           AND constraint_name = UPPER ('pk_u24_holdings');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/