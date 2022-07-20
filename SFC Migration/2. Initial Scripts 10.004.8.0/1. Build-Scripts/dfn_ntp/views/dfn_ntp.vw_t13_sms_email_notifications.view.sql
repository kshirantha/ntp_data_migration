CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t13_sms_email_notifications
(
    t13_mobile,
    t13_from_email,
    t13_to_email,
    t13_cc_emails,
    t13_message_body,
    t13_message_subject,
    t13_notification_type,
    t13_institution_id_m02,
    t13_created_date,
    status,
    t13_notification_status
)
AS
    SELECT t13_mobile,
           t13_from_email,
           t13_to_email,
           t13_cc_emails,
           t13_message_body,
           t13_message_subject,
           t13_notification_type,
           t13_institution_id_m02,
           t13_created_date,
           CASE
               WHEN t13_notification_status = 0 THEN 'Pending'
               WHEN t13_notification_status = 1 THEN 'Sent'
               WHEN t13_notification_status = 2 THEN 'Delivered'
           END
               AS status,
           t13_notification_status
      FROM dfn_ntp.t13_notifications
/