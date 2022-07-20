DECLARE
    l_exec_broker_exchange_id   NUMBER;
    l_broker_id                 NUMBER;
    l_primary_institute_id      NUMBER;
    l_sqlerrm                   VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (m87_id), 0)
      INTO l_exec_broker_exchange_id
      FROM dfn_ntp.m87_exec_broker_exchange;

    DELETE FROM error_log
          WHERE mig_table = 'M87_EXEC_BROKER_EXCHANGE';

    FOR i
        IN (SELECT ex02.ex02_id,
                   ex02.ex02_executing_institution,
                   m26_map.new_executing_broker_id,
                   NVL (map16.map16_ntp_code, ex02.ex02_exchange) AS exchange,
                   CASE
                       WHEN    NVL (ex02.ex02_fix_tag_22,
                                    ex01.ex01_fix_tag_22) = '4'
                            OR NVL (ex02.ex02_fix_tag_22,
                                    ex01.ex01_fix_tag_22) LIKE
                                   '%ISIN%'
                       THEN
                           1 -- ISIN
                       WHEN    NVL (ex02.ex02_fix_tag_22,
                                    ex01.ex01_fix_tag_22) = '5'
                            OR NVL (ex02.ex02_fix_tag_22,
                                    ex01.ex01_fix_tag_22) LIKE
                                   '%RIC%'
                       THEN
                           2 -- RIC
                       ELSE
                           3 -- Exchange Symbol
                   END
                       AS fix_tag_22,
                   NVL (ex02.ex02_fix_tag_100, ex01.ex01_fix_tag_100)
                       AS fix_tag_100,
                   ex01.ex01_fix_tag_50,
                   ex01.ex01_fix_tag_142,
                   ex01.ex01_fix_tag_57,
                   ex01.ex01_fix_tag_115,
                   ex01.ex01_fix_tag_116,
                   ex01.ex01_fix_tag_128,
                   ex01.ex01_fix_tag_109,
                   m01.m01_id,
                   m87_map.new_exec_broker_exg_id
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
                       ON NVL (map16.map16_ntp_code, ex02.ex02_exchange) =
                              m01.m01_exchange_code
                   LEFT JOIN m87_exec_broker_exg_mappings m87_map
                       ON ex02.ex02_id = m87_map.old_exec_broker_exg_id
             WHERE ex01.ex01_type IN (1, 2, 4))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.new_exec_broker_exg_id IS NULL
            THEN
                l_exec_broker_exchange_id := l_exec_broker_exchange_id + 1;

                INSERT
                  INTO dfn_ntp.m87_exec_broker_exchange (
                           m87_id,
                           m87_exec_broker_id_m26,
                           m87_exchange_code_m01,
                           m87_exchange_id_m01,
                           m87_fix_tag_50,
                           m87_fix_tag_142,
                           m87_fix_tag_57,
                           m87_fix_tag_115,
                           m87_fix_tag_116,
                           m87_fix_tag_128,
                           m87_fix_tag_22,
                           m87_fix_tag_109,
                           m87_fix_tag_100,
                           m87_custom_type)
                VALUES (l_exec_broker_exchange_id, -- m87_id
                        i.new_executing_broker_id, -- m87_exec_broker_id_m26
                        i.exchange, -- m87_exchange_code_m01
                        i.m01_id, -- m87_exchange_id_m01
                        i.ex01_fix_tag_50, -- m87_fix_tag_50
                        i.ex01_fix_tag_142, -- m87_fix_tag_142
                        i.ex01_fix_tag_57, -- m87_fix_tag_57
                        i.ex01_fix_tag_115, -- m87_fix_tag_115
                        i.ex01_fix_tag_116, -- m87_fix_tag_116
                        i.ex01_fix_tag_128, -- m87_fix_tag_128
                        i.fix_tag_22, -- m87_fix_tag_22
                        i.ex01_fix_tag_109, -- m87_fix_tag_109
                        i.fix_tag_100, -- m87_fix_tag_100
                        '1' -- m87_custom_type
                           );

                INSERT INTO m87_exec_broker_exg_mappings
                     VALUES (i.ex02_id, l_exec_broker_exchange_id);
            ELSE
                UPDATE dfn_ntp.m87_exec_broker_exchange
                   SET m87_exec_broker_id_m26 = i.new_executing_broker_id, -- m87_exec_broker_id_m26
                       m87_exchange_code_m01 = i.exchange, -- m87_exchange_code_m01
                       m87_exchange_id_m01 = i.m01_id, -- m87_exchange_id_m01
                       m87_fix_tag_50 = i.ex01_fix_tag_50, -- m87_fix_tag_50
                       m87_fix_tag_142 = i.ex01_fix_tag_142, -- m87_fix_tag_142
                       m87_fix_tag_57 = i.ex01_fix_tag_57, -- m87_fix_tag_57
                       m87_fix_tag_115 = i.ex01_fix_tag_115, -- m87_fix_tag_115
                       m87_fix_tag_116 = i.ex01_fix_tag_116, -- m87_fix_tag_116
                       m87_fix_tag_128 = i.ex01_fix_tag_128, -- m87_fix_tag_128
                       m87_fix_tag_22 = i.fix_tag_22, -- m87_fix_tag_22
                       m87_fix_tag_109 = i.ex01_fix_tag_109, -- m87_fix_tag_109
                       m87_fix_tag_100 = i.fix_tag_100 -- m87_fix_tag_100
                 WHERE m87_id = i.new_exec_broker_exg_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M87_EXEC_BROKER_EXCHANGE',
                                i.ex02_id,
                                CASE
                                    WHEN i.new_exec_broker_exg_id IS NULL
                                    THEN
                                        l_exec_broker_exchange_id
                                    ELSE
                                        i.new_exec_broker_exg_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_exec_broker_exg_id IS NULL
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