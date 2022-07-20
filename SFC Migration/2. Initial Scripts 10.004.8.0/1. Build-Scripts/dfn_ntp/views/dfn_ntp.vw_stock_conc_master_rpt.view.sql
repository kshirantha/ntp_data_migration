CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_stock_conc_master_rpt
(
    m73_margin_category_id_v01,
    m73_id,
    m73_name,
    u06_id,
    u06_currency_id_m03,
    u01_id,
    u01_external_ref_no,
    u06_external_ref_no,
    customer_name,
    u23_margin_expiry_date,
    u23_max_margin_limit,
    u23_margin_percentage,
    limit_utilization,
    utl_percentage,
    marginable_pv,
    portfolio_value,
    current_coverage_ratio,
    u23_margin_call_level_2,
    u23_liquidation_level,
    m07_name,
    cash_balance,
    marg_total_collateral_value,
    overstepping_amount,
    over_step_amnt_tocovabv_liqlvl,
    over_step_amnt_tocovabv_magcal,
    over_step_amnt_tocovabv_covrat,
    u07_id,
    u07_institute_id_m02,
    u23_margin_call_level_1
)
AS
    SELECT m73_margin_category_id_v01,
           m73_id,
           m73_name,
           u06_id,
           u06_currency_id_m03,
           u01_id,
           u01_external_ref_no,
           u06_external_ref_no,
           customer_name,
           u23_margin_expiry_date,
           u23_max_margin_limit,
           u23_margin_percentage,
           limit_utilization,
           CASE
               WHEN u23_max_margin_limit = 0 THEN 0
               ELSE ROUND (limit_utilization * 100 / u23_max_margin_limit, 5)
           END
               AS utl_percentage,
           marginable_pv,
           portfolio_value,
           CASE
               WHEN limit_utilization = 0 THEN 999
               ELSE ROUND (marginable_pv * 100 / limit_utilization, 2)
           END
               AS current_coverage_ratio,
           u23_margin_call_level_2,
           u23_liquidation_level,
           m07_name,
           cash_balance,
           ROUND (cash_balance + marginable_pv, 2)
               AS marg_total_collateral_value,
           CASE
               WHEN limit_utilization - u23_max_margin_limit < 0 THEN 0
               ELSE limit_utilization - u23_max_margin_limit
           END
               AS overstepping_amount,
           CASE
               WHEN u23_liquidation_level <> 0
               THEN
                      '('
                   || ABS (
                          ROUND (
                                (  (cash_balance + marginable_pv)
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
                                (  (cash_balance + marginable_pv)
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
                                (  (cash_balance + marginable_pv)
                                 / u23_margin_percentage)
                              - limit_utilization,
                              2))
                   || ')'
           END
               AS over_step_amnt_tocovabv_covrat,
           u07_id,
           u07_institute_id_m02,
           u23_margin_call_level_1
      FROM (SELECT MAX (m73_margin_category_id_v01)
                       AS m73_margin_category_id_v01,
                   MAX (m73_id) AS m73_id,
                   MAX (m73_name) AS m73_name,
                   NULL AS u06_id,
                   MAX (u06_currency_id_m03) AS u06_currency_id_m03,
                   u01_id,
                   MAX (u01_external_ref_no) AS u01_external_ref_no,
                   MAX (u06_external_ref_no) AS u06_external_ref_no,
                   MAX (customer_name) AS customer_name,
                   MAX (u23_margin_expiry_date) AS u23_margin_expiry_date,
                   MAX (u23_max_margin_limit) AS u23_max_margin_limit,
                   MAX (u23_margin_percentage) AS u23_margin_percentage,
                   CASE
                       WHEN SUM (limit_utilization) < 0 THEN 0
                       ELSE SUM (limit_utilization)
                   END
                       AS limit_utilization,
                   SUM (portfolio_value) AS portfolio_value,
                   SUM (marginable_pv) AS marginable_pv,
                   MAX (u23_margin_call_level_2) AS u23_margin_call_level_2,
                   MAX (u23_liquidation_level) AS u23_liquidation_level,
                   m07_name,
                   SUM (cash_balance) AS cash_balance,
                   u07_id,
                   MAX (u07_institute_id_m02) AS u07_institute_id_m02,
                   MAX (u23_margin_call_level_1) AS u23_margin_call_level_1
              FROM (SELECT m73.m73_margin_category_id_v01,
                           m73.m73_id,
                           m73.m73_name,
                           u06.u06_id,
                           u06.u06_currency_id_m03,
                           u01.u01_id,
                           u01.u01_external_ref_no,
                           u06.u06_external_ref_no,
                           u01.u01_display_name AS customer_name,
                           u23.u23_id,
                           u23.u23_margin_expiry_date,
                             u23.u23_max_margin_limit
                           * get_exchange_rate (
                                 u07.u07_institute_id_m02,
                                 u23.u23_max_limit_currency_m03,
                                 'SAR',
                                 'R')
                               AS u23_max_margin_limit,
                           u23.u23_margin_percentage,
                             CASE
                                 WHEN (  u06.u06_balance
                                       + u06.u06_payable_blocked
                                       - u06.u06_receivable_amount) < 0
                                 THEN
                                       (  u06.u06_balance
                                        + u06.u06_payable_blocked
                                        - u06.u06_receivable_amount)
                                     * -1
                                 ELSE
                                     0
                             END
                           +   u06.u06_loan_amount
                             * get_exchange_rate (u06.u06_institute_id_m02,
                                                  u06.u06_currency_code_m03,
                                                  'SAR',
                                                  'R')
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
                               AS marginable_pv,
                           u23.u23_margin_call_level_2,
                           u23.u23_liquidation_level,
                           m07.m07_name,
                             (  u06.u06_balance
                              + u06.u06_payable_blocked
                              - u06.u06_receivable_amount)
                           * get_exchange_rate (u06.u06_institute_id_m02,
                                                u06.u06_currency_code_m03,
                                                'SAR',
                                                'R')
                               cash_balance,
                           u07.u07_id,
                           u07.u07_institute_id_m02,
                           u23_margin_call_level_1
                      FROM u07_trading_account u07
                           JOIN u06_cash_account u06
                               ON     u07.u07_cash_account_id_u06 =
                                          u06.u06_id
                                  AND u06.u06_margin_enabled = 1
                           JOIN u01_customer u01
                               ON u06.u06_customer_id_u01 = u01.u01_id
                           JOIN u23_customer_margin_product u23
                               ON u01.u01_id = u23.u23_customer_id_u01
                           JOIN m73_margin_products m73
                               ON     u23.u23_margin_product_m73 = m73.m73_id
                                  AND m73.m73_status_id_v01 != 5
                           LEFT JOIN m07_location m07
                               ON u01.u01_signup_location_id_m07 = m07.m07_id
                           JOIN m02_institute m02
                               ON u06.u06_institute_id_m02 = m02.m02_id)
            GROUP BY u01_id,
                     u23_id,
                     m07_name,
                     u07_id)
/