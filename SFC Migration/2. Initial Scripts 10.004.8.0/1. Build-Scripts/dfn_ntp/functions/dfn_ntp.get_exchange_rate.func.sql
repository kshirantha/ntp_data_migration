CREATE OR REPLACE FUNCTION dfn_ntp.get_exchange_rate (
    p_institute         IN NUMBER,
    p_from_currency     IN VARCHAR2,
    p_to_currency       IN VARCHAR2,
    p_rate_type         IN VARCHAR2 DEFAULT 'R',
    p_date              IN DATE DEFAULT SYSDATE,
    pm04_category_v01   IN m04_currency_rate.m04_category_v01%TYPE DEFAULT 0 --0 - Default | 1 - Staff
                                                                            )
    RETURN NUMBER
IS
    l_exchange_rate   m04_currency_rate.m04_rate%TYPE;
    l_date            DATE;
BEGIN
    IF NVL (p_from_currency, ' ') = NVL (p_to_currency, ' ')
    THEN
        RETURN 1;
    END IF;

    IF TRUNC (l_date) < TRUNC (SYSDATE)
    THEN
        l_date := TRUNC (SYSDATE);
    ELSE
        SELECT CASE
                   WHEN COUNT (*) > 0 THEN TRUNC (p_date)
                   ELSE TRUNC (SYSDATE)
               END
          INTO l_date
          FROM h03_currency_rate_all h03
         WHERE     h03.h03_from_currency_code_m03 = p_from_currency
               AND h03.h03_to_currency_code_m03 = p_to_currency
               AND h03.h03_institute_id_m02 = p_institute
               AND h03.h03_category_v01 = pm04_category_v01
               AND h03.h03_date BETWEEN TRUNC (p_date)
                                    AND TRUNC (p_date) + 0.99999;
    END IF;

    IF l_date = TRUNC (SYSDATE)
    THEN
        SELECT DECODE (p_rate_type,
                       'R', m04.m04_rate,
                       'BR', m04.m04_sell_rate, --as per the broker this will be the buy rate from the customer
                       'SR', m04.m04_buy_rate, --as per the broker this will be the sell rate for the customer
                       'AVG', (m04.m04_buy_rate + m04.m04_sell_rate) / 2,
                       m04.m04_buy_rate)
          INTO l_exchange_rate
          FROM m04_currency_rate m04
         WHERE     m04.m04_from_currency_code_m03 = p_from_currency
               AND m04.m04_to_currency_code_m03 = p_to_currency
               AND m04.m04_institute_id_m02 = p_institute
               AND m04_category_v01 = pm04_category_v01;
    ELSE
        SELECT DECODE (p_rate_type,
                       'R', h03.h03_rate,
                       'BR', h03.h03_sell_rate, --as per the broker this will be the buy rate from the customer
                       'SR', h03.h03_buy_rate, --as per the broker this will be the sell rate for the customer
                       'AVG', (h03.h03_buy_rate + h03.h03_sell_rate) / 2,
                       h03.h03_buy_rate)
          INTO l_exchange_rate
          FROM h03_currency_rate_all h03
         WHERE     h03.h03_from_currency_code_m03 = p_from_currency
               AND h03.h03_to_currency_code_m03 = p_to_currency
               AND h03.h03_institute_id_m02 = p_institute
               AND h03.h03_category_v01 = pm04_category_v01
               AND h03.h03_date BETWEEN TRUNC (l_date)
                                    AND TRUNC (l_date) + 0.99999;
    END IF;

    l_exchange_rate := NVL (l_exchange_rate, 1);

    RETURN l_exchange_rate;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN 1;
END;
/
