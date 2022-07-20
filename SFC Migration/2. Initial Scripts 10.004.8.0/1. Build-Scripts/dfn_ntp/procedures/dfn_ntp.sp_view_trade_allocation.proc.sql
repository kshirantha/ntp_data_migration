CREATE OR REPLACE PROCEDURE dfn_ntp.sp_view_trade_allocation (
    p_view        OUT SYS_REFCURSOR,
    prows         OUT NUMBER,
    psymbol           NUMBER,
    ptxnid            VARCHAR2,
    paction           NUMBER,
    ptradingacc       VARCHAR2 DEFAULT NULL,
    pmethod           NUMBER DEFAULT NULL,
    proundqty         NUMBER DEFAULT NULL)
IS
    l_lot_size   NUMBER;
    l_total_holdings      NUMBER;
    l_weight              NUMBER;
    l_trading_acc_count   NUMBER;
BEGIN
    -- Action: Merge
    IF paction = 3
    THEN
        OPEN p_view FOR
              SELECT MAX (u01.u01_id) AS u01_id,
                     MAX (u01.u01_customer_no) AS u01_customer_no,
                     MAX (u01.u01_display_name) AS u01_display_name,
                     u07.u07_id,
                     MAX (u07.u07_display_name) AS u07_display_name,
                     MAX (u06.u06_id) AS u06_id,
                     t02.t02_symbol_id_m20,
                     MAX (t02.t02_symbol_code_m20) t02_symbol_code_m20,
                     t02.t02_side,
                     CASE
                         WHEN t02.t02_side = 1 THEN 'Buy'
                         WHEN t02.t02_side = 2 THEN 'Sell'
                         ELSE 'Sub'
                     END
                         order_side,
                     SUM (t02_last_shares) AS allocated_qty,
                     ROUND (
                           SUM (t02.t02_last_price * t02.t02_last_shares)
                         / SUM (t02.t02_last_shares),
                         2)
                         AS t02_last_price,
                       SUM (t02_last_shares)
                     * ROUND (
                             SUM (t02.t02_last_price * t02.t02_last_shares)
                           / SUM (t02.t02_last_shares),
                           2)
                         AS order_value,
                     SUM (t02.t02_broker_tax) + SUM (t02.t02_exchange_tax)
                         AS total_tax,
                     SUM (t02.t02_exchange_tax) AS exchange_tax,
                     SUM (t02.t02_broker_tax) AS broker_tax,
                     SUM (t02.t02_broker_commission) AS broker_commission,
                     SUM (t02.t02_exg_commission) AS exg_commission,
                     SUM (t02_commission_adjst) AS avg_commission,
                         SUM (t02_last_shares)
                       * ROUND (
                               SUM (t02.t02_last_price * t02.t02_last_shares)
                             / SUM (t02.t02_last_shares),
                             2)
                     + SUM (t02_commission_adjst)
                     + SUM (t02.t02_broker_tax)
                     + SUM (t02.t02_exchange_tax)
                         net_value,
                     MAX (u06.u06_balance) AS u06_balance,
                     MAX (u24.u24_net_holding) AS u24_net_holding,
                     t02.t02_create_date,
                     t02.t02_custodian_id_m26 AS m26_id,
                     MAX (m26_sid) AS m26_sid,
                     MAX (m26.m26_name) AS custodian,
                     MAX (m20.m20_exchange_code_m01) AS exchange_code,
                     MAX (t02.t02_cash_settle_date) AS cash_settle_date,
                     MAX (t02.t02_holding_settle_date) AS holding_settle_date,
                     MAX (NVL (m20.m20_price_ratio, 1)) AS price_ratio,
                     MAX (t02.t02_inst_id_m02) AS t02_inst_id_m02
                FROM t02_transaction_log_order_all t02
                     INNER JOIN u01_customer u01
                         ON u01.u01_id = t02.t02_customer_id_u01
                     INNER JOIN u07_trading_account u07
                         ON t02.t02_trd_acnt_id_u07 = u07.u07_id
                     INNER JOIN u06_cash_account u06
                         ON u07.u07_cash_account_id_u06 = u06.u06_id
                     INNER JOIN m20_symbol m20
                         ON t02.t02_symbol_id_m20 = m20.m20_id
                     LEFT JOIN u24_holdings u24
                         ON     u24.u24_trading_acnt_id_u07 = u07.u07_id
                            AND u24.u24_symbol_id_m20 = t02.t02_symbol_id_m20
                            AND u24.u24_exchange_code_m01 =
                                    t02.t02_exchange_code_m01
                            AND u24.u24_custodian_id_m26 =
                                    t02.t02_custodian_id_m26
                     LEFT JOIN m26_executing_broker m26
                         ON t02.t02_custodian_id_m26 = m26.m26_id
                     INNER JOIN (    SELECT TRIM (REGEXP_SUBSTR (ptxnid,
                                                                 '[^,]+',
                                                                 1,
                                                                 LEVEL))
                                                txnid
                                       FROM DUAL
                                 CONNECT BY REGEXP_SUBSTR (ptxnid,
                                                           '[^,]+',
                                                           1,
                                                           LEVEL)
                                                IS NOT NULL) txnids
                         ON t02.t02_last_db_seq_id = txnids.txnid
            GROUP BY u07.u07_id,
                     t02.t02_symbol_id_m20,
                     t02.t02_create_date,
                     t02.t02_side,
                     t02.t02_custodian_id_m26;
    END IF;

    --Split / Pro Rata Basis
    IF paction = 2 AND pmethod = 1
    THEN
        OPEN p_view FOR
            SELECT u01.u01_id,
                   u01.u01_customer_no,
                   u01.u01_display_name,
                   u07.u07_id,
                   u07.u07_display_name,
                   u06.u06_id,
                   t02.t02_symbol_id_m20,
                   t02.t02_symbol_code_m20,
                   t02.t02_side,
                   t02.order_side,
                   t02.allocated_qty,
                   actual_qty,
                   t02.t02_last_price,
                   allocated_qty * t02_last_price AS order_value,
                   exchange_tax,
                   broker_tax,
                   exchange_tax + broker_tax AS total_tax,
                   broker_commission,
                   exg_commission,
                   avg_commission,
                     (allocated_qty * t02_last_price)
                   + (avg_commission + exchange_tax + broker_tax)
                       net_value,
                   u06.u06_balance,
                   u24_net_holding,
                   t02.t02_create_date,
                   m26.m26_id,
                   m26_sid,
                   m26.m26_name AS custodian,
                   t02.exchange_code,
                   t02.cash_settle_date,
                   t02.holding_settle_date,
                   t02_inst_id_m02,
                   m20.m20_lot_size,
                   t02.t02_last_shares,
                   NVL (m20_price_ratio, 1) AS price_ratio,
                   t02_accrude_interest,
                   weight_per
              FROM (SELECT u07_id,
                           t02.t02_symbol_id_m20,
                           t02.t02_symbol_code_m20,
                           t02.t02_side,
                           CASE
                               WHEN t02.t02_side = 1 THEN 'Buy'
                               WHEN t02.t02_side = 2 THEN 'Sell'
                               ELSE 'Sub'
                           END
                               AS order_side,
                           t02.t02_cum_qty AS actual_qty,
                           DECODE (
                               proundqty,
                               1,   weight * t02.t02_cum_qty
                                  - MOD (weight * t02.t02_cum_qty, lot_size),
                               FLOOR (weight * t02.t02_cum_qty))
                               allocated_qty,
                           (weight * 100) || '%' AS weight_per,
                           --  t02.t02_avgprice avg_price,
                           ROUND (
                               t02.t02_exchange_tax / COUNT (u07_id) OVER (),
                               2)
                               AS exchange_tax,
                           ROUND (
                               t02.t02_broker_tax / COUNT (u07_id) OVER (),
                               2)
                               AS broker_tax,
                           ROUND (
                                 t02.t02_broker_commission
                               / COUNT (u07_id) OVER (),
                               2)
                               AS broker_commission,
                           ROUND (
                               t02_exg_commission / COUNT (u07_id) OVER (),
                               2)
                               AS exg_commission,
                           ROUND (
                               t02_commission_adjst / COUNT (u07_id) OVER (),
                               2)
                               AS avg_commission,
                           t02.t02_create_date,
                           u24_net_holding,
                           t02.t02_cash_settle_date cash_settle_date,
                           t02.t02_holding_settle_date holding_settle_date,
                           t02.t02_exchange_code_m01 exchange_code,
                           t02.t02_inst_id_m02,
                           t02.t02_last_shares,
                           t02.t02_last_price,
                           t02.t02_accrude_interest,
                           t02.t02_custodian_id_m26
                      FROM (SELECT u07.u07_id,
                                   u24.u24_net_holding,
                                   ( (ROUND (
                                            u24_net_holding
                                          / total.total_holding,
                                          2)))
                                       AS weight,
                                   m20.m20_lot_size AS lot_size,
                                   u24.u24_symbol_id_m20
                              FROM u07_trading_account u07
                                   INNER JOIN u24_holdings u24
                                       ON u07.u07_id =
                                              u24.u24_trading_acnt_id_u07
                                   INNER JOIN (    SELECT TRIM (
                                                              REGEXP_SUBSTR (
                                                                  ptradingacc,
                                                                  '[^,]+',
                                                                  1,
                                                                  LEVEL))
                                                              trd_acc_id
                                                     FROM DUAL
                                               CONNECT BY REGEXP_SUBSTR (
                                                              ptradingacc,
                                                              '[^,]+',
                                                              1,
                                                              LEVEL)
                                                              IS NOT NULL) trdids
                                       ON u07.u07_id = trdids.trd_acc_id
                                   INNER JOIN m20_symbol m20
                                       ON m20.m20_id = u24.u24_symbol_id_m20
                                   INNER JOIN (  SELECT u24.u24_symbol_id_m20,
                                                        SUM (u24_net_holding)
                                                            AS total_holding
                                                   FROM u07_trading_account u07
                                                        INNER JOIN u24_holdings u24
                                                            ON u07.u07_id =
                                                                   u24.u24_trading_acnt_id_u07
                                                        INNER JOIN (    SELECT TRIM (
                                                                                   REGEXP_SUBSTR (
                                                                                       ptradingacc,
                                                                                       '[^,]+',
                                                                                       1,
                                                                                       LEVEL))
                                                                                   trd_acc_id
                                                                          FROM DUAL
                                                                    CONNECT BY REGEXP_SUBSTR (
                                                                                   ptradingacc,
                                                                                   '[^,]+',
                                                                                   1,
                                                                                   LEVEL)
                                                                                   IS NOT NULL) trdids
                                                            ON u07.u07_id =
                                                                   trdids.trd_acc_id
                                                  WHERE u24.u24_symbol_id_m20 =
                                                            psymbol
                                               GROUP BY u24.u24_symbol_id_m20) total
                                       ON u24.u24_symbol_id_m20 =
                                              total.u24_symbol_id_m20
                             WHERE u24.u24_symbol_id_m20 = psymbol) tbl,
                           t02_transaction_log_order_all t02
                     WHERE     (weight * t02.t02_cum_qty) >= 1
                           AND t02.t02_last_db_seq_id = ptxnid) t02
                   INNER JOIN u07_trading_account u07
                       ON t02.u07_id = u07.u07_id
                   INNER JOIN u01_customer u01
                       ON u01.u01_id = u07.u07_customer_id_u01
                   INNER JOIN u06_cash_account u06
                       ON u07.u07_cash_account_id_u06 = u06.u06_id
                   INNER JOIN m20_symbol m20
                       ON m20.m20_id = t02.t02_symbol_id_m20
                   INNER JOIN m26_executing_broker m26
                       ON t02.t02_custodian_id_m26 = m26.m26_id;
    END IF;

    --Split Manual
    IF paction = 2 AND pmethod = 2
    THEN
        OPEN p_view FOR
            SELECT u01.u01_id,
                   u01.u01_customer_no,
                   u01.u01_display_name,
                   u07.u07_id,
                   u07.u07_display_name,
                   u06.u06_id,
                   t02.t02_symbol_id_m20,
                   t02.t02_symbol_code_m20,
                   t02.t02_side,
                   t02.order_side,
                   t02.allocated_qty,
                   actual_qty,
                   t02.t02_last_price,
                   allocated_qty * t02_last_price AS order_value,
                   exchange_tax,
                   broker_tax,
                   exchange_tax + broker_tax AS total_tax,
                   broker_commission,
                   exg_commission,
                   avg_commission,
                   0 AS net_value,
                   u06.u06_balance,
                   u24_net_holding,
                   t02.t02_create_date,
                   m26.m26_id,
                   m26_sid,
                   m26.m26_name AS custodian,
                   t02.exchange_code,
                   t02.cash_settle_date,
                   t02.holding_settle_date,
                   t02_inst_id_m02,
                   m20.m20_lot_size,
                   t02.t02_last_shares,
                   NVL (m20_price_ratio, 1) AS price_ratio,
                   t02_accrude_interest
              FROM (SELECT u07_id,
                           t02.t02_symbol_id_m20,
                           t02.t02_symbol_code_m20,
                           t02.t02_side,
                           CASE
                               WHEN t02.t02_side = 1 THEN 'Buy'
                               WHEN t02.t02_side = 2 THEN 'Sell'
                               ELSE 'Sub'
                           END
                               order_side,
                           0 allocated_qty,
                           t02.t02_cum_qty AS actual_qty,
                           ROUND (
                               t02.t02_exchange_tax / COUNT (u07_id) OVER (),
                               2)
                               AS exchange_tax,
                           ROUND (
                               t02.t02_broker_tax / COUNT (u07_id) OVER (),
                               2)
                               AS broker_tax,
                           ROUND (
                                 t02.t02_broker_commission
                               / COUNT (u07_id) OVER (),
                               2)
                               AS broker_commission,
                           ROUND (
                               t02_exg_commission / COUNT (u07_id) OVER (),
                               2)
                               AS exg_commission,
                           ROUND (
                               t02_commission_adjst / COUNT (u07_id) OVER (),
                               2)
                               AS avg_commission,
                           t02.t02_create_date,
                           t02.t02_cash_settle_date cash_settle_date,
                           t02.t02_holding_settle_date holding_settle_date,
                           t02.t02_exchange_code_m01 exchange_code,
                           t02.t02_inst_id_m02,
                           t02.t02_last_shares,
                           t02.t02_last_price,
                           t02.t02_accrude_interest,
                           t02.t02_custodian_id_m26
                      FROM t02_transaction_log_order_all t02,
                           (    SELECT TRIM (REGEXP_SUBSTR (ptradingacc,
                                                            '[^,]+',
                                                            1,
                                                            LEVEL))
                                           u07_id
                                  FROM DUAL
                            CONNECT BY REGEXP_SUBSTR (ptradingacc,
                                                      '[^,]+',
                                                      1,
                                                      LEVEL)
                                           IS NOT NULL) custids
                     WHERE t02.t02_last_db_seq_id = ptxnid) t02
                   INNER JOIN u07_trading_account u07
                       ON t02.u07_id = u07.u07_id
                   INNER JOIN u01_customer u01
                       ON u01.u01_id = u07.u07_customer_id_u01
                   INNER JOIN u06_cash_account u06
                       ON u07.u07_cash_account_id_u06 = u06.u06_id
                   INNER JOIN m26_executing_broker m26
                       ON t02.t02_custodian_id_m26 = m26.m26_id
                   INNER JOIN m20_symbol m20
                       ON m20.m20_id = t02.t02_symbol_id_m20
                   LEFT JOIN u24_holdings u24
                       ON     u24.u24_trading_acnt_id_u07 = u07.u07_id
                          AND u24.u24_symbol_id_m20 = t02.t02_symbol_id_m20;
    END IF;

    --Merge & Allocate / Pro Rata Basis
    IF paction = 1 AND pmethod = 1
    THEN
        SELECT REGEXP_COUNT (ptradingacc,
                                                '[^,]+',
                                                1,
                             'i')
                   REGEXP_COUNT
          INTO l_trading_acc_count
          FROM DUAL;

          SELECT SUM (u24_net_holding) AS total_holding
            INTO l_total_holdings
            FROM u07_trading_account u07
                 INNER JOIN u24_holdings u24
                     ON u07.u07_id = u24.u24_trading_acnt_id_u07
                 INNER JOIN (    SELECT TRIM (REGEXP_SUBSTR (ptradingacc,
                                                             '[^,]+',
                                                             1,
                                                             LEVEL))
                                            trd_acc_id
                                   FROM DUAL
                             CONNECT BY REGEXP_SUBSTR (ptradingacc,
                                                       '[^,]+',
                                                       1,
                                                       LEVEL)
                                            IS NOT NULL) trdids
                     ON u07.u07_id = trdids.trd_acc_id
           WHERE u24.u24_symbol_id_m20 = psymbol
        GROUP BY u24.u24_symbol_id_m20;

        IF l_total_holdings = 0 AND l_trading_acc_count > 0
        THEN
            l_weight := (ROUND (1 / l_trading_acc_count, 2));

            OPEN p_view FOR
                SELECT u01.u01_id,
                       u01.u01_customer_no,
                       u01.u01_display_name,
                       u07.u07_id,
                       u07.u07_display_name,
                       u06.u06_id,
                       t02.t02_symbol_id_m20,
                       t02.t02_symbol_code_m20,
                       t02.t02_side,
                       t02.order_side,
                       t02.allocated_qty,
                       actual_qty,
                       t02.t02_last_price,
                       allocated_qty * t02_last_price AS order_value,
                       exchange_tax,
                       broker_tax,
                       exchange_tax + broker_tax AS total_tax,
                       broker_commission,
                       exg_commission,
                       avg_commission,
                         (allocated_qty * t02_last_price)
                       + (avg_commission + exchange_tax + broker_tax)
                           net_value,
                       u06.u06_balance,
                       0 AS u24_net_holding,
                       t02.t02_create_date,
                       m26.m26_id,
                       m26_sid,
                       m26.m26_name AS custodian,
                       t02.exchange_code,
                       t02.cash_settle_date,
                       t02.holding_settle_date,
                       t02_inst_id_m02,
                       m20.m20_lot_size,
                       t02.t02_last_shares,
                       NVL (m20_price_ratio, 1) AS price_ratio,
                       weight_per
                  FROM (SELECT u07_id,
                               t02.t02_symbol_id_m20,
                               t02.t02_symbol_code_m20,
                               t02.t02_side,
                               CASE
                                   WHEN t02.t02_side = 1 THEN 'Buy'
                                   WHEN t02.t02_side = 2 THEN 'Sell'
                                   ELSE 'Sub'
                               END
                                   AS order_side,
                               t02.t02_holding_net_adjst AS actual_qty,
                               DECODE (
                                   proundqty,
                                   1,   l_weight * t02.t02_holding_net_adjst
                                      - MOD (
                                              l_weight
                                            * t02.t02_holding_net_adjst,
                                            lot_size),
                                   FLOOR (
                                       l_weight * t02.t02_holding_net_adjst))
                                   allocated_qty,
                               (l_weight * 100) || '%' AS weight_per,
                               ROUND (
                                     t02.t02_exchange_tax
                                   / COUNT (u07_id) OVER (),
                                   2)
                                   AS exchange_tax,
                               ROUND (
                                     t02.t02_broker_tax
                                   / COUNT (u07_id) OVER (),
                                   2)
                                   AS broker_tax,
                               ROUND (
                                     t02.t02_broker_commission
                                   / COUNT (u07_id) OVER (),
                                   2)
                                   AS broker_commission,
                               ROUND (
                                     t02_exg_commission
                                   / COUNT (u07_id) OVER (),
                                   2)
                                   AS exg_commission,
                               ROUND (
                                     t02_commission_adjst
                                   / COUNT (u07_id) OVER (),
                                   2)
                                   AS avg_commission,
                               t02.t02_create_date,
                               --u24_net_holding,
                               t02.cash_settle_date,
                               t02.holding_settle_date,
                               t02.exchange_code,
                               t02.t02_inst_id_m02,
                               t02.t02_last_shares,
                               t02.t02_last_price,
                               t02.t02_custodian_id_m26
                          FROM (SELECT u07_id
                                  FROM     u07_trading_account u07
                                       INNER JOIN
                                           (    SELECT TRIM (
                                                           REGEXP_SUBSTR (
                                                               ptradingacc,
                                                               '[^,]+',
                                                               1,
                                                               LEVEL))
                                                           trd_acc_id
                                                  FROM DUAL
                                            CONNECT BY REGEXP_SUBSTR (
                                                           ptradingacc,
                                                           '[^,]+',
                                                           1,
                                                           LEVEL)
                                                           IS NOT NULL) trdids
                                       ON u07.u07_id = trdids.trd_acc_id) tbl,
                               (  SELECT t02_symbol_id_m20,
                                         MAX (m20.m20_lot_size) AS lot_size,
                                         t02_side,
                                         CASE
                                             WHEN t02_side = 1 THEN 'Buy'
                                             WHEN t02_side = 2 THEN 'Sell'
                                             ELSE 'Sub'
                                         END
                                             order_side,
                                         SUM (t02_last_shares)
                                             AS t02_last_shares,
                                         ROUND (
                                               SUM (
                                                     t02_last_price
                                                   * t02_last_shares)
                                             / SUM (t02_last_shares),
                                             2)
                                             AS t02_last_price,
                                         SUM (t02_exchange_tax)
                                             AS t02_exchange_tax,
                                         SUM (t02_broker_tax) AS t02_broker_tax,
                                         SUM (t02_broker_commission)
                                             AS t02_broker_commission,
                                         SUM (t02_exg_commission)
                                             AS t02_exg_commission,
                                         SUM (t02_commission_adjst)
                                             AS t02_commission_adjst,
                                         t02_create_date,
                                         t02_custodian_id_m26,
                                         MAX (t02_exchange_code_m01)
                                             AS exchange_code,
                                         MAX (t02_symbol_code_m20)
                                             AS t02_symbol_code_m20,
                                         MAX (t02_cash_settle_date)
                                             AS cash_settle_date,
                                         MAX (t02_holding_settle_date)
                                             AS holding_settle_date,
                                         MAX (t02_inst_id_m02)
                                             AS t02_inst_id_m02,
                                         SUM (t02_holding_net_adjst)
                                             AS t02_holding_net_adjst
                                    FROM (SELECT t02_inst_id_m02,
                                                 t02_customer_id_u01,
                                                 t02_last_db_seq_id,
                                                 t02_exchange_code_m01,
                                                 t02_trd_acnt_id_u07,
                                                 t02_side,
                                                 t02_symbol_code_m20,
                                                 t02_symbol_id_m20,
                                                 t02_holding_settle_date,
                                                 t02_cash_settle_date,
                                                 t02_custodian_id_m26,
                                                 t02_create_date,
                                                 t02_exg_commission,
                                                 t02_broker_commission,
                                                 t02_exchange_tax,
                                                 t02_broker_tax,
                                                 t02_last_price,
                                                 t02_cum_qty,
                                                 t02_accrude_interest,
                                                 t02_holding_net_adjst,
                                                 t02_commission_adjst,
                                                   NVL (t02_last_shares, 0)
                                                 - NVL (t02_allocated_qty, 0)
                                                     AS t02_last_shares
                                            FROM t02_transaction_log_order_all)
                                         INNER JOIN (    SELECT TRIM (
                                                                    REGEXP_SUBSTR (
                                                                        ptxnid,
                                                                        '[^,]+',
                                                                        1,
                                                                        LEVEL))
                                                                    txnid
                                                           FROM DUAL
                                                     CONNECT BY REGEXP_SUBSTR (
                                                                    ptxnid,
                                                                    '[^,]+',
                                                                    1,
                                                                    LEVEL)
                                                                    IS NOT NULL) txnids
                                             ON t02_last_db_seq_id =
                                                    txnids.txnid
                                         INNER JOIN m20_symbol m20
                                             ON t02_symbol_id_m20 = m20.m20_id
                                GROUP BY t02_trd_acnt_id_u07,
                                         t02_symbol_id_m20,
                                         t02_create_date,
                                         t02_side,
                                         t02_custodian_id_m26) t02
                         WHERE (l_weight * t02.t02_holding_net_adjst) >= 1) t02
                       INNER JOIN u07_trading_account u07
                           ON t02.u07_id = u07.u07_id
                       INNER JOIN u01_customer u01
                           ON u01.u01_id = u07.u07_customer_id_u01
                       INNER JOIN u06_cash_account u06
                           ON u07.u07_cash_account_id_u06 = u06.u06_id
                       INNER JOIN m20_symbol m20
                           ON m20.m20_id = t02.t02_symbol_id_m20
                       INNER JOIN m26_executing_broker m26
                           ON t02.t02_custodian_id_m26 = m26.m26_id;
        ELSE
        OPEN p_view FOR
            SELECT u01.u01_id,
                   u01.u01_customer_no,
                   u01.u01_display_name,
                   u07.u07_id,
                   u07.u07_display_name,
                   u06.u06_id,
                   t02.t02_symbol_id_m20,
                   t02.t02_symbol_code_m20,
                   t02.t02_side,
                   t02.order_side,
                   t02.allocated_qty,
                   actual_qty,
                   t02.t02_last_price,
                   allocated_qty * t02_last_price AS order_value,
                   exchange_tax,
                   broker_tax,
                   exchange_tax + broker_tax AS total_tax,
                   broker_commission,
                   exg_commission,
                   avg_commission,
                     (allocated_qty * t02_last_price)
                   + (avg_commission + exchange_tax + broker_tax)
                       net_value,
                   u06.u06_balance,
                   u24_net_holding,
                   t02.t02_create_date,
                   m26.m26_id,
                   m26_sid,
                   m26.m26_name AS custodian,
                   t02.exchange_code,
                   t02.cash_settle_date,
                   t02.holding_settle_date,
                   t02_inst_id_m02,
                   m20.m20_lot_size,
                   t02.t02_last_shares,
                   NVL (m20_price_ratio, 1) AS price_ratio,
                   weight_per
              FROM (SELECT u07_id,
                           t02.t02_symbol_id_m20,
                           t02.t02_symbol_code_m20,
                           t02.t02_side,
                           CASE
                               WHEN t02.t02_side = 1 THEN 'Buy'
                               WHEN t02.t02_side = 2 THEN 'Sell'
                               ELSE 'Sub'
                           END
                               AS order_side,
                               t02.t02_holding_net_adjst AS actual_qty,
                           DECODE (
                               proundqty,
                                   1,   weight * t02.t02_holding_net_adjst
                                      - MOD (
                                              weight
                                            * t02.t02_holding_net_adjst,
                                            lot_size),
                                   FLOOR (weight * t02.t02_holding_net_adjst))
                               allocated_qty,
                           (weight * 100) || '%' AS weight_per,
                           ROUND (
                               t02.t02_exchange_tax / COUNT (u07_id) OVER (),
                               2)
                               AS exchange_tax,
                           ROUND (
                               t02.t02_broker_tax / COUNT (u07_id) OVER (),
                               2)
                               AS broker_tax,
                           ROUND (
                                 t02.t02_broker_commission
                               / COUNT (u07_id) OVER (),
                               2)
                               AS broker_commission,
                           ROUND (
                               t02_exg_commission / COUNT (u07_id) OVER (),
                               2)
                               AS exg_commission,
                           ROUND (
                               t02_commission_adjst / COUNT (u07_id) OVER (),
                               2)
                               AS avg_commission,
                           t02.t02_create_date,
                           u24_net_holding,
                           t02.cash_settle_date,
                           t02.holding_settle_date,
                           t02.exchange_code,
                           t02.t02_inst_id_m02,
                           t02.t02_last_shares,
                           t02.t02_last_price,
                           t02.t02_custodian_id_m26
                      FROM (SELECT u07.u07_id,
                                   u24.u24_net_holding,
                                   ( (ROUND (
                                            u24_net_holding
                                          / total.total_holding,
                                          2)))
                                       AS weight,
                                   m20.m20_lot_size AS lot_size,
                                   u24.u24_symbol_id_m20
                              FROM u07_trading_account u07
                                   INNER JOIN u24_holdings u24
                                       ON u07.u07_id =
                                              u24.u24_trading_acnt_id_u07
                                   INNER JOIN (    SELECT TRIM (
                                                              REGEXP_SUBSTR (
                                                                  ptradingacc,
                                                                  '[^,]+',
                                                                  1,
                                                                  LEVEL))
                                                              trd_acc_id
                                                     FROM DUAL
                                               CONNECT BY REGEXP_SUBSTR (
                                                              ptradingacc,
                                                              '[^,]+',
                                                              1,
                                                              LEVEL)
                                                              IS NOT NULL) trdids
                                       ON u07.u07_id = trdids.trd_acc_id
                                   INNER JOIN m20_symbol m20
                                       ON m20.m20_id = u24.u24_symbol_id_m20
                                   INNER JOIN (  SELECT u24.u24_symbol_id_m20,
                                                        SUM (u24_net_holding)
                                                            AS total_holding
                                                   FROM u07_trading_account u07
                                                        INNER JOIN u24_holdings u24
                                                            ON u07.u07_id =
                                                                   u24.u24_trading_acnt_id_u07
                                                        INNER JOIN (    SELECT TRIM (
                                                                                   REGEXP_SUBSTR (
                                                                                       ptradingacc,
                                                                                       '[^,]+',
                                                                                       1,
                                                                                       LEVEL))
                                                                                   trd_acc_id
                                                                          FROM DUAL
                                                                    CONNECT BY REGEXP_SUBSTR (
                                                                                   ptradingacc,
                                                                                   '[^,]+',
                                                                                   1,
                                                                                   LEVEL)
                                                                                   IS NOT NULL) trdids
                                                            ON u07.u07_id =
                                                                   trdids.trd_acc_id
                                                  WHERE u24.u24_symbol_id_m20 =
                                                            psymbol
                                               GROUP BY u24.u24_symbol_id_m20) total
                                       ON u24.u24_symbol_id_m20 =
                                              total.u24_symbol_id_m20
                             WHERE u24.u24_symbol_id_m20 = psymbol) tbl,
                           (  SELECT t02_symbol_id_m20,
                                     t02_trd_acnt_id_u07,
                                     t02_side,
                                     CASE
                                         WHEN t02_side = 1 THEN 'Buy'
                                         WHEN t02_side = 2 THEN 'Sell'
                                         ELSE 'Sub'
                                     END
                                         order_side,
                                     SUM (t02_last_shares) AS t02_last_shares,
                                     ROUND (
                                           SUM (
                                               t02_last_price * t02_last_shares)
                                         / SUM (t02_last_shares),
                                         2)
                                         AS t02_last_price,
                                     SUM (t02_exchange_tax) AS t02_exchange_tax,
                                     SUM (t02_broker_tax) AS t02_broker_tax,
                                     SUM (t02_broker_commission)
                                         AS t02_broker_commission,
                                     SUM (t02_exg_commission)
                                         AS t02_exg_commission,
                                     SUM (t02_commission_adjst)
                                         AS t02_commission_adjst,
                                     t02_create_date,
                                     t02_custodian_id_m26,
                                     MAX (t02_exchange_code_m01)
                                         AS exchange_code,
                                     MAX (t02_symbol_code_m20)
                                         AS t02_symbol_code_m20,
                                     MAX (t02_cash_settle_date)
                                         AS cash_settle_date,
                                     MAX (t02_holding_settle_date)
                                         AS holding_settle_date,
                                     MAX (t02_inst_id_m02) AS t02_inst_id_m02,
                                     SUM (t02_holding_net_adjst) AS t02_holding_net_adjst
                                FROM     t02_transaction_log_order_all
                                     INNER JOIN
                                         (    SELECT TRIM (REGEXP_SUBSTR (ptxnid,
                                                                          '[^,]+',
                                                                          1,
                                                                          LEVEL))
                                                         txnid
                                                FROM DUAL
                                          CONNECT BY REGEXP_SUBSTR (ptxnid,
                                                                    '[^,]+',
                                                                    1,
                                                                    LEVEL)
                                                         IS NOT NULL) txnids
                                     ON t02_last_db_seq_id = txnids.txnid
                            GROUP BY t02_trd_acnt_id_u07,
                                     t02_symbol_id_m20,
                                     t02_create_date,
                                     t02_side,
                                     t02_custodian_id_m26) t02
                         WHERE (weight * t02.t02_holding_net_adjst) >= 1) t02
                   INNER JOIN u07_trading_account u07
                       ON t02.u07_id = u07.u07_id
                   INNER JOIN u01_customer u01
                       ON u01.u01_id = u07.u07_customer_id_u01
                   INNER JOIN u06_cash_account u06
                       ON u07.u07_cash_account_id_u06 = u06.u06_id
                   INNER JOIN m20_symbol m20
                       ON m20.m20_id = t02.t02_symbol_id_m20
                   INNER JOIN m26_executing_broker m26
                       ON t02.t02_custodian_id_m26 = m26.m26_id;
    END IF;
    END IF;

    --Merge & Allocate Manual
    IF paction = 1 AND pmethod = 2
    THEN
        OPEN p_view FOR
            SELECT u01.u01_id,
                   u01.u01_customer_no,
                   u01.u01_display_name,
                   u07.u07_id,
                   u07.u07_display_name,
                   u06.u06_id,
                   t02.t02_symbol_id_m20,
                   t02.t02_symbol_code_m20,
                   t02.t02_side,
                   t02.order_side,
                   t02.allocated_qty,
                   actual_qty,
                   t02.t02_last_price,
                   allocated_qty * t02_last_price AS order_value,
                   exchange_tax,
                   broker_tax,
                   exchange_tax + broker_tax AS total_tax,
                   broker_commission,
                   exg_commission,
                   avg_commission,
                   0 AS net_value,
                   u06.u06_balance,
                   u24_net_holding,
                   t02.t02_create_date,
                   m26.m26_id,
                   m26_sid,
                   m26.m26_name AS custodian,
                   t02.exchange_code,
                   t02.cash_settle_date,
                   t02.holding_settle_date,
                   t02_inst_id_m02,
                   m20.m20_lot_size,
                   t02.t02_last_shares,
                   NVL (m20_price_ratio, 1) AS price_ratio
              FROM (SELECT u07_id,
                           t02.t02_symbol_id_m20,
                           t02.t02_symbol_code_m20,
                           t02.t02_side,
                           CASE
                               WHEN t02.t02_side = 1 THEN 'Buy'
                               WHEN t02.t02_side = 2 THEN 'Sell'
                               ELSE 'Sub'
                           END
                               order_side,
                           0 allocated_qty,
                           t02.t02_holding_net_adjst AS actual_qty,
                           ROUND (
                               t02.t02_exchange_tax / COUNT (u07_id) OVER (),
                               2)
                               AS exchange_tax,
                           ROUND (
                               t02.t02_broker_tax / COUNT (u07_id) OVER (),
                               2)
                               AS broker_tax,
                           ROUND (
                                 t02.t02_broker_commission
                               / COUNT (u07_id) OVER (),
                               2)
                               AS broker_commission,
                           ROUND (
                               t02_exg_commission / COUNT (u07_id) OVER (),
                               2)
                               AS exg_commission,
                           ROUND (
                               t02_commission_adjst / COUNT (u07_id) OVER (),
                               2)
                               AS avg_commission,
                           t02.t02_create_date,
                           t02.cash_settle_date,
                           t02.holding_settle_date,
                           t02.exchange_code,
                           t02.t02_inst_id_m02,
                           t02.t02_last_shares,
                           t02.t02_last_price,
                           t02.t02_custodian_id_m26
                      FROM (  SELECT t02_symbol_id_m20,
                                     t02_trd_acnt_id_u07,
                                     t02_side,
                                     CASE
                                         WHEN t02_side = 1 THEN 'Buy'
                                         WHEN t02_side = 2 THEN 'Sell'
                                         ELSE 'Sub'
                                     END
                                         order_side,
                                     SUM (t02_last_shares) AS t02_last_shares,
                                     ROUND (
                                           SUM (
                                               t02_last_price * t02_last_shares)
                                         / SUM (t02_last_shares),
                                         2)
                                         AS t02_last_price,
                                     SUM (t02_exchange_tax) AS t02_exchange_tax,
                                     SUM (t02_broker_tax) AS t02_broker_tax,
                                     SUM (t02_broker_commission)
                                         AS t02_broker_commission,
                                     SUM (t02_exg_commission)
                                         AS t02_exg_commission,
                                     SUM (t02_commission_adjst)
                                         AS t02_commission_adjst,
                                     t02_create_date,
                                     t02_custodian_id_m26,
                                     MAX (t02_exchange_code_m01)
                                         AS exchange_code,
                                     MAX (t02_symbol_code_m20)
                                         AS t02_symbol_code_m20,
                                     MAX (t02_cash_settle_date)
                                         AS cash_settle_date,
                                     MAX (t02_holding_settle_date)
                                         AS holding_settle_date,
                                     MAX (t02_inst_id_m02) AS t02_inst_id_m02,
                                     SUM (t02_holding_net_adjst)
                                         AS t02_holding_net_adjst
                                FROM     t02_transaction_log_order_all
                                     INNER JOIN
                                         (    SELECT TRIM (REGEXP_SUBSTR (ptxnid,
                                                                          '[^,]+',
                                                                          1,
                                                                          LEVEL))
                                                         txnid
                                                FROM DUAL
                                          CONNECT BY REGEXP_SUBSTR (ptxnid,
                                                                    '[^,]+',
                                                                    1,
                                                                    LEVEL)
                                                         IS NOT NULL) txnids
                                     ON t02_last_db_seq_id = txnids.txnid
                            GROUP BY t02_trd_acnt_id_u07,
                                     t02_symbol_id_m20,
                                     t02_create_date,
                                     t02_side,
                                     t02_custodian_id_m26) t02,
                           (    SELECT TRIM (REGEXP_SUBSTR (ptradingacc,
                                                            '[^,]+',
                                                            1,
                                                            LEVEL))
                                           u07_id
                                  FROM DUAL
                            CONNECT BY REGEXP_SUBSTR (ptradingacc,
                                                      '[^,]+',
                                                      1,
                                                      LEVEL)
                                           IS NOT NULL) custids) t02
                   INNER JOIN u07_trading_account u07
                       ON t02.u07_id = u07.u07_id
                   INNER JOIN u01_customer u01
                       ON u01.u01_id = u07.u07_customer_id_u01
                   INNER JOIN u06_cash_account u06
                       ON u07.u07_cash_account_id_u06 = u06.u06_id
                   INNER JOIN m26_executing_broker m26
                       ON t02.t02_custodian_id_m26 = m26.m26_id
                   INNER JOIN m20_symbol m20
                       ON m20.m20_id = t02.t02_symbol_id_m20
                   LEFT JOIN u24_holdings u24
                       ON     u24.u24_trading_acnt_id_u07 = u07.u07_id
                          AND u24.u24_symbol_id_m20 = t02.t02_symbol_id_m20
                          AND u24.u24_exchange_code_m01 = t02.exchange_code
                          AND u24.u24_custodian_id_m26 =
                                  t02.t02_custodian_id_m26;
    END IF;
END;
/