CREATE OR REPLACE PROCEDURE dfn_ntp.sp_populate_tax_details (
    p_key               OUT NUMBER,
    p_institute_id   IN     NUMBER DEFAULT 1,
    p_customer_id    IN     NUMBER,
    p_from_date      IN     DATE DEFAULT SYSDATE,
    p_to_date        IN     DATE DEFAULT SYSDATE,
    p_invoice_no     IN     VARCHAR,
    p_txn_code       IN     VARCHAR)
IS
    record_count   NUMBER := 0;
    l_qry          VARCHAR2 (15000);
    c_dataset      SYS_REFCURSOR;
BEGIN
    l_qry :=
           'SELECT t02.t02_last_db_seq_id, t02.t02_txn_code
              FROM t02_transact_log_cash_arc_all t02
             WHERE     t02.t02_customer_id_u01 = '
        || p_customer_id
        || ' AND t02.t02_inst_id_m02 = '
        || p_institute_id
        || ' AND t02.t02_create_date BETWEEN TO_DATE('''
        || TO_CHAR (p_from_date, ' DD - MM - YYYY ')
        || ''' ,
        ''DD - MM - YYYY '') AND
       TO_DATE(
       '''
        || TO_CHAR (p_to_date, ' DD - MM - YYYY ')
        || ''' ,
        '' DD - MM - YYYY '') + 0.99999'
        || CASE
               WHEN p_txn_code = 'ALL' THEN ' '
               ELSE ' AND t02.t02_txn_code = ''' || p_txn_code || ''''
           END
        || ' AND (t02.t02_exchange_tax + t02.t02_broker_tax /* + t02.t02_exec_cma_tax + t02.t02_exec_cpp_tax
                   + t02.t02_exec_dcm_tax*/ ) > 0';
    DBMS_OUTPUT.put_line (l_qry);

    EXECUTE IMMEDIATE
        ('SELECT COUNT(t02_last_db_seq_id) FROM ( ' || l_qry || ') ')
        INTO record_count;

    IF record_count = 0
    THEN
        p_key := -1;
        RETURN;
    END IF;

    EXECUTE IMMEDIATE
        (   'INSERT INTO t49_tax_invoice_details(t49_invoice_no_t48,
                                                t49_last_db_seq_id_t02,
                                                t49_txn_code)
              SELECT '''
         || p_invoice_no
         || ''', t02_last_db_seq_id, t02_txn_code FROM ('
         || l_qry
         || ')');

    p_key := record_count;
EXCEPTION
    WHEN OTHERS
    THEN
        p_key := -2;
END;
/
