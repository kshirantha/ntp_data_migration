CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_mubasher_number
    RETURN VARCHAR
IS
    mubasher_number   VARCHAR (50) DEFAULT '';
BEGIN
    dfn_ntp.generatenewmubasherno (mubasherno => mubasher_number);
    RETURN mubasher_number;
END;
/
