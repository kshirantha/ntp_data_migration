DECLARE
    l_broker_id                   NUMBER;
    l_primary_institute_id        NUMBER;
    l_trading_sym_restrictio_id   NUMBER;
    l_sqlerrm                     VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (u14_id), 0)
      INTO l_trading_sym_restrictio_id
      FROM dfn_ntp.u14_trading_symbol_restriction;

    DELETE FROM error_log
          WHERE mig_table = 'U14_TRADING_SYMBOL_RESTRICTION';

    FOR i
        IN (SELECT u07_map.new_trading_account_id,
                   restriction.u08_security_ac_id,
                   restriction.m20_id,
                   restriction.m20_symbol_code,
                   restriction.restriction,
                   u14.u14_id,
                   restriction.exchange_code
              FROM (SELECT u08.u08_security_ac_id,
                           NVL (map16.map16_ntp_code, u08.u08_exchangecode)
                               AS exchange_code,
                           m20.m20_id,
                           m20.m20_symbol_code,
                           12 AS restriction -- 12 - Buy
                      FROM mubasher_oms.u08_restricted_symbols@mubasher_db_link u08,
                           (SELECT m20_id,
                                   m20_symbol_code,
                                   m20_exchange_id_m01,
                                   m20_exchange_code_m01
                              FROM dfn_ntp.m20_symbol
                             WHERE m20_institute_id_m02 =
                                       l_primary_institute_id) m20,
                           (SELECT m01_id, m01_exchange_code
                              FROM dfn_ntp.m01_exchanges
                             WHERE m01_institute_id_m02 =
                                       l_primary_institute_id) m01,
                           map16_optional_exchanges_m01 map16
                     WHERE     u08_type IN (1, 3) -- Buy
                           AND u08_restricted = 1
                           AND m01.m01_id = m20.m20_exchange_id_m01
                           AND u08.u08_exchangecode = map16.map16_oms_code(+)
                           AND NVL (map16.map16_ntp_code,
                                    u08.u08_exchangecode) =
                                   m01.m01_exchange_code(+)
                           AND u08.u08_symbol = m20.m20_symbol_code
                           AND NVL (map16.map16_ntp_code,
                                    u08.u08_exchangecode) =
                                   m20.m20_exchange_code_m01(+)
                    UNION ALL
                    SELECT u08.u08_security_ac_id,
                           NVL (map16.map16_ntp_code, u08.u08_exchangecode)
                               AS exchange_code,
                           m20.m20_id,
                           m20.m20_symbol_code,
                           13 AS restriction -- 13 - Sell
                      FROM mubasher_oms.u08_restricted_symbols@mubasher_db_link u08,
                           (SELECT m20_id,
                                   m20_symbol_code,
                                   m20_exchange_id_m01,
                                   m20_exchange_code_m01
                              FROM dfn_ntp.m20_symbol
                             WHERE m20_institute_id_m02 =
                                       l_primary_institute_id) m20,
                           (SELECT m01_id, m01_exchange_code
                              FROM dfn_ntp.m01_exchanges
                             WHERE m01_institute_id_m02 =
                                       l_primary_institute_id) m01,
                           map16_optional_exchanges_m01 map16
                     WHERE     u08_type IN (2, 3) -- Sell
                           AND u08_restricted = 1
                           AND m01.m01_id = m20.m20_exchange_id_m01
                           AND u08.u08_exchangecode = map16.map16_oms_code(+)
                           AND NVL (map16.map16_ntp_code,
                                    u08.u08_exchangecode) =
                                   m01.m01_exchange_code(+)
                           AND u08.u08_symbol = m20.m20_symbol_code
                           AND NVL (map16.map16_ntp_code,
                                    u08.u08_exchangecode) =
                                   m20.m20_exchange_code_m01(+)) restriction,
                   u07_trading_account_mappings u07_map,
                   dfn_ntp.u14_trading_symbol_restriction u14
             WHERE     restriction.u08_security_ac_id =
                           u07_map.old_trading_account_id(+)
                   AND restriction.exchange_code = u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id =
                           u14.u14_trd_acnt_id_u07(+)
                   AND restriction.m20_id = u14.u14_symbol_id_m20(+)
                   AND restriction.restriction =
                           u14.u14_restriction_id_v31(+))
    LOOP
        BEGIN
            IF i.exchange_code IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.new_trading_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Security Account Not Available',
                                         TRUE);
            END IF;

            IF i.u14_id IS NULL
            THEN
                l_trading_sym_restrictio_id := l_trading_sym_restrictio_id + 1;

                INSERT
                  INTO dfn_ntp.u14_trading_symbol_restriction (
                           u14_id,
                           u14_trd_acnt_id_u07,
                           u14_symbol_id_m20,
                           u14_restriction_id_v31,
                           u14_custom_type)
                VALUES (l_trading_sym_restrictio_id, -- u14_id
                        i.new_trading_account_id, -- u14_trd_acnt_id_u07
                        i.m20_id, -- u14_symbol_id_m20
                        i.restriction, -- u14_restriction_id_v31
                        '1' -- u14_custom_type
                           );
            ELSE
                NULL; -- Nothing to Update.
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U14_TRADING_SYMBOL_RESTRICTION',
                                   'Trading Account : '
                                || i.u08_security_ac_id
                                || ' | Symbol : '
                                || i.m20_symbol_code
                                || ' | Restriction : '
                                || i.restriction,
                                CASE
                                    WHEN i.u14_id IS NULL
                                    THEN
                                        l_trading_sym_restrictio_id
                                    ELSE
                                        i.u14_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.u14_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
