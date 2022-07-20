CREATE TABLE dfn_ntp.v00_sys_config_broker_wise
(
    v00_id                           NUMBER (10, 0),
    v00_value                        VARCHAR2 (2000 BYTE) DEFAULT NULL,
    v00_description                  VARCHAR2 (150 BYTE),
    v00_key                          VARCHAR2 (50 BYTE),
    v00_status_id_v01                NUMBER (5, 0),
    v00_status_changed_by_id_u17     NUMBER (10, 0),
    v00_status_changed_date          DATE,
    v00_modified_by_id_u17           NUMBER (10, 0),
    v00_modified_date                DATE,
    v00_type                         NUMBER (1, 0),
    v00_custom_type                  VARCHAR2 (50 BYTE) DEFAULT 1,
    v00_primary_institution_id_m02   NUMBER (1, 0)
)
/



ALTER TABLE dfn_ntp.v00_sys_config_broker_wise
ADD PRIMARY KEY (v00_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.v00_sys_config_broker_wise.v00_type IS '1 - Basic
2 - Advance'
/


ALTER TABLE dfn_ntp.v00_sys_config_broker_wise
 ADD (
  v00_is_send_to_client NUMBER (1) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.v00_sys_config_broker_wise.v00_is_send_to_client IS
    '1=Should send to any client product if service requested'
/