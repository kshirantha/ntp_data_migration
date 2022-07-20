DECLARE
    l_trading_inst_restric_id   NUMBER;
    l_sqlerrm                   VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (u16_id), 0)
      INTO l_trading_inst_restric_id
      FROM dfn_ntp.u16_trading_instrument_restric;

    DELETE FROM error_log
          WHERE mig_table = 'U16_TRADING_INSTRUMENT_RESTRIC';

    FOR i
        IN (SELECT u07_map.new_trading_account_id,
                   v09.v09_id,
                   u16.u16_id,
                   u16.u16_restriction_id_v31,
                   NVL (map16.map16_ntp_code, u10.u10_exchange) AS exchange
              FROM mubasher_oms.u10_restricted_instrmnt_types@mubasher_db_link u10,
                   dfn_ntp.v09_instrument_types v09,
                   map16_optional_exchanges_m01 map16,
                   u07_trading_account_mappings u07_map,
                   dfn_ntp.u16_trading_instrument_restric u16
             WHERE     u10.u10_instrument_type_id = v09.v09_code(+)
                   AND u10.u10_security_ac_id =
                           u07_map.old_trading_account_id
                   AND u10.u10_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, u10.u10_exchange) =
                           u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id =
                           u16_trd_acnt_id_u07(+)
                   AND v09.v09_id = u16_instrument_id_v09(+))
    LOOP
        BEGIN
            IF i.exchange IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.v09_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Invalid Instrument Type',
                                         TRUE);
            END IF;

            IF    i.u16_id IS NULL
               OR (    i.u16_id IS NULL
                   AND i.u16_restriction_id_v31 NOT IN (14, 15))
            THEN
                l_trading_inst_restric_id := l_trading_inst_restric_id + 1;

                INSERT
                  INTO dfn_ntp.u16_trading_instrument_restric (
                           u16_id,
                           u16_trd_acnt_id_u07,
                           u16_restriction_id_v31,
                           u16_instrument_id_v09,
                           u16_custom_type)
                VALUES (l_trading_inst_restric_id, -- u16_id
                        i.new_trading_account_id, -- u16_trd_acnt_id_u07
                        14, -- u16_restriction_id_v31 | 14 - Buy
                        i.v09_id, -- u16_instrument_id_v09
                        '1' -- u16_custom_type
                           );

                l_trading_inst_restric_id := l_trading_inst_restric_id + 1;

                INSERT
                  INTO dfn_ntp.u16_trading_instrument_restric (
                           u16_id,
                           u16_trd_acnt_id_u07,
                           u16_restriction_id_v31,
                           u16_instrument_id_v09,
                           u16_custom_type)
                VALUES (l_trading_inst_restric_id, --u16_id
                        i.new_trading_account_id, -- u16_trd_acnt_id_u07
                        15, -- u16_restriction_id_v31 | 15 - Sell
                        i.v09_id, -- u16_instrument_id_v09
                        '1' -- u16_custom_type
                           );
            ELSE
                UPDATE dfn_ntp.u16_trading_instrument_restric
                   SET u16_restriction_id_v31 = 15 -- u16_restriction_id_v31 | 15 - Sell
                 WHERE u16_id = i.u16_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U16_TRADING_INSTRUMENT_RESTRIC',
                                   'Trading Account : '
                                || i.new_trading_account_id
                                || ' Instrument : '
                                || i.v09_id,
                                CASE
                                    WHEN    i.u16_id IS NULL
                                         OR (    i.u16_id IS NULL
                                             AND i.u16_restriction_id_v31 NOT IN
                                                     (14, 15))
                                    THEN
                                        l_trading_inst_restric_id
                                    ELSE
                                        i.u16_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN    i.u16_id IS NULL
                                         OR (    i.u16_id IS NULL
                                             AND i.u16_restriction_id_v31 NOT IN
                                                     (14, 15))
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