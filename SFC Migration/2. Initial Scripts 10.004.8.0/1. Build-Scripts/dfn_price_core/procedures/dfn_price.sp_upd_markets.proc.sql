
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_UPD_MARKETS (
    p_exchange           esp_markets.exchange%TYPE,
    p_marketcode         esp_markets.market_code%TYPE,
    p_description1       esp_markets.description_1%TYPE,
    p_description2       esp_markets.description_2%TYPE,
    p_symbolext          esp_markets.symbolext%TYPE,
    p_isdefault          esp_markets.is_default%TYPE,
    p_istickerdisplay    esp_markets.is_ticker_display%TYPE)
/*---------------------------------------------------------------------------
Description     : To Insert & update markets
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
    UPDATE esp_markets
       SET description_1 = p_description1,
           description_2 = p_description2,
           symbolext = p_symbolext,
           is_default = p_isdefault,
           is_ticker_display = p_istickerdisplay
     WHERE exchange = p_exchange AND market_code = p_marketcode;

    IF (SQL%ROWCOUNT = 0)
    THEN
        INSERT INTO esp_markets (exchange,
                                 market_code,
                                 description_1,
                                 description_2,
                                 symbolext,
                                 is_default,
                                 is_ticker_display)
             VALUES (p_exchange,
                     p_marketcode,
                     p_description1,
                     p_description2,
                     p_symbolext,
                     p_isdefault,
                     p_istickerdisplay);
    END IF;
END;
/
/
