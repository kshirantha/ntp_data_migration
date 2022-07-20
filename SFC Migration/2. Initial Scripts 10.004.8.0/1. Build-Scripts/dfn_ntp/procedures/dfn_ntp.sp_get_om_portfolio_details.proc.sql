CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_om_portfolio_details (
    p_view           OUT SYS_REFCURSOR,
    prows            OUT NUMBER,
    pcashaccountid       NUMBER DEFAULT NULL,
    preqid               NUMBER)
IS
    l_qry            VARCHAR2 (15000);
    s1               VARCHAR2 (15000);
    s2               VARCHAR2 (15000);
    l_total_stocks   NUMBER := 0;
    status           NUMBER;
BEGIN
    status := 0;
    prows := 1;

    SELECT NVL (
               SUM (
                     (  (  u24.u24_net_holding
                         - DECODE (m125.m125_allow_sell_unsettle_hold,
                                   1, 0,
                                   u24.u24_receivable_holding
                                  )
                         - u24.u24_manual_block)
                      - u24.u24_pledge_qty)
                   * m20.m20_lot_size),
               1)
               AS qty
      INTO l_total_stocks
      FROM u24_holdings u24
           JOIN m20_symbol m20 ON u24.u24_symbol_id_m20 = m20.m20_id
           LEFT JOIN m125_exchange_instrument_type m125
               ON     m125.m125_instrument_type_id_v09 =
                          m20.m20_instrument_type_id_v09
                  AND m125.m125_exchange_id_m01 = m20.m20_exchange_id_m01
           JOIN u07_trading_account u07
               ON     u24_trading_acnt_id_u07 = u07.u07_id
                  AND u07.u07_cash_account_id_u06 = pcashaccountid;

    OPEN p_view FOR
        SELECT hol.u07_cash_account_id_u06,
               hol.u07_institute_id_m02,
               hol.u24_symbol_code_m20,
               hol.short_description,
               hol.short_description_lang,
               hol.u24_currency_code_m03,
               ROUND (hol.market_price, 2) AS market_price,
               hol.quantity,
               hol.quantity * hol.market_price AS market_value,
               ROUND (hol.quantity / l_total_stocks, 2) * 100
                   AS stock_concen_per,
               NVL (sym_marg.m78_marginable_per,
                    hol.m77_global_marginable_per
                   )
                   AS marginability,
                 hol.quantity
               * hol.market_price
               * NVL (sym_marg.m78_marginable_per,
                      hol.m77_global_marginable_per
                     )
               / 100
                   AS margin_value
          FROM (SELECT u07.u07_cash_account_id_u06,
                       u07.u07_institute_id_m02,
                       u24.u24_symbol_code_m20,
                       u24.u24_currency_code_m03,
                       NVL (m20.m20_short_description, m20.m20_symbol_code)
                           AS short_description,
                       NVL (m20.m20_short_description_lang,
                            m20.m20_symbol_code
                           )
                           AS short_description_lang,
                       s_price.market_price,
                         (  (  u24.u24_net_holding
                             - DECODE (m125.m125_allow_sell_unsettle_hold,
                                       1, 0,
                                       u24.u24_receivable_holding
                                      )
                             - u24.u24_manual_block)
                          - u24.u24_pledge_qty)
                       * m20.m20_lot_size
                           AS quantity,
                       m73_symbol_margblty_grp_id_m77,
                       m20_id,
                       m77_global_marginable_per
                  FROM u24_holdings u24
                       JOIN u07_trading_account u07
                           ON     u24.u24_trading_acnt_id_u07 = u07.u07_id
                              AND u07.u07_cash_account_id_u06 =
                                      pcashaccountid
                       JOIN t73_om_margin_trading_request t73
                           ON     t73.t73_cash_account_id_u06 =
                                      u07_cash_account_id_u06
                              AND t73.t73_id = preqid
                       JOIN m20_symbol m20
                           ON u24.u24_symbol_id_m20 = m20.m20_id
                       JOIN m73_margin_products m73
                           ON t73_margin_product_id_m73 = m73.m73_id
                       JOIN m77_symbol_marginability_grps m77
                           ON m77.m77_id = m73.m73_symbol_margblty_grp_id_m77
                       LEFT JOIN m125_exchange_instrument_type m125
                           ON     m125.m125_instrument_type_id_v09 =
                                      m20.m20_instrument_type_id_v09
                              AND m125.m125_exchange_id_m01 =
                                      m20.m20_exchange_id_m01
                       LEFT JOIN vw_symbol_prices s_price
                           ON u24.u24_symbol_id_m20 = s_price.symbol_id
                 WHERE (   u24.u24_net_holding <> 0
                        OR u24.u24_payable_holding <> 0
                        OR u24.u24_receivable_holding <> 0
                        OR u24.u24_buy_pending <> 0
                        OR u24.u24_sell_pending <> 0)) hol
               LEFT JOIN
               (SELECT m78_symbol_id_m20,
                       m78_marginable_per,
                       m78.m78_sym_margin_group_m77
                  FROM m78_symbol_marginability m78) sym_marg
                   ON     sym_marg.m78_sym_margin_group_m77 =
                              hol.m73_symbol_margblty_grp_id_m77
                      AND hol.m20_id = sym_marg.m78_symbol_id_m20;

    status := 1;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        status := -2;
    WHEN OTHERS
    THEN
        status := -3;
END;
/