DECLARE
    l_sqlerrm   VARCHAR2 (4000);

    l_rec_cnt   NUMBER := 0;
BEGIN
    DELETE FROM error_log
          WHERE mig_table = 'ESP_TRANSACTIONS_COMPLETE';

    FOR i
        IN (SELECT esp.transactiondate,
                   NVL (map16.map16_ntp_code, esp.exchangecode)
                       AS exchangecode,
                   esp.symbol,
                   esp.open,
                   esp.high,
                   esp.low,
                   esp.close,
                   esp.change,
                   esp.percentchanged,
                   esp.previousclosed,
                   esp.volume,
                   esp.turnover,
                   esp.isindex,
                   esp.splitfactor,
                   esp.nooftrades,
                   esp.vwap,
                   esp.lasttradeprice,
                   esp.todaysopen,
                   new_esp.transactiondate AS mapped_txn_date,
                   new_esp.exchangecode AS mapped_exchange,
                   new_esp.symbol AS mapped_symbol
              FROM mubasher_price.esp_transactions_complete@mubasher_price_link esp,
                   map16_optional_exchanges_m01 map16,
                   dfn_price.esp_transactions_complete new_esp
             WHERE     esp.transactiondate = new_esp.transactiondate(+)
                   AND esp.exchangecode = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, esp.exchangecode) =
                           new_esp.exchangecode(+)
                   AND esp.symbol = new_esp.symbol(+))
    LOOP
        BEGIN
            IF (    i.mapped_txn_date IS NULL
                AND i.mapped_exchange IS NULL
                AND i.mapped_symbol IS NULL)
            THEN
                INSERT
                  INTO dfn_price.esp_transactions_complete (transactiondate,
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
                                                            lasttradeprice,
                                                            todaysopen,
                                                            lasttradedprice,
                                                            lasttradeddate,
                                                            bestaskprice,
                                                            bestaskquantity,
                                                            bestbidprice,
                                                            bestbidquantity)
                VALUES (i.transactiondate, -- transactiondate
                        i.exchangecode, -- exchangecode
                        i.symbol, -- symbol
                        i.open, -- open
                        i.high, -- high
                        i.low, -- low
                        i.close, -- close
                        i.change, -- change
                        i.percentchanged, -- percentchanged
                        i.previousclosed, -- previousclosed
                        i.volume, -- volume
                        i.turnover, -- turnover
                        i.isindex, -- isindex
                        i.nooftrades, -- nooftrades
                        i.vwap, -- vwap
                        i.lasttradeprice, -- lasttradeprice
                        i.todaysopen, -- todaysopen
                        NULL, -- lasttradedprice | Not Available
                        NULL, -- lasttradeddate | Not Available
                        NULL, -- bestaskprice | Not Available
                        NULL, -- bestaskquantity | Not Available
                        NULL, -- bestbidprice | Not Available
                        NULL -- bestbidquantity | Not Available
                            );
            ELSE
                UPDATE dfn_price.esp_transactions_complete
                   SET open = i.open, -- open
                       high = i.high, -- hign
                       low = i.low, -- low
                       close = i.close, -- close
                       change = i.change, -- change
                       percentchanged = i.percentchanged, -- percentchanged
                       previousclosed = i.previousclosed, -- previousclosed
                       volume = i.volume, -- volume
                       turnover = i.turnover, -- turnover
                       isindex = i.isindex, -- isindex
                       nooftrades = i.nooftrades, -- nooftrades
                       vwap = i.vwap, -- vwap
                       lasttradeprice = i.lasttradeprice, -- lasttradeprice
                       todaysopen = i.todaysopen, -- todaysopen
                       lasttradedprice = NULL, -- lasttradedprice | Not Available
                       lasttradeddate = NULL, -- lasttradeddate | Not Available
                       bestaskprice = NULL, -- bestaskprice | Not Available
                       bestaskquantity = NULL, -- bestaskquantity | Not Available
                       bestbidprice = NULL, -- bestbidprice | Not Available
                       bestbidquantity = NULL -- bestbidquantity | Not Available
                 WHERE     transactiondate = i.mapped_txn_date
                       AND exchangecode = i.mapped_exchange
                       AND symbol = i.mapped_symbol;
            END IF;

            l_rec_cnt := l_rec_cnt + 1;

            IF MOD (l_rec_cnt, 25000) = 0
            THEN
                COMMIT;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'ESP_TRANSACTIONS_COMPLETE',
                                   'Date: '
                                || i.transactiondate
                                || ' - '
                                || ' Exg: '
                                || i.exchangecode
                                || ' - '
                                || ' Symbol: '
                                || i.symbol,
                                   'Date: '
                                || i.transactiondate
                                || ' - '
                                || ' Exg: '
                                || i.exchangecode
                                || ' - '
                                || ' Symbol: '
                                || i.symbol,
                                l_sqlerrm,
                                CASE
                                    WHEN (    i.mapped_txn_date IS NULL
                                          AND i.mapped_exchange IS NULL
                                          AND i.mapped_symbol IS NULL)
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/