CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_book_level_conc_master
(
    u06_external_ref_no,
    u07_exchange_account_no,
    u07_exchange_code_m01,
    customer_name,
    m73_name,
    u23_margin_expiry_date,
    u23_margin_percentage,
    u23_max_margin_limit,
    limit_utilization,
    portfolio_value,
    m20_symbol_code,
    m20_short_description,
    u24_pledge_qty,
    symbol_market_value,
    symbol_marginable_value,
    m78_marginable_per,
    marginable_pv,
    no_of_shares,
    latest_market_price,
    pu_based_on_market_value,
    pu_based_on_marg_value,
    u01_id,
    u07_institute_id_m02,
    sector
)
AS
    SELECT u06_external_ref_no,
           f.u07_exchange_account_no,
           f.u07_exchange_code_m01,
           f.customer_name,
           f.m73_name,
           f.u23_margin_expiry_date,
           f.u23_margin_percentage,
           f.u23_max_margin_limit,
           f.limit_utilization,
           f.portfolio_value,
           f.m20_symbol_code,
           f.m20_short_description,
           u24_pledge_qty,
           f.symbol_market_value,
           symbol_marginable_value,
           f.m78_marginable_per,
           f.marginable_pv,
           no_of_shares,
           latest_market_price,
           CASE
               WHEN portfolio_value <> 0
               THEN
                   ROUND (
                         symbol_market_value
                       * limit_utilization
                       / portfolio_value,
                       2)
               ELSE
                   0
           END
               AS pu_based_on_market_value,
           CASE
               WHEN marginable_pv <> 0
               THEN
                   ROUND (
                         symbol_market_value
                       * limit_utilization
                       / marginable_pv,
                       2)
               ELSE
                   0
           END
               AS pu_based_on_marg_value,
           f.u01_id,
           f.u07_institute_id_m02,
           sector
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
                       AS symbol_marginable_value,
                   m73_name AS m73_name_nn,
                   m78_marginable_per AS m78_marginable_per_nn
              FROM (SELECT u06.u06_external_ref_no,
                           u07.u07_exchange_account_no,
                           u07.u07_exchange_code_m01,
                           marg.customer_name,
                           marg.m73_name,
                           marg.u23_margin_expiry_date,
                           marg.u23_margin_percentage,
                           marg.u23_max_margin_limit,
                           marg.limit_utilization,
                           marg.portfolio_value,
                           m20.m20_exchange_code_m01,
                           m20.m20_symbol_code,
                           m20.m20_short_description,
                           (  (  (  u24.u24_net_holding
                                  + u24.u24_payable_holding
                                  - u24.u24_receivable_holding)
                               - NVL (u24.u24_pledge_qty, 0))
                            * DECODE (NVL (esp.lasttradeprice, 0),
                                      0, NVL (esp.previousclosed, 0),
                                      NVL (esp.lasttradeprice, 0)
                                     )
                            * get_exchange_rate (u06.u06_institute_id_m02,
                                                 u06.u06_currency_code_m03,
                                                 'SAR',
                                                 'R'
                                                ))
                               AS symbol_market_value,
                           marg.marginable_pv,
                           u07.u07_id,
                           m20.m20_id,
                           marg.m73_id,
                           marg.u01_id,
                           marg.u07_institute_id_m02,
                           (  u24.u24_net_holding
                            + u24.u24_payable_holding
                            - u24.u24_receivable_holding
                            - u24.u24_manual_block)
                               AS no_of_shares,
                           u24.u24_pledge_qty,
                           DECODE (NVL (esp.lasttradeprice, 0),
                                   0, NVL (esp.previousclosed, 0),
                                   NVL (esp.lasttradeprice, 0)
                                  )
                               AS latest_market_price,
                           NVL (m63.m63_description, 'UNKNOWN') AS sector
                      FROM vw_stock_conc_master_rpt marg
                           JOIN u06_cash_account u06
                               ON marg.u06_external_ref_no =
                                      u06.u06_external_ref_no
                           JOIN u24_holdings u24
                               ON marg.u07_id = u24.u24_trading_acnt_id_u07
                           JOIN u07_trading_account u07
                               ON     marg.u07_id = u07.u07_id
                                  AND u24.u24_exchange_code_m01 =
                                          u07.u07_exchange_code_m01
                           JOIN m20_symbol m20
                               ON     u24.u24_symbol_id_m20 = m20.m20_id
                                  AND u24.u24_exchange_code_m01 =
                                          m20.m20_exchange_code_m01
                           LEFT JOIN m63_sectors m63
                               ON m20.m20_sectors_id_m63 = m63.m63_id
                           LEFT JOIN dfn_price.esp_todays_snapshots esp
                               ON     u24.u24_exchange_code_m01 =
                                          esp.exchangecode
                                  AND u24.u24_symbol_code_m20 = esp.symbol)
                   hold
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
                               ON m77.m77_id = m78.m78_sym_margin_group_m77)
                   mrg
                       ON     hold.m73_id = mrg.m73_id
                          AND hold.m20_id = mrg.m78_symbol_id_m20) f
/