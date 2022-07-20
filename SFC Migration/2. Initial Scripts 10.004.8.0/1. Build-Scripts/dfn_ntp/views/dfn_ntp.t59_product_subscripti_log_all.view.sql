CREATE OR REPLACE FORCE VIEW dfn_ntp.t59_product_subscripti_log_all
(
    t59_id,
    t59_customer_id_u01,
    t59_customer_login_u09,
    t59_cash_acc_id_u06,
    t59_product_id_m152,
    t59_subfee_waiveof_grp_id_m154,
    t59_from_date,
    t59_to_date,
    t59_status,
    t59_no_of_months,
    t59_service_fee,
    t59_broker_fee,
    t59_vat_service_fee,
    t59_vat_broker_fee,
    t59_reject_reason,
    t59_datetime,
    t59_prod_subscription_id_t56,
    t59_institute_id_m02
)
AS
    SELECT t59_id,
           t59_customer_id_u01,
           t59_customer_login_u09,
           t59_cash_acc_id_u06,
           t59_product_id_m152,
           t59_subfee_waiveof_grp_id_m154,
           t59_from_date,
           t59_to_date,
           t59_status,
           t59_no_of_months,
           t59_service_fee,
           t59_broker_fee,
           t59_vat_service_fee,
           t59_vat_broker_fee,
           t59_reject_reason,
           t59_datetime,
           t59_prod_subscription_id_t56,
           t59_institute_id_m02
      FROM dfn_ntp.t59_product_subscription_log
    UNION ALL
    SELECT t59_id,
           t59_customer_id_u01,
           t59_customer_login_u09,
           t59_cash_acc_id_u06,
           t59_product_id_m152,
           t59_subfee_waiveof_grp_id_m154,
           t59_from_date,
           t59_to_date,
           t59_status,
           t59_no_of_months,
           t59_service_fee,
           t59_broker_fee,
           t59_vat_service_fee,
           t59_vat_broker_fee,
           t59_reject_reason,
           t59_datetime,
           t59_prod_subscription_id_t56,
           t59_institute_id_m02
      FROM dfn_arc.t59_product_subscription_log
/
