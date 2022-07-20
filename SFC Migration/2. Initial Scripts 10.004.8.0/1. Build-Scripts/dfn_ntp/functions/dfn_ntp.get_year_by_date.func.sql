CREATE OR REPLACE FUNCTION dfn_ntp.get_year_by_date (datevalue IN DATE)
    RETURN NUMBER
IS
BEGIN
    RETURN TO_NUMBER (TO_CHAR (datevalue, 'YYYY'));
END;
/
/
