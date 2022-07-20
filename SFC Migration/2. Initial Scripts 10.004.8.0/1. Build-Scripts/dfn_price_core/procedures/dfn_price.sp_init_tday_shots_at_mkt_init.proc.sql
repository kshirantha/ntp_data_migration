
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_INIT_TDAY_SHOTS_AT_MKT_INIT (
    v_exchangecode IN VARCHAR2 DEFAULT NULL)
AS
BEGIN
    SET TRANSACTION READ WRITE;

    UPDATE esp_todays_snapshots
       SET turnover = 0,
           volume = 0,
           lastupdatedtime = TO_DATE ('19700101', 'YYYYMMDD'),
           lasttradetime = TO_DATE ('19700101', 'YYYYMMDD'),
           lasttradeprice = 0,
           lasttradequantity = 0,
           tradetick = 'Q',
           nooftrades = 0,
           high = 0,
           low = 0,
           change = 0,
           percentchanged = 0,
           --previousclosed = 0,
           todaysopen = 0,
           vwap = 0,
           avgvolume = 0,
           --//MINPRICE        = 0,
           ---//MAXPRICE       = 0,
           per = 0,
           pbr = 0,
           --MARKETCAP         = 0,
           yield = 0,
           bestaskprice = 0,
           bestaskquantity = 0,
           bestbidprice = 0,
           bestbidquantity = 0,
           noofbids = 0,
           noofasks = 0,
           totalbidqty = 0,
           totalaskqty = 0,
           highask = 0,
           lowbid = 0,
           lastaskprice = 0,
           lastbidprice = 0,
           bidaskratio = 0,
           simpleavgask = 0,
           weightedavgask = 0,
           simpleavgbid = 0,
           weightedavgbid = 0,
           updated = 'N',
           beginingofyear = 0,
           lastsequenceno = 0
     WHERE exchangecode = v_exchangecode;

    COMMIT;
END;
/
/
