
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_INS_UPD_ESP_NEWS (
    p_news_id        IN esp_news.news_id%TYPE,
    p_external_id    IN esp_news.external_id%TYPE,
    p_newsprovider   IN esp_news.newsprovider%TYPE,
    p_countrycode    IN esp_news.countrycode%TYPE,
    p_exchangecode   IN esp_news.exchangecode%TYPE,
    p_symbol         IN esp_news.symbol%TYPE,
    p_newsdate       IN esp_news.newsdate%TYPE,
    p_language       IN esp_news.language%TYPE,
    p_headline       IN esp_news.headline%TYPE,
    p_body           IN esp_news.body%TYPE,
    p_keywords       IN esp_news.keywords%TYPE,
    p_source         IN esp_news.source%TYPE)
AS
-----------------------------------------------------------------------------
--
-- Name: SP_INS_UPD_ESP_NEWS
--
-- Purpose: Insert, Update ESP_SYMBOLMAP
--
-- Modification History
--
-- Date         Person      History
-----------------------------------------------------------------------------
-- 2010-08-31   Saranga     Changed to select news id from the sequence and
--                          insert news id as external id
--
-----------------------------------------------------------------------------
BEGIN
    UPDATE esp_news
       SET newsprovider = p_newsprovider,
           countrycode = p_countrycode,
           exchangecode = p_exchangecode,
           symbol = p_symbol,
           newsdate = p_newsdate,
           language = p_language,
           headline = p_headline,
           body = p_body,
           keywords = p_keywords,
           source = p_source
     WHERE (external_id = p_news_id);

    IF (SQL%ROWCOUNT = 0)
    THEN
        INSERT INTO esp_news (news_id,
                              external_id,
                              newsprovider,
                              countrycode,
                              exchangecode,
                              symbol,
                              newsdate,
                              language,
                              headline,
                              body,
                              keywords,
                              source)
             VALUES (seq_esp_news_id.NEXTVAL,
                     p_news_id,
                     p_newsprovider,
                     p_countrycode,
                     p_exchangecode,
                     p_symbol,
                     p_newsdate,
                     p_language,
                     p_headline,
                     p_body,
                     p_keywords,
                     p_source);
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        RAISE;
END;
/
/
