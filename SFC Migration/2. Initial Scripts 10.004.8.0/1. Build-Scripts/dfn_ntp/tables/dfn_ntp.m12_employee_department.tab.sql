-- Table DFN_NTP.M12_EMPLOYEE_DEPARTMENT

CREATE TABLE dfn_ntp.m12_employee_department
(
    m12_id                         NUMBER (5, 0),
    m12_institute_id_m02           NUMBER (3, 0),
    m12_name                       VARCHAR2 (100),
    m12_created_by_id_u17          NUMBER (10, 0),
    m12_created_date               TIMESTAMP (6),
    m12_status_id_v01              NUMBER (5, 0),
    m12_modified_by_id_u17         NUMBER (10, 0),
    m12_modified_date              TIMESTAMP (6),
    m12_status_changed_by_id_u17   NUMBER (10, 0),
    m12_status_changed_date        TIMESTAMP (6),
    m12_external_ref               VARCHAR2 (20),
    m12_code                       VARCHAR2 (100),
    m12_name_lang                  VARCHAR2 (100),
    PRIMARY KEY (m12_id) ENABLE
)
ORGANIZATION INDEX
NOCOMPRESS
/

-- Constraints for  DFN_NTP.M12_EMPLOYEE_DEPARTMENT


  ALTER TABLE dfn_ntp.m12_employee_department MODIFY (m12_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m12_employee_department ADD CONSTRAINT uk_m12_name UNIQUE (m12_name)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m12_employee_department MODIFY (m12_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m12_employee_department MODIFY (m12_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m12_employee_department MODIFY (m12_created_date NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M12_EMPLOYEE_DEPARTMENT

alter table dfn_ntp.M12_EMPLOYEE_DEPARTMENT
	add M12_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m12_employee_department
    DROP CONSTRAINT uk_m12_name DROP INDEX
/

ALTER TABLE dfn_ntp.m12_employee_department
    ADD CONSTRAINT uk_m12_name UNIQUE (m12_name, m12_institute_id_m02)
        USING INDEX ENABLE
/