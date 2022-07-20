CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_accrued_interest_adjst_list
(
    t21_id,
    t21_cash_account_id_u06,
    t21_charges_id_m97,
    t21_interest_charge_amt,
    t21_created_date,
    t21_value_date,
    t21_status,
    t21_remarks,
    t21_cash_transaction_id_t06,
    t21_ovedraw_amt,
    t21_interest_rate,
    t21_posted_date,
    t21_frequency_id,
    t21_charges_code_m97,
    t21_created_by_id_u17,
    t21_approved_by_id_u17,
    t21_approved_date,
    t21_trans_value_date,
    created_by_full_name,
    approved_by_full_name,
    cash_account,
    status_description,
    m97_description,
    u06_display_name_u01,
    u06_display_name,
    u06_institute_id_m02
)
AS
    SELECT t21.t21_id,
           t21.t21_cash_account_id_u06,
           t21.t21_charges_id_m97,
           t21.t21_interest_charge_amt,
           t21.t21_created_date,
           t21.t21_value_date,
           t21.t21_status,
           t21.t21_remarks,
           t21.t21_cash_transaction_id_t06,
           t21.t21_ovedraw_amt,
           t21.t21_interest_rate,
           t21.t21_posted_date,
           t21.t21_frequency_id,
           t21.t21_charges_code_m97,
           t21.t21_created_by_id_u17,
           t21.t21_approved_by_id_u17,
           t21.t21_approved_date,
           t21.t21_trans_value_date,
           u17_created_by.u17_full_name AS created_by_full_name,
           u17_approved_by.u17_full_name AS approved_by_full_name,
           u06.u06_display_name AS cash_account,
           DECODE (t21.t21_status,
                   0, 'Pending',
                   1, 'Accrued',
                   2, 'Cancel',
                   3, 'Adjusted',
                   4, 'Cap-adjusted',
                   5, 'Invalidate by adjust',
                   6, 'Pending-Manual Adjustment',
                   7, 'Sent to Bank')
               AS status_description,
           m97.m97_description,
           u06.u06_display_name_u01,
           u06.u06_display_name,
           u06.u06_institute_id_m02
      FROM t21_daily_interest_for_charges t21
           JOIN u17_employee u17_created_by
               ON t21.t21_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_approved_by
               ON t21.t21_approved_by_id_u17 = u17_approved_by.u17_id
           JOIN u06_cash_account u06
               ON t21.t21_cash_account_id_u06 = u06.u06_id
           JOIN vw_m97_cash_txn_codes_base m97
               ON t21.t21_charges_id_m97 = m97.m97_id
           JOIN u06_cash_account u06
               ON t21.t21_cash_account_id_u06 = u06.u06_id
     WHERE m97_code IN
               ('WODINT_ADJ', 'RODINT_ADJ', 'MGNFEE_ADJ', 'IODINT_ADJ');
/
