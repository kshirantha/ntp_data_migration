CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_i_beneficiary_accounts
  ("bnfId",
   "bnkAccNum",
   "curr",
   "instId",
   "accTyp",
   "sts",
   "accId",
   "cashAccId",
   "iban",
   "bankBrn",
   "bankCode",
   "bankName",
   "customerId" )
AS
SELECT
    U08_ID                  AS "bnfId",
    U08_ACCOUNT_NO          AS "bnkAccNum",
    U08_CURRENCY_CODE_M03   AS "curr",
    U08_INSTITUTE_ID_M02    AS "instId",
    U08_ACCOUNT_TYPE_V01_ID AS "accTyp",
    U08_STATUS_ID_V01       AS "sts",
    U08_ID                  AS "accId",
    U08_CASH_ACCOUNT_ID_U06 AS "cashAccId",
    U08_IBAN_NO             AS "iban",
    U08_BANK_BRANCH_NAME    AS "bankBrn",
    M16_SWIFT_CODE          AS "bankCode",
    M16_NAME                AS "bankName",
    U08_CUSTOMER_ID_U01     AS "customerId"
  FROM U08_CUSTOMER_BENEFICIARY_ACC, M16_BANK
  WHERE U08_BANK_ID_M16 = M16_ID (+)
/
