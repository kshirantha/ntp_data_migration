CREATE TABLE dfn_ntp.v20_default_master_data
(
    v20_id            NUMBER (5, 0),
    v20_description   VARCHAR2 (200 BYTE),
    v20_value         NVARCHAR2 (200)
)
/

ALTER TABLE dfn_ntp.v20_default_master_data
    ADD v20_institute_id_m02 NUMBER (5)
/

ALTER TABLE dfn_ntp.v20_default_master_data
    ADD v20_primary_institute_id_m02 NUMBER (5)
/

ALTER TABLE dfn_ntp.v20_default_master_data
    ADD v20_tag VARCHAR2 (200)
/

alter table DFN_NTP.V20_DEFAULT_MASTER_DATA
	add v20_type number(1)
/

comment on column V20_DEFAULT_MASTER_DATA.v20_type is '1: String, 2: Dropdown, 3: Boolen'
/

alter table DFN_NTP.V20_DEFAULT_MASTER_DATA
	add v20_is_configurable number(1)  DEFAULT 1
/

alter table V20_DEFAULT_MASTER_DATA
	add V20_Custom_Type number(1) DEFAULT 1
/

alter table V20_DEFAULT_MASTER_DATA
	add V20_MODIFIED_BY_ID_U17 number(10)
/