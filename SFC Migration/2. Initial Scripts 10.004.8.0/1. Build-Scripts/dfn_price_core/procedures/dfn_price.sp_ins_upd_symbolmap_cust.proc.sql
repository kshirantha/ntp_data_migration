
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_INS_UPD_SYMBOLMAP_CUST (
    p_exchange              IN esp_symbolmap_cust.exchange%TYPE,
    p_symbol                IN esp_symbolmap_cust.symbol%TYPE,
    p_instrumenttype        IN esp_symbolmap_cust.instrumenttype%TYPE,
    p_symbolcode            IN esp_symbolmap_cust.symbolcode%TYPE,
    p_category              IN esp_symbolmap_cust.category%TYPE,
    p_sector                IN esp_symbolmap_cust.sector%TYPE,
    p_currency              IN esp_symbolmap_cust.currency%TYPE,
    p_lastupdated           IN esp_symbolmap_cust.lastupdated%TYPE,
    p_isactive              IN esp_symbolmap_cust.is_active%TYPE,
    p_marketcode            IN esp_symbolmap_cust.market_code%TYPE,
    p_decimalplaces         IN esp_symbolmap_cust.decimal_places%TYPE,
    p_deccorrectionfactor   IN esp_symbolmap_cust.dec_correction_factor%TYPE,
    p_lotsize               IN esp_symbolmap_cust.lot_size%TYPE,
    p_unit                  IN esp_symbolmap_cust.unit%TYPE,
    p_instcode              IN esp_symbolmap_cust.inst_code%TYPE)
/*---------------------------------------------------------------------------
Description   : To Insert & update symbolmap customized
Author  : Chinthaka
Date    : 19/07/2010
Used In  : Mubasher Pro
Modification History :
 Date   Author   Reason for change
=======================================================
 2010-07-19 Chinthaka   Convert T/SQL to PL/SQL
---------------------------------------------------------------------------*/

AS
BEGIN
    UPDATE esp_symbolmap_cust
       SET symbolcode = p_symbolcode,
           category = p_category,
           sector = p_sector,
           currency = p_currency,
           lastupdated = p_lastupdated,
           is_active = p_isactive,
           market_code = p_marketcode,
           decimal_places = p_decimalplaces,
           dec_correction_factor = p_deccorrectionfactor,
           lot_size = p_lotsize,
           unit = p_unit,
           inst_code = p_instcode
     WHERE     exchange = p_exchange
           AND symbol = p_symbol
           AND instrumenttype = p_instrumenttype;

    IF (SQL%ROWCOUNT = 0)
    THEN
        INSERT INTO esp_symbolmap_cust (exchange,
                                        symbol,
                                        instrumenttype,
                                        symbolcode,
                                        category,
                                        sector,
                                        currency,
                                        lastupdated,
                                        is_active,
                                        market_code,
                                        decimal_places,
                                        dec_correction_factor,
                                        lot_size,
                                        unit,
                                        inst_code)
             VALUES (p_exchange,
                     p_symbol,
                     p_instrumenttype,
                     p_symbolcode,
                     p_category,
                     p_sector,
                     p_currency,
                     p_lastupdated,
                     p_isactive,
                     p_marketcode,
                     p_decimalplaces,
                     p_deccorrectionfactor,
                     p_lotsize,
                     p_unit,
                     p_instcode);
    END IF;
END;
/
/
