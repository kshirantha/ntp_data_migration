CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_dc_margin_customers
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
    marginable_pv,
    portfolio_value,
    margin_utilized_percentage,
    current_margin_percentage,
    sym_margin_group,
    u02_mobile,
    liquidation_required,
    liquidation_amount,
    initial_margin,
    margin_percentage,
    tot_margin_pf_value,
    u06_customer_id_u01
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
           margin.rapv
               AS marginable_pv,
           margin.portfolio_value,
           margin.margin_utilized_percentage,
           current_margin_percentage,
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
           margin.margin_percentage,
           margin.rapv + margin.initial_margin
               AS tot_margin_pf_value,
           u06_customer_id_u01
    FROM (SELECT u23.u23_id,
                 MAX (u06.m02_broker_id_m150)
                     AS m02_broker_id_m150,
                 MAX (u06.u06_customer_id_u01)
                     AS u06_customer_id_u01,
                 MAX (u01.u01_customer_no)
                     AS u01_customer_no,
                 MAX (u01.u01_external_ref_no)
                     AS u01_external_ref_no,
                 MAX (u01.u01_full_name)
                     AS u01_full_name,
                 MAX (u01.u01_institute_id_m02)
                     AS u01_institute_id_m02,
                 MAX (u06_default.u06_display_name)
                     AS default_cash_acc_display_name,
                 MAX (u06_default.u06_currency_code_m03)
                     AS default_cash_acc_currency,
                 SUM (u06.total_cash_balance * u06.curr_rate)
                     AS total_cash_balance,
                 SUM (u06.u06_blocked * u06.curr_rate)
                     AS u06_blocked,
                 SUM (u06.u06_balance * u06.curr_rate)
                     AS u06_balance,
                 SUM (u06.margin_block * u06.curr_rate)
                     AS margin_block,
                 SUM (limit_utilization * u06.curr_rate)
                     AS margin_utilized,
                 MAX (u06.u06_margin_enabled)
                     AS u06_margin_enabled,
                 MAX (u06.margin_enabled_desc)
                     AS margin_enabled_desc,
                 MAX (m73.m73_product_type)
                     AS m73_product_type,
                 CASE
                     WHEN MAX (m73.m73_product_type) = 1
                     THEN
                         'Coverage Ratio'
                     WHEN MAX (m73.m73_product_type) = 2
                     THEN
                         'Initial Margin'
                 END
                     product_type_desc,
                   MAX (u23.u23_max_margin_limit)
                 * get_exchange_rate (
                       MAX (m73.m73_institution_m02_id),
                       MAX (u23.u23_max_limit_currency_m03),
                       MAX (u06_default.u06_currency_code_m03))
                     AS u23_max_margin_limit,
                 MAX (u23.u23_margin_percentage)
                     AS u23_margin_percentage,
                 SUM (u06.rapv * u06.curr_rate)
                     AS rapv,
                 SUM (u06.portfolio_value * u06.curr_rate)
                     AS portfolio_value,
                 MAX (u23.u23_margin_call_level_1)
                     AS u23_margin_call_level_1,
                 MAX (u23.u23_margin_call_level_2)
                     AS u23_margin_call_level_2,
                 MAX (u23.u23_liquidation_level)
                     AS u23_liquidation_level,
                 MAX (u23.u23_restore_level)
                     AS u23_restore_level,
                 CASE
                     WHEN MAX (u23.u23_current_margin_call_level) = 1
                     THEN
                         MAX (u23.u23_margin_call_level_1)
                     WHEN MAX (u23.u23_current_margin_call_level) = 2
                     THEN
                         MAX (u23.u23_margin_call_level_2)
                     WHEN MAX (u23.u23_current_margin_call_level) = 3
                     THEN
                         MAX (u23.u23_liquidation_level)
                 END
                     AS u23_current_margin_call_level,
                 MAX (u23.u23_margin_expiry_date)
                     AS u23_margin_expiry_date,
                 MAX (m77.m77_name)
                     AS sym_margin_group,
                 MAX (u01.u01_def_mobile)
                     AS u02_mobile,
                 fn_margin_utilized_percentage (
                     MAX (u23.u23_max_margin_limit),
                     SUM (ABS (limit_utilization * u06.curr_rate)),
                     get_exchange_rate (
                         MAX (m73.m73_institution_m02_id),
                         MAX (u23.u23_max_limit_currency_m03),
                         MAX (u06_default.u06_currency_code_m03)))
                     AS margin_utilized_percentage,
                 fn_margin_current_percentage (
                     SUM (rapv * u06.curr_rate),
                     SUM (ABS (u06.total_cash_balance * u06.curr_rate)),
                     MAX (m73.m73_product_type))
                     AS current_margin_percentage,
                 SUM (u06.u06_initial_margin * u06.curr_rate)
                     AS initial_margin,
                 MAX (u23.u23_margin_percentage)
                     AS margin_percentage
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
                           WHEN     u06.u06_balance > 0
                                AND u06.u06_blocked - u06.u06_balance > 0
                           THEN
                               (u06.u06_blocked - u06.u06_balance)
                           WHEN u06.u06_balance <= 0
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
                           p_cash_ac_id         => u06.u06_id,
                           p_institution        => u06.u06_institute_id_m02,
                           p_computation_method   =>
                               m02.m02_price_type_for_margin,
                           p_check_buy_pending   =>
                               m02.m02_add_buy_pending_for_margin,
                           p_check_pledgedqty   => m02.m02_add_pledge_for_bp,
                           p_check_sym_margin   => 1)
                           AS rapv,
                       get_pfolio_val_by_cash_ac (
                           p_cash_ac_id         => u06.u06_id,
                           p_institution        => u06.u06_institute_id_m02,
                           p_computation_method   =>
                               m02.m02_price_type_for_margin,
                           p_check_buy_pending   =>
                               m02.m02_add_buy_pending_for_margin,
                           p_check_pledgedqty   => m02.m02_add_pledge_for_bp,
                           p_check_sym_margin   => 0)
                           AS portfolio_value,
                       get_exchange_rate (u06.u06_institute_id_m02,
                                          u06.u06_currency_code_m03,
                                          u06_default.u06_currency_code_m03)
                           curr_rate,
                       m02.m02_broker_id_m150,
                       CASE
                           WHEN (  u06.u06_balance
                                 - u06.u06_loan_amount
                                 + u06.u06_payable_blocked
                                 - u06.u06_receivable_amount) <
                                0
                           THEN
                                 (  u06.u06_balance
                                  - u06.u06_loan_amount
                                  + u06.u06_payable_blocked
                                  - u06.u06_receivable_amount)
                               * -1
                           ELSE
                               0
                       END
                           AS limit_utilization
                FROM u06_cash_account u06
                     JOIN m02_institute m02
                         ON u06.u06_institute_id_m02 = m02.m02_id
                     JOIN u23_customer_margin_product u23
                         ON u06.u06_margin_product_id_u23 = u23.u23_id
                     JOIN u06_cash_account u06_default
                         ON u23.u23_default_cash_acc_id_u06 =
                            u06_default.u06_id
                WHERE u06.u06_margin_enabled = 1) u06
               JOIN u01_customer u01 ON u06.u06_customer_id_u01 = u01.u01_id
               JOIN u23_customer_margin_product u23
                   ON u06.u06_margin_product_id_u23 = u23.u23_id
               JOIN m73_margin_products m73
                   ON u23.u23_margin_product_m73 = m73.m73_id
               JOIN u06_cash_account u06_default
                   ON u23.u23_default_cash_acc_id_u06 = u06_default.u06_id
               JOIN m77_symbol_marginability_grps m77
                   ON u23.u23_sym_margin_group_m77 = m77.m77_id
          GROUP BY u23.u23_id) margin
/