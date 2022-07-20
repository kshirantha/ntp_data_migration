
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_UPD_SECTORS (
    p_exchangecode        IN esp_sectors.exchangecode%TYPE,
    p_sectorid            IN esp_sectors.sector_id%TYPE,
    p_description1        IN esp_sectors.description_1%TYPE,
    p_description2        IN esp_sectors.description_2%TYPE,
    p_shortdescription1   IN esp_sectors.shortdescription_1%TYPE,
    p_shortdescription2   IN esp_sectors.shortdescription_2%TYPE)
/*---------------------------------------------------------------------------
Description     : To Insert & update sectors
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
    UPDATE esp_sectors
       SET description_1 = p_description1,
           description_2 = p_description2,
           shortdescription_1 = p_shortdescription1,
           shortdescription_2 = p_shortdescription2
     WHERE (exchangecode = p_exchangecode) AND (sector_id = p_sectorid);

    IF (SQL%ROWCOUNT = 0)
    THEN
        INSERT INTO esp_sectors (exchangecode,
                                 sector_id,
                                 description_1,
                                 description_2,
                                 shortdescription_1,
                                 shortdescription_2)
             VALUES (p_exchangecode,
                     p_sectorid,
                     p_description1,
                     p_description2,
                     p_shortdescription1,
                     p_shortdescription2);
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        RAISE;
END;
/
/
