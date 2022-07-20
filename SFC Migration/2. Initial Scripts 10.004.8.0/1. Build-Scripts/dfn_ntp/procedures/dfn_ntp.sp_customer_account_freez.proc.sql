CREATE OR REPLACE PROCEDURE dfn_ntp.sp_customer_account_freez
IS
    l_exception       VARCHAR (4000);
    l_eod_date        DATE := func_get_eod_date;
    l_freeze_date     DATE := l_eod_date;
    l_eod_offset      NUMBER := 0;
    l_exp_level_cnt   NUMBER := 0;
    l_level_cnt       NUMBER := 0;
    l_u42_days        VARCHAR2 (250);
    l_message         VARCHAR (2000);
    l_message_ar      VARCHAR (2000);
BEGIN
    SELECT TO_NUMBER (NVL (MAX (v00_value), '0'))
      INTO l_eod_offset
      FROM v00_sys_config
     WHERE v00_key = 'EOD_OFFSET';

    l_eod_date := l_eod_date + l_eod_offset;
    l_freeze_date := l_eod_date;

    FOR c_branch IN (SELECT m02_id,
                            m02_code,
                            m02_name,
                            m02_underage_to_minor_years,
                            m02_minor_to_major_years
                       FROM m02_institute)
    LOOP
        ---Before ID Expire
        BEGIN
            SELECT COUNT (*)
              INTO l_level_cnt
              FROM u41_notification_configuration
             WHERE     u41_notification_type_id_m100 = 29
                   AND u41_institution_id_m02 = c_branch.m02_id;

            IF (l_level_cnt <> 0)
            THEN
                SELECT fn_aggregate_list (p_input => u42_days)
                  INTO l_u42_days
                  FROM     u41_notification_configuration u41
                       LEFT JOIN
                           u42_notification_levels u42
                       ON u41.u41_id = u42.u42_notify_config_id_u41
                 WHERE     u41.u41_notification_type_id_m100 = 29
                       AND u41_institution_id_m02 = c_branch.m02_id;

                l_u42_days := l_u42_days || ',';
            END IF;

            FOR i
                IN (SELECT u01.u01_id,
                           u01.u01_full_name,
                           u01.u01_full_name_lang,
                           u01.u01_customer_no,
                           u05.u05_expiry_date - l_eod_date AS due_days,
                           u05.u05_id_no,
                           u05.u05_expiry_date
                      FROM u01_customer u01,
                           m15_identity_type m15,
                           u05_customer_identification u05
                     WHERE     u01.u01_account_type_id_v01 != 1
                           AND u01.u01_institute_id_m02 = c_branch.m02_id
                           AND u01.u01_id = u05.u05_customer_id_u01
                           AND u05.u05_identity_type_id_m15 = m15.m15_id
                           AND u05.u05_expiry_date - l_eod_date >= 0)
            LOOP
                IF INSTR (l_u42_days, i.due_days || ',') > 0
                THEN
                    l_message :=
                           'DaysToFreez ='
                        || i.due_days
                        || UNISTR ('\0001')
                        || 'CustomerNo ='
                        || i.u01_customer_no
                        || UNISTR ('\0001')
                        || 'CustomerName ='
                        || i.u01_full_name
                        || UNISTR ('\0001')
                        || 'CustomerNameLang ='
                        || i.u01_full_name_lang
                        || UNISTR ('\0001')
                        || 'IdNo ='
                        || i.u05_id_no
                        || UNISTR ('\0001')
                        || 'IdExpiryDate ='
                        || i.u05_expiry_date;

                    dfn_ntp.sp_send_customer_sms_email (
                        pu01_id             => i.u01_id,
                        pm103_sub_item      => 32,
                        psms                => l_message,
                        psms_ar             => l_message,
                        pemail_subject      => 'Customer ID Expiry',
                        pemail_subject_ar   => 'Customer ID Expiry',
                        pemail_body         => l_message,
                        pemail_body_ar      => l_message,
                        p_event_id_m148     => 6);
                END IF;

                IF i.due_days = 0                                    --Freezed
                THEN
                    sp_customer_restriction (
                        pu01_id               => i.u01_id,
                        pnarration            => 'Customer Account has been Freezed ? System',
                        pnarration_lang       => 'Customer Account has been Freezed ? System',
                        prestriction_source   => 1,
                        pm02_id               => c_branch.m02_id);
                END IF;
            END LOOP;

            COMMIT;
        EXCEPTION
            WHEN OTHERS
            THEN
                ROLLBACK;
        END;

        l_u42_days := '';

        ---After ID Expire
        BEGIN
            SELECT COUNT (*)
              INTO l_exp_level_cnt
              FROM u41_notification_configuration
             WHERE     u41_notification_type_id_m100 = 33
                   AND u41_institution_id_m02 = c_branch.m02_id;

            IF (l_exp_level_cnt <> 0)
            THEN
                SELECT fn_aggregate_list (p_input => u42_days)
                  INTO l_u42_days
                  FROM     u41_notification_configuration u41
                       LEFT JOIN
                           u42_notification_levels u42
                       ON u41.u41_id = u42.u42_notify_config_id_u41
                 WHERE     u41.u41_notification_type_id_m100 = 33
                       AND u41_institution_id_m02 = c_branch.m02_id;

                l_u42_days := l_u42_days || ',';
            END IF;

            FOR i
                IN (SELECT u01.u01_id,
                           u01.u01_customer_no,
                           u01.u01_full_name,
                           u01.u01_full_name_lang,
                           l_eod_date - u05.u05_expiry_date AS pass_days,
                           u05.u05_id_no,
                           u05.u05_expiry_date
                      FROM u01_customer u01,
                           m15_identity_type m15,
                           u05_customer_identification u05
                     WHERE     u01.u01_account_type_id_v01 != 1
                           AND u01.u01_institute_id_m02 = c_branch.m02_id
                           AND u01.u01_id = u05.u05_customer_id_u01
                           AND u05.u05_identity_type_id_m15 = m15.m15_id
                           AND l_eod_date - u05.u05_expiry_date > 0)
            LOOP
                IF INSTR (l_u42_days, i.pass_days || ',') > 0
                THEN
                    l_message :=
                           'day_count ='
                        || 10                      -- need to add m48 prameter
                        || UNISTR ('\0001')
                        || 'CustomerNo ='
                        || i.u01_customer_no
                        || UNISTR ('\0001')
                        || 'CustomerName ='
                        || i.u01_full_name
                        || UNISTR ('\0001')
                        || 'CustomerNameLang ='
                        || i.u01_full_name_lang
                        || UNISTR ('\0001')
                        || 'IdNo ='
                        || i.u05_id_no
                        || UNISTR ('\0001')
                        || 'IdExpiryDate ='
                        || i.u05_expiry_date;

                    dfn_ntp.sp_send_customer_sms_email (
                        pu01_id             => i.u01_id,
                        pm103_sub_item      => 33,
                        psms                => l_message,
                        psms_ar             => l_message,
                        pemail_subject      => 'Customer Account Freez',
                        pemail_subject_ar   => 'Customer Account Freez',
                        pemail_body         => l_message,
                        pemail_body_ar      => l_message,
                        p_event_id_m148     => 7);
                END IF;
            END LOOP;

            COMMIT;
        EXCEPTION
            WHEN OTHERS
            THEN
                ROLLBACK;
        END;

        l_u42_days := '';
        l_freeze_date := l_eod_date;

        -----Underage to Minor
        BEGIN
            l_freeze_date := l_freeze_date; -- need to implement HIJRI date and pass here

            SELECT COUNT (*)
              INTO l_exp_level_cnt
              FROM u41_notification_configuration
             WHERE     u41_notification_type_id_m100 = 41
                   AND u41_institution_id_m02 = c_branch.m02_id;

            IF (l_exp_level_cnt <> 0)
            THEN
                SELECT fn_aggregate_list (p_input => u42_days)
                  INTO l_u42_days
                  FROM     u41_notification_configuration u41
                       LEFT JOIN
                           u42_notification_levels u42
                       ON u41.u41_id = u42.u42_notify_config_id_u41
                 WHERE     u41.u41_notification_type_id_m100 = 41
                       AND u41_institution_id_m02 = c_branch.m02_id;

                l_u42_days := l_u42_days || ',';
            END IF;

            FOR i
                IN (SELECT u01.u01_id,
                           u01.u01_customer_no,
                           u01.u01_full_name,
                           u01.u01_full_name_lang,
                           u01.u01_default_id_no,
                           (u01.u01_date_of_birth - l_freeze_date)
                               AS due_days
                      FROM u01_customer u01
                     WHERE     u01.u01_institute_id_m02 = c_branch.m02_id
                           AND u01.u01_minor_account = 1
                           AND u01.u01_account_type_id_v01 != 1 -- exclude Master Account
                           AND u01.u01_date_of_birth - l_freeze_date >= 0)
            LOOP
                IF INSTR (l_u42_days, i.due_days || ',') > 0
                THEN
                    l_message :=
                           'DaysToMinor ='
                        || i.due_days
                        || UNISTR ('\0001')
                        || 'CustomerNo ='
                        || i.u01_customer_no
                        || UNISTR ('\0001')
                        || 'CustomerName ='
                        || i.u01_full_name
                        || UNISTR ('\0001')
                        || 'CustomerNameLang ='
                        || i.u01_full_name_lang
                        || UNISTR ('\0001')
                        || 'IdNo ='
                        || i.u01_default_id_no;

                    dfn_ntp.sp_send_customer_sms_email (
                        pu01_id             => i.u01_id,
                        pm103_sub_item      => 41,
                        psms                => l_message,
                        psms_ar             => l_message,
                        pemail_subject      => 'Underage to Minor',
                        pemail_subject_ar   => 'Underage to Minor',
                        pemail_body         => l_message,
                        pemail_body_ar      => l_message,
                        p_event_id_m148     => 8);
                END IF;

                IF i.due_days = 0
                THEN
                    sp_customer_restriction (
                        pu01_id               => i.u01_id,
                        pnarration            => 'Underage to Minor ? System',
                        pnarration_lang       => 'Underage to Minor ? System',
                        prestriction_source   => 8,
                        pm02_id               => c_branch.m02_id);
                END IF;
            END LOOP;

            COMMIT;
        EXCEPTION
            WHEN OTHERS
            THEN
                ROLLBACK;
        END;

        l_u42_days := '';
        l_freeze_date := l_eod_date;

        --Minor to Major
        BEGIN
            l_freeze_date := l_freeze_date; -- need to implement HIJRI date and pass here

            SELECT COUNT (*)
              INTO l_exp_level_cnt
              FROM u41_notification_configuration
             WHERE     u41_notification_type_id_m100 = 40
                   AND u41_institution_id_m02 = c_branch.m02_id;

            IF (l_exp_level_cnt <> 0)
            THEN
                SELECT fn_aggregate_list (p_input => u42_days)
                  INTO l_u42_days
                  FROM     u41_notification_configuration u41
                       LEFT JOIN
                           u42_notification_levels u42
                       ON u41.u41_id = u42.u42_notify_config_id_u41
                 WHERE     u41.u41_notification_type_id_m100 = 40
                       AND u41_institution_id_m02 = c_branch.m02_id;

                l_u42_days := l_u42_days || ',';
            END IF;

            FOR i
                IN (SELECT u01.u01_id,
                           u01.u01_customer_no,
                           u01.u01_full_name,
                           u01.u01_full_name_lang,
                           u01.u01_default_id_no,
                           (u01.u01_date_of_birth - l_freeze_date)
                               AS due_days
                      FROM u01_customer u01
                     WHERE     u01.u01_institute_id_m02 = c_branch.m02_id
                           AND u01.u01_minor_account = 1
                           AND u01.u01_account_type_id_v01 != 1 -- exclude Master Account
                           AND u01.u01_date_of_birth - l_freeze_date >= 0)
            LOOP
                IF INSTR (l_u42_days, i.due_days || ',') > 0
                THEN
                    l_message :=
                           'DaysToMajor ='
                        || i.due_days
                        || UNISTR ('\0001')
                        || 'CustomerNo ='
                        || i.u01_customer_no
                        || UNISTR ('\0001')
                        || 'CustomerName ='
                        || i.u01_full_name
                        || UNISTR ('\0001')
                        || 'CustomerNameLang ='
                        || i.u01_full_name_lang
                        || UNISTR ('\0001')
                        || 'IdNo ='
                        || i.u01_default_id_no;

                    dfn_ntp.sp_send_customer_sms_email (
                        pu01_id             => i.u01_id,
                        pm103_sub_item      => 40,
                        psms                => l_message,
                        psms_ar             => l_message,
                        pemail_subject      => 'Minor to Major',
                        pemail_subject_ar   => 'Minor to Major',
                        pemail_body         => l_message,
                        pemail_body_ar      => l_message,
                        p_event_id_m148     => 9);
                END IF;

                IF i.due_days = 0
                THEN
                    sp_customer_restriction (
                        pu01_id               => i.u01_id,
                        pnarration            => 'Minor to Major ? System',
                        pnarration_lang       => 'Minor to Major ? System',
                        prestriction_source   => 7,
                        pm02_id               => c_branch.m02_id);
                END IF;
            END LOOP;

            COMMIT;
        EXCEPTION
            WHEN OTHERS
            THEN
                ROLLBACK;
        END;

        l_u42_days := '';
        l_freeze_date := l_eod_date;

        --KYC Expiry - Account Freeze
        BEGIN
            SELECT COUNT (*)
              INTO l_exp_level_cnt
              FROM u41_notification_configuration
             WHERE     u41_notification_type_id_m100 = 28
                   AND u41_institution_id_m02 = c_branch.m02_id;

            IF (l_exp_level_cnt <> 0)
            THEN
                SELECT fn_aggregate_list (p_input => u42_days)
                  INTO l_u42_days
                  FROM     u41_notification_configuration u41
                       LEFT JOIN
                           u42_notification_levels u42
                       ON u41.u41_id = u42.u42_notify_config_id_u41
                 WHERE     u41.u41_notification_type_id_m100 = 28
                       AND u41_institution_id_m02 = c_branch.m02_id;

                l_u42_days := l_u42_days || ',';
            END IF;

            FOR i
                IN (SELECT u01.u01_id,
                           u01.u01_customer_no,
                           u01.u01_full_name,
                           u01.u01_full_name_lang,
                           u01.u01_default_id_no,
                           (u03.u03_next_review - l_freeze_date) AS due_days
                      FROM u01_customer u01, u03_customer_kyc u03
                     WHERE     u01.u01_id = u03.u03_customer_id_u01
                           AND u01.u01_account_type_id_v01 != 1 -- exclude Master Account
                           AND u01.u01_institute_id_m02 = c_branch.m02_id
                           AND u03.u03_next_review - l_freeze_date >= 0)
            LOOP
                IF INSTR (l_u42_days, i.due_days || ',') > 0
                THEN
                    l_message :=
                           'days_to_kyc_exp ='
                        || i.due_days
                        || UNISTR ('\0001')
                        || 'CustomerNo ='
                        || i.u01_customer_no
                        || UNISTR ('\0001')
                        || 'CustomerName ='
                        || i.u01_full_name
                        || UNISTR ('\0001')
                        || 'CustomerNameLang ='
                        || i.u01_full_name_lang
                        || UNISTR ('\0001')
                        || 'IdNo ='
                        || i.u01_default_id_no;

                    dfn_ntp.sp_send_customer_sms_email (
                        pu01_id             => i.u01_id,
                        pm103_sub_item      => 28,
                        psms                => l_message,
                        psms_ar             => l_message,
                        pemail_subject      => 'KYC review',
                        pemail_subject_ar   => 'KYC review',
                        pemail_body         => l_message,
                        pemail_body_ar      => l_message,
                        p_event_id_m148     => 10);
                END IF;

                IF i.due_days = 0
                THEN
                    sp_customer_restriction (
                        pu01_id               => i.u01_id,
                        pnarration            => 'KYC Expired ? System',
                        pnarration_lang       => 'KYC Expired ? System',
                        prestriction_source   => 5,
                        pm02_id               => c_branch.m02_id);
                END IF;
            END LOOP;

            COMMIT;
        EXCEPTION
            WHEN OTHERS
            THEN
                ROLLBACK;
        END;
    --TODO

    --POA ID Expiry - Freeze POA

    END LOOP;
END;
/