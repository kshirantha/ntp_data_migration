CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u06_portfolio_value
(
    customer_id,
    u07_cash_account_id_u06,
    u07_prefred_inst_type_id,
    tnx_currency,
    portfolio_value,
    urgl,
    pf_value_with_pledge
)
AS
      SELECT MAX (u07.u07_customer_id_u01) AS customer_id,
             u07.u07_cash_account_id_u06,
             MAX (u07.u07_prefred_inst_type_id) AS u07_prefred_inst_type_id,
             MAX (m20.m20_currency_code_m03) AS tnx_currency,
             SUM (
                   NVL (s_price.market_price, 0)
                 * m20.m20_lot_size
                 * (  NVL (u24.u24_net_holding, 0)
                    - DECODE (m125.m125_allow_sell_unsettle_hold,
                              1, 0,
                              NVL (u24.u24_receivable_holding, 0))
                    - NVL (u24.u24_manual_block, 0)
                    - NVL (u24.u24_pledge_qty, 0))
                 * get_exchange_rate (u06.u06_institute_id_m02,
                                      m20.m20_currency_code_m03,
                                      u06.u06_currency_code_m03,
                                      'R'))
                 AS portfolio_value,
             SUM (
                   (NVL (s_price.market_price, 0) - NVL (u24.u24_avg_cost, 0))
                 * (  NVL (u24.u24_net_holding, 0)
                    - DECODE (m125.m125_allow_sell_unsettle_hold,
                              1, 0,
                              NVL (u24.u24_receivable_holding, 0))
                    - NVL (u24.u24_manual_block, 0)
                    - NVL (u24.u24_pledge_qty, 0))
                 * m20.m20_lot_size
                 * get_exchange_rate (u06.u06_institute_id_m02,
                                      m20.m20_currency_code_m03,
                                      u06.u06_currency_code_m03,
                                      'R'))
                 AS urgl,
             SUM (
                   NVL (s_price.market_price, 0)
                 * m20.m20_lot_size
                 * (  NVL (u24.u24_net_holding, 0)
                    - DECODE (m125.m125_allow_sell_unsettle_hold,
                              1, 0,
                              NVL (u24.u24_receivable_holding, 0))
                    - NVL (u24.u24_manual_block, 0))
                 * get_exchange_rate (u06.u06_institute_id_m02,
                                      m20.m20_currency_code_m03,
                                      u06.u06_currency_code_m03,
                                      'R'))
                 AS pf_value_with_pledge
        FROM u24_holdings u24
             JOIN u07_trading_account u07
                 ON u24.u24_trading_acnt_id_u07 = u07.u07_id
                    AND u24.u24_exchange_code_m01 = u07.u07_exchange_code_m01
             JOIN u06_cash_account u06
                 ON u07.u07_cash_account_id_u06 = u06.u06_id
             JOIN m20_symbol m20
                 ON u24.u24_symbol_id_m20 = m20.m20_id
             LEFT JOIN vw_symbol_prices s_price
                 ON u24.u24_symbol_id_m20 = s_price.symbol_id
             LEFT JOIN m125_exchange_instrument_type m125
                 ON     m125.m125_instrument_type_id_v09 =
                            m20.m20_instrument_type_id_v09
                    AND m125.m125_exchange_id_m01 = m20.m20_exchange_id_m01
    GROUP BY u07.u07_cash_account_id_u06
/
