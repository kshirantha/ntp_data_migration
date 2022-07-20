CREATE TABLE dfn_ntp.z04_forms_color_c
(
    z04_z01_id          NUMBER (5, 0) NOT NULL,
    z04_seq_no          NUMBER (5, 0) NOT NULL,
    z04_criteria        VARCHAR2 (200 BYTE) NOT NULL,
    z04_color           VARCHAR2 (100 BYTE) NOT NULL,
    z04_column          VARCHAR2 (100 BYTE),
    z04_time_stamp      DATE,
    z04_change_status   NUMBER (5, 0),
    z04_broker_code     VARCHAR2 (50 BYTE)
)
/

-- Comments for DFN_NTP.Z04_FORMS_COLOR_C

COMMENT ON COLUMN dfn_ntp.z04_forms_color_c.z04_change_status IS
    '1 - add, 2 - edit, 3 - delete'
/

ALTER TABLE DFN_NTP.Z04_FORMS_COLOR_C
 ADD (
  Z04_FEATURE_ID_V14 NUMBER (3,0)
 )
/