CREATE OR REPLACE PROCEDURE dfn_ntp.sp_unauth_od_clients_interest (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE,
    pinstitute            NUMBER,
    pdatefilter           VARCHAR2)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;

    l_qry :=
           'SELECT u06.u06_display_name AS cash_acc_ref_no,
                   u01.u01_external_ref_no AS customer_external_ref_no,
                   t21.t21_interest_charge_amt AS interest_charge_amount,
                   t21.t21_created_date AS created_date,
                   t21.t21_value_date AS value_date,
                   t21.t21_ovedraw_amt AS overdraw_amount,
                   t21.t21_interest_rate AS interest_rate,
                   u06.u06_currency_code_m03 AS currency_code,
                   u01.u01_display_name AS customer_name,
                   u06_id
              FROM t21_daily_interest_for_charges t21
                   JOIN u06_cash_account u06 ON t21.t21_cash_account_id_u06 = u06.u06_id
                   JOIN u01_customer u01 ON u06.u06_customer_id_u01 = u01.u01_id
      WHERE '
        || pdatefilter
        || ' BETWEEN TO_DATE (
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
        AND u01_institute_id_m02 = '
        || pinstitute
        || ' AND t21_charges_code_m97 IN (''WODINT_ADJ'',
                                    ''RODINT_ADJ'',
                                    ''IODINT_ADJ'',
                                    ''IODINT'',
                                    ''WODINT'',
                                    ''ODINT'',
                                    ''ODINT_ADJ'')'
        || '
      ORDER BY t21_created_date';

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