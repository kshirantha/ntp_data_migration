CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_a18_inactive_users
(
    a18_login_name,
    u17_full_name,
    u17_institution_id_m02,
    a18_narration,
    a18_login_time,
    login_date,
    login_status,
    a18_status_id_v01
)
AS
    SELECT a18.a18_login_name,
           u17.u17_full_name,
           u17.u17_institution_id_m02,
           a18.a18_narration,
           a18.a18_login_time,
           a18_login_date AS login_date,
           CASE a18.a18_status_id_v01
               WHEN 0 THEN 'Pending'
               WHEN 1 THEN 'Active'
               WHEN 2 THEN 'Locked'
               WHEN 3 THEN 'Suspended'
           END
               AS login_status,
           a18.a18_status_id_v01
      FROM     a18_user_login_audit_all a18
           JOIN
               u17_employee u17
           ON a18.a18_login_id = u17.u17_id
     WHERE a18.a18_status_id_v01 IN (2, 3)
/
