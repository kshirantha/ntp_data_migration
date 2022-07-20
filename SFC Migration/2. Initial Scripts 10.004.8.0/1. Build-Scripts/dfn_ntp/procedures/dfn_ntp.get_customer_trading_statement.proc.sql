CREATE OR REPLACE PROCEDURE dfn_ntp.get_customer_trading_statement (
    p_view        OUT SYS_REFCURSOR,
    prows         OUT NUMBER,
    pcustomerid       NUMBER,
    pfromdate         DATE,
    ptodate           DATE,
    ptradingacc       NUMBER DEFAULT 0)
IS
BEGIN
    OPEN p_view FOR
          SELECT CASE t01.t01_side WHEN 1 THEN 'Buy' WHEN 2 THEN 'Sell' END
                     AS order_side_description,
                 CASE t01.t01_side
                     WHEN 1 THEN 'Buy AR'
                     WHEN 2 THEN 'Sell AR'
                 END
                     AS order_side_description_lang,
                 t01.t01_ord_no,
                 ROUND (t01.t01_avg_price, 2) AS t01_avgpx,
                 t01.t01_date,
                 t01.t01_symbol_code_m20,
                 t01.t01_exchange_code_m01,
                 t01.t01_cum_quantity AS t01_orderqty,
                 ROUND (t01.t01_ord_value, 2) AS t01_ordvalue,
                 m20.m20_short_description AS stockname,
                 t01.t01_settle_currency,
                 NVL (m20.m20_long_description, t01.t01_symbol_code_m20)
                     long_description,
                 CASE WHEN t01.t01_side = 1 THEN 0 ELSE t01.t01_gainloss END
                     AS gainloss,
                 m20.m20_instrument_type_code_v09,
                 t01_cum_commission AS commission,
                 NVL (m20.m20_long_description_lang, t01.t01_symbol_code_m20)
                     long_description_ar,
                 u07.u07_display_name,
                 NVL (
                     ROUND (
                         CASE
                             WHEN t01.t01_exchange_code_m01 IN
                                      ('DFM',
                                       'ADSM',
                                       'BSE',
                                       'KSE',
                                       'MSM',
                                       'DSM')
                             THEN
                                 CASE
                                     WHEN t01_side = 1
                                     THEN
                                         (  ABS (t01.t01_cum_ord_value)
                                          + t01.t01_exec_brk_commission
                                          + t01.t01_cum_exchange_tax)
                                     ELSE
                                         (  ABS (t01.t01_cum_ord_value)
                                          - t01.t01_exec_brk_commission
                                          - t01.t01_cum_exchange_tax)
                                 END
                             ELSE
                                 CASE
                                     WHEN t01_side = 1
                                     THEN
                                         (  ABS (t01.t01_cum_ord_value)
                                          + t01.t01_exec_brk_commission)
                                     ELSE
                                         (  ABS (t01.t01_cum_ord_value)
                                          - t01.t01_exec_brk_commission)
                                 END
                         END,
                         m03.m03_decimal_places),
                     0)
                     AS custody_settlement
            FROM t01_order_all t01
                 JOIN m20_symbol m20
                     ON t01.t01_symbol_id_m20 = m20.m20_id
                 JOIN u07_trading_account u07
                     ON t01.t01_trading_acc_id_u07 = u07.u07_id
                 JOIN m03_currency m03
                     ON t01.t01_settle_currency = m03.m03_code
           WHERE     t01_customer_id_u01 = pcustomerid           --customer id
                 AND t01_date BETWEEN TRUNC (pfromdate)
                                  AND TRUNC (ptodate) + 0.99999
                 AND t01_status_id_v30 IN ('1', '2', 'q', 'r')
                 AND t01.t01_trade_process_stat_id_v01 = 25
                 AND t01.t01_cum_quantity > 0
                 AND t01.t01_trading_acc_id_u07 = ptradingacc
        ORDER BY t01_date, t01_ord_no;
END;
/
