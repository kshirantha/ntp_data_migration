CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t75_murabaha_contracts
(
    t75_id,
    t75_contract_no,
    t75_loan_amount,
    cust_trdng_ac_name,
    t75_customer_trdng_ac_id_u07,
    t75_customer_cash_ac_id_u06,
    t75_institution_id_m02,
    t75_currency_code_m03,
    customer_no,
    u01_external_ref_no,
    cust_name,
    cust_name_lang,
    agent_name,
    agent_name_lang,
    agent_code,
    t75_agent_trading_ac_id_u07,
    agent_trdng_ac_name,
    cust_cash_acc_display_name,
    basket,
    basket_name,
    auto_sell,
    t75_auto_sell,
    fund_by_client,
    t75_fund_by_client,
    t75_profit_percentage,
    t75_profit_amount,
    t75_status_id_v01,
    status_description,
    status_description_lang,
    created_by_name,
    t75_created_date,
    modified_by_name,
    t75_modified_date,
    status_changed_by_name,
    t75_status_changed_date,
    close_status,
    t75_close_status,
    t75_current_approval_level,
    t75_expiry_date,
    t75_customer_id_u01
)
AS
    SELECT t75.t75_id,
           t75.t75_contract_no,
           t75.t75_loan_amount,
           u07_cust.u07_display_name AS cust_trdng_ac_name,
           t75.t75_customer_trdng_ac_id_u07,
           t75.t75_customer_cash_ac_id_u06,
           t75.t75_institution_id_m02,
           t75.t75_currency_code_m03,
           u01_cust.u01_customer_no AS customer_no,
           u01_cust.u01_external_ref_no,
           u01_cust.u01_display_name AS cust_name,
           u01_cust.u01_display_name_lang AS cust_name_lang,
           u01_agent.u01_display_name AS agent_name,
           u01_agent.u01_display_name_lang AS agent_name_lang,
           u01_agent.u01_agent_code AS agent_code,
           t75.t75_agent_trading_ac_id_u07,
           u07_agent.u07_display_name AS agent_trdng_ac_name,
           u06_cust.u06_display_name AS cust_cash_acc_display_name,
           m181.m181_basket_name AS basket,
           m181.m181_basket_code AS basket_name,
           CASE WHEN t75.t75_auto_sell = 1 THEN 'Yes' ELSE 'No' END
               AS auto_sell,
           t75.t75_auto_sell,
           CASE WHEN t75.t75_fund_by_client = 1 THEN 'Yes' ELSE 'No' END
               AS fund_by_client,
           t75.t75_fund_by_client,
           t75.t75_profit_percentage,
           t75.t75_profit_amount,
           t75.t75_status_id_v01,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           u17_created_by.u17_full_name AS created_by_name,
           t75.t75_created_date,
           u17_modified_by.u17_full_name AS modified_by_name,
           t75.t75_modified_date,
           u17_status_changed_by.u17_full_name AS status_changed_by_name,
           t75.t75_status_changed_date,
           CASE WHEN t75.t75_close_status = 1 THEN 'CLOSED' ELSE 'OPEN' END
               AS close_status,
           t75.t75_close_status,
           t75.t75_current_approval_level,
           t75.t75_expiry_date,
           t75.t75_customer_id_u01
      FROM t75_murabaha_contracts t75
           JOIN m181_murabaha_baskets m181
               ON m181_id = t75.t75_basket_id_m181
           JOIN u07_trading_account u07_agent
               ON u07_agent.u07_id = t75.t75_agent_trading_ac_id_u07
           JOIN u06_cash_account u06_cust
               ON u06_cust.u06_id = t75.t75_customer_cash_ac_id_u06
           JOIN u01_customer u01_agent
               ON u01_agent.u01_id = u07_agent.u07_customer_id_u01
           JOIN u07_trading_account u07_cust
               ON u07_cust.u07_id = t75.t75_customer_trdng_ac_id_u07
           JOIN u01_customer u01_cust
               ON u01_cust.u01_id = u07_cust.u07_customer_id_u01
           JOIN u17_employee u17_created_by
               ON u17_created_by.u17_id = t75.t75_created_by_id_u17
           LEFT JOIN u17_employee u17_modified_by
               ON u17_modified_by.u17_id = t75.t75_modified_by_id_u17
           JOIN u17_employee u17_status_changed_by
               ON u17_status_changed_by.u17_id =
                      t75.t75_status_changed_by_id_u17
           JOIN vw_status_list status_list
               ON status_list.v01_id = t75.t75_status_id_v01
/