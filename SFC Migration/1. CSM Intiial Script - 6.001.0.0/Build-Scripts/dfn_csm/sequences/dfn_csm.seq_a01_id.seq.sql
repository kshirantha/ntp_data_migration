CREATE SEQUENCE dfn_csm.seq_a01_id
    INCREMENT BY 1
    START WITH 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    NOCYCLE
    NOORDER
    CACHE 20
/



DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'DROP SEQUENCE DFN_CSM.seq_a01_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_objects
     WHERE owner = UPPER ('dfn_csm') AND object_name = UPPER ('seq_a01_id');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE SEQUENCE dfn_csm.seq_a01_id
    INCREMENT BY 1
    START WITH 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    NOCYCLE
    NOORDER
    CACHE 20
/




