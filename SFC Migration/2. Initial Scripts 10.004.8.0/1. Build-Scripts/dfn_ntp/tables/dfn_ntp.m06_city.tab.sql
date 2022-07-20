-- Table DFN_NTP.M06_CITY

CREATE TABLE dfn_ntp.m06_city
(
    m06_id                         NUMBER (5, 0),
    m06_country_id_m05             NUMBER (5, 0),
    m06_name                       VARCHAR2 (50),
    m06_name_lang                  VARCHAR2 (50),
    m06_created_by_id_u17          NUMBER (10, 0),
    m06_created_date               DATE,
    m06_status_id_v01              NUMBER (5, 0),
    m06_modified_by_id_u17         NUMBER (10, 0),
    m06_modified_date              DATE,
    m06_status_changed_by_id_u17   NUMBER (10, 0),
    m06_status_changed_date        DATE,
    m06_external_ref               VARCHAR2 (20),
    m06_custom_type                VARCHAR2 (50),
    PRIMARY KEY (m06_id) ENABLE
)
ORGANIZATION INDEX
NOCOMPRESS
/

-- Constraints for  DFN_NTP.M06_CITY


  ALTER TABLE dfn_ntp.m06_city MODIFY (m06_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m06_city MODIFY (m06_country_id_m05 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m06_city MODIFY (m06_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m06_city MODIFY (m06_name_lang NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m06_city MODIFY (m06_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m06_city MODIFY (m06_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m06_city MODIFY (m06_status_id_v01 NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M06_CITY

COMMENT ON COLUMN dfn_ntp.m06_city.m06_custom_type IS
    'To support customization'
/
-- End of DDL Script for Table DFN_NTP.M06_CITY
