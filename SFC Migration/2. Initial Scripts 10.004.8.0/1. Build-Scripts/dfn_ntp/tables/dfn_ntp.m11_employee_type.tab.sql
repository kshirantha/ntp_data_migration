-- Table DFN_NTP.M11_EMPLOYEE_TYPE

CREATE TABLE dfn_ntp.m11_employee_type
(
    m11_id                         NUMBER (5, 0),
    m11_institute_id_m02           NUMBER (3, 0),
    m11_name                       VARCHAR2 (100),
    m11_name_lang                  VARCHAR2 (100),
    m11_category                   NUMBER (1, 0),
    m11_created_by_id_u17          NUMBER (10, 0),
    m11_created_date               TIMESTAMP (6),
    m11_status_id_v01              NUMBER (5, 0),
    m11_modified_by_id_u17         NUMBER (10, 0),
    m11_modified_date              TIMESTAMP (6),
    m11_status_changed_by_id_u17   NUMBER (10, 0),
    m11_status_changed_date        TIMESTAMP (6),
    m11_external_ref               VARCHAR2 (20),
    PRIMARY KEY (m11_id) ENABLE
)
ORGANIZATION INDEX
NOCOMPRESS
/

-- Constraints for  DFN_NTP.M11_EMPLOYEE_TYPE


  ALTER TABLE dfn_ntp.m11_employee_type MODIFY (m11_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m11_employee_type MODIFY (m11_institute_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m11_employee_type MODIFY (m11_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m11_employee_type MODIFY (m11_name_lang NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m11_employee_type MODIFY (m11_category NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m11_employee_type MODIFY (m11_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m11_employee_type ADD CONSTRAINT uk_m11_name UNIQUE (m11_name)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m11_employee_type MODIFY (m11_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m11_employee_type MODIFY (m11_created_date NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M11_EMPLOYEE_TYPE

COMMENT ON COLUMN dfn_ntp.m11_employee_type.m11_category IS
    'ATUser = 1,  Dealer = 2'
/
-- End of DDL Script for Table DFN_NTP.M11_EMPLOYEE_TYPE

ALTER TABLE dfn_ntp.m11_employee_type
DROP COLUMN m11_institute_id_m02
/

COMMENT ON COLUMN dfn_ntp.m11_employee_type.m11_category IS
    'ATUser = 1,  Dealer = 2 SystemUser = 3'
/
