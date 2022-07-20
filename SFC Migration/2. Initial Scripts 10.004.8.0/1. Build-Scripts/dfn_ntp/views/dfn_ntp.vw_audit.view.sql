CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_audit
(
    a06_id,
    a06_date,
    a06_user_id_u17,
    user_full_name,
    a06_activity_id_m82,
    activity_name,
    a06_description,
    a06_reference_no,
    a06_channel_v29,
    channel_name,
    a06_customer_id_u01,
    customer_full_name,
    a06_login_id_u09,
    a06_user_login_id_u17,
    a06_ip,
    a06_connected_machine,
    category_name,
    m81_id,
    u01_customer_no,
    institution_id
)
AS
    SELECT a06.a06_id,
           a06.a06_date,
           a06.a06_user_id_u17,
           u17.u17_full_name AS user_full_name,
           a06.a06_activity_id_m82,
           m82.m82_activity_name AS activity_name,
           a06.a06_description,
           a06.a06_reference_no,
           a06.a06_channel_v29,
           v29.v29_description AS channel_name,
           a06.a06_customer_id_u01,
           u01.u01_full_name AS customer_full_name,
           a06.a06_login_id_u09,
           a06.a06_user_login_id_u17,
           a06.a06_ip,
           a06.a06_connected_machine,
           m81.m81_category AS category_name,
           m81.m81_id,
           u01.u01_customer_no,
           CASE
               WHEN a06.a06_institute_id_m02 IS NULL
               THEN
                   u17.u17_institution_id_m02
               ELSE
                   a06.a06_institute_id_m02
           END
               AS institution_id
      FROM a06_audit_all a06
           JOIN u17_employee u17
               ON u17.u17_id = a06.a06_user_id_u17
           JOIN m82_audit_activity m82
               ON a06.a06_activity_id_m82 = m82.m82_id
           LEFT JOIN m81_audit_category m81
               ON m82.m82_category_id_m81 = m81.m81_id
           LEFT JOIN u01_customer u01
               ON u01.u01_id = a06.a06_customer_id_u01
           LEFT JOIN v29_order_channel v29
               ON v29.v29_id = a06.a06_channel_v29
/
