DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map13_notify_sub_items_m100;

    IF l_count = 0
    THEN
        INSERT INTO map13_notify_sub_items_m100
             VALUES (1, 1001, 'Customer Summary');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (2, 2, 'Filled');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (3, 1002, 'Trading Summary');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (4, 4, 'Queued');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (5, 5, 'Cancelled');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (6, 6, 'OMS Accepted');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (7, 7, 'AmendOrder');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (8, 8, 'RejectedOrder');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (9, 9, 'Deposit Withdrawal');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (10, 10, 'Failure Log in');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (11, 11, 'Successful log in');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (12, 12, 'First Log in');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (13, 13, 'Enable Trading confirmation message');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (14, 14, 'Automatic Notification');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (15, 15, 'Margin Call Notifications');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (16, 16, 'Margin Call Reminders');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (17, 17, 'Margin Liquidation Notifications');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (18, 18, 'Password Notification');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (19, 19, 'Trade Confirmation');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (20, 20, 'Partially filled');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (21, 48, 'Share Transfer Notification');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (22, 1003, 'Dividends');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (23, 1004, 'Certificates');

        INSERT INTO map13_notify_sub_items_m100
             VALUES (24, 1005, 'Sales Proceeds');
    END IF;
END;
/
