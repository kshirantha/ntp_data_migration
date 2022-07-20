CREATE OR REPLACE PROCEDURE dfn_ntp.generatenewmubasherno (
    mubasherno OUT VARCHAR)
IS
    b                     BOOLEAN;
    n1                    NUMBER;
    n2                    NUMBER;
    no                    VARCHAR (50);
    pmubasher_no_from     NUMBER;
    pmubasher_no_to       NUMBER;
    pmubasher_no_prefix   VARCHAR (20);
    pmubasher_no_sufix    VARCHAR (20);
BEGIN
    b := TRUE;
    /*
        SELECT NVL (TO_NUMBER (TRIM (m48_value)), 100000000)
          INTO pmubasher_no_from
          FROM m48_sys_para
         WHERE m48_id = 'MUBASHER_NO_FROM';

        SELECT NVL (TO_NUMBER (TRIM (m48_value)), 999999999)
          INTO pmubasher_no_to
          FROM m48_sys_para
         WHERE m48_id = 'MUBASHER_NO_TO';

        SELECT TRIM (m48_value)
          INTO pmubasher_no_prefix
          FROM m48_sys_para
         WHERE m48_id = 'MUBASHER_NO_PREFIX';

        SELECT TRIM (m48_value)
          INTO pmubasher_no_sufix
          FROM m48_sys_para
         WHERE m48_id = 'MUBASHER_NO_SUFIX';*/


    pmubasher_no_from := 100000;
    pmubasher_no_to := 999999;
    pmubasher_no_prefix := '11';
    pmubasher_no_sufix := '';

    WHILE b
    LOOP
        SELECT TO_CHAR (
                   TRUNC (
                       DBMS_RANDOM.VALUE (pmubasher_no_from, pmubasher_no_to)))
          INTO mubasherno
          FROM DUAL;

        mubasherno := pmubasher_no_prefix || mubasherno || pmubasher_no_sufix;

        SELECT COUNT (*)
          INTO n1
          FROM u01_customer
         WHERE u01_customer_no = mubasherno;

        IF n1 = 0
        THEN
            b := FALSE;
        END IF;
    END LOOP;



    RETURN;
END;
/
/
