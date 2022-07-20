CREATE OR REPLACE PROCEDURE dfn_ntp.sp_daily_trades_by_exchange (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2,
    pfromrownumber        NUMBER,
    ptorownumber          NUMBER,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE,
    ptodate               DATE,
    puserfilter           VARCHAR2 DEFAULT NULL,
    pexchangeid           NUMBER DEFAULT NULL,
    pinstitute            NUMBER)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           ' SELECT t02.t02_cliordid_t01,
       t02.t02_exchange_code_m01,
       t02.t02_symbol_code_m20,
       t02.t02_symbol_code_m20 AS symbol_name,
       t02.t02_order_no,
       t02.t02_order_exec_id,
       t02.t02_create_date,
       t02.t02_create_datetime,
       CASE WHEN t02.t02_side = 1 THEN ''Buy'' ELSE ''Sell'' END AS side,
       ''Filled'' AS v30_description,
       ABS(t02.t02_holding_net_adjst) AS t02_holding_net_adjst,
       t02.t02_leaves_qty,
       t02.t02_ordqty,
       t02.t02_last_price,
       ABS(t02.t02_ord_value_adjst) AS t02_ord_value_adjst,
       m02.m02_id,
       m02.m02_code
  FROM t02_transaction_log_order_all t02
       JOIN m02_institute m02
           ON t02.t02_inst_id_m02 = m02.m02_id
       JOIN m01_exchanges m01
           ON     t02.t02_exchange_id_m01 = m01.m01_id
 WHERE t02.t02_txn_code IN (''STLSEL'', ''STLBUY'')'
        || CASE
               WHEN pexchangeid != -1
               THEN
                   ' AND m01.m01_id = ' || pexchangeid || ''
               ELSE
                      ''
                   || ' AND t02.t02_create_date BETWEEN TO_DATE (
                                                                            '''
                   || TO_CHAR (pfromdate, 'DD-MM-YYYY')
                   || ''',
                                                                            ''DD-MM-YYYY''
                                                                        )
                                                                    AND  TO_DATE (
                                                                             '''
                   || TO_CHAR (ptodate, 'DD-MM-YYYY')
                   || ''',
                                                                             ''DD-MM-YYYY''
                                                                         )
                                                                         + .99999'
           END;

    /*  s1 :=
          fn_get_sp_data_query (psearchcriteria,
                                l_qry,
                                NULL,
                                NULL,
                                NULL);
      s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

      OPEN p_view FOR s1;

      EXECUTE IMMEDIATE s2 INTO prows; */

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
END;                                                              -- Procedure
/
