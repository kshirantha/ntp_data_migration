DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.t13_notifications
(
    t13_id                    NUMBER (10, 0),
    t13_mobile                VARCHAR2 (20),
    t13_from_email            VARCHAR2 (100),
    t13_to_email              VARCHAR2 (100) DEFAULT NULL,
    t13_cc_emails             VARCHAR2 (2000),
    t13_customer_id_u01       NUMBER (10, 0),
    t13_message_body          VARCHAR2 (4000),
    t13_message_subject       VARCHAR2 (500),
    t13_notification_type     NUMBER (1, 0),
    t13_user_id_u17           NUMBER (10, 0) DEFAULT -1,
    t13_lang                  VARCHAR2 (2) DEFAULT ''EN'',
    t13_customer_name_u01     VARCHAR2 (200),
    t13_event_id_m148         NUMBER (3, 0),
    t13_institution_id_m02    NUMBER (10, 0),
    t13_created_date          DATE,
    t13_template_id_m149      NUMBER (5, 0),
    t13_notification_status   NUMBER (1, 0) DEFAULT 0,
    t13_custom_type           VARCHAR2 (50) DEFAULT 1,
    t13_bcc_emails            VARCHAR2 (2000)
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (t13_created_date)
    INTERVAL ( NUMTOYMINTERVAL (1, ''MONTH'') )
    (
        PARTITION t13_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_t13_created_date ON dfn_arc.t13_notifications (t13_created_date DESC) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.t13_notifications TO dfn_ntp
/

GRANT INSERT ON dfn_arc.t13_notifications TO dfn_ntp
/

ALTER TABLE dfn_arc.t13_notifications
 MODIFY (
  t13_id NOT NULL
 )
/
