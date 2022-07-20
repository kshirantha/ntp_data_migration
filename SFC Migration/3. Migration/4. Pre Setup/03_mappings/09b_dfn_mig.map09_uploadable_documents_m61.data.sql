DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map09_uploadable_documents_m61;

    IF l_count = 0
    THEN
        INSERT INTO map09_uploadable_documents_m61
             VALUES (1, 1, 'Passport');

        INSERT INTO map09_uploadable_documents_m61
             VALUES (2, 2, 'Contract');

        INSERT INTO map09_uploadable_documents_m61
             VALUES (3, 3, 'Signature');

        INSERT INTO map09_uploadable_documents_m61
             VALUES (4, 4, 'Exchange A/C Paper');

        INSERT INTO map09_uploadable_documents_m61
             VALUES (5, 5, 'Power of Attorney');

        INSERT INTO map09_uploadable_documents_m61
             VALUES (6, 6, 'Company Registration');

        INSERT INTO map09_uploadable_documents_m61
             VALUES (7, 7, 'Bank A/C Details');

        INSERT INTO map09_uploadable_documents_m61
             VALUES (8, 8, 'Conditional Order Agreement');

        INSERT INTO map09_uploadable_documents_m61
             VALUES (9, 9, 'Family Book');

        INSERT INTO map09_uploadable_documents_m61
             VALUES (10, 10, 'Driving License');

        INSERT INTO map09_uploadable_documents_m61
             VALUES (11, 11, 'Agreement');

        INSERT INTO map09_uploadable_documents_m61
             VALUES (12, 12, 'Other Documents');

        INSERT INTO map09_uploadable_documents_m61
             VALUES (13, 13, 'Logo');

        INSERT INTO map09_uploadable_documents_m61
             VALUES (14, 14, 'Margin Trading Agreement');

        INSERT INTO map09_uploadable_documents_m61
             VALUES (15, 15, 'POA ID or Passport Copy');
    END IF;
END;
/
