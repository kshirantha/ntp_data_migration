CREATE OR REPLACE PROCEDURE dfn_ntp.sp_commission_override_report (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2,
    pfromrownumber        NUMBER,
    ptorownumber          NUMBER,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE,
    ptodate               DATE,
    puserfilter           VARCHAR2 DEFAULT NULL)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT u06.u06_investment_account_no  AS cash_account_no,
              u07.u07_exchange_account_no AS exchange_ac,
              u07.u07_id AS security_ac_id,
              u01.u01_full_name AS custname,
              t01.t01_date_time,
              t01.t01_ord_no,
              t01.t01_quantity,
              t01.t01_cl_ord_id,
              t01.t01_symbol_id_m20,
              m20.m20_short_description,
              t01.t01_price,
              t01.t01_ord_value,
              t01.t01_ord_net_value,
              t01.t01_orig_commission AS origin_comm,
              t01.t01_orig_commission - t01.t01_commission AS override_comm,
              t01.u17_login_name AS order_input_dealer_id,
              u17.u17_full_name AS dealername,
              u17_a.u17_login_name AS order_approved_dealer_id,
              u17_a.u17_full_name AS approved_dealername,
              u01.u01_id
         FROM t01_order_all t01
        JOIN u07_trading_account u07
           ON u07.u07_id = t01.t01_trading_acc_id_u07
        JOIN u06_cash_account u06
           ON u06.u06_id = u07.u07_cash_account_id_u06
        JOIN u01_customer u01
           ON u01.u01_id = u06.u06_customer_id_u01
       LEFT JOIN u17_employee u17
           ON t01.t01_dealer_id_u17 = u17.u17_id
       LEFT JOIN u17_employee u17_a
           ON t01.t01_approved_by_id_u17 = u17_a.u17_id
       LEFT JOIN m20_symbol m20
           ON     t01.t01_symbol_id_m20 = m20.m20_id
 WHERE     u06.u06_margin_enabled = 1 AND t01.t01_orig_commission > 0'
        || ' AND t01.t01_date BETWEEN TO_DATE (
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
                                                                         + .99999';


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