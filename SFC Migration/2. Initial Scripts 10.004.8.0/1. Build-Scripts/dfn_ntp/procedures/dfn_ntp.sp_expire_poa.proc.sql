CREATE OR REPLACE PROCEDURE dfn_ntp.sp_expire_poa
IS
    l_exp_level_cnt            NUMBER := 0;
    l_u42_days                 VARCHAR2 (250);
    l_poa_exp_sms_msg          VARCHAR (500);
    l_poa_exp_sms_msg_ar       VARCHAR (500);
    l_poa_id_exp_sms_msg       VARCHAR (500);
    l_poa_id_exp_sms_msg_ar    VARCHAR (500);
    l_poa_expired_sms_msg      VARCHAR (500);
    l_poa_expired_sms_msg_ar   VARCHAR (500);
    l_count                    NUMBER := 0;
    l_seq_no                   NUMBER := 0;
    l_agg_u02_mobile           VARCHAR2 (500);
    l_sms_id                   VARCHAR (10);
    l_message                  VARCHAR2 (32000);

    TYPE t_table IS TABLE OF NUMBER
        INDEX BY BINARY_INTEGER;

    l_table                    t_table;
BEGIN
    /***************POA Expiry Notification*****************/

    FOR c_branch IN (SELECT m02_id, m02_code, m02_name FROM m02_institute)
    LOOP
        SELECT COUNT (*)
          INTO l_exp_level_cnt
          FROM u41_notification_configuration
         WHERE     u41_notification_type_id_m100 = 34
               AND u41_institution_id_m02 = c_branch.m02_id;

        IF (l_exp_level_cnt <> 0)
        THEN
            SELECT fn_aggregate_list (p_input => u42_days)
              INTO l_u42_days
              FROM     u41_notification_configuration u41
                   LEFT JOIN
                       u42_notification_levels u42
                   ON u41.u41_id = u42.u42_notify_config_id_u41
             WHERE     u41.u41_notification_type_id_m100 = 34
                   AND u41_institution_id_m02 = c_branch.m02_id;

            l_u42_days := l_u42_days || ',';
        END IF;

        FOR i
            IN (SELECT u01.u01_id,
                       c_branch.m02_code,
                       u01.u01_customer_no,
                       u01.u01_institute_id_m02,
                       u01_preferred_lang_id_v01,
                       CASE
                           WHEN    u01.u01_preferred_lang_id_v01 IS NULL
                                OR u01.u01_preferred_lang_id_v01 = 1
                           THEN
                               'EN'
                           ELSE
                               'AR'
                       END
                           AS preferred_language,
                       u01.u01_display_name,
                       u01.u01_display_name_lang,
                       u47.u47_poa_name,
                       u47.u47_poa_name_lang,             --nin value m132_nin
                       u47.u47_id_type_m15,
                       u47.u47_id_no,
                       TRUNC (u49.u49_poa_expiry_date) AS u49_poa_expiry_date,
                       (TRUNC (u49.u49_poa_expiry_date) - func_get_eod_date)
                           AS due_days,
                       --  u02_def.u02_mobile,
                       m15.m15_account_frozen_type,
                       m15.m15_name,
                       m15.m15_name_lang,
                       u01.u01_account_category_id_v01,
                       u02.u02_mobile AS agg_u02_mobile,
                       u01.u01_def_mobile AS u02_mobile,
                       u49_id,
                       NVL (m104_poa_exp.m104_customer_id_u01, 0)
                           AS customer_id_poa_exp_sms
                  FROM             u01_customer u01
                               LEFT JOIN
                                   u47_power_of_attorney u47
                               ON u01.u01_id = u47.u47_customer_id_u01
                           LEFT JOIN
                               u49_poa_trading_privileges u49
                           ON u47.u47_id = u49.u49_poa_id_u47
                       LEFT JOIN
                           m15_identity_type m15
                       ON u47.u47_id_type_m15 = m15.m15_id,
                       (  SELECT u02_customer_id_u01,
                                 fn_aggregate_list (u02_mobile) AS u02_mobile
                            FROM u02_customer_contact_info
                        GROUP BY u02_customer_id_u01) u02,
                       (SELECT m104_customer_id_u01
                          FROM m104_cust_notification_schedul,
                               m103_notify_subitem_schedule
                         WHERE     m104_subitem_shedule_id_m103 = m103_id
                               AND m103_sub_item_id_m100 = 34) m104_poa_exp
                 WHERE     u01.u01_institute_id_m02 = c_branch.m02_id
                       AND u49.u49_poa_expiry_date - func_get_eod_date >= 0)
        LOOP
            l_message :=
                   'CustomerNo ='
                || TO_CHAR (i.u01_customer_no)
                || UNISTR ('\0001')
                || 'PreferredLang ='
                || TO_CHAR (i.preferred_language)
                || UNISTR ('\0001')
                || 'Institution ='
                || TO_CHAR (i.m02_code)
                || UNISTR ('\0001')
                || 'DisplayName ='
                || TO_CHAR (i.u01_display_name)
                || UNISTR ('\0001')
                || 'DisplayNameLang ='
                || TO_CHAR (i.u01_display_name_lang)
                || UNISTR ('\0001')
                || 'PoaName ='
                || TO_CHAR (i.u47_poa_name)
                || UNISTR ('\0001')
                || 'PoaNameLang ='
                || TO_CHAR (i.u47_poa_name_lang)
                || UNISTR ('\0001')
                || 'IdType ='
                || TO_CHAR (i.u47_id_type_m15)
                || UNISTR ('\0001')
                || 'IdNo ='
                || TO_CHAR (i.u47_id_no)
                || UNISTR ('\0001')
                || 'IdName ='
                || TO_CHAR (i.m15_name)
                || UNISTR ('\0001')
                || 'IdNameLang ='
                || TO_CHAR (i.m15_name_lang)
                || UNISTR ('\0001')
                || 'PoaExpiryDate ='
                || TO_CHAR (
                          SUBSTR (i.u49_poa_expiry_date, 0, 2)
                       || '/'
                       || SUBSTR (i.u49_poa_expiry_date, 4, 2)
                       || '/'
                       || SUBSTR (i.u49_poa_expiry_date, 7, 4))
                || UNISTR ('\0001')
                || 'DueDays ='
                || TO_CHAR (i.due_days)
                || UNISTR ('\0001')
                || 'customerIdPoaSms ='
                || TO_CHAR (i.customer_id_poa_exp_sms)
                || UNISTR ('\0001');

            IF (i.customer_id_poa_exp_sms <> 0)
            THEN
                IF INSTR (l_u42_days, i.due_days || ',') > 0
                THEN
                    IF (i.u02_mobile IS NOT NULL)
                    THEN
                        l_message :=
                               l_message
                            || 'Mobile ='
                            || TO_CHAR (i.u02_mobile)
                            || UNISTR ('\0001');

                        SELECT MAX (t13_id) + 1
                          INTO l_seq_no
                          FROM t13_notifications;

                        sp_sms_email_add (
                            pkey                  => l_seq_no,
                            p_mobile_no           => i.u02_mobile,
                            p_lang                => i.preferred_language,
                            p_event_id            => 47,             -- change
                            p_institution         => i.u01_institute_id_m02,
                            p_custname            => i.u01_display_name,
                            p_notification_type   => 1,
                            p_message             => l_message,
                            p_date                => SYSDATE,
                            p_template_id         => 11);            -- change
                        COMMIT;
                    END IF;

                    IF (    i.u01_account_category_id_v01 = 2
                        AND i.agg_u02_mobile IS NOT NULL)
                    THEN
                        l_count := 0;
                        l_agg_u02_mobile := i.agg_u02_mobile || ',';

                        WHILE INSTR (l_agg_u02_mobile, ',') != 0
                        LOOP
                            l_count := l_count + 1;
                            l_table (l_count) :=
                                SUBSTR (l_agg_u02_mobile,
                                        0,
                                        INSTR (l_agg_u02_mobile, ',') - 1);
                            l_agg_u02_mobile :=
                                SUBSTR (l_agg_u02_mobile,
                                        INSTR (l_agg_u02_mobile, ',') + 1);
                        END LOOP;

                        FOR j IN l_table.FIRST .. l_table.LAST
                        LOOP
                            IF l_table (j) IS NOT NULL
                            THEN
                                SELECT MAX (t13_id) + 1
                                  INTO l_seq_no
                                  FROM t13_notifications;

                                l_message :=
                                       l_message
                                    || 'Mobile ='
                                    || TO_CHAR (l_table (j))
                                    || UNISTR ('\0001');
                                sp_sms_email_add (
                                    pkey                  => l_seq_no,
                                    p_mobile_no           => l_table (j),
                                    p_lang                => i.preferred_language,
                                    p_event_id            => 47,     -- change
                                    p_institution         => i.u01_institute_id_m02,
                                    p_custname            => i.u01_display_name,
                                    p_notification_type   => 1,
                                    p_message             => l_message,
                                    p_date                => SYSDATE,
                                    p_template_id         => 11);    -- change
                                COMMIT;
                            END IF;
                        END LOOP;
                    END IF;
                END IF;
            END IF;

            IF (i.u49_poa_expiry_date = func_get_eod_date)
            THEN
                UPDATE u49_poa_trading_privileges
                   SET u49_is_active = 0
                 WHERE u49_id = i.u49_id;

                -- check this

                IF (i.customer_id_poa_exp_sms <> 0)
                THEN
                    IF (i.u02_mobile IS NOT NULL)
                    THEN
                        l_message :=
                               l_message
                            || 'Mobile ='
                            || TO_CHAR (i.u02_mobile)
                            || UNISTR ('\0001');

                        SELECT MAX (t13_id) + 1
                          INTO l_seq_no
                          FROM t13_notifications;

                        sp_sms_email_add (
                            pkey                  => l_seq_no,
                            p_mobile_no           => i.u02_mobile,
                            p_lang                => i.preferred_language,
                            p_event_id            => 47,             -- change
                            p_institution         => i.u01_institute_id_m02,
                            p_custname            => i.u01_display_name,
                            p_notification_type   => 1,
                            p_message             => l_message,
                            p_date                => SYSDATE,
                            p_template_id         => 11);            -- change
                        COMMIT;
                    END IF;

                    IF (    i.u01_account_category_id_v01 = 2
                        AND i.agg_u02_mobile IS NOT NULL)
                    THEN
                        l_count := 0;
                        l_agg_u02_mobile := i.agg_u02_mobile || ',';

                        WHILE INSTR (l_agg_u02_mobile, ',') != 0
                        LOOP
                            l_count := l_count + 1;
                            l_table (l_count) :=
                                SUBSTR (l_agg_u02_mobile,
                                        0,
                                        INSTR (l_agg_u02_mobile, ',') - 1);
                            l_agg_u02_mobile :=
                                SUBSTR (l_agg_u02_mobile,
                                        INSTR (l_agg_u02_mobile, ',') + 1);
                        END LOOP;

                        FOR j IN l_table.FIRST .. l_table.LAST
                        LOOP
                            IF l_table (j) IS NOT NULL
                            THEN
                                SELECT MAX (t13_id) + 1
                                  INTO l_seq_no
                                  FROM t13_notifications;

                                l_message :=
                                       l_message
                                    || 'Mobile ='
                                    || TO_CHAR (l_table (j))
                                    || UNISTR ('\0001');
                                sp_sms_email_add (
                                    pkey                  => l_seq_no,
                                    p_mobile_no           => l_table (j),
                                    p_lang                => i.preferred_language,
                                    p_event_id            => 47,     -- change
                                    p_institution         => i.u01_institute_id_m02,
                                    p_custname            => i.u01_display_name,
                                    p_notification_type   => 1,
                                    p_message             => l_message,
                                    p_date                => SYSDATE,
                                    p_template_id         => 11);    -- change
                                COMMIT;
                            END IF;
                        END LOOP;
                    END IF;
                END IF;
            END IF;
        END LOOP;

        /***************POA  ID Expiry Notification*****************/
        l_u42_days := '';

        SELECT COUNT (*)
          INTO l_exp_level_cnt
          FROM u41_notification_configuration
         WHERE     u41_notification_type_id_m100 = 35
               AND u41_institution_id_m02 = c_branch.m02_id;

        IF (l_exp_level_cnt <> 0)
        THEN
            SELECT fn_aggregate_list (p_input => u42_days)
              INTO l_u42_days
              FROM     u41_notification_configuration u41
                   LEFT JOIN
                       u42_notification_levels u42
                   ON u41.u41_id = u42.u42_notify_config_id_u41
             WHERE     u41.u41_notification_type_id_m100 = 35
                   AND u41_institution_id_m02 = c_branch.m02_id;

            l_u42_days := l_u42_days || ',';
        END IF;

        FOR i
            IN (SELECT u01.u01_id,
                       c_branch.m02_code,
                       u01.u01_customer_no,
                       u01.u01_institute_id_m02,
                       u01_preferred_lang_id_v01,
                       CASE
                           WHEN    u01.u01_preferred_lang_id_v01 IS NULL
                                OR u01.u01_preferred_lang_id_v01 = 1
                           THEN
                               'EN'
                           ELSE
                               'AR'
                       END
                           AS preferred_language,
                       u01.u01_display_name,
                       u01.u01_display_name_lang,
                       u47.u47_poa_name,
                       u47.u47_poa_name_lang,             --nin value m132_nin
                       u47.u47_id_type_m15,
                       u47.u47_id_no,
                       u47.u47_id,
                       TRUNC (u47.u47_id_expiry_date) AS u47_id_expiry_date,
                       (TRUNC (u47.u47_id_expiry_date) - func_get_eod_date)
                           AS due_days,
                       m15.m15_account_frozen_type,
                       m15.m15_name,
                       m15.m15_name_lang,
                       u01.u01_account_category_id_v01,
                       u02.u02_mobile AS agg_u02_mobile,
                       u01.u01_def_mobile AS u02_mobile,
                       NVL (m104_poa_exp.m104_customer_id_u01, 0)
                           AS customer_id_poa_exp_sms
                  FROM         u01_customer u01
                           LEFT JOIN
                               u47_power_of_attorney u47
                           ON u01.u01_id = u47.u47_customer_id_u01
                       LEFT JOIN
                           m15_identity_type m15
                       ON u47.u47_id_type_m15 = m15.m15_id,
                       (  SELECT u02_customer_id_u01,
                                 fn_aggregate_list (u02_mobile) AS u02_mobile
                            FROM u02_customer_contact_info
                        GROUP BY u02_customer_id_u01) u02,
                       (SELECT m104_customer_id_u01
                          FROM m104_cust_notification_schedul,
                               m103_notify_subitem_schedule
                         WHERE     m104_subitem_shedule_id_m103 = m103_id
                               AND m103_sub_item_id_m100 = 35) m104_poa_exp
                 WHERE     u01.u01_institute_id_m02 = c_branch.m02_id
                       AND u47.u47_id_expiry_date - func_get_eod_date >= 0)
        LOOP
            l_message :=
                   'CustomerNo ='
                || TO_CHAR (i.u01_customer_no)
                || UNISTR ('\0001')
                || 'PreferredLang ='
                || TO_CHAR (i.preferred_language)
                || UNISTR ('\0001')
                || 'Institution ='
                || TO_CHAR (i.m02_code)
                || UNISTR ('\0001')
                || 'DisplayName ='
                || TO_CHAR (i.u01_display_name)
                || UNISTR ('\0001')
                || 'DisplayNameLang ='
                || TO_CHAR (i.u01_display_name_lang)
                || UNISTR ('\0001')
                || 'PoaName ='
                || TO_CHAR (i.u47_poa_name)
                || UNISTR ('\0001')
                || 'PoaNameLang ='
                || TO_CHAR (i.u47_poa_name_lang)
                || UNISTR ('\0001')
                || 'IdType ='
                || TO_CHAR (i.u47_id_type_m15)
                || UNISTR ('\0001')
                || 'IdNo ='
                || TO_CHAR (i.u47_id_no)
                || UNISTR ('\0001')
                || 'IdName ='
                || TO_CHAR (i.m15_name)
                || UNISTR ('\0001')
                || 'IdNameLang ='
                || TO_CHAR (i.m15_name)
                || UNISTR ('\0001')
                || 'PoaExpiryDate ='
                || TO_CHAR (
                          SUBSTR (i.u47_id_expiry_date, 0, 2)
                       || '/'
                       || SUBSTR (i.u47_id_expiry_date, 4, 2)
                       || '/'
                       || SUBSTR (i.u47_id_expiry_date, 7, 4))
                || UNISTR ('\0001')
                || 'DueDays ='
                || TO_CHAR (i.due_days)
                || UNISTR ('\0001')
                || 'customerIdPoaSms ='
                || TO_CHAR (i.customer_id_poa_exp_sms)
                || UNISTR ('\0001');

            IF (i.customer_id_poa_exp_sms <> 0)
            THEN
                IF INSTR (l_u42_days, i.due_days || ',') > 0
                THEN
                    IF (i.u02_mobile IS NOT NULL)
                    THEN
                        l_message :=
                               l_message
                            || 'Mobile ='
                            || TO_CHAR (i.u02_mobile)
                            || UNISTR ('\0001');

                        SELECT MAX (t13_id) + 1
                          INTO l_seq_no
                          FROM t13_notifications;

                        sp_sms_email_add (
                            pkey                  => l_seq_no,
                            p_mobile_no           => i.u02_mobile,
                            p_lang                => i.preferred_language,
                            p_event_id            => 47,             -- change
                            p_institution         => i.u01_institute_id_m02,
                            p_custname            => i.u01_display_name,
                            p_notification_type   => 1,
                            p_message             => l_message,
                            p_date                => SYSDATE,
                            p_template_id         => 11);            -- change
                        COMMIT;
                    END IF;

                    IF (    i.u01_account_category_id_v01 = 2
                        AND i.agg_u02_mobile IS NOT NULL)
                    THEN
                        l_count := 0;
                        l_agg_u02_mobile := i.agg_u02_mobile || ',';

                        WHILE INSTR (l_agg_u02_mobile, ',') != 0
                        LOOP
                            l_count := l_count + 1;
                            l_table (l_count) :=
                                SUBSTR (l_agg_u02_mobile,
                                        0,
                                        INSTR (l_agg_u02_mobile, ',') - 1);
                            l_agg_u02_mobile :=
                                SUBSTR (l_agg_u02_mobile,
                                        INSTR (l_agg_u02_mobile, ',') + 1);
                        END LOOP;

                        FOR j IN l_table.FIRST .. l_table.LAST
                        LOOP
                            IF l_table (j) IS NOT NULL
                            THEN
                                SELECT MAX (t13_id) + 1
                                  INTO l_seq_no
                                  FROM t13_notifications;

                                l_message :=
                                       l_message
                                    || 'Mobile ='
                                    || TO_CHAR (l_table (j))
                                    || UNISTR ('\0001');
                                sp_sms_email_add (
                                    pkey                  => l_seq_no,
                                    p_mobile_no           => l_table (j),
                                    p_lang                => i.preferred_language,
                                    p_event_id            => 47,     -- change
                                    p_institution         => i.u01_institute_id_m02,
                                    p_custname            => i.u01_display_name,
                                    p_notification_type   => 1,
                                    p_message             => l_message,
                                    p_date                => SYSDATE,
                                    p_template_id         => 11);    -- change
                                COMMIT;
                            END IF;
                        END LOOP;
                    END IF;
                END IF;
            END IF;

            IF (i.u47_id_expiry_date = func_get_eod_date)
            THEN
                UPDATE u47_power_of_attorney
                   SET u47_status_id_v01 = 9
                 WHERE u47_id = i.u47_id;

                IF (i.customer_id_poa_exp_sms <> 0)
                THEN
                    IF (i.u02_mobile IS NOT NULL)
                    THEN
                        l_message :=
                               l_message
                            || 'Mobile ='
                            || TO_CHAR (i.u02_mobile)
                            || UNISTR ('\0001');

                        SELECT MAX (t13_id) + 1
                          INTO l_seq_no
                          FROM t13_notifications;

                        sp_sms_email_add (
                            pkey                  => l_seq_no,
                            p_mobile_no           => i.u02_mobile,
                            p_lang                => i.preferred_language,
                            p_event_id            => 47,             -- change
                            p_institution         => i.u01_institute_id_m02,
                            p_custname            => i.u01_display_name,
                            p_notification_type   => 1,
                            p_message             => l_message,
                            p_date                => SYSDATE,
                            p_template_id         => 11);            -- change
                        COMMIT;
                    END IF;

                    IF (    i.u01_account_category_id_v01 = 2
                        AND i.agg_u02_mobile IS NOT NULL)
                    THEN
                        l_count := 0;
                        l_agg_u02_mobile := i.agg_u02_mobile || ',';

                        WHILE INSTR (l_agg_u02_mobile, ',') != 0
                        LOOP
                            l_count := l_count + 1;
                            l_table (l_count) :=
                                SUBSTR (l_agg_u02_mobile,
                                        0,
                                        INSTR (l_agg_u02_mobile, ',') - 1);
                            l_agg_u02_mobile :=
                                SUBSTR (l_agg_u02_mobile,
                                        INSTR (l_agg_u02_mobile, ',') + 1);
                        END LOOP;

                        FOR j IN l_table.FIRST .. l_table.LAST
                        LOOP
                            IF l_table (j) IS NOT NULL
                            THEN
                                SELECT MAX (t13_id) + 1
                                  INTO l_seq_no
                                  FROM t13_notifications;

                                l_message :=
                                       l_message
                                    || 'Mobile ='
                                    || TO_CHAR (l_table (j))
                                    || UNISTR ('\0001');
                                sp_sms_email_add (
                                    pkey                  => l_seq_no,
                                    p_mobile_no           => l_table (j),
                                    p_lang                => i.preferred_language,
                                    p_event_id            => 47,     -- change
                                    p_institution         => i.u01_institute_id_m02,
                                    p_custname            => i.u01_display_name,
                                    p_notification_type   => 1,
                                    p_message             => l_message,
                                    p_date                => SYSDATE,
                                    p_template_id         => 11);    -- change
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