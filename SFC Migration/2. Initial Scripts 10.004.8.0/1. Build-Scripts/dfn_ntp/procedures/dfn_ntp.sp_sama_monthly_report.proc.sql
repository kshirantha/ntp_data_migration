CREATE OR REPLACE PROCEDURE dfn_ntp.sp_sama_monthly_report (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2,
    pfromrownumber        NUMBER,
    ptorownumber          NUMBER,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE,
    ptodate               DATE)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT u06.u06_external_ref_no as account_no,
               u01.u01_display_name,
               u01.u01_id,
               u07.u07_exchange_account_no,
               0 AS aproved_margin_limit,
               NVL (t21.t21_ovedraw_amt, 0) AS utilization_amount,
               m20.m20_symbol_code,
               m20.m20_exchange_code_m01,
               m20.m20_short_description,
               net_holdings AS availableqty,
               (  net_holdings
                * DECODE (NVL (esp.lasttradeprice, 0),
                          0, NVL (esp.previousclosed, 0),
                          NVL (esp.lasttradeprice, 0))
                * get_exchange_rate (u06.u06_institute_id_m02,
                                     m20.m20_currency_code_m03,
                                     u06.u06_currency_code_m03,
                                     ''SR''))
                   AS symbol_market_value,
               /*   ROUND (
                      SUM (NVL (t75.t75_aproved_margin_limit, 0))
                          OVER (PARTITION BY NULL),
                      2)
                      AS total_approv_margin_limit,*/
               ROUND (
                   SUM (NVL (t21.t21_ovedraw_amt, 0))
                       OVER (PARTITION BY NULL),
                   2)
                   AS total_utilization_amount,
                   u01_institute_id_m02 as institute_id
          FROM (SELECT u06.u06_id
                  FROM u06_cash_account u06
                       JOIN u23_customer_margin_product u23
                           ON u06.u06_margin_product_id_u23 = u23.u23_id
                       JOIN m73_margin_products m73
                           ON u23.u23_margin_product_m73 = m73.m73_id
                 WHERE     m73.m73_margin_category_id_v01 IN (8, 9)
                       AND m73.m73_status_id_v01 != 5
                       AND u06_margin_enabled = 1) marg,
               (SELECT t02_trd_acnt_id_u07,
                       t02_cash_acnt_id_u06,
                       t02_symbol_id_m20,
                       t02_symbol_code_m20,
                       t02_exchange_code_m01,
                       net_holdings
                  FROM (SELECT t02.t02_trd_acnt_id_u07,
                               MAX (t02_cash_acnt_id_u06)
                                   t02_cash_acnt_id_u06,
                               t02.t02_symbol_id_m20,
                               MAX (t02.t02_symbol_code_m20)
                                   t02_symbol_code_m20,
                               MAX (t02.t02_exchange_code_m01)
                                   t02_exchange_code_m01
                          FROM t02_transaction_log_hold_all t02
                         WHERE t02.t02_create_date BETWEEN TRUNC (TO_DATE('''
        || pfromdate
        || '''))
                                                       AND  TRUNC (TO_DATE('''
        || ptodate
        || '''))
                                                           + .99999
                        GROUP BY t02.t02_trd_acnt_id_u07,
                                 t02.t02_symbol_id_m20),
                       (SELECT h01_trading_acnt_id_u07,
                               h01_symbol_id_m20,
                               h01_exchange_code_m01,
                               h01_symbol_code_m20,
                                 h01_net_holding
                               + NVL (h01_payable_holding, 0)
                               - NVL (h01_receivable_holding, 0)
                                   AS net_holdings
                          FROM vw_h01_holding_summary h01
                         WHERE h01.h01_date = TRUNC (TO_DATE('''
        || ptodate
        || ''')))
                 WHERE     t02_trd_acnt_id_u07 = h01_trading_acnt_id_u07
                       AND t02_symbol_id_m20 = h01_symbol_id_m20) a,
               u06_cash_account u06,
               u07_trading_account u07,
               m20_symbol m20,
               u01_customer u01,
               (SELECT * FROM dfn_price.symbol_data --WHERE transactiondate BETWEEN TRUNC (SYSDATE)  AND TRUNC (SYSDATE) + .99999
                                                   ) esp,
               (SELECT *
                  FROM t21_daily_interest_for_charges
                 WHERE                      -- t75_interest_index_id <> -1 and
                       t21_created_date BETWEEN TRUNC (TO_DATE('''
        || pfromdate
        || '''))
                                            AND TRUNC (TO_DATE('''
        || ptodate
        || ''')) + .99999) t21
         WHERE     a.t02_cash_acnt_id_u06 = u06.u06_id
               AND u06.u06_customer_id_u01 = u01.u01_id
               AND marg.u06_id = a.t02_cash_acnt_id_u06
               AND a.t02_trd_acnt_id_u07 = u07.u07_id
               AND a.t02_exchange_code_m01 = u07.u07_exchange_code_m01
               AND a.t02_symbol_id_m20 = m20.m20_id
               AND a.t02_exchange_code_m01 = esp.exchangecode(+)
               AND a.t02_symbol_code_m20 = esp.symbol(+)
               AND u06.u06_id = t21.t21_cash_account_id_u06(+)';



    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              psortby,
                              ptorownumber,
                              pfromrownumber
                             );
    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;                                                              -- Procedure
/