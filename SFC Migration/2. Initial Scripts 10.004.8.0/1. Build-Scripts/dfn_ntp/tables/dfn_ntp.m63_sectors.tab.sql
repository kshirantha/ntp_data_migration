-- Table DFN_NTP.M63_SECTORS

CREATE TABLE dfn_ntp.m63_sectors
(
    m63_id                         NUMBER (5, 0),
    m63_exchange_id_m01            NUMBER (5, 0),
    m63_exchange_code_m01          VARCHAR2 (10),
    m63_sector_code                VARCHAR2 (25),
    m63_description                VARCHAR2 (75),
    m63_description_lang           VARCHAR2 (75),
    m63_shortdescription           VARCHAR2 (75),
    m63_shortdescription_lang      VARCHAR2 (75),
    m63_created_by_id_u17          NUMBER (20, 0),
    m63_created_date               DATE,
    m63_modified_by_id_u17         NUMBER (20, 0),
    m63_modified_date              DATE,
    m63_status_id_v01              NUMBER (20, 0),
    m63_status_changed_by_id_u17   NUMBER (20, 0),
    m63_status_changed_date        DATE
)
/

-- Constraints for  DFN_NTP.M63_SECTORS


  ALTER TABLE dfn_ntp.m63_sectors ADD CONSTRAINT m63_pk PRIMARY KEY (m63_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m63_sectors MODIFY (m63_exchange_code_m01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m63_sectors MODIFY (m63_sector_code NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M63_SECTORS

COMMENT ON COLUMN dfn_ntp.m63_sectors.m63_exchange_code_m01 IS 'fk from m01'
/
COMMENT ON COLUMN dfn_ntp.m63_sectors.m63_sector_code IS
    'sector id, unique for exchange'
/
COMMENT ON COLUMN dfn_ntp.m63_sectors.m63_description IS
    'english description'
/
COMMENT ON COLUMN dfn_ntp.m63_sectors.m63_description_lang IS
    'other descsription'
/
COMMENT ON COLUMN dfn_ntp.m63_sectors.m63_shortdescription IS
    'english short description'
/
COMMENT ON COLUMN dfn_ntp.m63_sectors.m63_shortdescription_lang IS
    'other short  descsription'
/
-- End of DDL Script for Table DFN_NTP.M63_SECTORS

alter table dfn_ntp.M63_SECTORS
	add M63_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE DFN_NTP.M63_SECTORS 
 ADD (
  M63_INSTITUTE_ID_M02 NUMBER (3)
 )
/

COMMENT ON COLUMN dfn_ntp.m63_sectors.m63_institute_id_m02 IS
    'Primary Institution'
/