CREATE OR REPLACE PROCEDURE dfn_ntp.sp_calculate_margin_interest
IS
    l_m97_id     NUMBER;
    l_eod_date   DATE := func_get_eod_date ();

    CURSOR c_margin_fees
    IS
        SELECT default_cash_acc_id,
               u06_institute_id_m02,
               net_rate,
               flat_fee,
               capitalization_frequency,
               fn_get_posted_date (capitalization_frequency, l_eod_date)
                   AS post_or_value_date,
               CASE
                   WHEN interest_basis = 1 THEN ABS (total_cash_balance)
                   WHEN interest_basis = 2 THEN max_margin_limit
               END
                   AS margin_amount,
               ROUND (
                       CASE
                           WHEN interest_basis = 1
                           THEN
                               ABS (total_cash_balance)
                           WHEN interest_basis = 2
                           THEN
                               max_margin_limit
                       END
                     * net_rate
                     / (100 * 360)
                   + flat_fee,
                   2)
                   AS margin_fee,
               u23_id,
               m65_rate,
               m65_tax,
               ROUND (
                     ROUND (
                             CASE
                                 WHEN interest_basis = 1
                                 THEN
                                     ABS (total_cash_balance)
                                 WHEN interest_basis = 2
                                 THEN
                                     max_margin_limit
                             END
                           * net_rate
                           / (100 * 360)
                         + flat_fee,
                         2)
                   * m65_tax
                   / 100,
                   2)
                   AS tax_amount
          FROM (SELECT u23_id,
                       MAX (margin.u23_default_cash_acc_id_u06)
                           AS default_cash_acc_id,
                       SUM (margin.total_cash_balance) AS total_cash_balance,
                       MAX (margin.max_margin_limit) AS max_margin_limit,
                       MAX (margin.net_rate) AS net_rate,
                       MAX (margin.tax_pct_m65) AS tax_rate,
                       MAX (margin.flat_fee) AS flat_fee,
                       MAX (margin.m74_capitalization_frequency)
                           AS capitalization_frequency,
                       MAX (margin.m74_interest_basis) AS interest_basis,
                       MAX (u06_institute_id_m02) AS u06_institute_id_m02,
                       MAX (margin.m65_rate) AS m65_rate,
                       MAX (margin.m65_tax) AS m65_tax
                  FROM (SELECT u23.u23_id,
                               u23.u23_default_cash_acc_id_u06,
                                 u23.u23_max_margin_limit
                               * get_exchange_rate (
                                     u06.u06_institute_id_m02,
                                     u06.u06_currency_code_m03,
                                     u06_default.u06_currency_code_m03)
                                   AS max_margin_limit,
                               u23.u23_status_id_v01,
                               u23.u23_margin_expiry_date,
                                 -1
                               * (  u06.u06_balance
                                  + u06.u06_payable_blocked
                                  - u06.u06_receivable_amount
                                  - u06.u06_loan_amount)
                               * get_exchange_rate (
                                     u06.u06_institute_id_m02,
                                     u06.u06_currency_code_m03,
                                     u06_default.u06_currency_code_m03)
                                   AS total_cash_balance,
                               m74.m74_interest_basis,
                               m74.m74_capitalization_frequency,
                                 --m74.m74_net_rate,
                                 m65_rate
                               + (  DECODE (m74_add_or_sub_to_saibor_rate,
                                            1, -1,
                                            1)
                                  * NVL (m74_add_or_sub_rate, 0))
                               + (  DECODE (
                                        u23.u23_add_or_sub_to_saibor_rate,
                                        1, -1,
                                        1)
                                  * NVL (u23.u23_add_or_sub_rate, 0))
                                   AS net_rate,
                               NVL (m65.m65_tax, 0) AS tax_pct_m65,
                                 (m74.m74_flat_fee + u23.u23_flat_fee)
                               * get_exchange_rate (
                                     u06.u06_institute_id_m02,
                                     u06.u06_currency_code_m03,
                                     u06_default.u06_currency_code_m03)
                                   AS flat_fee,
                               u06.u06_margin_enabled,
                               u06.u06_institute_id_m02,
                               m74_id,
                               m65_rate,
                               NVL (m65.m65_tax, 0) AS m65_tax
                          FROM u06_cash_account u06
                               JOIN m02_institute m02
                                   ON u06.u06_institute_id_m02 = m02.m02_id
                               JOIN u23_customer_margin_product u23
                                   ON u06.u06_margin_product_id_u23 =
                                          u23.u23_id
                               JOIN u06_cash_account u06_default
                                   ON u23.u23_default_cash_acc_id_u06 =
                                          u06_default.u06_id
                               JOIN m74_margin_interest_group m74
                                   ON u23.u23_interest_group_id_m74 =
                                          m74.m74_id
                               JOIN m65_saibor_basis_rates m65
                                   ON m65.m65_id =
                                          m74.m74_saibor_basis_group_id_m65
                         WHERE     u06.u06_margin_enabled = 1
                               AND (  u06.u06_balance
                                    - u06.u06_loan_amount
                                    + u06.u06_payable_blocked
                                    - u06.u06_receivable_amount) < 0) margin
                 WHERE     margin.u06_margin_enabled = 1
                       AND margin.u23_status_id_v01 IN (2, 21, 4)
                       AND TRUNC (margin.u23_margin_expiry_date) >
                               TRUNC (SYSDATE)
                GROUP BY margin.u23_id);
BEGIN
    SELECT MAX (m97_id)
      INTO l_m97_id
      FROM m97_transaction_codes
     WHERE m97_code = 'MGNFEE';

    FOR i IN c_margin_fees
    LOOP
        IF i.margin_fee > 0
        THEN
            INSERT
              INTO t21_daily_interest_for_charges (
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
                       t21_institute_id_m02,
                       t21_flat_fee,
                       t21_orginal_rate,
                       t21_margin_product_id_u23,
                       t21_interest_indices_rate_m65,
                       t21_tax_amount,
                       t21_tax_rate)
            VALUES (fn_get_next_sequnce ('T21_DAILY_INTEREST_FOR_CHARGES'),
                    i.default_cash_acc_id,
                    l_m97_id,
                    i.margin_fee + i.tax_amount,
                    l_eod_date,
                    i.post_or_value_date,
                    0,
                    'Margin Interest Accrual',
                    NULL,
                    i.margin_amount,
                    i.net_rate,
                    NULL,
                    i.capitalization_frequency,
                    'MGNFEE',
                    0,
                    i.post_or_value_date,
                    NULL,
                    NULL,
                    i.u06_institute_id_m02,
                    i.flat_fee,
                    i.net_rate,
                    i.u23_id,
                    i.m65_rate, -- t21_interest_indices_rate_m65
                    i.tax_amount,
                    i.m65_tax);

            UPDATE u06_cash_account u06
               SET u06.u06_accrued_interest =
                       u06.u06_accrued_interest + i.margin_fee,
                   u06.u06_last_activity_date = l_eod_date
             WHERE u06.u06_id = i.default_cash_acc_id;
        END IF;
    END LOOP;
END;
/