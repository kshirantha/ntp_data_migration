CREATE OR REPLACE PROCEDURE dfn_ntp.sp_margin_utilization_report (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pm02_id               m02_institute.m02_id%TYPE)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT m73_name,
                   u01_customer_no,
                   u01_external_ref_no,
                   u01_full_name,
                   u01_full_name_lang,
                   u06_display_name,
                   u06_currency_code_m03,
                   u06_margin_enabled,
                   CASE
                       WHEN u06_margin_enabled = 1 THEN ''Yes''
                       WHEN u06_margin_enabled = 2 THEN ''Expired''
                       ELSE ''No''
                   END
                       AS margin_enabled_desc,
                   u23_margin_expiry_date,
                   u23_max_margin_limit,
                   u23_margin_percentage,
                   u23_margin_call_level_1,
                   u23_margin_call_level_2,
                   u23_liquidation_level,
                   u23_restore_level,
                   u23_current_margin_call_level,
                   limit_utilization,
                   utl_percentage,
                   marginable_pv,
                   portfolio_value,
                   drawing_power,
                   overstepping_amt,
                   overstepping_ratio,
                   overstepping_limit,
                   total_overstepping_ratio,
                   CASE
                       WHEN NVL (overstepping_amt, 0) > NVL (overstepping_limit, 0)
                       THEN
                           (overstepping_amt)
                       ELSE
                           overstepping_limit
                   END
                       AS cash_to_be_transfer,
                   CASE
                       WHEN u23_margin_percentage = 100
                       THEN
                           0
                       ELSE
                           ROUND (
                                 u23_margin_percentage
                               * (overstepping_amt)
                               / (u23_margin_percentage - 100),
                               8)
                   END
                       AS stck_to_be_sold,
                   product_type_desc,
                   CASE
                       WHEN    (    m73_product_type = 1
                                AND u23_current_margin_call_level <=
                                        u23_liquidation_level)
                            OR (    m73_product_type = 2
                                AND u23_current_margin_call_level >=
                                        u23_liquidation_level)
                       THEN
                           ''Yes''
                       ELSE
                           ''No''
                   END
                       AS liquidation_required,
                   u06_initial_margin,
                   m73_product_type,
                   u01_id
              FROM (SELECT m73_name,
                           u01_customer_no,
                           u06_investment_account_no,
                           u01_full_name,
                           u01_full_name_lang,
                           u06_currency_code_m03,
                           u23_margin_expiry_date,
                           u23_max_margin_limit,
                           u23_margin_percentage,
                           u23_margin_call_level_1,
                           u23_margin_call_level_2,
                           u23_liquidation_level,
                           u23_restore_level,
                           u23_current_margin_call_level,
                           limit_utilization,
                           CASE
                               WHEN u23_max_margin_limit = 0
                               THEN
                                   0
                               ELSE
                                   ROUND (limit_utilization * 100 / u23_max_margin_limit,
                                          8)
                           END
                               AS utl_percentage,
                           portfolio_value,
                           marginable_pv,
                           CASE
                               WHEN u23_margin_percentage = 0
                               THEN
                                   0
                               ELSE
                                   ROUND (marginable_pv * 100 / u23_margin_percentage, 8)
                           END
                               AS drawing_power,
                           CASE
                               WHEN u23_margin_percentage = 0
                               THEN
                                   limit_utilization
                               WHEN limit_utilization <
                                        ROUND (
                                            marginable_pv * 100 / u23_margin_percentage,
                                            8)
                               THEN
                                   0
                               ELSE
                                     limit_utilization
                                   - ROUND (marginable_pv * 100 / u23_margin_percentage,
                                            8)
                           END
                               AS overstepping_amt,
                           CASE
                               WHEN marginable_pv = 0 THEN 0
                               ELSE ROUND (limit_utilization * 100 / marginable_pv, 8)
                           END
                               AS overstepping_ratio,
                           CASE
                               WHEN (limit_utilization - u23_max_margin_limit) < 0 THEN 0
                               ELSE (limit_utilization - u23_max_margin_limit)
                           END
                               AS overstepping_limit,
                           ROUND (
                               CASE
                                   WHEN limit_utilization = 0
                                   THEN
                                       0
                                   ELSE
                                       ROUND (portfolio_value * 100 / limit_utilization,
                                              8)
                               END,
                               8)
                               AS total_overstepping_ratio,
                           product_type_desc,
                           u06_initial_margin,
                           m73_product_type,
                           u06_margin_enabled,
                           u06_display_name,
                           u01_external_ref_no,
                           u01_id
                      FROM (SELECT m73.m73_name,
                                   u01.u01_customer_no,
                                   u06.u06_investment_account_no,
                                   u01.u01_full_name,
                                   u01.u01_full_name_lang,
                                   u06.u06_currency_code_m03,
                                   u23.u23_margin_expiry_date,
                                   u23.u23_max_margin_limit,
                                   u23.u23_margin_percentage,
                                   u23.u23_margin_call_level_1,
                                   u23.u23_margin_call_level_2,
                                   u23.u23_liquidation_level,
                                   u23.u23_restore_level,
                                   u23.u23_current_margin_call_level,
                                     (  u06.u06_balance
                                      - u06.u06_loan_amount
                                      + u06.u06_payable_blocked
                                      - u06.u06_receivable_amount)
                                   * -1
                                       AS limit_utilization,
                                   get_pfolio_val_by_cash_ac (
                                       p_cash_ac_id           => u06.u06_id,
                                       p_institution          => u06.u06_institute_id_m02,
                                       p_computation_method   => m02.m02_price_type_for_margin,
                                       p_check_buy_pending    => m02.m02_add_buy_pending_for_margin,
                                       p_check_pledgedqty     => m02.m02_add_pledge_for_bp,
                                       p_check_sym_margin     => 1)
                                       AS marginable_pv,
                                   get_pfolio_val_by_cash_ac (
                                       p_cash_ac_id           => u06.u06_id,
                                       p_institution          => u06.u06_institute_id_m02,
                                       p_computation_method   => m02.m02_price_type_for_margin,
                                       p_check_buy_pending    => m02.m02_add_buy_pending_for_margin,
                                       p_check_pledgedqty     => m02.m02_add_pledge_for_bp,
                                       p_check_sym_margin     => 0)
                                       AS portfolio_value,
                                   CASE
                                       WHEN m73.m73_product_type = 1
                                       THEN
                                           ''Coverage Ratio''
                                       WHEN m73.m73_product_type = 2
                                       THEN
                                           ''Initial Margin''
                                   END
                                       product_type_desc,
                                   u06.u06_initial_margin,
                                   m73.m73_product_type,
                                   u06.u06_margin_enabled,
                                   u06.u06_display_name,
                                   u01.u01_external_ref_no,
                                   u01.u01_id
                              FROM u23_customer_margin_product u23
                                   JOIN u06_cash_account u06
                                       ON     u06.u06_margin_product_id_u23 = u23.u23_id
                                          AND u06.u06_margin_enabled = 1
                                          AND (  u06.u06_balance
                                               - u06.u06_loan_amount
                                               + u06.u06_payable_blocked
                                               - u06.u06_receivable_amount) < 0
                                   JOIN m73_margin_products m73
                                       ON u23.u23_margin_product_m73 = m73.m73_id
                                   JOIN u01_customer u01
                                       ON     u06.u06_customer_id_u01 = u01.u01_id
                                          AND u01.u01_institute_id_m02 = '
        || pm02_id
        || ' JOIN m02_institute m02
                                       ON u01.u01_institute_id_m02 = m02.m02_id))';

    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              NULL,
                              NULL,
                              NULL);

    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/