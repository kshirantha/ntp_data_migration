CREATE TABLE dfn_ntp.m29_markets
(
    m29_exchange_code_m01            VARCHAR2 (10 BYTE),
    m29_current_mkt_status_id_v19    NUMBER (2, 0),
    m29_market_code                  VARCHAR2 (6 BYTE),
    m29_last_status_updated          DATE,
    m29_is_default                   NUMBER (1, 0),
    m29_is_active                    NUMBER (1, 0),
    m29_status_id_v01                NUMBER (5, 0),
    m29_id                           NUMBER (3, 0),
    m29_exchange_id_m01              NUMBER (5, 0),
    m29_preopen_allowed              NUMBER (1, 0),
    m29_last_preopened_date          DATE,
    m29_last_eod_date                DATE,
    m29_status_changed_by_id_u17     NUMBER (10, 0),
    m29_status_changed_date          DATE,
    m29_created_by_id_u17            NUMBER (10, 0),
    m29_created_date                 DATE,
    m29_modified_by_id_u17           NUMBER (10, 0),
    m29_modified_date                DATE,
    m29_is_active_process            VARCHAR2 (20 BYTE) DEFAULT 'NONE',
    m29_manual_suspend               NUMBER (1, 0) DEFAULT 0,
    m29_custom_type                  VARCHAR2 (50 BYTE) DEFAULT 1,
    m29_primary_institution_id_m02   NUMBER (3, 0) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.m29_markets
ADD CONSTRAINT m29_pk PRIMARY KEY (m29_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m29_markets.m29_current_mkt_status_id_v19 IS
    '2:OPEN,4:PreOpen,3:Closed,5:PreClosed,20:TradeAtLast,27:ClosingAuction'
/
COMMENT ON COLUMN dfn_ntp.m29_markets.m29_is_active IS '1=yes, 0=no'
/
COMMENT ON COLUMN dfn_ntp.m29_markets.m29_is_active_process IS
    'PRE_OPEN_RUNNING, EOD_RUNNING, NONE'
/
COMMENT ON COLUMN dfn_ntp.m29_markets.m29_is_default IS
    'is default submarket for exchange'
/
COMMENT ON COLUMN dfn_ntp.m29_markets.m29_last_status_updated IS
    '//maket status update time'
/
COMMENT ON COLUMN dfn_ntp.m29_markets.m29_manual_suspend IS
    '1-Suspended, 0-Not suspended'
/
COMMENT ON COLUMN dfn_ntp.m29_markets.m29_primary_institution_id_m02 IS
    'Primary Institution'
/
COMMENT ON COLUMN dfn_ntp.m29_markets.m29_status_id_v01 IS
    'Session status(i.e. connectivity to stp/appia)'
/

ALTER TABLE dfn_ntp.m29_markets
 ADD (
  m29_price_market_code VARCHAR2 (10)
 )
/
