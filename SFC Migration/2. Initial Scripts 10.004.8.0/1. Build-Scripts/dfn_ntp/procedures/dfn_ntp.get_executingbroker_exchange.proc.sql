CREATE OR REPLACE PROCEDURE dfn_ntp.get_executingbroker_exchange (
    p_view                   OUT SYS_REFCURSOR,
    prows                    OUT NUMBER,
    pm87execbrokeridm26   IN     VARCHAR2,
    p_institiute_id       IN     NUMBER DEFAULT 1)
IS
    status   NUMBER;
BEGIN
    status := 0;

    OPEN p_view FOR
        SELECT m01.m01_exchange_code AS m87_exchange_code_m01,
               m01.m01_id AS m87_exchange_id_m01,
               m87.m87_id,
               m87.m87_exec_broker_id_m26,
               m87.m87_fix_tag_50,
               m87.m87_fix_tag_142,
               m87.m87_fix_tag_57,
               m87.m87_fix_tag_115,
               m87.m87_fix_tag_116,
               m87.m87_fix_tag_128,
               m87.m87_fix_tag_22,
               m87.m87_fix_tag_109,
               m87.m87_fix_tag_100,
               CASE WHEN m87.m87_id IS NULL THEN 0 ELSE 1 END AS enabled,
               CASE WHEN m87.m87_id IS NULL THEN '' ELSE 'Yes' END
                   AS enabled_text,
               m01.m01_institute_id_m02
          FROM     m01_exchanges m01
               LEFT JOIN
                   (SELECT *
                      FROM m87_exec_broker_exchange m87
                     WHERE m87_exec_broker_id_m26 = pm87execbrokeridm26) m87
               ON m01.m01_id = m87.m87_exchange_id_m01
         WHERE m01.m01_institute_id_m02 = p_institiute_id;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        status := -2;
    WHEN OTHERS
    THEN
        status := -3;
END;
/
