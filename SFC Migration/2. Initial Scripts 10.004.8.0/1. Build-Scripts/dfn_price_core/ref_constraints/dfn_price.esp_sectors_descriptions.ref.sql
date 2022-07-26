-- Foreign Key for  DFN_PRICE.ESP_SECTORS_DESCRIPTIONS


  ALTER TABLE DFN_PRICE.ESP_SECTORS_DESCRIPTIONS ADD CONSTRAINT FK_ESP_SECTORS_DESCRIPTIONS FOREIGN KEY (EXCHANGECODE, SECTOR_ID)
	  REFERENCES DFN_PRICE.ESP_SECTORS (EXCHANGECODE, SECTOR_ID) ENABLE
/

  ALTER TABLE DFN_PRICE.ESP_SECTORS_DESCRIPTIONS ADD CONSTRAINT FK_ESP_SECTORS_LANGUAGE FOREIGN KEY (LANGUAGE)
	  REFERENCES DFN_PRICE.ESP_LANGUAGE_MASTER (LANGUAGE_CODE) ENABLE
/
-- End of REF DDL Script for Table DFN_PRICE.ESP_SECTORS_DESCRIPTIONS
