CREATE OR REPLACE FUNCTION dfn_ntp.fn_margin_liquidation_amount (
    p_asset               NUMBER,
    p_loan                NUMBER,
    p_product_type        NUMBER,
    p_current_level       NUMBER,
    p_liquidation_level   NUMBER,
    p_restore_level       NUMBER,
    p_broker_id           NUMBER DEFAULT NULL)
    RETURN NUMBER
IS
    l_liqudiation_amount   NUMBER := 0;
BEGIN
    IF p_broker_id = -1 -- Update the Formula Based on Correct Broker ID
    THEN
        IF    (p_product_type = 1 AND (1 - p_restore_level / 100) <> 0)
           OR (    p_product_type = 1
               AND (p_asset - (p_restore_level / 100) * p_loan) <> 0)
        THEN
            l_liqudiation_amount :=
                ROUND (
                    CASE
                        WHEN (    p_product_type = 1
                              AND p_current_level <= p_liquidation_level)
                        THEN
                              (p_asset - (p_restore_level / 100) * p_loan)
                            / (1 - p_restore_level / 100)
                        WHEN (    p_product_type = 2
                              AND p_current_level >= p_liquidation_level)
                        THEN
                              -- Need to Finalize the Formula for Initial Margin. Will handle as a Separate Task Later
                              (1 - p_restore_level / 100)
                            / (p_asset - (p_restore_level / 100) * p_loan)
                    END,
                    2);
        ELSE
            l_liqudiation_amount := 0;
        END IF;
    ELSE -- Generic Version
        IF    (p_product_type = 1 AND (1 - p_restore_level / 100) <> 0)
           OR (    p_product_type = 1
               AND (p_asset - (p_restore_level / 100) * p_loan) <> 0)
        THEN
            l_liqudiation_amount :=
                ROUND (
                    CASE
                        WHEN     (    p_product_type = 1
                                  AND p_current_level <= p_liquidation_level)
                             AND p_restore_level <> 100
                        THEN
                              (p_asset - (p_restore_level / 100) * p_loan)
                            / (1 - p_restore_level / 100)
                        WHEN (    p_product_type = 2
                              AND p_current_level >= p_liquidation_level)
                        THEN
                              -- Need to Finalize the Formula for Initial Margin. Will handle as a Separate Task Later
                              (1 - p_restore_level / 100)
                            / (p_asset - (p_restore_level / 100) * p_loan)
                    END,
                    2);
        ELSE
            l_liqudiation_amount := 0;
        END IF;
    END IF;

    RETURN l_liqudiation_amount;
END;
/