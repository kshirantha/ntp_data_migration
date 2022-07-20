
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_UPD_EXCHANGE_DESC (
    p_exchange           IN esp_exchange_descriptions.exchange%TYPE,
    p_language           IN esp_exchange_descriptions.language%TYPE,
    p_description        IN esp_exchange_descriptions.description%TYPE,
    p_shortdescription   IN esp_exchange_descriptions.short_description%TYPE)
/*---------------------------------------------------------------------------
Description     : To Insert & update exchange description
Author          : Chinthaka
Date            : 20/07/2010
Used In         : Mubasher Pro
Modification History :
     Date          Author          Reason for change
=======================================================
     2010-07-19    Chinthaka          Convert T/SQL to PL/SQL
---------------------------------------------------------------------------*/

AS
BEGIN
    UPDATE esp_exchange_descriptions
       SET description = p_description,
           short_description = p_shortdescription
     WHERE exchange = p_exchange AND language = p_language;

    IF (SQL%ROWCOUNT = 0)
    THEN
        INSERT INTO esp_exchange_descriptions (exchange,
                                               language,
                                               description,
                                               short_description)
             VALUES (p_exchange,
                     p_language,
                     p_description,
                     p_shortdescription);
    END IF;
END;
/
/
