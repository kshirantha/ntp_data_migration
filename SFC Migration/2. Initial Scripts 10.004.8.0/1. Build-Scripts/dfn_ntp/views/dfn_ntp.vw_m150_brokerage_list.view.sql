CREATE OR REPLACE VIEW dfn_ntp.vw_m150_brokerage_list (
   m150_id,
   m150_code,
   m150_description,
   m150_created_by_id_u17,
   m150_created_date,
   m150_modified_by_id_u17,
   m150_modified_date,
   m150_status_id_v01,
   m150_status_changed_by_id_u17,
   m150_status_changed_date,
   m150_primary_institute_id_m02,
   status,
   created_by_full_name,
   modified_by_full_name,
   status_changed_by_full_name )
AS
SELECT m150_id,
         m150_code,
         m150_description,
         m150_created_by_id_u17,
         m150_created_date,
         m150_modified_by_id_u17,
         m150_modified_date,
         m150_status_id_v01,
         m150_status_changed_by_id_u17,
         m150_status_changed_date,
         m150_primary_institute_id_m02,
         status_list.v01_description         AS status,
         u17_created_by.u17_full_name        AS created_by_full_name,
         u17_modified_by.u17_full_name       AS modified_by_full_name,
         u17_status_changed_by.u17_full_name AS status_changed_by_full_name
  FROM m150_broker m150
         JOIN u17_employee u17_created_by ON m150.m150_created_by_id_u17 = u17_created_by.u17_id
         LEFT JOIN u17_employee u17_modified_by ON m150.m150_modified_by_id_u17 = u17_modified_by.u17_id
         JOIN u17_employee u17_status_changed_by ON m150.m150_status_changed_by_id_u17 = u17_status_changed_by.u17_id
         LEFT JOIN vw_status_list status_list ON m150.m150_status_id_v01 = status_list.v01_id
/

