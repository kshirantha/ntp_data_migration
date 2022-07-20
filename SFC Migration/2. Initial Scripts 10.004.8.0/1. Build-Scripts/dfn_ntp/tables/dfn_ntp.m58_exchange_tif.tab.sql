-- Table DFN_NTP.M58_EXCHANGE_TIF

CREATE TABLE dfn_ntp.m58_exchange_tif
(
    m58_id                NUMBER (4, 0),
    m58_exchange_id_m01   NUMBER (5, 0),
    m58_tif_id_v10        NUMBER (2, 0),
    m58_duration          NUMBER (3, 0) DEFAULT 0
)
/

-- Constraints for  DFN_NTP.M58_EXCHANGE_TIF


  ALTER TABLE dfn_ntp.m58_exchange_tif ADD CONSTRAINT m58_exchange_tif_uk UNIQUE (m58_exchange_id_m01, m58_tif_id_v10) DISABLE
/

  ALTER TABLE dfn_ntp.m58_exchange_tif ADD CONSTRAINT m58_pk PRIMARY KEY (m58_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m58_exchange_tif MODIFY (m58_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m58_exchange_tif MODIFY (m58_exchange_id_m01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m58_exchange_tif MODIFY (m58_tif_id_v10 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m58_exchange_tif MODIFY (m58_duration NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M58_EXCHANGE_TIF

COMMENT ON COLUMN dfn_ntp.m58_exchange_tif.m58_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.m58_exchange_tif.m58_exchange_id_m01 IS
    'fk from m01'
/
COMMENT ON COLUMN dfn_ntp.m58_exchange_tif.m58_tif_id_v10 IS 'fk from v10'
/
COMMENT ON TABLE dfn_ntp.m58_exchange_tif IS
    'this table keeps all the TIF used in exchange'
/
-- End of DDL Script for Table DFN_NTP.M58_EXCHANGE_TIF
