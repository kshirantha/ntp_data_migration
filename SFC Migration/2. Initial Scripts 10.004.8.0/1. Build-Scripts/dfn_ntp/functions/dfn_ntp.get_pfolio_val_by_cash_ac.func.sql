CREATE OR REPLACE FUNCTION dfn_ntp.get_pfolio_val_by_cash_ac (
    p_cash_ac_id           IN NUMBER,
    p_institution          IN NUMBER,
    p_computation_method   IN NUMBER,
    p_check_buy_pending    IN NUMBER,
    p_check_pledgedqty     IN NUMBER,
    p_check_sym_margin     IN NUMBER,
    p_date                 IN DATE DEFAULT SYSDATE,
    p_for_non_margin       IN NUMBER DEFAULT 0)
    RETURN NUMBER
IS
    l_return                  NUMBER (18, 5);
    l_u23_sym_margin_group    u23_customer_margin_product.u23_sym_margin_group_m77%TYPE;
    l_global_marginable_per   NUMBER (6, 3);
    l_m73_equation            NUMBER (6, 3);
BEGIN
    IF p_for_non_margin = 1
    THEN
        SELECT NVL (MAX (m77_id), -1), MAX (m77_global_marginable_per)
          INTO l_u23_sym_margin_group, l_global_marginable_per
          FROM m77_symbol_marginability_grps
         WHERE m77_is_default = 1 AND m77_institution_m02 = p_institution;
    ELSE
        SELECT NVL (MAX (u23_sym_margin_group_m77), -1),
               MAX (m73.m73_equation)
          INTO l_u23_sym_margin_group, l_m73_equation
          FROM u23_customer_margin_product u23,
               u06_cash_account a,
               m73_margin_products m73
         WHERE     u23_id = a.u06_margin_product_id_u23
               AND u23.u23_margin_product_m73 = m73.m73_id
               AND a.u06_id = p_cash_ac_id;
    END IF;

    IF TRUNC (p_date) = TRUNC (SYSDATE)
    THEN
        SELECT SUM (
                     (  (  NVL (u24.u24_net_holding, 0)
                         - NVL (u24.u24_manual_block, 0))
                      - CASE
                            WHEN p_check_pledgedqty = 1
                            THEN
                                NVL (u24.u24_pledge_qty, 0)
                            ELSE
                                0
                        END
                      + CASE
                            WHEN p_check_buy_pending = 1
                            THEN
                                NVL (u24.u24_buy_pending, 0)
                            ELSE
                                0
                        END)
                   * m20.m20_lot_size
                   * CASE p_computation_method
                         WHEN 1 -- Last Trade
                         THEN
                             s_price.market_price
                         WHEN 2 -- VWAP
                         THEN
                             NVL (s_price.vwap, 0)
                         WHEN 3 -- Previous Closed
                         THEN
                             NVL (s_price.previous_closed, 0)
                         WHEN 4 -- Closing Price
                         THEN
                             CASE
                                 WHEN NVL (s_price.todays_closed, 0) = 0
                                 THEN
                                     NVL (s_price.previous_closed, 0)
                                 ELSE
                                     NVL (s_price.todays_closed, 0)
                             END
                         ELSE -- Default
                             s_price.market_price
                     END
                   * CASE
                         WHEN     p_check_sym_margin = 1
                              AND l_m73_equation NOT IN (2, 3)
                         THEN
                             NVL (m78.m78_marginable_per,
                                  l_global_marginable_per)
                         ELSE
                             100
                     END
                   * get_exchange_rate (u06.u06_institute_id_m02,
                                        m20.m20_currency_code_m03,
                                        u06.u06_currency_code_m03,
                                        'R')
                   / 100)
          INTO l_return
          FROM u24_holdings u24,
               (SELECT m78_symbol_id_m20, m78_marginable_per
                  FROM m78_symbol_marginability
                 WHERE     m78_institution_id_m02 = p_institution
                       AND m78_mariginability = 1
                       AND m78_sym_margin_group_m77 = l_u23_sym_margin_group)
               m78,
               vw_symbol_prices s_price,
               m20_symbol m20,
               u06_cash_account u06,
               u07_trading_account u07
         WHERE     u24.u24_trading_acnt_id_u07 = u07.u07_id
               AND m20.m20_id = u24.u24_symbol_id_m20
               AND m20.m20_id = m78.m78_symbol_id_m20(+)
               AND u07.u07_cash_account_id_u06 = p_cash_ac_id
               AND u07.u07_cash_account_id_u06 = u06.u06_id
               AND u24.u24_symbol_id_m20 = s_price.symbol_id;
    ELSE
        SELECT SUM (
                     (  (  NVL (h01.h01_net_holding, 0)
                         - NVL (h01.h01_manual_block, 0))
                      - CASE
                            WHEN p_check_pledgedqty = 1
                            THEN
                                NVL (h01.h01_pledge_qty, 0)
                            ELSE
                                0
                        END
                      + CASE
                            WHEN p_check_buy_pending = 1
                            THEN
                                NVL (h01.h01_buy_pending, 0)
                            ELSE
                                0
                        END)
                   * NVL (m20.m20_lot_size, 1)
                   * CASE p_computation_method
                         WHEN 1 -- Last Trade
                         THEN
                             h01.h01_market_price
                         WHEN 2 -- VWAP
                         THEN
                             h01.h01_vwap
                         WHEN 3 -- Previous Closed
                         THEN
                             h01.h01_previous_closed
                         WHEN 4 -- Closing Price
                         THEN
                             CASE
                                 WHEN h01.h01_todays_closed = 0
                                 THEN
                                     h01.h01_previous_closed
                                 ELSE
                                     h01.h01_todays_closed
                             END
                         ELSE -- Default
                             h01.h01_market_price
                     END
                   * CASE
                         WHEN     p_check_sym_margin = 1
                              AND l_m73_equation NOT IN (2, 3)
                         THEN
                             NVL (m78.m78_marginable_per,
                                  l_global_marginable_per)
                         ELSE
                             100
                     END
                   * get_exchange_rate (u06.u06_institute_id_m02,
                                        m20.m20_currency_code_m03,
                                        u06.u06_currency_code_m03,
                                        'R')
                   / 100)
          INTO l_return
          FROM vw_h01_holding_summary h01,
               (SELECT m78_symbol_id_m20, m78_marginable_per
                  FROM m78_symbol_marginability
                 WHERE     m78_institution_id_m02 = p_institution
                       AND m78_mariginability = 1
                       AND m78_sym_margin_group_m77 = l_u23_sym_margin_group)
               m78,
               m20_symbol m20,
               u06_cash_account u06,
               u07_trading_account u07
         WHERE     h01.h01_trading_acnt_id_u07 = u07.u07_id
               AND h01.h01_date = TRUNC (p_date)
               AND m20.m20_id = h01.h01_symbol_id_m20
               AND m20.m20_id = m78.m78_symbol_id_m20(+)
               AND u07.u07_cash_account_id_u06 = p_cash_ac_id
               AND u07.u07_cash_account_id_u06 = u06.u06_id;
    END IF;

    RETURN NVL (l_return, 0);
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN 0;
END;
/