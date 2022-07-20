-- Table DFN_NTP.Z07_MENU

CREATE TABLE dfn_ntp.z07_menu
(
    z07_id             VARCHAR2 (20),
    z07_loc_id         VARCHAR2 (10),
    z07_name           VARCHAR2 (50),
    z07_tag            VARCHAR2 (50),
    z07_sec_id         NUMBER (5, 0),
    z07_fkey           NUMBER (10, 0),
    z07_hide           NUMBER (1, 0),
    z07_icon           VARCHAR2 (50),
    z07_route          VARCHAR2 (500),
    z07_query_params   VARCHAR2 (500),
    z07_pkey           NUMBER (20, 0)
)
/

-- Constraints for  DFN_NTP.Z07_MENU


  ALTER TABLE dfn_ntp.z07_menu MODIFY (z07_id NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.Z07_MENU

COMMENT ON COLUMN dfn_ntp.z07_menu.z07_id IS 'Menu ID'
/
COMMENT ON COLUMN dfn_ntp.z07_menu.z07_loc_id IS 'Location ID'
/
COMMENT ON COLUMN dfn_ntp.z07_menu.z07_tag IS 'Tag'
/
COMMENT ON COLUMN dfn_ntp.z07_menu.z07_sec_id IS 'Entilement ID'
/
COMMENT ON COLUMN dfn_ntp.z07_menu.z07_fkey IS 'Function Key'
/
COMMENT ON COLUMN dfn_ntp.z07_menu.z07_hide IS '1=Hide'
/
-- End of DDL Script for Table DFN_NTP.Z07_MENU

alter table dfn_ntp.Z07_MENU
	add Z07_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.Z07_MENU
 ADD (
  Z07_Is_Customized NUMBER (1, 0) DEFAULT 0,
  z07_deleted_from_core NUMBER (1, 0) DEFAULT 0
)
/
COMMENT ON COLUMN dfn_ntp.Z07_MENU.Z07_Is_Customized IS '1 = customization done'
/
COMMENT ON COLUMN dfn_ntp.Z07_MENU.z07_deleted_from_core IS '1 = deleted from core'
/

alter table dfn_ntp.Z07_MENU drop column Z07_LOC_ID
/

alter table dfn_ntp.Z07_MENU
	add Z07_BROKER_CODE varchar2(50)
/

ALTER TABLE DFN_NTP.Z07_MENU
 ADD (
  Z07_FEATURE_ID_V14 NUMBER (3,0)
 )
/



ALTER TABLE dfn_ntp.z07_menu
 ADD (
  z07_form_title VARCHAR2 (200)
 )
/
