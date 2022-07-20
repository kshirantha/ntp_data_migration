CREATE OR REPLACE PROCEDURE dfn_ntp.get_custody_exchange (
    p_view                       OUT SYS_REFCURSOR,
    prows                        OUT NUMBER,
    pm70_exec_broker_id_m26   IN     VARCHAR2,
    p_institiute_id           IN     NUMBER DEFAULT 1)
IS
    status   NUMBER;
BEGIN
    status := 0;

    OPEN p_view FOR
          SELECT m01.m01_exchange_code AS m70_exchange_code_m01,
                 m01.m01_id AS m70_exchange_id_m01,
                 m70.m70_id,
                 CASE WHEN m70.m70_id IS NULL THEN 0 ELSE 1 END AS enabled,
                 m01.m01_institute_id_m02
            FROM     m01_exchanges m01
                 LEFT JOIN
                     (SELECT *
                        FROM m70_custody_exchanges m70
                       WHERE m70_exec_broker_id_m26 = pm70_exec_broker_id_m26) m70
                 ON m01.m01_id = m70.m70_exchange_id_m01
           WHERE m01.m01_institute_id_m02 = p_institiute_id
        ORDER BY m70_exchange_code_m01;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        status := -2;
    WHEN OTHERS
    THEN
        status := -3;
END;
/

