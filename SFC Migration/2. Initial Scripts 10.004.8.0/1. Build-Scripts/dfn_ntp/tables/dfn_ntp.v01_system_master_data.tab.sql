CREATE TABLE dfn_ntp.v01_system_master_data
(
    v01_id                 NUMBER (5, 0) NOT NULL,
    v01_description        VARCHAR2 (255 BYTE),
    v01_description_lang   VARCHAR2 (255 BYTE),
    v01_type               NUMBER (3, 0),
    v01_type_description   VARCHAR2 (255 BYTE)
)
/


ALTER TABLE dfn_ntp.v01_system_master_data
 MODIFY (
  v01_type NUMBER (10, 0)

 )
/

ALTER TABLE DFN_NTP.v01_system_master_data
 ADD (
  V01_FEATURE_ID_V14 NUMBER (3,0)
 )
/
CREATE UNIQUE INDEX dfn_ntp.idx_v01_fast
    ON dfn_ntp.v01_system_master_data (v01_id,
                                       v01_type,
                                       v01_description,
                                       v01_description_lang)
/
