DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_exg_tick_sizes_id      NUMBER;
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

    SELECT NVL (MAX (m122_id), 0)
      INTO l_exg_tick_sizes_id
      FROM dfn_ntp.m122_exchange_tick_sizes;

    DELETE FROM error_log
          WHERE mig_table = 'M122_EXCHANGE_TICK_SIZES';

    FOR i
        IN (SELECT m155_id,
                   m01_id,
                   NVL (map16.map16_ntp_code, m155.m155_exchange) AS exchange,
                   m155_range_low,
                   m155_range_high,
                   m155_price_unit,
                   m155_currency,
                   m03_id,
                   v34.v34_inst_id_v09,
                   m155_instrument_type,
                   m122_map.new_exg_tick_sizes_id
              FROM mubasher_oms.m155_exchange_tick_sizes@mubasher_db_link m155,
                   map16_optional_exchanges_m01 map16,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   dfn_ntp.m03_currency m03,
                   dfn_ntp.v34_price_instrument_type v34,
                   m122_exg_tick_sizes_mappings m122_map
             WHERE     m155.m155_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, m155.m155_exchange) =
                           m01.m01_exchange_code(+)
                   AND m155.m155_currency = m03.m03_code
                   AND m155.m155_instrument_type = v34.v34_price_inst_type_id
                   AND m155.m155_id = m122_map.old_exg_tick_sizes_id(+))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.new_exg_tick_sizes_id IS NULL
            THEN
                l_exg_tick_sizes_id := l_exg_tick_sizes_id + 1;

                INSERT
                  INTO dfn_ntp.m122_exchange_tick_sizes (
                           m122_id,
                           m122_exchange_id_m01,
                           m122_exchange_code_m01,
                           m122_range_low,
                           m122_range_high,
                           m122_price_unit,
                           m122_currency_code_m03,
                           m122_currency_id_m03,
                           m122_instrument_type_id_v09,
                           m122_created_by_id_u17,
                           m122_created_date,
                           m122_modified_by_id_u17,
                           m122_modified_date,
                           m122_status_id_v01,
                           m122_status_changed_by_id_u17,
                           m122_status_changed_date,
                           m122_instrument_type_code_v09,
                           m122_custom_type)
                VALUES (l_exg_tick_sizes_id, -- m122_id
                        i.m01_id, --  m122_exchange_id_m01
                        i.exchange, --  m122_exchange_code_m01
                        i.m155_range_low, --  m122_range_low
                        i.m155_range_high, --  m122_range_high
                        i.m155_price_unit, --  m122_price_unit
                        i.m155_currency, --  m122_currency_code_m03
                        i.m03_id, --  m122_currency_id_m03
                        i.v34_inst_id_v09, -- m122_instrument_type_id_v09
                        0, -- m122_created_by_id_u17 | Not Available
                        SYSDATE, -- m122_created_date | Not Available
                        NULL, -- m122_modified_by_id_u17 | Not Available
                        NULL, -- m122_modified_date | Not Available
                        2, -- m122_status_id_v01 | Not Available
                        0, -- m122_status_changed_by_id_u17 | Not Available
                        SYSDATE, -- m122_status_changed_date | Not Available
                        i.m155_instrument_type, -- m122_instrument_type_code_v09
                        '1' -- m122_custom_type
                           );

                INSERT INTO m122_exg_tick_sizes_mappings
                     VALUES (i.m155_id, l_exg_tick_sizes_id);
            ELSE
                UPDATE dfn_ntp.m122_exchange_tick_sizes
                   SET m122_exchange_id_m01 = i.m01_id, --  m122_exchange_id_m01
                       m122_exchange_code_m01 = i.exchange, --  m122_exchange_code_m01
                       m122_range_low = i.m155_range_low, --  m122_range_low
                       m122_range_high = i.m155_range_high, --  m122_range_high
                       m122_price_unit = i.m155_price_unit, --  m122_price_unit
                       m122_currency_code_m03 = i.m155_currency, --  m122_currency_code_m03
                       m122_currency_id_m03 = i.m03_id, --  m122_currency_id_m03
                       m122_instrument_type_id_v09 = i.v34_inst_id_v09, -- m122_instrument_type_id_v09
                       m122_instrument_type_code_v09 = i.m155_instrument_type, -- m122_instrument_type_code_v09
                       m122_modified_by_id_u17 = 0, -- m122_modified_by_id_u17
                       m122_modified_date = SYSDATE -- m122_modified_date
                 WHERE m122_id = i.new_exg_tick_sizes_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M122_EXCHANGE_TICK_SIZES',
                                i.m155_id,
                                CASE
                                    WHEN i.new_exg_tick_sizes_id IS NULL
                                    THEN
                                        l_exg_tick_sizes_id
                                    ELSE
                                        i.new_exg_tick_sizes_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_exg_tick_sizes_id IS NULL
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