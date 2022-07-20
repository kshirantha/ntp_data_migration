CREATE OR REPLACE FUNCTION dfn_ntp.fn_falcon_login (
    p_username   IN u17_employee.u17_login_name%TYPE,
    p_password   IN u17_employee.u17_password%TYPE)
    RETURN NUMBER
IS
    l_result_count   NUMBER;
    l_status         NUMBER;
BEGIN
    l_status := 1;

    SELECT COUNT (*)
      INTO l_result_count
      FROM u17_employee u17
     WHERE u17.u17_login_name = p_username AND u17.u17_password = p_password;

    IF l_result_count = 0
    THEN
        l_status := 0;
    END IF;

    RETURN l_status;
END;
/