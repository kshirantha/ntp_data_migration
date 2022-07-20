CREATE TABLE dfn_ntp.m47_permission_grp_users
(
    m47_id                         NUMBER (10, 0) NOT NULL,
    m47_user_id_u17                NUMBER (10, 0) NOT NULL,
    m47_group_id_m45               NUMBER (3, 0) NOT NULL,
    m47_granted_by_id_u17          NUMBER (10, 0),
    m47_granted_date               DATE,
    m47_l1_by_id_u17               NUMBER (10, 0),
    m47_l1_date                    DATE,
    m47_l2_by_id_u17               NUMBER (10, 0),
    m47_l2_date                    DATE,
    m47_status_id_v01              NUMBER (20, 0),
    m47_status_changed_by_id_u17   NUMBER (20, 0),
    m47_status_changed_date        DATE,
    m47_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1
)
/

CREATE UNIQUE INDEX dfn_ntp."BIN$U/THjQBnKnrgU/AOqMAWIA==$0"
    ON dfn_ntp.m47_permission_grp_users (m47_user_id_u17 ASC,
                                         m47_group_id_m45 ASC)
/


ALTER TABLE dfn_ntp.m47_permission_grp_users
ADD CONSTRAINT pk_composite_usrid_grp_id PRIMARY KEY (m47_user_id_u17,
  m47_group_id_m45)
/

COMMENT ON COLUMN dfn_ntp.m47_permission_grp_users.m47_granted_by_id_u17 IS
    'Granted by'
/
COMMENT ON COLUMN dfn_ntp.m47_permission_grp_users.m47_granted_date IS
    'Granted Date'
/
COMMENT ON COLUMN dfn_ntp.m47_permission_grp_users.m47_l1_by_id_u17 IS
    'L1 Approved by'
/
COMMENT ON COLUMN dfn_ntp.m47_permission_grp_users.m47_l1_date IS
    'L1 Approved Date'
/
COMMENT ON COLUMN dfn_ntp.m47_permission_grp_users.m47_l2_by_id_u17 IS
    'L2 Approved by'
/
COMMENT ON COLUMN dfn_ntp.m47_permission_grp_users.m47_l2_date IS 'L2 Date'
/
COMMENT ON COLUMN dfn_ntp.m47_permission_grp_users.m47_status_id_v01 IS
    'From (V01-4) Approval Status'
/
