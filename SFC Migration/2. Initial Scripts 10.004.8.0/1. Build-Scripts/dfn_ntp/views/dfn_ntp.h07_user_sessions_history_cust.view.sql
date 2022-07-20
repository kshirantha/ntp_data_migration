CREATE OR REPLACE FORCE VIEW dfn_ntp.h07_user_sessions_history_cust
(
    h07_login_time,
    login_time,
    login_name,
    u09_price_user_name,
    u01_full_name,
    nin_iqama,
    h07_ip,
    h07_logout_date,
    h07_logout_time,
    v29_description,
    h07_login_date_time,
    h07_login_id,
    u01_institute_id_m02
)
AS
      SELECT h07_login_date AS h07_login_time,
             TO_CHAR (h07.h07_login_time, 'HH:MI:SS AM') AS login_time,
             u09.u09_login_name AS login_name,
             u09.u09_price_user_name,
             u01.u01_full_name,
             u05.u05_id_no AS nin_iqama,
             h07.h07_ip,
             TRUNC (h07.h07_logout_time) AS h07_logout_date,
             TO_CHAR (h07.h07_logout_time, 'HH:MI:SS AM') AS h07_logout_time,
             v29.v29_description,
             h07.h07_login_time AS h07_login_date_time,
             h07.h07_login_id,
             u01.u01_institute_id_m02
        FROM h07_user_sessions_all h07
             INNER JOIN u09_customer_login u09
                 ON h07.h07_login_id = u09.u09_id
             INNER JOIN u01_customer u01
                 ON u09.u09_customer_id_u01 = u01.u01_id
             JOIN u05_customer_identification u05
                 ON u01.u01_id = u05.u05_customer_id_u01
             INNER JOIN v29_order_channel v29
                 ON h07.h07_channel_id = v29.v29_id AND h07.h07_entity_type = 1
    ORDER BY h07_login_time DESC
/
