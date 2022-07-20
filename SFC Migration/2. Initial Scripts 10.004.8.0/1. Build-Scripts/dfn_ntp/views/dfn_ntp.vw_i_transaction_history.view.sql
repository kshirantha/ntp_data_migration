CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_i_transaction_history (
   "chTranId",
   "cashAccId",
   "trnCde",
   "trnTyp",
   "date",
   "date_",
   "valDte",
   "cqDte",
   "sts",
   "invAccNum",
   "payMtd",
   "narr",
   "curr",
   "amt",
   "refId",
   "bnkAccNum",
   "bankAcc",
   "bank",
   "bnkBrn",
   "bnkAdr",
   "bnkChrg",
   "widwTyp",
   "b2bSts",
   "customerId",
   "customerNo",
   "systemApproval" )
AS
SELECT t06_id AS "chTranId",
       t06_cash_acc_id_u06 AS "cashAccId",
       t06_code AS "trnCde",
       m97_id AS "trnTyp",
       TO_CHAR (t06_date, 'YYYYMMDDHHmmSS') AS "date",
       t06_date as date_,
       TO_CHAR (t06_settlement_date, 'YYYYMMDD') AS "valDte",
       TO_CHAR (t06_cheque_date, 'YYYYMMDD') AS "cqDte",
       t06_status_id AS "sts",
       u06_investment_account_no AS "invAccNum",
       t06_payment_method AS "payMtd",
       t06_narration AS "narr",
       t06_txn_code_m03 AS "curr",
       t06_amt_in_txn_currency AS "amt",
       t06_id AS "refId",
           u08.u08_account_no AS "bnkAccNum",
           u08.u08_account_name AS "bankAcc",
           NULL AS "bank",
       t06_branch AS "bnkBrn",
       NULL AS "bnkAdr",
       t06_thirdparty_fee AS "bnkChrg",
       0 AS "widwTyp",
       0 AS "b2bSts",
       u06_customer_id_u01 AS "customerId",
       u06_customer_no_u01 AS "customerNo",
	   t06_system_approval As "systemApproval"
  FROM t06_cash_transaction_all
       JOIN u06_cash_account
           ON u06_id = t06_cash_acc_id_u06
       JOIN vw_m97_cash_txn_codes_base
           ON m97_code = t06_code
       LEFT OUTER JOIN u08_customer_beneficiary_acc u08
               ON u08.u08_id = t06_beneficiary_id_u08
/
