CREATE OR REPLACE FUNCTION dfn_ntp.key_value_splitter (p_text    VARCHAR2,
                                                       p_key     VARCHAR2)
    RETURN VARCHAR2
AS
    l_key_size   NUMBER;
    l_value      VARCHAR2 (4000);
BEGIN
    l_key_size := LENGTH (REPLACE (p_key, '"', ''));


    IF (REGEXP_COUNT (p_text,
                      p_key,
                      1,
                      'c') > 0)
    THEN
        l_value :=
            SUBSTR (
                p_text,
                (INSTR (p_text, p_key, 1)) + (l_key_size) + 3,
                (  INSTR (
                       SUBSTR (p_text,
                               (INSTR (p_text, p_key, 1)) + (l_key_size) + 3,
                               (4000)),
                       ',',
                       1)
                 - 1));


        RETURN REPLACE (
                   CASE WHEN l_value = 'null' THEN NULL ELSE l_value END,
                   '"',
                   '');
    ELSE
        RETURN 'String Index out of bounds exception';
    END IF;
END;
/