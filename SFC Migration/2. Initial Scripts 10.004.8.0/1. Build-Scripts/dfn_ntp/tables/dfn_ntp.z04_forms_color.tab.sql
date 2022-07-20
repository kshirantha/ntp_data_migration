-- Table DFN_NTP.Z04_FORMS_COLOR

CREATE TABLE dfn_ntp.z04_forms_color
(
    z04_z01_id       NUMBER (5, 0),
    z04_seq_no       NUMBER (5, 0),
    z04_criteria     VARCHAR2 (200),
    z04_color        VARCHAR2 (100),
    z04_column       VARCHAR2 (100),
    z04_time_stamp   DATE
)
/

-- Constraints for  DFN_NTP.Z04_FORMS_COLOR


  ALTER TABLE dfn_ntp.z04_forms_color MODIFY (z04_z01_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z04_forms_color MODIFY (z04_seq_no NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z04_forms_color MODIFY (z04_criteria NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z04_forms_color MODIFY (z04_color NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.Z04_FORMS_COLOR

ALTER TABLE DFN_NTP.Z04_FORMS_COLOR
 ADD (
  Z04_FEATURE_ID_V14 NUMBER (3,0)
 )
/