CREATE OR REPLACE PROCEDURE dfn_ntp.sp_marginable_pf_valuation_rpt (
    p_view                 OUT SYS_REFCURSOR,
    prows                  OUT NUMBER,
    pt02_trd_acnt_id_u07       NUMBER,
    pdate                      DATE)
IS
BEGIN
    IF TRUNC (pdate) = TRUNC (SYSDATE)
    THEN
        OPEN p_view FOR
            SELECT   f.u07_id,
                     f.u07_institute_id_m02,
                     f.u06_external_ref_no,
                     f.u07_exchange_account_no,
                     f.u07_exchange_code_m01,
                     f.m20_id,
                     f.m73_id,
                     f.u23_max_margin_limit AS u22_max_margin_limit,
                     f.limit_utilization,
                     f.portfolio_value,
                     f.m20_symbol_code AS t04_symbol,
                     f.m20_short_description AS m107_long_description,
                     u24_pledge_qty AS t04_pledgedqty,
                     f.symbol_market_value,
                     symbol_marginable_value AS margin_market_value,
                     f.m78_marginable_per AS margin_per,
                     f.marginable_pv,
                     u24_net_holding AS t04_net_holdings,
                     availableqty,
                     ROUND (u24_avg_price, 8) AS t04_avg_price,
                     latest_market_price AS market_price,
                     u24_total_cost AS t04_total_cost,
                     market_value,
                     profit,
                     u06_currency_code_m03 AS currency,
                     cash_balance,
                     current_overdraft_ratio,
                     u23_margin_call_level_1 AS u22_margin_call_level_1
                FROM (SELECT hold.*,
                             CASE
                                 WHEN     mrg.m78_mariginability = 1
                                      AND mrg.m78_marginable_per IS NOT NULL
                                 THEN
                                     mrg.m78_marginable_per
                                 ELSE
                                     mrg.m77_global_marginable_per
                             END
                                 AS m78_marginable_per,
                               (symbol_market_value / 100)
                             * (CASE
                                    WHEN     mrg.m78_mariginability = 1
                                         AND mrg.m78_marginable_per IS NOT NULL
                                    THEN
                                        m78_marginable_per
                                    ELSE
                                        mrg.m77_global_marginable_per
                                END)
                                 AS symbol_marginable_value
                        FROM (SELECT u07.u07_id,
                                     u07.u07_institute_id_m02,
                                     u06.u06_external_ref_no,
                                     u07.u07_exchange_account_no,
                                     u07.u07_exchange_code_m01,
                                     m20.m20_id,
                                     marg.m73_id,
                                     marg.u23_max_margin_limit,
                                     marg.limit_utilization,
                                     marg.portfolio_value,
                                     m20.m20_exchange_code_m01,
                                     m20.m20_symbol_code,
                                     m20.m20_short_description,
                                     (  (  u24.u24_net_holding
                                         + u24.u24_payable_holding
                                         - DECODE (
                                               m125.m125_allow_sell_unsettle_hold,
                                               1, 0,
                                               u24.u24_receivable_holding)
                                         - NVL (u24.u24_pledge_qty, 0))
                                      * DECODE (NVL (esp.lasttradeprice, 0),
                                                0, NVL (esp.previousclosed, 0),
                                                NVL (esp.lasttradeprice, 0)
                                               )
                                      * get_exchange_rate (
                                            u06.u06_institute_id_m02,
                                            u06.u06_currency_code_m03,
                                            'SAR',
                                            'R'))
                                         AS symbol_market_value,
                                     marg.marginable_pv,
                                     (  u24.u24_net_holding
                                      + u24.u24_payable_holding
                                      - u24.u24_receivable_holding
                                      - u24.u24_manual_block)
                                         AS u24_net_holding,
                                     (  (  u24.u24_net_holding
                                         - DECODE (
                                               m125.m125_allow_sell_unsettle_hold,
                                               1, 0,
                                               u24.u24_receivable_holding)
                                         - u24.u24_manual_block)
                                      - u24.u24_holding_block
                                      - u24.u24_pledge_qty)
                                         AS availableqty,
                                     u24.u24_pledge_qty,
                                     DECODE (NVL (esp.lasttradeprice, 0),
                                             0, NVL (esp.previousclosed, 0),
                                             NVL (esp.lasttradeprice, 0)
                                            )
                                         AS latest_market_price,
                                     u24.u24_avg_price,
                                     (  (  u24.u24_net_holding
                                         + u24.u24_payable_holding
                                         - DECODE (
                                               m125.m125_allow_sell_unsettle_hold,
                                               1, 0,
                                               u24.u24_receivable_holding)
                                         - u24.u24_manual_block)
                                      * ROUND (u24.u24_avg_cost, 8)
                                      * get_exchange_rate (
                                            u06.u06_institute_id_m02,
                                            u06.u06_currency_code_m03,
                                            'SAR',
                                            'R'))
                                         AS u24_total_cost,
                                       (CASE
                                            WHEN esp.lasttradeprice > 0
                                            THEN
                                                ROUND (esp.lasttradeprice, 8)
                                            ELSE
                                                ROUND (esp.previousclosed, 8)
                                        END)
                                     * (  u24.u24_net_holding
                                        + u24.u24_payable_holding
                                        - DECODE (
                                              m125.m125_allow_sell_unsettle_hold,
                                              1, 0,
                                              u24.u24_receivable_holding)
                                        - u24.u24_manual_block)
                                     * get_exchange_rate (
                                           u06.u06_institute_id_m02,
                                           u06.u06_currency_code_m03,
                                           'SAR',
                                           'R')
                                         AS market_value,
                                       (CASE
                                            WHEN esp.lasttradeprice > 0
                                            THEN
                                                  ROUND (esp.lasttradeprice, 8)
                                                - ROUND (u24.u24_avg_cost, 8)
                                            ELSE
                                                  ROUND (esp.previousclosed, 8)
                                                - ROUND (u24.u24_avg_cost, 8)
                                        END)
                                     * (  u24.u24_net_holding
                                        + u24.u24_payable_holding
                                        - DECODE (
                                              m125.m125_allow_sell_unsettle_hold,
                                              1, 0,
                                              u24.u24_receivable_holding)
                                        - u24.u24_manual_block
                                        - u24.u24_pledge_qty)
                                     * get_exchange_rate (
                                           u06.u06_institute_id_m02,
                                           u06.u06_currency_code_m03,
                                           'SAR',
                                           'R')
                                         AS profit,
                                     CASE
                                         WHEN     (esp.lasttradeprice > 0)
                                              AND (u24.u24_avg_cost <> 0)
                                         THEN
                                             TRUNC (
                                                 (  (  (  esp.lasttradeprice
                                                        - u24.u24_avg_cost)
                                                     / u24.u24_avg_cost)
                                                  * 100),
                                                 2)
                                         WHEN (u24.u24_avg_cost <> 0)
                                         THEN
                                             TRUNC (
                                                 (  (  (  esp.previousclosed
                                                        - u24.u24_avg_cost)
                                                     / u24.u24_avg_cost)
                                                  * 100),
                                                 2)
                                         ELSE
                                             0
                                     END
                                         AS profitpercentage,
                                     u06.u06_currency_code_m03,
                                     marg.cash_balance,
                                     CASE
                                         WHEN marg.limit_utilization <> 0
                                         THEN
                                             ROUND (
                                                   100
                                                 * (  limit_utilization
                                                    / marg.marginable_pv),
                                                 2)
                                         ELSE
                                             0
                                     END
                                         AS current_overdraft_ratio,
                                     marg.u23_margin_call_level_1
                                FROM (SELECT *
                                        FROM u24_holdings
                                       WHERE u24_trading_acnt_id_u07 =
                                                 pt02_trd_acnt_id_u07) u24
                                     JOIN u07_trading_account u07
                                         ON     u24.u24_trading_acnt_id_u07 =
                                                    u07.u07_id
                                            AND u24.u24_exchange_code_m01 =
                                                    u07.u07_exchange_code_m01
                                     LEFT JOIN vw_stock_conc_master_rpt marg
                                         ON     u24.u24_trading_acnt_id_u07 =
                                                    marg.u07_id
                                            AND marg.u07_id = u07.u07_id
                                     JOIN u06_cash_account u06
                                         ON u07.u07_cash_account_id_u06 =
                                                u06.u06_id
                                     JOIN m20_symbol m20
                                         ON     u24.u24_symbol_id_m20 =
                                                    m20.m20_id
                                            AND u24.u24_exchange_code_m01 =
                                                    m20.m20_exchange_code_m01
                                            AND m20.m20_instrument_type_code_v09 !=
                                                    'BN'
                                     LEFT JOIN
                                     m125_exchange_instrument_type m125
                                         ON     m125.m125_instrument_type_id_v09 =
                                                    m20.m20_instrument_type_id_v09
                                            AND m125.m125_exchange_id_m01 =
                                                    m20.m20_exchange_id_m01
                                     LEFT JOIN
                                     dfn_price.esp_todays_snapshots esp
                                         ON     u24.u24_exchange_code_m01 =
                                                    esp.exchangecode
                                            AND u24.u24_symbol_code_m20 =
                                                    esp.symbol) hold
                             LEFT JOIN
                             (SELECT m78.m78_symbol_id_m20,
                                     m78.m78_mariginability,
                                     m77.m77_global_marginable_per,
                                     m78.m78_marginable_per,
                                     m77.m77_id,
                                     m73.m73_id
                                FROM m73_margin_products m73
                                     JOIN m77_symbol_marginability_grps m77
                                         ON m73.m73_symbol_margblty_grp_id_m77 =
                                                m77.m77_id
                                     JOIN m78_symbol_marginability m78
                                         ON m77.m77_id =
                                                m78.m78_sym_margin_group_m77)
                             mrg
                                 ON     hold.m73_id = mrg.m73_id
                                    AND hold.m20_id = mrg.m78_symbol_id_m20) f
            ORDER BY f.m20_symbol_code;
    ELSE
        OPEN p_view FOR
            SELECT   f.u07_id,
                     f.u07_institute_id_m02,
                     f.u06_external_ref_no,
                     f.u07_exchange_account_no,
                     f.u07_exchange_code_m01,
                     f.m20_id,
                     f.m73_id,
                     f.u23_max_margin_limit AS u22_max_margin_limit,
                     f.limit_utilization,
                     f.portfolio_value,
                     f.m20_symbol_code AS t04_symbol,
                     f.m20_short_description AS m107_long_description,
                     h01_pledge_qty AS t04_pledgedqty,
                     f.symbol_market_value,
                     symbol_marginable_value AS margin_market_value,
                     f.m78_marginable_per AS margin_per,
                     f.marginable_pv,
                     h01_net_holding AS t04_net_holdings,
                     availableqty,
                     ROUND (h01_avg_price, 8) AS t04_avg_price,
                     latest_market_price AS market_price,
                     h01_total_cost AS t04_total_cost,
                     market_value,
                     profit,
                     u06_currency_code_m03 AS currency,
                     cash_balance,
                     current_overdraft_ratio,
                     u23_margin_call_level_1 AS u22_margin_call_level_1
                FROM (SELECT hold.*,
                             CASE
                                 WHEN     mrg.m78_mariginability = 1
                                      AND mrg.m78_marginable_per IS NOT NULL
                                 THEN
                                     mrg.m78_marginable_per
                                 ELSE
                                     mrg.m77_global_marginable_per
                             END
                                 AS m78_marginable_per,
                               (symbol_market_value / 100)
                             * (CASE
                                    WHEN     mrg.m78_mariginability = 1
                                         AND mrg.m78_marginable_per IS NOT NULL
                                    THEN
                                        m78_marginable_per
                                    ELSE
                                        mrg.m77_global_marginable_per
                                END)
                                 AS symbol_marginable_value
                        FROM (SELECT u07.u07_id,
                                     u07.u07_institute_id_m02,
                                     u06.u06_external_ref_no,
                                     u07.u07_exchange_account_no,
                                     u07.u07_exchange_code_m01,
                                     m20.m20_id,
                                     marg.m73_id,
                                     marg.u23_max_margin_limit,
                                     marg.limit_utilization,
                                     marg.portfolio_value,
                                     m20.m20_exchange_code_m01,
                                     m20.m20_symbol_code,
                                     m20.m20_short_description,
                                     (  (  h01.h01_net_holding
                                         + h01.h01_payable_holding
                                         - DECODE (
                                               m125.m125_allow_sell_unsettle_hold,
                                               1, 0,
                                               h01.h01_receivable_holding)
                                         - NVL (h01.h01_pledge_qty, 0))
                                      * NVL (esp.close, 0)
                                      * get_exchange_rate (
                                            u06.u06_institute_id_m02,
                                            u06.u06_currency_code_m03,
                                            'SAR',
                                            'R'))
                                         AS symbol_market_value,
                                     marg.marginable_pv,
                                     (  h01.h01_net_holding
                                      + h01.h01_payable_holding
                                      - h01.h01_receivable_holding
                                      - h01.h01_manual_block)
                                         AS h01_net_holding,
                                     (  (  h01.h01_net_holding
                                         - DECODE (
                                               m125.m125_allow_sell_unsettle_hold,
                                               1, 0,
                                               h01.h01_receivable_holding)
                                         - h01.h01_manual_block)
                                      - h01.h01_holding_block
                                      - h01.h01_pledge_qty)
                                         AS availableqty,
                                     h01.h01_pledge_qty,
                                     NVL (esp.close, 0) AS latest_market_price,
                                     h01.h01_avg_price,
                                     (  (  h01.h01_net_holding
                                         + h01.h01_payable_holding
                                         - DECODE (
                                               m125.m125_allow_sell_unsettle_hold,
                                               1, 0,
                                               h01.h01_receivable_holding)
                                         - h01.h01_manual_block)
                                      * ROUND (h01.h01_avg_cost, 8)
                                      * get_exchange_rate (
                                            u06.u06_institute_id_m02,
                                            u06.u06_currency_code_m03,
                                            'SAR',
                                            'R'))
                                         AS h01_total_cost,
                                       (CASE
                                            WHEN esp.lasttradeprice > 0
                                            THEN
                                                ROUND (esp.lasttradeprice, 8)
                                            ELSE
                                                ROUND (esp.previousclosed, 8)
                                        END)
                                     * (  h01.h01_net_holding
                                        + h01.h01_payable_holding
                                        - DECODE (
                                              m125.m125_allow_sell_unsettle_hold,
                                              1, 0,
                                              h01.h01_receivable_holding)
                                        - h01.h01_manual_block)
                                     * get_exchange_rate (
                                           u06.u06_institute_id_m02,
                                           u06.u06_currency_code_m03,
                                           'SAR',
                                           'R')
                                         AS market_value,
                                       (CASE
                                            WHEN esp.close > 0
                                            THEN
                                                  ROUND (esp.close, 8)
                                                - ROUND (h01.h01_avg_cost, 8)
                                            ELSE
                                                  ROUND (esp.previousclosed, 8)
                                                - ROUND (h01.h01_avg_cost, 8)
                                        END)
                                     * (  h01.h01_net_holding
                                        + h01.h01_payable_holding
                                        - DECODE (
                                              m125.m125_allow_sell_unsettle_hold,
                                              1, 0,
                                              h01.h01_receivable_holding)
                                        - h01.h01_manual_block
                                        - h01.h01_pledge_qty)
                                     * get_exchange_rate (
                                           u06.u06_institute_id_m02,
                                           u06.u06_currency_code_m03,
                                           'SAR',
                                           'R')
                                         AS profit,
                                     CASE
                                         WHEN     (esp.lasttradeprice > 0)
                                              AND (h01.h01_avg_cost <> 0)
                                         THEN
                                             TRUNC (
                                                 (  (  (  esp.close
                                                        - h01.h01_avg_cost)
                                                     / h01.h01_avg_cost)
                                                  * 100),
                                                 2)
                                         WHEN (h01.h01_avg_cost <> 0)
                                         THEN
                                             TRUNC (
                                                 (  (  (  esp.previousclosed
                                                        - h01.h01_avg_cost)
                                                     / h01.h01_avg_cost)
                                                  * 100),
                                                 2)
                                         ELSE
                                             0
                                     END
                                         AS profitpercentage,
                                     u06.u06_currency_code_m03,
                                     marg.cash_balance,
                                     CASE
                                         WHEN marg.limit_utilization <> 0
                                         THEN
                                             ROUND (
                                                   100
                                                 * (  limit_utilization
                                                    / marg.marginable_pv),
                                                 2)
                                         ELSE
                                             0
                                     END
                                         AS current_overdraft_ratio,
                                     marg.u23_margin_call_level_1
                                FROM (SELECT *
                                        FROM vw_h01_holding_summary h01
                                       WHERE     h01.h01_trading_acnt_id_u07 =
                                                     pt02_trd_acnt_id_u07
                                             AND h01_date = TRUNC (pdate)) h01
                                     JOIN u07_trading_account u07
                                         ON     h01.h01_trading_acnt_id_u07 =
                                                    u07.u07_id
                                            AND h01.h01_exchange_code_m01 =
                                                    u07.u07_exchange_code_m01
                                     LEFT JOIN vw_stock_conc_master_rpt marg
                                         ON marg.u07_id = u07.u07_id
                                     JOIN u06_cash_account u06
                                         ON u07.u07_cash_account_id_u06 =
                                                u06.u06_id
                                     JOIN m20_symbol m20
                                         ON     h01.h01_symbol_id_m20 =
                                                    m20.m20_id
                                            AND h01.h01_exchange_code_m01 =
                                                    m20.m20_exchange_code_m01
                                            AND m20.m20_instrument_type_code_v09 !=
                                                    'BN'
                                     LEFT JOIN
                                     m125_exchange_instrument_type m125
                                         ON     m125.m125_instrument_type_id_v09 =
                                                    m20.m20_instrument_type_id_v09
                                            AND m125.m125_exchange_id_m01 =
                                                    m20.m20_exchange_id_m01
                                     LEFT JOIN
                                     (SELECT *
                                        FROM dfn_price.esp_transactions_complete
                                       WHERE transactiondate = TRUNC (pdate))
                                     esp
                                         ON     h01.h01_exchange_code_m01 =
                                                    esp.exchangecode
                                            AND h01.h01_symbol_code_m20 =
                                                    esp.symbol) hold
                             LEFT JOIN
                             (SELECT m78.m78_symbol_id_m20,
                                     m78.m78_mariginability,
                                     m77.m77_global_marginable_per,
                                     m78.m78_marginable_per,
                                     m77.m77_id,
                                     m73.m73_id
                                FROM m73_margin_products m73
                                     JOIN m77_symbol_marginability_grps m77
                                         ON m73.m73_symbol_margblty_grp_id_m77 =
                                                m77.m77_id
                                     JOIN m78_symbol_marginability m78
                                         ON m77.m77_id =
                                                m78.m78_sym_margin_group_m77)
                             mrg
                                 ON     hold.m73_id = mrg.m73_id
                                    AND hold.m20_id = mrg.m78_symbol_id_m20) f
            ORDER BY f.m20_symbol_code;
    END IF;
END;
/