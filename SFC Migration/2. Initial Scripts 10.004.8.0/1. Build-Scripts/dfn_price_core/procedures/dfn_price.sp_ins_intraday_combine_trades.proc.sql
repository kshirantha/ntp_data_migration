
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_INS_INTRADAY_COMBINE_TRADES (
   v_exchangecode        IN   VARCHAR2 DEFAULT NULL,
   v_symbol              IN   VARCHAR2 DEFAULT NULL,
   v_tradetime           IN   DATE DEFAULT NULL,
   v_lasttradeprice      IN   NUMBER DEFAULT NULL,
   v_lasttradequantity   IN   NUMBER DEFAULT NULL,
   v_change              IN   NUMBER DEFAULT NULL,
   v_percentchanged      IN   NUMBER DEFAULT NULL,
   v_sequence_no         IN   NUMBER DEFAULT NULL,
   v_type                IN   CHAR DEFAULT NULL,
   v_oddlot              in   number default null,
   v_session             in   number default null,
   v_splits              in   number default null,
   v_trend			         in   number default null,
   v_instrument_type     in   number default null
   
)
AS
BEGIN
   INSERT INTO ESP_INTRADAY_COMBINE_TRADES
               (exchangecode, symbol, tradetime, lasttradeprice,
                lasttradequantity, change, percentchanged,
                sequence_no, type, oddlot, session_id, splits,
                instrument_type
               )
        VALUES (v_exchangecode, v_symbol, v_tradetime, v_lasttradeprice,
                v_lasttradequantity, v_change, v_percentchanged,
                v_sequence_no, v_type, v_oddlot, v_session, v_splits,
                v_instrument_type
               );
END;
/
/
