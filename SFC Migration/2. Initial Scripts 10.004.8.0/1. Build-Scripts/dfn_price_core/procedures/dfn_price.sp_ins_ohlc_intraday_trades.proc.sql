
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_INS_OHLC_INTRADAY_TRADES (
    p_exchangecode         VARCHAR2,
    p_symbol               VARCHAR2,
    p_tradetime            DATE,
    p_open                 NUMBER,
    p_high                 NUMBER,
    p_low                  NUMBER,
    p_close                NUMBER,
    p_volume               NUMBER,
    p_nooftrades           NUMBER,
    p_turnover             NUMBER,
    p_vwap                 NUMBER,
    p_cashinnooftrades     NUMBER,
    p_cashinturnover       NUMBER,
    p_cashinvolume         NUMBER,
    p_cashoutnooftrades    NUMBER,
    p_cashoutturnover      NUMBER,
    p_cashoutvolume        NUMBER,
    p_instrument_type      NUMBER)
AS
/*
-- Name : SP_INS_OHLC_INTRADAY_TRADES
-- Purpose: This is the main procedure to update esp_intraday_ohlc table (RDBM update)
-- Author: Tharindu
-- Date: 30-04-2009
-- Version : 01.00.000
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  -------------------------------------------
*/
BEGIN
    INSERT INTO esp_intraday_ohlc (exchangecode,
                                   symbol,
                                   trade_min,
                                   open,
                                   high,
                                   low,
                                   close,
                                   volume,
                                   nooftrades,
                                   turnover,
                                   vwap,
                                   cashinnooftrades,
                                   cashinturnover,
                                   cashinvolume,
                                   cashoutnooftrades,
                                   cashoutturnover,
                                   cashoutvolume,
                                   instrument_type)
         VALUES (p_exchangecode,
                 p_symbol,
                 p_tradetime,
                 p_open,
                 p_high,
                 p_low,
                 p_close,
                 p_volume,
                 p_nooftrades,
                 p_turnover,
                 p_vwap,
                 p_cashinnooftrades,
                 p_cashinturnover,
                 p_cashinvolume,
                 p_cashoutnooftrades,
                 p_cashoutturnover,
                 p_cashoutvolume,
                 p_instrument_type);
END;
/
/
