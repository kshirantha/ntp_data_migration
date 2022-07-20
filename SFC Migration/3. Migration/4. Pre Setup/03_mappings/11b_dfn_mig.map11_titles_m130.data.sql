DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map11_titles_m130;

    IF l_count = 0
    THEN
        INSERT INTO dfn_mig.map11_titles_m130
             VALUES (1, 1, 'Mr.');

        INSERT INTO map11_titles_m130
             VALUES (2, 8, 'Prince.');

        INSERT INTO map11_titles_m130
             VALUES (3, 3, 'Mrs.');

        INSERT INTO map11_titles_m130
             VALUES (6, 9, 'Shaikh.');

        INSERT INTO map11_titles_m130
             VALUES (7, 6, 'Dr.');
    END IF;
END;
/
