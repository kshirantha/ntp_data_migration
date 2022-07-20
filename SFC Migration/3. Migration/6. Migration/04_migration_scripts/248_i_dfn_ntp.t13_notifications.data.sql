DECLARE
    l_notification_id   NUMBER;
    l_sqlerrm           VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t13_id), 0)
      INTO l_notification_id
      FROM dfn_ntp.t13_notifications;

    DELETE FROM error_log
          WHERE mig_table = 'T13_NOTIFICATIONS';

    FOR i
        IN (SELECT tmp10.tmp10_id AS notification_id,
                   NULL AS mobile,
                   tmp10.tmp10_from AS from_email,
                   tmp10.tmp10_to_list AS to_email,
                   tmp10.tmp10_cc_list AS cc_emails,
                   tmp10.tmp10_message_data AS msg_body,
                   tmp10.tmp10_lang AS lang,
                   tmp10.tmp10_date AS created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   tmp10.tmp10_subject AS subject,
                   2 AS notification_type, -- 2  - Email
                   'TMP10_CUST_NOTIFICATIONS' AS source,
                   t13_map.new_notification_id AS mapped_notification_id
              FROM mubasher_oms.tmp10_cust_notifications@mubasher_db_link tmp10,
                   (SELECT *
                      FROM t13_notifications_mappings
                     WHERE old_notification_table =
                               'TMP10_CUST_NOTIFICATIONS') t13_map
             WHERE tmp10.tmp10_id = t13_map.old_notification_id(+)
            UNION ALL
            SELECT tmp03.tmp03_id AS notification_id,
                   tmp03.tmp03_mobile AS mobile,
                   NULL AS from_email,
                   NULL AS to_email,
                   NULL AS cc_emails,
                   TO_CHAR (tmp03.tmp03_message) AS msg_body,
                   tmp03.tmp03_lan AS lang,
                   NULL AS created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   NULL subject,
                   1 AS notification_type, -- 1 - SMS
                   'TMP03_SMS_OUT' AS source,
                   tmp03.tmp03_id AS mapped_notification_id
              FROM mubasher_oms.tmp03_sms_out@mubasher_db_link tmp03,
                   (SELECT *
                      FROM t13_notifications_mappings
                     WHERE old_notification_table =
                               'TMP10_CUST_NOTIFICATIONS') t13_map
             WHERE tmp03.tmp03_id = t13_map.old_notification_table(+))
    LOOP
        BEGIN
            IF i.notification_id IS NULL
            THEN
                l_notification_id := l_notification_id + 1;

                INSERT
                  INTO dfn_ntp.t13_notifications (t13_id,
                                                  t13_mobile,
                                                  t13_from_email,
                                                  t13_to_email,
                                                  t13_cc_emails,
                                                  t13_customer_id_u01,
                                                  t13_message_body,
                                                  t13_message_subject,
                                                  t13_notification_type,
                                                  t13_user_id_u17,
                                                  t13_lang,
                                                  t13_customer_name_u01,
                                                  t13_event_id_m148,
                                                  t13_institution_id_m02,
                                                  t13_created_date,
                                                  t13_template_id_m149,
                                                  t13_notification_status,
                                                  t13_custom_type,
                                                  t13_bcc_emails)
                VALUES (l_notification_id, -- t13_id
                        i.mobile, -- t13_mobile
                        i.from_email, -- t13_from_email
                        i.to_email, -- t13_to_email
                        i.cc_emails, -- t13_cc_emails
                        NULL, -- t13_customer_id_u01  | Not Available
                        i.msg_body, -- t13_message_body
                        i.subject, -- t13_message_subject
                        i.notification_type, -- t13_notification_type
                        NULL, -- t13_user_id_u17 | Not Available
                        i.lang, -- t13_lang
                        NULL, -- t13_customer_name_u01
                        NULL, -- t13_event_id_m148
                        NULL, -- t13_institution_id_m02  | Not Available
                        i.created_date, -- t13_created_date
                        NULL, -- t13_template_id_m149  | Not Available
                        2, -- t13_notification_status
                        '1', -- t13_custom_type
                        NULL -- t13_bcc_emails
                            );

                INSERT
                  INTO t13_notifications_mappings (old_notification_id,
                                                   new_notification_id,
                                                   old_notification_table)
                VALUES (i.notification_id, l_notification_id, i.source);
            ELSE
                UPDATE dfn_ntp.t13_notifications
                   SET t13_mobile = i.mobile, -- t13_mobile
                       t13_from_email = i.from_email, -- t13_from_email
                       t13_to_email = i.to_email, -- t13_to_email
                       t13_cc_emails = i.cc_emails, -- t13_cc_emails
                       t13_message_body = i.msg_body, -- t13_message_body
                       t13_message_subject = i.subject, -- t13_message_subject
                       t13_notification_type = i.notification_type, -- t13_notification_type
                       t13_lang = i.lang -- t13_lang
                 WHERE t13_id = i.notification_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T13_NOTIFICATIONS',
                                i.source || ' - ' || i.notification_id,
                                CASE
                                    WHEN i.notification_id IS NULL
                                    THEN
                                        l_notification_id
                                    ELSE
                                        i.notification_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.notification_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
