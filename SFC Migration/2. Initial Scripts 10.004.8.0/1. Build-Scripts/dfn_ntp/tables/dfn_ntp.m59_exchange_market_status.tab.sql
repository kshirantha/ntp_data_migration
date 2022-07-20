-- Table DFN_NTP.M59_EXCHANGE_MARKET_STATUS

CREATE TABLE dfn_ntp.m59_exchange_market_status
(
    m59_id                     NUMBER (3, 0),
    m59_exchange_id_m01        NUMBER (5, 0),
    m59_market_status_id_v19   NUMBER (2, 0),
    m59_exchange_code_m01      VARCHAR2 (10)
)
/

-- Constraints for  DFN_NTP.M59_EXCHANGE_MARKET_STATUS


  ALTER TABLE dfn_ntp.m59_exchange_market_status ADD CONSTRAINT m59_pk PRIMARY KEY (m59_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m59_exchange_market_status MODIFY (m59_id NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M59_EXCHANGE_MARKET_STATUS

COMMENT ON COLUMN dfn_ntp.m59_exchange_market_status.m59_exchange_id_m01 IS
    'fkey from m11'
/
COMMENT ON COLUMN dfn_ntp.m59_exchange_market_status.m59_market_status_id_v19 IS
    'fkey from m165'
/
-- End of DDL Script for Table DFN_NTP.M59_EXCHANGE_MARKET_STATUS

alter table dfn_ntp.M59_EXCHANGE_MARKET_STATUS
	add M59_CUSTOM_TYPE varchar2(50) default 1
/
