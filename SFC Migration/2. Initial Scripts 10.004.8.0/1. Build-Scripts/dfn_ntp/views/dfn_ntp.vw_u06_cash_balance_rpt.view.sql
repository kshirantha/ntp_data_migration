CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u06_cash_balance_rpt
(
    u06_id,
    u06_institute_id_m02,
    u06_customer_id_u01,
    u06_customer_no_u01,
    u06_display_name_u01,
    u06_currency_code_m03,
    u06_currency_id_m03,
    u06_balance,
    cash_for_withdraw,
    od_limit_today,
    od_margin_utilized,
    u06_blocked,
    u06_open_buy_blocked,
    u06_payable_blocked,
    u06_manual_trade_blocked,
    u06_manual_full_blocked,
    u06_manual_transfer_blocked,
    u06_receivable_amount,
    u06_is_default,
    is_default,
    u06_created_by_id_u17,
    created_by_name,
    u06_created_date,
    u06_status_id_v01,
    status,
    u06_status_changed_date,
    u06_last_activity_date,
    u06_display_name,
    margin_enabled,
    institute_name,
    u01_external_ref_no,
    u06_external_ref_no,
    u06_margin_due,
    u06_margin_block,
    u06_primary_od_limit,
    u06_primary_start,
    u06_primary_expiry,
    u06_secondary_od_limit,
    u06_secondary_start,
    u06_secondary_expiry,
    u06_investment_account_no,
    m177_cash_transfer_limit,
    u06_pending_withdraw,
    u06_pending_deposit,
    balance,
    u06_account_type_v01,
    account_type,
    u06_inactive_drmnt_status_v01,
    dormant_status,
    u06_net_receivable
)
AS
    SELECT u06.u06_id,
           u06.u06_institute_id_m02,
           u06.u06_customer_id_u01,
           u06.u06_customer_no_u01,
           u06.u06_display_name_u01,
           u06.u06_currency_code_m03,
           u06.u06_currency_id_m03,
           u06.u06_balance,
           u06.cash_for_withdraw,
           u06.od_limit_today,
           CASE
               WHEN u06.u06_balance < 0 THEN ABS (u06.u06_balance)
               ELSE 0
           END
               AS od_margin_utilized,
           u06.u06_blocked,
           u06.u06_open_buy_blocked,
           u06.u06_payable_blocked,
           u06.u06_manual_trade_blocked,
           u06.u06_manual_full_blocked,
           u06.u06_manual_transfer_blocked,
           u06.u06_receivable_amount,
           u06.u06_is_default,
           CASE WHEN u06_is_default = 1 THEN 'Yes' ELSE 'No' END
               AS is_default,
           u06.u06_created_by_id_u17,
           createdby.u17_full_name AS created_by_name,
           u06.u06_created_date,
           u06.u06_status_id_v01,
           status.v01_description AS status,
           u06.u06_status_changed_date,
           u06.u06_last_activity_date,
           u06.u06_display_name,
           CASE u06.u06_margin_enabled WHEN 1 THEN 'Yes' ELSE 'No' END
               AS margin_enabled,
           m02.m02_name AS institute_name,
           u01.u01_external_ref_no,
           u06.u06_external_ref_no,
           u06.u06_margin_due,
           u06.u06_margin_block,
           u06.u06_primary_od_limit,
           u06.u06_primary_start,
           u06.u06_primary_expiry,
           u06.u06_secondary_od_limit,
           u06.u06_secondary_start,
           u06.u06_secondary_expiry,
           u06.u06_investment_account_no,
           m177.m177_cash_transfer_limit,
           u06.u06_pending_withdraw,
           u06.u06_pending_deposit,
             u06.u06_balance
           + u06.u06_payable_blocked
           - u06.u06_receivable_amount
               AS balance,
           u06.u06_account_type_v01,
           CASE u06.u06_account_type_v01
               WHEN 1 THEN 'Investment'
               WHEN 2 THEN 'Share Finance'
               WHEN 3 THEN 'Mutual Fund'
           END
               AS account_type,
           u06.u06_inactive_drmnt_status_v01,
           CASE u06.u06_inactive_drmnt_status_v01
               WHEN 11 THEN dormnt_status.v01_description
               WHEN 12 THEN dormnt_status.v01_description
               ELSE ''
           END
               AS dormant_status,
           u06.u06_net_receivable
      FROM vw_u06_cash_account_base u06,
           vw_status_list status,
           u17_employee createdby,
           m02_institute m02,
           u01_customer u01,
           vw_status_list dormnt_status,
           m177_cash_transfer_limit_group m177
     WHERE     u06.u06_status_id_v01 = status.v01_id
           AND u06.u06_created_by_id_u17 = createdby.u17_id
           AND u06.u06_institute_id_m02 = m02.m02_id
           AND u06.u06_customer_id_u01 = u01.u01_id
           AND u06.u06_inactive_drmnt_status_v01 = dormnt_status.v01_id(+)
           AND u06.u06_transfer_limit_grp_id_m177 = m177.m177_id(+)
/