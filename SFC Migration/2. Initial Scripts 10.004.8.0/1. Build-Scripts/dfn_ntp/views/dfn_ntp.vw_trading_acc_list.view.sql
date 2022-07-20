CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_trading_acc_list
(
    u07_id,
    u07_institute_id_m02,
    u07_customer_id_u01,
    u07_cash_account_id_u06,
    u07_exchange_code_m01,
    u07_display_name_u06,
    u07_customer_no_u01,
    u07_display_name_u01,
    u07_default_id_no_u01,
    u07_is_default,
    u07_type,
    u07_trading_enabled,
    u07_sharia_compliant,
    u07_trading_group_id_m08,
    u07_created_by_id_u17,
    u07_created_date,
    u07_status_id_v01,
    u07_commission_group_id_m22,
    u07_discount_percentage,
    u07_commission_dis_grp_id_m24,
    u07_modified_by_id_u17,
    u07_modified_date,
    u07_status_changed_by_id_u17,
    u07_status_changed_date,
    u07_exe_broker_id_m26,
    u07_display_name,
    u07_exchange_account_no,
    u07_txn_fee,
    u07_cust_settle_group_id_m35,
    u07_custodian_id_m26,
    status,
    external_customer_no,
    institute,
    commission_group,
    customer_name,
    modified_by,
    sharia_compliant
)
AS
    SELECT u07.u07_id,
           u07.u07_institute_id_m02,
           u07.u07_customer_id_u01,
           u07.u07_cash_account_id_u06,
           u07.u07_exchange_code_m01,
           u07.u07_display_name_u06,
           u07.u07_customer_no_u01,
           u07.u07_display_name_u01,
           u07.u07_default_id_no_u01,
           u07.u07_is_default,
           u07.u07_type,
           u07.u07_trading_enabled,
           u07.u07_sharia_compliant,
           u07.u07_trading_group_id_m08,
           u07.u07_created_by_id_u17,
           u07.u07_created_date,
           u07.u07_status_id_v01,
           u07.u07_commission_group_id_m22,
           u07.u07_discount_percentage,
           u07.u07_commission_dis_grp_id_m24,
           u07.u07_modified_by_id_u17,
           u07.u07_modified_date,
           u07.u07_status_changed_by_id_u17,
           u07.u07_status_changed_date,
           u07.u07_exe_broker_id_m26,
           u07.u07_display_name,
           u07.u07_exchange_account_no,
           u07.u07_txn_fee,
           u07.u07_cust_settle_group_id_m35,
           u07.u07_custodian_id_m26,
           status_list.v01_description AS status,
           u01.u01_external_ref_no AS external_customer_no,
           m02.m02_name AS institute,
           m22.m22_description AS commission_group,
           u01.u01_display_name AS customer_name,
           u17modified.u17_full_name AS modified_by,
           CASE u07.u07_sharia_compliant
               WHEN 1 THEN 'Yes'
               WHEN 0 THEN 'No'
           END
               AS sharia_compliant
      FROM u07_trading_account u07
           LEFT JOIN vw_status_list status_list
               ON u07.u07_status_id_v01 = status_list.v01_id
           LEFT JOIN u01_customer u01
               ON u07.u07_customer_id_u01 = u01.u01_id
           LEFT JOIN m02_institute m02
               ON u07.u07_commission_group_id_m22 = m02.m02_id
           LEFT JOIN m22_commission_group m22
               ON u07.u07_commission_group_id_m22 = m22.m22_id
           LEFT JOIN u06_cash_account u06
               ON u07.u07_institute_id_m02 = u06.u06_id
           LEFT JOIN u17_employee u17modified
               ON u07.u07_modified_by_id_u17 = u17modified.u17_id;
/
