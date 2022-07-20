
CREATE OR REPLACE PROCEDURE DFN_PRICE.ESP_EOD (
    mp_exchangecode IN esp_exchangemaster.exchange%TYPE DEFAULT NULL)
IS
    ml_trandate   esp_exchangemaster.last_active_date%TYPE DEFAULT NULL;
BEGIN
    /*
    *  Date            User            Change
    *  31-07-2008      saranga         Below

    *  will be invoked daily from an event triggered at the market closure.
    */

    DELETE esp_intraday_ohlc
     WHERE exchangecode = mp_exchangecode AND trade_min < (SYSDATE - 30);

    ml_trandate := TRUNC (SYSDATE);

    INSERT INTO esp_transactions_complete (transactiondate,
                                           exchangecode,
                                           symbol,
                                           open,
                                           high,
                                           low,
                                           close,
                                           change,
                                           percentchanged,
                                           previousclosed,
                                           volume,
                                           turnover,
                                           isindex,
                                           nooftrades,
                                           vwap,
                                           bestaskprice,
                                           bestaskquantity,
                                           bestbidprice,
                                           bestbidquantity,
                                           todaysopen,
                                           lasttradeddate)
        SELECT TRUNC (ml_trandate),
               exchangecode,
               symbol,
               NVL (todaysopen, 0),
               NVL (high, 0),
               NVL (low, 0),
               NVL (todaysclosed, 0),
               NVL (change, 0),
               NVL (percentchanged, 0),
               NVL (previousclosed, 0),
               NVL (volume, 0),
               NVL (turnover, 0),
               0,
               NVL (nooftrades, 0),
               NVL (vwap, 0),
               bestaskprice,
               bestaskquantity,
               bestbidprice,
               bestbidquantity,
               NVL (todaysopen, 0),
               TRUNC (ml_trandate)
          FROM esp_todays_snapshots
         WHERE exchangecode = mp_exchangecode;

    INSERT INTO esp_transactions_complete (transactiondate,
                                           exchangecode,
                                           symbol,
                                           open,
                                           high,
                                           low,
                                           close,
                                           change,
                                           percentchanged,
                                           previousclosed,
                                           volume,
                                           turnover,
                                           isindex,
                                           nooftrades,
                                           todaysopen,
                                           lasttradeddate)
        SELECT TRUNC (ml_trandate),
               exchangecode,
               symbol,
               todayintindex,
               high,
               low,
               indexvalue,
               netchange,
               perce_change,
               advprevcloseidxval,
               volume,
               turnover,
               1,
               0,
               todayintindex,
               TRUNC (ml_trandate)
          FROM esp_indicies
         WHERE     exchangecode = mp_exchangecode
               AND symbol NOT IN
                       (SELECT DISTINCT tc.symbol
                          FROM esp_transactions_complete tc, esp_indicies i
                         WHERE     tc.exchangecode = i.exchangecode
                               AND tc.symbol = i.symbol);

    UPDATE esp_exchangemaster
       SET last_eod_date = SYSDATE
     WHERE exchange = mp_exchangecode;

    COMMIT;
EXCEPTION
    WHEN OTHERS
    THEN
        ROLLBACK;
        RAISE;
END;
/
/
