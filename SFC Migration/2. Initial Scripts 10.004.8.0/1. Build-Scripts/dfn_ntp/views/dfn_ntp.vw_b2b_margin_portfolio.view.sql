/* Formatted on 8/5/2020 3:13:49 PM (QP5 v5.206) */
CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_b2b_margin_portfolio
(
    customer_no,
    u01_display_name,
    u01_display_name_lang,
    security_ac_no,
    cash_ac_no,
    currency,
    portfolio_val_include_pledge,
    portfolio_value_ex_pledge,
    cash_balance,
    blocked_amount,
    cash_block,
    avilable_cash_balance,
    pending_orders,
    pending_settlement,
    pending_transfers,
    pending_deposits,
    group_buying_power,
    buying_power,
    margin_type,
    approve_margin_limit,
    margin_expiry_date,
    coverage_ratio,
    marginalbe_portfolio,
    mpv_with_pending_orders,
    limit_utilization,
    loan_due,
    loan_currency,
    loan_account
)
AS
    ( (SELECT u01.u01_customer_no AS customer_no,
              u01.u01_display_name,
              u01_display_name_lang,
              u07_exchange_account_no AS security_ac_no,
              u06_investment_account_no AS cash_ac_no,
              u06.u06_currency_code_m03 AS currency,
              ROUND (
                  get_pfolio_val_by_cash_ac (
                      p_cash_ac_id           => u06.u06_id,
                      p_institution          => u06.u06_institute_id_m02,
                      p_computation_method   => m02.m02_price_type_for_margin,
                      p_check_buy_pending    => 0,                       --'N'
                      p_check_pledgedqty     => 1,                       --'Y'
                      p_check_sym_margin     => 0),
                  2)                                                     --'N'
                  AS portfolio_val_include_pledge,
              ROUND (
                  get_pfolio_val_by_cash_ac (
                      p_cash_ac_id           => u06.u06_id,
                      p_institution          => u06.u06_institute_id_m02,
                      p_computation_method   => m02.m02_price_type_for_margin,
                      p_check_buy_pending    => 0,                       --'N'
                      p_check_pledgedqty     => 0,                       --'Y'
                      p_check_sym_margin     => 0),
                  2)                                                     --'N'
                  AS portfolio_value_ex_pledge,
              ROUND (
                  (  u06.u06_balance
                   + u06.u06_payable_blocked
                   - u06.u06_receivable_amount),
                  2)
                  AS cash_balance,
              u06.u06_blocked AS blocked_amount,
              u06.u06_manual_full_blocked AS cash_block,
              (  u06.u06_balance
               - u06.u06_blocked
               - u06.u06_manual_full_blocked)
                  AS avilable_cash_balance,
              u06.u06_manual_trade_blocked AS pending_orders,
              (u06.u06_receivable_amount - u06.u06_payable_blocked)
                  AS pending_settlement,
              u06.u06_pending_withdraw AS pending_transfers,
              u06.u06_pending_deposit AS pending_deposits,
              pkg_sfc_b2b_inquiries.get_group_buying_power (
                  u06.u06_id,
                  u06.u06_currency_code_m03,
                  u01.u01_id)
                  AS group_buying_power,
              pkg_sfc_b2b_inquiries.get_buying_power (u06.u06_id)
                  AS buying_power,
              m73.m73_name AS margin_type,
              u23.u23_max_margin_limit AS approve_margin_limit,
              u23.u23_margin_expiry_date AS margin_expiry_date,
              u23.u23_margin_percentage AS coverage_ratio,
              ROUND (
                  NVL (
                      get_pfolio_val_by_cash_ac (
                          p_cash_ac_id           => u06.u06_id,
                          p_institution          => u06.u06_institute_id_m02,
                          p_computation_method   => m02.m02_price_type_for_margin,
                          p_check_buy_pending    => 0,                   --'N'
                          p_check_pledgedqty     => 1,                   --'Y'
                          p_check_sym_margin     => 1),
                      0),
                  2)                                                     --'N'
                  AS marginalbe_portfolio,
              ROUND (
                  NVL (
                      get_pfolio_val_by_cash_ac (
                          p_cash_ac_id           => u06.u06_id,
                          p_institution          => u06.u06_institute_id_m02,
                          p_computation_method   => m02.m02_price_type_for_margin,
                          p_check_buy_pending    => 1,                   --'N'
                          p_check_pledgedqty     => 1,                   --'Y'
                          p_check_sym_margin     => 1),
                      0),
                  2)                                                     --'N'
                  AS mpv_with_pending_orders,
              CASE WHEN u06.u06_balance < 0 THEN u06.u06_balance ELSE 0 END
                  AS limit_utilization,
              u06.u06_loan_amount AS loan_due,
              u06.u06_currency_code_m03 AS loan_currency,
              u06.u06_investment_account_no AS loan_account
         FROM u07_trading_account u07
              INNER JOIN u06_cash_account u06
                  ON u06.u06_id = u07.u07_cash_account_id_u06
              INNER JOIN u01_customer u01
                  ON u01.u01_id = u06.u06_customer_id_u01
              LEFT OUTER JOIN u23_customer_margin_product u23
                  ON u23_customer_id_u01 = u01.u01_id
              LEFT OUTER JOIN m73_margin_products m73
                  ON m73.m73_id = u23.u23_id
              INNER JOIN m02_institute m02
                  ON m02.m02_id = u06.u06_institute_id_m02
              LEFT OUTER JOIN u23_customer_margin_product u23
                  ON     u23.u23_customer_id_u01 = u01.u01_id
                     AND u23.u23_id = u06.u06_margin_product_id_u23
              LEFT OUTER JOIN m73_margin_products m73
                  ON m73.m73_id = u23.u23_margin_product_m73))
/
