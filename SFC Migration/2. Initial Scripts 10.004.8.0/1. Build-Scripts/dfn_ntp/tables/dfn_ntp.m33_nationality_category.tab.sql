-- Table DFN_NTP.M33_NATIONALITY_CATEGORY

CREATE TABLE dfn_ntp.m33_nationality_category
(
    m33_id                         NUMBER (5, 0),
    m33_description                VARCHAR2 (255 CHAR),
    m33_created_by_id_u17          NUMBER (20, 0),
    m33_created_date               TIMESTAMP (7),
    m33_modified_by_id_u17         NUMBER (20, 0),
    m33_modified_date              TIMESTAMP (7),
    m33_status_id_v01              NUMBER (20, 0),
    m33_status_changed_by_id_u17   NUMBER (20, 0),
    m33_status_changed_date        TIMESTAMP (7)
)
/

-- Constraints for  DFN_NTP.M33_NATIONALITY_CATEGORY


  ALTER TABLE dfn_ntp.m33_nationality_category ADD CONSTRAINT primary PRIMARY KEY (m33_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m33_nationality_category MODIFY (m33_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m33_nationality_category MODIFY (m33_description NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m33_nationality_category MODIFY (m33_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m33_nationality_category MODIFY (m33_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m33_nationality_category MODIFY (m33_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m33_nationality_category MODIFY (m33_status_changed_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m33_nationality_category MODIFY (m33_status_changed_date NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M33_NATIONALITY_CATEGORY

COMMENT ON COLUMN dfn_ntp.m33_nationality_category.m33_id IS 'pk'
/
-- End of DDL Script for Table DFN_NTP.M33_NATIONALITY_CATEGORY

alter table dfn_ntp.M33_NATIONALITY_CATEGORY
	add M33_CUSTOM_TYPE varchar2(50) default 1
/
