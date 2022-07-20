CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_settlement_projection (
    p_view       OUT SYS_REFCURSOR,
    prows        OUT NUMBER,
    pt02_u07id       NUMBER,
    pfromdate        DATE DEFAULT SYSDATE,
    ptodate          DATE DEFAULT SYSDATE)
IS
BEGIN
    OPEN p_view FOR
        SELECT SUM (
                   CASE
                       WHEN a.t02_side = 1
                       THEN
                             (a.t02_ord_value_adjst + a.t02_commission_adjst)
                           * -1
                       ELSE
                           (a.t02_ord_value_adjst + a.t02_commission_adjst)
                   END)
                   settlement_amount,
               a.t02_cash_settle_date
          FROM t02_transaction_log a
         WHERE     a.t02_trd_acnt_id_u07 = pt02_u07id
               AND a.t02_update_type IN (1)
               AND t02_amnt_in_stl_currency <> 0
               /*  AND a.t02_ord_status_v30 NOT IN ('M',
                                                  'O',
                                                  '8',
                                                  'Q',
                                                  'P')*/
               AND a.t02_exg_ord_id IS NOT NULL
               AND a.t02_order_exec_id IS NOT NULL
               AND a.t02_cash_settle_date BETWEEN pfromdate
                                              AND ptodate + 0.99999
        GROUP BY a.t02_cash_settle_date
        ORDER BY a.t02_cash_settle_date;
END;
/