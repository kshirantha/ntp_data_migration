-- Table DFN_NTP.Z03_FORMS_MENU

CREATE TABLE dfn_ntp.z03_forms_menu
(
    z03_z01_id        NUMBER (5, 0),
    z03_seq_no        NUMBER (5, 0),
    z03_text          VARCHAR2 (100),
    z03_time_stamp    DATE,
    z03_visible       NUMBER (1, 0),
    z03_parent_menu   NUMBER (5, 0),
    z03_sec_id        NUMBER (5, 0)
)
/

-- Constraints for  DFN_NTP.Z03_FORMS_MENU


  ALTER TABLE dfn_ntp.z03_forms_menu MODIFY (z03_z01_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.z03_forms_menu MODIFY (z03_seq_no NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.Z03_FORMS_MENU

ALTER TABLE DFN_NTP.Z03_FORMS_MENU
 ADD (
  Z03_FEATURE_ID_V14 NUMBER (3,0)
 )
/