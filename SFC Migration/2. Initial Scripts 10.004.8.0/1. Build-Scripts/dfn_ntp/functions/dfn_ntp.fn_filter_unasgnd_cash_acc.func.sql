CREATE OR REPLACE FUNCTION dfn_ntp.fn_filter_unasgnd_cash_acc (
    pview IN VARCHAR DEFAULT NULL)
    RETURN NUMBER
IS
    l_value   NUMBER;
BEGIN
    l_value := 1;
    RETURN l_value;
EXCEPTION
    WHEN OTHERS
    THEN
        l_value := -1;
        RETURN l_value;
END;
/
