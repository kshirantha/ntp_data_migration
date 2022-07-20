update dfn_ntp.v04_entitlements
set v04_enabled = 0 ---check this and remove from institute entitlements as well
where v04_id = 1139; -- Chandika and Satheeq request

--Janaka mail

DELETE dfn_ntp.m101_notification_channels
 WHERE m101_id IN (1, 4, 5);
/

DELETE dfn_ntp.m102_notification_schedule
 WHERE m102_id IN (1, 2, 3, 4, 5);
/

DELETE dfn_ntp.m103_notify_subitem_schedule
 WHERE m103_channel_id_m101 NOT IN
           (SELECT m101_id FROM dfn_ntp.m101_notification_channels);
/


DELETE dfn_ntp.m103_notify_subitem_schedule;


delete dfn_ntp.m104_cust_notification_schedul;

DECLARE
    l_m103_id   NUMBER := 0;
BEGIN
    SELECT NVL (MAX (m103_id), 0)
      INTO l_m103_id
      FROM dfn_ntp.m103_notify_subitem_schedule;


    FOR j IN (SELECT m100_id FROM dfn_ntp.m100_notification_sub_items)
    LOOP
        FOR k IN (SELECT m101_id FROM dfn_ntp.m101_notification_channels)
        LOOP
            FOR l IN (SELECT m102_id FROM dfn_ntp.m102_notification_schedule)
            LOOP
                l_m103_id := l_m103_id + 1;

                INSERT
                  INTO dfn_ntp.m103_notify_subitem_schedule (
                           m103_id,
                           m103_sub_item_id_m100,
                           m103_channel_id_m101,
                           m103_notify_shedule_id_m102)
                VALUES (l_m103_id,
                        j.m100_id,
                        k.m101_id,
                        l.m102_id);
            END LOOP;
        END LOOP;
    END LOOP;
END;
/



commit;

UPDATE dfn_ntp.u17_employee
   SET u17_authentication_type = 3
 WHERE u17_login_name NOT IN
           ('DFNADMIN',
            'INTEGRATION_USER',
            'DUMINDUAT',
            'MALHAR',
            'JAYALAL',
            'JANAKAAT',
            'JANAKADT',
            'MALHARDT',
            'RANGADT',
            'MUBASHER7',
            'MUBASHER',
			'DILUMDT',
			'DILUM');
 
 
commit;


UPDATE dfn_ntp.u28_employee_exchanges a
   SET a.u28_market_id_m29 = 70;
   
   COMMIT;


UPDATE dfn_ntp.v29_order_channel
   SET v29_trader_id_prefix = 'I'
WHERE v29_id IN (14, 27, 31, 32, 33);

COMMIT;