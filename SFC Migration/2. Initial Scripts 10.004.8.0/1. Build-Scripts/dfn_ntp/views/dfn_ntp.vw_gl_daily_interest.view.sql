CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_gl_daily_interest
(
    txn_code,
    cash_account_id_u06,
    institute_id_m02,
    txn_ref,
    txn_date,
    settle_date,
    amount_in_txn_currency,
    amount_in_stl_currency,
    currency_code_m03,
    currency_id_m03,
    transaction_desc,
    transaction_desc_lang
)
AS
    SELECT t21.t21_charges_code_m97 AS txn_code,
           t21.t21_cash_account_id_u06 AS cash_account_id_u06,
           t21.t21_institute_id_m02 AS institute_id_m02,
           t21.t21_id AS txn_ref,
           t21.t21_created_date AS txn_date,
           t21.t21_value_date AS settle_date,
           t21.t21_interest_charge_amt AS amount_in_txn_currency,
           t21.t21_interest_charge_amt AS amount_in_stl_currency,
           u06.u06_currency_code_m03 AS currency_code_m03,
           u06.u06_currency_id_m03 AS currency_id_m03,
           m97.m97_description AS transaction_desc,
           m97.m97_description_lang AS transaction_desc_lang
      FROM t21_daily_interest_for_charges t21
           JOIN u06_cash_account u06
               ON t21.t21_cash_account_id_u06 = u06.u06_id
           JOIN m97_transaction_codes m97
               ON t21.t21_charges_id_m97 = m97.m97_id
/