CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_customer_margin_call_log
(
    u22_type,
    u22_date,
    u01_customer_no,
    u01_external_ref_no,
    u01_display_name,
    u01_display_name_lang,
    u01_institute_id_m02,
    u06_display_name,
    u06_margin_enabled,
    u06_id,
    margin_enabled_desc,
    u22_utilized_amount,
    u22_utilized_percentage,
    u22_top_up_amount,
    u22_cash_balance,
    u22_block_amount,
    u22_margin_blocked,
    u22_rapv,
    m73_product_type,
    product_type_desc,
    u23_margin_percentage,
    u23_max_margin_limit,
    u23_margin_call_level_1,
    u23_margin_call_level_2,
    u23_liquidation_level,
    u23_restore_level
)
AS
    SELECT u22.u22_type,
           u22.u22_date,
           u01.u01_customer_no,
           u01.u01_external_ref_no,
           u01.u01_display_name,
           u01.u01_display_name_lang,
           u01.u01_institute_id_m02,
           u06_default.u06_display_name,
           u06_default.u06_margin_enabled,
           u06_default.u06_id,
           CASE
               WHEN u06_default.u06_margin_enabled = 1 THEN 'Yes'
               WHEN u06_default.u06_margin_enabled = 2 THEN 'Expired'
               ELSE 'No'
           END
               AS margin_enabled_desc,
           u22.u22_utilized_amount,
           u22.u22_utilized_percentage,
           u22.u22_top_up_amount,
           u22.u22_cash_balance,
           u22.u22_block_amount,
           u22.u22_margin_blocked,
           u22.u22_rapv,
           m73.m73_product_type,
           CASE
               WHEN m73.m73_product_type = 1 THEN 'Coverage Ratio'
               WHEN m73.m73_product_type = 2 THEN 'Initial Margin'
           END
               product_type_desc,
           u23.u23_margin_percentage,
           u23.u23_max_margin_limit,
           u23.u23_margin_call_level_1,
           u23.u23_margin_call_level_2,
           u23.u23_liquidation_level,
           u23.u23_restore_level
      FROM u22_customer_margin_call_log u22
           JOIN u23_customer_margin_product u23
               ON u22.u22_margin_prdouct_id_u23 = u23.u23_id
           JOIN u06_cash_account u06_default
               ON u23.u23_default_cash_acc_id_u06 = u06_default.u06_id
           JOIN u01_customer u01
               ON u06_default.u06_customer_id_u01 = u01.u01_id
           JOIN m73_margin_products m73
               ON u23.u23_margin_product_m73 = m73.m73_id
/
