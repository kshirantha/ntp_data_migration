DECLARE
    l_custody_exchange_id    NUMBER;
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m70_id), 0)
      INTO l_custody_exchange_id
      FROM dfn_ntp.m70_custody_exchanges;

    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    DELETE FROM error_log
          WHERE mig_table = 'M70_CUSTODY_EXCHANGES';

    FOR i IN (SELECT ex02.ex02_id,
                     m26_map.new_executing_broker_id,
                     NVL (map16_ntp_code, ex02.ex02_exchange) AS exchange,
                     m01.m01_id,
                     m70_map.new_custody_exchanges_id
                FROM mubasher_oms.ex02_executing_inst_exchanges@mubasher_db_link ex02
                     JOIN mubasher_oms.ex01_executing_institution@mubasher_db_link ex01
                         ON ex02.ex02_executing_institution = ex01.ex01_id
                     LEFT JOIN m26_executing_broker_mappings m26_map
                         ON ex02.ex02_executing_institution =
                                m26_map.old_executing_broker_id
                     LEFT JOIN map16_optional_exchanges_m01 map16
                         ON ex02.ex02_exchange = map16.map16_oms_code
                     LEFT JOIN (SELECT m01_id, m01_exchange_code
                                  FROM dfn_ntp.m01_exchanges
                                 WHERE m01_institute_id_m02 =
                                           l_primary_institute_id) m01
                         ON NVL (map16_ntp_code, ex02.ex02_exchange) =
                                m01.m01_exchange_code
                     LEFT JOIN m70_custody_exchanges_mappings m70_map
                         ON ex02.ex02_id = m70_map.old_custody_exchanges_id
               WHERE ex01.ex01_type IN (2, 3, 4))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.new_custody_exchanges_id IS NULL
            THEN
                l_custody_exchange_id := l_custody_exchange_id + 1;

                INSERT
                  INTO dfn_ntp.m70_custody_exchanges (m70_id,
                                                      m70_exec_broker_id_m26,
                                                      m70_exchange_code_m01,
                                                      m70_exchange_id_m01,
                                                      m70_custom_type)
                VALUES (l_custody_exchange_id, -- m70_id
                        i.new_executing_broker_id, -- m70_exec_broker_id_m26
                        i.exchange, -- m70_exchange_code_m01
                        i.m01_id, -- m70_exchange_id_m01
                        '1' -- m70_custom_type
                           );

                INSERT INTO m70_custody_exchanges_mappings
                     VALUES (i.ex02_id, l_custody_exchange_id);
            ELSE
                UPDATE dfn_ntp.m70_custody_exchanges
                   SET m70_exec_broker_id_m26 = i.new_executing_broker_id, -- m70_exec_broker_id_m26
                       m70_exchange_code_m01 = i.exchange, -- m70_exchange_code_m01
                       m70_exchange_id_m01 = i.m01_id -- m70_exchange_id_m01
                 WHERE m70_id = i.new_custody_exchanges_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M70_CUSTODY_EXCHANGES',
                                i.ex02_id,
                                CASE
                                    WHEN i.new_custody_exchanges_id IS NULL
                                    THEN
                                        l_custody_exchange_id
                                    ELSE
                                        i.new_custody_exchanges_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_custody_exchanges_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/