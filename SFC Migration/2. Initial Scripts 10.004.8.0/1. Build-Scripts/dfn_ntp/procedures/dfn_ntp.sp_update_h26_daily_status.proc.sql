/* Formatted on 10-Aug-2020 22:10:27 (QP5 v5.276) */
CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_h26_daily_status (
    p_date   IN DATE)
IS
BEGIN
    INSERT INTO h26_daily_status a (a.h26_id,
                                    a.h26_date,
                                    a.h26_exchange,
                                    a.h26_buy,
                                    a.h26_sell,
                                    a.h26_broker_comm,
                                    a.h26_total_comm,
                                    a.h26_no_of_trades,
                                    a.h26_exg_turnover,
                                    a.h26_exg_no_of_trades,
                                    a.h26_no_of_orders,
                                    a.h26_no_of_cust_traded,
                                    a.h26_institution_id_m02
                                   )
        (SELECT seq_h26_id.NEXTVAL,
                TRUNC (p_date) AS trimdate,
                exg.exchange,
                NVL (t02.buy, 0) buy,
                NVL (t02.sell, 0) sell,
                NVL (t02.t02_broker_commission, 0) broker_commission,
                NVL (t02.total_commission, 0) total_commission,
                NVL (t02.no_of_trades, 0) no_of_trades,
                NVL (exg.exg_turnover, 0) exg_turnover,
                NVL (exg.exg_no_of_trades, 0) exg_no_of_trades,
                NVL (t01.no_of_orders, 0) no_of_orders,
                NVL (t02.no_of_trd_cust, 0) no_of_trd_cust,
                t01_institution_id_m02
           FROM (SELECT exchange,
                        turnover AS exg_turnover,
                        nooftrades AS exg_no_of_trades
                   FROM dfn_price.esp_exchangemaster) exg,
                (SELECT   t02_exchange_code_m01,
                          t02_inst_id_m02,
                          SUM (t02_broker_commission) AS t02_broker_commission,
                          SUM (total_commission) AS total_commission,
                          SUM (
                              CASE t02_txn_code
                                  WHEN 'STLBUY' THEN t02_amnt_in_txn_currency
                                  ELSE 0
                              END)
                              AS buy,
                          SUM (
                              CASE t02_txn_code
                                  WHEN 'STLSEL' THEN t02_amnt_in_txn_currency
                                  ELSE 0
                              END)
                              AS sell,
                          COUNT (*) AS no_of_trades,
                          COUNT (DISTINCT (t02_customer_id_u01))
                              AS no_of_trd_cust
                     FROM (SELECT ABS (a.t02_amnt_in_txn_currency)
                                      AS t02_amnt_in_txn_currency,
                                  a.t02_txn_code,
                                  a.t02_create_date,
                                  a.t02_cash_settle_date,
                                  a.t02_create_datetime,
                                  (t02_commission_adjst - t02_exg_commission)
                                      AS t02_broker_commission,
                                  (a.t02_commission_adjst) AS total_commission,
                                  a.t02_exchange_code_m01,
                                  t02_customer_id_u01,
                                  a.t02_inst_id_m02
                             FROM t02_transaction_log_order a
                            WHERE     t02_create_date = TRUNC (p_date)
                                  AND t02_ord_status_v30 NOT IN ('h')) a
                 GROUP BY TRUNC (t02_create_date),
                          t02_exchange_code_m01,
                          t02_inst_id_m02) t02,
                (SELECT   t01.t01_exchange_code_m01,
                          t01.t01_institution_id_m02,
                          COUNT (DISTINCT (t01.t01_ord_no)) AS no_of_orders
                     FROM t01_order t01
                    WHERE t01.t01_date = TRUNC (p_date)
                 GROUP BY t01.t01_exchange_code_m01, t01_institution_id_m02)
                t01
          WHERE     exg.exchange = t02.t02_exchange_code_m01(+)
                AND exg.exchange = t01.t01_exchange_code_m01(+)
                AND t02_inst_id_m02 = t01_institution_id_m02);
END;
/