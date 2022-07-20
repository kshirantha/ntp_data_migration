CREATE OR REPLACE PROCEDURE dfn_ntp.sp_re_calculate_margn_intrst_b (
    ptype   IN NUMBER -- 0 -> LOCAL, 1 -> INTL
                     )
IS
BEGIN
    FOR i
        IN (SELECT t21_id,
                   ABS (
                       ROUND (
                               t21.t21_ovedraw_amt
                             * (  m65_rate
                                + NVL (
                                        DECODE (
                                            m74_add_or_sub_to_saibor_rate,
                                            1, -1,
                                            1)
                                      * m74_add_or_sub_rate,
                                      0)
                                + NVL (
                                        DECODE (
                                            u23.u23_add_or_sub_to_saibor_rate,
                                            1, -1,
                                            1)
                                      * u23.u23_add_or_sub_rate,
                                      0))
                             / (100 * 360)
                           + NVL (m74_flat_fee, 0)
                           + NVL (u23.u23_flat_fee, 0),
                           2))
                       AS new_interest_charge,
                   ROUND (
                         ABS (
                             ROUND (
                                     t21.t21_ovedraw_amt
                                   * (  m65_rate
                                      + NVL (
                                              DECODE (
                                                  m74_add_or_sub_to_saibor_rate,
                                                  1, -1,
                                                  1)
                                            * m74_add_or_sub_rate,
                                            0)
                                      + NVL (
                                              DECODE (
                                                  u23.u23_add_or_sub_to_saibor_rate,
                                                  1, -1,
                                                  1)
                                            * u23.u23_add_or_sub_rate,
                                            0))
                                   / (100 * 360)
                                 + NVL (m74_flat_fee, 0)
                                 + NVL (u23.u23_flat_fee, 0),
                                 2))
                       * NVL (m65_tax, 0)
                       / 100,
                       2)
                       AS new_tax_amount,
                     NVL (
                           DECODE (m74_add_or_sub_to_saibor_rate, 1, -1, 1)
                         * m74_add_or_sub_rate,
                         0)
                   + NVL (
                           DECODE (u23.u23_add_or_sub_to_saibor_rate,
                                   1, -1,
                                   1)
                         * u23.u23_add_or_sub_rate,
                         0)
                       AS new_spread_rate,
                   NVL (m74_flat_fee, 0) + NVL (u23.u23_flat_fee, 0)
                       AS flat_fee,
                   m65_rate,
                   t21_interest_rate
                       AS orginal_rate,
                   m65_tax,
                     NVL (m74_add_or_sub_rate, 0)
                   + NVL (u23_add_or_sub_rate, 0)
                       AS spread_rate,
                   DECODE (u23.u23_add_or_sub_to_saibor_rate, 1, -1, 1) -- take only this due to m74 null or 0 in sfc
                       AS add_or_sub_spread,
                   ABS (
                       ROUND (
                             t21.t21_ovedraw_amt
                           * (  NVL (
                                      DECODE (m74_add_or_sub_to_saibor_rate,
                                              1, -1,
                                              1)
                                    * m74_add_or_sub_rate,
                                    0)
                              + NVL (
                                      DECODE (
                                          u23.u23_add_or_sub_to_saibor_rate,
                                          1, -1,
                                          1)
                                    * u23.u23_add_or_sub_rate,
                                    0))
                           / (100 * 360),
                           2))
                       AS spread_amount
            FROM t21_daily_interest_for_charges t21
                 JOIN u06_cash_account u06
                     ON t21.t21_cash_account_id_u06 = u06.u06_id
                 JOIN u23_customer_margin_product u23
                     ON t21.t21_margin_product_id_u23 = u23.u23_id
                 JOIN m74_margin_interest_group m74
                     ON u23.u23_interest_group_id_m74 = m74.m74_id
                 JOIN m65_saibor_basis_rates m65
                     ON m65.m65_id = m74.m74_saibor_basis_group_id_m65
            WHERE     t21.t21_status = 0
                  AND (   (ptype = 0 --LOCAL
                                     AND u06.u06_currency_code_m03 = 'SAR')
                       OR (ptype = 1 -- INTL
                                     AND u06.u06_currency_code_m03 != 'SAR'))
                  AND t21.t21_value_date = TRUNC (func_get_eod_date)
                  AND TRUNC (LAST_DAY (TRUNC (func_get_eod_date))) =
                      TRUNC (func_get_eod_date))
    LOOP
        UPDATE t21_daily_interest_for_charges a
        SET a.t21_interest_charge_amt =
                i.new_interest_charge + i.new_tax_amount,
            a.t21_interest_rate = i.m65_rate,
            a.t21_flat_fee = i.flat_fee,
            --a.t21_orginal_rate = i.orginal_rate,
            a.t21_interest_indices_rate_m65 = i.m65_rate,
            a.t21_tax_rate = i.m65_tax,
            a.t21_tax_amount = i.new_tax_amount,
            a.t21_add_or_sub_to_saibor_rt_b = i.add_or_sub_spread,
            a.t21_add_or_sub_rate_b = i.spread_rate,
            a.t21_spread_amount_b = i.spread_amount
        WHERE t21_id = i.t21_id;
    END LOOP;
END;
/