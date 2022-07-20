
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_INIT_TABLES_AT_MKT_INIT (
    v_exchangecode IN VARCHAR2 DEFAULT NULL)
AS
BEGIN
    SET TRANSACTION READ WRITE;

    UPDATE esp_exchangemaster
       SET last_init_date = SYSDATE
     WHERE exchange = v_exchangecode;

    DELETE esp_intraday_trades
     WHERE exchangecode = v_exchangecode;

    DELETE esp_intraday_combine_trades
     WHERE exchangecode = v_exchangecode;

    DELETE esp_marketdepth
     WHERE exchangecode = v_exchangecode;

    INSERT INTO esp_marketdepth (exchangecode, symbol)
        (SELECT exchangecode, symbol
           FROM esp_todays_snapshots
          WHERE exchangecode = v_exchangecode);

    COMMIT;
END;
/
/
