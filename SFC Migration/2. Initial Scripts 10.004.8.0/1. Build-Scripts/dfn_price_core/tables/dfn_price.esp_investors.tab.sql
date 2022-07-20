-- Table DFN_PRICE.ESP_INVESTORS

  CREATE TABLE DFN_PRICE.ESP_INVESTORS 
   (	EXCHANGECODE VARCHAR2(10), 
	INVESTOR_TYPE VARCHAR2(50), 
	BUY_VAL NUMBER(21,6), 
	SELL_VAL NUMBER(21,6), 
	NET_VAL NUMBER(21,6), 
	BUY_PERC NUMBER(21,6), 
	SELL_PERC NUMBER(21,6), 
	TOT_PERC NUMBER(21,6), 
	UPDATETIME DATE DEFAULT SYSDATE
   ) 
/

-- Constraints for  DFN_PRICE.ESP_INVESTORS


  ALTER TABLE DFN_PRICE.ESP_INVESTORS ADD CONSTRAINT PK_ESP_INVESTORS PRIMARY KEY (EXCHANGECODE, INVESTOR_TYPE)
  USING INDEX  ENABLE
/

  ALTER TABLE DFN_PRICE.ESP_INVESTORS MODIFY (EXCHANGECODE NOT NULL ENABLE)
/

  ALTER TABLE DFN_PRICE.ESP_INVESTORS MODIFY (INVESTOR_TYPE NOT NULL ENABLE)
/




-- End of DDL Script for Table DFN_PRICE.ESP_INVESTORS