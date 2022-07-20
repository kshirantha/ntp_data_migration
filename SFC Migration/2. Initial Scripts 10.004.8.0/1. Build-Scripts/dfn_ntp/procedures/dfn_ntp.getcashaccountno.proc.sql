CREATE OR REPLACE PROCEDURE dfn_ntp.getcashaccountno (
    cashaccountid   IN     NUMBER,
    cashaccountno      OUT VARCHAR)
IS
    lprefix   VARCHAR (10);
BEGIN
    lprefix := 'C';
    cashaccountno := TO_CHAR (NVL (cashaccountid, 1), '000000000');
    cashaccountno := TRIM (lprefix) || TRIM (cashaccountno);
END;
/
/
