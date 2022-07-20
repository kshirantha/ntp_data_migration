CREATE OR REPLACE FORCE VIEW dfn_ntp.relationship_manager_list
(
    m10_id,
    m10_institute_id_m02,
    m10_name,
    m10_name_lang,
    m10_created_by_id_u17,
    m10_created_date,
    m10_status_id_v01,
    m10_modified_by_id_u17,
    m10_modified_date,
    m10_status_changed_by_id_u17,
    m10_status_changed_date,
    m10_external_ref
)
AS
    SELECT a.m10_id,
           a.m10_institute_id_m02,
           a.m10_name,
           a.m10_name_lang,
           a.m10_created_by_id_u17,
           a.m10_created_date,
           a.m10_status_id_v01,
           a.m10_modified_by_id_u17,
           a.m10_modified_date,
           a.m10_status_changed_by_id_u17,
           a.m10_status_changed_date,
           a.m10_external_ref
      FROM m10_relationship_manager a;
/
