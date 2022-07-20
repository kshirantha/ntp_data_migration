CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_coupon_value (
    pinterest_day_basis   IN NUMBER,
    pinterest_rate        IN NUMBER,
    pnominal_value        IN NUMBER,
    pvalue_date           IN DATE,
    pstart_date           IN DATE,
    pstrike_price         IN NUMBER,
    pprice_div_factor     IN NUMBER)
    RETURN NUMBER
IS
    l_upper_value       NUMBER;
    l_lower_value       NUMBER;
    l_multific_factor   NUMBER DEFAULT 0;
    l_coupon_value      NUMBER DEFAULT 0;
    l_year_1            NUMBER;
    l_month_1           NUMBER;
    l_day_1             NUMBER;
    l_year_2            NUMBER;
    l_month_2           NUMBER;
    l_day_2             NUMBER;
BEGIN
    SELECT v26.v26_upper_value, v26.v26_lower_value
      INTO l_upper_value, l_lower_value
      FROM v26_interest_day_basis v26
     WHERE v26.v26_id = pinterest_day_basis;

    IF l_upper_value = 360
    THEN
        l_year_1 := TO_NUMBER (TO_CHAR (pvalue_date, 'YYYY'));
        l_month_1 := TO_NUMBER (TO_CHAR (pvalue_date, 'MM'));
        l_day_1 := TO_NUMBER (TO_CHAR (pvalue_date, 'DD'));

        l_year_2 := TO_NUMBER (TO_CHAR (pstart_date, 'YYYY'));
        l_month_2 := TO_NUMBER (TO_CHAR (pstart_date, 'MM'));
        l_day_2 := TO_NUMBER (TO_CHAR (pstart_date, 'DD'));

        l_multific_factor :=
              (  (l_upper_value * (l_year_1 - l_year_2))
               + (l_upper_value * (l_month_1 - l_month_2) / 12.0)
               + (l_day_1 - l_day_2 + 1))
            / l_lower_value;
    ELSE
        l_multific_factor :=
            (TRUNC (pvalue_date) - TRUNC (pstart_date) + 1) / l_lower_value;
    END IF;

    l_coupon_value :=
          (  pinterest_rate
           * pstrike_price
           * pnominal_value
           * l_multific_factor)
        / (100 * pprice_div_factor);

    RETURN l_coupon_value;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN 0;
END;
/
