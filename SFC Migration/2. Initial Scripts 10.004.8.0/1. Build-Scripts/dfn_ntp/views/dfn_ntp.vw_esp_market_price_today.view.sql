CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_esp_market_price_today
(
    transactiondate,
    exchangecode,
    symbol,
    currency,
    lastupdatedtime,
    lasttradetime,
    bestaskprice,
    bestaskquantity,
    bestbidprice,
    bestbidquantity,
    highpriceof52weeks,
    lowpriceof52weeks,
    lasttradeprice_only,
    lasttradequantity,
    high,
    low,
    change,
    volume,
    turnover,
    percentchanged,
    previousclosed,
    todaysopen,
    minprice,
    maxprice,
    todaysclosed,
    vwap,
    lasttradedprice,
    nooftrades,
    market_price,
    lasttradeddate
)
AS
    SELECT TRUNC (SYSDATE) AS transactiondate,
           a.exchangecode,
           a.symbol,
           a.currency,
           a.lastupdatedtime,
           a.lasttradetime,
           CASE
               WHEN a.exchangecode = 'KSE'
               THEN
                   ROUND (a.bestaskprice / 1000, 5)
               ELSE
                   a.bestaskprice
           END
               AS bestaskprice,
           a.bestaskquantity,
           CASE
               WHEN a.exchangecode = 'KSE'
               THEN
                   ROUND (a.bestbidprice / 1000, 5)
               ELSE
                   a.bestbidprice
           END
               AS bestbidprice,
           a.bestbidquantity,
           CASE
               WHEN a.exchangecode = 'KSE'
               THEN
                   ROUND (a.highpriceof52weeks / 1000, 5)
               ELSE
                   a.highpriceof52weeks
           END
               AS highpriceof52weeks,
           CASE
               WHEN a.exchangecode = 'KSE'
               THEN
                   ROUND (a.lowpriceof52weeks / 1000, 5)
               ELSE
                   a.lowpriceof52weeks
           END
               AS lowpriceof52weeks,
           CASE
               WHEN a.exchangecode = 'KSE'
               THEN
                   ROUND (a.lasttradeprice / 1000, 5)
               ELSE
                   a.lasttradeprice
           END
               AS lasttradeprice_only,
           a.lasttradequantity,
           a.high,
           a.low,
           a.change,
           a.volume,
           a.turnover,
           a.percentchanged,
           CASE
               WHEN a.exchangecode = 'KSE'
               THEN
                   ROUND (a.previousclosed / 1000, 5)
               ELSE
                   a.previousclosed
           END
               AS previousclosed,
           CASE
               WHEN a.exchangecode = 'KSE'
               THEN
                   ROUND (a.todaysopen / 1000, 5)
               ELSE
                   a.todaysopen
           END
               AS todaysopen,
           a.minprice,
           a.maxprice,
           CASE
               WHEN a.exchangecode = 'KSE'
               THEN
                   ROUND (a.todaysclosed / 1000, 5)
               ELSE
                   a.todaysclosed
           END
               AS todaysclosed,
           a.vwap,
           CASE
               WHEN a.exchangecode = 'KSE'
               THEN
                   ROUND (a.lasttradedprice / 1000, 5)
               ELSE
                   a.lasttradedprice
           END
               AS lasttradedprice,
           nooftrades,
           CASE
               WHEN a.exchangecode = 'KSE'
               THEN
                   CASE
                       WHEN a.todaysclosed > 0
                       THEN
                           ROUND (a.todaysclosed / 1000, 5)
                       WHEN a.lasttradeprice > 0
                       THEN
                           ROUND (a.lasttradeprice / 1000, 5)
                       ELSE
                           ROUND (a.lasttradedprice / 1000, 5)
                   END
               ELSE
                   CASE
                       WHEN a.todaysclosed > 0 THEN a.todaysclosed
                       WHEN a.lasttradeprice > 0 THEN a.lasttradeprice
                       ELSE a.lasttradedprice
                   END
           END
               AS market_price,
           CASE
               WHEN TRUNC (a.lasttradetime) =
                        TO_DATE ('1970/01/01', 'yyyy/mm/dd')
               THEN
                   TRUNC (a.lasttradeddate)
               ELSE
                   TRUNC (a.lasttradetime)
           END
               AS lasttradeddate
      FROM dfn_price.esp_todays_snapshots a
-- b.instrumenttype = '0' ?? is it required;
/
