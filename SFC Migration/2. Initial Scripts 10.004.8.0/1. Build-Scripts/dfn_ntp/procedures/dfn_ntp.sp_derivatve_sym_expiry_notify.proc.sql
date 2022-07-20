CREATE OR REPLACE PROCEDURE dfn_ntp.sp_derivatve_sym_expiry_notify
IS
    l_u42_days         VARCHAR2 (250);
    l_exp_level_cnt    NUMBER := 0;
    l_agg_u02_mobile   VARCHAR2 (500);
    l_message          VARCHAR2 (32000);
    l_u02_email        VARCHAR2 (32000);
    l_seq_no           NUMBER := 0;
    l_count            NUMBER := 0;

    TYPE t_table IS TABLE OF NUMBER
        INDEX BY BINARY_INTEGER;

    l_table            t_table;
BEGIN
    FOR c_branch IN (SELECT m02_id, m02_code, m02_name FROM m02_institute)
    LOOP
        SELECT COUNT (*)
          INTO l_exp_level_cnt
          FROM u41_notification_configuration
         WHERE     u41_notification_type_id_m100 = 48
               AND u41_institution_id_m02 = c_branch.m02_id;

        IF (l_exp_level_cnt = 1)
        THEN
            SELECT fn_aggregate_list (p_input => u42_days)
              INTO l_u42_days
              FROM     u41_notification_configuration u41
                   LEFT JOIN
                       u42_notification_levels u42
                   ON u41.u41_id = u42.u42_notify_config_id_u41
             WHERE     u41.u41_notification_type_id_m100 = 48
                   AND u41_institution_id_m02 = c_branch.m02_id;

            l_u42_days := l_u42_days || ',';
        END IF;

        FOR i
            IN (SELECT u01.u01_id,
                       u01.u01_customer_no,
                       u01.u01_institute_id_m02,
                       u01_full_name,
                       u01_full_name_lang,
                       u01_display_name,
                       u01_display_name_lang,
                       m20_expire_date,
                       CASE
                           WHEN u01_preferred_lang_id_v01 = 2
                           THEN
                               u01.u01_full_name
                           ELSE
                               u01.u01_full_name_lang
                       END
                           AS customer_name,
                       CASE
                           WHEN    u01.u01_preferred_lang_id_v01 IS NULL
                                OR u01.u01_preferred_lang_id_v01 = 1
                           THEN
                               'EN'
                           ELSE
                               'AR'
                       END
                           AS preferred_language,
                       m20_expire_date AS exp_date,
                       TRUNC (TO_DATE (m20_expire_date) - TRUNC (SYSDATE))
                           AS i_num_of_dates,
                       u01.u01_preferred_lang_id_v01,
                       u01.u01_account_category_id_v01,
                       m02.m02_email AS from_mail,
                       m02.m02_telephone,
                       m02.m02_name,
                       m02.m02_name_lang,
                       m02.m02_email
                  FROM (SELECT u07.u07_customer_id_u01,
                               m20_expire_date,
                               u07_institute_id_m02
                          FROM u24_holdings u24
                               INNER JOIN m20_symbol m20
                                   ON     u24.u24_symbol_id_m20 = m20.m20_id
                                      AND m20.m20_instrument_type_code_v09 =
                                              'FUT'
                               INNER JOIN u07_trading_account u07
                                   ON     u24.u24_trading_acnt_id_u07 =
                                              u07.u07_id
                                      AND (  u24.u24_net_holding
                                           + u24.u24_payable_holding
                                           - u24.u24_receivable_holding) <> 0) hold
                       INNER JOIN u01_customer u01
                           ON hold.u07_customer_id_u01 = u01.u01_id
                       INNER JOIN m02_institute m02
                           ON hold.u07_institute_id_m02 = m02.m02_id
                 WHERE     TRUNC (SYSDATE) <= hold.m20_expire_date
                       AND hold.u07_institute_id_m02 = c_branch.m02_id)
        LOOP
            l_message :=
                   'CustomerName ='
                || TO_CHAR (i.u01_display_name)
                || UNISTR ('\0001')
                || 'ExpiryDate ='
                || TO_CHAR (
                          SUBSTR (i.m20_expire_date, 0, 2)
                       || '/'
                       || SUBSTR (i.m20_expire_date, 4, 2)
                       || '/'
                       || SUBSTR (i.m20_expire_date, 7, 4))
                || UNISTR ('\0001')
                || 'InstitutionName ='
                || TO_CHAR (i.m02_name)
                || UNISTR ('\0001');

            IF INSTR (l_u42_days, i.i_num_of_dates || ',') > 0
            THEN
                IF (i.u01_account_category_id_v01 = 1)
                THEN
                    FOR contact
                        IN (SELECT u02_customer_id_u01, u02_mobile, u02_email
                              FROM u02_customer_contact_info
                             WHERE u02_customer_id_u01 = i.u01_id)
                    LOOP
                        IF (contact.u02_mobile IS NOT NULL)
                        THEN
                            l_message :=
                                   l_message
                                || 'Mobile ='
                                || TO_CHAR (contact.u02_mobile)
                                || UNISTR ('\0001');

                            SELECT MAX (t13_id) + 1
                              INTO l_seq_no
                              FROM t13_notifications;

                            sp_sms_email_add (
                                pkey                  => l_seq_no,
                                p_mobile_no           => contact.u02_mobile,
                                p_lang                => i.preferred_language,
                                p_event_id            => 56,         -- change
                                p_institution         => i.u01_institute_id_m02,
                                p_custname            => i.u01_display_name,
                                p_notification_type   => 1,
                                p_message             => l_message,
                                p_date                => SYSDATE,
                                p_template_id         => 59);        -- change
                            COMMIT;
                        END IF;


                        IF (contact.u02_email IS NOT NULL)
                        THEN
                            SELECT MAX (t13_id) + 1
                              INTO l_seq_no
                              FROM t13_notifications;

                            sp_sms_email_add (
                                pkey                  => l_seq_no,
                                p_mobile_no           => contact.u02_mobile,
                                p_from_email          => i.m02_email,
                                p_to_email            => contact.u02_email,
                                p_cc_emails           => '',
                                p_lang                => i.preferred_language,
                                p_event_id            => 56,
                                p_institution         => i.u01_institute_id_m02,
                                p_custname            => i.u01_display_name,
                                p_notification_type   => 2,
                                p_message             => l_message,
                                p_message_subject     => '',
                                p_date                => SYSDATE,
                                p_template_id         => 59);
                            COMMIT;
                        END IF;
                    END LOOP;


                    IF (i.u01_account_category_id_v01 = 2)
                    THEN
                        FOR board_member
                            IN (SELECT u48_customer_id_u01,
                                       u48_mobile,
                                       u48_email
                                  FROM u48_corp_customer_contact
                                 WHERE u48_customer_id_u01 = i.u01_id)
                        LOOP
                            IF (board_member.u48_mobile IS NOT NULL)
                            THEN
                                l_message :=
                                       l_message
                                    || 'Mobile ='
                                    || TO_CHAR (board_member.u48_mobile)
                                    || UNISTR ('\0001');
                                sp_sms_email_add (
                                    pkey                  => l_seq_no,
                                    p_mobile_no           => board_member.u48_mobile,
                                    p_lang                => i.preferred_language,
                                    p_event_id            => 56,     -- change
                                    p_institution         => i.u01_institute_id_m02,
                                    p_custname            => i.u01_display_name,
                                    p_notification_type   => 1,
                                    p_message             => l_message,
                                    p_date                => SYSDATE,
                                    p_template_id         => 59);    -- change
                                COMMIT;
                            END IF;

                            IF (board_member.u48_email IS NOT NULL)
                            THEN
                                SELECT MAX (t13_id) + 1
                                  INTO l_seq_no
                                  FROM t13_notifications;

                                sp_sms_email_add (
                                    pkey                  => l_seq_no,
                                    p_mobile_no           => board_member.u48_mobile,
                                    p_from_email          => i.m02_email,
                                    p_to_email            => board_member.u48_email,
                                    p_cc_emails           => '',
                                    p_lang                => i.preferred_language,
                                    p_event_id            => 56,
                                    p_institution         => i.u01_institute_id_m02,
                                    p_custname            => i.u01_display_name,
                                    p_notification_type   => 2,
                                    p_message             => l_message,
                                    p_message_subject     => '',
                                    p_date                => SYSDATE,
                                    p_template_id         => 59);
                                COMMIT;
                            END IF;
                        END LOOP;
                    END IF;
                END IF;
            END IF;
        END LOOP;
    END LOOP;
END;
/