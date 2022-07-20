CREATE TABLE dfn_ntp.m45_permission_groups
(
    m45_id                         NUMBER (3, 0),
    m45_group_name                 VARCHAR2 (50 BYTE),
    m45_group_enabled              NUMBER (1, 0) DEFAULT 1,
    m45_created_date               DATE,
    m45_created_by_id_u17          NUMBER (10, 0),
    m45_institute_id_m02           NUMBER (10, 0),
    m45_modified_by_id_u17         NUMBER (10, 0),
    m45_modified_date              DATE,
    m45_status_id_v01              NUMBER (20, 0),
    m45_status_changed_by_id_u17   NUMBER (20, 0),
    m45_status_changed_date        DATE,
    m45_editable                   NUMBER (1, 0) DEFAULT 1,
    m45_is_root_inst_only          NUMBER (1, 0) DEFAULT 0,
    m45_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.m45_permission_groups
ADD CONSTRAINT uk_m45_grp_name_inst_id UNIQUE (m45_group_name,
  m45_institute_id_m02)
USING INDEX
/

ALTER TABLE dfn_ntp.m45_permission_groups
ADD CONSTRAINT pk_m45_id PRIMARY KEY (m45_id)
USING INDEX
/

ALTER TABLE dfn_ntp.m45_permission_groups
ADD CONSTRAINT ck_m45_group_name CHECK ("M45_GROUP_NAME" IS NOT NULL)
/

ALTER TABLE dfn_ntp.m45_permission_groups
ADD CONSTRAINT ck_m45_group_enabled CHECK ("M45_GROUP_ENABLED" IS NOT NULL)
/

COMMENT ON COLUMN dfn_ntp.m45_permission_groups.m45_institute_id_m02 IS
    'Institution ID'
/
COMMENT ON COLUMN dfn_ntp.m45_permission_groups.m45_modified_by_id_u17 IS
    'Modified by'
/
COMMENT ON COLUMN dfn_ntp.m45_permission_groups.m45_modified_date IS
    'Modified Date'
/
COMMENT ON COLUMN dfn_ntp.m45_permission_groups.m45_status_id_v01 IS
    'From (V01-4) Approval Status'
/