CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_assigned_inst_entlmnt_list
(
    m44_id,
    m44_institution_id_m02,
    m44_entitlement_id_v04,
    v04_task_name,
    v04_entitlement_type_id_v03,
    v04_enabled,
    v04_id,
    category_text,
    v04_sensitive_level_id_v02,
    sensitive_level
)
AS
    SELECT m44.m44_id,
           m44.m44_institution_id_m02,
           m44.m44_entitlement_id_v04,
           e.v04_task_name,
           e.v04_entitlement_type_id_v03,
           e.v04_enabled,
           e.v04_id,
           e.category_text,
           e.v04_sensitive_level_id_v02,
           e.sensitive_level
      FROM     m44_institution_entitlements m44
           LEFT JOIN
               vw_entitlement_list e
           ON m44.m44_entitlement_id_v04 = e.v04_id;
/
