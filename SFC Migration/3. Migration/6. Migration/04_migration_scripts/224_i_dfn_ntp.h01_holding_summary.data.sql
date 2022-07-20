/*
    The logic used to avoid record which do not differ from the previous date gets wrong
    when executed several times as the variable take NULL values and can not compare with
    the one that is already existing. If variables could be populated with its mapped and
    existing one then we could run without deleting the full table.
    Eventhough update path is written it would not take it as the table is deleted first.
    Also we will not populate any intermediate table as it could be really costly to make
    copy of old table when actually a fraction of original table is migrated.
*/

BEGIN
    dfn_ntp.truncate_table ('H01_HOLDING_SUMMARY');
END;
/

COMMIT;

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);

    l_security_ac_id         NUMBER := 0;
    l_exchange               VARCHAR2 (10) := '';
    l_symbol                 VARCHAR2 (50) := '';
    l_custodian_id           NUMBER := 0;
    l_net_holdings           NUMBER := 0;
    l_avg_cost               NUMBER := 0;
    l_avg_price              NUMBER := 0;
    l_sell_pending           NUMBER := 0;
    l_buy_pending            NUMBER := 0;
    l_pledgedqty             NUMBER := 0;
    l_short_holding          NUMBER := 0;
    l_other_blocked_qty      NUMBER := 0;
    l_payable_holding        NUMBER := 0;
    l_pending_settle         NUMBER := 0;
    l_subscribed_quantity    NUMBER := 0;
    l_pending_subscription   NUMBER := 0;

    l_do_insert              NUMBER := 0;
    l_rec_cnt                NUMBER := 0;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    DELETE FROM error_log
          WHERE mig_table = 'H01_HOLDING_SUMMARY';

    -- Migrating General History Data

    FOR i
        IN (  SELECT holding.s01_security_ac_id,
                     holding.new_trading_account_id,
                     holding.exchange,
                     holding.s01_symbol,
                     holding.m20_id,
                     holding.s01_trimdate,
                     NVL (holding.s01_other_blocked_qty, 0)
                         AS s01_other_blocked_qty,
                     NVL (holding.s01_sell_pending, 0) AS s01_sell_pending,
                     NVL (holding.s01_buy_pending, 0) AS s01_buy_pending,
                     NVL (holding.s01_avg_price, 0) AS s01_avg_price,
                     NVL (holding.s01_weighted_avg_cost, 0)
                         AS s01_weighted_avg_cost,
                     NVL (holding.s01_avg_cost, 0) AS s01_avg_cost,
                     NVL (holding.s01_pending_settle, 0) AS s01_pending_settle,
                     NVL (holding.s01_payable_holding, 0)
                         AS s01_payable_holding,
                     holding.m20_currency_code_m03,
                     holding.m20_instrument_type_id_v09,
                     NVL (holding.s01_pledgedqty, 0) AS s01_pledgedqty,
                     NVL (holding.s01_lasttradeprice, 0) AS s01_lasttradeprice,
                     NVL (holding.close, 0) AS close,
                     NVL (holding.s01_vwap, 0) AS s01_vwap,
                     NVL (holding.s01_previousclosed, 0) AS s01_previousclosed,
                     NVL (holding.s01_net_holdings, 0) AS s01_net_holdings,
                     holding.trade_processing_status,
                     NVL (holding.s01_short_holding, 0) AS s01_short_holding,
                     NVL (holding.s01_subscribed_quantity, 0)
                         AS s01_subscribed_quantity,
                     NVL (holding.s01_pending_subscription, 0)
                         AS s01_pending_subscription,
                     holding.institute_custody_id,
                     holding.institute_custody_sid,
                     NVL (holding.s01_net_receivable, 0) AS s01_net_receivable,
                     h01.h01_trading_acnt_id_u07,
                     h01.h01_exchange_code_m01,
                     h01.h01_symbol_code_m20,
                     h01.h01_date
                FROM (SELECT s01_security_ac_id,
                             u07_map.new_trading_account_id,
                             NVL (map16.map16_ntp_code, s01.s01_exchange)
                                 AS exchange,
                             s01.s01_symbol,
                             m20.m20_id,
                             s01_trimdate,
                             s01_other_blocked_qty,
                             s01_sell_pending,
                             s01_buy_pending,
                             s01_avg_price,
                             s01_weighted_avg_cost,
                             s01_avg_cost,
                             s01_pending_settle,
                             s01_payable_holding,
                             m20.m20_currency_code_m03,
                             m20.m20_instrument_type_id_v09,
                             s01_pledgedqty,
                             s01_lasttradeprice,
                             esp.close,
                             s01_vwap,
                             s01_previousclosed,
                             s01_net_holdings,
                             CASE
                                 WHEN s01_trimdate <= TRUNC (SYSDATE) THEN 25
                                 ELSE 24
                             END
                                 AS trade_processing_status,
                             s01_short_holding,
                             s01_subscribed_quantity,
                             s01_pending_subscription,
                             NVL (m26.m26_id, -1) AS institute_custody_id,
                             s01_net_receivable,
                             NVL (m26.m26_sid, '') AS institute_custody_sid
                        FROM mubasher_oms.s01_holdings_summary@mubasher_db_link s01,
                             map16_optional_exchanges_m01 map16,
                             u07_trading_account_mappings u07_map,
                             (SELECT m20_id,
                                     m20_symbol_code,
                                     m20_exchange_code_m01,
                                     m20_currency_code_m03,
                                     m20_instrument_type_id_v09,
                                     m20_institute_id_m02
                                FROM dfn_ntp.m20_symbol
                               WHERE m20_institute_id_m02 =
                                         l_primary_institute_id) m20,
                             mubasher_price.esp_transactions_complete@mubasher_price_link esp,
                             (SELECT m43_institute_id_m02, m43_custodian_id_m26
                                FROM dfn_ntp.m43_institute_exchanges
                               WHERE m43_exchange_code_m01 = 'TDWL') m43,
                             (SELECT m26_id, m26_sid
                                FROM dfn_ntp.m26_executing_broker
                               WHERE m26_institution_id_m02 =
                                         l_primary_institute_id) m26
                       WHERE     s01.s01_security_ac_id =
                                     u07_map.old_trading_account_id
                             AND s01.s01_exchange = map16.map16_oms_code(+)
                             AND NVL (map16.map16_ntp_code, s01.s01_exchange) =
                                     u07_map.exchange_code
                             AND s01_symbol = m20.m20_symbol_code
                             AND NVL (map16.map16_ntp_code, s01.s01_exchange) =
                                     m20.m20_exchange_code_m01
                             AND s01_exchange = esp.exchangecode(+)
                             AND s01_symbol = esp.symbol(+)
                             AND s01_trimdate = esp.transactiondate(+)
                             AND NVL (map16.map16_ntp_code, s01.s01_exchange) =
                                     'TDWL'
                             AND m20.m20_institute_id_m02 =
                                     m43.m43_institute_id_m02(+)
                             AND m43.m43_custodian_id_m26 = m26.m26_id(+)) holding,
                     (SELECT *
                        FROM dfn_ntp.h01_holding_summary
                       WHERE h01_primary_institute_id_m02 =
                                 l_primary_institute_id) h01,
                     u07_trading_account_mappings u07_map
               WHERE     holding.s01_security_ac_id =
                             u07_map.old_trading_account_id(+)
                     AND u07_map.new_trading_account_id =
                             h01.h01_trading_acnt_id_u07(+)
                     AND holding.exchange = u07_map.exchange_code(+)
                     AND holding.exchange = h01.h01_exchange_code_m01(+)
                     AND holding.s01_symbol = h01.h01_symbol_code_m20(+)
                     AND holding.s01_trimdate = h01.h01_date(+)
            ORDER BY s01_security_ac_id,
                     exchange,
                     s01_symbol,
                     s01_trimdate)
    LOOP
        BEGIN
            IF    i.s01_security_ac_id <> l_security_ac_id
               OR i.exchange <> l_exchange
               OR i.s01_symbol <> l_symbol
               OR i.s01_net_holdings <> l_net_holdings
               OR i.s01_avg_cost <> l_avg_cost
               OR i.s01_avg_price <> l_avg_price
               OR i.s01_sell_pending <> l_sell_pending
               OR i.s01_buy_pending <> l_buy_pending
               OR i.s01_pledgedqty <> l_pledgedqty
               OR i.s01_short_holding <> l_short_holding
               OR i.s01_other_blocked_qty <> l_other_blocked_qty
               OR i.s01_payable_holding <> l_payable_holding
               OR i.s01_pending_settle <> l_pending_settle
               OR i.s01_subscribed_quantity <> l_subscribed_quantity
               OR i.s01_pending_subscription <> l_pending_subscription
            THEN
                l_do_insert := 1;
            END IF;

            IF l_do_insert = 1
            THEN
                IF     i.h01_trading_acnt_id_u07 IS NOT NULL
                   AND i.h01_exchange_code_m01 IS NOT NULL
                   AND i.h01_symbol_code_m20 IS NOT NULL
                   AND i.h01_date IS NOT NULL
                THEN
                    UPDATE dfn_ntp.h01_holding_summary
                       SET h01_symbol_id_m20 = i.m20_id, -- h01_symbol_id_m20
                           h01_custodian_id_m26 = i.institute_custody_id, -- h01_custodian_id_m26
                           h01_holding_block = i.s01_sell_pending, -- h01_holding_block | s01_sell_pending + Open Withdraw / Transfer Block which is Not Available
                           h01_sell_pending = i.s01_sell_pending, -- h01_sell_pending
                           h01_buy_pending = i.s01_buy_pending, -- h01_buy_pending
                           h01_weighted_avg_price = i.s01_weighted_avg_cost, -- h01_weighted_avg_price | Column s01_weighted_avg_cost is Used as h01_weighted_avg_price is Not Available
                           h01_avg_price = i.s01_avg_price, -- h01_avg_price
                           h01_weighted_avg_cost = i.s01_weighted_avg_cost, -- h01_weighted_avg_cost
                           h01_avg_cost = i.s01_avg_cost, -- h01_avg_cost
                           h01_receivable_holding = i.s01_pending_settle, -- h01_receivable_holding
                           h01_payable_holding = i.s01_payable_holding, -- h01_payable_holding
                           h01_currency_code_m03 = i.m20_currency_code_m03, -- h01_currency_code_m03
                           h01_price_inst_type = i.m20_instrument_type_id_v09, -- h01_price_inst_type
                           h01_pledge_qty = i.s01_pledgedqty, -- h01_pledge_qty
                           h01_last_trade_price = i.s01_lasttradeprice, -- h01_last_trade_price
                           h01_vwap = i.s01_vwap, -- h01_vwap
                           h01_market_price = i.close, -- h01_market_price
                           h01_previous_closed = i.s01_previousclosed, -- h01_previous_closed
                           h01_todays_closed = i.close, -- h01_todays_closed
                           h01_manual_block = i.s01_other_blocked_qty, -- h01_manual_block
                           h01_net_holding = i.s01_net_holdings, -- h01_net_holding
                           h01_custodian_code_m26 = i.institute_custody_sid, -- h01_custodian_code_m26
                           h01_short_holdings = i.s01_short_holding, -- h01_short_holdings
                           h01_net_receivable = i.s01_net_receivable, -- h01_net_receivable
                           h01_trade_processing_id_t17 =
                               i.trade_processing_status, -- h01_trade_processing_id_t17
                           h01_subscribed_qty = i.s01_subscribed_quantity, -- h01_subscribed_qty
                           h01_pending_subscribe_qty =
                               i.s01_pending_subscription -- h01_pending_subscribe_qty
                     WHERE     h01_trading_acnt_id_u07 =
                                   i.new_trading_account_id
                           AND h01_exchange_code_m01 = i.exchange
                           AND h01_symbol_code_m20 = i.s01_symbol
                           AND h01_date = i.s01_trimdate;
                ELSE
                    INSERT
                      INTO dfn_ntp.h01_holding_summary (
                               h01_trading_acnt_id_u07,
                               h01_exchange_code_m01,
                               h01_symbol_id_m20,
                               h01_date,
                               h01_custodian_id_m26,
                               h01_holding_block,
                               h01_sell_pending,
                               h01_buy_pending,
                               h01_weighted_avg_price,
                               h01_avg_price,
                               h01_weighted_avg_cost,
                               h01_avg_cost,
                               h01_receivable_holding,
                               h01_payable_holding,
                               h01_symbol_code_m20,
                               h01_realized_gain_lost,
                               h01_currency_code_m03,
                               h01_price_inst_type,
                               h01_pledge_qty,
                               h01_last_trade_price,
                               h01_vwap,
                               h01_market_price,
                               h01_previous_closed,
                               h01_todays_closed,
                               h01_manual_block,
                               h01_net_holding,
                               h01_custodian_code_m26,
                               h01_short_holdings,
                               h01_net_receivable,
                               h01_is_history_adjusted,
                               h01_trade_processing_id_t17,
                               h01_primary_institute_id_m02,
                               h01_subscribed_qty,
                               h01_pending_subscribe_qty,
                               h01_is_archive_ready)
                    VALUES (i.new_trading_account_id, -- h01_trading_acnt_id_u07
                            i.exchange, -- h01_exchange_code_m01
                            i.m20_id, -- h01_symbol_id_m20
                            i.s01_trimdate, -- h01_date
                            i.institute_custody_id, -- h01_custodian_id_m26
                            i.s01_sell_pending, -- h01_holding_block | s01_sell_pending + Open Withdraw / Transfer Block which is Not Available
                            i.s01_sell_pending, -- h01_sell_pending
                            i.s01_buy_pending, -- h01_buy_pending
                            i.s01_weighted_avg_cost, -- h01_weighted_avg_price | Column s01_weighted_avg_cost is Used as h01_weighted_avg_price is Not Available
                            i.s01_avg_price, -- h01_avg_price
                            i.s01_weighted_avg_cost, -- h01_weighted_avg_cost
                            i.s01_avg_cost, -- h01_avg_cost
                            i.s01_pending_settle, -- h01_receivable_holding
                            i.s01_payable_holding, -- h01_payable_holding
                            i.s01_symbol, -- h01_symbol_code_m20
                            0, -- h01_realized_gain_lost | Not Available
                            i.m20_currency_code_m03, -- h01_currency_code_m03
                            i.m20_instrument_type_id_v09, -- h01_price_inst_type
                            i.s01_pledgedqty, -- h01_pledge_qty
                            i.s01_lasttradeprice, -- h01_last_trade_price
                            i.s01_vwap, -- h01_vwap
                            i.close, -- h01_market_price
                            i.s01_previousclosed, -- h01_previous_closed
                            i.close, -- h01_todays_closed
                            i.s01_other_blocked_qty, -- h01_manual_block
                            i.s01_net_holdings, -- h01_net_holding
                            i.institute_custody_sid, -- h01_custodian_code_m26
                            i.s01_short_holding, -- h01_short_holdings
                            i.s01_net_receivable, -- h01_net_receivable
                            0, -- h01_is_history_adjusted
                            i.trade_processing_status, -- h01_trade_processing_id_t17
                            l_primary_institute_id, -- h01_primary_institute_id_m02
                            i.s01_subscribed_quantity, -- h01_subscribed_qty
                            i.s01_pending_subscription, -- h01_pending_subscribe_qty
                            0 -- h01_is_archive_ready
                             );

                    l_security_ac_id := i.s01_security_ac_id;
                    l_exchange := i.exchange;
                    l_symbol := i.s01_symbol;
                    l_net_holdings := i.s01_net_holdings;
                    l_avg_cost := i.s01_avg_cost;
                    l_avg_price := i.s01_avg_price;
                    l_sell_pending := i.s01_sell_pending;
                    l_buy_pending := i.s01_buy_pending;
                    l_pledgedqty := i.s01_pledgedqty;
                    l_short_holding := i.s01_short_holding;
                    l_other_blocked_qty := i.s01_other_blocked_qty;
                    l_payable_holding := i.s01_payable_holding;
                    l_pending_settle := i.s01_pending_settle;
                    l_subscribed_quantity := i.s01_subscribed_quantity;
                    l_pending_subscription := i.s01_pending_subscription;

                    l_do_insert := 0;
                END IF;

                l_rec_cnt := l_rec_cnt + 1;

                IF MOD (l_rec_cnt, 25000) = 0
                THEN
                    COMMIT;
                END IF;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'H01_HOLDING_SUMMARY',
                                   'S01 : Date - '
                                || i.s01_trimdate
                                || ' | '
                                || 'Security Acc - '
                                || i.s01_security_ac_id
                                || ' | '
                                || 'Exchange - '
                                || i.exchange
                                || ' | '
                                || 'Symbol - '
                                || i.s01_symbol,
                                CASE
                                    WHEN     i.h01_trading_acnt_id_u07
                                                 IS NOT NULL
                                         AND i.h01_exchange_code_m01
                                                 IS NOT NULL
                                         AND i.h01_symbol_code_m20
                                                 IS NOT NULL
                                         AND i.h01_date IS NOT NULL
                                    THEN
                                           'S01 : Date - '
                                        || i.h01_date
                                        || ' | '
                                        || 'Security Acc - '
                                        || i.h01_trading_acnt_id_u07
                                        || ' | '
                                        || 'Exchange - '
                                        || i.exchange
                                        || ' | '
                                        || 'Symbol - '
                                        || i.h01_symbol_code_m20
                                    ELSE
                                           'S01 : Date - '
                                        || i.s01_trimdate
                                        || ' | '
                                        || 'Security Acc - '
                                        || i.new_trading_account_id
                                        || ' | '
                                        || 'Exchange - '
                                        || i.exchange
                                        || ' | '
                                        || 'Symbol - '
                                        || i.s01_symbol
                                        || ' | '
                                        || 'Default Executing broker - '
                                        || i.institute_custody_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN     i.h01_trading_acnt_id_u07
                                                 IS NOT NULL
                                         AND i.exchange IS NOT NULL
                                         AND i.h01_symbol_code_m20
                                                 IS NOT NULL
                                         AND i.h01_date IS NOT NULL
                                    THEN
                                        'UPDATE'
                                    ELSE
                                        'INSERT'
                                END,
                                SYSDATE);
        END;
    END LOOP;

    COMMIT;

    -- Migrating Custodian Wise History Data

    FOR i
        IN (  SELECT holding.s05_security_ac_id,
                     holding.new_trading_account_id,
                     holding.exchange,
                     holding.s05_symbol,
                     holding.m20_id,
                     holding.s05_custodian,
                     holding.new_executing_broker_id,
                     holding.m26_sid,
                     holding.s05_trimdate,
                     NVL (holding.s05_sell_pending, 0) AS s05_sell_pending,
                     NVL (holding.s05_buy_pending, 0) AS s05_buy_pending,
                     NVL (holding.s05_avg_cost, 0) AS s05_avg_cost,
                     NVL (holding.s05_pending_settle, 0) AS s05_pending_settle,
                     NVL (holding.s05_payable_holding, 0)
                         AS s05_payable_holding,
                     holding.m20_currency_code_m03,
                     holding.m20_instrument_type_id_v09,
                     NVL (holding.close, 0) AS close,
                     NVL (holding.s05_net_holdings, 0) AS s05_net_holdings,
                     holding.trade_processing_status,
                     NVL (holding.s05_short_holding, 0) AS s05_short_holding,
                     h01.h01_trading_acnt_id_u07,
                     h01.h01_exchange_code_m01,
                     h01.h01_symbol_code_m20,
                     h01.h01_date,
                     h01.h01_custodian_id_m26
                FROM (SELECT s05.s05_security_ac_id,
                             u07_map.new_trading_account_id,
                             NVL (map16.map16_ntp_code, s05.s05_exchange)
                                 AS exchange,
                             s05.s05_symbol,
                             m20.m20_id,
                             s05.s05_custodian,
                             m26_map.new_executing_broker_id,
                             m26.m26_sid,
                             s05.s05_trimdate,
                             s05.s05_sell_pending,
                             s05.s05_buy_pending,
                             s05.s05_avg_cost,
                             s05.s05_pending_settle,
                             s05.s05_payable_holding,
                             m20.m20_currency_code_m03,
                             m20.m20_instrument_type_id_v09,
                             esp.close,
                             s05.s05_net_holdings,
                             CASE
                                 WHEN s05.s05_trimdate <= TRUNC (SYSDATE)
                                 THEN
                                     25
                                 ELSE
                                     24
                             END
                                 AS trade_processing_status,
                             s05.s05_short_holding
                        FROM mubasher_oms.s05_custodian_holdings_summary@mubasher_db_link s05,
                             map16_optional_exchanges_m01 map16,
                             u07_trading_account_mappings u07_map,
                             (SELECT m20_id,
                                     m20_symbol_code,
                                     m20_exchange_code_m01,
                                     m20_currency_code_m03,
                                     m20_instrument_type_id_v09
                                FROM dfn_ntp.m20_symbol
                               WHERE m20_institute_id_m02 =
                                         l_primary_institute_id) m20,
                             mubasher_price.esp_transactions_complete@mubasher_price_link esp,
                             m26_executing_broker_mappings m26_map,
                             dfn_ntp.m26_executing_broker m26
                       WHERE     s05.s05_security_ac_id =
                                     u07_map.old_trading_account_id
                             AND s05.s05_custodian =
                                     m26_map.old_executing_broker_id
                             AND m26_map.new_executing_broker_id = m26.m26_id
                             AND s05.s05_exchange = map16.map16_oms_code(+)
                             AND NVL (map16.map16_ntp_code, s05.s05_exchange) =
                                     u07_map.exchange_code
                             AND s05.s05_symbol = m20.m20_symbol_code
                             AND NVL (map16.map16_ntp_code, s05.s05_exchange) =
                                     m20.m20_exchange_code_m01
                             AND s05.s05_exchange = esp.exchangecode(+)
                             AND s05.s05_symbol = esp.symbol(+)
                             AND s05.s05_trimdate = esp.transactiondate(+)
                             AND NVL (map16.map16_ntp_code, s05.s05_exchange) <>
                                     'TDWL') holding,
                     (SELECT *
                        FROM dfn_ntp.h01_holding_summary
                       WHERE h01_primary_institute_id_m02 =
                                 l_primary_institute_id) h01,
                     u07_trading_account_mappings u07_map
               WHERE     holding.s05_security_ac_id =
                             u07_map.old_trading_account_id(+)
                     AND u07_map.new_trading_account_id =
                             h01.h01_trading_acnt_id_u07(+)
                     AND holding.exchange = u07_map.exchange_code(+)
                     AND holding.exchange = h01.h01_exchange_code_m01(+)
                     AND holding.s05_symbol = h01.h01_symbol_code_m20(+)
                     AND holding.s05_trimdate = h01.h01_date(+)
                     AND holding.new_executing_broker_id =
                             h01.h01_custodian_id_m26(+)
            ORDER BY s05_security_ac_id,
                     exchange,
                     s05_symbol,
                     s05_custodian,
                     s05_trimdate)
    LOOP
        BEGIN
            IF    i.s05_security_ac_id <> l_security_ac_id
               OR i.exchange <> l_exchange
               OR i.s05_symbol <> l_symbol
               OR i.s05_custodian <> l_custodian_id
               OR i.s05_net_holdings <> l_net_holdings
               OR i.s05_avg_cost <> l_avg_cost
               OR i.s05_sell_pending <> l_sell_pending
               OR i.s05_buy_pending <> l_buy_pending
               OR i.s05_short_holding <> l_short_holding
               OR i.s05_payable_holding <> l_payable_holding
               OR i.s05_pending_settle <> l_pending_settle
            THEN
                l_do_insert := 1;
            END IF;

            IF l_do_insert = 1
            THEN
                IF     i.h01_trading_acnt_id_u07 IS NOT NULL
                   AND i.h01_exchange_code_m01 IS NOT NULL
                   AND i.h01_symbol_code_m20 IS NOT NULL
                   AND i.h01_custodian_id_m26 IS NOT NULL
                   AND i.h01_date IS NOT NULL
                THEN
                    UPDATE dfn_ntp.h01_holding_summary
                       SET h01_symbol_id_m20 = i.m20_id, -- h01_symbol_id_m20
                           h01_holding_block = i.s05_sell_pending, -- h01_sell_pending | s01_sell_pending + Open Withdraw / Transfer Block which is Not Available
                           h01_sell_pending = i.s05_sell_pending, -- h01_sell_pending
                           h01_buy_pending = i.s05_buy_pending, -- h01_buy_pending
                           h01_weighted_avg_price = i.s05_avg_cost, -- h01_weighted_avg_price | Column s05_avg_cost is Used as h01_weighted_avg_price is Not Available
                           h01_avg_price = i.s05_avg_cost, -- h01_avg_price | Column s05_avg_cost is Used as h01_avg_price is Not Available
                           h01_weighted_avg_cost = i.s05_avg_cost, -- h01_weighted_avg_cost | Column s05_avg_cost is Used as h01_weighted_avg_cost is Not Available
                           h01_avg_cost = i.s05_avg_cost, -- h01_avg_cost
                           h01_receivable_holding = i.s05_pending_settle, -- h01_receivable_holding
                           h01_payable_holding = i.s05_payable_holding, -- h01_payable_holding
                           h01_currency_code_m03 = i.m20_currency_code_m03, -- h01_currency_code_m03
                           h01_price_inst_type = i.m20_instrument_type_id_v09, -- h01_price_inst_type
                           h01_last_trade_price = i.close, -- h01_last_trade_price
                           h01_vwap = i.close, -- h01_vwap | Column h01_vwap is Used as h01_vwap is Not Available
                           h01_market_price = i.close, -- h01_market_price | Column h01_vwap is Used as h01_market_price is Not Available
                           h01_previous_closed = i.close, -- h01_previous_closed | Column h01_vwap is Used as h01_previous_closed is Not Available
                           h01_todays_closed = i.close, -- h01_todays_closed | Column h01_vwap is Used as h01_todays_closed is Not Available
                           h01_net_holding = i.s05_net_holdings, -- h01_net_holding
                           h01_custodian_code_m26 = i.m26_sid, -- h01_custodian_code_m26
                           h01_short_holdings = i.s05_short_holding, -- h01_short_holdings
                           h01_trade_processing_id_t17 =
                               i.trade_processing_status -- h01_trade_processing_id_t17
                     WHERE     h01_trading_acnt_id_u07 =
                                   i.new_trading_account_id
                           AND h01_exchange_code_m01 = i.exchange
                           AND h01_symbol_code_m20 = i.s05_symbol
                           AND h01_custodian_id_m26 =
                                   i.new_executing_broker_id
                           AND h01_date = i.s05_trimdate;
                ELSE
                    INSERT
                      INTO dfn_ntp.h01_holding_summary (
                               h01_trading_acnt_id_u07,
                               h01_exchange_code_m01,
                               h01_symbol_id_m20,
                               h01_date,
                               h01_custodian_id_m26,
                               h01_holding_block,
                               h01_sell_pending,
                               h01_buy_pending,
                               h01_weighted_avg_price,
                               h01_avg_price,
                               h01_weighted_avg_cost,
                               h01_avg_cost,
                               h01_receivable_holding,
                               h01_payable_holding,
                               h01_symbol_code_m20,
                               h01_realized_gain_lost,
                               h01_currency_code_m03,
                               h01_price_inst_type,
                               h01_pledge_qty,
                               h01_last_trade_price,
                               h01_vwap,
                               h01_market_price,
                               h01_previous_closed,
                               h01_todays_closed,
                               h01_manual_block,
                               h01_net_holding,
                               h01_custodian_code_m26,
                               h01_short_holdings,
                               h01_net_receivable,
                               h01_is_history_adjusted,
                               h01_trade_processing_id_t17,
                               h01_primary_institute_id_m02,
                               h01_subscribed_qty,
                               h01_pending_subscribe_qty,
                               h01_is_archive_ready)
                    VALUES (i.new_trading_account_id, -- h01_trading_acnt_id_u07
                            i.exchange, -- h01_exchange_code_m01
                            i.m20_id, -- h01_symbol_id_m20
                            i.s05_trimdate, -- h01_date
                            i.new_executing_broker_id, -- h01_custodian_id_m26
                            i.s05_sell_pending, -- h01_holding_block | s01_sell_pending + Open Withdraw / Transfer Block which is Not Available
                            i.s05_sell_pending, -- h01_sell_pending
                            i.s05_buy_pending, -- h01_buy_pending
                            i.s05_avg_cost, -- h01_weighted_avg_price | Column s05_avg_cost is Used as h01_weighted_avg_price is Not Available
                            i.s05_avg_cost, -- h01_avg_price | Column s05_avg_cost is Used as h01_avg_price is Not Available
                            i.s05_avg_cost, -- h01_weighted_avg_cost | Column s05_avg_cost is Used as h01_weighted_avg_cost is Not Available
                            i.s05_avg_cost, -- h01_avg_cost
                            i.s05_pending_settle, -- h01_receivable_holding
                            i.s05_payable_holding, -- h01_payable_holding
                            i.s05_symbol, -- h01_symbol_code_m20
                            0, -- h01_realized_gain_lost | Not Available
                            i.m20_currency_code_m03, -- h01_currency_code_m03
                            i.m20_instrument_type_id_v09, -- h01_price_inst_type
                            0, -- h01_pledge_qty | Not Available
                            i.close, -- h01_last_trade_price
                            i.close, -- h01_vwap | Column h01_vwap is Used as h01_vwap is Not Available
                            i.close, -- h01_market_price | Column h01_vwap is Used as h01_market_price is Not Available
                            i.close, -- h01_previous_closed | Column h01_vwap is Used as h01_previous_closed is Not Available
                            i.close, -- h01_todays_closed | Column h01_vwap is Used as h01_todays_closed is Not Available
                            0, -- h01_manual_block | Not Available
                            i.s05_net_holdings, -- h01_net_holding
                            i.m26_sid, -- h01_custodian_code_m26
                            i.s05_short_holding, -- h01_short_holdings
                            0, -- h01_net_receivable | Not Available
                            0, -- h01_is_history_adjusted
                            i.trade_processing_status, -- h01_trade_processing_id_t17
                            l_primary_institute_id, -- h01_primary_institute_id_m02
                            0, -- h01_subscribed_qty | Not Available
                            0, -- h01_pending_subscribe_qty | Not Available
                            0 -- h01_is_archive_ready
                             );

                    l_security_ac_id := i.s05_security_ac_id;
                    l_exchange := i.exchange;
                    l_symbol := i.s05_symbol;
                    l_custodian_id := i.s05_custodian;
                    l_net_holdings := i.s05_net_holdings;
                    l_avg_cost := i.s05_avg_cost;
                    l_sell_pending := i.s05_sell_pending;
                    l_buy_pending := i.s05_buy_pending;
                    l_short_holding := i.s05_short_holding;
                    l_payable_holding := i.s05_payable_holding;
                    l_pending_settle := i.s05_pending_settle;

                    l_do_insert := 0;
                END IF;

                l_rec_cnt := l_rec_cnt + 1;

                IF MOD (l_rec_cnt, 25000) = 0
                THEN
                    COMMIT;
                END IF;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'H01_HOLDING_SUMMARY',
                                   'S05 : Date - '
                                || i.s05_trimdate
                                || ' | '
                                || 'Security Acc - '
                                || i.s05_security_ac_id
                                || ' | '
                                || 'Exchange - '
                                || i.exchange
                                || ' | '
                                || 'Symbol - '
                                || i.s05_symbol
                                || ' | '
                                || 'Custodian - '
                                || i.s05_custodian,
                                CASE
                                    WHEN     i.h01_trading_acnt_id_u07
                                                 IS NOT NULL
                                         AND i.h01_exchange_code_m01
                                                 IS NOT NULL
                                         AND i.h01_symbol_code_m20
                                                 IS NOT NULL
                                         AND i.h01_date IS NOT NULL
                                         AND i.h01_custodian_id_m26
                                                 IS NOT NULL
                                    THEN
                                           'S05 : Date - '
                                        || i.h01_date
                                        || ' | '
                                        || 'Security Acc - '
                                        || i.h01_trading_acnt_id_u07
                                        || ' | '
                                        || 'Exchange - '
                                        || i.h01_exchange_code_m01
                                        || ' | '
                                        || 'Symbol - '
                                        || i.h01_symbol_code_m20
                                        || ' | '
                                        || 'Custodian - '
                                        || i.h01_custodian_id_m26
                                    ELSE
                                           'S05 : Date - '
                                        || i.s05_trimdate
                                        || ' | '
                                        || 'Security Acc - '
                                        || i.new_trading_account_id
                                        || ' | '
                                        || 'Exchange - '
                                        || i.exchange
                                        || ' | '
                                        || 'Symbol - '
                                        || i.s05_symbol
                                        || ' | '
                                        || 'Custodian - '
                                        || i.new_executing_broker_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN     i.h01_trading_acnt_id_u07
                                                 IS NOT NULL
                                         AND i.h01_exchange_code_m01
                                                 IS NOT NULL
                                         AND i.h01_symbol_code_m20
                                                 IS NOT NULL
                                         AND i.h01_date IS NOT NULL
                                         AND i.h01_custodian_id_m26
                                                 IS NOT NULL
                                    THEN
                                        'UPDATE'
                                    ELSE
                                        'INSERT'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('H01_HOLDING_SUMMARY');
END;
/

-- Adding an Entry as EOD Job does not Add a Record to S01 for 0 Net Holding Portfolios

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
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

    FOR i
        IN (SELECT holding.new_trading_account_id,
                   holding.t06_security_ac_id,
                   holding.exchange,
                   holding.m20_id,
                   holding.t06_symbol,
                   holding.m20_currency_code_m03,
                   holding.m20_instrument_type_id_v09,
                   holding.t06_timestamp,
                   CASE
                       WHEN holding.t06_timestamp <= TRUNC (SYSDATE) THEN 25
                       ELSE 24
                   END
                       AS trade_processing_status,
                   holding.t06_custodian_inst_id,
                   holding.custody_id,
                   holding.custody_sid,
                   h01.h01_trading_acnt_id_u07,
                   h01.h01_exchange_code_m01,
                   h01.h01_symbol_code_m20,
                   h01.h01_date,
                   h01.h01_custodian_id_m26
              FROM (  SELECT u07_map.new_trading_account_id,
                             MAX (t06_security_ac_id) AS t06_security_ac_id,
                             NVL (map16.map16_ntp_code, t06.t06_exchange)
                                 AS exchange,
                             m20_id,
                             MAX (t06_symbol) AS t06_symbol,
                             MAX (m20.m20_currency_code_m03)
                                 AS m20_currency_code_m03,
                             MAX (m20.m20_instrument_type_id_v09)
                                 AS m20_instrument_type_id_v09,
                             TRUNC (MAX (t06_timestamp)) AS t06_timestamp,
                             SUM (t06_net_holdings) AS t06_net_holdings,
                             MAX (t06_custodian_inst_id)
                                 AS t06_custodian_inst_id,
                             NVL (MAX (m26_map.new_executing_broker_id),
                                  MAX (m26_custody.m26_id))
                                 AS custody_id,
                             NVL (MAX (m26.m26_sid), MAX (m26_custody.m26_sid))
                                 AS custody_sid
                        FROM mubasher_oms.t06_holdings_log@mubasher_db_link t06,
                             map16_optional_exchanges_m01 map16,
                             u07_trading_account_mappings u07_map,
                             (SELECT m20_id,
                                     m20_symbol_code,
                                     m20_exchange_code_m01,
                                     m20_currency_code_m03,
                                     m20_instrument_type_id_v09,
                                     m20_institute_id_m02
                                FROM dfn_ntp.m20_symbol
                               WHERE m20_institute_id_m02 =
                                         l_primary_institute_id) m20,
                             m26_executing_broker_mappings m26_map,
                             dfn_ntp.m26_executing_broker m26,
                             (SELECT m43_institute_id_m02,
                                     m43_executing_broker_id_m26,
                                     m43_custodian_id_m26
                                FROM dfn_ntp.m43_institute_exchanges
                               WHERE m43_exchange_code_m01 = 'TDWL') m43,
                             (SELECT m26_id, m26_sid
                                FROM dfn_ntp.m26_executing_broker
                               WHERE m26_institution_id_m02 =
                                         l_primary_institute_id) m26_custody
                       WHERE     t06.t06_security_ac_id =
                                     u07_map.old_trading_account_id
                             AND t06.t06_exchange = map16.map16_oms_code(+)
                             AND NVL (map16.map16_ntp_code, t06.t06_exchange) =
                                     u07_map.exchange_code
                             AND t06.t06_symbol = m20.m20_symbol_code
                             AND NVL (map16.map16_ntp_code, t06.t06_exchange) =
                                     m20.m20_exchange_code_m01
                             AND t06.t06_custodian_inst_id =
                                     m26_map.old_executing_broker_id(+)
                             AND m26_map.new_executing_broker_id =
                                     m26.m26_id(+)
                             AND NVL (map16.map16_ntp_code, t06.t06_exchange) =
                                     'TDWL'
                             AND m20.m20_institute_id_m02 =
                                     m43.m43_institute_id_m02(+)
                             AND m43.m43_custodian_id_m26 =
                                     m26_custody.m26_id(+)
                    GROUP BY u07_map.new_trading_account_id,
                             NVL (map16.map16_ntp_code, t06.t06_exchange),
                             m20.m20_id) holding,
                   (SELECT *
                      FROM dfn_ntp.h01_holding_summary
                     WHERE h01_primary_institute_id_m02 =
                               l_primary_institute_id) h01,
                   u07_trading_account_mappings u07_map
             WHERE     holding.t06_security_ac_id =
                           u07_map.old_trading_account_id(+)
                   AND u07_map.new_trading_account_id =
                           h01.h01_trading_acnt_id_u07(+)
                   AND holding.exchange = u07_map.exchange_code(+)
                   AND holding.exchange = h01.h01_exchange_code_m01(+)
                   AND holding.t06_symbol = h01.h01_symbol_code_m20(+)
                   AND holding.t06_timestamp = h01.h01_date(+)
                   AND holding.custody_id = h01.h01_custodian_id_m26(+)
                   AND t06_net_holdings = 0)
    LOOP
        BEGIN
            IF     i.h01_trading_acnt_id_u07 IS NOT NULL
               AND i.h01_exchange_code_m01 IS NOT NULL
               AND i.h01_symbol_code_m20 IS NOT NULL
               AND i.h01_date IS NOT NULL
               AND i.h01_custodian_id_m26 IS NOT NULL
            THEN
                UPDATE dfn_ntp.h01_holding_summary
                   SET h01_symbol_id_m20 = i.m20_id, -- h01_symbol_id_m20
                       h01_currency_code_m03 = i.m20_currency_code_m03, -- h01_currency_code_m03
                       h01_price_inst_type = i.m20_instrument_type_id_v09, -- h01_price_inst_type
                       h01_custodian_code_m26 = i.custody_sid, -- h01_custodian_code_m26
                       h01_trade_processing_id_t17 = i.trade_processing_status -- h01_trade_processing_id_t17
                 WHERE     h01_trading_acnt_id_u07 =
                               i.h01_trading_acnt_id_u07
                       AND h01_exchange_code_m01 = i.h01_exchange_code_m01
                       AND h01_symbol_code_m20 = i.h01_symbol_code_m20
                       AND h01_date = i.h01_date
                       AND h01_custodian_id_m26 = i.h01_custodian_id_m26;
            ELSE
                INSERT
                  INTO dfn_ntp.h01_holding_summary (
                           h01_trading_acnt_id_u07,
                           h01_exchange_code_m01,
                           h01_symbol_id_m20,
                           h01_date,
                           h01_custodian_id_m26,
                           h01_holding_block,
                           h01_sell_pending,
                           h01_buy_pending,
                           h01_weighted_avg_price,
                           h01_avg_price,
                           h01_weighted_avg_cost,
                           h01_avg_cost,
                           h01_receivable_holding,
                           h01_payable_holding,
                           h01_symbol_code_m20,
                           h01_realized_gain_lost,
                           h01_currency_code_m03,
                           h01_price_inst_type,
                           h01_pledge_qty,
                           h01_last_trade_price,
                           h01_vwap,
                           h01_market_price,
                           h01_previous_closed,
                           h01_todays_closed,
                           h01_manual_block,
                           h01_net_holding,
                           h01_custodian_code_m26,
                           h01_short_holdings,
                           h01_net_receivable,
                           h01_is_history_adjusted,
                           h01_trade_processing_id_t17,
                           h01_primary_institute_id_m02,
                           h01_subscribed_qty,
                           h01_pending_subscribe_qty,
                           h01_is_archive_ready)
                VALUES (i.new_trading_account_id, -- h01_trading_acnt_id_u07
                        i.exchange, -- h01_exchange_code_m01
                        i.m20_id, -- h01_symbol_id_m20
                        i.t06_timestamp, -- h01_date
                        i.custody_id, -- h01_custodian_id_m26
                        0, -- h01_holding_block
                        0, -- h01_sell_pending
                        0, -- h01_buy_pending
                        0, -- h01_weighted_avg_price
                        0, -- h01_avg_price
                        0, -- h01_weighted_avg_cost
                        0, -- h01_avg_cost
                        0, -- h01_receivable_holding
                        0, -- h01_payable_holding
                        i.t06_symbol, -- h01_symbol_code_m20
                        0, -- h01_realized_gain_lost
                        i.m20_currency_code_m03, -- h01_currency_code_m03
                        i.m20_instrument_type_id_v09, -- h01_price_inst_type
                        0, -- h01_pledge_qty
                        0, -- h01_last_trade_price
                        0, -- h01_vwap
                        0, -- h01_market_price
                        0, -- h01_previous_closed
                        0, -- h01_todays_closed
                        0, -- h01_manual_block
                        0, -- h01_net_holding
                        i.custody_sid, -- h01_custodian_code_m26
                        0, -- h01_short_holdings
                        0, -- h01_net_receivable
                        0, -- h01_is_history_adjusted
                        i.trade_processing_status, -- h01_trade_processing_id_t17
                        l_primary_institute_id, -- h01_primary_institute_id_m02
                        0, -- h01_subscribed_qty
                        0, -- h01_pending_subscribe_qty
                        0 -- h01_is_archive_ready
                         );
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'H01_HOLDING_SUMMARY',
                                   'S01 0 Balance : Date - '
                                || i.t06_timestamp
                                || ' | '
                                || 'Security Acc - '
                                || i.t06_security_ac_id
                                || ' | '
                                || 'Exchange - '
                                || i.exchange
                                || ' | '
                                || 'Symbol - '
                                || i.t06_symbol
                                || ' | '
                                || 'Custodian - '
                                || i.t06_custodian_inst_id,
                                CASE
                                    WHEN     i.h01_trading_acnt_id_u07
                                                 IS NOT NULL
                                         AND i.h01_exchange_code_m01
                                                 IS NOT NULL
                                         AND i.h01_symbol_code_m20
                                                 IS NOT NULL
                                         AND i.h01_date IS NOT NULL
                                         AND i.h01_custodian_id_m26
                                                 IS NOT NULL
                                    THEN
                                        NULL
                                    ELSE
                                           'S01 0 Balance : Date - '
                                        || i.t06_timestamp
                                        || ' | '
                                        || 'Security Acc - '
                                        || i.new_trading_account_id
                                        || ' | '
                                        || 'Exchange - '
                                        || i.exchange
                                        || ' | '
                                        || 'Symbol - '
                                        || i.t06_symbol
                                        || ' | '
                                        || 'Custodian - '
                                        || i.custody_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN     i.h01_trading_acnt_id_u07
                                                 IS NOT NULL
                                         AND i.h01_exchange_code_m01
                                                 IS NOT NULL
                                         AND i.h01_symbol_code_m20
                                                 IS NOT NULL
                                         AND i.h01_date IS NOT NULL
                                         AND i.h01_custodian_id_m26
                                                 IS NOT NULL
                                    THEN
                                        NULL
                                    ELSE
                                        'INSERT'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('H01_HOLDING_SUMMARY');
END;
/

-- Adding an Entry as EOD Job does not Add a Record to S05 for 0 Net Holding Portfolios

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
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

    FOR i
        IN (SELECT holding.new_trading_account_id,
                   holding.t06_security_ac_id,
                   holding.exchange,
                   holding.m20_id,
                   holding.t06_symbol,
                   holding.m20_currency_code_m03,
                   holding.m20_instrument_type_id_v09,
                   holding.t06_timestamp,
                   CASE
                       WHEN holding.t06_timestamp <= TRUNC (SYSDATE) THEN 25
                       ELSE 24
                   END
                       AS trade_processing_status,
                   holding.t06_custodian_inst_id,
                   holding.custody_id,
                   holding.custody_sid,
                   h01.h01_trading_acnt_id_u07,
                   h01.h01_exchange_code_m01,
                   h01.h01_symbol_code_m20,
                   h01.h01_date,
                   h01.h01_custodian_id_m26
              FROM (  SELECT u07_map.new_trading_account_id,
                             MAX (t06_security_ac_id) AS t06_security_ac_id,
                             NVL (map16.map16_ntp_code, t06.t06_exchange)
                                 AS exchange,
                             m20_id,
                             MAX (t06_symbol) AS t06_symbol,
                             MAX (m20.m20_currency_code_m03)
                                 AS m20_currency_code_m03,
                             MAX (m20.m20_instrument_type_id_v09)
                                 AS m20_instrument_type_id_v09,
                             TRUNC (MAX (t06_timestamp)) AS t06_timestamp,
                             SUM (t06_net_holdings) AS t06_net_holdings,
                             MAX (t06_custodian_inst_id)
                                 AS t06_custodian_inst_id,
                             NVL (MAX (m26_map.new_executing_broker_id),
                                  MAX (m43_custody.m43_custodian_id_m26))
                                 AS custody_id,
                             NVL (MAX (m26.m26_sid), MAX (m43_custody.m26_sid))
                                 AS custody_sid
                        FROM mubasher_oms.t06_holdings_log@mubasher_db_link t06,
                             map16_optional_exchanges_m01 map16,
                             u07_trading_account_mappings u07_map,
                             (SELECT m20_id,
                                     m20_symbol_code,
                                     m20_exchange_code_m01,
                                     m20_currency_code_m03,
                                     m20_instrument_type_id_v09,
                                     m20_institute_id_m02
                                FROM dfn_ntp.m20_symbol m20
                               WHERE m20_institute_id_m02 =
                                         l_primary_institute_id) m20,
                             m26_executing_broker_mappings m26_map,
                             dfn_ntp.m26_executing_broker m26,
                             (SELECT m43_institute_id_m02,
                                     m43_exchange_code_m01,
                                     m43_custodian_id_m26,
                                     m26_sid
                                FROM dfn_ntp.m43_institute_exchanges,
                                     dfn_ntp.m26_executing_broker
                               WHERE     m26_institution_id_m02 =
                                             l_primary_institute_id
                                     AND m26_id = m43_custodian_id_m26) m43_custody
                       WHERE     t06.t06_security_ac_id =
                                     u07_map.old_trading_account_id
                             AND t06.t06_exchange = map16.map16_oms_code(+)
                             AND NVL (map16.map16_ntp_code, t06.t06_exchange) =
                                     u07_map.exchange_code
                             AND t06.t06_symbol = m20.m20_symbol_code
                             AND NVL (map16.map16_ntp_code, t06.t06_exchange) =
                                     m20.m20_exchange_code_m01
                             AND t06.t06_custodian_inst_id =
                                     m26_map.old_executing_broker_id(+)
                             AND m26_map.new_executing_broker_id =
                                     m26.m26_id(+)
                             AND NVL (map16.map16_ntp_code, t06.t06_exchange) <>
                                     'TDWL'
                             AND m20.m20_institute_id_m02 =
                                     m43_custody.m43_institute_id_m02(+)
                             AND NVL (map16.map16_ntp_code, t06.t06_exchange) =
                                     m43_custody.m43_exchange_code_m01(+)
                    GROUP BY u07_map.new_trading_account_id,
                             NVL (map16.map16_ntp_code, t06.t06_exchange),
                             m20.m20_id) holding,
                   (SELECT *
                      FROM dfn_ntp.h01_holding_summary
                     WHERE h01_primary_institute_id_m02 =
                               l_primary_institute_id) h01,
                   u07_trading_account_mappings u07_map
             WHERE     holding.t06_security_ac_id =
                           u07_map.old_trading_account_id(+)
                   AND u07_map.new_trading_account_id =
                           h01.h01_trading_acnt_id_u07(+)
                   AND holding.exchange = u07_map.exchange_code(+)
                   AND holding.exchange = h01.h01_exchange_code_m01(+)
                   AND holding.t06_symbol = h01.h01_symbol_code_m20(+)
                   AND holding.t06_timestamp = h01.h01_date(+)
                   AND holding.custody_id = h01.h01_custodian_id_m26(+)
                   AND t06_net_holdings = 0)
    LOOP
        BEGIN
            IF     i.h01_trading_acnt_id_u07 IS NOT NULL
               AND i.h01_exchange_code_m01 IS NOT NULL
               AND i.h01_symbol_code_m20 IS NOT NULL
               AND i.h01_date IS NOT NULL
               AND i.h01_custodian_id_m26 IS NOT NULL
            THEN
                UPDATE dfn_ntp.h01_holding_summary
                   SET h01_symbol_id_m20 = i.m20_id, -- h01_symbol_id_m20
                       h01_currency_code_m03 = i.m20_currency_code_m03, -- h01_currency_code_m03
                       h01_price_inst_type = i.m20_instrument_type_id_v09, -- h01_price_inst_type
                       h01_custodian_code_m26 = i.custody_sid, -- h01_custodian_code_m26
                       h01_trade_processing_id_t17 = i.trade_processing_status -- h01_trade_processing_id_t17
                 WHERE     h01_trading_acnt_id_u07 =
                               i.h01_trading_acnt_id_u07
                       AND h01_exchange_code_m01 = i.h01_exchange_code_m01
                       AND h01_symbol_code_m20 = i.h01_symbol_code_m20
                       AND h01_date = i.h01_date
                       AND h01_custodian_id_m26 = i.h01_custodian_id_m26;
            ELSE
                INSERT
                  INTO dfn_ntp.h01_holding_summary (
                           h01_trading_acnt_id_u07,
                           h01_exchange_code_m01,
                           h01_symbol_id_m20,
                           h01_date,
                           h01_custodian_id_m26,
                           h01_holding_block,
                           h01_sell_pending,
                           h01_buy_pending,
                           h01_weighted_avg_price,
                           h01_avg_price,
                           h01_weighted_avg_cost,
                           h01_avg_cost,
                           h01_receivable_holding,
                           h01_payable_holding,
                           h01_symbol_code_m20,
                           h01_realized_gain_lost,
                           h01_currency_code_m03,
                           h01_price_inst_type,
                           h01_pledge_qty,
                           h01_last_trade_price,
                           h01_vwap,
                           h01_market_price,
                           h01_previous_closed,
                           h01_todays_closed,
                           h01_manual_block,
                           h01_net_holding,
                           h01_custodian_code_m26,
                           h01_short_holdings,
                           h01_net_receivable,
                           h01_is_history_adjusted,
                           h01_trade_processing_id_t17,
                           h01_primary_institute_id_m02,
                           h01_subscribed_qty,
                           h01_pending_subscribe_qty,
                           h01_is_archive_ready)
                VALUES (i.new_trading_account_id, -- h01_trading_acnt_id_u07
                        i.exchange, -- h01_exchange_code_m01
                        i.m20_id, -- h01_symbol_id_m20
                        i.t06_timestamp, -- h01_date
                        i.custody_id, -- h01_custodian_id_m26
                        0, -- h01_holding_block
                        0, -- h01_sell_pending
                        0, -- h01_buy_pending
                        0, -- h01_weighted_avg_price
                        0, -- h01_avg_price
                        0, -- h01_weighted_avg_cost
                        0, -- h01_avg_cost
                        0, -- h01_receivable_holding
                        0, -- h01_payable_holding
                        i.t06_symbol, -- h01_symbol_code_m20
                        0, -- h01_realized_gain_lost
                        i.m20_currency_code_m03, -- h01_currency_code_m03
                        i.m20_instrument_type_id_v09, -- h01_price_inst_type
                        0, -- h01_pledge_qty
                        0, -- h01_last_trade_price
                        0, -- h01_vwap
                        0, -- h01_market_price
                        0, -- h01_previous_closed
                        0, -- h01_todays_closed
                        0, -- h01_manual_block
                        0, -- h01_net_holding
                        i.custody_sid, -- h01_custodian_code_m26
                        0, -- h01_short_holdings
                        0, -- h01_net_receivable
                        0, -- h01_is_history_adjusted
                        i.trade_processing_status, -- h01_trade_processing_id_t17
                        l_primary_institute_id, -- h01_primary_institute_id_m02
                        0, -- h01_subscribed_qty
                        0, -- h01_pending_subscribe_qty
                        0 -- h01_is_archive_ready
                         );
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'H01_HOLDING_SUMMARY',
                                   'S05 0 Balance : Date - '
                                || i.t06_timestamp
                                || ' | '
                                || 'Security Acc - '
                                || i.t06_security_ac_id
                                || ' | '
                                || 'Exchange - '
                                || i.exchange
                                || ' | '
                                || 'Symbol - '
                                || i.t06_symbol
                                || ' | '
                                || 'Custodian - '
                                || i.t06_custodian_inst_id,
                                CASE
                                    WHEN     i.h01_trading_acnt_id_u07
                                                 IS NOT NULL
                                         AND i.h01_exchange_code_m01
                                                 IS NOT NULL
                                         AND i.h01_symbol_code_m20
                                                 IS NOT NULL
                                         AND i.h01_date IS NOT NULL
                                         AND i.h01_custodian_id_m26
                                                 IS NOT NULL
                                    THEN
                                        NULL
                                    ELSE
                                           'S05 0 Balance : Date - '
                                        || i.t06_timestamp
                                        || ' | '
                                        || 'Security Acc - '
                                        || i.new_trading_account_id
                                        || ' | '
                                        || 'Exchange - '
                                        || i.exchange
                                        || ' | '
                                        || 'Symbol - '
                                        || i.t06_symbol
                                        || ' | '
                                        || 'Custodian - '
                                        || i.custody_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN     i.h01_trading_acnt_id_u07
                                                 IS NOT NULL
                                         AND i.h01_exchange_code_m01
                                                 IS NOT NULL
                                         AND i.h01_symbol_code_m20
                                                 IS NOT NULL
                                         AND i.h01_date IS NOT NULL
                                         AND i.h01_custodian_id_m26
                                                 IS NOT NULL
                                    THEN
                                        NULL
                                    ELSE
                                        'INSERT'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('H01_HOLDING_SUMMARY');
END;
/