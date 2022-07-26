-- Table DFN_PRICE.ESP_MARKETS_DESCRIPTIONS

  CREATE TABLE DFN_PRICE.ESP_MARKETS_DESCRIPTIONS 
   (	EXCHANGECODE VARCHAR2(8), 
	MARKET_CODE VARCHAR2(10), 
	LANGUAGE CHAR(2), 
	DESCRIPTION NVARCHAR2(100)
   ) 
/

-- Constraints for  DFN_PRICE.ESP_MARKETS_DESCRIPTIONS


  ALTER TABLE DFN_PRICE.ESP_MARKETS_DESCRIPTIONS ADD CONSTRAINT PK_ESP_MARKETS_DESCRIPTIONS PRIMARY KEY (EXCHANGECODE, MARKET_CODE, LANGUAGE)
  USING INDEX  ENABLE
/

  ALTER TABLE DFN_PRICE.ESP_MARKETS_DESCRIPTIONS MODIFY (EXCHANGECODE NOT NULL ENABLE)
/

  ALTER TABLE DFN_PRICE.ESP_MARKETS_DESCRIPTIONS MODIFY (MARKET_CODE NOT NULL ENABLE)
/

  ALTER TABLE DFN_PRICE.ESP_MARKETS_DESCRIPTIONS MODIFY (LANGUAGE NOT NULL ENABLE)
/




-- End of DDL Script for Table DFN_PRICE.ESP_MARKETS_DESCRIPTIONS
