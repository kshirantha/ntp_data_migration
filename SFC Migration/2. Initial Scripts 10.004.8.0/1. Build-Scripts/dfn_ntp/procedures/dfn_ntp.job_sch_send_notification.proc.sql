CREATE OR REPLACE PROCEDURE dfn_ntp.job_sch_send_notification (
    p_message IN VARCHAR2)
IS
    l_notify_enabled   VARCHAR2 (200) := '0';
    l_notify_path      VARCHAR2 (200) := '0';
    l_notify_nos       VARCHAR2 (200);
    l_count            NUMBER := 0;
    l_sms_id           VARCHAR (10);

    TYPE t_table IS TABLE OF VARCHAR2 (20)
        INDEX BY BINARY_INTEGER;

    l_table            t_table;
BEGIN
    SELECT MAX (v00_value)
      INTO l_notify_enabled
      FROM v00_sys_config
     WHERE v00_key = 'EOD_NOTIFICATIONS_ENABLED';

    l_notify_enabled := TRIM (NVL (l_notify_enabled, 0));

    IF l_notify_enabled = 0
    THEN
        RETURN;
    END IF;

    SELECT MAX (v00_value)
      INTO l_notify_nos
      FROM v00_sys_config
     WHERE v00_key = 'EOD_NOTIFICATIONS_MOBILE_NO';

    IF l_notify_nos IS NOT NULL
    THEN
        l_notify_nos := l_notify_nos || ',';

        WHILE INSTR (l_notify_nos, ',') != 0
        LOOP
            l_count := l_count + 1;
            l_table (l_count) :=
                SUBSTR (l_notify_nos, 0, INSTR (l_notify_nos, ',') - 1);
            l_notify_nos :=
                SUBSTR (l_notify_nos, INSTR (l_notify_nos, ',') + 1);
        END LOOP;

        FOR i IN l_table.FIRST .. l_table.LAST
        LOOP
            IF l_table (i) IS NOT NULL
            THEN
                sp_sms_email_add (pkey                  => l_sms_id,
                                  p_mobile_no           => l_table (i),
                                  p_lang                => 'EN',
                                  p_event_id            => 0,
                                  p_notification_type   => 1,
                                  p_message             => p_message,
                                  p_date                => SYSDATE);
            END IF;
        END LOOP;
    END IF;
END;
/