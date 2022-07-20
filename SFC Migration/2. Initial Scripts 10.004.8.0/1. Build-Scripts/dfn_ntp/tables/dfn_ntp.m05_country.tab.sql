-- Table DFN_NTP.M05_COUNTRY

CREATE TABLE dfn_ntp.m05_country
(
    m05_id                         NUMBER (5, 0),
    m05_code                       VARCHAR2 (10),
    m05_name                       VARCHAR2 (50),
    m05_name_lang                  VARCHAR2 (50) DEFAULT NULL,
    m05_created_by_id_u17          NUMBER (10, 0),
    m05_created_date               DATE,
    m05_status_id_v01              NUMBER (5, 0),
    m05_modified_by_id_u17         NUMBER (10, 0),
    m05_modified_date              DATE,
    m05_status_changed_by_id_u17   NUMBER (10, 0),
    m05_status_changed_date        DATE,
    m05_external_ref               VARCHAR2 (20),
    m05_access_level_id_v01        NUMBER (5, 0),
    PRIMARY KEY (m05_id) ENABLE
)
ORGANIZATION INDEX
NOCOMPRESS
/

-- Constraints for  DFN_NTP.M05_COUNTRY


  ALTER TABLE dfn_ntp.m05_country MODIFY (m05_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m05_country MODIFY (m05_code NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m05_country MODIFY (m05_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m05_country MODIFY (m05_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m05_country MODIFY (m05_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m05_country MODIFY (m05_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m05_country ADD CONSTRAINT uk_m05_code UNIQUE (m05_code)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m05_country ADD CONSTRAINT uk_m05_name UNIQUE (m05_name)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.M05_COUNTRY

COMMENT ON COLUMN dfn_ntp.m05_country.m05_access_level_id_v01 IS
    'From (v01-1) Symbol access levels2'
/
-- End of DDL Script for Table DFN_NTP.M05_COUNTRY

alter table dfn_ntp.M05_COUNTRY
	add M05_CUSTOM_TYPE varchar2(50) default 1
/

CREATE UNIQUE INDEX dfn_ntp.idx_m05_fast
    ON dfn_ntp.m05_country (m05_id, m05_name, m05_name_lang)
/
