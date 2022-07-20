CREATE TABLE dfn_ntp.z03_forms_menu_c
(
    z03_z01_id          NUMBER (5, 0) NOT NULL,
    z03_seq_no          NUMBER (5, 0) NOT NULL,
    z03_text            VARCHAR2 (100 BYTE),
    z03_time_stamp      DATE,
    z03_visible         NUMBER (1, 0),
    z03_parent_menu     NUMBER (5, 0),
    z03_sec_id          NUMBER (5, 0),
    z03_change_status   NUMBER (5, 0),
    z03_broker_code     VARCHAR2 (50 BYTE)
)
/
-- Comments for DFN_NTP.Z03_FORMS_MENU_C

COMMENT ON COLUMN dfn_ntp.z03_forms_menu_c.z03_change_status IS
    '1 - add, 2 - edit, 3 - delete'
/

ALTER TABLE DFN_NTP.Z03_FORMS_MENU_C
 ADD (
  Z03_FEATURE_ID_V14 NUMBER (3,0)
 )
/