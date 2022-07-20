CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_margin_products
(
    m73_id,
    m73_institution_m02_id,
    m73_name,
    m73_description,
    m73_risk_owner,
    risk_owner,
    m73_product_group,
    m73_product_type,
    m73_margin_category_id_v01,
    m73_created_by_id_u17,
    created_by_full_name,
    m73_created_date,
    m73_modified_by_id_u17,
    modified_by_full_name,
    m73_modified_date,
    m73_status_id_v01,
    status,
    m73_status_changed_by_id_u17,
    status_changed_by_full_name,
    m73_status_changed_date,
    margin_category,
    equation,
    m73_margin_interest_grp_id_m74,
    interest_group,
    m73_stock_concent_grp_id_m75,
    stock_concen_group,
    m73_symbol_margblty_grp_id_m77,
    symbol_marginability_group,
    m73_max_amount,
    m73_min_amount,
    m73_currency_id_m03,
    m73_currency_code_m03,
    m73_online_allowed,
    m73_display_buying_power,
    m73_agent_id_u07,
    agent_name,
    m73_profit_type,
    m73_profit,
    m73_minimum_trading_experience,
    m73_murabaha_basket_id_m181,
    m73_risk_approval_limit,
    m73_remarks,
    m73_margin_product_eq_id_v36,
    m73_margin_product_eq_id_v01
)
AS
    SELECT a.m73_id,
           a.m73_institution_m02_id,
           a.m73_name,
           a.m73_description,
           a.m73_risk_owner,
           CASE a.m73_risk_owner WHEN 1 THEN 'Broker' WHEN 2 THEN 'Bank' END
               AS risk_owner,
           a.m73_product_group,
           a.m73_product_type,
           a.m73_margin_category_id_v01,
           a.m73_created_by_id_u17,
           u17_created_by.u17_full_name AS created_by_full_name,
           a.m73_created_date,
           a.m73_modified_by_id_u17,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           a.m73_modified_date,
           a.m73_status_id_v01,
           vw_status_list.v01_description AS status,
           a.m73_status_changed_by_id_u17,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           a.m73_status_changed_date,
           v01.v01_description AS margin_category,
           eq_v01.v01_description AS equation,
           a.m73_margin_interest_grp_id_m74,
           m74.m74_description AS interest_group,
           a.m73_stock_concent_grp_id_m75,
           m75.m75_description AS stock_concen_group,
           a.m73_symbol_margblty_grp_id_m77,
           m77.m77_name AS symbol_marginability_group,
           a.m73_max_amount,
           a.m73_min_amount,
           a.m73_currency_id_m03,
           a.m73_currency_code_m03,
           a.m73_online_allowed,
           a.m73_display_buying_power,
           a.m73_agent_id_u07,
           u07.u07_display_name AS agent_name,
           a.m73_profit_type,
           a.m73_profit,
           a.m73_minimum_trading_experience,
           a.m73_murabaha_basket_id_m181,
           a.m73_risk_approval_limit,
           a.m73_remarks,
           a.m73_margin_product_eq_id_v36,
           a.m73_margin_product_eq_id_v01
      FROM m73_margin_products a
           LEFT JOIN u17_employee u17_created_by
               ON a.m73_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_status_changed_by
               ON a.m73_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON a.m73_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN vw_status_list
               ON a.m73_status_id_v01 = vw_status_list.v01_id
           LEFT JOIN m74_margin_interest_group m74
               ON a.m73_margin_interest_grp_id_m74 = m74.m74_id
           LEFT JOIN m75_stock_concentration_group m75
               ON a.m73_stock_concent_grp_id_m75 = m75.m75_id
           LEFT JOIN m77_symbol_marginability_grps m77
               ON a.m73_symbol_margblty_grp_id_m77 = m77.m77_id
           LEFT JOIN v01_system_master_data v01
               ON     v01.v01_type = 78
                  AND a.m73_margin_category_id_v01 = v01.v01_id
           LEFT JOIN v01_system_master_data eq_v01
               ON     eq_v01.v01_type = 30
                  AND eq_v01.v01_id = a.m73_margin_product_eq_id_v01
           LEFT JOIN u07_trading_account u07
               ON u07.u07_id = a.m73_agent_id_u07
/