DECLARE
    l_broker_id                     NUMBER;
    l_primary_institute_id          NUMBER;
    l_market_maker_grps_detail_id   NUMBER;
    l_sqlerrm                       VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (m132_id), 0)
      INTO l_market_maker_grps_detail_id
      FROM dfn_ntp.m132_market_maker_grp_details;

    DELETE FROM error_log
          WHERE mig_table = 'M132_MARKET_MAKER_GRP_DETAILS';

    FOR i
        IN (SELECT m349.m349_id,
                   m131_map.new_market_maker_grp_id,
                   NVL (map16.map16_ntp_code, m349.m349_exchange) AS exchange,
                   m349.m349_symbol,
                   m349.m349_trader_id,
                   NVL (u17_created_by.new_employee_id, 0)
                       AS created_by_new_id,
                   NVL (m349.m349_created_date, SYSDATE) AS created_date,
                   m131_map.new_institute_id,
                   m01.m01_id,
                   m20.m20_id,
                   m132_map.new_mkt_maker_detail_id
              FROM mubasher_oms.m349_market_maker_details@mubasher_db_link m349,
                   m131_market_maker_grp_mappings m131_map,
                   (SELECT m20_id, m20_symbol_code, m20_exchange_code_m01
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   map16_optional_exchanges_m01 map16,
                   u17_employee_mappings u17_created_by,
                   m132_mkt_maker_detail_mappings m132_map
             WHERE     m349.m349_market_maker =
                           m131_map.old_market_maker_grp_id
                   AND m349.m349_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, m349.m349_exchange) =
                           m01.m01_exchange_code(+)
                   AND m349.m349_symbol = m20.m20_symbol_code(+)
                   AND NVL (map16.map16_ntp_code, m349.m349_exchange) =
                           m20.m20_exchange_code_m01(+)
                   AND m349.m349_created_by =
                           u17_created_by.old_employee_id(+)
                   AND m349.m349_id = m132_map.old_mkt_maker_detail_id(+)
                   AND m131_map.new_institute_id =
                           m132_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.new_mkt_maker_detail_id IS NULL
            THEN
                l_market_maker_grps_detail_id :=
                    l_market_maker_grps_detail_id + 1;

                INSERT
                  INTO dfn_ntp.m132_market_maker_grp_details (
                           m132_id,
                           m132_market_maker_grp_id_m131,
                           m132_exchange_id_m01,
                           m132_exchange_code_m01,
                           m132_symbol_id_m20,
                           m132_symbol_code_m20,
                           m132_trader_id,
                           m132_created_by_id_u17,
                           m132_created_date,
                           m132_modified_by_id_u17,
                           m132_modified_date,
                           m132_custom_type)
                VALUES (l_market_maker_grps_detail_id, -- m132_id
                        i.new_market_maker_grp_id, -- m132_market_maker_grp_id_m131
                        i.m01_id, -- m132_exchange_id_m01
                        i.exchange, -- m132_exchange_code_m01
                        i.m20_id, -- m132_symbol_id_m20
                        i.m349_symbol, -- m132_symbol_code_m20
                        i.m349_trader_id, -- m132_trader_id
                        i.created_by_new_id, -- m132_created_by_id_u17
                        i.created_date, -- m132_created_date
                        NULL, -- m132_modified_by_id_u17
                        NULL, -- m132_modified_date
                        '1' -- m132_custom_type
                           );

                INSERT
                  INTO m132_mkt_maker_detail_mappings (
                           old_mkt_maker_detail_id,
                           new_mkt_maker_detail_id,
                           new_institute_id)
                VALUES (
                           i.m349_id,
                           l_market_maker_grps_detail_id,
                           i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m132_market_maker_grp_details
                   SET m132_market_maker_grp_id_m131 =
                           i.new_market_maker_grp_id, -- m132_market_maker_grp_id_m131
                       m132_exchange_id_m01 = i.m01_id, -- m132_exchange_id_m01
                       m132_exchange_code_m01 = i.exchange, -- m132_exchange_code_m01
                       m132_symbol_id_m20 = i.m20_id, -- m132_symbol_id_m20
                       m132_symbol_code_m20 = i.m349_symbol, -- m132_symbol_code_m20
                       m132_trader_id = i.m349_trader_id, -- m132_trader_id
                       m132_modified_by_id_u17 = 0, -- m132_modified_by_id_u17
                       m132_modified_date = SYSDATE -- m132_modified_date
                 WHERE m132_id = i.new_mkt_maker_detail_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M132_MARKET_MAKER_GRP_DETAILS',
                                i.m349_id,
                                CASE
                                    WHEN i.new_mkt_maker_detail_id IS NULL
                                    THEN
                                        l_market_maker_grps_detail_id
                                    ELSE
                                        i.new_mkt_maker_detail_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_mkt_maker_detail_id IS NULL
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