
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_INS_INTRADAY_TRADES (
    v_exchangecode        IN VARCHAR2 DEFAULT NULL,
    v_symbol              IN VARCHAR2 DEFAULT NULL,
    v_tradetime           IN DATE DEFAULT NULL,
    v_lasttradeprice      IN NUMBER DEFAULT NULL,
    v_lasttradequantity   IN NUMBER DEFAULT NULL,
    v_change              IN NUMBER DEFAULT NULL,
    v_percentchanged      IN NUMBER DEFAULT NULL,
    v_sequence_no         IN NUMBER DEFAULT NULL,
    v_type                IN CHAR DEFAULT NULL,
    v_oddlot              IN NUMBER DEFAULT NULL,
    v_session             IN NUMBER DEFAULT NULL)
AS
BEGIN
    INSERT INTO esp_intraday_trades (exchangecode,
                                     symbol,
                                     tradetime,
                                     lasttradeprice,
                                     lasttradequantity,
                                     change,
                                     percentchanged,
                                     sequence_no,
                                     TYPE,
                                     oddlot,
                                     session_id)
         VALUES (v_exchangecode,
                 v_symbol,
                 v_tradetime,
                 v_lasttradeprice,
                 v_lasttradequantity,
                 v_change,
                 v_percentchanged,
                 v_sequence_no,
                 v_type,
                 v_oddlot,
                 v_session);
END;
/
/
