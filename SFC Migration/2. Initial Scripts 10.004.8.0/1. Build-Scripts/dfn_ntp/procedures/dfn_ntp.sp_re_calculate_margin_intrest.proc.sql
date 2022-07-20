CREATE OR REPLACE PROCEDURE dfn_ntp.sp_re_calculate_margin_intrest
IS
BEGIN
    FOR i
        IN (SELECT t21_id,
                   ABS (
                       ROUND (
                               t21.t21_ovedraw_amt
                             * (  (  DECODE (m74_add_or_sub_to_saibor_rate,
                                             1, -1,
                                             1)
                                   * NVL (m74_add_or_sub_rate, 0))
                                + (  DECODE (
                                         u23.u23_add_or_sub_to_saibor_rate,
                                         1, -1,
                                         1)
                                   * NVL (u23.u23_add_or_sub_rate, 0)))
                             / (100 * 360)
                           + m74_flat_fee
                           + u23.u23_flat_fee,
                           2))
                       AS new_interest_charge,
                   ROUND (
                         ABS (
                             ROUND (
                                     t21.t21_ovedraw_amt
                                   * (  (  DECODE (
                                               m74_add_or_sub_to_saibor_rate,
                                               1, -1,
                                               1)
                                         * NVL (m74_add_or_sub_rate, 0))
                                      + (  DECODE (
                                               u23.u23_add_or_sub_to_saibor_rate,
                                               1, -1,
                                               1)
                                         * NVL (u23.u23_add_or_sub_rate, 0)))
                                   / (100 * 360)
                                 + m74_flat_fee
                                 + u23.u23_flat_fee,
                                 2))
                       * NVL (m65_tax, 0)
                       / 100,
                       2)
                       AS new_tax_amount,
                     m65_rate
                   + (  DECODE (m74_add_or_sub_to_saibor_rate, 1, -1, 1)
                      * NVL (m74_add_or_sub_rate, 0))
                   + (  DECODE (u23.u23_add_or_sub_to_saibor_rate, 1, -1, 1)
                      * NVL (u23.u23_add_or_sub_rate, 0))
                       AS new_rate,
                   m74_flat_fee,
                   m65_rate,
                   m65_tax
            FROM t21_daily_interest_for_charges t21
                 JOIN u23_customer_margin_product u23
                     ON t21.t21_margin_product_id_u23 = u23.u23_id
                 JOIN m74_margin_interest_group m74
                     ON u23.u23_interest_group_id_m74 = m74.m74_id
                 JOIN m65_saibor_basis_rates m65
                     ON m65.m65_id = m74.m74_saibor_basis_group_id_m65
            WHERE     t21.t21_status = 0
                  AND t21.t21_value_date = TRUNC (func_get_eod_date)
                  AND TRUNC (LAST_DAY (TRUNC (func_get_eod_date))) =
                          TRUNC (func_get_eod_date))
    LOOP
        UPDATE t21_daily_interest_for_charges a
           SET a.t21_interest_charge_amt =
                   i.new_interest_charge + i.new_tax_amount,
               a.t21_interest_rate = ROUND (i.new_rate, 2),
               a.t21_flat_fee = i.m74_flat_fee,
               a.t21_orginal_rate = ROUND (i.new_rate, 2),
               a.t21_interest_indices_rate_m65 = ROUND (i.m65_rate, 2),
               a.t21_tax_rate = ROUND (i.m65_tax, 2),
               a.t21_tax_amount = i.new_tax_amount
         WHERE t21_id = i.t21_id;
    END LOOP;
END;
/