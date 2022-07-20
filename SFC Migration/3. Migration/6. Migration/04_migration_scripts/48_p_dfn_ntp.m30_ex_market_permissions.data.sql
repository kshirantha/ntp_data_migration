DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_market_permission_id   NUMBER;
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

    SELECT NVL (MAX (m30_id), 0)
      INTO l_market_permission_id
      FROM dfn_ntp.m30_ex_market_permissions;

    DELETE FROM error_log
          WHERE mig_table = 'M30_EX_MARKET_PERMISSIONS';

    FOR i
        IN (SELECT m115.m115_market_code,
                   v19.v19_id,
                   NVL (map16.map16_ntp_code, m115.m115_exchange) AS exchange,
                   m166.m166_id,
                   m01.m01_id,
                   m59_map.new_exg_mkt_status_id,
                   m30_map.new_ex_mkt_permission_id
              FROM mubasher_oms.m115_sub_markets@mubasher_db_link m115,
                   mubasher_oms.m166_exchange_market_status@mubasher_db_link m166,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   map16_optional_exchanges_m01 map16,
                   dfn_ntp.v19_market_status v19,
                   m59_exg_mkt_status_mappings m59_map,
                   m30_ex_mkt_permission_mappings m30_map
             WHERE     m115_exchange = m166.m166_exchange
                   AND m166.m166_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, m115.m115_exchange) =
                           m01.m01_exchange_code(+)
                   AND m166.m166_market_status = v19.v19_price_mapping_id(+)
                   AND m166.m166_id = m59_map.old_exg_mkt_status_id
                   -- AND m115.m115_is_default = 1 -- Since DT Couldn't Filter Out Other Sub Markets Above Tempory Solution is Requested from Onsite to Take only the Default Market
                   AND m166.m166_id = m30_map.old_ex_mkt_permission_id(+))
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
                                         'Market Status Invalid',
                                         TRUE);
            END IF;

            IF i.new_ex_mkt_permission_id IS NULL
            THEN
                l_market_permission_id := l_market_permission_id + 1;

                INSERT
                  INTO dfn_ntp.m30_ex_market_permissions (
                           m30_market_code_m29,
                           m30_market_status_id_v19,
                           m30_exchange_code_m01,
                           m30_id,
                           m30_cancel_order_allowed,
                           m30_amend_order_allowed,
                           m30_create_order_allowed,
                           m30_exchange_id_m01,
                           m30_exchange_status_id_m59,
                           m30_custom_type)
                VALUES (i.m115_market_code, -- m30_market_code_m29
                        i.v19_id, -- m30_market_status_id_v19
                        i.exchange, -- m30_exchange_code_m01
                        l_market_permission_id, -- m30_id
                        1, -- m30_cancel_order_allowed
                        1, -- m30_amend_order_allowed
                        1, -- m30_create_order_allowed
                        i.m01_id, -- m30_exchange_id_m01
                        i.new_exg_mkt_status_id, -- m30_exchange_status_id_m59
                        '1' -- m30_custom_type
                           );

                INSERT INTO m30_ex_mkt_permission_mappings
                     VALUES (i.m166_id, l_market_permission_id);
            ELSE
                UPDATE dfn_ntp.m30_ex_market_permissions
                   SET m30_market_code_m29 = i.m115_market_code, -- m30_market_code_m29
                       m30_market_status_id_v19 = i.v19_id, -- m30_market_status_id_v19
                       m30_exchange_code_m01 = i.exchange, -- m30_exchange_code_m01
                       m30_exchange_id_m01 = i.m01_id, -- m30_exchange_id_m01
                       m30_exchange_status_id_m59 = i.new_exg_mkt_status_id -- m30_exchange_status_id_m59
                 WHERE m30_id = i.new_ex_mkt_permission_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M30_EX_MARKET_PERMISSIONS',
                                i.m166_id,
                                CASE
                                    WHEN i.new_ex_mkt_permission_id IS NULL
                                    THEN
                                        l_market_permission_id
                                    ELSE
                                        i.new_ex_mkt_permission_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_ex_mkt_permission_id IS NULL
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