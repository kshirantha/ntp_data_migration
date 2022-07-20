-- Table DFN_NTP.Z01_FORMS_M

CREATE TABLE dfn_ntp.z01_forms_m
(
    z01_id                         NUMBER (5, 0),
    z01_tag                        VARCHAR2 (200),
    z01_version_no                 NUMBER (5, 0),
    z01_view_name                  VARCHAR2 (200),
    z01_title                      NVARCHAR2 (200),
    z01_form_type                  NUMBER (1, 0),
    z01_location_id                VARCHAR2 (10),
    z01_sort_column                VARCHAR2 (200),
    z01_date_field                 VARCHAR2 (100),
    z01_truncate_date              NUMBER (1, 0),
    z01_load_all_data              NUMBER (1, 0),
    z01_time_stamp                 DATE,
    z01_has_sensitive_data         NUMBER (1, 0) DEFAULT 1,
    z01_excel_export_sec_id        NUMBER (5, 0),
    z01_textfile_export_sec_id     NUMBER (5, 0),
    z01_auto_refresh               NUMBER (1, 0) DEFAULT 0,
    z01_source_type                NUMBER (1, 0) DEFAULT 1,
    z01_ignore_sort                NUMBER (1, 0) DEFAULT 0,
    z01_load_data_on_opening       NUMBER (1, 0) DEFAULT 1,
    z01_fully_loaded               NUMBER (1, 0) DEFAULT 0,
    z01_updated_datetime           DATE,
    z01_columns_updated_datetime   DATE,
    z01_menus_updated_datetime     DATE,
    z01_colors_updated_datetime    DATE
)
/

-- Constraints for  DFN_NTP.Z01_FORMS_M


  ALTER TABLE dfn_ntp.z01_forms_m MODIFY (z01_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z01_forms_m MODIFY (z01_tag NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z01_forms_m MODIFY (z01_version_no NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z01_forms_m MODIFY (z01_view_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z01_forms_m MODIFY (z01_title NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z01_forms_m MODIFY (z01_form_type NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z01_forms_m MODIFY (z01_has_sensitive_data NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z01_forms_m MODIFY (z01_source_type NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.Z01_FORMS_M

COMMENT ON COLUMN dfn_ntp.z01_forms_m.z01_form_type IS
    '1 = Normal | 2 = Date | 3 = Month'
/
COMMENT ON COLUMN dfn_ntp.z01_forms_m.z01_source_type IS '1 = View | 2 = SP'
/
-- End of DDL Script for Table DFN_NTP.Z01_FORMS_M

alter table dfn_ntp.Z01_FORMS_M
	add Z01_CUSTOM_TYPE varchar2(50) default 1
/

alter table dfn_ntp.Z01_FORMS_M
	add Z01_BROKER_CODE varchar2(50)
/

ALTER TABLE dfn_ntp.Z01_FORMS_M 
 ADD (
  Z01_Is_Customized NUMBER (1, 0) DEFAULT 0
)
/

COMMENT ON COLUMN dfn_ntp.Z01_FORMS_M.Z01_Is_Customized IS '1 = customization done'
/


alter table dfn_ntp.Z01_FORMS_M drop column Z01_LOCATION_ID
/

ALTER TABLE DFN_NTP.Z01_FORMS_M
 ADD (
  Z01_FEATURE_ID_V14 NUMBER (3,0)
 )
/
