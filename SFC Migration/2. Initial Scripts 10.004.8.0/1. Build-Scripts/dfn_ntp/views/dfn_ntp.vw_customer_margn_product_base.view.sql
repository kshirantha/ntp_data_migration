CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_customer_margn_product_base
(
   u23_id,
   u23_customer_id_u01,
   u23_margin_product_m73,
   margin_product,
   margin_product_type_desc,
   u23_interest_group_id_m74,
   interest_group,
   u23_max_margin_limit,
   u23_max_limit_currency_m03,
   u23_margin_percentage,
   u23_margin_expiry_date,
   u23_margin_call_level_1,
   u23_margin_call_level_2,
   u23_liquidation_level,
   u23_restore_level,
   u23_sym_margin_group_m77,
   u23_stock_concentration_m75,
   u23_status_id_v01,
   approval_status,
   u23_created_date,
   u23_created_by_id_u17,
   created_by_name,
   u23_modified_date,
   u23_modified_by_id_u17,
   modified_by_name,
   u23_max_limit_currency_id_m03,
   u23_borrowers_name,
   u23_status_changed_by_id_u17,
   status_changed_by_name,
   u23_status_changed_date,
   u23_default_cash_acc_id_u06,
   u23_other_cash_acc_ids_u06,
   u23_exempt_liquidation,
   u23_institute_id_m02,
   u23_margin_expired
)
AS
   SELECT u23_id,
          u23_customer_id_u01,
          u23_margin_product_m73,
          m73.m73_name AS margin_product,
          CASE
             WHEN m73.m73_product_type = 1 THEN 'Coverage Ratio'
             WHEN m73.m73_product_type = 2 THEN 'Initial Margin'
          END
             AS margin_product_type_desc,
          u23_interest_group_id_m74,
          m74.m74_description AS interest_group,
          u23_max_margin_limit,
          u23_max_limit_currency_m03,
          u23_margin_percentage,
          u23_margin_expiry_date,
          u23_margin_call_level_1,
          u23_margin_call_level_2,
          u23_liquidation_level,
          u23_restore_level,
          u23_sym_margin_group_m77,
          u23_stock_concentration_m75,
          u23_status_id_v01,
          status.v01_description AS approval_status,
          u23_created_date,
          u23_created_by_id_u17,
          createdby.u17_full_name AS created_by_name,
          u23_modified_date,
          u23_modified_by_id_u17,
          modifiedby.u17_full_name AS modified_by_name,
          u23_max_limit_currency_id_m03,
          u23_borrowers_name,
          u23_status_changed_by_id_u17,
          statuschangedby.u17_full_name AS status_changed_by_name,
          u23.u23_status_changed_date,
          u23.u23_default_cash_acc_id_u06,
          u23.u23_other_cash_acc_ids_u06,
          u23.u23_exempt_liquidation,
          u23.u23_institute_id_m02,
          u23.u23_margin_expired
     FROM u23_customer_margin_product u23
          JOIN m73_margin_products m73
             ON u23.u23_margin_product_m73 = m73.m73_id
          JOIN m74_margin_interest_group m74
             ON u23.u23_interest_group_id_m74 = m74.m74_id
          JOIN vw_status_list status ON u23.u23_status_id_v01 = status.v01_id
          JOIN u17_employee createdby
             ON u23.u23_created_by_id_u17 = createdby.u17_id
          JOIN u17_employee statuschangedby
             ON u23.u23_status_changed_by_id_u17 = statuschangedby.u17_id
          LEFT JOIN u17_employee modifiedby
             ON u23.u23_modified_by_id_u17 = modifiedby.u17_id
/