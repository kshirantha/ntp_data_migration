CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_margin_enabled_accounts
(
    u23_id,
    u01_customer_no,
    u01_external_ref_no,
    u01_full_name,
    u01_institute_id_m02,
    default_cash_acc_display_name,
    default_cash_acc_currency,
    total_cash_balance,
    u06_blocked,
    margin_block,
    margin_utilized,
    u06_margin_enabled,
    margin_enabled_desc,
    m73_product_type,
    product_type_desc,
    u23_max_margin_limit,
    u23_margin_percentage,
    u23_margin_call_level_1,
    u23_margin_call_level_2,
    u23_liquidation_level,
    u23_restore_level,
    u23_current_margin_call_level,
    u23_margin_expiry_date,
    rapv,
    portfolio_value,
    sym_margin_group,
    u02_mobile,
    liquidation_required,
    liquidation_amount,
    initial_margin,
    tot_margin_pf_value,
    u06_id
)
AS
    SELECT margin.u23_id,
           margin.u01_customer_no,
           margin.u01_external_ref_no,
           margin.u01_full_name,
           margin.u01_institute_id_m02,
           margin.default_cash_acc_display_name,
           margin.default_cash_acc_currency,
           margin.total_cash_balance,
           margin.u06_blocked,
           margin.margin_block,
           margin.margin_utilized,
           margin.u06_margin_enabled,
           margin.margin_enabled_desc,
           margin.m73_product_type,
           margin.product_type_desc,
           margin.u23_max_margin_limit,
           margin.u23_margin_percentage,
           margin.u23_margin_call_level_1,
           margin.u23_margin_call_level_2,
           margin.u23_liquidation_level,
           margin.u23_restore_level,
           margin.u23_current_margin_call_level,
           margin.u23_margin_expiry_date,
           margin.rapv,
           margin.portfolio_value,
           margin.sym_margin_group,
           margin.u02_mobile,
           CASE
               WHEN    (    margin.m73_product_type = 1
                        AND margin.u23_current_margin_call_level <=
                                margin.u23_liquidation_level)
                    OR (    margin.m73_product_type = 2
                        AND margin.u23_current_margin_call_level >=
                                margin.u23_liquidation_level)
               THEN
                   'Yes'
               ELSE
                   'No'
           END
               AS liquidation_required,
           fn_margin_liquidation_amount (margin.rapv,
                                         margin.margin_utilized,
                                         margin.m73_product_type,
                                         margin.current_margin_percentage,
                                         margin.u23_liquidation_level,
                                         margin.u23_restore_level,
                                         margin.m02_broker_id_m150)
               AS liquidation_amount,
           margin.initial_margin,
           margin.rapv + margin.initial_margin AS tot_margin_pf_value,
           u06_id
      FROM (SELECT u06.u23_id,
                   u06.m02_broker_id_m150 AS m02_broker_id_m150,
                   u01.u01_customer_no AS u01_customer_no,
                   u01.u01_external_ref_no AS u01_external_ref_no,
                   u01.u01_full_name AS u01_full_name,
                   u01.u01_institute_id_m02 AS u01_institute_id_m02,
                   u06.u06_display_name AS default_cash_acc_display_name,
                   u06.u06_currency_code_m03 AS default_cash_acc_currency,
                   u06.total_cash_balance AS total_cash_balance,
                   u06.u06_blocked AS u06_blocked,
                   u06.u06_balance AS u06_balance,
                   u06.margin_block AS margin_block,
                   u06.margin_utilized,
                   u06.u06_margin_enabled AS u06_margin_enabled,
                   u06.margin_enabled_desc AS margin_enabled_desc,
                   m73.m73_product_type AS m73_product_type,
                   CASE
                       WHEN m73.m73_product_type = 1 THEN 'Coverage Ratio'
                       WHEN m73.m73_product_type = 2 THEN 'Initial Margin'
                   END
                       product_type_desc,
                     u06.u23_max_margin_limit
                   * get_exchange_rate (m73.m73_institution_m02_id,
                                        u06.u23_max_limit_currency_m03,
                                        u06.u06_currency_code_m03)
                       AS u23_max_margin_limit,
                   u06.u23_margin_percentage AS u23_margin_percentage,
                   u06.rapv AS rapv,
                   u06.portfolio_value AS portfolio_value,
                   u06.u23_margin_call_level_1 AS u23_margin_call_level_1,
                   u06.u23_margin_call_level_2 AS u23_margin_call_level_2,
                   u06.u23_liquidation_level AS u23_liquidation_level,
                   u06.u23_restore_level AS u23_restore_level,
                   CASE
                       WHEN u06.u23_current_margin_call_level = 1
                       THEN
                           u06.u23_margin_call_level_1
                       WHEN u06.u23_current_margin_call_level = 2
                       THEN
                           u06.u23_margin_call_level_2
                       WHEN u06.u23_current_margin_call_level = 3
                       THEN
                           u06.u23_liquidation_level
                   END
                       AS u23_current_margin_call_level,
                   u06.u23_margin_expiry_date AS u23_margin_expiry_date,
                   m77.m77_name AS sym_margin_group,
                   u01.u01_def_mobile AS u02_mobile,
                   fn_margin_current_percentage (rapv,
                                                 u06.total_cash_balance,
                                                 m73.m73_product_type),
                   m73.m73_product_type AS current_margin_percentage,
                   u06.u06_initial_margin AS initial_margin,
                   u06.u06_id
              FROM (SELECT u06.u06_id,
                           u06.u06_customer_id_u01,
                           u06.u06_display_name,
                           u06.u06_currency_code_m03,
                           u06.u06_balance,
                           u06.u06_blocked,
                           u06.u06_initial_margin,
                           u06.u06_loan_amount,
                           (  u06.u06_balance
                            + u06.u06_payable_blocked
                            - u06.u06_receivable_amount)
                               AS total_cash_balance,
                           CASE
                               WHEN (  u06.u06_balance
                                     - u06.u06_loan_amount
                                     + u06.u06_payable_blocked
                                     - u06.u06_receivable_amount) < 0
                               THEN
                                   ABS (
                                         u06.u06_balance
                                       - u06.u06_loan_amount
                                       + u06.u06_payable_blocked
                                       - u06.u06_receivable_amount)
                               ELSE
                                   0
                           END
                               AS margin_utilized,
                           CASE
                               WHEN     u06.u06_balance > 0
                                    AND u06.u06_blocked - u06.u06_balance > 0
                               THEN
                                   (u06.u06_blocked - u06.u06_balance)
                               WHEN u06.u06_balance < 0
                               THEN
                                   u06.u06_blocked
                               ELSE
                                   0
                           END
                               AS margin_block,
                           u06.u06_margin_product_id_u23,
                           u06.u06_margin_enabled,
                           CASE
                               WHEN u06.u06_margin_enabled = 1 THEN 'Yes'
                               WHEN u06.u06_margin_enabled = 2 THEN 'Expired'
                               ELSE 'No'
                           END
                               AS margin_enabled_desc,
                           get_pfolio_val_by_cash_ac (
                               p_cash_ac_id           => u06.u06_id,
                               p_institution          => u06.u06_institute_id_m02,
                               p_computation_method   => m02.m02_price_type_for_margin,
                               p_check_buy_pending    => m02.m02_add_buy_pending_for_margin,
                               p_check_pledgedqty     => m02.m02_add_pledge_for_bp,
                               p_check_sym_margin     => 1)
                               AS rapv,
                           get_pfolio_val_by_cash_ac (
                               p_cash_ac_id           => u06.u06_id,
                               p_institution          => u06.u06_institute_id_m02,
                               p_computation_method   => m02.m02_price_type_for_margin,
                               p_check_buy_pending    => m02.m02_add_buy_pending_for_margin,
                               p_check_pledgedqty     => m02.m02_add_pledge_for_bp,
                               p_check_sym_margin     => 0)
                               AS portfolio_value,
                           m02.m02_broker_id_m150,
                           u23.u23_margin_product_m73,
                           u23.u23_sym_margin_group_m77,
                           u23.u23_max_limit_currency_m03,
                           u23.u23_max_margin_limit,
                           u23_margin_expiry_date,
                           u23.u23_liquidation_level,
                           u23.u23_current_margin_call_level,
                           u23.u23_margin_call_level_1,
                           u23.u23_margin_call_level_2,
                           u23.u23_restore_level,
                           u23.u23_margin_percentage,
                           u23.u23_id
                      FROM u06_cash_account u06
                           JOIN m02_institute m02
                               ON u06.u06_institute_id_m02 = m02.m02_id
                           JOIN u23_customer_margin_product u23
                               ON u06.u06_margin_product_id_u23 = u23.u23_id) u06
                   JOIN u01_customer u01
                       ON u06.u06_customer_id_u01 = u01.u01_id
                   JOIN m73_margin_products m73
                       ON u06.u23_margin_product_m73 = m73.m73_id
                   JOIN m77_symbol_marginability_grps m77
                       ON u06.u23_sym_margin_group_m77 = m77.m77_id) margin
/
