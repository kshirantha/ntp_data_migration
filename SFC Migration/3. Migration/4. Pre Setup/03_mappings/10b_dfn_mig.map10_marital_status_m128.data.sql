DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map10_marital_status_m128;

    IF l_count = 0
    THEN
        INSERT INTO map10_marital_status_m128
             VALUES (1, 1, 'Single');

        INSERT INTO map10_marital_status_m128
             VALUES (2, 2, 'Married');

        INSERT INTO map10_marital_status_m128
             VALUES (3, 8, 'Other');
    END IF;
END;
/
