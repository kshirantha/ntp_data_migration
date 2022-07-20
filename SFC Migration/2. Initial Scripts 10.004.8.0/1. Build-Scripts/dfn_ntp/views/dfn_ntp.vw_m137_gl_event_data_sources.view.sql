CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m137_gl_event_data_sources
(
   m137_id,
   m137_view_name,
   m137_filter,
   m137_event_cat_id_m136,
   m137_description,
   m137_enabled,
   m137_external_ref,
   m137_modified_by_id_u17,
   m137_modified_date,
   event_category_desc,
   enabled_desc,
   modified_by_full_name,
   m136_institute_id_m02
)
AS
   SELECT m137.m137_id,
          m137.m137_view_name,
          m137.m137_filter,
          m137.m137_event_cat_id_m136,
          m137.m137_description,
          m137.m137_enabled,
          m137.m137_external_ref,
          m137.m137_modified_by_id_u17,
          m137.m137_modified_date,
          m136.m136_description AS event_category_desc,
          CASE m137.m137_enabled WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
             AS enabled_desc,
          u17_modified_by.u17_full_name AS modified_by_full_name,
          m136.m136_institute_id_m02
     FROM m137_gl_event_data_sources m137
          JOIN m136_gl_event_categories m136
             ON m137.m137_event_cat_id_m136 = m136.m136_id
          LEFT JOIN u17_employee u17_modified_by
             ON m137.m137_modified_by_id_u17 = u17_modified_by.u17_id;
/