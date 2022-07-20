-- Table DFN_NTP.V10_TIF

CREATE TABLE dfn_ntp.v10_tif
(
    v10_id                     NUMBER (2, 0),
    v10_description            VARCHAR2 (75),
    v10_default                NUMBER (1, 0) DEFAULT 1,
    v10_expiry_date_required   NUMBER (1, 0) DEFAULT 0,
    v10_expiry_date_offset     NUMBER (2, 0) DEFAULT 0,
    v10_expiry_time_required   VARCHAR2 (1) DEFAULT 0,
    v10_is_available_in_fix    NUMBER (1, 0) DEFAULT 0,
    v10_duration               NUMBER (3, 0) DEFAULT 0
)
/

-- Constraints for  DFN_NTP.V10_TIF


  ALTER TABLE dfn_ntp.v10_tif MODIFY (v10_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v10_tif MODIFY (v10_description NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v10_tif MODIFY (v10_default NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v10_tif MODIFY (v10_expiry_date_required NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v10_tif MODIFY (v10_expiry_date_offset NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v10_tif MODIFY (v10_expiry_time_required NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v10_tif MODIFY (v10_is_available_in_fix NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v10_tif MODIFY (v10_duration NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v10_tif ADD CONSTRAINT v10_pk PRIMARY KEY (v10_id)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.V10_TIF

COMMENT ON COLUMN dfn_ntp.v10_tif.v10_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.v10_tif.v10_description IS 'descriptions'
/
COMMENT ON COLUMN dfn_ntp.v10_tif.v10_default IS
    'is this a default TIF used for exchanges'
/
COMMENT ON COLUMN dfn_ntp.v10_tif.v10_expiry_date_required IS
    'whether we need to show expiry date or not'
/
COMMENT ON COLUMN dfn_ntp.v10_tif.v10_expiry_date_offset IS
    'if expiry date required how many dates from the current date the expiry data should be. if this is non zero user can not set the expiry date from order entry'
/
COMMENT ON COLUMN dfn_ntp.v10_tif.v10_expiry_time_required IS
    'whether we need to show expiry time or not'
/
COMMENT ON TABLE dfn_ntp.v10_tif IS
    'this table keeps all the TIF used in FIX.'
/
-- End of DDL Script for Table DFN_NTP.V10_TIF


ALTER TABLE dfn_ntp.v10_tif
 ADD (
  v10_description_lang VARCHAR2 (200)
)
/
