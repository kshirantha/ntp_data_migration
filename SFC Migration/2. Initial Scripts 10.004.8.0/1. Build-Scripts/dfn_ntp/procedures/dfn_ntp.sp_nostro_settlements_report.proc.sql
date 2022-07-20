CREATE OR REPLACE PROCEDURE dfn_ntp.sp_nostro_settlements_report (
    p_view                     OUT SYS_REFCURSOR,
    prows                      OUT NUMBER,
    psortby                 IN     VARCHAR2 DEFAULT NULL,
    pfromrownumber          IN     NUMBER DEFAULT NULL,
    ptorownumber            IN     NUMBER DEFAULT NULL,
    psearchcriteria         IN     VARCHAR2 DEFAULT NULL,
    pt02_custodian_id_m26   IN     t02_transaction_log.t02_custodian_id_m26%TYPE DEFAULT -1,
    pfromdate               IN     t02_transaction_log.t02_cash_settle_date%TYPE DEFAULT SYSDATE,
    ptodate                 IN     t02_transaction_log.t02_cash_settle_date%TYPE DEFAULT SYSDATE,
    pprimaryinstitute       IN     u01_customer.u01_institute_id_m02%TYPE)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           '  SELECT t02_side,
         order_side,
         MAX (t02_cliordid_t01) AS t02_cliordid_t01,
         t02_symbol_code_m20,
         m20_reuters_code,
         u01_external_ref_no,
         SUM (t02_last_shares) AS t02_last_shares,
         t02_txn_currency,
         SUM (amount) AS amount,
         t02_cash_settle_date,
         t02_create_date,
         m20_instrument_type_id_v09,
         m26_name,
         t02_custodian_id_m26,
         t02_exchange_code_m01
    FROM (SELECT t02.t02_side,
                 CASE t02.t02_side
                     WHEN 1 THEN ''Buy''
                     WHEN 2 THEN ''Sell''
                     WHEN 3 THEN ''Subscription''
                 END
                     AS order_side,
                 t02.t02_cliordid_t01,
                 t02.t02_order_no,
                 t02.t02_symbol_code_m20,
                 m20.m20_reuters_code,
                 u01.u01_external_ref_no,
                 t02.t02_last_shares,
                 t02.t02_txn_currency,
                 CASE
                     WHEN t02.t02_side = 1
                     THEN
                           ABS (t02.t02_ord_value_adjst)
                         + t02.t02_exg_commission
                         + NVL (t02.t02_accrude_interest, 0)
                     ELSE
                           ABS (t02.t02_ord_value_adjst)
                         - t02.t02_exg_commission
                         + NVL (t02.t02_accrude_interest, 0)
                 END
                     AS amount,
                 t02.t02_cash_settle_date,
                 TRUNC (t02.t02_create_date) AS t02_create_date,
                 m20.m20_instrument_type_id_v09,
                 m26.m26_sid || ''-'' || m26.m26_name AS m26_name,
                 t02.t02_custodian_id_m26,
                 t02.t02_exchange_code_m01
            FROM t02_transact_log_order_arc_all t02
                 JOIN u06_cash_account u06
                     ON t02.t02_cash_acnt_id_u06 = u06.u06_id
                 JOIN m20_symbol m20
                     ON t02.t02_symbol_id_m20 = m20.m20_id
                 JOIN u01_customer u01
                     ON u06.u06_customer_id_u01 = u01.u01_id
                 JOIN m26_executing_broker m26
                     ON t02.t02_custodian_id_m26 = m26.m26_id
           WHERE u01.u01_institute_id_m02 = '
        || pprimaryinstitute
        || CASE
               WHEN pt02_custodian_id_m26 <> -1
               THEN
                      ' AND t02.t02_custodian_id_m26 = '
                   || pt02_custodian_id_m26
               ELSE
                   ''
           END
        || ' AND t02.t02_create_date BETWEEN TO_DATE (
                                                                                        '''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',
                                                                                        ''DD-MM-YYYY''
                                                                                    ) - fn_get_max_txn_stl_date_diff AND TO_DATE (
                                                                                        '''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''',
                                                                                        ''DD-MM-YYYY''
                                                                                    )
                                                                            + 0.99999
                             AND t02.t02_cash_settle_date BETWEEN TO_DATE (
                                                                                        '''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',
                                                                                        ''DD-MM-YYYY''
                                                                                    ) AND TO_DATE (
                                                                                        '''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''',
                                                                                        ''DD-MM-YYYY''
                                                                                    )
                                                                                 + 0.99999)
            GROUP BY t02_side,
                     order_side,
                     t02_order_no,
                     t02_symbol_code_m20,
                     m20_reuters_code,
                     u01_external_ref_no,
                     t02_txn_currency,
                     t02_cash_settle_date,
                     t02_create_date,
                     m20_instrument_type_id_v09,
                     m26_name,
                     t02_custodian_id_m26,
                     t02_exchange_code_m01';

    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              NULL,
                              NULL,
                              NULL);

    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/
