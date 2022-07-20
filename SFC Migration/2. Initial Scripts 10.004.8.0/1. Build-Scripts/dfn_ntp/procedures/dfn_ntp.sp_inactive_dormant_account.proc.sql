CREATE OR REPLACE PROCEDURE dfn_ntp.sp_inactive_dormant_account
IS
    l_days_to_inactive        NUMBER := 180;
    l_days_to_dormant         NUMBER := 365;
    l_message                 VARCHAR (2000);

    l_m71_stock_trading       m71_institute_restrictions.m71_stock_trading%TYPE;
    l_m71_stock_transaction   m71_institute_restrictions.m71_stock_transaction%TYPE;
    l_m71_stock_transfer      m71_institute_restrictions.m71_stock_transfer%TYPE;
    l_m71_pledge              m71_institute_restrictions.m71_pledge%TYPE;
    l_m71_cash_transactions   m71_institute_restrictions.m71_cash_transactions%TYPE;
    l_m71_cash_transfer       m71_institute_restrictions.m71_cash_transfer%TYPE;
BEGIN
    -- inactivate customers

    SELECT TO_NUMBER (NVL (MAX (v00_value), '0'))
      INTO l_days_to_inactive
      FROM v00_sys_config
     WHERE v00_key = 'DAYS_TO_INACTIVE';

    FOR inst IN (SELECT m02_id FROM m02_institute)
    LOOP
        SELECT m71.m71_stock_trading,
               m71.m71_stock_transaction,
               m71.m71_stock_transfer,
               m71.m71_pledge,
               m71.m71_cash_transactions,
               m71.m71_cash_transfer
          INTO l_m71_stock_trading,
               l_m71_stock_transaction,
               l_m71_stock_transfer,
               l_m71_pledge,
               l_m71_cash_transactions,
               l_m71_cash_transfer
          FROM m71_institute_restrictions m71
         WHERE m71.m71_institution_id_m02 = inst.m02_id AND m71.m71_type = 3;

        FOR i
            IN (SELECT u01.u01_id,
                       u01.u01_customer_no,
                       u01.u01_full_name,
                       u01.u01_full_name_lang,
                       u06.u06_id,
                       u06.u06_display_name,
                       u01.u01_def_mobile,
                       TRUNC (SYSDATE) - u06.u06_last_activity_date
                           AS inactive_dates,
                       u01.u01_preferred_lang_id_v01,
                       u01.u01_institute_id_m02,
                       u01.u01_display_name
                  FROM     u01_customer u01
                       JOIN
                           u06_cash_account u06
                       ON u06.u06_customer_id_u01 = u01.u01_id
                 WHERE     u06.u06_inactive_drmnt_status_v01 NOT IN (11, 12)
                       AND u01.u01_account_type_id_v01 != 1 -- exclude Master Account
                       AND u06.u06_last_activity_date <=
                               TRUNC (SYSDATE) - l_days_to_inactive
                       AND u06.u06_institute_id_m02 = inst.m02_id)
        LOOP
            UPDATE u06_cash_account u06
               SET u06.u06_inactive_dormant_date = SYSDATE,
                   u06.u06_inactive_drmnt_status_v01 = 11
             WHERE u06.u06_id = i.u06_id;

            sp_cash_acc_wise_restrict (
                pu06_id                  => i.u06_id,
                pm71_cash_transactions   => l_m71_cash_transactions,
                pm71_cash_transfer       => l_m71_cash_transfer,
                pnarration               => 'Customer Account has been Inactivated by System',
                pnarration_lang          => 'Customer Account has been Inactivated by System',
                prestriction_source      => 3);


            FOR j IN (SELECT u07_id
                        FROM u07_trading_account
                       WHERE u07_cash_account_id_u06 = i.u06_id)
            LOOP
                sp_trading_acc_wise_restrict (
                    pu07_id                  => j.u07_id,
                    pm71_stock_trading       => l_m71_stock_trading,
                    pm71_stock_transaction   => l_m71_stock_transaction,
                    pm71_stock_transfer      => l_m71_stock_transfer,
                    pm71_pledge              => l_m71_pledge,
                    pnarration               => 'Customer Account has been Inactivated by System',
                    pnarration_lang          => 'Customer Account has been Inactivated by System',
                    prestriction_source      => 3);
            END LOOP;

            l_message :=
                   'day_count ='
                || i.inactive_dates
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
                || 'CashAccount ='
                || i.u06_display_name
                || UNISTR ('\0001')
                || 'MobileNo ='
                || i.u01_def_mobile;

            dfn_ntp.sp_send_customer_sms_email (
                pu01_id             => i.u01_id,
                pm103_sub_item      => 42,
                psms                => l_message,
                psms_ar             => l_message,
                pemail_subject      => 'Customer Inactive',
                pemail_subject_ar   => 'Customer Inactive',
                pemail_body         => l_message,
                pemail_body_ar      => l_message,
                p_event_id_m148     => 11);
        END LOOP;

        -- Dormant  Customers

        SELECT TO_NUMBER (NVL (MAX (v00_value), '0'))
          INTO l_days_to_dormant
          FROM v00_sys_config
         WHERE v00_key = 'DAYS_TO_DORMANT';

        SELECT m71.m71_stock_trading,
               m71.m71_stock_transaction,
               m71.m71_stock_transfer,
               m71.m71_pledge,
               m71.m71_cash_transactions,
               m71.m71_cash_transfer
          INTO l_m71_stock_trading,
               l_m71_stock_transaction,
               l_m71_stock_transfer,
               l_m71_pledge,
               l_m71_cash_transactions,
               l_m71_cash_transfer
          FROM m71_institute_restrictions m71
         WHERE m71.m71_institution_id_m02 = inst.m02_id AND m71.m71_type = 4;

        FOR i
            IN (SELECT u01.u01_id,
                       u01.u01_customer_no,
                       u01.u01_full_name,
                       u01.u01_full_name_lang,
                       u06.u06_id,
                       u06.u06_display_name,
                       TRUNC (SYSDATE) - u06.u06_last_activity_date
                           AS inactive_dates,
                       u01.u01_preferred_lang_id_v01,
                       u01.u01_institute_id_m02,
                       u01.u01_display_name
                  FROM     u01_customer u01
                       JOIN
                           u06_cash_account u06
                       ON u06.u06_customer_id_u01 = u01.u01_id
                 WHERE     u06.u06_inactive_drmnt_status_v01 = 11
                       AND u01.u01_account_type_id_v01 != 1 -- exclude Master Account
                       AND u06.u06_last_activity_date <=
                               TRUNC (SYSDATE) - l_days_to_dormant
                       AND u06.u06_institute_id_m02 = inst.m02_id)
        LOOP
            UPDATE u06_cash_account u06
               SET u06.u06_inactive_dormant_date = SYSDATE,
                   u06.u06_inactive_drmnt_status_v01 = 12
             WHERE u06.u06_id = i.u06_id;

            sp_cash_acc_wise_restrict (
                pu06_id                  => i.u06_id,
                pm71_cash_transactions   => l_m71_cash_transactions,
                pm71_cash_transfer       => l_m71_cash_transfer,
                pnarration               => 'Customer Account has been Dormant – System',
                pnarration_lang          => 'Customer Account has been Dormant – System',
                prestriction_source      => 4);

            FOR j IN (SELECT u07_id
                        FROM u07_trading_account
                       WHERE u07_cash_account_id_u06 = i.u06_id)
            LOOP
                sp_trading_acc_wise_restrict (
                    pu07_id                  => j.u07_id,
                    pm71_stock_trading       => l_m71_stock_trading,
                    pm71_stock_transaction   => l_m71_stock_transaction,
                    pm71_stock_transfer      => l_m71_stock_transfer,
                    pm71_pledge              => l_m71_pledge,
                    pnarration               => 'Customer Account has been Dormant – System',
                    pnarration_lang          => 'Customer Account has been Dormant – System',
                    prestriction_source      => 4);
            END LOOP;

            l_message :=
                   'day_count ='
                || i.inactive_dates
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
                || 'CashAccount ='
                || i.u06_display_name;

            dfn_ntp.sp_send_customer_sms_email (
                pu01_id             => i.u01_id,
                pm103_sub_item      => 43,
                psms                => l_message,
                psms_ar             => l_message,
                pemail_subject      => 'Customer Dormant',
                pemail_subject_ar   => 'Customer Dormant',
                pemail_body         => l_message,
                pemail_body_ar      => l_message,
                p_event_id_m148     => 12);
        END LOOP;
    END LOOP;
END;
/