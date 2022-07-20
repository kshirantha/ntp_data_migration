CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_a18_failed_user_logins
(
    a18_login_name,
    u17_full_name,
    u17_institution_id_m02,
    v29_description,
    a18_failed_attempts,
    a18_ip,
    a18_login_time,
    a18_status_id_v01,
    login_date,
    login_status
)
AS
    SELECT a18.a18_login_name,
           u17.u17_full_name,
           u17.u17_institution_id_m02,
           v29.v29_description,
           a18.a18_failed_attempts,
           a18.a18_ip,
           a18.a18_login_time,
           a18.a18_status_id_v01,
           TRUNC (a18.a18_login_time) AS login_date,
           CASE u17.u17_login_status
               WHEN 0 THEN 'Pending'
               WHEN 1 THEN 'Active'
               WHEN 2 THEN 'Locked'
               WHEN 3 THEN 'Suspended'
           END
               AS login_status
      FROM a18_user_login_audit_all a18,
           u17_employee u17,
           v29_order_channel v29
     WHERE     a18.a18_login_id = u17.u17_id
           AND a18.a18_channel_id_v29 = v29.v29_id
/
