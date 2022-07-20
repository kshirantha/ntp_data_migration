DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map05_employee_type_m11;

    IF l_count = 0
    THEN
        INSERT INTO map05_employee_type_m11
             VALUES (1, 1, 'Employee');

        INSERT INTO map05_employee_type_m11
             VALUES (13, 2, 'Management');

        INSERT INTO map05_employee_type_m11
             VALUES (5, 3, 'Dealer');

        INSERT INTO map05_employee_type_m11
             VALUES (7, 5, 'Dealer Manager');

        INSERT INTO map05_employee_type_m11
             VALUES (6, 6, 'Super Dealer');

        INSERT INTO map05_employee_type_m11
             VALUES (12, 7, 'Execution Broker User');

        INSERT INTO map05_employee_type_m11
             VALUES (2, 8, 'Agent');

        INSERT INTO map05_employee_type_m11
             VALUES (3, 9, 'CRM Team Lead');

        INSERT INTO map05_employee_type_m11
             VALUES (4, 10, 'CRM Manager');

        INSERT INTO map05_employee_type_m11
             VALUES (8, 11, 'CRM Supervisor');

        INSERT INTO map05_employee_type_m11
             VALUES (9, 12, 'Independent Financial Advisor');

        INSERT INTO map05_employee_type_m11
             VALUES (14, 13, 'Relationship Manager');
    END IF;
END;
/