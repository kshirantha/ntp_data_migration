CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m67_fix_logins
(
    m67_login_id,
    m67_inst_id_m02,
    m67_enabled,
    enabled,
    m67_id,
    m67_mubasher_no
)
AS
    (SELECT m67.m67_login_id,
            m67.m67_inst_id_m02,
            m67.m67_enabled,
            CASE WHEN m67.m67_enabled = 0 THEN 'NO' ELSE 'YES' END AS enabled,
            m67.m67_id,
            m67.m67_mubasher_no
       FROM m67_fix_logins m67);
/
