CREATE OR REPLACE PROCEDURE dfn_ntp.sp_h01_populate_holding
IS
    l_sysdate   DATE := TRUNC (func_get_eod_date ());
BEGIN
    DELETE FROM dfn_ntp.h00_dates
          WHERE h00_date = l_sysdate;

    INSERT INTO dfn_ntp.h00_dates (h00_date)
         VALUES (l_sysdate);

    DELETE FROM dfn_ntp.h01_holding_summary
          WHERE h01_date = l_sysdate;

    INSERT INTO dfn_ntp.h01_holding_summary (h01_trading_acnt_id_u07,
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
                                             h01_net_holding,
                                             h01_symbol_code_m20,
                                             h01_custodian_code_m26,
                                             h01_realized_gain_lost,
                                             h01_currency_code_m03,
                                             h01_price_inst_type,
                                             h01_pledge_qty,
                                             h01_manual_block,
                                             h01_last_trade_price,
                                             h01_vwap,
                                             h01_market_price,
                                             h01_previous_closed,
                                             h01_todays_closed,
                                             h01_short_holdings,
                                             h01_net_receivable,
                                             h01_primary_institute_id_m02,
                                             h01_subscribed_qty,
                                             h01_pending_subscribe_qty)
        SELECT u24_trading_acnt_id_u07,
               u24_exchange_code_m01,
               u24_symbol_id_m20,
               l_sysdate,
               u24_custodian_id_m26,
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
               u24_symbol_code_m20,
               u24_custodian_code_m26,
               u24_realized_gain_lost,
               u24_currency_code_m03,
               u24_price_inst_type,
               u24_pledge_qty,
               u24_manual_block,
               s_price.last_trade_price,
               s_price.vwap,
               s_price.market_price,
               s_price.previous_closed,
               s_price.todays_closed,
               u24_short_holdings,
               u24_net_receivable,
               m02.m02_primary_institute_id_m02,
               u24_subscribed_qty,
               u24_pending_subscribe_qty
          FROM u24_holdings u24
               JOIN u07_trading_account u07
                   ON u24_trading_acnt_id_u07 = u07.u07_id
               JOIN m02_institute m02
                   ON u07.u07_institute_id_m02 = m02.m02_id
               JOIN vw_symbol_prices s_price
                   ON u24.u24_symbol_id_m20 = s_price.symbol_id
         WHERE u24.u24_last_update_datetime >= l_sysdate;
END;
/

