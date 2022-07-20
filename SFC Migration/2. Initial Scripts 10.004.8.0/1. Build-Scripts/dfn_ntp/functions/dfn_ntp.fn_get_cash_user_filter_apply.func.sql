CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_cash_user_filter_apply (
    pview IN VARCHAR DEFAULT NULL)
    RETURN NUMBER
IS
    l_value   NUMBER;
BEGIN
    l_value := 0;
    RETURN l_value;
EXCEPTION
    WHEN OTHERS
    THEN
        l_value := -1;
        RETURN l_value;
END;
/
