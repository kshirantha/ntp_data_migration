CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_h01_holding_summary
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
	m01_offline_feed
)
AS
    SELECT h00.h00_date AS h01_date,
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
		   m01.m01_offline_feed
      FROM h01_holding_summary_all h01
           JOIN u24_holdings u24
               ON     h01.h01_trading_acnt_id_u07 =
                          u24.u24_trading_acnt_id_u07
                  AND h01.h01_symbol_id_m20 = u24.u24_symbol_id_m20
                  AND h01.h01_custodian_id_m26 = u24.u24_custodian_id_m26
           JOIN h00_dates h00
               ON h01.h01_date =
                      fn_get_latest_h01_date (u24.u24_trading_acnt_id_u07,
                                              u24.u24_exchange_code_m01,
                                              u24.u24_symbol_id_m20,
                                              h00.h00_date,
                                              u24.u24_custodian_id_m26)
			JOIN m01_exchanges m01
               ON h01.h01_exchange_code_m01 = m01.m01_exchange_code
                  AND h01.h01_primary_institute_id_m02 = m01.m01_institute_id_m02
/
