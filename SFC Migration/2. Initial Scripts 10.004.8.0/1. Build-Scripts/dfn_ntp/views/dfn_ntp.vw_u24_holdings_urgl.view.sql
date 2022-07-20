CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u24_holdings_urgl
(
    trading_account_id,
    symbol_code,
    exchange_code,
    net_holding,
    avg_cost,
    weighted_avg_cost,
    price,
    market_value,
    unrealized_gain,
    previous_closed,
    unrealize_profit,
    unrealize_profit_percent,
    currency,
    cash_account_name,
    symbol_des,
    symbol_des_lang,
    unrealized_gain_percent,
    instrument_type,
    exchange_account_no,
    cash_account_balance
)
AS
    SELECT trading_account_id,
           symbol_code,
           exchange_code,
           net_holding,
           avg_cost,
           weighted_avg_cost,
           price,
           market_value,
           unrealized_gain,
           previous_closed,
           unrealize_profit,
           unrealize_profit_percent,
           currency,
           cash_account_name,
           symbol_des,
           symbol_des_lang,
           CASE
               WHEN weighted_avg_cost <> 0
               THEN
                   ROUND ( (unrealized_gain / weighted_avg_cost) * 100, 2)
               ELSE
                   0
           END
               AS unrealized_gain_percent,
           instrument_type,
           exchange_account_no,
           cash_account_balance
      FROM (SELECT u24.u24_trading_acnt_id_u07 AS trading_account_id,
                   u24.u24_symbol_code_m20 AS symbol_code,
                   u24.u24_exchange_code_m01 AS exchange_code,
                   (  u24.u24_net_holding
                    + u24.u24_payable_holding
                    - u24.u24_receivable_holding)
                       AS net_holding,
                   u24.u24_avg_cost AS avg_cost,
                     (  u24.u24_net_holding
                      + u24.u24_payable_holding
                      - u24.u24_receivable_holding)
                   * u24.u24_avg_cost
                   * m20.m20_lot_size
                   * m20.m20_price_ratio
                       AS weighted_avg_cost,
                   s.last_trade_price AS price,
                     s.last_trade_price
                   * (  u24.u24_net_holding
                      + u24.u24_payable_holding
                      - u24.u24_receivable_holding)
                   * m20.m20_lot_size
                   * m20.m20_price_ratio
                       AS market_value,
                     CASE
                         WHEN m20.m20_instrument_type_code_v09 = 'RHT'
                         THEN
                             -1
                         ELSE
                             1
                     END
                   * (  (s.last_trade_price - u24.u24_avg_cost)
                      * (  u24.u24_net_holding
                         + u24.u24_payable_holding
                         - u24.u24_receivable_holding)
                      * m20.m20_lot_size
                      * m20.m20_price_ratio)
                       AS unrealized_gain,
                   s.previous_closed,
                     CASE
                         WHEN m20.m20_instrument_type_code_v09 = 'RHT'
                         THEN
                             -1
                         ELSE
                             1
                     END
                   * (  (  TRUNC (s.last_trade_price, 2)
                         - TRUNC (u24.u24_avg_cost, 2))
                      * (  u24.u24_net_holding
                         + u24.u24_payable_holding
                         - u24.u24_receivable_holding)
                      * m20.m20_lot_size
                      * m20.m20_price_ratio)
                       AS unrealize_profit,
                     CASE
                         WHEN m20.m20_instrument_type_code_v09 = 'RHT'
                         THEN
                             -1
                         ELSE
                             1
                     END
                   * (CASE
                          WHEN (u24.u24_avg_cost <> 0)
                          THEN
                              TRUNC (
                                  (  (  (  s.last_trade_price
                                         - u24.u24_avg_cost)
                                      / u24.u24_avg_cost)
                                   * 100),
                                  2)
                          ELSE
                              0
                      END)
                       AS unrealize_profit_percent,
                   u06.u06_currency_code_m03 AS currency,
                   u06.u06_display_name AS cash_account_name,
                   m20.m20_short_description AS symbol_des,
                   m20.m20_short_description_lang AS symbol_des_lang,
                   m20.m20_instrument_type_code_v09 AS instrument_type,
                   u07.u07_exchange_account_no AS exchange_account_no,
                   u06.u06_balance AS cash_account_balance
              FROM u24_holdings u24,
                   vw_symbol_prices s,
                   u07_trading_account u07,
                   u06_cash_account u06,
                   m20_symbol m20
             WHERE     u24.u24_symbol_id_m20 = s.symbol_id
                   AND (   u24.u24_net_holding <> 0
                        OR u24.u24_payable_holding <> 0
                        OR u24.u24_receivable_holding <> 0)
                   AND u07.u07_id = u24.u24_trading_acnt_id_u07
                   AND u06.u06_id = u07.u07_cash_account_id_u06
                   AND u24_symbol_id_m20 = m20.m20_id);
/
