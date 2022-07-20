CREATE TABLE dfn_ntp.m53_approval_required_tables
(
    m53_id                          NUMBER (5, 0),
    m53_table                       VARCHAR2 (50 BYTE),
    m53_table_description           VARCHAR2 (50 BYTE),
    m53_approval_type               NUMBER (1, 0),
    m53_approval_levels             NUMBER (1, 0),
    m53_maker_checker_type          NUMBER (1, 0),
    m53_audit_activity_id_m82       NUMBER (10, 0),
    m53_apprvl_entitlement_id_v04   NUMBER (10, 0),
    m53_custom_type                 VARCHAR2 (50 BYTE) DEFAULT 1,
    m53_route                       VARCHAR2 (1000 BYTE)
)
/

COMMENT ON COLUMN dfn_ntp.m53_approval_required_tables.m53_approval_levels IS
    '0 - Imidiate | 1 - 1 Level | 2 - 2 Levels'
/
COMMENT ON COLUMN dfn_ntp.m53_approval_required_tables.m53_approval_type IS
    '0- None | 1 - Row Wise | 2 - Column Wise'
/
COMMENT ON COLUMN dfn_ntp.m53_approval_required_tables.m53_audit_activity_id_m82 IS
    'M82 Entity Status Change Audit Activity ID'
/
COMMENT ON COLUMN dfn_ntp.m53_approval_required_tables.m53_id IS
    'Table ID (M01=1), (U01=1001), (V01=2001), (T01=3001),(Z01=4001))'
/
COMMENT ON COLUMN dfn_ntp.m53_approval_required_tables.m53_maker_checker_type IS
    '0 - No Restriction | 1 - Maker Can''t Do Approvals | 2 - Can''t Do Consecutive Approvals | 3 - Only One Approval By One Person'
/