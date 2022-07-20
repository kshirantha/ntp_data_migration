CREATE OR REPLACE FUNCTION dfn_ntp.get_last_day_of_month (d1 DATE)
    RETURN DATE
IS
    l_return   DATE;
BEGIN
    SELECT LAST_DAY (d1) INTO l_return FROM DUAL;

    RETURN l_return;
END;
/
/
