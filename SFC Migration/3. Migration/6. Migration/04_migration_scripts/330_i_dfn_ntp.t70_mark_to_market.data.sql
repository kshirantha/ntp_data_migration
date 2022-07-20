DECLARE
    l_mark_to_market_id   NUMBER;
    l_sqlerrm             VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t70_id), 0)
      INTO l_mark_to_market_id
      FROM dfn_ntp.t70_mark_to_market;

    DELETE FROM error_log
          WHERE mig_table = 'T70_MARK_TO_MARKET';

    FOR i
        IN (SELECT t119.t119_id,
                   t119.t119_date,
                   u07_map.new_trading_account_id,
                   NVL (map16.map16_ntp_code, t119.t119_exchange) AS exchange,
                   t119.t119_symbol,
                   t119.t119_own_holdings,
                   t119.t119_vwap,
                   t119.t119_settle_price,
                   t119.t119_m2m_gain_loss,
                   t119.t119_im_value,
                   t119.t119_orderno,
                   t119.t119_execid,
                   t119.t119_order_side,
                   t119.t119_position_effect,
                   t119.t119_notional_value,
                   t70_map.new_mark_to_market_id
              FROM mubasher_oms.t119_mark_to_market@mubasher_db_link t119,
                   map16_optional_exchanges_m01 map16,
                   u07_trading_account_mappings u07_map,
                   t70_mark_to_market_mappings t70_map
             WHERE     t119.t119_security_ac_id =
                           u07_map.old_trading_account_id(+)
                   AND t119.t119_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, t119.t119_exchange) =
                           u07_map.exchange_code(+)
                   AND t119.t119_id = t70_map.old_mark_to_market_id(+))
    LOOP
        BEGIN
            IF i.exchange IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.new_trading_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Trading Account Not Available',
                                         TRUE);
            END IF;

            IF i.new_mark_to_market_id IS NULL
            THEN
                l_mark_to_market_id := l_mark_to_market_id + 1;

                INSERT
                  INTO dfn_ntp.t70_mark_to_market (t70_id,
                                                   t70_date,
                                                   t70_trading_acc_id_u07,
                                                   t70_exchange_code_m01,
                                                   t70_symbol_code_m20,
                                                   t70_own_holdings,
                                                   t70_vwap,
                                                   t70_settle_price,
                                                   t70_m2m_gain_loss,
                                                   t70_im_value,
                                                   t70_order_no,
                                                   t70_exec_id,
                                                   t70_order_side,
                                                   t70_position_effect,
                                                   t70_notional_value,
                                                   t70_custom_type)
                VALUES (l_mark_to_market_id, -- t70_id
                        i.t119_date, -- t70_date
                        i.new_trading_account_id, -- t70_trading_acc_id_u07
                        i.exchange, -- t70_exchange_code_m01
                        i.t119_symbol, -- t70_symbol_code_m20
                        i.t119_own_holdings, -- t70_own_holdings
                        i.t119_vwap, -- t70_vwap
                        i.t119_settle_price, -- t70_settle_price
                        i.t119_m2m_gain_loss, -- t70_m2m_gain_loss
                        i.t119_im_value, -- t70_im_value
                        i.t119_orderno, -- t70_order_no
                        i.t119_execid, -- t70_exec_id
                        i.t119_order_side, -- t70_order_side
                        i.t119_position_effect, -- t70_position_effect
                        i.t119_notional_value, -- t70_notional_value
                        '1' -- t70_custom_type
                           );

                INSERT
                  INTO t70_mark_to_market_mappings (old_mark_to_market_id,
                                                    new_mark_to_market_id)
                VALUES (i.t119_id, l_mark_to_market_id);
            ELSE
                UPDATE dfn_ntp.t70_mark_to_market
                   SET t70_date = i.t119_date, -- t70_date
                       t70_trading_acc_id_u07 = i.new_trading_account_id, -- t70_trading_acc_id_u07
                       t70_exchange_code_m01 = i.exchange, -- t70_exchange_code_m01
                       t70_symbol_code_m20 = i.t119_symbol, -- t70_symbol_code_m20
                       t70_own_holdings = i.t119_own_holdings, -- t70_own_holdings
                       t70_vwap = i.t119_vwap, -- t70_vwap
                       t70_settle_price = i.t119_settle_price, -- t70_settle_price
                       t70_m2m_gain_loss = i.t119_m2m_gain_loss, -- t70_m2m_gain_loss
                       t70_im_value = i.t119_im_value, -- t70_im_value
                       t70_order_no = i.t119_orderno, -- t70_order_no
                       t70_exec_id = i.t119_execid, -- t70_exec_id
                       t70_order_side = i.t119_order_side, -- t70_order_side
                       t70_position_effect = i.t119_position_effect, -- t70_position_effect
                       t70_notional_value = i.t119_notional_value -- t70_notional_value
                 WHERE t70_id = i.new_mark_to_market_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T70_MARK_TO_MARKET',
                                i.t119_id,
                                CASE
                                    WHEN i.new_mark_to_market_id IS NULL
                                    THEN
                                        l_mark_to_market_id
                                    ELSE
                                        i.new_mark_to_market_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_mark_to_market_id IS NULL
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
