CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_top_cust_assets_val (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pinstituteid          NUMBER)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           'SELECT *
FROM (SELECT NVL (customer_id, u06_customer_id_u01) AS customer_id,
             NVL (portfolio_value, 0) + NVL (u06_balance, 0) AS asset_value,
             u06_display_name_u01, u06_customer_no_u01
      FROM (SELECT 
                   u07.u07_customer_id_u01 AS customer_id,
                   SUM (
                         NVL (s_price.market_price, 0)
                       * m20.m20_lot_size
                       * (  NVL (u24.u24_net_holding, 0)
                          - DECODE (m125.m125_allow_sell_unsettle_hold,
                                    1, 0,
                                    NVL (u24.u24_receivable_holding, 0))
                          - NVL (u24.u24_manual_block, 0)
                          - NVL (u24.u24_pledge_qty, 0))
                       * get_exchange_rate (u06.u06_institute_id_m02,
                                            m20.m20_currency_code_m03,
                                            u06.u06_currency_code_m03,
                                            ''R'')) AS portfolio_value
            FROM u24_holdings u24
                 JOIN u07_trading_account u07
                     ON     u24.u24_trading_acnt_id_u07 = u07.u07_id
                        AND u07.u07_institute_id_m02 =
                            '
        || pinstituteid
        || '
                 JOIN u06_cash_account u06
                     ON u07.u07_cash_account_id_u06 = u06.u06_id
                 JOIN m20_symbol m20 ON u24.u24_symbol_id_m20 = m20.m20_id
                 LEFT JOIN vw_symbol_prices s_price
                     ON u24.u24_symbol_id_m20 = s_price.symbol_id
                 LEFT JOIN m125_exchange_instrument_type m125
                     ON     m125.m125_instrument_type_id_v09 =
                            m20.m20_instrument_type_id_v09
                        AND m125.m125_exchange_id_m01 =
                            m20.m20_exchange_id_m01
            GROUP BY u07.u07_customer_id_u01) a
           FULL JOIN
           (SELECT u06_customer_id_u01,
                   u06_display_name_u01,
                   u06_customer_no_u01
                   SUM (
                       CASE
                           WHEN u06.u06_currency_code_m03 != ''SAR''
                           THEN
                                 u06_balance
                               * get_exchange_rate (
                                     u06.u06_institute_id_m02,
                                     u06.u06_currency_code_m03,
                                     ''SAR'')
                           ELSE
                               u06_balance
                       END) AS u06_balance
            FROM u06_cash_account u06
            WHERE u06.u06_institute_id_m02 = '
        || pinstituteid
        || '
            GROUP BY u06.u06_customer_id_u01, u06_display_name_u01, u06_customer_no_u01)
               ON u06_customer_id_u01 = customer_id
      ORDER BY asset_value DESC)
WHERE ROWNUM <= 10';

    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              psortby,
                              ptorownumber,
                              pfromrownumber);
    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2
        INTO prows;
END;
/

