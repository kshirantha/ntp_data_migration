
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_INS_UPD_SYMBOLMAP_DESC_CUST (
    p_exchange                 IN esp_symbolmap_desc_cust.exchange%TYPE,
    p_symbol                   IN esp_symbolmap_desc_cust.symbol%TYPE,
    p_instrumenttype           IN esp_symbolmap_desc_cust.instrumenttype%TYPE,
    p_language                 IN esp_symbolmap_desc_cust.language%TYPE,
    p_symboldescription        IN esp_symbolmap_desc_cust.symboldescription%TYPE,
    p_symbolshortdescription   IN esp_symbolmap_desc_cust.symbolshortdescription%TYPE)
/*---------------------------------------------------------------------------
Description     : To Insert & update symbolmap description customized
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
    UPDATE esp_symbolmap_desc_cust
       SET symboldescription = p_symboldescription,
           symbolshortdescription = p_symbolshortdescription
     WHERE     exchange = p_exchange
           AND symbol = p_symbol
           AND language = p_language
           AND instrumenttype = p_instrumenttype;

    IF (SQL%ROWCOUNT = 0)
    THEN
        INSERT INTO esp_symbolmap_desc_cust (exchange,
                                             symbol,
                                             instrumenttype,
                                             language,
                                             symboldescription,
                                             symbolshortdescription)
             VALUES (p_exchange,
                     p_symbol,
                     p_instrumenttype,
                     p_language,
                     p_symboldescription,
                     p_symbolshortdescription);
    END IF;
END;
/
/
