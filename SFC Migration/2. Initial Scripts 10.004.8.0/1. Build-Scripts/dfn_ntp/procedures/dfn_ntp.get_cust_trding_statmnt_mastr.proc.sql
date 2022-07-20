CREATE OR REPLACE PROCEDURE dfn_ntp.get_cust_trding_statmnt_mastr (
    p_view              OUT SYS_REFCURSOR,
    prows               OUT NUMBER,
    pcustomerid             NUMBER,
    pfromdate               DATE,
    ptodate                 DATE,
    ptradingaccountid       NUMBER)
IS
BEGIN
    OPEN p_view FOR
          SELECT ptradingaccountid AS trading_account_no,
                 CASE t01.t01_side WHEN 1 THEN 'Buy' WHEN 2 THEN 'Sell' END
                     AS order_side_description,
                 t01.t01_ord_no,
                 ROUND (t01_avg_price, 2) AS t01_avgpx,
                 t01_date,
                 t01_symbol_code_m20,
                 t01_exchange_code_m01,
                 t01_cum_quantity AS t01_orderqty,
                 ROUND (t01.t01_ord_value, 2) AS t01_ordvalue,
                 m20.m20_short_description AS stockname,
                 t01.t01_settle_currency,
                 NVL (m20.m20_long_description, t01.t01_symbol_id_m20)
                     long_description,
                 CASE WHEN t01.t01_side = 1 THEN 0 ELSE t01.t01_gainloss END
                     AS gainloss,
                 m20.m20_instrument_type_id_v09,
                 m20.m20_instrument_type_code_v09,
                 t01_cum_commission AS commission
            FROM t01_order_all t01
                 JOIN m20_symbol m20
                     ON t01.t01_symbol_id_m20 = m20.m20_id
                 JOIN u07_trading_account u07
                     ON t01.t01_trading_acc_id_u07 = u07.u07_id
           WHERE     t01_customer_id_u01 IN
                         (SELECT u01_id
                            FROM u01_customer
                           WHERE u01_master_account_id_u01 = pcustomerid)
                 AND t01_date BETWEEN TRUNC (pfromdate)
                                  AND TRUNC (t01_date) + 0.99999
                 AND t01_status_id_v30 IN ('1', '2', 'q', 'r')
                 AND t01.t01_trade_process_stat_id_v01 = 25
                 AND t01.t01_cum_quantity > 0
        --  AND u06_routing_ac_type = 2 check this
        ORDER BY t01_date, t01_ord_no;
END;
/
