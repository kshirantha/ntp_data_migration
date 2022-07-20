
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_UPD_EXCHANGE_DETAILS (
    p_exchange                  IN esp_exchangemaster.exchange%TYPE,
    p_exchangecode              IN esp_exchangemaster.exchangecode%TYPE,
    p_description1              IN esp_exchangemaster.description_1%TYPE,
    p_description2              IN esp_exchangemaster.description_2%TYPE,
    p_shortdescription1         IN esp_exchangemaster.short_description_1%TYPE,
    p_shortdescription2         IN esp_exchangemaster.short_description_2%TYPE,
    p_primarycurrency           IN esp_exchangemaster.primary_currency%TYPE,
    p_marketstatus              IN esp_exchangemaster.marketstatus%TYPE,
    p_lasteoddate               IN esp_exchangemaster.last_eod_date%TYPE,
    p_lastactivedate            IN esp_exchangemaster.last_active_date%TYPE,
    p_lastinitdate              IN esp_exchangemaster.last_init_date%TYPE,
    p_isactive                  IN esp_exchangemaster.is_active%TYPE,
    p_path                      IN esp_exchangemaster.PATH%TYPE,
    p_noofups                   IN esp_exchangemaster.noofups%TYPE,
    p_noofdowns                 IN esp_exchangemaster.noofdowns%TYPE,
    p_noofnochange              IN esp_exchangemaster.noofnochange%TYPE,
    p_intradayohlcdays          IN esp_exchangemaster.intraday_ohlc_days%TYPE,
    p_isexpandsubmkts           IN esp_exchangemaster.is_expand_submkts%TYPE,
    p_defaultdecimalpts         IN esp_exchangemaster.default_decimal_pts%TYPE,
    p_pricemodificationfactor   IN esp_exchangemaster.price_modification_factor%TYPE,
    p_archivegenstatus          IN esp_exchangemaster.archive_gen_status%TYPE,
    p_deccorrectionfactor       IN esp_exchangemaster.dec_correction_factor%TYPE,
    p_isallowdisplay            IN esp_exchangemaster.is_allow_display%TYPE,
    p_displayexchange           IN esp_exchangemaster.display_exchange%TYPE)
/*---------------------------------------------------------------------------
-- Description     : To update exchange details
-- Author          : Chinthaka
-- Date            : 20/07/2010
-- Used In         : Mubasher Pro
-- Modification History :
--   Date          Author          Reason for change
--=======================================================
--   2010-07-20    Chinthaka          Convert T/SQL to PL/SQL
--   2010-08-11    Tharindu           last_eod_date,last_active_date,last_init_date,
--                                    marketstatus,noofups,noofdowns,noofnochange,archive_gen_status
---------------------------------------------------------------------------*/
AS
BEGIN
    UPDATE esp_exchangemaster
       SET exchangecode = p_exchangecode,
           description_1 = p_description1,
           description_2 = p_description2,
           short_description_1 = p_shortdescription1,
           short_description_2 = p_shortdescription2,
           primary_currency = p_primarycurrency,
           is_active = p_isactive,
           PATH = p_path,
           intraday_ohlc_days = p_intradayohlcdays,
           is_expand_submkts = p_isexpandsubmkts,
           default_decimal_pts = p_defaultdecimalpts,
           price_modification_factor = p_pricemodificationfactor,
           dec_correction_factor = p_deccorrectionfactor,
           is_allow_display = p_isallowdisplay,
           display_exchange = p_displayexchange
     WHERE (exchange = p_exchange);

    IF (SQL%ROWCOUNT = 0)
    THEN
        INSERT INTO esp_exchangemaster (exchange,
                                        exchangecode,
                                        description_1,
                                        description_2,
                                        short_description_1,
                                        short_description_2,
                                        primary_currency,
                                        marketstatus,
                                        last_eod_date,
                                        last_active_date,
                                        last_init_date,
                                        is_active,
                                        PATH,
                                        noofups,
                                        noofdowns,
                                        noofnochange,
                                        intraday_ohlc_days,
                                        is_expand_submkts,
                                        default_decimal_pts,
                                        price_modification_factor,
                                        archive_gen_status,
                                        dec_correction_factor,
                                        is_allow_display,
                                        display_exchange)
             VALUES (p_exchange,
                     p_exchangecode,
                     p_description1,
                     p_description2,
                     p_shortdescription1,
                     p_shortdescription2,
                     p_primarycurrency,
                     p_marketstatus,
                     p_lasteoddate,
                     p_lastactivedate,
                     p_lastinitdate,
                     p_isactive,
                     p_path,
                     p_noofups,
                     p_noofdowns,
                     p_noofnochange,
                     p_intradayohlcdays,
                     p_isexpandsubmkts,
                     p_defaultdecimalpts,
                     p_pricemodificationfactor,
                     p_archivegenstatus,
                     p_deccorrectionfactor,
                     p_isallowdisplay,
                     p_displayexchange);
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        RAISE;
END;
/
/
