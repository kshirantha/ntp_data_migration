CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_cash_details_by_date (
   p_view         OUT SYS_REFCURSOR,
   prows          OUT NUMBER,
   pu07_id     IN     u07_trading_account.u07_id%TYPE DEFAULT NULL,
   pfromdate   IN     DATE DEFAULT SYSDATE,
   ptodate     IN     DATE DEFAULT SYSDATE)
IS
   l_u06_id         u06_cash_account.u06_id%TYPE;
   l_cash_balance   u06_cash_account.u06_balance%TYPE;
BEGIN
 SELECT u07_cash_account_id_u06
      INTO l_u06_id
      FROM u07_trading_account
     WHERE u07_id = pu07_id;  

 SELECT total_cash_balance
     INTO l_cash_balance
     FROM vw_u06_cash_account_base
    WHERE u06_id = l_u06_id;

   OPEN p_view FOR
      SELECT l_cash_balance AS cash_balance,
             SUM (NVL (buy, 0)) AS buy,
             SUM (NVL (sell, 0)) AS sell,
             SUM (NVL (deposits, 0)) AS deposits,
             SUM (NVL (withdrawals, 0)) AS withdrawals,
             SUM (NVL (other, 0)) AS other,
             SUM (NVL (commission, 0)) AS commission,
             SUM (NVL (gainloss, 0)) AS gainloss
        FROM (SELECT h02.h02_net_buy AS buy,
                     h02.h02_net_sell AS sell,
                     h02.h02_deposits AS deposits,
                     h02.h02_withdrawals AS withdrawals,
                     h02.h02_net_charges_refunds AS other,
                     h02.h02_net_commission AS commission,
                     h02.h02_gainloss AS gainloss
                FROM h02_cash_account_summary h02
               WHERE     h02.h02_cash_account_id_u06 = l_u06_id
                     AND h02.h02_date BETWEEN TRUNC (pfromdate)
                                          AND TRUNC (ptodate) + 0.99999
              UNION ALL
              SELECT CASE t02.t02_txn_code
                        WHEN 'STLBUY' THEN t02.t02_amnt_in_stl_currency
                        ELSE 0
                     END
                        AS buy,
                     CASE t02.t02_txn_code
                        WHEN 'STLSEL' THEN t02.t02_amnt_in_stl_currency
                        ELSE 0
                     END
                        AS sell,
                     CASE t02.t02_txn_code
                        WHEN 'DEPOST' THEN t02.t02_amnt_in_stl_currency
                        ELSE 0
                     END
                        AS deposits,
                     CASE t02.t02_txn_code
                        WHEN 'WITHDR' THEN t02.t02_amnt_in_stl_currency
                        ELSE 0
                     END
                        AS withdrawals,
                     CASE
                        WHEN t02.t02_txn_code NOT IN
                                ('STLBUY', 'STLSEL', 'DEPOST', 'WITHDR')
                        THEN
                           t02.t02_amnt_in_stl_currency
                        ELSE
                           0
                     END
                        AS other,
                     t02.t02_commission_adjst * t02.t02_fx_rate AS commission,
                     CASE
                        WHEN t02.t02_txn_code NOT IN ('STLBUY')
                        THEN
                           t02.t02_gainloss
                        ELSE
                           0
                     END
                        AS gainloss
                FROM t02_transaction_log_cash_all t02
                 WHERE     t02.t02_trd_acnt_id_u07 = pu07_id
                     AND t02.t02_create_date BETWEEN TRUNC (SYSDATE)
                                                 AND   TRUNC (SYSDATE)
                                                     + 0.99999
                     AND t02.t02_create_date BETWEEN TRUNC (pfromdate)
                                                 AND   TRUNC (ptodate)
                                                     + 0.99999);

   prows := 1;
END;
/