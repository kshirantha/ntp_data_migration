/* Formatted on 02-Sep-2019 16:19:28 (QP5 v5.276) */
CREATE OR REPLACE PROCEDURE dfn_ntp.sp_trade_commission_report (
    p_view                 OUT SYS_REFCURSOR,
    prows                  OUT NUMBER,
    p_cash_account_id   IN     NUMBER,
    psortby             IN     VARCHAR2,
    pfromdate           IN     DATE,
    ptodate             IN     DATE,
    pfromrownumber             NUMBER DEFAULT NULL,
    ptorownumber               NUMBER DEFAULT NULL)
IS
    l_qry   VARCHAR2 (10000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           'SELECT total_buy_trades,
               total_sell_trades,
               total_trade_volume,
               default_commission AS gross_commission,
               discount_amount,
               exchange_commission,
               commission         AS net_commission
        FROM (
                 SELECT SUM(
                                CASE
                                    WHEN T02_TXN_CODE IN (''REVBUY'', ''STLBUY'')
                                        THEN
                                        trade_value
                                    END)
                                                   total_buy_trades,
                        SUM(
                                CASE
                                    WHEN T02_TXN_CODE IN (''REVSEL'', ''STLSEL'')
                                        THEN
                                        trade_value
                                    END)
                                                   total_sell_trades,
                        SUM(commission)         AS commission,
                        SUM(T02_EXG_COMMISSION) AS exchange_commission,
                        SUM(trade_value)        AS total_trade_volume,
                        SUM(default_commission) AS default_commission,
                        SUM(T02_DISCOUNT)       AS discount_amount
                 FROM (SELECT T02_ORDER_NO,
                              T02_TXN_CODE,
                              SUM(T02_COMMISSION_ADJST) AS commission,
                              SUM(T02_EXG_COMMISSION)
                                                        AS T02_EXG_COMMISSION,
                              SUM(T02_ORD_VALUE_ADJST)  AS trade_value,
                              SUM(
                                          T02_COMMISSION_ADJST
                                          + T02_DISCOUNT)
                                                        AS default_commission,
                              SUM(T02_DISCOUNT)
                                                        AS T02_DISCOUNT
                       FROM (SELECT T02_ORDER_NO,
                                 /*Get reverse order amounts minus*/
                                    CASE
                                        WHEN T02_TXN_CODE = ''REVBUY''
                                            OR T02_TXN_CODE = ''REVSEL''
                                            THEN
                                            -1 * ABS(T02_ORD_VALUE_ADJST)
                                        ELSE
                                            ABS(T02_ORD_VALUE_ADJST)
                                        END
                                        AS T02_ORD_VALUE_ADJST,
                                    T02_COMMISSION_ADJST,
                                    T02_EXG_COMMISSION,
                                    T02_EXCHANGE_CODE_M01,
                                    T02_CREATE_DATE,
                                    T02_TXN_CODE,
                                    T02_DISCOUNT
                             FROM T02_TRANSACTION_LOG
                             WHERE T02_CASH_ACNT_ID_U06 =
                                   '
        || p_cash_account_id
        || '
                               AND T02_TXN_CODE IN (''REVBUY'',
                                                    ''REVSEL'',
                                                    ''STLBUY'',
                                                    ''STLSEL'')) a
                       WHERE a.T02_CREATE_DATE BETWEEN TRUNC (TO_DATE('''
        || pfromdate
        || '''))
                                 AND TRUNC(TO_DATE('''
        || ptodate
        || '''))
                                 + .99999
                       GROUP BY T02_ORDER_NO, T02_TXN_CODE) x)';


    s1 :=
        fn_get_sp_data_query (NULL,
                              l_qry,
                              psortby,
                              ptorownumber,
                              pfromrownumber);
    s2 := fn_get_sp_row_count_query (NULL, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/