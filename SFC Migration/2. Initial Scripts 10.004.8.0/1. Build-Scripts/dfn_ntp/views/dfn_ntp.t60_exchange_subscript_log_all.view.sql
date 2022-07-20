CREATE OR REPLACE FORCE VIEW dfn_ntp.t60_exchange_subscript_log_all
(
    t60_id,
    t60_customer_id_u01,
    t60_customer_login_u09,
    t60_cash_acc_id_u06,
    t60_exchange_product_id_m153,
    t60_subfee_waiveof_grp_id_m154,
    t60_from_date,
    t60_to_date,
    t60_status,
    t60_no_of_months,
    t60_exchange_fee,
    t60_vat_exchange_fee,
    t60_reject_reason,
    t60_datetime,
    t60_exg_subscription_id_t57,
    t60_institute_id_m02
)
AS
    SELECT t60_id,
           t60_customer_id_u01,
           t60_customer_login_u09,
           t60_cash_acc_id_u06,
           t60_exchange_product_id_m153,
           t60_subfee_waiveof_grp_id_m154,
           t60_from_date,
           t60_to_date,
           t60_status,
           t60_no_of_months,
           t60_exchange_fee,
           t60_vat_exchange_fee,
           t60_reject_reason,
           t60_datetime,
           t60_exg_subscription_id_t57,
           t60_institute_id_m02
      FROM dfn_ntp.t60_exchange_subscription_log
    UNION ALL
    SELECT t60_id,
           t60_customer_id_u01,
           t60_customer_login_u09,
           t60_cash_acc_id_u06,
           t60_exchange_product_id_m153,
           t60_subfee_waiveof_grp_id_m154,
           t60_from_date,
           t60_to_date,
           t60_status,
           t60_no_of_months,
           t60_exchange_fee,
           t60_vat_exchange_fee,
           t60_reject_reason,
           t60_datetime,
           t60_exg_subscription_id_t57,
           t60_institute_id_m02
      FROM dfn_arc.t60_exchange_subscription_log
/
