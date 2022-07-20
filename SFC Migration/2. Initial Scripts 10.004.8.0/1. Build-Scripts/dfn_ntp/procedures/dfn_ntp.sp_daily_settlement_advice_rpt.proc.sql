CREATE OR REPLACE PROCEDURE dfn_ntp.sp_daily_settlement_advice_rpt (
    p_view              OUT SYS_REFCURSOR,
    prows               OUT NUMBER,
    p_cash_account_id       NUMBER,
    p_d1                    DATE)
IS
BEGIN
    OPEN p_view FOR
        SELECT opening_balance,
               (  opening_balance
                - ABS (total_buy)
                - ABS (total_cash_out)
                + total_sell
                + total_cash_in)
                   AS utilization_of_settlement,
               utilize_od,
               total_buy,
               total_cash_in,
               total_sell,
               total_cash_out,
               total_sell - ABS (total_buy) AS settlement_as,
               settlementdate
          FROM (  SELECT MAX (opening_balance) AS opening_balance,
                         SUM (utilize_od) AS utilize_od,
                         SUM (total_buy) AS total_buy,
                         SUM (cash_in) AS total_cash_in,
                         SUM (total_sell) AS total_sell,
                         SUM (cash_out) AS total_cash_out,
                         MAX (t02_cash_settle_date) AS settlementdate
                    FROM (SELECT TRUNC (t02_create_date) AS t02_create_date,
                                 NVL (h02.h02_balance, 0) AS opening_balance,
                                 NVL (u06.u06_primary_od_limit, 0)
                                     AS utilize_od,
                                 CASE
                                     WHEN t02_txn_code IN ('STLBUY', 'REVBUY')
                                     THEN
                                         (cash_in + cash_out)
                                     ELSE
                                         0
                                 END
                                     AS total_buy,
                                 CASE
                                     WHEN t02_txn_code IN ('STLSEL', 'REVSEL')
                                     THEN
                                         (cash_in + cash_out)
                                     ELSE
                                         0
                                 END
                                     AS total_sell,
                                 CASE
                                     WHEN t02_txn_code NOT IN
                                              ('STLBUY',
                                               'STLSEL',
                                               'BUYRMV',
                                               'SELRMV',
                                               'RMVBLK',
                                               'CRTBLK',
                                               'REVSEL',
                                               'REVBUY',
                                               'CONOPN',
                                               'CONCLS',
                                               'MKTMKT')
                                     THEN
                                         cash_in
                                     ELSE
                                         0
                                 END
                                     AS cash_in,
                                 CASE
                                     WHEN t02_txn_code NOT IN
                                              ('STLBUY',
                                               'STLSEL',
                                               'BUYRMV',
                                               'SELRMV',
                                               'RMVBLK',
                                               'CRTBLK',
                                               'REVSEL',
                                               'REVBUY',
                                               'CONOPN',
                                               'CONCLS',
                                               'MKTMKT')
                                     THEN
                                         cash_out
                                     ELSE
                                         0
                                 END
                                     AS cash_out,
                                 t02_cash_settle_date
                            FROM (  SELECT t02_create_date,
                                           t02_cash_acnt_id_u06,
                                           t02_txn_code,
                                           MAX (t02_cash_settle_date)
                                               AS t02_cash_settle_date,
                                           SUM (cash_in) cash_in,
                                           SUM (cash_out) cash_out
                                      FROM (SELECT t02_cash_acnt_id_u06,
                                                   t02.t02_txn_code,
                                                   t02.t02_create_date,
                                                   t02.t02_cash_settle_date,
                                                   CASE
                                                       WHEN t02.t02_amnt_in_stl_currency >
                                                                0
                                                       THEN
                                                           NVL (
                                                               t02.t02_amnt_in_stl_currency,
                                                               0)
                                                       ELSE
                                                           0
                                                   END
                                                       AS cash_in,
                                                   CASE
                                                       WHEN t02.t02_amnt_in_stl_currency <
                                                                0
                                                       THEN
                                                           NVL (
                                                               t02.t02_amnt_in_stl_currency,
                                                               0)
                                                       ELSE
                                                           0
                                                   END
                                                       AS cash_out
                                              FROM t02_transaction_log_cash t02
                                             WHERE     t02_cash_acnt_id_u06 =
                                                           p_cash_account_id
                                                   AND t02_create_date BETWEEN TRUNC (
                                                                                   TO_DATE (
                                                                                       p_d1))
                                                                           AND   TRUNC (
                                                                                     TO_DATE (
                                                                                         p_d1))
                                                                               + 0.99999) t02
                                  GROUP BY t02.t02_cash_acnt_id_u06,
                                           t02.t02_txn_code,
                                           t02_create_date) t02,
                                 u06_cash_account u06,
                                 (SELECT h02.h02_cash_account_id_u06,
                                         h02.h02_balance
                                    FROM vw_h02_cash_account_summary h02
                                   WHERE     h02.h02_date =
                                                 TRUNC (TO_DATE (p_d1 - 1))
                                         AND h02_cash_account_id_u06 =
                                                 p_cash_account_id) h02
                           WHERE     u06.u06_id = p_cash_account_id
                                 AND u06.u06_id = t02.t02_cash_acnt_id_u06(+)
                                 AND u06.u06_id =
                                         h02.h02_cash_account_id_u06(+))
                GROUP BY t02_create_date);
END;
/