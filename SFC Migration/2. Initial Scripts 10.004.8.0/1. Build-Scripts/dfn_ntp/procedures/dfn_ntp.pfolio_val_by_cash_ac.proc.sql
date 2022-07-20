CREATE OR REPLACE PROCEDURE dfn_ntp.pfolio_val_by_cash_ac (
    p_cash_ac_id     IN     NUMBER,
    portfoliovalue      OUT VARCHAR)
IS
    l_return   NUMBER (18, 5);
BEGIN
    SELECT SUM (u24.u24_net_holding * m20.m20_lasttradeprice)
      INTO l_return
      FROM u24_holdings u24
           INNER JOIN u07_trading_account u07
               ON u24.u24_trading_acnt_id_u07 = u07.u07_id
           INNER JOIN m20_symbol m20
               ON u24.u24_symbol_id_m20 = m20.m20_id
     WHERE u07.u07_cash_account_id_u06 = p_cash_ac_id;

    portfoliovalue := l_return;
END;
/
/
