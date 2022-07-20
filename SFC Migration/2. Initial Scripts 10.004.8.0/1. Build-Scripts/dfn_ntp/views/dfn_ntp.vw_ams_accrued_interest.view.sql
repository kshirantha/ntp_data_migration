CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_ams_accrued_interest
(
    id,
    u06_investment_account_no,
    interest_charge_amt,
    created_date,
    value_date,
    status,
    charge_type,
    ovedraw_amt,
    interest_rate,
    posted_date,
    orginal_rate,
    flat_rate,
    saibor_libor_fee,
    spread_fee,
    t75_broker_vat
)
AS
      SELECT t21_id AS id,
             u06.u06_investment_account_no,
             t21_interest_charge_amt AS interest_charge_amt,
             t21_created_date AS created_date,
             t21_value_date AS value_date,
             CASE
                 WHEN t21_status = 1 THEN 'Capitalized'
                 WHEN (t21_status = 2 OR t21_status = 5) THEN 'Cancelled'
                 ELSE 'Pending'
             END
                 AS status,
             m97.m97_description AS charge_type,
             t21_ovedraw_amt AS ovedraw_amt,
             t21_interest_rate AS interest_rate,
             t21_posted_date AS posted_date,
             t21_orginal_rate AS orginal_rate,
             t21_flat_fee AS flat_rate,
             t21_interest_indices_rate_m65 AS saibor_libor_fee,
             (t21_interest_rate - t21_interest_indices_rate_m65) AS spread_fee,
             t21_tax_amount AS t75_broker_vat
        FROM t21_daily_interest_for_charges t21
             INNER JOIN m97_transaction_codes m97
                 ON m97.m97_code = t21_charges_code_m97
             INNER JOIN u06_cash_account u06
                 ON u06.u06_id = t21.t21_cash_account_id_u06
    ORDER BY t21_created_date DESC
/
