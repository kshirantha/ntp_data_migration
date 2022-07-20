CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_posted_date (
    postedfquencetype   IN NUMBER,
    in_date             IN DATE DEFAULT SYSDATE)
    RETURN DATE
IS
    posteddate   DATE;
BEGIN
    IF (postedfquencetype = 1)
    THEN
        SELECT TRUNC (LAST_DAY (in_date)) INTO posteddate FROM DUAL;
    ELSIF (postedfquencetype = 2)
    THEN
        SELECT TRUNC (in_date) INTO posteddate FROM DUAL;
    ELSIF (postedfquencetype = 3)
    THEN
        SELECT TRUNC (NEXT_DAY (in_date, 'FRIDAY')) INTO posteddate FROM DUAL;
    END IF;

    RETURN posteddate;
END fn_get_posted_date;
/