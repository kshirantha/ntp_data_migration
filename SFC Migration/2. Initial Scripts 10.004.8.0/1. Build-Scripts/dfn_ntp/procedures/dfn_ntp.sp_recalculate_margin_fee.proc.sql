CREATE OR REPLACE PROCEDURE dfn_ntp.sp_recalculate_margin_fee (
    p_view              OUT SYS_REFCURSOR,
    prows               OUT NUMBER,
    psortby                 VARCHAR2 DEFAULT NULL,
    pcashaccountid   IN     NUMBER,
    prate            IN     NUMBER,
    pfromdate        IN     DATE,
    ptodate          IN     DATE)
IS
BEGIN
    MERGE INTO t21_daily_interest_for_charges t21
    USING m65_saibor_basis_rates m65
    ON (    m65.m65_id = t21.t21_interest_indices_rate_m65
        AND t21_cash_account_id_u06 = pcashaccountid
        AND TRUNC (pfromdate) <= TRUNC (t21_created_date)
        AND TRUNC (t21_created_date) <= TRUNC (ptodate)
        AND t21_charges_code_m97 = 'MGNFEE'
        AND t21_status = 0)
    WHEN MATCHED
    THEN
        UPDATE SET
            t21.t21_interest_charge_amt =
                  ROUND (
                      (t21.t21_ovedraw_amt * prate / 36000 + t21.t21_flat_fee),
                      5)
                + ROUND (
                        ROUND (
                            (  t21.t21_ovedraw_amt * prate / 36000
                             + t21.t21_flat_fee),
                            5)
                      * NVL (m65.m65_tax, 0)
                      / 100,
                      5),
            t21.t21_interest_rate = prate,
            t21.t21_interest_indices_rate_m65 = m65.m65_rate,
            t21.t21_tax_rate = m65.m65_tax,
            t21.t21_tax_amount =
                ROUND (
                      ROUND (
                          (  t21.t21_ovedraw_amt * prate / 36000
                           + t21.t21_flat_fee),
                          5)
                    * NVL (m65.m65_tax, 0)
                    / 100,
                    5),
            t21.t21_add_or_sub_to_saibor_rt_b = 0, -- set 0 due to manual calculation is considered as the final value
            t21.t21_add_or_sub_rate_b = 0, -- set 0 due to manual calculation is considered as the final value
            t21.t21_spread_amount_b = 0 -- set 0 due to manual calculation is considered as the final value
                                       ;

    OPEN p_view FOR
        SELECT a.t21_created_date,
               t21_ovedraw_amt,
               t21_interest_rate,
               t21_flat_fee,
               CASE
                   WHEN t21_status = 0
                   THEN
                         ROUND (t21_ovedraw_amt * (t21_orginal_rate) / 36000,
                                5)
                       + t21_flat_fee
                   ELSE
                       a.t21_interest_charge_amt
               END AS t21_interest_charge_amt,
               CASE
                   WHEN t21_status = 0 THEN a.t21_interest_charge_amt
                   ELSE NULL
               END AS re_calculated_interest,
               CASE a.t21_status
                   WHEN 0 THEN 'Pending' --0 = Pending | 1 = Posted | 2 = Cancel | 3 = Adjusted | 4 = Cap-Adjusted | 5 = Invalidate by Adjust | 6 - Pending Manual Adjustment
                   WHEN 1 THEN 'Capitalized'
                   WHEN 2 THEN 'Cancelled'
                   ELSE 'Unknown'
               END AS status
        FROM t21_daily_interest_for_charges a
        WHERE     a.t21_cash_account_id_u06 = pcashaccountid
              AND TRUNC (pfromdate) <= TRUNC (t21_created_date)
              AND TRUNC (t21_created_date) <= TRUNC (ptodate)
              AND a.t21_charges_code_m97 = 'MGNFEE';
END;
/