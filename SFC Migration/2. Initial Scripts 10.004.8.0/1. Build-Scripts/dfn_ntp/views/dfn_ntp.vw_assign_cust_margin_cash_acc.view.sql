CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_assign_cust_margin_cash_acc
(
    other_cash_acc_ids_u06,
    default_cash_acc_id_u06,
    customer_id
)
AS
    SELECT u23_other_cash_acc_ids_u06 AS other_cash_acc_ids_u06,
           u23_default_cash_acc_id_u06 AS default_cash_acc_id_u06,
           u23_customer_id_u01 AS customer_id
      FROM u23_customer_margin_product
     WHERE u23_status_id_v01 NOT IN (3, 5) -- without deleted and rejected
    UNION
    SELECT t24_other_cash_acc_ids_u06 AS other_cash_acc_ids_u06,
           t24_default_cash_acc_id_u06 AS default_cash_acc_id_u06,
           t24_customer_id_u01 AS customer_id
      FROM t24_customer_margin_request
     WHERE t24_status_id_v01 NOT IN (2, 5) -- pending records
/