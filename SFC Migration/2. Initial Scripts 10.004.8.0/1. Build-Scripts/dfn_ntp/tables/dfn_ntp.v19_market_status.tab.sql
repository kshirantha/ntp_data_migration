-- Table DFN_NTP.V19_MARKET_STATUS

CREATE TABLE dfn_ntp.v19_market_status
(
    v19_id       NUMBER (2, 0),
    v19_status   VARCHAR2 (100)
)
/

-- Constraints for  DFN_NTP.V19_MARKET_STATUS


  ALTER TABLE dfn_ntp.v19_market_status MODIFY (v19_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v19_market_status ADD CONSTRAINT v19_pk PRIMARY KEY (v19_id)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.V19_MARKET_STATUS

COMMENT ON COLUMN dfn_ntp.v19_market_status.v19_id IS 'fk'
/
-- End of DDL Script for Table DFN_NTP.V19_MARKET_STATUS

ALTER TABLE dfn_ntp.v19_market_status
 ADD (
  v19_price_mapping_id NUMBER (2)
 )
/
COMMENT ON COLUMN dfn_ntp.v19_market_status.v19_price_mapping_id IS
    'Price Feed''s Mapping Required for DT'
/