CREATE OR REPLACE PROCEDURE dfn_ntp.sp_cma_int_brokerage_dtls_all (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE,
    pcurrency             VARCHAR2 DEFAULT 'SAR',
    pinstid               NUMBER)
IS
    l_sucurities          NUMBER;
    l_portfolios          NUMBER;
    l_settle_amount       NUMBER;
    l_portfolio_value_a   NUMBER;                                  --ETF,CS,TR
    l_portfolio_value_b   NUMBER;                                         --BN
    l_cash_balance        NUMBER;
    l_clients_assets      NUMBER;
    p_date                DATE;
    p_sdate               DATE;
    l_qry                 VARCHAR2 (15000);
BEGIN
    prows := 0;
    p_sdate := pfromdate;
    p_date := ptodate;

    l_qry :=
           'SELECT u07_portfolio.u07_id,
               u07_portfolio.u07_display_name,
               NVL (ABS(u07_portfolio.rate * u07_portfolio.t02_amnt_in_stl_currency), 0) AS settle_amount,
               ROUND(NVL(u07_portfolio.port_value_a * u07_portfolio.rate, 0), 4) AS portfolio_value_a,
               ROUND(NVL(u07_portfolio.port_value_b * u07_portfolio.rate, 0), 4) AS portfolio_value_b,
               ROUND(NVL (u06_bal.cash_balance * u07_portfolio.rate, 0), 4) AS cash_balance,
               (  NVL (u07_portfolio.port_value_a, 0)
                + NVL (u07_portfolio.port_value_b, 0)
                + NVL (u06_bal.cash_balance, 0))* u07_portfolio.rate
                   AS asset,
               (   NVL (u07_portfolio.port_value_a, 0)
                + NVL (u07_portfolio.port_value_b, 0)
                + NVL (u06_bal.cash_balance, 0))* u07_portfolio.rate
                   AS deal_asset
            FROM (SELECT u07.u07_id,
                   u07.u07_display_name,
                   u07.u07_cash_account_id_u06,
                   get_exchange_rate (t02_inst_id_m02,
                                 t02_settle_currency,'''
        || pcurrency
        || ''',
                                 ''R'',
                                  TO_DATE ('''
        || TO_CHAR (p_date, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'')
                                 ) AS rate,
                  t02.t02_amnt_in_stl_currency,
                  u06_id, u06_display_name,
                  get_pfolio_val_by_cash_ac ( u06_id,
                                     u06_institute_id_m02,
                                     ''1'',
                                     ''0'',
                                     ''1'',
                                     ''0'',
                                     TO_DATE ('''
        || TO_CHAR (p_date, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'') ,
                                     ''1'') AS port_value_a,
                 get_pfolio_val_by_cash_ac (u06_id,
                     u06_institute_id_m02,
                     ''1'',
                     ''0'',
                     ''1'',
                     ''0'',
                     TO_DATE ('''
        || TO_CHAR (p_date, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'') ,
                     ''2'') AS port_value_b
                      FROM u07_trading_account u07
                     LEFT JOIN t02_transact_log_cash_arc_all t02 ON u07.u07_id = t02.t02_trd_acnt_id_u07
                     AND u07.u07_institute_id_m02 = '
        || pinstid
        || '
                            AND t02.t02_txn_code IN (''STLBUY'', ''STLSEL'')
                            AND t02.t02_cash_settle_date BETWEEN TO_DATE ('''
        || TO_CHAR (p_sdate, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'')
                                                           AND  TO_DATE ('''
        || TO_CHAR (p_date, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'')
                                                               + 0.99999
                    LEFT JOIN u06_cash_account u06 ON u07.u07_cash_account_id_u06 = u06.u06_id) u07_portfolio

            LEFT JOIN (SELECT u06_id, (u06.u06_balance
                            + u06.u06_payable_blocked
                            - u06.u06_net_receivable) AS cash_balance
                    FROM  u06_cash_account u06
                    WHERE u06_institute_id_m02 = '
        || pinstid
        || 'AND TRUNC (SYSDATE) = TO_DATE ('''
        || TO_CHAR (p_date, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'')
                    UNION
                    SELECT  h02_cash_account_id_u06 AS u06_id, (h02.h02_balance
                                      + h02.h02_payable_blocked
                                      - h02.h02_net_receivable) AS cash_balance
                    FROM vw_h02_cash_account_summary h02
                    WHERE h02_date BETWEEN TO_DATE ('''
        || TO_CHAR (p_date, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'')
                     AND TO_DATE ('''
        || TO_CHAR (p_date, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'')   + 0.99999) u06_bal
            ON u07_portfolio.u07_cash_account_id_u06 = u06_bal.u06_id';
    DBMS_OUTPUT.put_line (l_qry);

    IF (pfromrownumber = 1)
    THEN
        EXECUTE IMMEDIATE
               'SELECT COUNT ( * ) FROM ('
            || l_qry
            || ')'
            || CASE
                   WHEN psearchcriteria IS NOT NULL
                   THEN
                       ' WHERE ' || psearchcriteria
                   ELSE
                       ''
               END
            INTO prows;
    ELSE
        prows := -2;
    END IF;

    IF psortby IS NOT NULL
    THEN
        OPEN p_view FOR
               'SELECT t2.* FROM (SELECT t1.*, ROWNUM rnum FROM (SELECT t3.*, ROW_NUMBER() OVER(ORDER BY '
            || psortby
            || ') runm FROM ('
            || l_qry
            || ') t3'
            || CASE
                   WHEN psearchcriteria IS NOT NULL
                   THEN
                       ' WHERE ' || psearchcriteria
                   ELSE
                       ''
               END
            || ') t1 WHERE ROWNUM <= '
            || ptorownumber
            || ') t2 WHERE RNUM >= '
            || pfromrownumber;
    ELSE
        OPEN p_view FOR
               'SELECT t2.* FROM (SELECT t1.*, ROWNUM rn FROM (SELECT * FROM ('
            || l_qry
            || ')'
            || CASE
                   WHEN psearchcriteria IS NOT NULL
                   THEN
                       ' WHERE ' || psearchcriteria
                   ELSE
                       ''
               END
            || ') t1 WHERE ROWNUM <= '
            || ptorownumber
            || ') t2 WHERE rn >= '
            || pfromrownumber;
    END IF;
END;
/
