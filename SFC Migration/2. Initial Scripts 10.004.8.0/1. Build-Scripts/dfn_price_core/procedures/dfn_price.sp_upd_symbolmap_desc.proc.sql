
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_UPD_SYMBOLMAP_DESC (
    p_exchange                 IN esp_symbolmap_descriptions.exchange%TYPE,
    p_language                 IN esp_symbolmap_descriptions.language%TYPE,
    p_symbol                   IN esp_symbolmap_descriptions.symbol%TYPE,
    p_instrumenttype           IN esp_symbolmap_descriptions.instrumenttype%TYPE,
    p_symboldescription        IN esp_symbolmap_descriptions.symboldescription%TYPE,
    p_symbolshortdescription   IN esp_symbolmap_descriptions.symbolshortdescription%TYPE)
AS
BEGIN
    UPDATE esp_symbolmap_descriptions
       SET symboldescription = p_symboldescription,
           symbolshortdescription = p_symbolshortdescription
     WHERE     (exchange = p_exchange)
           AND (language = p_language)
           AND (symbol = p_symbol)
           AND (instrumenttype = p_instrumenttype);

    IF (SQL%ROWCOUNT = 0)
    THEN
        INSERT INTO esp_symbolmap_descriptions (symboldescription,
                                                symbolshortdescription,
                                                exchange,
                                                language,
                                                symbol,
                                                instrumenttype)
             VALUES (p_symboldescription,
                     p_symbolshortdescription,
                     p_exchange,
                     p_language,
                     p_symbol,
                     p_instrumenttype);
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        RAISE;
END;
/
/
