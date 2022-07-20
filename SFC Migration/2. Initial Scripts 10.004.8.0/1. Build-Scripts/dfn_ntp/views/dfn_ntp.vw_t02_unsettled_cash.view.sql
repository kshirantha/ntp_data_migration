CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t02_unsettled_cash
(
    t02_cash_acnt_id_u06,
    t02_cash_settle_date,
    payable_blocked,
    receivable_amount,
    net_recievable,
    old_net_recievable,
    no_of_trades
)
AS
    SELECT   t02_unsettle.t02_cash_acnt_id_u06,
             t02_unsettle.t02_cash_settle_date,
             SUM (t02_unsettle.payable_blocked) AS payable_blocked,
             SUM (t02_unsettle.recievable_amount) AS receivable_amount,
             MAX (u06_net_receivable) AS net_recievable,
             CASE
                 WHEN (  SUM (t02_unsettle.recievable_amount)
                       - SUM (t02_unsettle.payable_blocked)) > 0
                 THEN
                       SUM (t02_unsettle.recievable_amount)
                     - SUM (t02_unsettle.payable_blocked)
                 ELSE
                     0
             END
                 AS old_net_recievable,
             COUNT (*) AS no_of_trades
        FROM (SELECT t02.t02_cash_acnt_id_u06,
                     t02.t02_cash_settle_date,
                     CASE
                         WHEN t02.t02_txn_code = 'STLBUY'
                         THEN
                             ABS (t02.t02_amnt_in_stl_currency)
                         ELSE
                             0
                     END
                         AS payable_blocked,
                     CASE
                         WHEN t02.t02_txn_code = 'STLSEL'
                         THEN
                             ABS (t02.t02_amnt_in_stl_currency)
                         ELSE
                             0
                     END
                         AS recievable_amount
                FROM t02_transaction_log_cash_all t02
               WHERE     (   t02.t02_cash_settle_date > TRUNC (SYSDATE)
                          OR t02.t02_trade_process_stat_id_v01 IN (1, 21))
                     AND t02.t02_txn_code IN ('STLBUY', 'STLSEL')) t02_unsettle
             JOIN u06_cash_account u06 ON t02_cash_acnt_id_u06 = u06.u06_id
    GROUP BY t02_unsettle.t02_cash_acnt_id_u06,
             t02_unsettle.t02_cash_settle_date
    ORDER BY t02_unsettle.t02_cash_settle_date
/