-- Table DFN_NTP.M128_MARITAL_STATUS

CREATE TABLE dfn_ntp.m128_marital_status
(
    m128_id                         NUMBER (3, 0),
    m128_description                VARCHAR2 (75),
    m128_created_by_id_u17          NUMBER (20, 0),
    m128_created_date               DATE,
    m128_modified_by_id_u17         NUMBER (20, 0),
    m128_modified_date              DATE,
    m128_status_id_v01              NUMBER (20, 0),
    m128_status_changed_by_id_u17   NUMBER (20, 0),
    m128_status_changed_date        DATE
)
/

-- Constraints for  DFN_NTP.M128_MARITAL_STATUS


  ALTER TABLE dfn_ntp.m128_marital_status MODIFY (m128_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m128_marital_status MODIFY (m128_description NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M128_MARITAL_STATUS

alter table dfn_ntp.M128_MARITAL_STATUS
	add M128_CUSTOM_TYPE varchar2(50) default 1
/
