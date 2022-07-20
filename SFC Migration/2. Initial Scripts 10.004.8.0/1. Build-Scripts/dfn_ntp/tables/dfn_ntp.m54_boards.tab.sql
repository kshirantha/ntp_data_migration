CREATE TABLE dfn_ntp.m54_boards
(
    m54_id                           NUMBER (3, 0),
    m54_exchange_code_m01            VARCHAR2 (10 BYTE),
    m54_exchange_id_m01              NUMBER (5, 0),
    m54_code                         VARCHAR2 (6 BYTE),
    m54_exg_brd_status_id_v19        NUMBER (2, 0),
    m54_exg_brd_sts_updated_date     DATE,
    m54_is_default                   NUMBER (1, 0),
    m54_is_active                    NUMBER (1, 0),
    m54_preopen_allowed              NUMBER (1, 0),
    m54_last_preopened_date          DATE,
    m54_last_eod_date                DATE,
    m54_status_id_v01                NUMBER (5, 0),
    m54_status_changed_by_id_u17     NUMBER (10, 0),
    m54_status_changed_date          DATE,
    m54_created_by_id_u17            NUMBER (10, 0),
    m54_created_date                 DATE,
    m54_modified_by_id_u17           NUMBER (10, 0),
    m54_modified_date                DATE,
    m54_custom_type                  VARCHAR2 (50 BYTE) DEFAULT 1,
    m54_primary_institution_id_m02   NUMBER (3, 0) DEFAULT 1,
    m54_price_brd_code               VARCHAR2 (10 BYTE)
)
/

ALTER TABLE dfn_ntp.m54_boards
ADD CONSTRAINT m54_brd_pk PRIMARY KEY (m54_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m54_boards.m54_exg_brd_status_id_v19 IS
    '2:OPEN,4:PreOpen,3:Closed,5:PreClosed,20:TradeAtLast,27:ClosingAuction'
/
COMMENT ON COLUMN dfn_ntp.m54_boards.m54_is_active IS '1=yes, 0=no'
/
COMMENT ON COLUMN dfn_ntp.m54_boards.m54_is_default IS
    'is default board for exchange'
/
COMMENT ON COLUMN dfn_ntp.m54_boards.m54_primary_institution_id_m02 IS
    'Primary Institution'
/
COMMENT ON COLUMN dfn_ntp.m54_boards.m54_status_id_v01 IS
    'Session status(i.e. connectivity to stp/appia)'
/

ALTER TABLE dfn_ntp.m54_boards
 ADD (
  m54_trade_type_v01 NUMBER (5)
 )
/

COMMENT ON COLUMN dfn_ntp.m54_boards.m54_trade_type_v01 IS 'v01_type = 27'
/

ALTER TABLE dfn_ntp.m54_boards
ADD (
m54_is_active_process VARCHAR2 (20) DEFAULT 'NONE',
m54_manual_suspend NUMBER (1)
)
/

COMMENT ON COLUMN dfn_ntp.m54_boards.m54_is_active_process IS
    'PRE_OPEN_RUNNING | EOD_RUNNING | NONE'
/

COMMENT ON COLUMN dfn_ntp.m54_boards.m54_manual_suspend IS
    '1 - Suspended | 0 - Not Suspended'
/

ALTER TABLE dfn_ntp.M54_BOARDS 
 ADD (
  M54_PRICE_FLUCTUATION NUMBER (5, 0)
 )
/

COMMENT ON COLUMN dfn_ntp.M54_BOARDS.M54_PRICE_FLUCTUATION IS 'Price fluctuation percentage'
/


ALTER TABLE dfn_ntp.m54_boards
 MODIFY (
  m54_code VARCHAR2 (10 BYTE)

 )
/

ALTER TABLE dfn_ntp.M54_BOARDS
 ADD ( 
  m54_last_symbol_status_req_dat DATE
 )
/

ALTER TABLE dfn_ntp.M54_BOARDS
 ADD ( 
  m54_last_market_status_req_dat DATE
 )
/
