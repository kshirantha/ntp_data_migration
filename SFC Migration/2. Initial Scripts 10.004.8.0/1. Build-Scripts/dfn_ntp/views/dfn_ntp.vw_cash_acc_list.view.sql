CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_cash_acc_list
(
    u06_id,
    u06_institute_id_m02,
    u06_customer_id_u01,
    u06_customer_no_u01,
    u06_display_name_u01,
    u06_default_id_no_u01,
    u06_currency_code_m03,
    u06_currency_id_m03,
    u06_balance,
    u06_blocked,
    u06_open_buy_blocked,
    u06_payable_blocked,
    u06_manual_trade_blocked,
    u06_manual_full_blocked,
    u06_manual_transfer_blocked,
    u06_receivable_amount,
    u06_is_default,
    u06_created_by_id_u17,
    u06_created_date,
    u06_status_id_v01,
    u06_margin_product_id_u23,
    u06_modified_by_id_u17,
    u06_modified_date,
    u06_status_changed_by_id_u17,
    u06_status_changed_date,
    u06_last_activity_date,
    u06_display_name,
    u01_display_name,
    u01_display_name_lang
)
AS
    SELECT u06.u06_id,
           u06.u06_institute_id_m02,
           u06.u06_customer_id_u01,
           u06.u06_customer_no_u01,
           u06.u06_display_name_u01,
           u06.u06_default_id_no_u01,
           u06.u06_currency_code_m03,
           u06.u06_currency_id_m03,
           u06.u06_balance,
           u06.u06_blocked,
           u06.u06_open_buy_blocked,
           u06.u06_payable_blocked,
           u06.u06_manual_trade_blocked,
           u06.u06_manual_full_blocked,
           u06.u06_manual_transfer_blocked,
           u06.u06_receivable_amount,
           u06.u06_is_default,
           u06.u06_created_by_id_u17,
           u06.u06_created_date,
           u06.u06_status_id_v01,
           u06.u06_margin_product_id_u23,
           u06.u06_modified_by_id_u17,
           u06.u06_modified_date,
           u06.u06_status_changed_by_id_u17,
           u06.u06_status_changed_date,
           u06.u06_last_activity_date,
           u06.u06_display_name,
           u01.u01_display_name,
           u01.u01_display_name_lang
      FROM u06_cash_account u06, u01_customer u01
     WHERE u06.u06_customer_id_u01 = u01.u01_id;
/