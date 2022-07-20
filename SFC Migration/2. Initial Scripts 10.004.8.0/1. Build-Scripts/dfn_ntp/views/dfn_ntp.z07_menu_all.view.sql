CREATE OR REPLACE FORCE VIEW dfn_ntp.z07_menu_all
(
    z07_id,
    z07_name,
    z07_tag,
    z07_sec_id,
    z07_fkey,
    z07_hide,
    z07_icon,
    z07_route,
    z07_query_params,
    z07_pkey,
    z07_broker_code,
    z07_custom_type,
    z07_is_customized,
    z07_deleted_from_core,
    z07_form_title
)
AS
    SELECT a.z07_id,
           a.z07_name,
           a.z07_tag,
           a.z07_sec_id,
           a.z07_fkey,
           a.z07_hide,
           a.z07_icon,
           a.z07_route,
           a.z07_query_params,
           a.z07_pkey,
           a.z07_broker_code,
           a.z07_custom_type,
           a.z07_is_customized,
           a.z07_deleted_from_core,
           a.z07_form_title
      FROM z07_menu a
     WHERE                                  --        a.z07_is_customized <> 1
           -- AND a.z07_deleted_from_core <> 1
           (a.z07_hide IS NULL OR a.z07_hide = 0)
/
