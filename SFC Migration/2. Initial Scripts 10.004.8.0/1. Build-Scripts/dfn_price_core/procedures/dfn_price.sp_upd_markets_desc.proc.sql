
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_UPD_MARKETS_DESC (
    p_exchangecode   IN esp_markets_descriptions.exchangecode%TYPE,
    p_marketcode     IN esp_markets_descriptions.market_code%TYPE,
    p_language       IN esp_markets_descriptions.language%TYPE,
    p_description    IN esp_markets_descriptions.description%TYPE)
/*---------------------------------------------------------------------------
Description     : To Insert & update markets description
Author          : Chinthaka
Date            : 20/07/2010
Used In         : Mubasher Pro
Modification History :
     Date          Author          Reason for change
=======================================================
     2010-07-20    Chinthaka          Convert T/SQL to PL/SQL
---------------------------------------------------------------------------*/
AS
BEGIN
    UPDATE esp_markets_descriptions
       SET description = p_description
     WHERE     (exchangecode = p_exchangecode)
           AND (market_code = p_marketcode)
           AND (language = p_language);

    IF (SQL%ROWCOUNT = 0)
    THEN
        INSERT INTO esp_markets_descriptions (exchangecode,
                                              market_code,
                                              language,
                                              description)
             VALUES (p_exchangecode,
                     p_marketcode,
                     p_language,
                     p_description);
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        RAISE;
END;
/
/
