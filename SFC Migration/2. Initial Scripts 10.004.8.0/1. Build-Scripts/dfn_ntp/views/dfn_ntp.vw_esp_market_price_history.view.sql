CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_esp_market_price_history
(
    transactiondate,
    exchangecode,
    symbol,
    market_price,
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
    lasttradedprice,
    todaysopen,
    lasttradeddate,
    bestaskprice,
    bestaskquantity,
    bestbidprice,
    bestbidquantity,
    marektprice
)
AS
    SELECT esp_hist.transactiondate AS transactiondate,
           esp_hist.exchangecode,
           esp_hist.symbol,
           esp_hist.close AS market_price,
           esp_hist.open,
           esp_hist.high,
           esp_hist.low,
           esp_hist.close,
           esp_hist.change,
           esp_hist.percentchanged,
           CASE
               WHEN esp_hist.exchangecode = 'KSE'
               THEN
                   ROUND (esp_hist.previousclosed / 1000, 5)
               ELSE
                   esp_hist.previousclosed
           END
               AS previousclosed,
           esp_hist.volume,
           esp_hist.turnover,
           esp_hist.isindex,
           esp_hist.nooftrades,
           esp_hist.vwap,
           CASE
               WHEN esp_hist.exchangecode = 'KSE'
               THEN
                   ROUND (esp_hist.lasttradedprice / 1000, 5)
               ELSE
                   esp_hist.lasttradedprice
           END
               AS lasttradedprice,
           CASE
               WHEN esp_hist.exchangecode = 'KSE'
               THEN
                   ROUND (esp_hist.todaysopen / 1000, 5)
               ELSE
                   esp_hist.todaysopen
           END
               AS todaysopen,
           TO_DATE (esp_hist.lasttradeddate) AS lasttradeddate,
           CASE
               WHEN esp_hist.exchangecode = 'KSE'
               THEN
                   ROUND (esp_hist.bestaskprice / 1000, 5)
               ELSE
                   esp_hist.bestaskprice
           END
               AS bestaskprice,
           esp_hist.bestaskquantity,
           CASE
               WHEN esp_hist.exchangecode = 'KSE'
               THEN
                   ROUND (esp_hist.bestbidprice / 1000, 5)
               ELSE
                   esp_hist.bestbidprice
           END
               AS bestbidprice,
           esp_hist.bestbidquantity,
           esp_hist.close AS marektprice
      FROM dfn_price.esp_transactions_complete esp_hist
--  b.instrumenttype = '0' ???;
/
