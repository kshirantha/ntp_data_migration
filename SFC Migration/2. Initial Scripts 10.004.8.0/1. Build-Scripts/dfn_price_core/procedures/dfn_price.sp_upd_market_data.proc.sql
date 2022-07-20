
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_UPD_MARKET_DATA (
    v_exchange        IN CHAR DEFAULT NULL,
    v_marketid        IN VARCHAR2 DEFAULT NULL,
    v_marketstatus    IN NUMBER DEFAULT NULL,
    v_nooftrades      IN NUMBER DEFAULT 0,
    v_noofups         IN NUMBER DEFAULT 0,
    v_noofdowns       IN NUMBER DEFAULT 0,
    v_noofnochange    IN NUMBER DEFAULT 0,
    v_symbolstraded   IN NUMBER DEFAULT 0,
    v_volume          IN NUMBER DEFAULT 0,
    v_turnover        IN NUMBER DEFAULT 0)
AS
BEGIN
    --v_Exchange := RTRIM(v_Exchange);
    UPDATE esp_markets
       SET marketstatus = v_marketstatus,
           symbols_traded = v_symbolstraded,
           turnover = v_turnover,
           volume = v_volume,
           noofnochange = v_noofnochange,
           noofdowns = v_noofdowns,
           noofups = v_noofups,
           nooftrades = v_nooftrades
     WHERE exchange = v_exchange AND market_code = v_marketid;
END;
/
/
