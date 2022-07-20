CREATE OR REPLACE PROCEDURE dfn_ntp.gettradingaccountno (id   IN     NUMBER,
                                                         no      OUT VARCHAR)
IS
    lprefix   VARCHAR (10);
BEGIN
    lprefix := 'T';
    no := TO_CHAR (NVL (id, 1), '000000000');
    no := TRIM (lprefix) || TRIM (no);
END;
/
/
