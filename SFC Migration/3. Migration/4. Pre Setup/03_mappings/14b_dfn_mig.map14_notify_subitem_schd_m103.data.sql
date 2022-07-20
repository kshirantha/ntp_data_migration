DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map14_notify_subitem_schd_m103;

    IF l_count = 0
    THEN
        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (1, 1001);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (2, 21);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (5, 22);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (6, 23);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (7, 24);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (8, 25);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (9, 26);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (10, 27);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (11, 28);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (12, 29);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (13, 30);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (14, 31);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (15, 32);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (16, 33);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (17, 17);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (18, 35);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (19, 36);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (20, 37);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (21, 38);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (22, 39);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (23, 40);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (24, 41);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (25, 42);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (26, 43);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (27, 44);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (28, 1002);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (29, 1003);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (30, 1004);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (31, 1005);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (32, 1006);

        INSERT INTO map14_notify_subitem_schd_m103
             VALUES (33, 1007);
    END IF;
END;
/