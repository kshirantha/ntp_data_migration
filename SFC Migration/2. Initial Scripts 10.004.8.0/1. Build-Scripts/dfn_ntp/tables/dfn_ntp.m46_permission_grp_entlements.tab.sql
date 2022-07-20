CREATE TABLE dfn_ntp.m46_permission_grp_entlements
(
    m46_id                         NUMBER (10, 0) NOT NULL,
    m46_group_id_m45               NUMBER (3, 0) NOT NULL,
    m46_task_id_v04                NUMBER (10, 0) NOT NULL,
    m46_added_by_id_u17            NUMBER (10, 0),
    m46_added_date                 DATE,
    m46_l1_by_id_u17               NUMBER (5, 0),
    m46_l1_date                    DATE,
    m46_l2_by_id_u17               NUMBER (5, 0),
    m46_l2_date                    DATE,
    m46_status_id_v01              NUMBER (20, 0),
    m46_status_changed_by_id_u17   NUMBER (20, 0),
    m46_status_changed_date        DATE,
    m46_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1
)
/

CREATE UNIQUE INDEX dfn_ntp."BIN$U/THiwgiKnbgU/AOqMAO3g==$0"
    ON dfn_ntp.m46_permission_grp_entlements (m46_group_id_m45 ASC,
                                              m46_task_id_v04 ASC)
/

ALTER TABLE dfn_ntp.m46_permission_grp_entlements
ADD CONSTRAINT pk_m46_composite PRIMARY KEY (m46_group_id_m45, m46_task_id_v04)
/

ALTER TABLE dfn_ntp.m46_permission_grp_entlements
ADD CONSTRAINT ck_m46_status_id CHECK (m46_status_id_v01 IS NOT NULL)
/

ALTER TABLE dfn_ntp.m46_permission_grp_entlements
ADD CONSTRAINT ck_m46_status_chg_by CHECK (M46_STATUS_CHANGED_BY_ID_U17 IS NOT NULL)
/

ALTER TABLE dfn_ntp.m46_permission_grp_entlements
ADD CONSTRAINT ck_m46_status_chg_date CHECK (M46_STATUS_CHANGED_DATE IS NOT NULL)
/

COMMENT ON COLUMN dfn_ntp.m46_permission_grp_entlements.m46_added_by_id_u17 IS
    'Added by'
/
COMMENT ON COLUMN dfn_ntp.m46_permission_grp_entlements.m46_added_date IS
    'Added Date'
/
COMMENT ON COLUMN dfn_ntp.m46_permission_grp_entlements.m46_l1_by_id_u17 IS
    'L1 Approved by'
/
COMMENT ON COLUMN dfn_ntp.m46_permission_grp_entlements.m46_l1_date IS
    'L1 Approved Date'
/
COMMENT ON COLUMN dfn_ntp.m46_permission_grp_entlements.m46_l2_by_id_u17 IS
    'L2 Approved by'
/
COMMENT ON COLUMN dfn_ntp.m46_permission_grp_entlements.m46_l2_date IS
    'L2 Approved Date'
/
COMMENT ON COLUMN dfn_ntp.m46_permission_grp_entlements.m46_status_id_v01 IS
    'From (V01-4) Approval Status'
/