CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_ams_cash_transaction_list
(
    transactionid,
    transactiondate,
    fromacc,
    toacc,
    narration,
    paymentmethod,
    currency,
    amount,
    t06_amt_in_settle_currency,
    approveddate,
    status,
    t12_exchange_vat,
    t12_broker_vat,
    total_vat,
    cpt,
    customername,
    t06_status_id,
    t06_code
)
AS
    SELECT t06_id AS transactionid,
           t06_date AS transactiondate,
           u06.u06_investment_account_no AS fromacc,
           u06_other.u06_investment_account_no AS toacc,
           t06.t06_narration AS narration,
           t06.t06_payment_method AS paymentmethod,
           u06.u06_currency_code_m03 AS currency,
           t06.t06_amt_in_txn_currency AS amount,
           t06.t06_amt_in_settle_currency,
           a09_approve_2.a09_action_date AS approveddate,
           v01.v01_description AS status,
           t06.t06_exg_vat AS t12_exchange_vat,
           t06.t06_brk_vat AS t12_broker_vat,
           (t06.t06_exg_vat + t06.t06_brk_vat) AS total_vat,
           u01.u01_customer_no cpt,
           u01.u01_display_name AS customername,
           t06.t06_status_id,
           t06.t06_code
      FROM t06_cash_transaction t06
           INNER JOIN u06_cash_account u06
               ON u06.u06_id = t06.t06_cash_acc_id_u06
           LEFT OUTER JOIN u06_cash_account u06_other
               ON u06_other.u06_id = t06.t06_to_cash_acc_id
           LEFT OUTER JOIN a09_function_approval_log_all a09_approve_2
               ON     a09_approve_2.a09_request_id = t06_id
                  AND a09_approve_2.a09_status_id_v01 = 2
           LEFT OUTER JOIN u17_employee approve_2
               ON approve_2.u17_id = a09_approve_2.a09_action_by_id_u17
           INNER JOIN v01_system_master_data v01
               ON t06.t06_status_id = v01.v01_id AND v01_type = 4
           INNER JOIN u01_customer u01
               ON u01.u01_id = u06.u06_customer_id_u01
/
