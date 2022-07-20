CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_i_holding_details
(
    tradingaccid,
    tradingaccno,
    holdingblock,
    pendsell,
    pendbuy,
    wavgprice,
    avgprice,
    weightedavgcost,
    avgcst,
    recqty,
    payqty,
    qty,
    symbol,
    exg,
    lastupdate,
    lastupdatestr,
    custodiancode,
    curr,
    instrutyp,
    avaiqty,
    u24_holding_block,
    u24_manual_block,
    u24_pledge_qty,
    u24_subscribed_qty,
    u24_payable_holding,
    m20_strike_price,
    u07_exchange_account_no,
    m125_allow_sell_unsettle_hold,
	m01_offline_feed
)
AS
    SELECT u24_trading_acnt_id_u07 AS tradingaccid,
           u07_display_name AS tradingaccno,
           u24_holding_block AS holdingblock,
           u24_sell_pending AS pendsell,
           u24_buy_pending AS pendbuy,
           u24_weighted_avg_price AS wavgprice,
           u24_avg_price AS avgprice,
           u24_weighted_avg_cost AS weightedavgcost,
           u24_avg_cost AS avgcst,
           u24_receivable_holding AS recqty,
           u24_payable_holding AS payqty,
           u24_net_holding AS qty,
           u24_symbol_code_m20 AS symbol,
           u24_exchange_code_m01 AS exg,
           TO_CHAR (u24_last_update_datetime, 'YYYY-MM-DDTHH24:MI:SS')
               AS lastupdate,
           TO_CHAR (u24_last_update_datetime, 'YYYYMMDDHH24MISS')
               AS lastupdatestr,
           u24_custodian_id_m26 AS custodiancode,
           u24_currency_code_m03 AS curr,
           u24_price_inst_type AS instrutyp,
           (u24_net_holding - u24_sell_pending) AS avaiqty,
           u24_holding_block,
           u24_manual_block,
           u24_pledge_qty,
           u24_subscribed_qty,
           u24_payable_holding,
           m20_strike_price,
           u07_exchange_account_no,
           m125_allow_sell_unsettle_hold,
		   m01_offline_feed
      FROM u24_holdings,
           u07_trading_account,
           m20_symbol m20,
           m125_exchange_instrument_type m125,
           v09_instrument_types v09,
		   m01_exchanges m01
     WHERE     u24_trading_acnt_id_u07 = u07_id
           AND u24_symbol_id_m20 = m20_id
           AND v09.v09_id = m125.m125_instrument_type_id_v09
           AND v09.v09_code = m20.m20_instrument_type_code_v09
           AND m20.m20_exchange_id_m01 = m125.m125_exchange_id_m01
		   AND m20.m20_exchange_id_m01 = m01.m01_id
/