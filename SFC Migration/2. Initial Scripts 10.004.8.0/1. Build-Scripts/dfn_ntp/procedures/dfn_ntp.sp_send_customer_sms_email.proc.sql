CREATE OR REPLACE PROCEDURE dfn_ntp.sp_send_customer_sms_email (
    pu01_id              IN NUMBER,
    pm103_sub_item       IN NUMBER,
    psms                 IN VARCHAR2,
    psms_ar              IN VARCHAR2,
    pemail_subject       IN VARCHAR2,
    pemail_subject_ar    IN VARCHAR2,
    pemail_body          IN VARCHAR2,
    pemail_body_ar       IN VARCHAR2,
    p_event_id_m148      IN NUMBER DEFAULT NULL,
    p_attachment_data    IN BLOB DEFAULT NULL,
    p_attachment_name    IN VARCHAR DEFAULT NULL,
    p_template_id_m149   IN NUMBER DEFAULT -1)
IS
    l_mobile                 VARCHAR2 (20);
    l_email                  VARCHAR2 (200);
    l_u01_preferred_lang     NUMBER;
    l_u01_account_category   NUMBER;
    l_customer_name          VARCHAR2 (1000);
    l_branch_email           VARCHAR2 (1000);
    l_cust_branch_id         NUMBER;
    l_sms_id                 VARCHAR (10);
    l_channel                NUMBER;

    CURSOR customer_list
    IS
        SELECT u01.u01_def_mobile,
               u01.u01_def_email,
               CASE
                   WHEN    u01.u01_preferred_lang_id_v01 IS NULL
                        OR u01.u01_preferred_lang_id_v01 = 1
                   THEN
                       'EN'
                   ELSE
                       'AR'
               END
                   AS preferred_language,
               u01.u01_account_category_id_v01,
               CASE
                   WHEN    u01.u01_preferred_lang_id_v01 IS NULL
                        OR u01.u01_preferred_lang_id_v01 = 1
                   THEN
                       u01.u01_full_name
                   ELSE
                       u01.u01_full_name_lang
               END
                   AS customer_name,
               m02.m02_email,
               u01.u01_institute_id_m02 AS institution_id,
               m103.m103_channel_id_m101
          FROM u01_customer u01
               JOIN m02_institute m02
                   ON m02.m02_id = u01.u01_institute_id_m02
               JOIN m104_cust_notification_schedul m104
                   ON m104.m104_customer_id_u01 = u01.u01_id
               JOIN m103_notify_subitem_schedule m103
                   ON m103.m103_id = m104.m104_subitem_shedule_id_m103
         WHERE     m103.m103_sub_item_id_m100 = pm103_sub_item
               AND u01.u01_id = pu01_id;
BEGIN
    FOR customer IN customer_list
    LOOP
        -- Individual Customer SMS

        IF (customer.u01_account_category_id_v01 = 1)
        THEN
            IF (    customer.u01_def_mobile IS NOT NULL
                AND customer.m103_channel_id_m101 = 3)
            THEN
                sp_sms_email_add (
                    pkey                  => l_sms_id,
                    p_mobile_no           => customer.u01_def_mobile,
                    p_lang                => customer.preferred_language,
                    p_event_id            => p_event_id_m148,
                    p_institution         => customer.institution_id,
                    p_custname            => customer.customer_name,
                    p_notification_type   => 1,
                    p_message             => CASE
                                                WHEN customer.preferred_language =
                                                         'EN'
                                                THEN
                                                    psms
                                                ELSE
                                                    psms_ar
                                            END,
                    p_date                => SYSDATE,
                    p_template_id         => p_template_id_m149);
            END IF;

            -- Individual Customer Email
            IF (    customer.u01_def_email IS NOT NULL
                AND customer.m103_channel_id_m101 = 2)
            THEN
                sp_sms_email_add (
                    pkey                  => l_sms_id,
                    p_to_email            => customer.u01_def_email,
                    p_from_email          => customer.m02_email,
                    p_lang                => customer.preferred_language,
                    p_event_id            => p_event_id_m148,
                    p_institution         => customer.institution_id,
                    p_date                => SYSDATE,
                    p_custname            => customer.customer_name,
                    p_notification_type   => 2,
                    p_message_subject     => CASE
                                                WHEN customer.preferred_language =
                                                         'EN'
                                                THEN
                                                    pemail_subject
                                                ELSE
                                                    pemail_subject_ar
                                            END,
                    p_message             => CASE
                                                WHEN customer.preferred_language =
                                                         'EN'
                                                THEN
                                                    pemail_body
                                                ELSE
                                                    pemail_body_ar
                                            END,
                    p_template_id         => p_template_id_m149);
            END IF;

            IF (    p_attachment_name IS NOT NULL
                AND p_attachment_data IS NOT NULL)
            THEN
                INSERT
                  INTO t14_notification_data (t14_t13_id,
                                              t14_attachment_name,
                                              t14_attachment_data)
                VALUES (l_sms_id, p_attachment_name, p_attachment_data);
            END IF;
        END IF;

        -- Corporate Customer
        IF (customer.u01_account_category_id_v01 = 2)
        THEN
            FOR board_member
                IN (SELECT u48_customer_id_u01, u48_mobile, u48_email
                      FROM u48_corp_customer_contact
                     WHERE u48_customer_id_u01 = pu01_id)
            LOOP
                -- Corporate Customer SMS
                IF (    board_member.u48_mobile IS NOT NULL
                    AND customer.m103_channel_id_m101 = 3)
                THEN
                    sp_sms_email_add (
                        pkey                  => l_sms_id,
                        p_mobile_no           => board_member.u48_mobile,
                        p_lang                => customer.preferred_language,
                        p_event_id            => p_event_id_m148,
                        p_institution         => customer.institution_id,
                        p_custname            => customer.customer_name,
                        p_notification_type   => 1,
                        p_message             => CASE
                                                    WHEN customer.preferred_language =
                                                             'EN'
                                                    THEN
                                                        psms
                                                    ELSE
                                                        psms_ar
                                                END,
                        p_date                => SYSDATE,
                        p_template_id         => p_template_id_m149);
                END IF;

                -- Corporate Customer Email
                IF (    board_member.u48_email IS NOT NULL
                    AND customer.m103_channel_id_m101 = 2)
                THEN
                    sp_sms_email_add (
                        pkey                  => l_sms_id,
                        p_to_email            => board_member.u48_email,
                        p_from_email          => board_member.u48_email,
                        p_lang                => customer.preferred_language,
                        p_event_id            => p_event_id_m148,
                        p_institution         => customer.institution_id,
                        p_date                => SYSDATE,
                        p_custname            => customer.customer_name,
                        p_notification_type   => 2,
                        p_message_subject     => CASE
                                                    WHEN customer.preferred_language =
                                                             'EN'
                                                    THEN
                                                        pemail_subject
                                                    ELSE
                                                        pemail_subject_ar
                                                END,
                        p_message             => CASE
                                                    WHEN customer.preferred_language =
                                                             'EN'
                                                    THEN
                                                        pemail_body
                                                    ELSE
                                                        pemail_body_ar
                                                END,
                        p_template_id         => p_template_id_m149);
                END IF;
            END LOOP;
        END IF;
    END LOOP;
END;
/