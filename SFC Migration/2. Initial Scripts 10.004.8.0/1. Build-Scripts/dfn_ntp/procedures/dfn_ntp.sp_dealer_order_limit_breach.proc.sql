CREATE OR REPLACE PROCEDURE dfn_ntp.sp_dealer_order_limit_breach
IS
BEGIN
    FOR i
        IN (SELECT ord_limit.u17_id,
                   ord_limit.u17_full_name,
                   ord_limit.u17_institution_id_m02,
                   ord_limit.m02_email,
                   ord_limit.m50_order_value_per_day,
                   ord_limit.m50_order_volume_per_day,
                   ord_limit.cummilative_ord_value,
                   ord_limit.cummilative_ord_volume,
                   CASE
                       WHEN u41.u41_notify_email_cc_list IS NULL
                       THEN
                           ord_limit.u17_email
                       ELSE
                              u41.u41_notify_email_cc_list
                           || ','
                           || ord_limit.u17_email
                   END
                       AS u41_notify_email_cc_list,
                   CASE
                       WHEN ord_limit.cummilative_ord_value >=
                                ord_limit.m50_order_value_per_day
                       THEN
                           'Value'
                       WHEN ord_limit.cummilative_ord_volume >=
                                ord_limit.m50_order_volume_per_day
                       THEN
                           'Volume'
                   END
                       AS breached_type
            FROM (SELECT u17.u17_id,
                         MAX (u17.u17_full_name) AS u17_full_name,
                         MAX (u17.u17_institution_id_m02)
                             AS u17_institution_id_m02,
                         MAX (m02.m02_email) AS m02_email,
                         MAX (m50.m50_order_value_per_day)
                             AS m50_order_value_per_day,
                         MAX (m50.m50_order_volume_per_day)
                             AS m50_order_volume_per_day,
                         MAX (u17.u17_email) AS u17_email,
                         NVL (
                             SUM (
                                   ABS (t02.t02_amnt_in_txn_currency)
                                 * get_exchange_rate (
                                       t02.t02_inst_id_m02,
                                       t02.t02_txn_currency,
                                       m50.m50_default_currency_code_m03)),
                             0)
                             AS cummilative_ord_value,
                         NVL (SUM (t02.t02_last_shares), 0)
                             AS cummilative_ord_volume
                    FROM t02_transaction_log_order_all t02,
                         t01_order t01,
                         m50_employee_trd_limits m50,
                         u17_employee u17,
                         m02_institute m02
                   WHERE     t02.t02_cliordid_t01 = t01.t01_cl_ord_id
                         AND t01.t01_dealer_id_u17 = m50.m50_employee_id_u17
                         AND m50.m50_employee_id_u17 = u17.u17_id
                         AND t01.t01_ord_channel_id_v29 = 12
                         AND u17.u17_institution_id_m02 = m02.m02_id
                         AND t02.t02_create_date = TRUNC (SYSDATE)
                  GROUP BY u17.u17_id) ord_limit,
                 u41_notification_configuration u41
            WHERE     u41.u41_notification_type_id_m100 = 49
                  AND u41.u41_institution_id_m02 =
                          ord_limit.u17_institution_id_m02
                  AND (   ord_limit.cummilative_ord_value >=
                              ord_limit.m50_order_value_per_day
                       OR ord_limit.cummilative_ord_volume >=
                              ord_limit.m50_order_volume_per_day))
    LOOP
        INSERT INTO t13_notifications (t13_id,
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
            VALUES (
                       fn_get_next_sequnce ('T13_NOTIFICATIONS'),
                       NULL,
                       i.m02_email,
                       i.u41_notify_email_cc_list,
                       i.u41_notify_email_cc_list,
                       NULL,
                          'OrdLimitType='
                       || i.breached_type
                       || UNISTR (REPLACE ('\u0001', 'u'))
                       || 'OrdLimit='
                       || CASE
                              WHEN i.breached_type = 'Value'
                              THEN
                                  i.cummilative_ord_value
                              ELSE
                                  i.cummilative_ord_volume
                          END
                       || UNISTR (REPLACE ('\u0001', 'u'))
                       || 'OrdLimitEntity=Dealer'
                       || UNISTR (REPLACE ('\u0001', 'u'))
                       || 'OrdLimitEntityName='
                       || i.u17_full_name,
                          'OrdLimitType='
                       || i.breached_type
                       || UNISTR (REPLACE ('\u0001', 'u'))
                       || 'OrdLimit='
                       || CASE
                              WHEN i.breached_type = 'Value'
                              THEN
                                  i.cummilative_ord_value
                              ELSE
                                  i.cummilative_ord_volume
                          END
                       || UNISTR (REPLACE ('\u0001', 'u'))
                       || 'OrdLimitEntity=Dealer'
                       || UNISTR (REPLACE ('\u0001', 'u'))
                       || 'OrdLimitEntityName='
                       || i.u17_full_name,
                       2,
                       NULL,
                       'EN',
                       NULL,
                       54,
                       i.u17_institution_id_m02,
                       SYSDATE,
                       57,
                       0,
                       '1',
                       NULL);
    END LOOP;
END;
/