CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_audit_category
(
    m81_id,
    m81_category,
    m81_channel_id_v29
)
AS
    SELECT a.m81_id, a.m81_category, a.m81_channel_id_v29
      FROM m81_audit_category a;
/
