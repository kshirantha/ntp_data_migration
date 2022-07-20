CREATE OR REPLACE PROCEDURE dfn_ntp.sp_cheuvrex_trade_confimation (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    pu07_id               NUMBER,
    pfromdate             DATE,
    ptodate               DATE,
    pdecimalplaces        NUMBER,
    pbuyrate              NUMBER DEFAULT 1,
    psellrate             NUMBER DEFAULT 1,
    pcommission           NUMBER,
    pcommissionrate       NUMBER)
IS
BEGIN
    OPEN p_view FOR
        SELECT t02_txn_code
                   AS t05_code,
               side,
               fx_rate,
               t02_order_no
                   AS t05_orderno,
               t02_create_date
                   AS t05_date,
               t02_symbol_code_m20
                   AS t05_symbol,
               t02_cash_settle_date
                   AS t05_value_date,
               t02_exchange_code_m01
                   AS t05_exchange,
               m20_reuters_code
                   AS m77_reuters_code,
               m20_isincode
                   AS m77_isincode,
               m20_short_description
                   AS m107_short_description,
               t02_last_shares
                   AS t05_last_shares,
               t02_last_price
                   AS t05_lastpx,
               t02_ord_value_adjst
                   AS t05_amount,
               t02_commission_adjst
                   AS t05_commission,
               net_amount,
               other_charges,
               ROUND ((net_amount / t02_last_shares), pdecimalplaces)
                   AS avg_cost,
               total_tax
                   AS total_vat
        FROM (SELECT MAX (a.t02_txn_code) AS t02_txn_code,
                     CASE
                         WHEN MAX (a.t02_txn_code) = 'STLBUY' THEN 'Buy'
                         ELSE 'Sell'
                     END AS side,
                     CASE
                         WHEN MAX (a.t02_txn_code) = 'STLBUY' THEN pbuyrate
                         ELSE psellrate
                     END AS fx_rate,
                     a.t02_order_no,
                     a.t02_create_date,
                     MAX (a.t02_symbol_code_m20) AS t02_symbol_code_m20,
                     a.t02_cash_settle_date,
                     MAX (a.t02_exchange_code_m01) AS t02_exchange_code_m01,
                     MAX (b.m20_reuters_code) AS m20_reuters_code,
                     MAX (b.m20_isincode) AS m20_isincode,
                     MAX (b.m20_short_description) AS m20_short_description,
                     SUM (a.t02_last_shares) t02_last_shares,
                     ROUND (
                           ABS (SUM (a.t02_ord_value_adjst))
                         / SUM (a.t02_last_shares),
                         pdecimalplaces) AS t02_last_price,
                     SUM (a.t02_ord_value_adjst) t02_ord_value_adjst,
                     CASE (pcommission)
                         WHEN 1
                         THEN
                             SUM (a.t02_commission_adjst)
                         ELSE
                             ABS (
                                   SUM (a.t02_ord_value_adjst)
                                 * (pcommissionrate)
                                 / 100)
                     END AS t02_commission_adjst,
                     CASE
                         WHEN MAX (a.t02_txn_code) = 'STLBUY'
                         THEN
                             CASE
                                 WHEN pcommission = 1
                                 THEN
                                     ROUND (
                                         ((  ABS (
                                                 SUM (a.t02_ord_value_adjst))
                                           + ABS (
                                                 SUM (
                                                       a.t02_broker_tax
                                                     + a.t02_exchange_tax))
                                           + ABS (
                                                 SUM (a.t02_commission_adjst)))),
                                         pdecimalplaces)
                                 ELSE
                                     ROUND (
                                         (  ABS (SUM (a.t02_ord_value_adjst))
                                          + ABS (
                                                SUM (
                                                      a.t02_broker_tax
                                                    + a.t02_exchange_tax))
                                          + -ABS (
                                                   SUM (
                                                       a.t02_ord_value_adjst)
                                                 * (pcommissionrate)
                                                 / 100)),
                                         pdecimalplaces)
                             END
                         WHEN MAX (a.t02_txn_code) = 'STLSEL'
                         THEN
                             CASE
                                 WHEN pcommission = 1
                                 THEN
                                     ROUND (
                                         ((  ABS (
                                                 SUM (a.t02_ord_value_adjst))
                                           - ABS (
                                                 SUM (
                                                       a.t02_broker_tax
                                                     + a.t02_exchange_tax))
                                           - ABS (
                                                 SUM (a.t02_commission_adjst)))),
                                         pdecimalplaces)
                                 ELSE
                                     ROUND (
                                         (  ABS (SUM (a.t02_ord_value_adjst))
                                          - ABS (
                                                SUM (
                                                      a.t02_broker_tax
                                                    + a.t02_exchange_tax))
                                          - ABS (
                                                  SUM (a.t02_ord_value_adjst)
                                                * (pcommissionrate)
                                                / 100)),
                                         pdecimalplaces)
                             END
                     END net_amount,
                     0   AS other_charges,
                     SUM (a.t02_broker_tax + a.t02_exchange_tax) AS total_tax
              FROM t02_transaction_log_order_arc a
                   JOIN m20_symbol b
                       ON     a.t02_symbol_id_m20 = b.m20_id
                          AND a.t02_exchange_code_m01 =
                              b.m20_exchange_code_m01
                   JOIN u07_trading_account u07
                       ON     a.t02_trd_acnt_id_u07 = u07.u07_id
                          -- AND u07.u07_exchange_account_no =
                          --    pexchangeaccnumber
                          AND u07.u07_id = pu07_id
              WHERE a.t02_create_date BETWEEN pfromdate AND ptodate + 0.99999
              GROUP BY a.t02_order_no,
                       a.t02_create_date,
                       a.t02_cash_settle_date) a;
END;
/