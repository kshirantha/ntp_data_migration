CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_cash_details
(
    t02_cash_acnt_id_u06,
    buy_tot,
    sell_tot,
    deposit_tot,
    withdraw_tot
)
AS
      SELECT t02.t02_cash_acnt_id_u06,
             SUM (
                 CASE WHEN action = 'Buy' THEN t02.t02_amnt_in_stl_currency END)
                 AS buy_tot,
             SUM (
                 CASE
                     WHEN action = 'Sell' THEN t02.t02_amnt_in_stl_currency
                 END)
                 AS sell_tot,
             SUM (
                 CASE
                     WHEN action = 'Deposit' THEN t02.t02_amnt_in_stl_currency
                 END)
                 AS deposit_tot,
             SUM (
                 CASE
                     WHEN action = 'Withdraw' THEN t02.t02_amnt_in_stl_currency
                 END)
                 AS withdraw_tot
        FROM vw_t02_cash_txn_log_all t02, m01_exchanges m01
       WHERE     t02.t02_cash_settle_date BETWEEN TRUNC (SYSDATE - 100)
                                              AND TRUNC (SYSDATE) + 0.99999
             AND t02.t02_exchange_id_m01 = m01.m01_id(+)
             AND t02_txn_code NOT IN ('REVBTD', 'REVSTD', 'REVADJ', 'FTB')
             AND (   (    t02_txn_code IN ('STLBUY', 'STLSEL')
                      AND m01.m01_is_local = 1)
                  OR t02.t02_txn_code NOT IN ('STLBUY', 'STLSEL'))
    GROUP BY t02.t02_cash_acnt_id_u06
/
