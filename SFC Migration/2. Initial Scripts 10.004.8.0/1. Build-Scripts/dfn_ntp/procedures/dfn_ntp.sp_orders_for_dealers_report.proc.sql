CREATE OR REPLACE PROCEDURE dfn_ntp.sp_orders_for_dealers_report (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE,
    pdealerid             NUMBER DEFAULT NULL,
    pexchange             VARCHAR2 DEFAULT NULL)
IS
    l_qry   VARCHAR2 (10000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           'SELECT t01.t01_ord_no,
       t01.t01_cl_ord_id,
       t01.t01_exchange_ord_id,
       t01.t01_date,
       t01_status_id_v30,
       m20_symbol_code,
       t01.m20_currency_code_m03,
       t01.t01_exchange_code_m01,
       t01_price,
       t01.t01_quantity,
       t01_commission,
       t01.cum_broker_commission,
       t01.t01_ord_value,
       t01.t01_cum_quantity,
       v06_description as order_type,
       t01.t01_side,
       order_side,
       u17_full_name as dealer_name,
       t01_customer_id_u01,
       u01_customer_no,
       t01.t01_institution_id_m02,
       t01.m20_short_description,
       t01.m20_short_description_lang,
       t01.m20_long_description,
       t01.m20_long_description_lang,
       t01.t01_broker_tax,
       t01.t01_exchange_tax,
       t01.t01_cum_exchange_tax,
       t01.t01_cum_broker_tax,
       t01.v30_description,
       t01.t01_dealer_id_u17,
       t01.U09_LOGIN_NAME,
       t01.t01_trading_acntno_u07,
       t01.u01_display_name
  FROM vw_order_list t01 WHERE t01_dealer_id_u17 is not null and t01_date BETWEEN TO_DATE (
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
                                                                         + .99999
          '
        || CASE
               WHEN pdealerid IS NULL THEN ' '
               WHEN TRIM (pdealerid) = '' THEN ' '
               ELSE 'and t01_dealer_id_u17 = ' || pdealerid
           END
        || CASE
               WHEN pexchange IS NULL THEN ' '
               WHEN TRIM (pexchange) = '' THEN ' '
               ELSE 'and t01_exchange_code_m01 = ''' || pexchange || ''''
           END;

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