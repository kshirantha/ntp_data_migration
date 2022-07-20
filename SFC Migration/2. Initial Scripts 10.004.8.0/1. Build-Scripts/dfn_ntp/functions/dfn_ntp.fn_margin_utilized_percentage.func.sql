CREATE OR REPLACE FUNCTION dfn_ntp.fn_margin_utilized_percentage (
    p_max_margin_limit      NUMBER,
    p_total_cash_balance    NUMBER,
    p_exchange_rate         NUMBER)
    RETURN NUMBER
IS
    l_utilized_percentage   NUMBER := 0;
BEGIN
    IF p_max_margin_limit = 0
    THEN
        l_utilized_percentage := 100;
    ELSIF ROUND (
                p_total_cash_balance
              * 100
              / p_max_margin_limit
              * p_exchange_rate,
              2) > 100
    THEN
        l_utilized_percentage := 100;
    ELSE
        l_utilized_percentage :=
            ROUND (
                  p_total_cash_balance
                * 100
                / p_max_margin_limit
                * p_exchange_rate,
                2);
    END IF;

    RETURN l_utilized_percentage;
END;
/

