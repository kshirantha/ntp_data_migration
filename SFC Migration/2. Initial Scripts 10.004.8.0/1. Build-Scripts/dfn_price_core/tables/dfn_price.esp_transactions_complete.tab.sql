-- Table DFN_PRICE.ESP_TRANSACTIONS_COMPLETE

  CREATE TABLE DFN_PRICE.ESP_TRANSACTIONS_COMPLETE 
   (	TRANSACTIONDATE DATE, 
	EXCHANGECODE VARCHAR2(8), 
	SYMBOL VARCHAR2(30), 
	OPEN NUMBER(21,6), 
	HIGH NUMBER(21,6), 
	LOW NUMBER(21,6), 
	CLOSE NUMBER(21,6), 
	CHANGE NUMBER(21,6), 
	PERCENTCHANGED NUMBER(21,6), 
	PREVIOUSCLOSED NUMBER(21,6), 
	VOLUME NUMBER(19,0), 
	TURNOVER NUMBER(21,6), 
	ISINDEX NUMBER(1,0), 
	NOOFTRADES NUMBER(10,0), 
	VWAP NUMBER(21,6), 
	LASTTRADEPRICE NUMBER(18,3), 
	TODAYSOPEN NUMBER(18,3), 
	LASTTRADEDPRICE NUMBER(18,3), 
	LASTTRADEDDATE DATE DEFAULT '01-JAN-1970', 
	BESTASKPRICE NUMBER(21,6), 
	BESTASKQUANTITY NUMBER(26,0), 
	BESTBIDPRICE NUMBER(21,6), 
	BESTBIDQUANTITY NUMBER(26,0)
   ) 
/

-- Constraints for  DFN_PRICE.ESP_TRANSACTIONS_COMPLETE


  ALTER TABLE DFN_PRICE.ESP_TRANSACTIONS_COMPLETE ADD CONSTRAINT PK_ESP_TRANSACTIONS_COMPLETE PRIMARY KEY (TRANSACTIONDATE, EXCHANGECODE, SYMBOL)
  USING INDEX  ENABLE
/

  ALTER TABLE DFN_PRICE.ESP_TRANSACTIONS_COMPLETE MODIFY (TRANSACTIONDATE NOT NULL ENABLE)
/

  ALTER TABLE DFN_PRICE.ESP_TRANSACTIONS_COMPLETE MODIFY (EXCHANGECODE NOT NULL ENABLE)
/

  ALTER TABLE DFN_PRICE.ESP_TRANSACTIONS_COMPLETE MODIFY (SYMBOL NOT NULL ENABLE)
/

  ALTER TABLE DFN_PRICE.ESP_TRANSACTIONS_COMPLETE MODIFY (OPEN NOT NULL ENABLE)
/

  ALTER TABLE DFN_PRICE.ESP_TRANSACTIONS_COMPLETE MODIFY (HIGH NOT NULL ENABLE)
/

  ALTER TABLE DFN_PRICE.ESP_TRANSACTIONS_COMPLETE MODIFY (LOW NOT NULL ENABLE)
/

  ALTER TABLE DFN_PRICE.ESP_TRANSACTIONS_COMPLETE MODIFY (CHANGE NOT NULL ENABLE)
/

  ALTER TABLE DFN_PRICE.ESP_TRANSACTIONS_COMPLETE MODIFY (PERCENTCHANGED NOT NULL ENABLE)
/

  ALTER TABLE DFN_PRICE.ESP_TRANSACTIONS_COMPLETE MODIFY (PREVIOUSCLOSED NOT NULL ENABLE)
/

  ALTER TABLE DFN_PRICE.ESP_TRANSACTIONS_COMPLETE MODIFY (VOLUME NOT NULL ENABLE)
/

  ALTER TABLE DFN_PRICE.ESP_TRANSACTIONS_COMPLETE MODIFY (TURNOVER NOT NULL ENABLE)
/



-- Comments for  DFN_PRICE.ESP_TRANSACTIONS_COMPLETE

   COMMENT ON COLUMN DFN_PRICE.ESP_TRANSACTIONS_COMPLETE.EXCHANGECODE IS 'Mubasher Driven Exchnage short code'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_TRANSACTIONS_COMPLETE.SYMBOL IS 'Symbol'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_TRANSACTIONS_COMPLETE.HIGH IS 'highest value of the day'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_TRANSACTIONS_COMPLETE.LOW IS 'lowest  values of the day'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_TRANSACTIONS_COMPLETE.CLOSE IS 'Close value of the day'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_TRANSACTIONS_COMPLETE.CHANGE IS 'change of the day'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_TRANSACTIONS_COMPLETE.PERCENTCHANGED IS 'change percentage of the day'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_TRANSACTIONS_COMPLETE.PREVIOUSCLOSED IS 'previous close value'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_TRANSACTIONS_COMPLETE.VOLUME IS 'Total quantity traded  for the exchange(Eg:125782563)'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_TRANSACTIONS_COMPLETE.TURNOVER IS 'Total traded value for the market(Eg:990463435.110)'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_TRANSACTIONS_COMPLETE.NOOFTRADES IS 'Total number of trades for the exchange(Eg:3410)'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_TRANSACTIONS_COMPLETE.VWAP IS 'Volume Weighted Avarge price for the symbol ( Trunover / Volume )'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_TRANSACTIONS_COMPLETE.LASTTRADEPRICE IS 'Last trade price'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_TRANSACTIONS_COMPLETE.TODAYSOPEN IS 'Open value of the symbol for the current day'
/
-- End of DDL Script for Table DFN_PRICE.ESP_TRANSACTIONS_COMPLETE
