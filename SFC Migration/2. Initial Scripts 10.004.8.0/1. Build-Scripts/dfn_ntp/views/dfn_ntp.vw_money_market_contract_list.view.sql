CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_money_market_contract_list
(
    t69_id,
    t69_contract_type_id_v01,
    contract_type,
    contract_type_lang,
    t69_transaction_date,
    t69_settlement_date,
    t69_principal_value,
    t69_interest_rate,
    t69_period,
    t69_maturity_amount,
    t69_penalty_interest_rate,
    t69_collateral_type_id_v01,
    collateral_type,
    collateral_type_lang,
    t69_bond_symbol_id_m171,
    bond_symbol_code,
    t69_symbol_id_m20,
    symbol_code,
    t69_quantity,
    t69_l_cash_acnt_id_u06,
    t69_b_cash_acnt_id_u06,
    t69_l_currency_code_m03,
    t69_b_currency_code_m03,
    t69_l_currency_id_m03,
    t69_b_currency_id_m03,
    t69_l_customer_id_u01,
    t69_b_customer_id_u01,
    lender_customer_no,
    lender_display_name,
    lender_display_name_lang,
    borrower_customer_no,
    borrower_display_name,
    borrower_display_name_lang,
    t69_l_gross_settle_amount,
    t69_b_gross_settle_amount,
    t69_l_otc_commission_id_m169,
    t69_b_otc_commission_id_m169,
    t69_l_commission_amount,
    t69_b_commission_amount,
    t69_l_vat_amount,
    t69_b_vat_amount,
    t69_l_net_settle_amount,
    t69_b_net_settle_amount,
    t69_created_date,
    t69_modified_date,
    t69_status_changed_date,
    t69_institute_id_m02,
    t69_status_id_v01,
    lender_cash_acc,
    borrower_cash_acc,
    status,
    created_by_full_name,
    modified_by_full_name,
    status_changed_by_full_name
)
AS
    SELECT t69_id,
           t69_contract_type_id_v01,
           v69.v01_description AS contract_type,
           v69.v01_description_lang AS contract_type_lang,
           t69_transaction_date,
           t69_settlement_date,
           t69_principal_value,
           t69_interest_rate,
           t69_period,
           t69_maturity_amount,
           t69_penalty_interest_rate,
           t69_collateral_type_id_v01,
           v68.v01_description AS collateral_type,
           v68.v01_description_lang AS collateral_type_lang,
           t69_bond_symbol_id_m171,
           m171_name AS bond_symbol_code,
           t69_symbol_id_m20,
           m20_symbol_code AS symbol_code,
           t69_quantity,
           t69_l_cash_acnt_id_u06,
           t69_b_cash_acnt_id_u06,
           t69_l_currency_code_m03,
           t69_b_currency_code_m03,
           t69_l_currency_id_m03,
           t69_b_currency_id_m03,
           t69_l_customer_id_u01,
           t69_b_customer_id_u01,
           u01l.u01_customer_no AS lender_customer_no,
           u01l.u01_display_name AS lender_display_name,
           u01l.u01_display_name_lang AS lender_display_name_lang,
           u01b.u01_customer_no AS borrower_customer_no,
           u01b.u01_display_name AS borrower_display_name,
           u01b.u01_display_name_lang AS borrower_display_name_lang,
           t69_l_gross_settle_amount,
           t69_b_gross_settle_amount,
           t69_l_otc_commission_id_m169,
           t69_b_otc_commission_id_m169,
           t69_l_commission_amount,
           t69_b_commission_amount,
           t69_l_vat_amount,
           t69_b_vat_amount,
           t69_l_net_settle_amount,
           t69_b_net_settle_amount,
           t69_created_date,
           t69_modified_date,
           t69_status_changed_date,
           t69_institute_id_m02,
           t69_status_id_v01,
           u06l.u06_display_name AS lender_cash_acc,
           u06b.u06_display_name AS borrower_cash_acc,
           status_list.v01_description AS status,
           u17_created_by.u17_full_name AS created_by_full_name,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name
      FROM t69_money_market_contract
           JOIN u17_employee u17_created_by
               ON t69_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON t69_modified_by_id_u17 = u17_modified_by.u17_id
           JOIN u17_employee u17_status_changed_by
               ON t69_status_changed_by_id_u17 = u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON t69_status_id_v01 = status_list.v01_id
           LEFT JOIN (SELECT *
                        FROM v01_system_master_data
                       WHERE v01_type = 68) v68
               ON t69_collateral_type_id_v01 = v68.v01_id
           LEFT JOIN (SELECT *
                        FROM v01_system_master_data
                       WHERE v01_type = 69) v69
               ON t69_contract_type_id_v01 = v69.v01_id
           LEFT JOIN m20_symbol
               ON t69_symbol_id_m20 = m20_id
           LEFT JOIN m171_bond_issue_config m171
               ON t69_bond_symbol_id_m171 = m171.m171_id
           LEFT JOIN u01_customer u01l
               ON t69_l_customer_id_u01 = u01l.u01_id
           LEFT JOIN u01_customer u01b
               ON t69_b_customer_id_u01 = u01b.u01_id
           LEFT JOIN u06_cash_account u06l
               ON t69_l_cash_acnt_id_u06 = u06l.u06_id
           LEFT JOIN u06_cash_account u06b
               ON t69_b_cash_acnt_id_u06 = u06b.u06_id
           LEFT JOIN m169_otc_trading_commission m169l
               ON t69_l_otc_commission_id_m169 = m169l.m169_id
           LEFT JOIN m169_otc_trading_commission m169b
               ON t69_b_otc_commission_id_m169 = m169b.m169_id
/
