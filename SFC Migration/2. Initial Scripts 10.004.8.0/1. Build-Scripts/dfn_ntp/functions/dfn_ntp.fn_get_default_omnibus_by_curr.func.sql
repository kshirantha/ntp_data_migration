CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_default_omnibus_by_curr (
    m93_currency_code_m03 IN CHAR DEFAULT 'SAR')
    RETURN NUMBER
IS
    l_m93_id   NUMBER;
BEGIN
    SELECT a.m93_id
      INTO l_m93_id
      FROM m93_bank_accounts a
     WHERE     m93_is_default_omnibus = 1
           AND m93_currency_code_m03 = m93_currency_code_m03;

    RETURN l_m93_id;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN -1;
END;
/
/
