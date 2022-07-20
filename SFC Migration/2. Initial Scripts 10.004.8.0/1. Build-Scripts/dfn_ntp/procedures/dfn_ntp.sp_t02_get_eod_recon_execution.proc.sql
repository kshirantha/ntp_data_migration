CREATE OR REPLACE PROCEDURE dfn_ntp.sp_t02_get_eod_recon_execution (
    p_view          OUT SYS_REFCURSOR,
    prows           OUT NUMBER,
    p_date       IN     t02_transaction_log.t02_create_date%TYPE,
    p_exchange   IN     t02_transaction_log.t02_exchange_code_m01%TYPE,
    p_inst_id    IN     t02_transaction_log.t02_inst_id_m02%TYPE)
IS
    l_broker_id   NUMBER;
BEGIN
    SELECT a.m150_id
      INTO l_broker_id
      FROM m150_broker a
     WHERE a.m150_primary_institute_id_m02 = p_inst_id;


    OPEN p_view FOR
        SELECT t02.t02_create_date,
               t02.t02_create_datetime,
               t02.t02_exchange_code_m01,
               t02.t02_order_exec_id,
               t02.t02_cliordid_t01,
               t02.t02_order_no,
               t02.t02_symbol_code_m20,
               t02.t02_customer_no,
               t02.t02_customer_id_u01,
               u07.u07_display_name_u06,
               u07.u07_exchange_account_no,
               CASE
                   WHEN t02.t02_side = 1 THEN 'Bought'
                   WHEN t02.t02_side = 2 THEN 'Sold'
               END
                   AS side,
               t02.t02_last_shares,
               t02.t02_leaves_qty,
               t02.t02_ordqty,
               t02.t02_last_price,
               t02.t02_last_shares * t02.t02_last_price AS VALUE,
               t01.t01_ord_net_settle,
               t01.t01_commission,
               t01.t01_status_id_v30,
               NVL (t02_exg_ord_id, t01.t01_exchange_ord_id)
                   AS t02_exg_ord_id,
               CASE
                   WHEN t01.t01_tif_id_v10 = 0 THEN 'Day'
                   WHEN t01.t01_tif_id_v10 = 1 THEN 'Good Till Cancel'
                   WHEN t01.t01_tif_id_v10 = 2 THEN 'At the Opening'
                   WHEN t01.t01_tif_id_v10 = 3 THEN 'Immediate or Cancel'
                   WHEN t01.t01_tif_id_v10 = 4 THEN 'Fill or Kill'
                   WHEN t01.t01_tif_id_v10 = 5 THEN 'Good Till Crossing'
                   WHEN t01.t01_tif_id_v10 = 6 THEN 'Good Till Date'
               END
                   AS tif,
               t01.t01_tif_id_v10
          FROM t02_transaction_log t02
               INNER JOIN u07_trading_account u07
                   ON t02.t02_trd_acnt_id_u07 = u07.u07_id
               INNER JOIN t01_order t01
                   ON t02.t02_cliordid_t01 = t01.t01_cl_ord_id
               INNER JOIN m02_institute m02
                   ON t02.t02_inst_id_m02 = m02.m02_id
         WHERE     m02.m02_broker_id_m150 = l_broker_id
               AND t02.t02_exchange_code_m01 = p_exchange
               AND t02.t02_create_date BETWEEN TRUNC (p_date)
                                           AND TRUNC (p_date) + 0.99999
               AND t02.t02_ord_status_v30 NOT IN ('M', 'O', '8', 'Q', 'P')
               AND t02.t02_exg_ord_id IS NOT NULL
               AND t02.t02_order_exec_id IS NOT NULL;
----  AND t02.t02_last_shares > 0
--  AND t02.t02_cash_acnt_id_u06 = 3226; -- for testing purpose
END;
/
