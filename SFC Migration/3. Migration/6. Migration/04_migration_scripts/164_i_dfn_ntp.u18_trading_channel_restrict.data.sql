DECLARE
    l_trading_channel_restrict_id   NUMBER;
    l_sqlerrm                       VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (u18_id), 0)
      INTO l_trading_channel_restrict_id
      FROM dfn_ntp.u18_trading_channel_restrict;

    DELETE FROM error_log
          WHERE mig_table = 'U18_TRADING_CHANNEL_RESTRICT';

    FOR i
        IN (SELECT u07_map.new_trading_account_id,
                   restriction.u18_restriction_id_v31,
                   restriction.u20_order_channel,
                   u18.u18_id,
                   NVL (map16.map16_ntp_code, u20_exchange) AS exchange
              FROM (SELECT u20.u20_security_ac_id,
                           16 AS u18_restriction_id_v31, -- 16 - Buy
                           CASE u20_order_channel
                               WHEN 2 THEN 26 -- TW OLD VERSION -> RIA NET
                               WHEN 3 THEN 12 -- DC OLD VERSION -> DT
                               ELSE u20_order_channel
                           END
                               AS u20_order_channel,
                           u20_exchange
                      FROM mubasher_oms.u20_restricted_channels@mubasher_db_link u20
                     WHERE u20_type IN (1, 3) -- Buy
                    UNION ALL
                    SELECT u20.u20_security_ac_id,
                           17 AS u18_restriction_id_v31, -- 17 - Sell
                           CASE u20_order_channel
                               WHEN 2 THEN 26 -- TW OLD VERSION -> RIA NET
                               WHEN 3 THEN 12 -- DC OLD VERSION -> DT
                               ELSE u20_order_channel
                           END
                               AS u20_order_channel,
                           u20_exchange
                      FROM mubasher_oms.u20_restricted_channels@mubasher_db_link u20
                     WHERE u20_type IN (2, 3) -- Sell
                                             ) restriction,
                   u07_trading_account_mappings u07_map,
                   map16_optional_exchanges_m01 map16,
                   dfn_ntp.u18_trading_channel_restrict u18
             WHERE     restriction.u20_security_ac_id =
                           u07_map.old_trading_account_id
                   AND u20_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, u20_exchange) =
                           u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id =
                           u18.u18_trd_acnt_id_u07(+)
                   AND restriction.u18_restriction_id_v31 =
                           u18.u18_restriction_id_v31(+)
                   AND restriction.u20_order_channel =
                           u18.u18_channel_id_v29(+))
    LOOP
        BEGIN
            IF i.exchange IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.u18_id IS NULL
            THEN
                l_trading_channel_restrict_id :=
                    l_trading_channel_restrict_id + 1;

                INSERT
                  INTO dfn_ntp.u18_trading_channel_restrict (
                           u18_id,
                           u18_trd_acnt_id_u07,
                           u18_restriction_id_v31,
                           u18_channel_id_v29,
                           u18_custom_type)
                VALUES (l_trading_channel_restrict_id, -- u18_id
                        i.new_trading_account_id, -- u18_trd_acnt_id_u07
                        i.u18_restriction_id_v31, -- u18_restriction_id_v31
                        i.u20_order_channel, -- u18_channel_id_v29
                        '1' -- u18_custom_type
                           );
            ELSE
                NULL; -- Nothing to Update. All Columns are Used in Join
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U18_TRADING_CHANNEL_RESTRICT',
                                   'Trading Account : '
                                || i.new_trading_account_id
                                || 'Restriction : '
                                || i.u18_restriction_id_v31
                                || 'Order Channel : '
                                || i.u20_order_channel,
                                CASE
                                    WHEN i.u18_id IS NULL
                                    THEN
                                        l_trading_channel_restrict_id
                                    ELSE
                                        i.u18_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.u18_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/