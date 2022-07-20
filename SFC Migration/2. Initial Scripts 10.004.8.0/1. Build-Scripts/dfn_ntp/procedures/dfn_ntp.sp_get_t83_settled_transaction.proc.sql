CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_t83_settled_transaction (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pt83id                NUMBER,
    psettledate           DATE)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;

    l_qry :=
           'SELECT a.t02_order_no,
               a.t02_order_exec_id,
               a.t02_cash_settle_date,
               a.t02_custodian_id_m26,
               a.t02_exec_broker_id_m26,
               a.t02_exchange_code_m01,
               a.t02_txn_currency,
               a.t02_inst_id_m02,
               a.t02_ord_value_adjst order_value,
               a.t02_commission_adjst total_commission,
               a.t02_exg_commission exchange_commission,
               a.t02_exchange_tax exchange_tax,
               a.t02_broker_tax broker_tax,
               m26.m26_name,
               a.t02_cash_acnt_id_u06,
               u06.u06_customer_no_u01,
               u06.u06_display_name_u01,
               u06.u06_display_name
          FROM t02_transaction_log a
               JOIN m26_executing_broker m26
                   ON a.t02_exec_broker_id_m26 = m26.m26_id
               JOIN u06_cash_account u06
                   ON a.t02_cash_acnt_id_u06 = u06.u06_id
               JOIN (SELECT t88.t88_t02_last_db_seq_id
               FROM t88_exec_broker_settlemnt_log t88
              WHERE t88.t88_id_t83 = '
        || pt83id
        || ') t88
           ON a.t02_last_db_seq_id = t88.t88_t02_last_db_seq_id
         WHERE     a.t02_create_date between TO_DATE('''
        || TO_CHAR (psettledate, ' DD - MM - YYYY ')
        || ''', '' DD - MM - YYYY '')  - 30
         AND TO_DATE('''
        || TO_CHAR (psettledate, ' DD - MM - YYYY ')
        || ''', '' DD - MM - YYYY '') + .99999
         AND a.t02_cash_settle_date BETWEEN TO_DATE('''
        || TO_CHAR (psettledate, ' DD - MM - YYYY ')
        || ''', '' DD - MM - YYYY '')
       AND TO_DATE('''
        || TO_CHAR (psettledate, ' DD - MM - YYYY ')
        || ''', '' DD - MM - YYYY '') + .99999';

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