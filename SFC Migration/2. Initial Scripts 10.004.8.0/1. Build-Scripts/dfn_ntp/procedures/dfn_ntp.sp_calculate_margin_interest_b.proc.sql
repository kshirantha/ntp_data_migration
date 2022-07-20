CREATE OR REPLACE PROCEDURE dfn_ntp.sp_calculate_margin_interest_b (
    ptype   IN NUMBER -- 0 -> LOCAL, 1 -> INTL
                     )
IS
    l_m97_id           NUMBER;
    l_eod_date         DATE := func_get_eod_date;
    l_t21_value_date   t21_daily_interest_for_charges.t21_value_date%TYPE;
BEGIN
    SELECT MAX (m97_id)
    INTO l_m97_id
    FROM m97_transaction_codes
    WHERE m97_code = 'MGNFEE';

    FOR i
        IN (SELECT u23_default_cash_acc_id_u06,
                   u06_institute_id_m02,
                   m74_capitalization_frequency,
                   fn_get_posted_date (m74_capitalization_frequency,
                                       l_eod_date) AS post_or_value_date,
                   CASE
                       WHEN m74_interest_basis = 1
                       THEN
                           ABS (limit_utilization)
                       WHEN m74_interest_basis = 2
                       THEN
                           u23_max_margin_limit
                   END AS margin_amount,
                   ROUND (
                           CASE
                               WHEN m74_interest_basis = 1
                               THEN
                                   ABS (limit_utilization)
                               WHEN m74_interest_basis = 2
                               THEN
                                   u23_max_margin_limit
                           END
                         * (m65_rate + spread_rate)
                         / (100 * 360)
                       + flat_fee,
                       2) AS margin_fee,
                   spread_rate,
                   m65_rate,
                   flat_fee,
                   add_or_sub_spread,
                   tax_pct_m65,
                   ROUND (
                         ABS (
                             ROUND (
                                     CASE
                                         WHEN m74_interest_basis = 1
                                         THEN
                                             ABS (limit_utilization)
                                         WHEN m74_interest_basis = 2
                                         THEN
                                             u23_max_margin_limit
                                     END
                                   * (m65_rate + spread_rate)
                                   / (100 * 360)
                                 + flat_fee,
                                 2))
                       * tax_pct_m65
                       / 100,
                       2) AS tax_amount,
                   ABS (
                       ROUND (
                             CASE
                                 WHEN m74_interest_basis = 1
                                 THEN
                                     ABS (limit_utilization)
                                 WHEN m74_interest_basis = 2
                                 THEN
                                     u23_max_margin_limit
                             END
                           * spread_rate
                           / (100 * 360),
                           2)) AS spread_amount,
                   u23_id
            FROM (SELECT u23.u23_id,
                         u23.u23_default_cash_acc_id_u06,
                         u23.u23_max_margin_limit
                             AS u23_max_margin_limit,
                         u23.u23_status_id_v01,
                         u23.u23_margin_expiry_date,
                           CASE
                               WHEN (u06.u06_balance + u06.u06_payable_blocked - u06.u06_receivable_amount) < 0
                               THEN
                                   (u06.u06_balance + u06.u06_payable_blocked - u06.u06_receivable_amount)
                               ELSE
                                   0
                           END
                         + u06.u06_loan_amount
                             AS limit_utilization,
                         m74.m74_interest_basis,
                         m74.m74_capitalization_frequency,
                         NVL (m65_rate, 0)
                             m65_rate,
                           NVL (
                                 DECODE (m74_add_or_sub_to_saibor_rate,
                                         1, -1,
                                         1)
                               * m74_add_or_sub_rate,
                               0)
                         + NVL (
                                 DECODE (u23.u23_add_or_sub_to_saibor_rate,
                                         1, -1,
                                         1)
                               * u23.u23_add_or_sub_rate,
                               0)
                             AS spread_rate,
                         NVL (m65.m65_tax, 0)
                             AS tax_pct_m65,
                         NVL (m74_flat_fee, 0) + NVL (u23.u23_flat_fee, 0)
                             AS flat_fee,
                         u06.u06_margin_enabled,
                         u06.u06_institute_id_m02,
                         DECODE (u23.u23_add_or_sub_to_saibor_rate, 1, -1, 1) -- take only this due to m74 null or 0 in sfc
                             AS add_or_sub_spread
                  FROM u23_customer_margin_product u23
                       JOIN u06_cash_account u06
                           ON     u23.u23_default_cash_acc_id_u06 =
                                  u06.u06_id
                              AND (   (    ptype = 0 --LOCAL
                                       AND u06.u06_currency_code_m03 = 'SAR')
                                   OR (    ptype = 1 -- INTL
                                       AND u06.u06_currency_code_m03 != 'SAR'))
                              AND u06.u06_margin_enabled = 1
                              AND (  u06.u06_balance
                                   - u06.u06_loan_amount
                                   + u06.u06_payable_blocked
                                   - u06.u06_receivable_amount) <
                                  0
                       JOIN m74_margin_interest_group m74
                           ON u23.u23_interest_group_id_m74 = m74.m74_id
                       JOIN m65_saibor_basis_rates m65
                           ON m65.m65_id = m74.m74_saibor_basis_group_id_m65
                  WHERE     u23.u23_status_id_v01 IN (2, 21, 4)
                        AND u23.u23_margin_expiry_date >=
                            TRUNC (l_eod_date) + 0.99999))
    LOOP
        IF i.margin_fee > 0
        THEN
            INSERT INTO t21_daily_interest_for_charges (
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
                            t21_tax_rate,
                            t21_add_or_sub_to_saibor_rt_b,
                            t21_add_or_sub_rate_b,
                            t21_spread_amount_b)
            VALUES (fn_get_next_sequnce ('T21_DAILY_INTEREST_FOR_CHARGES'),
                    i.u23_default_cash_acc_id_u06,
                    l_m97_id,
                    i.margin_fee,
                    l_eod_date,
                    i.post_or_value_date,
                    0,
                    'Margin Interest Accrual',
                    NULL,
                    i.margin_amount,
                    i.m65_rate,
                    NULL,
                    i.m74_capitalization_frequency,
                    'MGNFEE',
                    0,
                    i.post_or_value_date,
                    NULL,
                    NULL,
                    i.u06_institute_id_m02,
                    i.flat_fee,
                    i.m65_rate, --t21_orginal_rate
                    i.u23_id,
                    i.m65_rate, -- t21_interest_indices_rate_m65
                    i.tax_amount,
                    i.tax_pct_m65, --t21_tax_rate
                    i.add_or_sub_spread, --t21_add_or_sub_to_saibor_rt_b
                    i.spread_rate,
                    i.spread_amount);

            UPDATE u06_cash_account u06
            SET u06.u06_accrued_interest =
                    u06.u06_accrued_interest + i.margin_fee,
                u06.u06_last_activity_date = l_eod_date
            WHERE u06.u06_id = i.u23_default_cash_acc_id_u06;
        END IF;
    END LOOP;

    SELECT MAX (m97_id)
    INTO l_m97_id
    FROM m97_transaction_codes
    WHERE m97_code = 'ODINT';

    l_t21_value_date := fn_get_posted_date (1, l_eod_date);

    FOR i
        IN (SELECT u06_id,
                   od_amount,
                   interest_rate,
                   m118_broker_vat,
                   ROUND (ABS (od_amount * interest_rate / 36000), 2)
                       AS margin_fee,
                   ROUND (
                         ROUND (ABS (od_amount * interest_rate / 36000), 2)
                       * NVL (m118_broker_vat, 0)
                       / 100,
                       2)
                       AS tax_amount
            FROM (SELECT u06.u06_id,
                         u06.u06_institute_id_m02,
                           u06.u06_balance
                         + u06.u06_payable_blocked
                         - u06.u06_receivable_amount
                         - u06.u06_loan_amount
                             AS od_amount,
                         NVL (m118_interest_rate,
                              NVL (m02.m02_overdrawn_interest_rate, 0))
                             interest_rate,
                         m118_broker_vat
                  FROM u23_customer_margin_product u23,
                       m02_institute m02,
                       u06_cash_account u06,
                       (SELECT m118_group_id_m117,
                               NVL (MAX (m118_interest_rate), 0)
                                   m118_interest_rate,
                               NVL (MAX (m118_broker_vat), 0)
                                   m118_broker_vat,
                               m118_currency_code_m03
                        FROM m118_charge_fee_structure m118
                        WHERE m118_charge_code_m97 = 'ODINT'
                        GROUP BY m118_group_id_m117, m118_currency_code_m03)
                       m118
                  WHERE     u23.u23_id = u06.u06_margin_product_id_u23
                        AND u23.u23_default_cash_acc_id_u06 <> u06.u06_id
                        AND u06.u06_institute_id_m02 = m02.m02_id
                        AND u06.u06_charges_group_m117 =
                            m118.m118_group_id_m117(+)
                        AND (   (    ptype = 0 --LOCAL
                                 AND u06.u06_currency_code_m03 = 'SAR')
                             OR (    ptype = 1 -- INTL
                                 AND u06.u06_currency_code_m03 != 'SAR'))
                        AND u06.u06_currency_code_m03 =
                            m118.m118_currency_code_m03(+)
                        AND u23.u23_status_id_v01 IN (2, 21, 4)
                        AND u23.u23_margin_expiry_date >=
                            TRUNC (l_eod_date) + 0.99999
                        AND (  u06.u06_balance
                             + u06.u06_payable_blocked
                             - u06.u06_receivable_amount) <
                            0))
    LOOP
        IF i.margin_fee > 0
        THEN
            INSERT INTO t21_daily_interest_for_charges (
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
                            t21_tax_amount,
                            t21_tax_rate)
            VALUES (fn_get_next_sequnce ('T21_DAILY_INTEREST_FOR_CHARGES'),
                    i.u06_id,
                    l_m97_id,
                    i.margin_fee,
                    l_eod_date,
                    l_t21_value_date,
                    0,
                    '',
                    NULL,
                    i.od_amount,
                    i.interest_rate,
                    NULL,
                    1,
                    'ODINT',
                    0,
                    NULL,
                    i.tax_amount,
                    i.m118_broker_vat);

            UPDATE u06_cash_account u06
            SET u06.u06_accrued_interest =
                    u06.u06_accrued_interest + i.margin_fee,
                u06.u06_last_activity_date = l_eod_date
            WHERE u06.u06_id = i.u06_id;
        END IF;
    END LOOP;
END;
/