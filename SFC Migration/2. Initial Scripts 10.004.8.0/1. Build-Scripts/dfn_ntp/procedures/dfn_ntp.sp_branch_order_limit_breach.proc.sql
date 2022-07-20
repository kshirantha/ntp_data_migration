CREATE OR REPLACE PROCEDURE dfn_ntp.sp_branch_order_limit_breach
IS
BEGIN
    FOR i
        IN (SELECT ord_limit.m07_id,
                   ord_limit.m07_name,
                   ord_limit.m07_institute_id_m02,
                   ord_limit.m02_email,
                   ord_limit.m07_order_value_per_day,
                   ord_limit.m07_order_volume_per_day,
                   ord_limit.cummilative_ord_value,
                   ord_limit.cummilative_ord_volume,
                   u41.u41_notify_email_cc_list,
                   CASE
                       WHEN ord_limit.cummilative_ord_value >=
                                ord_limit.m07_order_value_per_day
                       THEN
                           'Value'
                       WHEN ord_limit.cummilative_ord_volume >=
                                ord_limit.m07_order_volume_per_day
                       THEN
                           'Volume'
                   END
                       AS breached_type
            FROM (SELECT m07.m07_id,
                         MAX (m07.m07_name) AS m07_name,
                         MAX (m07.m07_institute_id_m02)
                             AS m07_institute_id_m02,
                         MAX (m02.m02_email) AS m02_email,
                         MAX (m07.m07_order_value_per_day)
                             AS m07_order_value_per_day,
                         MAX (m07.m07_order_volume_per_day)
                             AS m07_order_volume_per_day,
                         NVL (
                             SUM (
                                   ABS (t02.t02_amnt_in_txn_currency)
                                 * get_exchange_rate (
                                       m07.m07_institute_id_m02,
                                       t02.t02_txn_currency,
                                       m07.m07_default_currency_code_m03)),
                             0)
                             AS cummilative_ord_value,
                         NVL (SUM (t02.t02_last_shares), 0)
                             AS cummilative_ord_volume
                    FROM t02_transaction_log_order_all t02,
                         t01_order t01,
                         u01_customer u01,
                         m07_location m07,
                         m02_institute m02
                   WHERE     t02.t02_cliordid_t01 = t01.t01_cl_ord_id
                         AND t01.t01_customer_id_u01 = u01.u01_id
                         AND u01.u01_signup_location_id_m07 = m07.m07_id
                         AND m07.m07_institute_id_m02 = m02.m02_id
                         AND t02.t02_create_date = TRUNC (SYSDATE)
                  GROUP BY m07.m07_id) ord_limit,
                 u41_notification_configuration u41
            WHERE     u41.u41_notification_type_id_m100 = 49
                  AND u41.u41_institution_id_m02 =
                          ord_limit.m07_institute_id_m02
                  AND (   ord_limit.cummilative_ord_value >=
                              ord_limit.m07_order_value_per_day
                       OR ord_limit.cummilative_ord_volume >=
                              ord_limit.m07_order_volume_per_day))
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
                       || 'OrdLimitEntity=Branch'
                       || UNISTR (REPLACE ('\u0001', 'u'))
                       || 'OrdLimitEntityName='
                       || i.m07_name,
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
                       || 'OrdLimitEntity=Branch'
                       || UNISTR (REPLACE ('\u0001', 'u'))
                       || 'OrdLimitEntityName='
                       || i.m07_name,
                       2,
                       NULL,
                       'EN',
                       NULL,
                       54,
                       i.m07_institute_id_m02,
                       SYSDATE,
                       57,
                       0,
                       '1',
                       NULL);
    END LOOP;
END;
/