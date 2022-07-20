CREATE OR REPLACE PROCEDURE dfn_ntp.sp_cust_portfoli_position_b (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    pdate          IN     DATE DEFAULT SYSDATE,
    ptradingacid   IN     NUMBER)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;

    l_qry :=
           'SELECT portfolio_id,
                 portfolio_no,
                 instrument_code_id,
                 instrument_code,
                 country_id,
                 country_name,
                 cash_balance,
                 currency,
                 symbol,
                 symbol_name,
                 symbol_name_lang,
                 quantity,
                 block_quantity,
                 cost_price,
                 cost_value,
                 market_price,
                 market_value,
                 unrealise_profit_lost,
                 short_holding,
                 (  cost_value
                  * get_exchange_rate (
                        p_institute       => u07_institute_id_m02,
                        p_from_currency   => m20_currency_code_m03,
                        p_to_currency     => ''USD''))
                     AS cost_value_usd,
                 (  market_value
                  * get_exchange_rate (
                        p_institute       => u07_institute_id_m02,
                        p_from_currency   => m20_currency_code_m03,
                        p_to_currency     => ''USD''))
                     AS market_value_usd,
                 (  unrealise_profit_lost
                  * get_exchange_rate (
                        p_institute       => u07_institute_id_m02,
                        p_from_currency   => m20_currency_code_m03,
                        p_to_currency     => ''USD''))
                     AS profit_lost_usd,
                 m20_currency_code_m03 AS symbol_currency,
                 pledge_qty,
                 availableqty,
                 trading_acnt_id_u07
            FROM (SELECT u07.u07_id AS portfolio_id,
                         u07.u07_display_name AS portfolio_no,
                         m20.m20_instrument_type_id_v09 AS instrument_code_id,
                         v09.v09_description AS instrument_code,
                         m05.m05_id AS country_id,
                         m05.m05_name AS country_name,
                           u06_balance
                         + u06_payable_blocked
                         - u06_receivable_amount
                             AS cash_balance,
                         u06.u06_currency_code_m03 AS currency,
                         u24.symbol_code_m20 AS symbol,
                         m20.m20_short_description AS symbol_name,
                         m20.m20_short_description_lang AS symbol_name_lang,
                         (  u24.net_holding
                          + u24.payable_holding
                          - u24.receivable_holding)
                             AS quantity,
                         u24.manual_block AS block_quantity,
                           u24.avg_cost
                         * get_exchange_rate (
                               p_institute       => u07.u07_institute_id_m02,
                               p_from_currency   => m20.m20_currency_code_m03,
                               p_to_currency     => u06.u06_currency_code_m03)
                             AS cost_price,
                           (  (  (  u24.net_holding
                                  - DECODE (m125.m125_allow_sell_unsettle_hold,
                                            1, 0,
                                            u24.receivable_holding)
                                  - u24.manual_block)
                               - u24.pledge_qty)
                            * ROUND (u24.avg_cost, 8)
                            * m20.m20_lot_size)
                         * get_exchange_rate (
                               p_institute       => u07.u07_institute_id_m02,
                               p_from_currency   => m20.m20_currency_code_m03,
                               p_to_currency     => u06.u06_currency_code_m03)
                         * m20.m20_price_ratio
                             AS cost_value,
                           NVL(esp.market_price,0)
                         * get_exchange_rate (
                               p_institute       => u07.u07_institute_id_m02,
                               p_from_currency   => m20.m20_currency_code_m03,
                               p_to_currency     => u06.u06_currency_code_m03)
                             AS market_price,
                           (  (  (  u24.net_holding
                                  - DECODE (m125.m125_allow_sell_unsettle_hold,
                                            1, 0,
                                            u24.receivable_holding)
                                  - u24.manual_block)
                               - u24.pledge_qty)
                            * ROUND ( NVL(esp.market_price,0), 8)
                            * m20.m20_lot_size)
                         * get_exchange_rate (
                               p_institute       => u07.u07_institute_id_m02,
                               p_from_currency   => m20.m20_currency_code_m03,
                               p_to_currency     => u06.u06_currency_code_m03)
                         * m20.m20_price_ratio
                             AS market_value,
                           ( NVL(esp.market_price,0) - u24.avg_cost)
                         * (  u24.net_holding
                            - DECODE (m125.m125_allow_sell_unsettle_hold,
                                      1, 0,
                                      u24.receivable_holding)
                            - u24.manual_block
                            - u24.pledge_qty)
                         * m20.m20_lot_size
                         * get_exchange_rate (
                               p_institute       => u07.u07_institute_id_m02,
                               p_from_currency   => m20.m20_currency_code_m03,
                               p_to_currency     => u06.u06_currency_code_m03)
                         * m20.m20_price_ratio
                             AS unrealise_profit_lost,
                         ABS (u24.short_holdings) AS short_holding,
                         u07.u07_institute_id_m02,
                         m20.m20_currency_code_m03,
                         NVL(u24.pledge_qty, 0) as pledge_qty,
                         (  u24.manual_block
                          - u24.payable_holding
                          - u24.sell_pending
                          - u24.pledge_qty)
                             AS availableqty,
                             trading_acnt_id_u07
                    FROM vw_u24_h01_holdings_all u24
                         JOIN u07_trading_account u07
                             ON     u24.trading_acnt_id_u07 = u07_id AND trading_acnt_id_u07 = '
        || ptradingacid
        || 'JOIN u06_cash_account u06
                             ON u07.u07_cash_account_id_u06 = u06_id
                         JOIN m20_symbol m20
                             ON u24.symbol_id_m20 = m20.m20_id
                         LEFT JOIN v09_instrument_types v09
                             ON m20.m20_instrument_type_id_v09 = v09.v09_id
                         JOIN m01_exchanges m01
                             ON m20.m20_exchange_id_m01 = m01.m01_id
                         LEFT JOIN m125_exchange_instrument_type m125
                             ON     m01.m01_id = m125.m125_exchange_id_m01
                                AND m20.m20_instrument_type_id_v09 =
                                        m125.m125_instrument_type_id_v09
                         LEFT JOIN vw_esp_market_price_today esp
                             ON     u24.exchange_code_m01 = exchangecode
                                AND u24.symbol_code_m20 = symbol
                         JOIN m05_country m05
                             ON m01.m01_country_id_m05 = m05.m05_id
                   WHERE     (   u24.net_holding <> 0
                              OR u24.payable_holding <> 0
                              OR u24.receivable_holding <> 0
                              OR u24.buy_pending <> 0
                              OR u24.sell_pending <> 0
                              OR u24.short_holdings <> 0)
                         AND  holding_date =  TO_DATE ('''
        || TO_CHAR (pdate, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY''))
        ORDER BY symbol';

    DBMS_OUTPUT.put_line (l_qry);

    s1 :=
        fn_get_sp_data_query (NULL,
                              l_qry,
                              NULL,
                              NULL,
                              NULL);
    s2 := fn_get_sp_row_count_query (NULL, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/