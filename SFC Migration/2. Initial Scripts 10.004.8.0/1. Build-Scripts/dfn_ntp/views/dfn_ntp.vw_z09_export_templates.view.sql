CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_z09_export_templates
(
    z09_id,
    z09_form_id_z01,
    z09_title,
    z09_created_by_id_u17,
    z09_created_date,
    z09_modified_by_id_u17,
    z09_modified_date,
    z09_details,
    z09_export_type
)
AS
    SELECT z09.z09_id,
           z09.z09_form_id_z01,
           z09.z09_title,
           z09.z09_created_by_id_u17,
           z09.z09_created_date,
           z09.z09_modified_by_id_u17,
           z09.z09_modified_date,
           z09.z09_details,
           z09.z09_export_type
      FROM z09_export_templates z09
/