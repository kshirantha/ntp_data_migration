CREATE OR REPLACE FUNCTION dfn_ntp.func_get_eod_date
    RETURN DATE
IS
    l_sysdate   DATE := SYSDATE;
    l_time      NUMBER;
BEGIN
    SELECT SYSDATE - TRUNC (SYSDATE) INTO l_time FROM DUAL;

    IF l_time < 0.5
    THEN
        l_sysdate := SYSDATE - 1;
    END IF;

    RETURN TRUNC (l_sysdate);
END;
/