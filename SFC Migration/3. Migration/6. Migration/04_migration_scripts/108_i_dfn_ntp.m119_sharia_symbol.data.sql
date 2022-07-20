DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_sharia_symbol_id       NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (m119_id), 0)
      INTO l_sharia_symbol_id
      FROM dfn_ntp.m119_sharia_symbol;

    DELETE FROM error_log
          WHERE mig_table = 'M119_SHARIA_SYMBOL';

    FOR i
        IN (SELECT m02_map.new_institute_id,
                   m01.m01_id,
                   NVL (map16.map16_ntp_code, u16.u16_exchange) AS exchange,
                   m20.m20_id,
                   u16.u16_symbol,
                   NVL (u17_created_by.new_employee_id, 0)
                       AS created_by_new_id,
                   NVL (u16_created_date, SYSDATE) AS created_date,
                   m120.m120_id,
                   u16.u16_inst_id,
                   m119.m119_id
              FROM mubasher_oms.u16_inst_sharia_symbols@mubasher_db_link u16,
                   m02_institute_mappings m02_map,
                   dfn_ntp.m120_sharia_compliant_group m120,
                   map16_optional_exchanges_m01 map16,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   (SELECT m20_id, m20_symbol_code, m20_exchange_code_m01
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20,
                   u17_employee_mappings u17_created_by,
                   dfn_ntp.m119_sharia_symbol m119
             WHERE     u16.u16_inst_id = m02_map.old_institute_id
                   AND m02_map.new_institute_id = m120.m120_institute_id_m02 -- Group is created for each institution and therefore selecting the group having same institution as sharia symbol
                   AND u16.u16_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, u16.u16_exchange) =
                           m01.m01_exchange_code(+)
                   AND u16.u16_symbol = m20.m20_symbol_code(+)
                   AND u16.u16_exchange = m20.m20_exchange_code_m01(+)
                   AND u16.u16_created_by = u17_created_by.old_employee_id(+)
                   AND m02_map.new_institute_id =
                           m119.m119_institute_id_m02(+)
                   AND m01.m01_id = m119.m119_exchange_id_m01(+)
                   AND m20.m20_id = m119.m119_symbol_id_m20(+))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.m20_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Symbol Not Available',
                                         TRUE);
            END IF;

            IF i.m119_id IS NULL
            THEN
                l_sharia_symbol_id := l_sharia_symbol_id + 1;

                INSERT
                  INTO dfn_ntp.m119_sharia_symbol (m119_id,
                                                   m119_institute_id_m02,
                                                   m119_exchange_id_m01,
                                                   m119_exchange_code_m01,
                                                   m119_symbol_id_m20,
                                                   m119_symbol_code_m20,
                                                   m119_created_by_id_u17,
                                                   m119_created_date,
                                                   m119_sharia_group_id_m120,
                                                   m119_custom_type)
                VALUES (l_sharia_symbol_id, -- m119_id
                        i.new_institute_id, -- m119_institute_id_m02
                        i.m01_id, -- m119_exchange_id_m01
                        i.exchange, -- m119_exchange_code_m01
                        i.m20_id, -- m119_symbol_id_m20
                        i.u16_symbol, -- m119_symbol_code_m20
                        i.created_by_new_id, -- m119_created_by_id_u17
                        i.created_date, -- m119_created_date
                        i.m120_id, -- m119_sharia_group_id_m120
                        '1' -- m119_custom_type
                           );
            ELSE
                UPDATE dfn_ntp.m119_sharia_symbol
                   SET m119_exchange_code_m01 = i.exchange, -- m119_exchange_code_m01
                       m119_symbol_code_m20 = i.u16_symbol, -- m119_symbol_code_m20
                       m119_sharia_group_id_m120 = i.m120_id -- m119_sharia_group_id_m120
                 WHERE m119_id = i.m119_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M119_SHARIA_SYMBOL',
                                   'Institution : '
                                || i.u16_inst_id
                                || ' | Exchnge : '
                                || i.exchange
                                || ' | Symbol : '
                                || i.u16_symbol,
                                CASE
                                    WHEN i.m119_id IS NULL
                                    THEN
                                        l_sharia_symbol_id
                                    ELSE
                                        i.m119_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.m119_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/