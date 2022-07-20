CREATE OR REPLACE FUNCTION dfn_ntp.string_splitter (p_splitter    VARCHAR2,
                                                    p_text        VARCHAR2,
                                                    p_index       NUMBER)
    RETURN VARCHAR2
AS
    l_spliited_string   VARCHAR2 (4000);
BEGIN
    IF (  REGEXP_COUNT (p_text,
                        p_splitter,
                        1,
                        'c')
        + 1 >= p_index)
    THEN
        l_spliited_string :=
            SUBSTR (p_text,
                    (CASE
                         WHEN p_index = 1
                         THEN
                             0
                         ELSE
                               INSTR (p_text,
                                      p_splitter,
                                      1,
                                      p_index - 1)
                             + 1
                     END)--,INSTR(P_TEXT,P_SPLITTER,1,P_INDEX) + ((CASE WHEN P_INDEX = 1 THEN 0 ELSE  -(INSTR(P_TEXT,P_SPLITTER,1,P_INDEX-1)) END )-1));
                    ,
                    (CASE
                         WHEN INSTR (p_text,
                                     p_splitter,
                                     1,
                                     p_index) = 0
                         THEN
                               LENGTH (p_text)
                             + (  (CASE
                                       WHEN p_index = 1
                                       THEN
                                           0
                                       ELSE
                                           - (INSTR (p_text,
                                                     p_splitter,
                                                     1,
                                                     1))
                                   END)
                                - 1)
                         ELSE
                             (  INSTR (p_text,
                                       p_splitter,
                                       1,
                                       p_index)
                              + (  (CASE
                                        WHEN p_index = 1
                                        THEN
                                            0
                                        ELSE
                                            - (INSTR (p_text,
                                                      p_splitter,
                                                      1,
                                                      p_index - 1))
                                    END)
                                 - 1))
                     END));

        RETURN l_spliited_string;
    ELSE
        RETURN 'String Index out of bounds exception';
    END IF;
END;
/
/
