CREATE OR REPLACE PROCEDURE dfn_ntp.sp_send_sms_email_notification (
    p_from_email          IN VARCHAR,
    p_cc_emails           IN VARCHAR,
    p_message_body        IN VARCHAR,
    p_message_subject     IN VARCHAR,
    p_notification_type   IN NUMBER,
    p_customer_status     IN NUMBER,
    p_attachment_data     IN BLOB DEFAULT NULL,
    p_attachment_name     IN VARCHAR DEFAULT NULL,
    p_template_id         IN NUMBER DEFAULT -1)
IS
    i_last_seq   NUMBER (10);

    CURSOR customer_list
    IS
        SELECT DISTINCT u01.u01_id,
                        u01.u01_customer_no,
                        u01.u01_def_mobile,
                        u01.u01_def_email,
                        u01.u01_full_name
          FROM     u01_customer u01
               JOIN
                   u09_customer_login u09
               ON u01.u01_id = u09.u09_customer_id_u01
         WHERE u09.u09_login_status_id_v01 = p_customer_status;
BEGIN
    FOR customer IN customer_list
    LOOP
        SELECT app_seq_value
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
                                       t13_cc_emails,
                                       t13_customer_id_u01,
                                       t13_message_body,
                                       t13_message_subject,
                                       t13_notification_type,
                                       t13_created_date,
                                       t13_template_id_m149)
             VALUES (i_last_seq,
                     customer.u01_def_mobile,
                     p_from_email,
                     p_cc_emails,
                     customer.u01_id,
                     p_message_body,
                     p_message_subject,
                     p_notification_type,
                     SYSDATE,
                     p_template_id);

        IF (p_attachment_name IS NOT NULL AND p_attachment_data IS NOT NULL)
        THEN
            INSERT
              INTO t14_notification_data (t14_t13_id,
                                          t14_attachment_name,
                                          t14_attachment_data)
            VALUES (i_last_seq, p_attachment_name, p_attachment_data);
        END IF;

        COMMIT;
    END LOOP;
END;
/