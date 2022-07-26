-- Table DFN_PRICE.ANNOUNCEMENTS

  CREATE TABLE DFN_PRICE.ANNOUNCEMENTS 
   (	ID NUMBER(10,0), 
	SYMBOL NVARCHAR2(30), 
	EXCHANGECODE VARCHAR2(8), 
	REF_CODE VARCHAR2(20), 
	TIME DATE, 
	HEADING_1 NVARCHAR2(2000), 
	HEADING_2 NVARCHAR2(2000), 
	BODY_1 NCLOB, 
	BODY_2 NCLOB, 
	URL VARCHAR2(500), 
	COMPANY_CODE_1 NVARCHAR2(200), 
	COMPANY_CODE_2 NVARCHAR2(200), 
	COMPANY_NAME_1 VARCHAR2(150), 
	COMPANY_NAME_2 NVARCHAR2(300), 
	TIMESTAMP_A DATE, 
	IS_BODY_AVAIL NUMBER(10,0), 
	TIME_NUMERIC NUMBER(10,0), 
	ATTACH_URL_1 NVARCHAR2(600), 
	ATTACH_URL_2 NVARCHAR2(600), 
	IS_COMPANY NUMBER(1,0), 
	BODY_3 NCLOB, 
	ORIGINAL_ID NUMBER(10,0)
   ) 
/

-- Constraints for  DFN_PRICE.ANNOUNCEMENTS


  ALTER TABLE DFN_PRICE.ANNOUNCEMENTS ADD CONSTRAINT PK_ANNOUNCEMENTS PRIMARY KEY (ID)
  USING INDEX  ENABLE
/

  ALTER TABLE DFN_PRICE.ANNOUNCEMENTS MODIFY (ID NOT NULL ENABLE)
/

  ALTER TABLE DFN_PRICE.ANNOUNCEMENTS MODIFY (SYMBOL NOT NULL ENABLE)
/

  ALTER TABLE DFN_PRICE.ANNOUNCEMENTS MODIFY (TIME NOT NULL ENABLE)
/

-- Indexes for  DFN_PRICE.ANNOUNCEMENTS


  CREATE INDEX DFN_PRICE.INDX_ANN_ORIG_ID ON DFN_PRICE.ANNOUNCEMENTS (ORIGINAL_ID) 
  
/

-- Comments for  DFN_PRICE.ANNOUNCEMENTS

   COMMENT ON COLUMN DFN_PRICE.ANNOUNCEMENTS.ID IS 'unique announcement id (inserted by a sequence)'
/
   COMMENT ON COLUMN DFN_PRICE.ANNOUNCEMENTS.SYMBOL IS 'symbol'
/
   COMMENT ON COLUMN DFN_PRICE.ANNOUNCEMENTS.EXCHANGECODE IS 'exchange of the company'
/
   COMMENT ON COLUMN DFN_PRICE.ANNOUNCEMENTS.REF_CODE IS 'unique announcement id (sent by the exchange side)'
/
   COMMENT ON COLUMN DFN_PRICE.ANNOUNCEMENTS.TIME IS 'the actual time the announcement published'
/
   COMMENT ON COLUMN DFN_PRICE.ANNOUNCEMENTS.HEADING_1 IS 'english heading of the announcement'
/
   COMMENT ON COLUMN DFN_PRICE.ANNOUNCEMENTS.HEADING_2 IS 'arabic heading of the announcement'
/
   COMMENT ON COLUMN DFN_PRICE.ANNOUNCEMENTS.BODY_1 IS 'the announcement (english)'
/
   COMMENT ON COLUMN DFN_PRICE.ANNOUNCEMENTS.BODY_2 IS 'the announcement (arabic)'
/
   COMMENT ON COLUMN DFN_PRICE.ANNOUNCEMENTS.URL IS 'the announcement URL'
/
   COMMENT ON COLUMN DFN_PRICE.ANNOUNCEMENTS.COMPANY_CODE_1 IS 'announcement''s company code (english)'
/
   COMMENT ON COLUMN DFN_PRICE.ANNOUNCEMENTS.COMPANY_CODE_2 IS 'announcement''s company code (arabic)'
/
   COMMENT ON COLUMN DFN_PRICE.ANNOUNCEMENTS.COMPANY_NAME_1 IS 'announcement''s company name (english)'
/
   COMMENT ON COLUMN DFN_PRICE.ANNOUNCEMENTS.COMPANY_NAME_2 IS 'announcement''s company name (english)'
/
   COMMENT ON COLUMN DFN_PRICE.ANNOUNCEMENTS.TIMESTAMP_A IS 'the time the announcement inserted to the database'
/
   COMMENT ON COLUMN DFN_PRICE.ANNOUNCEMENTS.TIME_NUMERIC IS 'numeric timestamp of the announcement received time'
/
   COMMENT ON COLUMN DFN_PRICE.ANNOUNCEMENTS.ORIGINAL_ID IS 'source side id (mubasher central system)'
/
-- End of DDL Script for Table DFN_PRICE.ANNOUNCEMENTS
