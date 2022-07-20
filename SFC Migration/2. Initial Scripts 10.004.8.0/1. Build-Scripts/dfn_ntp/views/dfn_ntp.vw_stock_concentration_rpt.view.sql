CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_stock_concentration_rpt
(
    u08_account_no,
    u07_exchange_account_no,
    customer_name,
    m73_name,
    u23_margin_expiry_date,
    u23_margin_percentage,
    limit_utilization,
    portfolio_value,
    m20_symbol_code,
    m20_short_description,
    symbol_market_value,
    m78_marginable_per,
    marginable_pv,
    pct_conc_stock,
    u01_id,
    u07_institute_id_m02,
    u07_id
)
AS
    SELECT f.u08_account_no,
           f.u07_exchange_account_no,
           f.customer_name,
           f.m73_name,
           f.u23_margin_expiry_date,
           f.u23_margin_percentage,
           f.limit_utilization,
           f.portfolio_value,
           f.m20_symbol_code,
           f.m20_short_description,
           f.symbol_market_value,
           f.m78_marginable_per,
           f.marginable_pv,
           CASE
               WHEN f.portfolio_value <> 0
               THEN
                   ROUND (100 * f.symbol_market_value / f.portfolio_value, 2)
               ELSE
                   0
           END
               AS pct_conc_stock,
           f.u01_id,
           f.u07_institute_id_m02,
           f.u07_id
      FROM (SELECT hold.*,
                   CASE
                       WHEN     mrg.m78_mariginability = 1
                            AND mrg.m78_marginable_per IS NOT NULL
                       THEN
                           mrg.m78_marginable_per
                       ELSE
                           NVL (mrg.m77_global_marginable_per, 100)
                   END
                       AS m78_marginable_per
              FROM (SELECT u08.u08_account_no,
                           marg.u07_exchange_account_no,
                           marg.customer_name,
                           marg.m73_name,
                           marg.u23_margin_expiry_date,
                           marg.u23_margin_percentage,
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
                            * get_exchange_rate (marg.u07_institute_id_m02,
                                                 marg.u06_currency_code_m03,
                                                 'SAR',
                                                 'R'
                                                ))
                               AS symbol_market_value,
                           marg.marginable_pv,
                           marg.u07_id,
                           m20.m20_id,
                           marg.m73_id,
                           marg.u01_id,
                           marg.u07_institute_id_m02
                      FROM (SELECT m73_margin_category_id_v01,
                                   m73_id,
                                   m73_name,
                                   u06_id,
                                   u06_currency_code_m03,
                                   u01_id,
                                   u01_external_ref_no,
                                   u06_external_ref_no,
                                   customer_name,
                                   u23_margin_expiry_date,
                                   u23_max_margin_limit,
                                   u23_margin_percentage,
                                   limit_utilization,
                                   CASE
                                       WHEN u23_max_margin_limit = 0
                                       THEN
                                           0
                                       ELSE
                                           ROUND (
                                                 limit_utilization
                                               * 100
                                               / u23_max_margin_limit,
                                               5)
                                   END
                                       AS utl_percentage,
                                   marginable_pv,
                                   portfolio_value,
                                   CASE
                                       WHEN limit_utilization = 0
                                       THEN
                                           999
                                       ELSE
                                           ROUND (
                                                 marginable_pv
                                               * 100
                                               / limit_utilization,
                                               2)
                                   END
                                       AS current_coverage_ratio,
                                   u23_margin_call_level_2,
                                   u23_liquidation_level,
                                   m07_name,
                                   cash_balance,
                                   ROUND (cash_balance + marginable_pv, 2)
                                       AS marg_total_collateral_value,
                                   CASE
                                       WHEN   limit_utilization
                                            - u23_max_margin_limit < 0
                                       THEN
                                           0
                                       ELSE
                                             limit_utilization
                                           - u23_max_margin_limit
                                   END
                                       AS overstepping_amount,
                                   CASE
                                       WHEN u23_liquidation_level <> 0
                                       THEN
                                              '('
                                           || ABS (
                                                  ROUND (
                                                        (  (  cash_balance
                                                            + marginable_pv)
                                                         / u23_liquidation_level)
                                                      - limit_utilization,
                                                      2))
                                           || ')'
                                   END
                                       AS over_step_amnt_tocovabv_liqlvl,
                                   CASE
                                       WHEN u23_margin_call_level_2 <> 0
                                       THEN
                                              '('
                                           || ABS (
                                                  ROUND (
                                                        (  (  cash_balance
                                                            + marginable_pv)
                                                         / u23_margin_call_level_2)
                                                      - limit_utilization,
                                                      2))
                                           || ')'
                                   END
                                       AS over_step_amnt_tocovabv_magcal,
                                   CASE
                                       WHEN u23_margin_percentage <> 0
                                       THEN
                                              '('
                                           || ABS (
                                                  ROUND (
                                                        (  (  cash_balance
                                                            + marginable_pv)
                                                         / u23_margin_percentage)
                                                      - limit_utilization,
                                                      2))
                                           || ')'
                                   END
                                       AS over_step_amnt_tocovabv_covrat,
                                   u07_id,
                                   u07_institute_id_m02,
                                   u07_exchange_code_m01,
                                   u07_exchange_account_no
                              FROM (SELECT   MAX (m73_margin_category_id_v01)
                                                 AS m73_margin_category_id_v01,
                                             MAX (m73_id) AS m73_id,
                                             MAX (m73_name) AS m73_name,
                                             MAX (u06_id) AS u06_id,
                                             MAX (u06_currency_code_m03)
                                                 AS u06_currency_code_m03,
                                             u01_id,
                                             MAX (u01_external_ref_no)
                                                 AS u01_external_ref_no,
                                             MAX (u06_external_ref_no)
                                                 AS u06_external_ref_no,
                                             MAX (customer_name)
                                                 AS customer_name,
                                             MAX (u23_margin_expiry_date)
                                                 AS u23_margin_expiry_date,
                                             MAX (u23_max_margin_limit)
                                                 AS u23_max_margin_limit,
                                             MAX (u23_margin_percentage)
                                                 AS u23_margin_percentage,
                                             CASE
                                                 WHEN SUM (limit_utilization) <
                                                          0
                                                 THEN
                                                     0
                                                 ELSE
                                                     SUM (limit_utilization)
                                             END
                                                 AS limit_utilization,
                                             SUM (portfolio_value)
                                                 AS portfolio_value,
                                             SUM (marginable_pv)
                                                 AS marginable_pv,
                                             MAX (u23_margin_call_level_2)
                                                 AS u23_margin_call_level_2,
                                             MAX (u23_liquidation_level)
                                                 AS u23_liquidation_level,
                                             m07_name,
                                             SUM (cash_balance) AS cash_balance,
                                             u07_id,
                                             u07_exchange_code_m01,
                                             u07_exchange_account_no,
                                             MAX (u07_institute_id_m02)
                                                 AS u07_institute_id_m02
                                        FROM (SELECT m73.m73_margin_category_id_v01,
                                                     m73.m73_id,
                                                     m73.m73_name,
                                                     u06_default.u06_id,
                                                     u06_default.u06_currency_code_m03,
                                                     u01.u01_id,
                                                     u01.u01_external_ref_no,
                                                     u06_default.u06_external_ref_no,
                                                     u01.u01_display_name
                                                         AS customer_name,
                                                     u23.u23_id,
                                                     u23.u23_margin_expiry_date,
                                                       u23.u23_max_margin_limit
                                                     * CASE
                                                           WHEN u23_max_limit_currency_m03 =
                                                                    'SAR'
                                                           THEN
                                                               1
                                                           ELSE
                                                               get_exchange_rate (
                                                                   u07.u07_institute_id_m02,
                                                                   u23.u23_max_limit_currency_m03,
                                                                   'SAR',
                                                                   'R')
                                                       END
                                                         AS u23_max_margin_limit,
                                                     u23.u23_margin_percentage,
                                                       CASE
                                                           WHEN (  u06.u06_balance
                                                                 + u06.u06_payable_blocked
                                                                 - u06.u06_receivable_amount) <
                                                                    0
                                                           THEN
                                                                 (  u06.u06_balance
                                                                  + u06.u06_payable_blocked
                                                                  - u06.u06_receivable_amount)
                                                               * -1
                                                           ELSE
                                                               0
                                                       END
                                                     -   u06.u06_loan_amount
                                                       * CASE
                                                             WHEN u06.u06_currency_code_m03 =
                                                                      'SAR'
                                                             THEN
                                                                 1
                                                             ELSE
                                                                 get_exchange_rate (
                                                                     u06.u06_institute_id_m02,
                                                                     u06.u06_currency_code_m03,
                                                                     'SAR',
                                                                     'R')
                                                         END
                                                         AS limit_utilization,
                                                       NVL (
                                                           get_pfolio_val_by_cash_ac (
                                                               u06.u06_id,
                                                               u06.u06_institute_id_m02,
                                                               m02.m02_price_type_for_margin,
                                                               m02.m02_add_buy_pending_for_margin,
                                                               m02.m02_add_pledge_for_bp,
                                                               0),
                                                           0)
                                                     * CASE
                                                           WHEN u06.u06_currency_code_m03 =
                                                                    'SAR'
                                                           THEN
                                                               1
                                                           ELSE
                                                               get_exchange_rate (
                                                                   u06.u06_institute_id_m02,
                                                                   u06.u06_currency_code_m03,
                                                                   'SAR',
                                                                   'R')
                                                       END
                                                         AS portfolio_value,
                                                       NVL (
                                                           get_pfolio_val_by_cash_ac (
                                                               u06.u06_id,
                                                               u06.u06_institute_id_m02,
                                                               m02.m02_price_type_for_margin,
                                                               m02.m02_add_buy_pending_for_margin,
                                                               m02.m02_add_pledge_for_bp,
                                                               1),
                                                           0)
                                                     * CASE
                                                           WHEN u06.u06_currency_code_m03 =
                                                                    'SAR'
                                                           THEN
                                                               1
                                                           ELSE
                                                               get_exchange_rate (
                                                                   u06.u06_institute_id_m02,
                                                                   u06.u06_currency_code_m03,
                                                                   'SAR',
                                                                   'R')
                                                       END
                                                         AS marginable_pv,
                                                     u23.u23_margin_call_level_2,
                                                     u23.u23_liquidation_level,
                                                     m07.m07_name,
                                                       (  u06.u06_balance
                                                        + u06.u06_payable_blocked
                                                        - u06.u06_receivable_amount)
                                                     * CASE
                                                           WHEN u06.u06_currency_code_m03 =
                                                                    'SAR'
                                                           THEN
                                                               1
                                                           ELSE
                                                               get_exchange_rate (
                                                                   u06.u06_institute_id_m02,
                                                                   u06.u06_currency_code_m03,
                                                                   'SAR',
                                                                   'R')
                                                       END
                                                         cash_balance,
                                                     u07.u07_id,
                                                     u07.u07_institute_id_m02,
                                                     u07.u07_exchange_code_m01,
                                                     u07_exchange_account_no
                                                FROM u07_trading_account u07
                                                     JOIN u06_cash_account u06
                                                         ON     u07.u07_cash_account_id_u06 =
                                                                    u06.u06_id
                                                            AND u06.u06_margin_enabled =
                                                                    1
                                                     JOIN u01_customer u01
                                                         ON u06.u06_customer_id_u01 =
                                                                u01.u01_id
                                                     JOIN
                                                     u23_customer_margin_product u23
                                                         ON     u01.u01_id =
                                                                    u23.u23_customer_id_u01
                                                            AND u06.u06_margin_product_id_u23 =
                                                                    u23.u23_id
                                                     JOIN
                                                     u06_cash_account u06_default
                                                         ON u23.u23_default_cash_acc_id_u06 =
                                                                u06_default.u06_id
                                                     JOIN
                                                     m73_margin_products m73
                                                         ON     u23.u23_margin_product_m73 =
                                                                    m73.m73_id
                                                            AND m73.m73_status_id_v01 !=
                                                                    5
                                                     LEFT JOIN m07_location m07
                                                         ON u01.u01_signup_location_id_m07 =
                                                                m07.m07_id
                                                     JOIN m02_institute m02
                                                         ON u06.u06_institute_id_m02 =
                                                                m02.m02_id)
                                    GROUP BY u01_id,
                                             u23_id,
                                             m07_name,
                                             u07_id,
                                             u07_exchange_code_m01,
                                             u07_exchange_account_no)) marg
                           JOIN
                           (SELECT   u24_trading_acnt_id_u07,
                                     u24_exchange_code_m01,
                                     u24_symbol_code_m20,
                                     u24_symbol_id_m20,
                                     SUM (u24_net_holding) u24_net_holding,
                                     SUM (u24_payable_holding)
                                         u24_payable_holding,
                                     SUM (u24_receivable_holding)
                                         u24_receivable_holding,
                                     SUM (u24_pledge_qty) u24_pledge_qty
                                FROM u24_holdings u24
                            GROUP BY u24_trading_acnt_id_u07,
                                     u24_exchange_code_m01,
                                     u24_symbol_code_m20,
                                     u24_symbol_id_m20) u24
                               ON     marg.u07_id =
                                          u24.u24_trading_acnt_id_u07
                                  AND marg.u07_exchange_code_m01 =
                                          u24.u24_exchange_code_m01
                           JOIN m20_symbol m20
                               ON     u24.u24_symbol_id_m20 = m20.m20_id
                                  AND u24.u24_exchange_code_m01 =
                                          m20.m20_exchange_code_m01
                           LEFT JOIN dfn_price.esp_todays_snapshots esp
                               ON     u24.u24_exchange_code_m01 =
                                          esp.exchangecode
                                  AND u24.u24_symbol_code_m20 = esp.symbol
                           LEFT JOIN
                           (SELECT u08.u08_customer_id_u01,
                                   u08.u08_account_no
                              FROM u08_customer_beneficiary_acc u08
                             WHERE u08.u08_is_default = 1) u08
                               ON marg.u01_id = u08.u08_customer_id_u01) hold
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