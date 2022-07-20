
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_INIT_INDICIES_AT_MKT_INIT (
    v_exchangecode IN VARCHAR2 DEFAULT NULL)
AS
BEGIN
    SET TRANSACTION READ WRITE;

    UPDATE esp_indicies

       SET -- indexvalue = 0, -- removed upon Dunith's request - saranga - 2010.09.30
          prevcloseidxval = 0,
           advprevcloseidxval = 0,
           netchange = 0,
           perce_change = 0,
           volume = 0,
           turnover = 0,
           nooftrades = 0,
           high = 0,
           low = 0,
           todayintindex = 0,
           noofups = 0,
           noofdowns = 0,
           noofnochange = 0,
           noofnotrade = 0,
           s52wkshghprccnsistsoflastindex = 0,
           s52wkslwprcconsistsoflastindex = 0
     WHERE exchangecode = v_exchangecode;

    COMMIT;
END;
/
/
