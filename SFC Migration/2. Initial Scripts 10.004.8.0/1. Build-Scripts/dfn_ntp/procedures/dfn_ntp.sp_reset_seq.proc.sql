CREATE OR REPLACE PROCEDURE dfn_ntp.sp_reset_seq (
    p_seq_name          IN VARCHAR2,
    p_table_name        IN VARCHAR2,
    p_table_id_column   IN VARCHAR2,
    p_reset             IN NUMBER -- 0 - No | 1 - Reset to 1
                                 )
    AUTHID CURRENT_USER
IS
    l_val   NUMBER;
BEGIN
    IF p_reset = 0
    THEN
        EXECUTE IMMEDIATE
            'SELECT MAX(' || p_table_id_column || ') FROM ' || p_table_name
            INTO l_val;

        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || p_seq_name;

        EXECUTE IMMEDIATE
            'CREATE SEQUENCE ' || p_seq_name || ' INCREMENT BY 1
        START WITH 1';

        IF l_val IS NOT NULL AND l_val > 0 AND p_reset = 0
        THEN
            EXECUTE IMMEDIATE
                'ALTER SEQUENCE ' || p_seq_name || ' INCREMENT BY ' || l_val;


            EXECUTE IMMEDIATE 'SELECT ' || p_seq_name || '.NEXTVAL FROM DUAL'
                INTO l_val;

            EXECUTE IMMEDIATE
                'ALTER SEQUENCE ' || p_seq_name || ' INCREMENT BY 1';
        END IF;
    ELSE
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || p_seq_name;

        EXECUTE IMMEDIATE
            'CREATE SEQUENCE ' || p_seq_name || ' INCREMENT BY 1
        START WITH 1';
    END IF;
END;
/