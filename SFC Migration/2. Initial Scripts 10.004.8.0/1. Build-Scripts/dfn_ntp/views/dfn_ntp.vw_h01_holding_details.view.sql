CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_h01_holding_details
(
    h01_date,
    h01_trading_acnt_id_u07,
    h01_exchange_code_m01,
    h01_symbol_id_m20,
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
    h01_realized_gain_lost,
    h01_currency_code_m03,
    h01_price_inst_type,
    h01_pledge_qty,
    h01_manual_block,
    h01_vwap,
    h01_market_price,
    h01_todays_closed,
    h01_previous_closed,
    h01_short_holdings,
    h01_net_receivable,
    h01_last_trade_price,
    m125_allow_sell_unsettle_hold
)
AS
    SELECT h01.h01_date,
           h01.h01_trading_acnt_id_u07,
           h01.h01_exchange_code_m01,
           h01.h01_symbol_id_m20,
           h01.h01_custodian_id_m26,
           h01.h01_holding_block,
           h01.h01_sell_pending,
           h01.h01_buy_pending,
           h01.h01_weighted_avg_price,
           h01.h01_avg_price,
           h01.h01_weighted_avg_cost,
           h01.h01_avg_cost,
           h01.h01_receivable_holding,
           h01.h01_payable_holding,
           h01.h01_net_holding,
           h01.h01_symbol_code_m20,
           h01.h01_realized_gain_lost,
           h01.h01_currency_code_m03,
           h01.h01_price_inst_type,
           h01.h01_pledge_qty,
           h01.h01_manual_block,
           h01.h01_vwap,
           h01.h01_market_price,
           h01.h01_todays_closed,
           h01.h01_previous_closed,
           h01.h01_short_holdings,
           h01.h01_net_receivable,
           h01.h01_last_trade_price,
           m125_allow_sell_unsettle_hold
      FROM vw_h01_holding_summary h01
           JOIN m20_symbol m20
               ON h01.h01_symbol_id_m20 = m20_id
           JOIN v09_instrument_types v09
               ON m20.m20_instrument_type_code_v09 = v09.v09_code
           JOIN m125_exchange_instrument_type m125
               ON     v09.v09_id = m125.m125_instrument_type_id_v09
                  AND m20.m20_exchange_id_m01 = m125.m125_exchange_id_m01
/
