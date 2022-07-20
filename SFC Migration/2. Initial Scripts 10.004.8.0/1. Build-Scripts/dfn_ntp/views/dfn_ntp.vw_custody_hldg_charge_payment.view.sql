CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_custody_hldg_charge_payment
(
    t21_custodian_id_m26,
    m26_name,
    last_payment_date,
    next_payment_date,
    t21_frequency_id,
    t21_institute_id_m02,
    payment_frequency
)
AS
      SELECT t21_custodian_id_m26,
             m26.m26_name,
             MAX (m26.m26_hold_chrg_last_pay_date) last_payment_date,
             MAX (t21_value_date) AS next_payment_date,
             t21.t21_frequency_id,
             t21.t21_institute_id_m02,
             CASE t21.t21_frequency_id
                 WHEN 1 THEN 'Daily'
                 WHEN 2 THEN 'Weekly'
                 WHEN 3 THEN 'Monthly'
             END
                 AS payment_frequency
        FROM     t21_daily_interest_for_charges t21
             INNER JOIN
                 m26_executing_broker m26
             ON t21.t21_custodian_id_m26 = m26.m26_id
       WHERE t21_charges_code_m97 = 'CUDYHLDFEE' AND t21_status = 0
    GROUP BY t21_custodian_id_m26,
             m26.m26_name,
             t21_institute_id_m02,
             t21_frequency_id
/
