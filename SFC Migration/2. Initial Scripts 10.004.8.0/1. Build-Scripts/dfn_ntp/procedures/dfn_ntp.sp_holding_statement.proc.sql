CREATE OR REPLACE PROCEDURE dfn_ntp.sp_holding_statement (
    p_view                   OUT SYS_REFCURSOR,
    prows                    OUT NUMBER,
    pt02_trd_acnt_id_u07         NUMBER,
    pd1                          DATE,
    pd2                          DATE,
    pdecimals                    NUMBER DEFAULT 2,
    pt02_symbol_code_m20         VARCHAR2 DEFAULT NULL,
    pt02_exchange_code_m01       VARCHAR2 DEFAULT NULL)
IS
    lcount    NUMBER;
    lformat   VARCHAR (100);
BEGIN
    lformat := '99999';
    lcount := 0;

    IF (pdecimals > 0)
    THEN
        lformat := lformat || '.';

        WHILE (lcount < pdecimals)
        LOOP
            lformat := lformat || '9';
            lcount := lcount + 1;
        END LOOP;
    END IF;

    IF     (pt02_exchange_code_m01 IS NOT NULL)
       AND (pt02_symbol_code_m20 IS NULL)
    THEN
        OPEN p_view FOR
            SELECT pd1 AS datetime,
                   pd1 AS tdate,
                   h01_symbol_code_m20 AS t02_symbol_code_m20,
                   m20.m20_short_description,
                   m20.m20_short_description_lang,
                   m20.m20_long_description,
                   m20.m20_long_description_lang,
                   h01_trading_acnt_id_u07 AS t02_trd_acnt_id_u07,
                   h01_net_holding AS holding_net,
                   'Opening Balance' AS narration,
                   h01_exchange_code_m01 AS t02_exchange_code_m01,
                   ' ' AS side,
                   ROUND (h01_avg_price, pdecimals) AS avg_price
              FROM     vw_h01_holding_summary h01
                   JOIN
                       m20_symbol m20
                   ON h01.h01_symbol_id_m20 = m20.m20_id
             WHERE     h01_date = pd1 - 1
                   AND h01_trading_acnt_id_u07 = pt02_trd_acnt_id_u07
                   AND h01_exchange_code_m01 = pt02_exchange_code_m01
            UNION ALL
              SELECT t02_create_date + 30 / 86400 AS datetime,
                     t02_create_date AS tdate,
                     t02_symbol_code_m20,
                     m20_short_description,
                     m20_short_description_lang,
                     m20_long_description,
                     m20_long_description_lang,
                     t02_trd_acnt_id_u07,
                     SUM (t02_holding_net_adjst) AS holding_net,
                     side AS narration,
                     t02_exchange_code_m01,
                     side,
                     ROUND (t02_last_price, pdecimals) AS avg_price
                FROM vw_t02_holdings_log
               WHERE                                     -- (last_shares) <> 0
                         -- AND
                         t02_trd_acnt_id_u07 = pt02_trd_acnt_id_u07
                     AND t02_create_date >= pd1
                     AND t02_create_date <= pd2
                     AND t02_exchange_code_m01 = pt02_exchange_code_m01
                     AND t02_trade_process_stat_id_v01 = 25
                     AND t02_txn_entry_status = 0
            GROUP BY t02_create_date,
                     t02_trd_acnt_id_u07,
                     t02_symbol_code_m20,
                     m20_short_description,
                     m20_short_description_lang,
                     m20_long_description,
                     m20_long_description_lang,
                     t02_exchange_code_m01,
                     side,
                     ROUND (t02_last_price, pdecimals)
            ORDER BY t02_symbol_code_m20, datetime, narration; /*dont change the orderby */
    ELSIF (    (pt02_symbol_code_m20 IS NULL)
           AND (pt02_exchange_code_m01 IS NULL))
    THEN
        OPEN p_view FOR
            /*  SELECT pd1 AS datetime,
                     pd1 AS tdate,
                     t02_symbol_code_m20,
                     m20_short_description,
                     m20_short_description_lang,
                     m20_long_description,
                     m20_long_description_lang,
                     t02_trd_acnt_id_u07,
                     SUM (t02_holding_net) AS t02_holding_net,
                     'Opening Balance' AS narration,
                     t02_exchange_code_m01,
                     ' ' AS side
                FROM vw_t02_holdings_log
               WHERE     t02_trd_acnt_id_u07 = pt02_trd_acnt_id_u07
                     AND last_shares <> 0
                     AND t02_create_date < pd1
            GROUP BY t02_symbol_code_m20,
                     m20_short_description,
                     m20_short_description_lang,
                     m20_long_description,
                     m20_long_description_lang,
                     t02_trd_acnt_id_u07,
                     t02_exchange_code_m01
              HAVING SUM (last_shares) <> 0*/

            SELECT pd1 AS datetime,
                   pd1 AS tdate,
                   h01_symbol_code_m20 AS t02_symbol_code_m20,
                   m20.m20_short_description,
                   m20.m20_short_description_lang,
                   m20.m20_long_description,
                   m20.m20_long_description_lang,
                   h01_trading_acnt_id_u07 AS t02_trd_acnt_id_u07,
                   h01_net_holding AS holding_net,
                   'Opening Balance' AS narration,
                   h01_exchange_code_m01 AS t02_exchange_code_m01,
                   ' ' AS side,
                   ROUND (h01_avg_price, pdecimals) AS avg_price
              FROM     vw_h01_holding_summary h01
                   JOIN
                       m20_symbol m20
                   ON h01.h01_symbol_id_m20 = m20.m20_id
             WHERE     h01_date = pd1 - 1
                   AND h01_trading_acnt_id_u07 = pt02_trd_acnt_id_u07
            UNION ALL
              SELECT t02_create_date + 30 / 86400 AS datetime,
                     t02_create_date AS tdate,
                     t02_symbol_code_m20,
                     m20_short_description,
                     m20_short_description_lang,
                     m20_long_description,
                     m20_long_description_lang,
                     t02_trd_acnt_id_u07,
                     SUM (t02_holding_net_adjst) AS holding_net,
                     side AS narration,
                     t02_exchange_code_m01,
                     side,
                     ROUND (t02_last_price, pdecimals) AS avg_price
                FROM vw_t02_holdings_log
               WHERE                                     -- (last_shares) <> 0
                         -- AND
                         t02_trd_acnt_id_u07 = pt02_trd_acnt_id_u07
                     AND t02_create_date >= pd1
                     AND t02_create_date <= pd2
            GROUP BY t02_create_date,
                     t02_trd_acnt_id_u07,
                     t02_symbol_code_m20,
                     m20_short_description,
                     m20_short_description_lang,
                     m20_long_description,
                     m20_long_description_lang,
                     t02_exchange_code_m01,
                     side,
                     ROUND (t02_last_price, pdecimals)
            ORDER BY datetime, t02_symbol_code_m20, narration;
    ELSE
        OPEN p_view FOR
            /*   SELECT pd1 AS datetime,
                      pd1 AS tdate,
                      t02_symbol_code_m20,
                      m20_short_description,
                      m20_short_description_lang,
                      m20_long_description,
                      m20_long_description_lang,
                      t02_trd_acnt_id_u07,
                      SUM (t02_holding_net) AS t02_holding_net,
                      'Balance B/F' AS narration,
                      t02_exchange_code_m01,
                      'Opening Balance' AS side,
                      NULL AS t02_price
                 FROM vw_t02_holdings_log
                WHERE     t02_trd_acnt_id_u07 = pt02_trd_acnt_id_u07
                      AND t02_create_date < pd1
                      AND (last_shares) <> 0
                      AND t02_symbol_code_m20 = pt02_symbol_code_m20
                      AND t02_exchange_code_m01 = pt02_exchange_code_m01
             GROUP BY t02_symbol_code_m20,
                      m20_short_description,
                      m20_short_description_lang,
                      m20_long_description,
                      m20_long_description_lang,
                      t02_trd_acnt_id_u07,
                      pt02_exchange_code_m01
               HAVING SUM (last_shares) <> 0 */

            SELECT pd1 AS datetime,
                   pd1 AS tdate,
                   h01_symbol_code_m20 AS t02_symbol_code_m20,
                   m20.m20_short_description,
                   m20.m20_short_description_lang,
                   m20.m20_long_description,
                   m20.m20_long_description_lang,
                   h01_trading_acnt_id_u07 AS t02_trd_acnt_id_u07,
                   h01_net_holding AS holding_net,
                   'Opening Balance' AS narration,
                   h01_exchange_code_m01 AS t02_exchange_code_m01,
                   ' ' AS side,
                   --NULL AS t02_price
                   ROUND (h01_avg_price, pdecimals) AS avg_price
              FROM     vw_h01_holding_summary h01
                   JOIN
                       m20_symbol m20
                   ON h01.h01_symbol_id_m20 = m20.m20_id
             WHERE     h01_date = pd1 - 1
                   AND h01_trading_acnt_id_u07 = pt02_trd_acnt_id_u07
                   AND h01_exchange_code_m01 = pt02_exchange_code_m01
                   AND h01_symbol_code_m20 = pt02_symbol_code_m20
            UNION ALL
            SELECT t02_create_date AS datetime,
                   t02_create_date + 30 / 86400 AS tdate,
                   t02_symbol_code_m20,
                   m20_short_description,
                   m20_short_description_lang,
                   m20_long_description,
                   m20_long_description_lang,
                   t02_trd_acnt_id_u07,
                   (last_shares * SIGN) AS holding_net,
                   CASE
                       WHEN (side IN ('Buy', 'Sell'))
                       THEN
                              (last_shares * SIGN)
                           || ' '
                           || t02_symbol_code_m20
                           || ' @'
                           || TO_CHAR (
                                  ROUND (NVL (ABS (t02_last_price), 0),
                                         pdecimals),
                                  lformat)
                       ELSE
                           t02_narration
                   END
                       AS narration,
                   t02_exchange_code_m01,
                   side,
                   ROUND (t02_last_price, pdecimals) AS avg_price
              FROM vw_t02_holdings_log
             WHERE                                -- (last_shares * SIGN) <> 0
                       --AND
                       t02_trd_acnt_id_u07 = pt02_trd_acnt_id_u07
                   AND t02_create_date >= pd1
                   AND t02_create_date <= pd2
                   AND t02_symbol_code_m20 = pt02_symbol_code_m20
                   AND t02_exchange_code_m01 = pt02_exchange_code_m01
            ORDER BY datetime, t02_symbol_code_m20, narration;
    END IF;
END;
/