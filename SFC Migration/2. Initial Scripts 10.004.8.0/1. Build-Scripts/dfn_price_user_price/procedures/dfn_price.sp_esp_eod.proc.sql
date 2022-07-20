CREATE OR REPLACE PROCEDURE dfn_price.sp_esp_eod
IS
    l_exchange_count     NUMBER;
    l_last_active_date   DATE;
BEGIN
    FOR i IN (SELECT * FROM dfn_ntp.m01_exchanges)
    LOOP
        SELECT COUNT (last_active_date)
          INTO l_exchange_count
          FROM esp_exchangemaster
         WHERE exchange = i.m01_exchange_code;

        IF l_exchange_count = 1
        THEN
            SELECT TRUNC (last_active_date)
              INTO l_last_active_date
              FROM esp_exchangemaster
             WHERE exchange = i.m01_exchange_code;

            DELETE FROM esp_transactions_complete
                  WHERE     transactiondate >= l_last_active_date
                        AND exchangecode = i.m01_exchange_code;

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
                SELECT l_last_active_date,
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
                       NVL (bestaskprice, 0),
                       NVL (bestaskquantity, 0),
                       NVL (bestbidprice, 0),
                       NVL (bestbidquantity, 0),
                       NVL (todaysopen, 0),
                       l_last_active_date
                  FROM esp_todays_snapshots
                 WHERE     exchangecode = i.m01_exchange_code
                       AND TRUNC (lasttradetime) >= l_last_active_date;

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
                SELECT l_last_active_date,
                       exchangecode,
                       symbol,
                       NVL (todayintindex, 0),
                       NVL (high, 0),
                       NVL (low, 0),
                       NVL (indexvalue, 0),
                       NVL (netchange, 0),
                       NVL (perce_change, 0),
                       NVL (advprevcloseidxval, 0),
                       NVL (volume, 0),
                       NVL (turnover, 0),
                       1,
                       NVL (nooftrades, 0),
                       NVL (todayintindex, 0),
                       l_last_active_date
                  FROM esp_indicies
                 WHERE     exchangecode = i.m01_exchange_code
                       AND symbol NOT IN (SELECT DISTINCT snap.symbol
                                            FROM     esp_todays_snapshots snap
                                                 JOIN
                                                     esp_indicies idx
                                                 ON     snap.exchangecode =
                                                            idx.exchangecode
                                                    AND snap.symbol =
                                                            idx.symbol);

            UPDATE esp_exchangemaster
               SET last_eod_date = SYSDATE
             WHERE exchange = i.m01_exchange_code;

            COMMIT;
        END IF;
    END LOOP;
EXCEPTION
    WHEN OTHERS
    THEN
        ROLLBACK;
        RAISE;
END;
/

GRANT EXECUTE ON dfn_price.sp_esp_eod TO dfn_ntp WITH GRANT OPTION
/
