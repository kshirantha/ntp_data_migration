DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);

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
          WHERE mig_table = 'U24_HOLDINGS';

    -- Migrate Custodian Wise Holdings Considering for Non TDWL Exchanges [Discussed]

    FOR i
        IN (SELECT m26_map.new_executing_broker_id,
                   NVL (t04_dtl.t04_sell_pending, 0) AS t04_sell_pending,
                   NVL (t04_dtl.t04_buy_pending, 0) AS t04_buy_pending,
                   NVL (t04_dtl.t04_avg_price, 0) AS t04_avg_price,
                   NVL (t04_dtl.t04_weighted_avg_cost, 0)
                       AS t04_weighted_avg_cost,
                   NVL (t04_dtl.t04_avg_cost, 0) AS t04_avg_cost,
                   NVL (t04_dtl.t04_pending_settle, 0) AS t04_pending_settle,
                   NVL (t04_dtl.t04_payable_holding, 0)
                       AS t04_payable_holding,
                   NVL (t04_dtl.t04_net_holdings, 0) AS t04_net_holdings,
                   u07_map.new_trading_account_id,
                   m20.m20_symbol_code,
                   m20.m20_exchange_code_m01,
                   m26.m26_sid,
                   u06.u06_currency_code_m03,
                   u06.u06_id,
                   m20.m20_price_instrument_id_v34,
                   NVL (t04_dtl.t04_pledgedqty, 0) AS t04_pledgedqty,
                   NVL (t04_dtl.t04_other_blocked_qty, 0)
                       AS t04_other_blocked_qty,
                   NVL (t04_dtl.t04_short_holding, 0) AS t04_short_holding,
                   m20.m20_id,
                   u07_map.old_trading_account_id,
                   t04_dtl.t04_custodian,
                   NVL (t04_dtl.t04_long_holding, 0) AS t04_long_holding,
                   u24.u24_trading_acnt_id_u07 AS mapped_trading_acnt_id,
                   u24.u24_exchange_code_m01 AS mapped_exchange_code,
                   u24.u24_symbol_code_m20 AS mapped_symbol_code,
                   u24.u24_custodian_id_m26 AS mapped_custodian
              FROM mubasher_oms.t04_holdings_intraday_dtl@mubasher_db_link t04_dtl,
                   mubasher_oms.u05_security_accounts@mubasher_db_link u05,
                   m02_institute_mappings m02_map,
                   map16_optional_exchanges_m01 map16,
                   u07_trading_account_mappings u07_map,
                   dfn_ntp.u07_trading_account u07,
                   dfn_ntp.u06_cash_account u06,
                   m26_executing_broker_mappings m26_map,
                   dfn_ntp.m26_executing_broker m26,
                   (SELECT m20_id,
                           m20_symbol_code,
                           m20_exchange_code_m01,
                           m20_price_instrument_id_v34
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20,
                   u07_trading_account_mappings u07_mapped,
                   m26_executing_broker_mappings m26_mapped,
                   (SELECT *
                      FROM dfn_ntp.u24_holdings
                     WHERE u24_exchange_code_m01 <> 'TDWL') u24
             WHERE     t04_dtl.t04_security_ac_id = u05.u05_id
                   AND u05.u05_branch_id = m02_map.old_institute_id
                   AND t04_dtl.t04_security_ac_id =
                           u07_map.old_trading_account_id(+)
                   AND t04_dtl.t04_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, t04_dtl.t04_exchange) =
                           u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id = u07.u07_id(+)
                   AND u07.u07_cash_account_id_u06 = u06.u06_id(+)
                   AND t04_dtl.t04_custodian =
                           m26_map.old_executing_broker_id(+)
                   AND m26_map.new_executing_broker_id = m26.m26_id(+)
                   AND t04_dtl.t04_symbol = m20.m20_symbol_code(+)
                   AND NVL (map16.map16_ntp_code, t04_dtl.t04_exchange) =
                           m20.m20_exchange_code_m01(+)
                   AND NVL (map16.map16_ntp_code, t04_dtl.t04_exchange) <>
                           'TDWL'
                   AND t04_dtl.t04_security_ac_id =
                           u07_mapped.old_trading_account_id(+)
                   AND NVL (map16.map16_ntp_code, t04_dtl.t04_exchange) =
                           u07_mapped.exchange_code(+)
                   AND u07_mapped.new_trading_account_id =
                           u24.u24_trading_acnt_id_u07(+)
                   AND NVL (map16.map16_ntp_code, t04_dtl.t04_exchange) =
                           u24.u24_exchange_code_m01(+)
                   AND t04_dtl.t04_symbol = u24.u24_symbol_code_m20(+)
                   AND t04_dtl.t04_custodian =
                           m26_mapped.old_executing_broker_id(+)
                   AND m26_mapped.new_executing_broker_id =
                           u24.u24_custodian_id_m26(+))
    LOOP
        BEGIN
            IF i.new_trading_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Trading Account Not Available',
                                         TRUE);
            END IF;

            IF i.new_executing_broker_id IS NULL
            THEN
                raise_application_error (-20001, 'Invalid Custodian', TRUE);
            END IF;

            IF i.m20_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Symbol Not Available',
                                         TRUE);
            END IF;

            IF     i.mapped_trading_acnt_id IS NOT NULL
               AND i.mapped_exchange_code IS NOT NULL
               AND i.mapped_symbol_code IS NOT NULL
               AND i.mapped_custodian IS NOT NULL
            THEN
                UPDATE dfn_ntp.u24_holdings
                   SET u24_holding_block = i.t04_sell_pending, -- u24_holding_block | t04_sell_pending + Open Withdraw / Transfer Block which is Not Available
                       u24_sell_pending = i.t04_sell_pending, -- u24_sell_pending
                       u24_buy_pending = i.t04_buy_pending, -- u24_buy_pending
                       u24_weighted_avg_price = i.t04_weighted_avg_cost, -- u24_weighted_avg_price | Column t04_weighted_avg_cost is Used as t04_weighted_avg_price is Not Available
                       u24_avg_price = i.t04_avg_price, -- u24_avg_price
                       u24_weighted_avg_cost = i.t04_weighted_avg_cost, -- u24_weighted_avg_cost
                       u24_avg_cost = i.t04_avg_cost, -- u24_avg_cost
                       u24_receivable_holding = i.t04_pending_settle, -- u24_receivable_holding
                       u24_payable_holding = i.t04_payable_holding, -- u24_payable_holding
                       u24_net_holding = i.t04_net_holdings, -- u24_net_holding
                       u24_custodian_code_m26 = i.m26_sid, -- u24_custodian_code_m26
                       u24_currency_code_m03 = i.u06_currency_code_m03, -- u24_currency_code_m03
                       u24_price_inst_type = i.m20_price_instrument_id_v34, -- u24_price_inst_type
                       u24_symbol_id_m20 = i.m20_id, -- u24_symbol_id_m20
                       u24_pledge_qty = i.t04_pledgedqty, -- u24_pledge_qty
                       u24_manual_block = i.t04_other_blocked_qty, -- u24_manual_block
                       u24_short_holdings = i.t04_short_holding, -- u24_short_holdings
                       u24_long_holdings = i.t04_long_holding, -- u24_long_holdings
                       u24_cash_account_id_u06 = i.u06_id -- u24_cash_account_id_u06
                 WHERE     u24_trading_acnt_id_u07 = i.mapped_trading_acnt_id
                       AND u24_exchange_code_m01 = i.mapped_exchange_code
                       AND u24_symbol_code_m20 = i.mapped_symbol_code
                       AND u24_custodian_id_m26 = i.mapped_custodian;
            ELSE
                INSERT
                  INTO dfn_ntp.u24_holdings (u24_custodian_id_m26,
                                             u24_holding_block,
                                             u24_sell_pending,
                                             u24_buy_pending,
                                             u24_weighted_avg_price,
                                             u24_avg_price,
                                             u24_weighted_avg_cost,
                                             u24_avg_cost,
                                             u24_receivable_holding,
                                             u24_payable_holding,
                                             u24_net_holding,
                                             u24_trading_acnt_id_u07,
                                             u24_symbol_code_m20,
                                             u24_exchange_code_m01,
                                             u24_last_update_datetime,
                                             u24_custodian_code_m26,
                                             u24_realized_gain_lost,
                                             u24_currency_code_m03,
                                             u24_price_inst_type,
                                             u24_dbseqid,
                                             u24_ordexecseq,
                                             u24_symbol_id_m20,
                                             u24_pledge_qty,
                                             u24_manual_block,
                                             u24_subscribed_qty,
                                             u24_pending_subscribe_qty,
                                             u24_short_holdings,
                                             u24_net_receivable,
                                             u24_base_holding_block,
                                             u24_base_cash_block,
                                             u24_short_holding_block,
                                             u24_maintain_margin_charged,
                                             u24_maintain_margin_block,
                                             u24_m2m_profit,
                                             u24_derivative_fixing_price,
                                             u24_long_holdings,
                                             u24_cash_account_id_u06)
                VALUES (i.new_executing_broker_id, -- u24_custodian_id_m26
                        i.t04_sell_pending, -- u24_holding_block | t04_sell_pending + Open Withdraw / Transfer Block which is Not Available
                        i.t04_sell_pending, -- u24_sell_pending
                        i.t04_buy_pending, -- u24_buy_pending
                        i.t04_weighted_avg_cost, -- u24_weighted_avg_price | Column t04_weighted_avg_cost is Used as t04_weighted_avg_price is Not Available
                        i.t04_avg_price, -- u24_avg_price
                        i.t04_weighted_avg_cost, -- u24_weighted_avg_cost
                        i.t04_avg_cost, -- u24_avg_cost
                        i.t04_pending_settle, -- u24_receivable_holding
                        i.t04_payable_holding, -- u24_payable_holding
                        i.t04_net_holdings, -- u24_net_holding
                        i.new_trading_account_id, -- u24_trading_acnt_id_u07
                        i.m20_symbol_code, -- u24_symbol_code_m20
                        i.m20_exchange_code_m01, -- u24_exchange_code_m01
                        SYSDATE, -- u24_last_update_datetime
                        i.m26_sid, -- u24_custodian_code_m26
                        0, -- u24_realized_gain_lost | Not Available
                        i.u06_currency_code_m03, -- u24_currency_code_m03
                        i.m20_price_instrument_id_v34, -- u24_price_inst_type
                        NULL, -- u24_dbseqid
                        NULL, -- u24_ordexecseq
                        i.m20_id, -- u24_symbol_id_m20
                        i.t04_pledgedqty, -- u24_pledge_qty
                        i.t04_other_blocked_qty, -- u24_manual_block
                        0, -- u24_subscribed_qty | Not Available
                        0, -- u24_pending_subscribe_qty | Not Available
                        i.t04_short_holding, -- u24_short_holdings
                        0, -- u24_net_receivable | Not Available
                        0, -- u24_base_holding_block  | Not Available
                        0, -- u24_base_cash_block | Not Available
                        NULL, -- u24_short_holding_block | Not Available
                        NULL, -- u24_maintain_margin_charged | Not Available
                        NULL, -- u24_maintain_margin_block | Not Available
                        NULL, -- u24_m2m_profit | Not Available
                        NULL, -- u24_derivative_fixing_price | Not Available
                        i.t04_long_holding, -- u24_long_holdings
                        i.u06_id -- u24_cash_account_id_u06
                                );
            END IF;

            l_rec_cnt := l_rec_cnt + 1;

            IF MOD (l_rec_cnt, 25000) = 0
            THEN
                COMMIT;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U24_HOLDINGS',
                                   'Trading Account : '
                                || i.old_trading_account_id
                                || ' | Exchange : '
                                || i.m20_exchange_code_m01
                                || ' |  Symbol: '
                                || i.m20_symbol_code
                                || ' | Custodian : '
                                || i.t04_custodian,
                                   'Trading Account : '
                                || i.new_trading_account_id
                                || ' | Exchange : '
                                || i.m20_exchange_code_m01
                                || ' | Symbol : '
                                || i.m20_symbol_code
                                || ' | Custodian : '
                                || i.new_executing_broker_id,
                                l_sqlerrm,
                                CASE
                                    WHEN     i.mapped_trading_acnt_id
                                                 IS NOT NULL
                                         AND i.mapped_exchange_code
                                                 IS NOT NULL
                                         AND i.mapped_symbol_code IS NOT NULL
                                         AND i.mapped_custodian IS NOT NULL
                                    THEN
                                        'UPDATE'
                                    ELSE
                                        'INSERT'
                                END,
                                SYSDATE);
        END;
    END LOOP;

    -- Migrate Holdings for TDWL Exchanges [Discussed]

    l_rec_cnt := 0;

    FOR i
        IN (SELECT NVL (t04.t04_sell_pending, 0) AS t04_sell_pending,
                   NVL (t04.t04_buy_pending, 0) AS t04_buy_pending,
                   NVL (t04.t04_avg_price, 0) AS t04_avg_price,
                   NVL (t04.t04_weighted_avg_cost, 0)
                       AS t04_weighted_avg_cost,
                   NVL (t04.t04_avg_cost, 0) AS t04_avg_cost,
                   NVL (t04.t04_pending_settle, 0) AS t04_pending_settle,
                   NVL (t04.t04_payable_holding, 0) AS t04_payable_holding,
                   NVL (t04.t04_net_holdings, 0) AS t04_net_holdings,
                   u07_map.new_trading_account_id,
                   m20.m20_symbol_code,
                   m20.m20_exchange_code_m01,
                   u06.u06_currency_code_m03,
                   u06.u06_id,
                   m20.m20_price_instrument_id_v34,
                   NVL (t04.t04_pledgedqty, 0) AS t04_pledgedqty,
                   NVL (t04.t04_other_blocked_qty, 0)
                       AS t04_other_blocked_qty,
                   NVL (t04.t04_subscribed_quantity, 0)
                       AS t04_subscribed_quantity,
                   NVL (t04.t04_pending_subscription, 0)
                       AS t04_pending_subscription,
                   NVL (t04.t04_short_holding, 0) AS t04_short_holding,
                   NVL (t04.t04_net_receivable, 0) AS t04_net_receivable,
                   m20.m20_id,
                   u07_map.old_trading_account_id,
                   t04.t04_maintain_margin_value,
                   t04.t04_maintain_margin_blk_amt,
                   t04.t04_m2m_settled,
                   NVL (t04.t04_derivative_avg_price, 0)
                       AS t04_derivative_avg_price,
                   NVL (t04.t04_long_holding, 0) AS t04_long_holding,
                   u24.u24_trading_acnt_id_u07 AS mapped_trading_acnt_id,
                   u24.u24_exchange_code_m01 AS mapped_exchange_code,
                   u24.u24_symbol_code_m20 AS mapped_symbol_code
              FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04,
                   mubasher_oms.u05_security_accounts@mubasher_db_link u05,
                   m02_institute_mappings m02_map,
                   map16_optional_exchanges_m01 map16,
                   u07_trading_account_mappings u07_map,
                   dfn_ntp.u07_trading_account u07,
                   dfn_ntp.u06_cash_account u06,
                   (SELECT m20_id,
                           m20_symbol_code,
                           m20_exchange_code_m01,
                           m20_price_instrument_id_v34
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20,
                   u07_trading_account_mappings u07_mapped,
                   (SELECT *
                      FROM dfn_ntp.u24_holdings
                     WHERE u24_exchange_code_m01 = 'TDWL') u24
             WHERE     t04.t04_security_ac_id = u05.u05_id
                   AND u05.u05_branch_id = m02_map.old_institute_id
                   AND t04.t04_security_ac_id =
                           u07_map.old_trading_account_id(+)
                   AND t04.t04_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, t04.t04_exchange) =
                           u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id = u07.u07_id(+)
                   AND u07.u07_cash_account_id_u06 = u06.u06_id(+)
                   AND t04.t04_symbol = m20.m20_symbol_code(+)
                   AND NVL (map16.map16_ntp_code, t04.t04_exchange) =
                           m20.m20_exchange_code_m01(+)
                   AND NVL (map16.map16_ntp_code, t04.t04_exchange) = 'TDWL'
                   AND t04.t04_security_ac_id =
                           u07_mapped.old_trading_account_id(+)
                   AND NVL (map16.map16_ntp_code, t04.t04_exchange) =
                           u07_mapped.exchange_code(+)
                   AND u07_mapped.new_trading_account_id =
                           u24.u24_trading_acnt_id_u07(+)
                   AND NVL (map16.map16_ntp_code, t04.t04_exchange) =
                           u24.u24_exchange_code_m01(+)
                   AND t04.t04_symbol = u24.u24_symbol_code_m20(+))
    LOOP
        BEGIN
            IF i.new_trading_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Trading Account Not Available',
                                         TRUE);
            END IF;

            IF i.m20_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Symbol Not Available',
                                         TRUE);
            END IF;

            IF     i.mapped_trading_acnt_id IS NOT NULL
               AND i.mapped_exchange_code IS NOT NULL
               AND i.mapped_symbol_code IS NOT NULL
            THEN
                UPDATE dfn_ntp.u24_holdings
                   SET u24_custodian_id_m26 = -1, -- u24_custodian_id_m26 | Update Later in this Script
                       u24_holding_block = i.t04_sell_pending, -- u24_holding_block | t04_sell_pending + Open Withdraw / Transfer Block which is Not Available
                       u24_sell_pending = i.t04_sell_pending, -- u24_sell_pending
                       u24_buy_pending = i.t04_buy_pending, -- u24_buy_pending
                       u24_weighted_avg_price = i.t04_weighted_avg_cost, -- u24_weighted_avg_price | Column t04_weighted_avg_cost is Used as t04_weighted_avg_price is Not Available
                       u24_avg_price = i.t04_avg_price, -- u24_avg_price
                       u24_weighted_avg_cost = i.t04_weighted_avg_cost, -- u24_weighted_avg_cost
                       u24_avg_cost = i.t04_avg_cost, -- u24_avg_cost
                       u24_receivable_holding = i.t04_pending_settle, -- u24_receivable_holding
                       u24_payable_holding = i.t04_payable_holding, -- u24_payable_holding
                       u24_net_holding = i.t04_net_holdings, -- u24_net_holding
                       u24_currency_code_m03 = i.u06_currency_code_m03, -- u24_currency_code_m03
                       u24_price_inst_type = i.m20_price_instrument_id_v34, -- u24_price_inst_type
                       u24_symbol_id_m20 = i.m20_id, -- u24_symbol_id_m20
                       u24_pledge_qty = i.t04_pledgedqty, -- u24_pledge_qty
                       u24_manual_block = i.t04_other_blocked_qty, -- u24_manual_block
                       u24_subscribed_qty = i.t04_subscribed_quantity, -- u24_subscribed_qty
                       u24_pending_subscribe_qty = i.t04_pending_subscription, -- u24_pending_subscribe_qty
                       u24_short_holdings = i.t04_short_holding, -- u24_short_holdings
                       u24_net_receivable = i.t04_net_receivable, -- u24_net_receivable
                       u24_maintain_margin_charged =
                           i.t04_maintain_margin_value, -- u24_maintain_margin_charged
                       u24_maintain_margin_block =
                           i.t04_maintain_margin_blk_amt, -- u24_maintain_margin_block
                       u24_m2m_profit = i.t04_m2m_settled, -- u24_m2m_profit
                       u24_derivative_fixing_price =
                           i.t04_derivative_avg_price, -- u24_derivative_fixing_price
                       u24_long_holdings = i.t04_long_holding, -- u24_long_holdings
                       u24_cash_account_id_u06 = i.u06_id -- u24_cash_account_id_u06
                 WHERE     u24_trading_acnt_id_u07 = i.mapped_trading_acnt_id
                       AND u24_exchange_code_m01 = i.mapped_exchange_code
                       AND u24_symbol_code_m20 = i.mapped_symbol_code;
            ELSE
                INSERT
                  INTO dfn_ntp.u24_holdings (u24_custodian_id_m26,
                                             u24_holding_block,
                                             u24_sell_pending,
                                             u24_buy_pending,
                                             u24_weighted_avg_price,
                                             u24_avg_price,
                                             u24_weighted_avg_cost,
                                             u24_avg_cost,
                                             u24_receivable_holding,
                                             u24_payable_holding,
                                             u24_net_holding,
                                             u24_trading_acnt_id_u07,
                                             u24_symbol_code_m20,
                                             u24_exchange_code_m01,
                                             u24_last_update_datetime,
                                             u24_custodian_code_m26,
                                             u24_realized_gain_lost,
                                             u24_currency_code_m03,
                                             u24_price_inst_type,
                                             u24_dbseqid,
                                             u24_ordexecseq,
                                             u24_symbol_id_m20,
                                             u24_pledge_qty,
                                             u24_manual_block,
                                             u24_subscribed_qty,
                                             u24_pending_subscribe_qty,
                                             u24_short_holdings,
                                             u24_net_receivable,
                                             u24_base_holding_block,
                                             u24_base_cash_block,
                                             u24_maintain_margin_charged,
                                             u24_maintain_margin_block,
                                             u24_m2m_profit,
                                             u24_derivative_fixing_price,
                                             u24_long_holdings,
                                             u24_cash_account_id_u06)
                VALUES (-1, -- u24_custodian_id_m26 | Update Later in this Script
                        i.t04_sell_pending, -- u24_holding_block | t04_sell_pending + Open Withdraw / Transfer Block which is Not Available
                        i.t04_sell_pending, -- u24_sell_pending
                        i.t04_buy_pending, -- u24_buy_pending
                        i.t04_weighted_avg_cost, -- u24_weighted_avg_price | Column t04_weighted_avg_cost is Used as t04_weighted_avg_price is Not Available
                        i.t04_avg_price, -- u24_avg_price
                        i.t04_weighted_avg_cost, -- u24_weighted_avg_cost
                        i.t04_avg_cost, -- u24_avg_cost
                        i.t04_pending_settle, -- u24_receivable_holding
                        i.t04_payable_holding, -- u24_payable_holding
                        i.t04_net_holdings, -- u24_net_holding
                        i.new_trading_account_id, -- u24_trading_acnt_id_u07
                        i.m20_symbol_code, -- u24_symbol_code_m20
                        i.m20_exchange_code_m01, -- u24_exchange_code_m01
                        SYSDATE, -- u24_last_update_datetime
                        NULL, -- u24_custodian_code_m26 | Update Later in Post Migration Script
                        0, -- u24_realized_gain_lost | Not Available
                        i.u06_currency_code_m03, -- u24_currency_code_m03
                        i.m20_price_instrument_id_v34, -- u24_price_inst_type
                        NULL, -- u24_dbseqid
                        NULL, -- u24_ordexecseq
                        i.m20_id, -- u24_symbol_id_m20
                        i.t04_pledgedqty, -- u24_pledge_qty
                        i.t04_other_blocked_qty, -- u24_manual_block
                        i.t04_subscribed_quantity, -- u24_subscribed_qty
                        i.t04_pending_subscription, -- u24_pending_subscribe_qty
                        i.t04_short_holding, -- u24_short_holdings
                        i.t04_net_receivable, -- u24_net_receivable
                        0, -- u24_base_holding_block | Not Available
                        0, -- u24_base_cash_block| Not Available
                        i.t04_maintain_margin_value, -- u24_maintain_margin_charged
                        i.t04_maintain_margin_blk_amt, -- u24_maintain_margin_block
                        i.t04_m2m_settled, -- u24_m2m_profit
                        i.t04_derivative_avg_price, -- u24_derivative_fixing_price
                        i.t04_long_holding, -- u24_long_holdings
                        i.u06_id -- u24_cash_account_id_u06
                                );
            END IF;

            l_rec_cnt := l_rec_cnt + 1;

            IF MOD (l_rec_cnt, 25000) = 0
            THEN
                COMMIT;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U24_HOLDINGS',
                                   'Trading Account : '
                                || i.old_trading_account_id
                                || ' | Exchange : '
                                || i.m20_exchange_code_m01
                                || ' |  Symbol: '
                                || i.m20_symbol_code,
                                   'Trading Account : '
                                || i.new_trading_account_id
                                || ' | Exchange : '
                                || i.m20_exchange_code_m01
                                || ' | Symbol : '
                                || i.m20_symbol_code,
                                l_sqlerrm,
                                CASE
                                    WHEN     i.mapped_trading_acnt_id
                                                 IS NOT NULL
                                         AND i.mapped_exchange_code
                                                 IS NOT NULL
                                         AND i.mapped_symbol_code IS NOT NULL
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

-- Updating with Default Custodian

BEGIN
    FOR i
        IN (SELECT u24.u24_exchange_code_m01, m26.m26_id, m26.m26_sid
              FROM dfn_ntp.u24_holdings u24,
                   dfn_ntp.u07_trading_account u07,
                   dfn_ntp.m43_institute_exchanges m43,
                   dfn_ntp.m26_executing_broker m26
             WHERE     u24.u24_exchange_code_m01 = m43.m43_exchange_code_m01
                   AND u24.u24_trading_acnt_id_u07 = u07.u07_id
                   AND u07.u07_institute_id_m02 = m43.m43_institute_id_m02
                   AND m43.m43_custodian_id_m26 = m26.m26_id(+)
                   AND u24.u24_custodian_id_m26 IN (-1, 0))
    LOOP
        UPDATE dfn_ntp.u24_holdings u24
           SET u24.u24_custodian_id_m26 = i.m26_id,
               u24.u24_custodian_code_m26 = i.m26_sid
         WHERE     u24.u24_exchange_code_m01 = i.u24_exchange_code_m01
               AND u24.u24_custodian_id_m26 IN (-1, 0);
    END LOOP;
END;
/

BEGIN
    dfn_ntp.sp_stat_gather ('U24_HOLDINGS');
END;
/