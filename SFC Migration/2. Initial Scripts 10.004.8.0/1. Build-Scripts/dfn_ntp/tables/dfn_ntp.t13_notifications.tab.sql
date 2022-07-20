CREATE TABLE dfn_ntp.t13_notifications
(
    t13_id                    NUMBER (10, 0),
    t13_mobile                VARCHAR2 (20 BYTE),
    t13_from_email            VARCHAR2 (100 BYTE),
    t13_to_email              VARCHAR2 (100 BYTE) DEFAULT NULL,
    t13_cc_emails             VARCHAR2 (2000 BYTE),
    t13_customer_id_u01       NUMBER (10, 0),
    t13_message_body          VARCHAR2 (4000 BYTE),
    t13_message_subject       VARCHAR2 (500 BYTE),
    t13_notification_type     NUMBER (1, 0),
    t13_user_id_u17           NUMBER (10, 0) DEFAULT -1,
    t13_lang                  VARCHAR2 (2 BYTE) DEFAULT 'EN',
    t13_customer_name_u01     VARCHAR2 (200 BYTE),
    t13_event_id_m148         NUMBER (3, 0),
    t13_institution_id_m02    NUMBER (10, 0),
    t13_created_date          DATE,
    t13_template_id_m149      NUMBER (5, 0),
    t13_notification_status   NUMBER (1, 0) DEFAULT 0,
    t13_custom_type           VARCHAR2 (50 BYTE) DEFAULT 1,
    t13_bcc_emails            VARCHAR2 (2000 BYTE)
)
/


ALTER TABLE dfn_ntp.t13_notifications
ADD PRIMARY KEY (t13_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.t13_notifications.t13_notification_status IS
    '0-Pending; 1-Sent; 2-Delivered'
/
COMMENT ON COLUMN dfn_ntp.t13_notifications.t13_notification_type IS
    '1 - SMS | 2 - EMAIL'
/