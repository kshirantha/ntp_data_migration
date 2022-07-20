DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map12_notification_items_m99;

    IF l_count = 0
    THEN
        INSERT INTO map12_notification_items_m99
             VALUES (1, 1, 'Customer Statements');

        INSERT INTO map12_notification_items_m99
             VALUES (2, 2, 'Order Status');

        INSERT INTO map12_notification_items_m99
             VALUES (3, 3, 'Customer Operations');

        INSERT INTO map12_notification_items_m99
             VALUES (4, 4, 'Margin Trading Notifications');

        INSERT INTO map12_notification_items_m99
             VALUES (5, 5, 'Password Distribution');

        INSERT INTO map12_notification_items_m99
             VALUES (6, 6, 'Trade Confirmation Notifications');

        INSERT INTO map12_notification_items_m99
             VALUES (7, 101, 'Customer Advise');
    END IF;
END;
/
