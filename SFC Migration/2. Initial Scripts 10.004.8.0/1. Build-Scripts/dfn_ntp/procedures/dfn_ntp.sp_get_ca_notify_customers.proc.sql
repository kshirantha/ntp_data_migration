CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_ca_notify_customers (
    p_view             OUT SYS_REFCURSOR,
    p_corpactid     IN     NUMBER,
    p_corpacttype   IN     VARCHAR2,
    p_instid        IN     NUMBER)
IS
    l_tradingaccount   VARCHAR (200);
    l_cashaccount      VARCHAR (200);
    l_holdingadjust    VARCHAR (20000);
    l_holdingcount     NUMBER;
    l_holdingentry     VARCHAR2 (5000);
    l_cashadjust       VARCHAR (5000);
    l_cashcharge       VARCHAR2 (5000);
    l_cashcount        NUMBER;
    l_message          VARCHAR (20000);
    l_separator        CHAR;
    l_seq_no           NUMBER;
BEGIN
    FOR i
        IN (SELECT u01.u01_id,
                   u01.u01_customer_no,
                   u01.u01_display_name,
                   u01.u01_display_name_lang,
                   u01.u01_title_id_v01,
                   CASE
                       WHEN    u01.u01_preferred_lang_id_v01 IS NULL
                            OR u01.u01_preferred_lang_id_v01 = 1
                       THEN
                           'EN'
                       ELSE
                           'AR'
                   END
                       AS preferred_language,
                   u01.u01_full_name,
                   u01.u01_full_name_lang,
                   u01.u01_def_mobile,
                   u01.u01_def_email,
                   a.is_email,
                   a.is_sms,
                   a.is_swift,
                   t41_trading_acc_id_u07,
                   t41_cash_acc_id_u06,
                   t41_id
              FROM     (  SELECT MAX (m103.m104_customer_id_u01)
                                     AS m104_customer_id_u01,
                                 MAX (m103.is_email) AS is_email,
                                 MAX (m103.is_sms) AS is_sms,
                                 NULL AS is_swift,
                                 t41.t41_trading_acc_id_u07,
                                 MAX (t41.t41_cash_acc_id_u06)
                                     AS t41_cash_acc_id_u06,
                                 MAX (t41_id) AS t41_id
                            FROM     (SELECT *
                                        FROM (  SELECT m104.m104_customer_id_u01,
                                                       MAX (
                                                           CASE
                                                               WHEN     m103.m103_sub_item_id_m100 =
                                                                            36
                                                                    AND m103_channel_id_m101 =
                                                                            2
                                                               THEN
                                                                   1
                                                               ELSE
                                                                   0
                                                           END)
                                                           AS is_email,
                                                       MAX (
                                                           CASE
                                                               WHEN     m103.m103_sub_item_id_m100 =
                                                                            36
                                                                    AND m103_channel_id_m101 =
                                                                            3
                                                               THEN
                                                                   1
                                                               ELSE
                                                                   0
                                                           END)
                                                           AS is_sms
                                                  FROM     m104_cust_notification_schedul m104
                                                       JOIN
                                                           m103_notify_subitem_schedule m103
                                                       ON m104.m104_subitem_shedule_id_m103 =
                                                              m103.m103_id
                                              GROUP BY m104_customer_id_u01)
                                       WHERE is_email != 0 OR is_sms != 0) m103
                                 JOIN
                                     t41_cust_corp_act_distribution t41
                                 ON     m103.m104_customer_id_u01 =
                                            t41.t41_customer_id_u01
                                    AND t41_cust_corp_act_id_m141 = p_corpactid
                        GROUP BY t41_trading_acc_id_u07
                        ORDER BY m104_customer_id_u01 DESC) a
                   LEFT JOIN
                       u01_customer u01
                   ON a.m104_customer_id_u01 = u01.u01_id)
    LOOP
        l_separator := '';
        l_tradingaccount := '';
        l_holdingadjust := '';
        l_cashadjust := '';
        l_cashcharge := '';
        l_holdingentry := '';
        l_message :=
               'CustomerNo ='
            || i.u01_customer_no
            || UNISTR ('\0001')
            || 'DisplayName ='
            || i.u01_display_name
            || UNISTR ('\0001')
            || 'DisplayNameLang ='
            || i.u01_display_name_lang
            || UNISTR ('\0001')
            || 'FullName ='
            || i.u01_full_name
            || UNISTR ('\0001')
            || 'FullNameLang ='
            || i.u01_full_name_lang
            || UNISTR ('\0001')
            || 'MobileNo ='
            || i.u01_def_mobile
            || UNISTR ('\0001')
            || 'Email ='
            || i.u01_def_email
            || UNISTR ('\0001')
            || 'CorporateAction ='
            || p_corpacttype;

        SELECT COUNT (*)
          INTO l_holdingcount
          FROM vw_t42_cust_corp_act_hold t42
         WHERE i.t41_id = t42.t42_cust_distr_id_t41;

        IF (l_holdingcount > 0)
        THEN
            l_holdingadjust := '[';

            FOR j IN (SELECT *
                        FROM vw_t42_cust_corp_act_hold t42
                       WHERE i.t41_id = t42.t42_cust_distr_id_t41)
            LOOP
                l_tradingaccount := j.u07_display_name;

                IF (l_holdingadjust = '[')
                THEN
                    l_separator := '';
                ELSE
                    l_separator := ',';
                END IF;

                l_holdingentry :=
                       '{'
                    || j.t42_exchange_code_m01
                    || ','
                    || j.t42_symbol_code_m20
                    || ','
                    || j.hold_adj_type
                    || ','
                    || j.t42_eligible_quantity
                    || '}';
                l_holdingadjust :=
                    l_holdingadjust || l_separator || l_holdingentry;
            END LOOP;

            l_holdingadjust := l_holdingadjust || ']';
            DBMS_OUTPUT.put_line (l_holdingadjust);
        END IF;

        SELECT COUNT (*)
          INTO l_cashcount
          FROM vw_t43_cust_corp_act_cash t43
         WHERE i.t41_id = t43.t43_cust_distr_id_t41;

        IF (l_cashcount > 0)
        THEN
            FOR k IN (SELECT *
                        FROM vw_t43_cust_corp_act_cash t43
                       WHERE i.t41_id = t43.t43_cust_distr_id_t41)
            LOOP
                l_cashaccount := k.u06_display_name;

                IF (k.cash_type = 'Charge')
                THEN
                    l_cashcharge := '{' || k.t43_amnt_in_txn_currency || '}';
                ELSE
                    l_cashadjust := '{' || k.t43_amnt_in_txn_currency || '}';
                END IF;
            END LOOP;
        END IF;

        l_message :=
               l_message
            || UNISTR ('\0001')
            || 'HoldingAdjust ='
            || l_holdingadjust
            || UNISTR ('\0001')
            || 'CashCharge ='
            || l_cashcharge
            || UNISTR ('\0001')
            || 'CashAdjust ='
            || l_cashadjust
            || UNISTR ('\0001')
            || 'TradingAccount ='
            || l_tradingaccount
            || UNISTR ('\0001')
            || 'CashAccount ='
            || l_cashaccount;

        IF (i.is_sms = 1)
        THEN
            SELECT MAX (t13_id) + 1 INTO l_seq_no FROM t13_notifications;

            sp_sms_email_add (pkey                  => l_seq_no,
                              p_mobile_no           => i.u01_def_mobile,
                              p_lang                => i.preferred_language,
                              p_event_id            => 47,
                              p_institution         => p_instid,
                              p_custname            => i.u01_full_name,
                              p_notification_type   => 1,
                              p_message             => l_message,
                              p_date                => SYSDATE,
                              p_template_id         => 11);
            COMMIT;
        END IF;

        IF (i.is_email = 1)
        THEN
            SELECT MAX (t13_id) + 1 INTO l_seq_no FROM t13_notifications;

            sp_sms_email_add (pkey                  => l_seq_no,
                              p_mobile_no           => i.u01_def_mobile,
                              p_from_email          => '',
                              p_to_email            => '',
                              p_cc_emails           => '',
                              p_lang                => i.preferred_language,
                              p_event_id            => 47,
                              p_institution         => p_instid,
                              p_custname            => i.u01_full_name,
                              p_notification_type   => 2,
                              p_message             => l_message,
                              p_message_subject     => '',
                              p_date                => SYSDATE,
                              p_template_id         => 11);
            COMMIT;
        END IF;
    END LOOP;
END;
/
