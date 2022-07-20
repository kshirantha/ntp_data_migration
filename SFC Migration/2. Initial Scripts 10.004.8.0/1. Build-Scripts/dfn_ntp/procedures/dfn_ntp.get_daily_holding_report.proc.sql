CREATE OR REPLACE PROCEDURE dfn_ntp.get_daily_holding_report (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2,
    pfromrownumber        NUMBER,
    ptorownumber          NUMBER,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE,
    ptodate               DATE)
IS
    l_qry    VARCHAR2 (15000);
    l_date   DATE;
    s1       VARCHAR2 (15000);
    s2       VARCHAR2 (15000);
BEGIN
    l_date := pfromdate;

    IF TRUNC (l_date) > TRUNC (SYSDATE)
    THEN
        l_date := SYSDATE;
    END IF;

    IF TRUNC (l_date) = TRUNC (SYSDATE)
    THEN
        l_qry :=
            '
SELECT MAX (u24.u07_display_name) AS u07_display_name,
       MAX (u24.u06_investment_account_no) AS u06_investment_account_no,
       MAX (u24.customer_id) AS u01_id,
       MAX (u24.customer_name) AS u01_display_name,
       MAX (u24.u24_symbol_code_m20) AS m20_symbol_code,
       MAX (u24.short_description) m20_short_description,
       MAX (u24.short_description_lang) AS m20_short_description_lang,
       MAX (u24.m20_isincode) AS m20_isincode,
       SUM (
             u24.u24_net_holding
           + u24.u24_payable_holding
           - u24.u24_receivable_holding
           - u24.u24_manual_block)
           AS own_qty,
       SUM (u24.u24_pledge_qty) AS pledge_qty,
       SUM (
             u24.u24_net_holding
           + u24.u24_payable_holding
           - u24.u24_receivable_holding
           - u24.u24_manual_block
           - u24.u24_pledge_qty)
           AS balance_qty,
       u24.u24_exchange_code_m01 AS t02_exchange_code_m01,
       AVG (ROUND (NVL (u24.market_price, 0), 8)) AS close_price,
       SUM (
           NVL (
                 (  u24.u24_net_holding
                  + u24.u24_payable_holding
                  - u24.u24_receivable_holding
                  - u24.u24_manual_block)
               * NVL (u24.market_price, 0),
               0))
           AS total_value
  FROM vw_u24_holdings_all u24
GROUP BY u24.u24_trading_acnt_id_u07,
         u24.u24_exchange_code_m01,
         u24.u24_symbol_id_m20';
    ELSE
        l_qry :=
               'SELECT u07.u07_display_name,
               u06.u06_investment_account_no,
               u07.u07_customer_id_u01 AS u01_id,
               u07.u07_display_name_u01 AS u01_display_name,
               h01.h01_symbol_code_m20 AS m20_symbol_code,
               m20.m20_short_description,
               m20_short_description_lang,
               m20.m20_isincode,
               h01.own_qty,
               h01.pledge_qty,
               (h01.own_qty - h01.pledge_qty) AS balance_qty,
               h01.h01_exchange_code_m01 AS t02_exchange_code_m01,
               NVL (price.market_price, 0) AS close_price,
               NVL (h01.own_qty * NVL (price.market_price, 0), 0)
                   AS total_value
          FROM (SELECT h01_trading_acnt_id_u07,
                       h01_exchange_code_m01,
                       h01_symbol_id_m20,
                       MAX (h01_symbol_code_m20) AS h01_symbol_code_m20,
                       SUM (
                             h01_net_holding
                           + h01_payable_holding
                           - h01_receivable_holding
                           - h01_manual_block)
                           AS own_qty,
                       SUM (h01_pledge_qty) AS pledge_qty
                  FROM vw_h01_holding_summary
                 WHERE h01_date = TO_DATE ('''
            || TO_CHAR (l_date, 'DD-MM-YYYY')
            || ''',''DD-MM-YYYY'')
                GROUP BY h01_trading_acnt_id_u07,
                         h01_exchange_code_m01,
                         h01_symbol_id_m20) h01
               JOIN u07_trading_account u07
                   ON h01.h01_trading_acnt_id_u07 = u07.u07_id
               JOIN u06_cash_account u06
                   ON u07.u07_cash_account_id_u06 = u06.u06_id
               JOIN m20_symbol m20 ON h01.h01_symbol_id_m20 = m20.m20_id
               JOIN vw_symbol_prices price
                   ON h01.h01_symbol_id_m20 = price.symbol_id';
    END IF;

    IF (psearchcriteria IS NOT NULL)
    THEN
        s1 := ' WHERE ' || psearchcriteria;
        s2 :=
               'SELECT COUNT(*) FROM ('
            || l_qry
            || ') WHERE '
            || psearchcriteria;
    ELSE
        s1 := '';
        s2 := 'SELECT COUNT(*) FROM (' || l_qry || ')';
    END IF;

    IF psortby IS NOT NULL
    THEN
        OPEN p_view FOR
               'SELECT t2.*
FROM (SELECT t1.*, rownum rnum
        FROM (SELECT t3.*, row_number() OVER(ORDER BY '
            || psortby
            || ') runm
              FROM ('
            || l_qry
            || ') t3'
            || s1
            || ') t1 WHERE rownum <= '
            || ptorownumber
            || ') t2 WHERE rnum >= '
            || pfromrownumber;
    ELSE
        OPEN p_view FOR
               'SELECT t2.* FROM (SELECT t1.*, rownum rn FROM (
      SELECT * FROM ('
            || l_qry
            || ')'
            || s1
            || ') t1 WHERE rownum <= '
            || ptorownumber
            || ') t2 WHERE rn >= '
            || pfromrownumber;
    END IF;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/
/
