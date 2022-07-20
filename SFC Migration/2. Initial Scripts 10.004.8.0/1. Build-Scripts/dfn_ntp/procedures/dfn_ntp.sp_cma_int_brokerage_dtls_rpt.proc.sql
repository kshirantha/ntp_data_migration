CREATE OR REPLACE PROCEDURE dfn_ntp.sp_cma_int_brokerage_dtls_rpt (
    p_view      OUT SYS_REFCURSOR,
    prows       OUT NUMBER,
    pfromdate       DATE DEFAULT SYSDATE,
    ptodate         DATE DEFAULT SYSDATE,
    pcurrency       VARCHAR2 DEFAULT 'SAR',
    pinstid         NUMBER)
IS
    l_securities          NUMBER;
    l_portfolios          NUMBER;
    l_settle_amount       NUMBER;
    l_portfolio_value_a   NUMBER;                                  --ETF,CS,TR
    l_portfolio_value_b   NUMBER;                                         --BN
    l_cash_balance        NUMBER;
    l_clients_assets      NUMBER;
    p_date                DATE;
    p_sdate               DATE;
    i_start_time          TIMESTAMP;
BEGIN
    p_sdate := TRUNC (TO_DATE (pfromdate, 'DD-MM-YYYY'));
    p_date := TRUNC (TO_DATE (ptodate, 'DD-MM-YYYY'));
    i_start_time := SYSTIMESTAMP;

    SELECT COUNT (securitis) AS securitis
      INTO l_securities
      FROM (  SELECT COUNT (u07_id) AS securitis
                FROM u07_trading_account u07, u24_holdings u24
               WHERE     u07.u07_id = u24.u24_trading_acnt_id_u07
                     AND u07.u07_institute_id_m02 = pinstid
            GROUP BY u07_id);

    DBMS_OUTPUT.put_line (i_start_time - SYSTIMESTAMP);

    SELECT COUNT (u07_id) AS portfolios
      INTO l_portfolios
      FROM u07_trading_account u07
     WHERE u07.u07_institute_id_m02 = pinstid;

    SELECT SUM (settle_amount) AS settle_amount
      INTO l_settle_amount
      FROM (SELECT ABS (  t02_amnt_in_stl_currency
                        * get_exchange_rate (t02_inst_id_m02,
                                             t02_settle_currency,
                                             pcurrency,
                                             'R',
                                             p_date))
                       AS settle_amount
              FROM t02_transact_log_cash_arc_all
             WHERE     t02_txn_code IN ('STLBUY', 'STLSEL')
                   AND t02_inst_id_m02 = pinstid
                   AND t02_cash_settle_date BETWEEN p_sdate
                                                AND p_date + 0.99999) t02;

    IF TRUNC (p_date) = TRUNC (SYSDATE)
    THEN
        SELECT ROUND (SUM (NVL (portfolio_value_a * rate, 0)), 4),
               ROUND (SUM (NVL (portfolio_value_b * rate, 0)), 4),
               ROUND (SUM (NVL (cash_balance * rate, 0)), 4)
          INTO l_portfolio_value_a, l_portfolio_value_b, l_cash_balance
          FROM (SELECT get_pfolio_val_by_cash_ac (u06_id,
                                                  u06_institute_id_m02,
                                                  '1',
                                                  '0',
                                                  '1',
                                                  '0',
                                                  p_date,
                                                  '1')
                           AS portfolio_value_a,
                       get_exchange_rate (u06_institute_id_m02,
                                          u06_currency_code_m03,
                                          pcurrency,
                                          'R',
                                          p_date)
                           AS rate,
                       get_pfolio_val_by_cash_ac (u06_id,
                                                  u06_institute_id_m02,
                                                  '1',
                                                  '0',
                                                  '1',
                                                  '0',
                                                  p_date,
                                                  '2')
                           AS portfolio_value_b,
                       (  u06.u06_balance
                        + u06.u06_payable_blocked
                        - u06.u06_net_receivable)
                           AS cash_balance
                  FROM u06_cash_account u06
                 WHERE u06_institute_id_m02 = pinstid);
    ELSE
        SELECT ROUND (SUM (NVL (portfolio_value_a * rate, 0)), 4),
               ROUND (SUM (NVL (portfolio_value_b * rate, 0)), 4),
               ROUND (SUM (NVL (cash_balance * rate, 0)), 4)
          INTO l_portfolio_value_a, l_portfolio_value_b, l_cash_balance
          FROM (SELECT get_pfolio_val_by_cash_ac (u06_id,
                                                  u06_institute_id_m02,
                                                  '1',
                                                  '0',
                                                  '1',
                                                  '0',
                                                  p_date,
                                                  '1')
                           AS portfolio_value_a,
                       get_exchange_rate (u06_institute_id_m02,
                                          h02.h02_currency_code_m03,
                                          pcurrency,
                                          'R',
                                          p_date)
                           AS rate,
                       get_pfolio_val_by_cash_ac (u06_id,
                                                  u06_institute_id_m02,
                                                  '1',
                                                  '0',
                                                  '1',
                                                  '0',
                                                  p_date,
                                                  '2')
                           AS portfolio_value_b,
                       (  h02.h02_balance
                        + h02.h02_payable_blocked
                        - h02.h02_net_receivable)
                           AS cash_balance
                  FROM u06_cash_account u06, vw_h02_cash_account_summary h02
                 WHERE     u06_institute_id_m02 = pinstid
                       AND h02.h02_cash_account_id_u06 = u06.u06_id
                       AND h02.h02_date BETWEEN TRUNC (p_date)
                                            AND TRUNC (p_date) + .99999);
    END IF;

    l_clients_assets :=
        l_portfolio_value_b + l_cash_balance + l_portfolio_value_a;

    OPEN p_view FOR
        SELECT NVL (l_securities, 0) AS no_of_securities,
               NVL (l_portfolios, 0) AS no_of_portfolios,
               NVL (l_settle_amount, 0) AS settle_amount,
               NVL (l_portfolio_value_a, 0) AS portfolio_value_a,
               NVL (l_portfolio_value_b, 0) AS portfolio_value_b,
               NVL (l_cash_balance, 0) AS cash_balance,
               NVL (l_clients_assets, 0) AS clients_assets,
               NVL (l_clients_assets, 0) AS tot_clients_assets
          FROM DUAL;

    DBMS_OUTPUT.put_line (i_start_time - SYSTIMESTAMP);
END;
/
