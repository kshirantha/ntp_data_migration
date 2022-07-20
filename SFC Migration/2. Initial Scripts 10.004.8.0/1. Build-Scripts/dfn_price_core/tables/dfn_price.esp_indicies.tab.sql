-- Table DFN_PRICE.ESP_INDICIES

  CREATE TABLE DFN_PRICE.ESP_INDICIES 
   (	EXCHANGECODE VARCHAR2(8), 
	SYMBOL VARCHAR2(30), 
	INDEXTYPE CHAR(2), 
	DESCRIPTION_1 VARCHAR2(50), 
	DESCRIPTION_2 NVARCHAR2(100), 
	SHORTDESCRIPTION_1 VARCHAR2(50), 
	SHORTDESCRIPTION_2 NVARCHAR2(100), 
	PREVCLOSEIDXVAL NUMBER(18,3), 
	ADVPREVCLOSEIDXVAL NUMBER(18,3), 
	INDEXVALUE NUMBER(18,3), 
	NETCHANGE NUMBER(18,3), 
	PERCE_CHANGE NUMBER(18,3), 
	VOLUME NUMBER(26,0), 
	TURNOVER NUMBER(18,3), 
	NOOFTRADES NUMBER(18,0), 
	HIGH NUMBER(18,3), 
	LOW NUMBER(18,3), 
	TODAYINTINDEX NUMBER(18,3), 
	NOOFUPS NUMBER(18,0), 
	NOOFDOWNS NUMBER(18,0), 
	NOOFNOCHANGE NUMBER(18,0), 
	NOOFNOTRADE NUMBER(18,0), 
	HIGHPRICEOF52WEEKS NUMBER(18,3), 
	HIGHPRICEDATEOF52WEEKS DATE, 
	LOWPRICEOF52WEEKS NUMBER(18,3), 
	LOWPRICEDATEOF52WEEKS DATE, 
	S52WKSHGHPRCCNSISTSOFLASTINDEX NUMBER(1,0), 
	S52WKSLWPRCCONSISTSOFLASTINDEX NUMBER(1,0), 
	NOOFSYMBOLSFORTHISINDEX NUMBER(5,0), 
	BASEVALUE NUMBER(18,3), 
	BASESTARTDATE DATE, 
	INDEXCALTYPE VARCHAR2(4), 
	BASETURNOVER NUMBER(18,3), 
	BASETOTALPRICE NUMBER(18,3), 
	LASTSEQUENCENO NUMBER(26,0), 
	SORT_ORDER NUMBER(3,0), 
	WEIGHTEDINDEXVALUE NUMBER(18,3), 
	CLOSE NUMBER(18,3)
   ) 
/

-- Constraints for  DFN_PRICE.ESP_INDICIES


  ALTER TABLE DFN_PRICE.ESP_INDICIES ADD CONSTRAINT PK_ESP_INDICIES PRIMARY KEY (EXCHANGECODE, SYMBOL)
  USING INDEX  ENABLE
/

  ALTER TABLE DFN_PRICE.ESP_INDICIES MODIFY (EXCHANGECODE NOT NULL ENABLE)
/

  ALTER TABLE DFN_PRICE.ESP_INDICIES MODIFY (SYMBOL NOT NULL ENABLE)
/



-- Comments for  DFN_PRICE.ESP_INDICIES

   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.EXCHANGECODE IS 'Mubasher Driven Exchange long code ()'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.SYMBOL IS 'Symbol'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.INDEXTYPE IS 'IM : main index 
/ IS: Normal index'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.DESCRIPTION_1 IS 'English Description'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.DESCRIPTION_2 IS 'Arabic Description'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.SHORTDESCRIPTION_1 IS 'English Short Description'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.SHORTDESCRIPTION_2 IS 'Arabic Short Description'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.PREVCLOSEIDXVAL IS 'Previous closed value of the index'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.ADVPREVCLOSEIDXVAL IS 'Adjusted previous close values of the index'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.INDEXVALUE IS 'last value of the index'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.NETCHANGE IS 'net change value of the index'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.PERCE_CHANGE IS 'precentage change of the index'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.VOLUME IS 'Total quantity traded  for index'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.TURNOVER IS 'Total traded value for the index'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.NOOFTRADES IS 'Total number of trades for the index'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.HIGH IS 'highest index value of the day'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.LOW IS 'lowest index values of the day'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.TODAYINTINDEX IS 'Todays first index value'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.NOOFUPS IS 'No of symbols increased in price compared to previoued closed price (Eg:25)'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.NOOFDOWNS IS 'No of symbols decreased in price compared to previoued closed price(Eg:18)'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.NOOFNOCHANGE IS 'No of symbols have no change in price compared to previoued closed price(Eg:20)'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.NOOFNOTRADE IS 'Total number of symbols not traded for the index'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.HIGHPRICEOF52WEEKS IS 'Highest index value of past 52 weeks'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.HIGHPRICEDATEOF52WEEKS IS 'Date of Highest index value for past 52 weeks'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.LOWPRICEOF52WEEKS IS 'Lowest index value of past 52 weeks'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.LOWPRICEDATEOF52WEEKS IS 'Date of Lowest index value for past 52 weeks'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.S52WKSHGHPRCCNSISTSOFLASTINDEX IS '52 weeks high price equal to last index value or not'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.S52WKSLWPRCCONSISTSOFLASTINDEX IS '52 weeks low price equal to last index value or not'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.BASEVALUE IS 'Base value for the index'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.BASESTARTDATE IS 'first applied date of base value'
/
   COMMENT ON COLUMN DFN_PRICE.ESP_INDICIES.CLOSE IS 'close price of index for the day'
/
-- End of DDL Script for Table DFN_PRICE.ESP_INDICIES