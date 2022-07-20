CREATE TABLE dfn_ntp.v00_sys_config
(
    v00_id                         NUMBER (10, 0),
    v00_value                      VARCHAR2 (2000 BYTE) DEFAULT NULL,
    v00_description                VARCHAR2 (150 BYTE),
    v00_key                        VARCHAR2 (50 BYTE),
    v00_status_id_v01              NUMBER (5, 0),
    v00_status_changed_by_id_u17   NUMBER (10, 0),
    v00_status_changed_date        DATE,
    v00_modified_by_id_u17         NUMBER (10, 0),
    v00_modified_date              DATE,
    v00_type                       NUMBER (1, 0),
    v00_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1
)
/



ALTER TABLE dfn_ntp.v00_sys_config
ADD PRIMARY KEY (v00_id)
USING INDEX
/

ALTER TABLE dfn_ntp.v00_sys_config
ADD CONSTRAINT unique_key UNIQUE (v00_key)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.v00_sys_config.v00_type IS '1 - Basic
2 - Advance'
/