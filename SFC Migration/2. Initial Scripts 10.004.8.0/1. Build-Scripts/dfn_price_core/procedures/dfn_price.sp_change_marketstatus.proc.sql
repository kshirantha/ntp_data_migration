
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_CHANGE_MARKETSTATUS (
    v_exchange         IN VARCHAR2 DEFAULT NULL,
    v_marketstatus     IN NUMBER DEFAULT NULL,
    v_lastactivedate   IN DATE DEFAULT NULL)
AS
BEGIN
    UPDATE esp_exchangemaster
       SET marketstatus = v_marketstatus, last_active_date = v_lastactivedate
     WHERE exchange = v_exchange;
END;
/
/
