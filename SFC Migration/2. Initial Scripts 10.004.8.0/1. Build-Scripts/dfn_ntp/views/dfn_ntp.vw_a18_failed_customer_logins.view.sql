CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_a18_failed_customer_logins
(
    attempted_date,
    attempted_time,
    attempted_login_name,
    login_name,
    price_user_name,
    customer_name,
    customer_no,
    u01_external_ref_no,
    nin_iqama,
    channel,
    a18_ip,
    a18_narration,
    a18_failed_attempts,
    a18_status_id_v01,
    login_date,
    login_status,
    a18_login_time,
    u01_institute_id_m02,
    u09_last_login_date,
    u01_full_name_lang
)
AS
    SELECT a18.a18_login_date AS attempted_date,
           TO_CHAR (a18.a18_login_time, 'HH:MI:SS AM') AS attempted_time,
           a18.a18_login_name AS attempted_login_name,
           u09.u09_login_name AS login_name,
           u09.u09_price_user_name AS price_user_name,
           u01.u01_full_name AS customer_name,
           u01.u01_customer_no AS customer_no,
           u01.u01_external_ref_no,
           u05.u05_id_no AS nin_iqama,
           v29.v29_description AS channel,
           a18.a18_ip,
           a18.a18_narration,
           a18.a18_failed_attempts,
           a18.a18_status_id_v01,
           a18.a18_login_date AS login_date,
           CASE u09.u09_status_id_v01
               WHEN 0 THEN 'Pending'
               WHEN 1 THEN 'Active'
               WHEN 2 THEN 'Locked'
               WHEN 3 THEN 'Suspended'
           END
               AS login_status,
           a18.a18_login_time,
           u01.u01_institute_id_m02,
           u09.u09_last_login_date,
           u01.u01_full_name_lang
      FROM a18_user_login_audit_all a18
           INNER JOIN u09_customer_login u09
               ON a18.a18_login_id = u09.u09_id
           INNER JOIN v29_order_channel v29
               ON a18.a18_channel_id_v29 = v29.v29_id
           INNER JOIN u01_customer u01
               ON u09.u09_customer_id_u01 = u01.u01_id
           JOIN u05_customer_identification u05
               ON u09.u09_customer_id_u01 = u05.u05_customer_id_u01
/
