CREATE OR REPLACE PROCEDURE dfn_ntp.sp_sms_email_add (
    pkey                     OUT VARCHAR,
    p_mobile_no           IN     VARCHAR DEFAULT NULL,
    p_lang                IN     VARCHAR,
    p_event_id            IN     NUMBER DEFAULT NULL,
    p_institution         IN     NUMBER DEFAULT NULL,
    p_custname            IN     VARCHAR DEFAULT NULL,
    p_notification_type   IN     NUMBER,
    p_date                IN     DATE,
    p_from_email          IN     VARCHAR DEFAULT NULL,
    p_to_email            IN     VARCHAR DEFAULT NULL,
    p_cc_emails           IN     VARCHAR DEFAULT NULL,
    p_message             IN     VARCHAR,
    p_message_subject     IN     VARCHAR DEFAULT NULL,
    p_template_id         IN     NUMBER DEFAULT -1)
IS
    i_last_seq   NUMBER (10);
BEGIN
    SELECT MAX (app_seq_value)
      INTO i_last_seq
      FROM app_seq_store
     WHERE app_seq_name = 'T13_NOTIFICATIONS';

    i_last_seq := NVL (i_last_seq, 0) + 1;

    UPDATE app_seq_store
       SET app_seq_value = i_last_seq
     WHERE app_seq_name = 'T13_NOTIFICATIONS';

    COMMIT;

    INSERT INTO t13_notifications (t13_id,
                                   t13_mobile,
                                   t13_from_email,
                                   t13_to_email,
                                   t13_cc_emails,
                                   t13_customer_name_u01,
                                   t13_message_body,
                                   t13_message_subject,
                                   t13_notification_type,
                                   t13_lang,
                                   t13_event_id_m148,
                                   t13_institution_id_m02,
                                   t13_created_date,
                                   t13_template_id_m149)
         VALUES (i_last_seq,
                 p_mobile_no,
                 p_from_email,
                 p_to_email,
                 p_cc_emails,
                 p_custname,
                 p_message,
                 p_message_subject,
                 p_notification_type,
                 p_lang,
                 p_event_id,
                 p_institution,
                 p_date,
                 p_template_id);

    pkey := i_last_seq;
END;
/