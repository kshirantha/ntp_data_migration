CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m16_bank_list
(
   m16_id,
   m16_name,
   m16_name_lang,
   m16_swift_code,
   m16_bank_identifier,
   m16_created_by_id_u17,
   created_by_full_name,
   m16_created_date,
   m16_status_id_v01,
   status_description,
   status_description_lang,
   m16_modified_by_id_u17,
   modified_by_full_name,
   m16_modified_date,
   m16_status_changed_by_id_u17,
   status_changed_by_full_name,
   m16_status_changed_date,
   m16_external_ref,
   m16_address,
   m16_aba_routing_no,
   m16_institute_id_m02
)
AS
   SELECT m16.m16_id,
          m16.m16_name,
          m16.m16_name_lang,
          m16.m16_swift_code,
          m16.m16_bank_identifier,
          m16.m16_created_by_id_u17,
          u17_created_by.u17_full_name AS created_by_full_name,
          m16.m16_created_date,
          m16.m16_status_id_v01,
          status_list.v01_description AS status_description,
          status_list.v01_description_lang AS status_description_lang,
          m16.m16_modified_by_id_u17,
          u17_modified_by.u17_full_name AS modified_by_full_name,
          m16.m16_modified_date,
          m16.M16_STATUS_CHANGED_BY_id_U17,
          u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
          m16.m16_status_changed_date,
          m16.m16_external_ref,
          m16.m16_address,
          m16.m16_aba_routing_no,
          m16.m16_institute_id_m02
     FROM m16_bank m16
          LEFT JOIN u17_employee u17_created_by
             ON m16.m16_created_by_id_u17 = u17_created_by.u17_id
          LEFT JOIN u17_employee u17_modified_by
             ON m16.m16_modified_by_id_u17 = u17_modified_by.u17_id
          LEFT JOIN u17_employee u17_status_changed_by
             ON m16.m16_status_changed_by_id_u17 =
                   u17_status_changed_by.u17_id
          LEFT JOIN vw_status_list status_list
             ON m16.m16_status_id_v01 = status_list.v01_id
/