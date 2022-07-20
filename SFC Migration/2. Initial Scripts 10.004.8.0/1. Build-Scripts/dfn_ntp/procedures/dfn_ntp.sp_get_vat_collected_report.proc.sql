CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_vat_collected_report (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE,
    pinstitute            NUMBER)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;

    l_qry :=
           'SELECT t02_create_date,
               t02_cash_settle_date,
               t02_txn_code,
               m97.m97_description,
               t02_narration,
               NVL (t02.t02_broker_vat + t02.t02_exchange_vat, 0) AS total_vat,
               t02_order_no,
               t02_symbol_code_m20,
               t02_customer_id_u01,
               t02_cash_acnt_id_u06,
               t02_trd_acnt_id_u07,
               t02_inst_id_m02
          FROM vw_t02_cash_txn_log t02
               JOIN u06_cash_account u06 ON t02.t02_cash_acnt_id_u06 = u06.u06_id
               JOIN u01_customer u01 ON u06.u06_customer_id_u01 = u01.u01_id
               JOIN vw_m97_cash_txn_codes_base m97 ON t02.t02_txn_code = m97.m97_code
      WHERE t02.t02_create_date BETWEEN TO_DATE (
                                                                      '''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',
                                                                      ''DD-MM-YYYY'')
                                                              AND  TO_DATE (
                                                                       '''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''',
                                                                       ''DD-MM-YYYY'')
                                                                   + .99999
        and t02_inst_id_m02 = '
        || pinstitute
        || '



      ORDER BY t02_create_date';

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