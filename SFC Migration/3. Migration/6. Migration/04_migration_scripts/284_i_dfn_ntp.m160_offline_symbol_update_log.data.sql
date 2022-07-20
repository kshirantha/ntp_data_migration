DECLARE
    l_offline_sym_upd_log_id   NUMBER;
    l_sqlerrm                  VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m160_id), 0)
      INTO l_offline_sym_upd_log_id
      FROM dfn_ntp.m160_offline_symbol_update_log;

    DELETE FROM error_log
          WHERE mig_table = 'M160_OFFLINE_SYMBOL_UPDATE_LOG';

    FOR i
        IN (SELECT m77.m77_symbol,
                   m77.m77_date,
                   CASE
                       WHEN m77.m77_status = 1 THEN 17
                       WHEN m77.m77_status = 2 THEN 3
                   END
                       AS status,
                   m77.m77_old_ltp,
                   m77.m77_new_ltp,
                   m77.m77_old_previous_close,
                   m77.m77_new_previous_close,
                   m77.m77_old_last_trade_date,
                   m77.m77_new_last_trade_date,
                   m77.m77_old_max_price,
                   m77.m77_new_max_price,
                   m77.m77_old_bid_price,
                   m77.m77_new_bid_price,
                   m77.m77_old_ask_price,
                   m77.m77_new_ask_price,
                   m77.m77_old_maturity_date,
                   m77.m77_new_maturity_date,
                   m77.m77_old_min_price,
                   m77.m77_new_min_price,
                   NVL (u17_updated_by.new_employee_id, 0) AS last_updated_by,
                   NVL (m77.m77_updated_date, m77.m77_date)
                       AS last_updated_date,
                   m77.m77_reason,
                   m77.m77_reuters_code,
                   m77.m77_currency,
                   NVL (map16.map16_ntp_code, m77.m77_exchange) AS exchange,
                   m77.m77_volume,
                   m77.m77_coupon_rate,
                   m77.m77_isin,
                   m160.m160_id
              FROM mubasher_oms.m77_ofline_symbols_update_log@mubasher_db_link m77,
                   map16_optional_exchanges_m01 map16,
                   u17_employee_mappings u17_updated_by,
                   dfn_ntp.m160_offline_symbol_update_log m160
             WHERE     m77.m77_updated_by = u17_updated_by.old_employee_id(+)
                   AND m77.m77_symbol = m160.m160_symbol(+)
                   AND m77.m77_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, m77.m77_exchange) =
                           m160.m160_exchange(+)
                   AND m77.m77_date = m160.m160_date(+))
    LOOP
        BEGIN
            IF i.exchange IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.m77_symbol IS NULL
            THEN
                raise_application_error (-20001,
                                         'Symbol Not Available',
                                         TRUE);
            END IF;

            IF i.m160_id IS NULL
            THEN
                l_offline_sym_upd_log_id := l_offline_sym_upd_log_id + 1;

                INSERT
                  INTO dfn_ntp.m160_offline_symbol_update_log (
                           m160_id,
                           m160_symbol,
                           m160_date,
                           m160_status,
                           m160_old_ltp,
                           m160_new_ltp,
                           m160_old_previous_close,
                           m160_new_previous_close,
                           m160_old_last_trade_date,
                           m160_new_last_trade_date,
                           m160_old_max_price,
                           m160_new_max_price,
                           m160_old_bid_price,
                           m160_new_bid_price,
                           m160_old_ask_price,
                           m160_new_ask_price,
                           m160_old_maturity_date,
                           m160_new_maturity_date,
                           m160_old_min_price,
                           m160_new_min_price,
                           m160_updated_by_id_u17,
                           m160_updated_date,
                           m160_reason,
                           m160_reuters_code,
                           m160_currency,
                           m160_exchange,
                           m160_volume,
                           m160_coupon_rate,
                           m160_isin,
                           m160_custom_type,
                           m160_symbol_sessions_id_m159)
                VALUES (l_offline_sym_upd_log_id, -- m160_id
                        i.m77_symbol, -- m160_symbol
                        i.m77_date, -- m160_date
                        i.status, -- m160_status
                        i.m77_old_ltp, -- m160_old_ltp
                        i.m77_new_ltp, -- m160_new_ltp
                        i.m77_old_previous_close, -- m160_old_previous_close
                        i.m77_new_previous_close, -- m160_new_previous_close
                        i.m77_old_last_trade_date, -- m160_old_last_trade_date
                        i.m77_new_last_trade_date, -- m160_new_last_trade_date
                        i.m77_old_max_price, -- m160_old_max_price
                        i.m77_new_max_price, -- m160_new_max_price
                        i.m77_old_bid_price, -- m160_old_bid_price
                        i.m77_new_bid_price, -- m160_new_bid_price
                        i.m77_old_ask_price, -- m160_old_ask_price
                        i.m77_new_ask_price, -- m160_new_ask_price
                        i.m77_old_maturity_date, -- m160_old_maturity_date
                        i.m77_new_maturity_date, -- m160_new_maturity_date
                        i.m77_old_min_price, -- m160_old_min_price
                        i.m77_new_min_price, -- m160_new_min_price
                        i.last_updated_by, -- m160_updated_by_id_u17
                        i.last_updated_date, -- m160_updated_date
                        i.m77_reason, -- m160_reason
                        i.m77_reuters_code, -- m160_reuters_code
                        i.m77_currency, -- m160_currency
                        i.exchange, -- m160_exchange
                        i.m77_volume, -- m160_volume
                        i.m77_coupon_rate, -- m160_coupon_rate
                        i.m77_isin, -- m160_isin
                        '1', -- m160_custom_type
                        NULL -- m160_symbol_sessions_id_m159 | Not Available
                            );
            ELSE
                UPDATE dfn_ntp.m160_offline_symbol_update_log
                   SET m160_date = i.m77_date, -- m160_date
                       m160_status = i.status, -- m160_status
                       m160_old_previous_close = i.m77_old_previous_close, -- m160_old_previous_close
                       m160_new_previous_close = i.m77_new_previous_close, -- m160_new_previous_close
                       m160_old_last_trade_date = i.m77_old_last_trade_date, -- m160_old_last_trade_date
                       m160_new_last_trade_date = i.m77_new_last_trade_date, -- m160_new_last_trade_date
                       m160_old_max_price = i.m77_old_max_price, -- m160_old_max_price
                       m160_new_max_price = i.m77_new_max_price, -- m160_new_max_price
                       m160_old_bid_price = i.m77_old_bid_price, -- m160_old_bid_price
                       m160_new_bid_price = i.m77_new_bid_price, -- m160_new_bid_price
                       m160_old_ask_price = i.m77_old_ask_price, -- m160_old_ask_price
                       m160_new_ask_price = i.m77_new_ask_price, -- m160_new_ask_price
                       m160_old_maturity_date = i.m77_old_maturity_date, -- m160_old_maturity_date
                       m160_new_maturity_date = i.m77_new_maturity_date, -- m160_new_maturity_date
                       m160_old_min_price = i.m77_old_min_price, -- m160_old_min_price
                       m160_new_min_price = i.m77_new_min_price, -- m160_new_min_price
                       m160_updated_by_id_u17 = i.last_updated_by, -- m160_updated_by_id_u17
                       m160_updated_date = i.last_updated_date, -- m160_updated_date
                       m160_reason = i.m77_reason, -- m160_reason
                       m160_reuters_code = i.m77_reuters_code, -- m160_reuters_code
                       m160_currency = i.m77_currency, -- m160_currency
                       m160_volume = i.m77_volume, -- m160_volume
                       m160_coupon_rate = i.m77_coupon_rate, -- m160_coupon_rate
                       m160_isin = i.m77_isin -- m160_isin
                 WHERE m160_id = i.m160_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M160_OFFLINE_SYMBOL_UPDATE_LOG',
                                   'Symbol : '
                                || i.m77_symbol
                                || ' - '
                                || ' : Exchange - '
                                || i.exchange
                                || ' - '
                                || ' : Old LTP - '
                                || i.m77_old_ltp
                                || ' - '
                                || ' : New LTP - '
                                || i.m77_old_ltp,
                                CASE
                                    WHEN i.m160_id IS NULL
                                    THEN
                                        l_offline_sym_upd_log_id
                                    ELSE
                                        i.m160_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.m160_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
