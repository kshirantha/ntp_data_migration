DECLARE
    l_broker_id                NUMBER;
    l_primary_institute_id     NUMBER;
    l_exg_instrument_type_id   NUMBER;
    l_sqlerrm                  VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (m125_id), 0)
      INTO l_exg_instrument_type_id
      FROM dfn_ntp.m125_exchange_instrument_type;

    DELETE FROM error_log
          WHERE mig_table = 'M125_EXCHANGE_INSTRUMENT_TYPE';

    FOR i
        IN (SELECT m291_id,
                   NVL (map16.map16_ntp_code, m291.m291_exchange) AS exchange,
                   m01.m01_id,
                   v09.v09_id,
                   v09.v09_code,
                   NVL (u17_created_by.new_employee_id, 0)
                       AS created_by_new_id,
                   NVL (m291_created_date, SYSDATE) AS created_date,
                   u17_modified_by.new_employee_id AS modified_by_new_id,
                   m291_modified_date AS modified_date,
                   m291_is_subscription_allowed,
                   m291_allow_sell_unsettle_hold,
                   m11.m11_subscription_start_time,
                   m11.m11_subscription_end_time,
                   m125_map.new_exg_inst_type_id
              FROM mubasher_oms.m291_exchange_instrument_type@mubasher_db_link m291,
                   mubasher_oms.m11_exchanges@mubasher_db_link m11,
                   dfn_ntp.v09_instrument_types v09,
                   map16_optional_exchanges_m01 map16,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   u17_employee_mappings u17_created_by,
                   u17_employee_mappings u17_modified_by,
                   m125_exg_inst_type_mappings m125_map
             WHERE     m291.m291_exchange = m11.m11_exchangecode
                   AND m291.m291_instrument_type = v09.v09_code(+)
                   AND m11.m11_exchangecode = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, m291.m291_exchange) =
                           m01.m01_exchange_code(+)
                   AND m291.m291_created_by =
                           u17_created_by.old_employee_id(+)
                   AND m291.m291_modified_by =
                           u17_modified_by.old_employee_id(+)
                   AND m291.m291_id = m125_map.old_exg_inst_type_id(+))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.v09_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Instrument Type Not Available',
                                         TRUE);
            END IF;

            IF i.new_exg_inst_type_id IS NULL
            THEN
                l_exg_instrument_type_id := l_exg_instrument_type_id + 1;

                INSERT
                  INTO dfn_ntp.m125_exchange_instrument_type (
                           m125_id,
                           m125_exchange_code_m01,
                           m125_exchange_id_m01,
                           m125_instrument_type_id_v09,
                           m125_min_broker_commission,
                           m125_is_online,
                           m125_created_by_id_u17,
                           m125_created_date,
                           m125_modified_by_id_u17,
                           m125_modified_date,
                           m125_is_subscription_allowed,
                           m125_allow_sell_unsettle_hold,
                           m125_subscription_start_time,
                           m125_subscription_end_time,
                           m125_instrument_type_code_v09,
                           m125_custom_type,
                           m125_board_code_m54,
                           m125_board_id_m54)
                VALUES (l_exg_instrument_type_id, -- m125_id
                        i.exchange, -- m125_exchange_code_m01
                        i.m01_id, -- m125_exchange_id_m01
                        i.v09_id, -- m125_instrument_type_id_v09
                        NULL, -- m125_min_broker_commission | Not Available
                        0, -- m125_is_online | Not Available
                        i.created_by_new_id, -- m125_created_by_id_u17
                        i.created_date, -- m125_created_date
                        i.modified_by_new_id, -- m125_modified_by_id_u17
                        i.modified_date, -- m125_modified_date
                        i.m291_is_subscription_allowed, -- m125_is_subscription_allowed
                        i.m291_allow_sell_unsettle_hold, -- m125_allow_sell_unsettle_hold
                        i.m11_subscription_start_time, -- m125_subscription_start_time
                        i.m11_subscription_end_time, -- m125_subscription_end_time
                        i.v09_code, -- m125_instrument_type_code_v09
                        '1', -- m125_custom_type
                        NULL, -- m125_board_code_m54 | Not Available (PTTP)
                        NULL -- m125_board_id_m54 | Not Available (PTTP)
                            );

                INSERT INTO m125_exg_inst_type_mappings
                     VALUES (i.m291_id, l_exg_instrument_type_id);
            ELSE
                UPDATE dfn_ntp.m125_exchange_instrument_type
                   SET m125_exchange_code_m01 = i.exchange, -- m125_exchange_code_m01
                       m125_exchange_id_m01 = i.m01_id, -- m125_exchange_id_m01
                       m125_instrument_type_id_v09 = i.v09_id, -- m125_instrument_type_id_v09
                       m125_modified_by_id_u17 = NVL (i.modified_by_new_id, 0), -- m125_modified_by_id_u17
                       m125_modified_date = NVL (i.modified_date, SYSDATE), -- m125_modified_date
                       m125_is_subscription_allowed =
                           i.m291_is_subscription_allowed, -- m125_is_subscription_allowed
                       m125_allow_sell_unsettle_hold =
                           i.m291_allow_sell_unsettle_hold, -- m125_allow_sell_unsettle_hold
                       m125_subscription_start_time =
                           i.m11_subscription_start_time, -- m125_subscription_start_time
                       m125_subscription_end_time =
                           i.m11_subscription_end_time, -- m125_subscription_end_time
                       m125_instrument_type_code_v09 = i.v09_code -- m125_instrument_type_code_v09
                 WHERE m125_id = i.new_exg_inst_type_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M125_EXCHANGE_INSTRUMENT_TYPE',
                                i.m291_id,
                                CASE
                                    WHEN i.new_exg_inst_type_id IS NULL
                                    THEN
                                        l_exg_instrument_type_id
                                    ELSE
                                        i.new_exg_inst_type_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_exg_inst_type_id IS NULL
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