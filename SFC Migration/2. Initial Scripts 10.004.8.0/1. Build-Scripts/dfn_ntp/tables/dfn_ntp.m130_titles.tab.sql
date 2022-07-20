-- Table DFN_NTP.M130_TITLES

CREATE TABLE dfn_ntp.m130_titles
(
    m130_id                         NUMBER (3, 0),
    m130_description                VARCHAR2 (75),
    m130_description_lang           VARCHAR2 (75),
    m130_created_by_id_u17          NUMBER (20, 0),
    m130_created_date               DATE DEFAULT SYSDATE,
    m130_modified_by_id_u17         NUMBER (20, 0),
    m130_modified_date              DATE,
    m130_status_id_v01              NUMBER (20, 0),
    m130_status_changed_by_id_u17   NUMBER (20, 0),
    m130_status_changed_date        DATE
)
/

-- Constraints for  DFN_NTP.M130_TITLES


  ALTER TABLE dfn_ntp.m130_titles MODIFY (m130_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m130_titles MODIFY (m130_description NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m130_titles MODIFY (m130_description_lang NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M130_TITLES

alter table dfn_ntp.M130_TITLES
	add M130_CUSTOM_TYPE varchar2(50) default 1
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.m130_titles
ADD (
  m130_external_ref NUMBER (5)
)';

BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('m130_titles')
           AND column_name = UPPER ('m130_external_ref');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
