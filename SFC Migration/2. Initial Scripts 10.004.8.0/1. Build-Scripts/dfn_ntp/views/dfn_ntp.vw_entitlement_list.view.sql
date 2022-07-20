CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_entitlement_list
(
    v04_id,
    v04_task_name,
    v04_enabled,
    v04_entitlement_type_id_v03,
    category_text,
    v04_sensitive_level_id_v02,
    sensitive_level
)
AS
    SELECT v04.v04_id,
           v04.v04_task_name,
           v04.v04_enabled,
           v04.v04_entitlement_type_id_v03,
           v03.v03_description AS category_text,
           v04.v04_sensitive_level_id_v02,
           v02.v02_description AS sensitive_level
      FROM v04_entitlements v04,
           v03_entitlement_type v03,
           v02_ent_sensitive_levels v02
     WHERE     v04.v04_entitlement_type_id_v03 = v03.v03_id(+)
           AND v04.v04_sensitive_level_id_v02 = v02.v02_id(+);
/
