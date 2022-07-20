
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_UPD_SECTORS_DESC (
    p_exchangecode   IN esp_sectors_descriptions.exchangecode%TYPE,
    p_sectorid       IN esp_sectors_descriptions.sector_id%TYPE,
    p_language       IN esp_sectors_descriptions.language%TYPE,
    p_description    IN esp_sectors_descriptions.description%TYPE)
/*---------------------------------------------------------------------------
Description     : To Insert & update sectors description
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
    UPDATE esp_sectors_descriptions
       SET description = p_description
     WHERE     (exchangecode = p_exchangecode)
           AND (sector_id = p_sectorid)
           AND (language = p_language);

    IF (SQL%ROWCOUNT = 0)
    THEN
        INSERT INTO esp_sectors_descriptions (exchangecode,
                                              sector_id,
                                              language,
                                              description)
             VALUES (p_exchangecode,
                     p_sectorid,
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
