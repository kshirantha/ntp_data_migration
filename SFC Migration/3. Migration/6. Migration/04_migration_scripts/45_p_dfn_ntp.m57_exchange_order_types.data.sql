DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_exg_order_id           NUMBER;
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

    SELECT NVL (MAX (m57_id), 0)
      INTO l_exg_order_id
      FROM dfn_ntp.m57_exchange_order_types;

    DELETE FROM error_log
          WHERE mig_table = 'M57_EXCHANGE_ORDER_TYPES';

    FOR i
        IN (SELECT m119_id,
                   m01_id,
                   v06.v06_id,
                   NVL (map16.map16_ntp_code, m119.m119_exchange) AS exchange,
                   m57_map.new_exg_order_types_id
              FROM mubasher_oms.m119_exchange_order_types@mubasher_db_link m119,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   dfn_ntp.v06_order_type v06,
                   map16_optional_exchanges_m01 map16,
                   m57_exg_order_types_mappings m57_map
             WHERE     m119.m119_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, m119.m119_exchange) =
                           m01.m01_exchange_code(+)
                   AND m119.m119_order_type = v06.v06_type_id
                   AND m119.m119_id = m57_map.old_exg_order_types_id(+))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.new_exg_order_types_id IS NULL
            THEN
                l_exg_order_id := l_exg_order_id + 1;

                INSERT
                  INTO dfn_ntp.m57_exchange_order_types (m57_id,
                                                         m57_exchange_id_m01,
                                                         m57_order_type_id_v06,
                                                         m57_exchange_code_m01,
                                                         m57_custom_type)
                VALUES (l_exg_order_id, -- m57_id
                        i.m01_id, -- m57_exchange_id_m01
                        i.v06_id, -- m57_order_type_id_v06
                        i.exchange, -- m57_exchange_code_m01
                        '1' -- m57_custom_type
                           );

                INSERT INTO m57_exg_order_types_mappings
                     VALUES (i.m119_id, l_exg_order_id);
            ELSE
                UPDATE dfn_ntp.m57_exchange_order_types
                   SET m57_exchange_id_m01 = i.m01_id, -- m57_exchange_id_m01
                       m57_order_type_id_v06 = i.v06_id, -- m57_order_type_id_v06
                       m57_exchange_code_m01 = i.exchange -- m57_exchange_code_m01
                 WHERE m57_id = i.new_exg_order_types_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M57_EXCHANGE_ORDER_TYPES',
                                i.m119_id,
                                CASE
                                    WHEN i.new_exg_order_types_id IS NULL
                                    THEN
                                        l_exg_order_id
                                    ELSE
                                        i.new_exg_order_types_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_exg_order_types_id IS NULL
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