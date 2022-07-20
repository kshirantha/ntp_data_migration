CREATE TABLE dfn_csm.a14_settlement_position_rep
(
    a14_id               NUMBER (18, 0),
    a14_rptid            VARCHAR2 (50 BYTE),
    a14_reqid            NUMBER (18, 0),
    a14_bizdt            DATE,
    a14_msgevtsrc        NUMBER (2, 0),
    a14_symbol           VARCHAR2 (18 BYTE),
    a14_isincode         VARCHAR2 (18 BYTE),
    a14_settldt          DATE,
    a14_txntm            DATE,
    a14_qty_typ          VARCHAR2 (10 BYTE),
    a14_qty_long         NUMBER (18, 0),
    a14_qty_short        NUMBER (18, 0),
    a14_qty_stat         NUMBER (4, 0),
    a14_qtydt            DATE,
    a14_amt_typ          VARCHAR2 (50 BYTE),
    a14_amt              NUMBER (18, 0),
    a14_amt_ccy          VARCHAR2 (10 BYTE),
    a14_amt_rsn          NUMBER (4, 0),
    a14_settlement_acc   VARCHAR2 (15 BYTE)
)
SEGMENT CREATION DEFERRED
NOPARALLEL
LOGGING
MONITORING
/



COMMENT ON COLUMN dfn_csm.a14_settlement_position_rep.a14_amt IS 'Amount'
/
COMMENT ON COLUMN dfn_csm.a14_settlement_position_rep.a14_amt_ccy IS
    'Currency'
/
COMMENT ON COLUMN dfn_csm.a14_settlement_position_rep.a14_amt_rsn IS
    'Position Reason : 1001 = AmountBuy, 1002 = AmountSell, 1003 = PendingAmountBuy, 1004 = PendingAmountSell, 1005 = InstructedAmountBuy, 1006 = InstructedAmountSell'
/
COMMENT ON COLUMN dfn_csm.a14_settlement_position_rep.a14_amt_typ IS
    'Position Amount Type'
/
COMMENT ON COLUMN dfn_csm.a14_settlement_position_rep.a14_bizdt IS
    'Report Date'
/
COMMENT ON COLUMN dfn_csm.a14_settlement_position_rep.a14_isincode IS
    'ISIN code'
/
COMMENT ON COLUMN dfn_csm.a14_settlement_position_rep.a14_qty_long IS
    'Long Qty'
/
COMMENT ON COLUMN dfn_csm.a14_settlement_position_rep.a14_qty_short IS
    'Short Qty'
/
COMMENT ON COLUMN dfn_csm.a14_settlement_position_rep.a14_qty_stat IS
    'Position Status : 1003 = Pending, 1005 = Instructed'
/
COMMENT ON COLUMN dfn_csm.a14_settlement_position_rep.a14_qty_typ IS
    'Position Type'
/
COMMENT ON COLUMN dfn_csm.a14_settlement_position_rep.a14_qtydt IS
    'Instruction generated Date'
/
COMMENT ON COLUMN dfn_csm.a14_settlement_position_rep.a14_reqid IS
    'Request ID - A13_ID'
/
COMMENT ON COLUMN dfn_csm.a14_settlement_position_rep.a14_rptid IS
    'Unique ID of the report response'
/
COMMENT ON COLUMN dfn_csm.a14_settlement_position_rep.a14_settldt IS
    'Settlement Date'
/
COMMENT ON COLUMN dfn_csm.a14_settlement_position_rep.a14_settlement_acc IS
    'Settlement Account'
/
COMMENT ON COLUMN dfn_csm.a14_settlement_position_rep.a14_symbol IS 'Symbol'
/
COMMENT ON COLUMN dfn_csm.a14_settlement_position_rep.a14_txntm IS
    'Report time'
/


