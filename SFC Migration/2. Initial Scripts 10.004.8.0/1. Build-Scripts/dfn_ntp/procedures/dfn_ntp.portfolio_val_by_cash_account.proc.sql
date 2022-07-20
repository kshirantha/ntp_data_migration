CREATE OR REPLACE PROCEDURE dfn_ntp.portfolio_val_by_cash_account (
   p_view            OUT SYS_REFCURSOR,
   prows             OUT NUMBER,
   p_cash_ac_id   IN     NUMBER)
IS
   l_return   NUMBER (18, 5);
BEGIN
   OPEN p_view FOR
      SELECT SUM (
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
                AS portfoliovalue
        FROM u24_holdings u24
             JOIN u07_trading_account u07
                ON u24.u24_trading_acnt_id_u07 = u07.u07_id
             JOIN u06_cash_account u06
                ON u07.u07_cash_account_id_u06 = u06.u06_id
             JOIN m20_symbol m20 ON u24.u24_symbol_id_m20 = m20.m20_id
             LEFT JOIN vw_symbol_prices s_price
                ON u24.u24_symbol_id_m20 = s_price.symbol_id
             LEFT JOIN m125_exchange_instrument_type m125
                ON     m125.m125_instrument_type_id_v09 =
                          m20.m20_instrument_type_id_v09
                   AND m125.m125_exchange_code_m01 =
                          m20.m20_exchange_code_m01
       WHERE u07.u07_cash_account_id_u06 = p_cash_ac_id;
END;
/