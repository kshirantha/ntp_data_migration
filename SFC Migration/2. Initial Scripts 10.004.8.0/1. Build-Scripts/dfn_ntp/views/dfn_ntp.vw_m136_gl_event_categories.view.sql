CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m136_gl_event_categories
(
    m136_id,
    m136_description,
    m136_description_lang,
    m136_institute_id_m02,
    m136_enabled,
    m136_type,
    m136_modified_by_id_u17,
    m136_modified_date,
    enabled_desc,
    type_desc,
    modified_by_full_name
)
AS
    SELECT m136.m136_id,
           m136.m136_description,
           m136.m136_description_lang,
           m136.m136_institute_id_m02,
           m136.m136_enabled,
           m136.m136_type,
           m136.m136_modified_by_id_u17,
           m136.m136_modified_date,
           CASE m136.m136_enabled WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
               AS enabled_desc,
           CASE m136.m136_type WHEN 0 THEN 'Record' WHEN 1 THEN 'Column' END
               AS type_desc,
           u17_modified_by.u17_full_name AS modified_by_full_name
      FROM     m136_gl_event_categories m136
           LEFT JOIN
               u17_employee u17_modified_by
           ON m136.m136_modified_by_id_u17 = u17_modified_by.u17_id
/