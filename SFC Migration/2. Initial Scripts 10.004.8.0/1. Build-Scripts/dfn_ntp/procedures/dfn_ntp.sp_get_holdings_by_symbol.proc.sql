CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_holdings_by_symbol (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pdate                 DATE DEFAULT SYSDATE,
    pinstitute            NUMBER)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;

    IF TRUNC (pdate) = TRUNC (SYSDATE)
    THEN
        l_qry :=
               'SELECT u01.u01_id AS u01_id,
                       MAX (u01.u01_customer_no) AS u01_customer_no,
                       MAX (u01.u01_display_name) AS custname,
                       MAX (u01.u01_institute_id_m02) AS u01_institute_id_m02,
                       TRUNC (SYSDATE) AS holding_date,
                       MAX (m20.m20_symbol_code) AS symbol,
                       u24.u24_exchange_code_m01 AS exchange_code,
                       MAX(u07.u07_id) AS u07_id,
                       u24.u24_currency_code_m03 AS currency_code,
                       SUM (
                             u24.u24_net_holding
                           + u24.u24_payable_holding
                           - u24.u24_receivable_holding
                           - u24.u24_manual_block)
                           AS qty,
                       MAX (esp.market_price) AS close_price,
                       SUM (
                             esp.market_price
                           * (  u24.u24_net_holding
                              + u24.u24_payable_holding
                              - u24.u24_receivable_holding
                              - u24.u24_manual_block)
                           * m20.m20_lot_size
                           * m20.m20_price_ratio)
                           AS market_value
                  FROM u24_holdings u24
                       JOIN u07_trading_account u07
                           ON     u24.u24_trading_acnt_id_u07 = u07.u07_id
                              AND (   u24.u24_net_holding <> 0
                                   OR u24.u24_payable_holding <> 0
                                   OR u24.u24_receivable_holding <> 0
                                   OR u24.u24_short_holdings <> 0
                                   OR u24.u24_manual_block <> 0)
                       JOIN u01_customer u01 ON u07.u07_customer_id_u01 = u01.u01_id
                       JOIN m20_symbol m20 ON u24.u24_symbol_id_m20 = m20.m20_id
                       LEFT JOIN vw_esp_market_price_today esp
                           ON     m20.m20_exchange_code_m01 = esp.exchangecode
                              AND m20.m20_symbol_code = esp.symbol
                 WHERE u01.u01_institute_id_m02 = '
            || pinstitute
            || '
                GROUP BY m20.m20_id,
                         u24.u24_exchange_code_m01,
                         u24.u24_currency_code_m03,
                         u01.u01_id'
			|| ' HAVING SUM (
                             u24.u24_net_holding
                           + u24.u24_payable_holding
                           - u24.u24_receivable_holding
                           - u24.u24_manual_block) > 0';
    ELSE
        l_qry :=
               'SELECT u01.u01_id AS u01_id,
                       MAX (u01.u01_customer_no) AS u01_customer_no,
                       MAX (u01.u01_display_name) AS custname,
                       MAX (u01.u01_institute_id_m02) AS u01_institute_id_m02,
                       h01.h01_date AS holding_date,
                       MAX (m20.m20_symbol_code) AS symbol,
                       h01.h01_exchange_code_m01 AS exchange_code,
                       MAX(u07.u07_id) AS u07_id,
                       h01.h01_currency_code_m03 AS currency_code,
                       SUM (
                             h01.h01_net_holding
                           + h01.h01_payable_holding
                           - h01.h01_receivable_holding
                           - h01.h01_manual_block)
                           AS qty,
                       MAX (esp.market_price) AS close_price,
                       SUM (
                             esp.market_price
                           * (  h01.h01_net_holding
                              + h01.h01_payable_holding
                              - h01.h01_receivable_holding
                              - h01.h01_manual_block)
                           * m20.m20_lot_size
                           * m20.m20_price_ratio)
                           AS market_value
                  FROM vw_h01_holding_summary h01
                       JOIN u07_trading_account u07
                           ON     h01.h01_trading_acnt_id_u07 = u07.u07_id
                              AND (   h01.h01_net_holding <> 0
                                   OR h01.h01_payable_holding <> 0
                                   OR h01.h01_receivable_holding <> 0
                                   OR h01.h01_short_holdings <> 0
                                   OR h01.h01_manual_block <> 0)
                       JOIN u01_customer u01 ON u07.u07_customer_id_u01 = u01.u01_id
                       JOIN m20_symbol m20 ON h01.h01_symbol_id_m20 = m20.m20_id
                       LEFT JOIN vw_esp_market_price_history esp
                           ON     m20.m20_exchange_code_m01 = esp.exchangecode
                              AND m20.m20_symbol_code = esp.symbol
                 WHERE     h01.h01_date = TRUNC(TO_DATE ('''
            || TO_CHAR (pdate, 'DD-MM-YYYY')
            || ''',''DD-MM-YYYY'')) AND u01_institute_id_m02 = '
            || pinstitute
            || ' GROUP BY m20.m20_id,
                         h01.h01_exchange_code_m01,
                         h01.h01_currency_code_m03,
                         u01.u01_id,
                         h01.h01_date'
			|| ' HAVING SUM (
                             h01.h01_net_holding
                           + h01.h01_payable_holding
                           - h01.h01_receivable_holding
                           - h01.h01_manual_block) > 0';
    END IF;


    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              psortby,
                              ptorownumber,
                              pfromrownumber);
    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/