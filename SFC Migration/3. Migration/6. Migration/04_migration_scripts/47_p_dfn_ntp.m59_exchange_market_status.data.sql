DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_exg_market_status_id   NUMBER;
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

    SELECT NVL (MAX (m59_id), 0)
      INTO l_exg_market_status_id
      FROM dfn_ntp.m59_exchange_market_status;

    DELETE FROM error_log
          WHERE mig_table = 'M59_EXCHANGE_MARKET_STATUS';

    FOR i
        IN (SELECT m166.m166_id,
                   m01.m01_id,
                   v19.v19_id,
                   NVL (map16.map16_ntp_code, m166.m166_exchange) AS exchange,
                   m59_map.new_exg_mkt_status_id
              FROM mubasher_oms.m166_exchange_market_status@mubasher_db_link m166,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   map16_optional_exchanges_m01 map16,
                   dfn_ntp.v19_market_status v19,
                   m59_exg_mkt_status_mappings m59_map
             WHERE     m166.m166_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, m166.m166_exchange) =
                           m01.m01_exchange_code(+)
                   AND m166.m166_market_status = v19.v19_price_mapping_id(+)
                   AND m166.m166_id = m59_map.old_exg_mkt_status_id(+))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.v19_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Invalid Market Status',
                                         TRUE);
            END IF;

            IF i.new_exg_mkt_status_id IS NULL
            THEN
                l_exg_market_status_id := l_exg_market_status_id + 1;

                INSERT
                  INTO dfn_ntp.m59_exchange_market_status (
                           m59_id,
                           m59_exchange_id_m01,
                           m59_market_status_id_v19,
                           m59_exchange_code_m01,
                           m59_custom_type)
                VALUES (l_exg_market_status_id, -- m59_id
                        i.m01_id, -- m59_exchange_id_m01
                        i.v19_id, -- m59_market_status_id_v19
                        i.exchange, -- m59_exchange_code_m01
                        '1' -- m59_custom_type
                           );

                INSERT INTO m59_exg_mkt_status_mappings
                     VALUES (i.m166_id, l_exg_market_status_id);
            ELSE
                UPDATE dfn_ntp.m59_exchange_market_status
                   SET m59_exchange_id_m01 = i.m01_id, -- m59_exchange_id_m01
                       m59_market_status_id_v19 = i.v19_id, -- m59_market_status_id_v19
                       m59_exchange_code_m01 = i.exchange -- m59_exchange_code_m01
                 WHERE m59_id = i.new_exg_mkt_status_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M59_EXCHANGE_MARKET_STATUS',
                                i.m166_id,
                                CASE
                                    WHEN i.new_exg_mkt_status_id IS NULL
                                    THEN
                                        l_exg_market_status_id
                                    ELSE
                                        i.new_exg_mkt_status_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_exg_mkt_status_id IS NULL
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