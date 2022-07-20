CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_market_turnover (
    pexchange            VARCHAR2,
    pfrom_date           DATE,
    pto_date             DATE,
    pdefault_turnover    NUMBER DEFAULT 0)
    RETURN NUMBER
IS
    l_turnover   NUMBER := 0;
BEGIN
    IF TRUNC (SYSDATE) BETWEEN TRUNC (pfrom_date) AND TRUNC (pto_date)
    THEN
        SELECT SUM (NVL (turnover, 0))
          INTO l_turnover
          FROM dfn_price.esp_todays_snapshots
         WHERE exchangecode = pexchange;
    ELSE
        SELECT SUM (turnover)
          INTO l_turnover
          FROM dfn_price.esp_transactions_complete
         WHERE     exchangecode = pexchange
               AND transactiondate BETWEEN TRUNC (pfrom_date)
                                       AND TRUNC (pto_date);
    END IF;

    IF l_turnover = 0
    THEN
        l_turnover := pdefault_turnover;
    END IF;

    RETURN NVL (l_turnover, pdefault_turnover);
END;
/
/
