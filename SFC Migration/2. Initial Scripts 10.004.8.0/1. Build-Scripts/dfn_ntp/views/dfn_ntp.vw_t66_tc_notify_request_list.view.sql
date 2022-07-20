CREATE OR REPLACE VIEW dfn_ntp.vw_t66_tc_notify_request_list 
(
   t66_id,
   t66_report_no,
   t66_to_email,
   t66_cc_email,
   t66_bcc_email,
   t66_subject,
   t66_email_body,
   t66_tc_format_id_v12,
   t66_report_name,
   t66_status_id_v01,
   t66_notification_id_t13,
   t66_created_by_id_u17,
   t66_created_date,
   t66_status_changed_by_id_u17,
   t66_status_changed_date,
   status_description,
   created_by_full_name,
   status_changed_by_full_name,
   T66_INSTITUTE_ID_M02
)
AS
SELECT 
     t66.t66_id,
         t66.t66_report_no,
         t66.t66_to_email,
         t66.t66_cc_email,
         t66.t66_bcc_email,
         t66.t66_subject,
         t66.t66_email_body,
         t66.t66_tc_format_id_v12,
         t66.t66_report_name,
         t66.t66_status_id_v01,
         t66.t66_notification_id_t13,
         t66.t66_created_by_id_u17,
         t66.t66_created_date,
         t66.t66_status_changed_by_id_u17,
         t66.t66_status_changed_date,
         status_list.v01_description         AS status_description,
         u17_created_by.u17_full_name        AS created_by_full_name,
         u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
         T66_INSTITUTE_ID_M02
  FROM t66_tc_notify_request t66
         JOIN u17_employee u17_created_by 
      ON t66.t66_created_by_id_u17 = u17_created_by.u17_id
      LEFT JOIN u17_employee u17_status_changed_by 
      ON t66.t66_status_changed_by_id_u17 = u17_status_changed_by.u17_id
         LEFT JOIN vw_status_list status_list 
      ON t66.t66_status_id_v01 = status_list.v01_id;
/     
