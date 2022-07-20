CREATE OR REPLACE FUNCTION dfn_ntp.fn_margin_current_percentage (
    p_rapv                  NUMBER,
    p_total_cash_balance    NUMBER,
    p_product_type          NUMBER)
    RETURN NUMBER
IS
    l_current_percentage   NUMBER := 0;
BEGIN
    IF p_rapv > 0 AND p_total_cash_balance > 0
    THEN
        l_current_percentage :=
            ROUND (
                  CASE
                      WHEN p_product_type = 1
                      THEN
                          p_rapv / p_total_cash_balance
                      WHEN p_product_type = 2
                      THEN
                          p_total_cash_balance / p_rapv
                  END
                * 100,
                2);
    ELSE
        l_current_percentage := 0;
    END IF;

    RETURN l_current_percentage;
END;
/
