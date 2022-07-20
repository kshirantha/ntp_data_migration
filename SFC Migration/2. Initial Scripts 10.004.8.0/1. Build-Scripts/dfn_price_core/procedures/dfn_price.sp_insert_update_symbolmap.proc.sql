
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_INSERT_UPDATE_SYMBOLMAP (
   v_exchange                   IN   esp_symbolmap.EXCHANGE%TYPE,
   v_symbol                     IN   esp_symbolmap.symbol%TYPE,
   v_instrumenttype             IN   esp_symbolmap.instrumenttype%TYPE,
   v_exchangecode               IN   esp_symbolmap.exchangecode%TYPE,
   v_category                   IN   esp_symbolmap.CATEGORY%TYPE,
   v_symboldescription_1        IN   esp_symbolmap.symboldescription_1%TYPE,
   v_symboldescription_2        IN   esp_symbolmap.symboldescription_2%TYPE,
   v_symbolshortdescription_1   IN   esp_symbolmap.symbolshortdescription_1%TYPE,
   v_symbolshortdescription_2   IN   esp_symbolmap.symbolshortdescription_2%TYPE,
   v_sector                     IN   esp_symbolmap.sector%TYPE,
   v_currency                   IN   esp_symbolmap.currency%TYPE,
   v_symbolcode                 IN   esp_symbolmap.symbolcode%TYPE,
   v_market_code                IN   esp_symbolmap.market_code%TYPE,
   v_lastupdated                IN   esp_symbolmap.lastupdated%TYPE,
   v_is_active                  IN   esp_symbolmap.is_active%TYPE,
   v_dec_correction_factor      IN   esp_symbolmap.dec_correction_factor%TYPE,
   v_decimal_places             IN   esp_symbolmap.decimal_places%TYPE,
   v_lot_size                   IN   esp_symbolmap.lot_size%TYPE,
   v_unit                       IN   esp_symbolmap.unit%TYPE,
   v_EXPIRYDATE                 IN   esp_symbolmap.EXPIRYDATE%TYPE,
   v_UNDERLINESYMBOL            IN   esp_symbolmap.UNDERLINESYMBOL%TYPE,
   v_STRIKEPRICE                IN   esp_symbolmap.STRIKEPRICE%TYPE,
   v_ISINCODE                   IN   esp_symbolmap.ISINCODE%TYPE,
   v_symbol_group				IN 	 esp_symbolmap.SYMBOL_GROUP%TYPE,
   v_underline_exchange         IN 	 esp_symbolmap.UNDERLINE_EXCHANGE%TYPE default null,
   v_option_type                IN 	 esp_symbolmap.OPTION_TYPE%TYPE default null,
   v_first_subs_startdate		IN   esp_symbolmap.FIRST_SUBS_STARTDATE%TYPE default null,
   v_first_subs_expdate			IN   esp_symbolmap.FIRST_SUBS_EXPDATE%TYPE default null,
   v_sec_subs_startdate			IN   esp_symbolmap.SEC_SUBS_STARTDATE%TYPE default null,
   v_sec_subs_expdate			IN   esp_symbolmap.SEC_SUBS_EXPDATE%TYPE default null,
   v_first_subs_startdate_hijri	IN   esp_symbolmap.FIRST_SUBS_START_HIJRI%TYPE default null,
   v_first_subs_expdate_hijri	IN   esp_symbolmap.FIRST_SUBS_EXP_HIJRI%TYPE default null,
   v_sec_subs_startdate_hijri	IN   esp_symbolmap.SEC_SUBS_START_HIJRI%TYPE default null,
   v_sec_subs_expdate_hijri		IN   esp_symbolmap.SEC_SUBS_EXP_HIJRI%TYPE default null,
   v_market_id          		IN   esp_symbolmap.MARKET_ID%TYPE default null
)
AS
BEGIN
   UPDATE esp_symbolmap
      SET exchangecode = v_exchangecode,
          CATEGORY = v_category,
          symboldescription_1 = v_symboldescription_1,
          symboldescription_2 = v_symboldescription_2,
          symbolshortdescription_1 = v_symbolshortdescription_1,
          symbolshortdescription_2 = v_symbolshortdescription_2,
          sector = v_sector,
          currency = v_currency,
          symbolcode = v_symbolcode,
          market_code = v_market_code,
          lastupdated = v_lastupdated,
          is_active = v_is_active,
          dec_correction_factor = v_dec_correction_factor,
          decimal_places = v_decimal_places,
          lot_size = v_lot_size,
          unit = v_unit,
          EXPIRYDATE = v_EXPIRYDATE,
          UNDERLINESYMBOL = v_UNDERLINESYMBOL,
          STRIKEPRICE = v_STRIKEPRICE,
          ISINCODE = v_ISINCODE,
		  SYMBOL_GROUP = v_symbol_group,
		  UNDERLINE_EXCHANGE = v_underline_exchange,
		  OPTION_TYPE = v_option_type,
		  FIRST_SUBS_STARTDATE = v_first_subs_startdate,
		  FIRST_SUBS_EXPDATE = v_first_subs_expdate,
		  SEC_SUBS_STARTDATE = v_sec_subs_startdate,
		  SEC_SUBS_EXPDATE = v_sec_subs_expdate,
		  FIRST_SUBS_START_HIJRI = v_first_subs_startdate_hijri,
		  FIRST_SUBS_EXP_HIJRI = v_first_subs_expdate_hijri,
		  SEC_SUBS_START_HIJRI = v_sec_subs_startdate_hijri,
		  SEC_SUBS_EXP_HIJRI = v_sec_subs_expdate_hijri,
		  MARKET_ID = v_market_id

    WHERE EXCHANGE = v_exchange
      AND symbol = v_symbol
      AND instrumenttype = v_instrumenttype;

   IF (SQL%ROWCOUNT = 0 AND v_is_active = 1)
   THEN
      INSERT INTO esp_symbolmap
                  (EXCHANGE, symbol, instrumenttype, exchangecode,
                   CATEGORY, symboldescription_1, symboldescription_2,
                   symbolshortdescription_1, symbolshortdescription_2,
                   sector, currency, symbolcode, market_code,
                   lastupdated, is_active, dec_correction_factor,
                   decimal_places, lot_size, unit, expirydate, 
                   underlinesymbol, strikeprice, isincode, SYMBOL_GROUP,
				   UNDERLINE_EXCHANGE,OPTION_TYPE, FIRST_SUBS_STARTDATE,
				   FIRST_SUBS_EXPDATE, SEC_SUBS_STARTDATE, SEC_SUBS_EXPDATE,
				   FIRST_SUBS_START_HIJRI, FIRST_SUBS_EXP_HIJRI, SEC_SUBS_START_HIJRI,
				   SEC_SUBS_EXP_HIJRI, MARKET_ID
                  )
           VALUES (v_exchange, v_symbol, v_instrumenttype, v_exchangecode,
                   v_category, v_symboldescription_1, v_symboldescription_2,
                   v_symbolshortdescription_1, v_symbolshortdescription_2,
                   v_sector, v_currency, v_symbolcode, v_market_code,
                   v_lastupdated, v_is_active, v_dec_correction_factor,
                   v_decimal_places, v_lot_size, v_unit, v_expirydate, 
                   v_underlinesymbol, v_strikeprice, v_isincode , v_symbol_group,
				   v_underline_exchange,v_option_type, v_first_subs_startdate,
				   v_first_subs_expdate, v_sec_subs_startdate, v_sec_subs_expdate,
				   v_first_subs_startdate_hijri, v_first_subs_expdate_hijri,
				   v_sec_subs_startdate_hijri, v_sec_subs_expdate_hijri, v_market_id
                  );
   END IF;

   IF (v_is_active = 1)
   THEN
       BEGIN
          INSERT INTO esp_todays_snapshots
                      (companycode, exchangecode, symbol, sector, is_active,
                       lasttradeddate, lasttradedprice, minprice, maxprice
                      )
               VALUES ('N/A', v_exchange, v_symbol, v_sector, 1,
                       TO_DATE ('1970/01/01', 'yyyy/mm/dd'), 0, 0, 1000
                      );
       EXCEPTION
          WHEN DUP_VAL_ON_INDEX
          THEN
             NULL;
       END;
   END IF;
END;
/
/
