-- Table DFN_NTP.M114_COMPANY_POSITIONS

CREATE TABLE dfn_ntp.m114_company_positions
(
    m114_id                         NUMBER (4, 0),
    m114_description                VARCHAR2 (75),
    m114_description_lang           VARCHAR2 (100),
    m114_politically_exposed        NUMBER (1, 0) DEFAULT 0,
    m114_created_by_id_u17          NUMBER (20, 0),
    m114_created_date               DATE,
    m114_modified_by_id_u17         NUMBER (20, 0),
    m114_modified_date              DATE,
    m114_status_id_v01              NUMBER (20, 0),
    m114_status_changed_by_id_u17   NUMBER (20, 0),
    m114_status_changed_date        DATE
)
/

-- Constraints for  DFN_NTP.M114_COMPANY_POSITIONS


  ALTER TABLE dfn_ntp.m114_company_positions MODIFY (m114_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m114_company_positions MODIFY (m114_description NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m114_company_positions MODIFY (m114_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m114_company_positions MODIFY (m114_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m114_company_positions MODIFY (m114_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m114_company_positions MODIFY (m114_status_changed_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m114_company_positions MODIFY (m114_status_changed_date NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M114_COMPANY_POSITIONS

alter table dfn_ntp.M114_COMPANY_POSITIONS
	add M114_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m114_company_positions
 ADD (
  m114_institute_id_m02 NUMBER (3, 0) DEFAULT 1
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.m114_company_positions
ADD (
 m114_external_ref varchar2 (25 BYTE)
)';

BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('m114_company_positions')
           AND column_name = UPPER ('m114_external_ref');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/






