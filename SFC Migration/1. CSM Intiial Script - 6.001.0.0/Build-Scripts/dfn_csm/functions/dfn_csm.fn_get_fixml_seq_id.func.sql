CREATE OR REPLACE FUNCTION dfn_csm.fn_get_fixml_seq_id
    RETURN CHARACTER
IS
    p_a00_id   VARCHAR2 (25);
BEGIN
    SELECT seq_a00_id.NEXTVAL INTO p_a00_id FROM DUAL;

    RETURN p_a00_id;
END;
/



