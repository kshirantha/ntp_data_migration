CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_allocation_transactions (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    pinstitute            NUMBER,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    pfromdate             DATE,
    penddate              DATE,
    psymbol               NUMBER DEFAULT NULL,
    porderside            NUMBER DEFAULT NULL,
    pcustomer             NUMBER DEFAULT NULL,
    pafdatetype           NUMBER DEFAULT 1,
    pafqtyopt             NUMBER DEFAULT 0,
    pafvalueopt           NUMBER DEFAULT 0,
    pafzerovalue          NUMBER DEFAULT 0,
    pafqtyfrom            VARCHAR2 DEFAULT '',
    pafqtyto              VARCHAR2 DEFAULT '',
    pafvalfrom            VARCHAR2 DEFAULT '',
    pafvalto              VARCHAR2 DEFAULT '')
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT
              t02.t02_customer_id_u01,
              t02.t02_trd_acnt_id_u07,
              t02.t02_cash_acnt_id_u06,
              u01.u01_customer_no,
              u01.u01_display_name,
              u07.u07_display_name,
              t02_order_no,
              t02_order_exec_id,
              t02_ordqty,
              t02.t02_avgprice,
              t02.t02_create_date,
              t02_cash_settle_date,
              t02_holding_settle_date,
              t02_commission_adjst AS t02_cum_commission,
              t02_broker_tax + t02_exchange_tax total_tax,
              t02_cum_qty,
              t02_leaves_qty,
              t02_exchange_code_m01,
              t02.t02_symbol_code_m20,
                  CASE
                      WHEN t02.t02_side = 1 THEN
                           ''Buy''
                      WHEN t02.t02_side = 2 THEN
                           ''Sell''
                      ELSE
                           ''Sub''
                      END order_side,
              t02.t02_side,
              t02.t02_cliordid_t01,
              m26.m26_sid,
              t02.t02_last_db_seq_id,
			         m26.m26_name AS custodian,
              t02.t02_Last_Shares,
              t02.t02_allocated_qty,
              t02.t02_last_price,
              NVL(m20.m20_price_ratio,1) as price_ratio,
              NVL(t02.t02_last_shares,0) - NVL(t02.t02_allocated_qty,0) as remaining_qty
              FROM
              t02_transaction_log_order_all t02
              INNER JOIN u01_customer u01
              ON t02.t02_customer_id_u01 = u01.u01_id
              INNER JOIN u07_trading_account u07
              ON t02.t02_trd_acnt_id_u07=u07.u07_id
              INNER JOIN m26_executing_broker m26
              ON t02.t02_custodian_id_m26 = m26.m26_id
              LEFT JOIN m20_symbol m20 ON t02.t02_symbol_id_m20 = m20.m20_id
              WHERE NVL(t02.t02_last_shares,0) - NVL(t02.t02_allocated_qty,0) > 0
              AND t02.t02_inst_id_m02 = '
        || pinstitute
        || CASE
               WHEN pafdatetype = 1
               THEN --Filter Based on Trade Date
                      ' AND t02.t02_create_date BETWEEN TO_DATE ('''
                   || TO_CHAR (pfromdate, 'DD-MM-YYYY')
                   || ''',''DD-MM-YYYY'')
         AND  TO_DATE ('''
                   || TO_CHAR (penddate, 'DD-MM-YYYY')
                   || ''', ''DD-MM-YYYY'' ) + .99999'
               WHEN pafdatetype = 2
               THEN --Filter Based on Settlement Date
                      ' AND t02.t02_create_date BETWEEN TO_DATE ('''
                   || TO_CHAR (pfromdate, 'DD-MM-YYYY')
                   || ''',''DD-MM-YYYY'') - fn_get_max_txn_stl_date_diff
         AND  TO_DATE ('''
                   || TO_CHAR (penddate, 'DD-MM-YYYY')
                   || ''', ''DD-MM-YYYY'' ) + .99999'
                   || ' AND t02.t02_cash_settle_date BETWEEN TO_DATE ('''
                   || TO_CHAR (pfromdate, 'DD-MM-YYYY')
                   || ''',''DD-MM-YYYY'')
         AND  TO_DATE ('''
                   || TO_CHAR (penddate, 'DD-MM-YYYY')
                   || ''', ''DD-MM-YYYY'' ) + .99999'
               ELSE
                   ''
           END
        || CASE
               WHEN pafqtyopt <> 0
               THEN
                      ' AND '
                   || fn_prep_trade_where_clause ('t02_Last_Shares',
                                                  pafqtyopt,
                                                  pafqtyfrom,
                                                  pafqtyto)
               ELSE
                   ''
           END
        || CASE
               WHEN pafvalueopt <> 0
               THEN
                      ' AND '
                   || fn_prep_trade_where_clause (
                          't02_last_price * t02_Last_Shares',
                          pafvalueopt,
                          pafvalfrom,
                          pafvalto)
               ELSE
                   ''
           END
        || CASE
               WHEN psymbol IS NOT NULL
               THEN
                   ' And t02.t02_symbol_id_m20 = ' || psymbol
               ELSE
                   ''
           END
        || CASE
               WHEN porderside IS NOT NULL
               THEN
                   ' And t02.t02_side = ' || porderside
               ELSE
                   ''
           END
        || CASE
               WHEN pcustomer IS NOT NULL
               THEN
                   ' And u07.u07_id = ' || pcustomer
               ELSE
                   ''
           END;


    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              NULL,
                              ptorownumber,
                              pfromrownumber);

    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);


    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/