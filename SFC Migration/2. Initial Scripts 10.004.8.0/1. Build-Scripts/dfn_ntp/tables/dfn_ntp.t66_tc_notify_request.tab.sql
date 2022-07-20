CREATE TABLE dfn_ntp.t66_tc_notify_request
(
    t66_id                          NUMBER (18, 0) NOT NULL,
    t66_trade_confirmation_id_t64   NUMBER (18, 0) NOT NULL,
    t66_report_no                   VARCHAR2 (14 BYTE) NOT NULL,
    t66_to_email                    VARCHAR2 (100 BYTE) NOT NULL,
    t66_cc_email                    VARCHAR2 (2000 BYTE),
    t66_bcc_email                   VARCHAR2 (2000 BYTE),
    t66_subject                     VARCHAR2 (500 BYTE) NOT NULL,
    t66_email_body                  VARCHAR2 (4000 BYTE) NOT NULL,
    t66_tc_format_id_v12            NUMBER (4, 0) NOT NULL,
    t66_report_name                 VARCHAR2 (500 BYTE),
    t66_status_id_v01               NUMBER (20, 0),
    t66_notification_id_t13         NUMBER (10, 0) DEFAULT NULL,
    t66_created_by_id_u17           NUMBER (10, 0),
    t66_created_date                DATE,
    t66_status_changed_by_id_u17    NUMBER (10, 0),
    t66_status_changed_date         DATE,
    t66_institute_id_m02            NUMBER (3, 0) DEFAULT 1,
    t66_custom_type                 VARCHAR2 (50 BYTE)
)
/



ALTER TABLE dfn_ntp.t66_tc_notify_request
ADD CONSTRAINT pk_t66 PRIMARY KEY (t66_id)
USING INDEX
/