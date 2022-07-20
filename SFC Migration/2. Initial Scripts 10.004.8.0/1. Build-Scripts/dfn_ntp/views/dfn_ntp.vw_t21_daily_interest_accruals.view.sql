CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t21_daily_interest_accruals
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
   t21_trans_value_date,
   t21_approved_by_id_u17,
   t21_approved_date,
   t21_custom_type,
   t21_institute_id_m02,
   t21_custodian_id_m26,
   t21_u24_symbol_code_m20,
   t21_net_holding,
   t21_u24_symbol_id_m20,
   t21_u24_exchange_code_m01,
   t21_flat_fee,
   t21_orginal_rate,
   t21_margin_product_id_u23,
    t21_interest_indices_rate_m65,
    status
)
AS
SELECT a.t21_id,
           a.t21_cash_account_id_u06,
           a.t21_charges_id_m97,
           a.t21_interest_charge_amt,
           a.t21_created_date,
           a.t21_value_date,
           a.t21_status,
           a.t21_remarks,
           a.t21_cash_transaction_id_t06,
           a.t21_ovedraw_amt,
           a.t21_interest_rate,
           a.t21_posted_date,
           a.t21_frequency_id,
           a.t21_charges_code_m97,
           a.t21_created_by_id_u17,
           a.t21_trans_value_date,
           a.t21_approved_by_id_u17,
           a.t21_approved_date,
           a.t21_custom_type,
           a.t21_institute_id_m02,
           a.t21_custodian_id_m26,
           a.t21_u24_symbol_code_m20,
           a.t21_net_holding,
           a.t21_u24_symbol_id_m20,
           a.t21_u24_exchange_code_m01,
           a.t21_flat_fee,
           a.t21_orginal_rate,
           a.t21_margin_product_id_u23,
           a.t21_interest_indices_rate_m65,
           CASE a.t21_status
               WHEN 0 THEN 'Pending' --0 = Pending | 1 = Posted | 2 = Cancel | 3 = Adjusted | 4 = Cap-Adjusted | 5 = Invalidate by Adjust | 6 - Pending Manual Adjustment
               WHEN 1 THEN 'Capitalized'
               WHEN 2 THEN 'Cancelled'
               ELSE 'Unknown'
           END
               AS status
      FROM t21_daily_interest_for_charges a
/