CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_pending_margin_fee (
    p_view                          OUT SYS_REFCURSOR,
    prows                           OUT NUMBER,
    pinstituteid                 IN     NUMBER,
    pt21_margin_product_id_u23   IN     NUMBER)
IS
BEGIN
    OPEN p_view FOR
        SELECT a.t21_cash_account_id_u06,
               a.t21_created_date,
               a.t21_interest_charge_amt,
               a.t21_interest_rate,
               a.t21_flat_fee
          FROM t21_daily_interest_for_charges a
         WHERE     a.t21_margin_product_id_u23 = pt21_margin_product_id_u23
               AND a.t21_status = 0
               AND a.t21_charges_id_m97 = 38
               AND a.t21_charges_code_m97 = 'MGNFEE'
               AND a.t21_institute_id_m02 = pinstituteid
               AND a.t21_value_date <= TRUNC (LAST_DAY (SYSDATE)) + .99999;
END;
/