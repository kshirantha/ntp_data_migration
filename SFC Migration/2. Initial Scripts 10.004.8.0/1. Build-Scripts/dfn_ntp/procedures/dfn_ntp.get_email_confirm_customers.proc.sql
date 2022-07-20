CREATE OR REPLACE PROCEDURE dfn_ntp.get_email_confirm_customers (
    p_view               OUT SYS_REFCURSOR,
    prows                OUT NUMBER,
    psortby           IN     VARCHAR2 DEFAULT NULL,
    pfromrownumber    IN     NUMBER DEFAULT NULL,
    ptorownumber      IN     NUMBER DEFAULT NULL,
    psearchcriteria   IN     VARCHAR2 DEFAULT NULL,
    pfromdate         IN     DATE DEFAULT SYSDATE,
    ptodate           IN     DATE DEFAULT SYSDATE,
    pinstitute               NUMBER DEFAULT 1,
    pexchange                VARCHAR2 DEFAULT NULL,
    porderside               NUMBER DEFAULT NULL,
    psymbol                  NUMBER DEFAULT NULL,
    psignuploc               NUMBER DEFAULT NULL)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT u01.u01_customer_no,
           u01.u01_display_name     u01_customer_name,
           u06.u06_display_name     u06_cash_account_number,
           u07.u07_display_name     u07_trading_account_number,
           u02.u02_email,
           u02.u02_cc_email,
           u02.u02_bcc_email,
           t02.t02_trade_confirm_no,
           t64.t64_id,
           v12.v12_id,
            t02.trd_acnt_id_u07 AS t02_trd_acnt_id_u07
      FROM (SELECT MAX(t02_trd_acnt_id_u07) AS trd_acnt_id_u07,
                   t02_trade_confirm_no
              FROM t02_transaction_log_order_all t02
             WHERE t02.t02_create_date BETWEEN TO_DATE ('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'') AND TO_DATE ('''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'') + 0.99999
            AND t02.t02_inst_id_m02 ='
        || pinstitute
        || CASE
               WHEN pexchange IS NOT NULL
               THEN
                   ' AND t02.t02_exchange_code_m01 = ' || pexchange
               ELSE
                   ' '
           END
        || CASE
               WHEN porderside IS NOT NULL
               THEN
                   ' AND t02.t02_side = ' || porderside
               ELSE
                   ' '
           END
        || CASE
               WHEN psymbol IS NOT NULL
               THEN
                   ' AND t02.t02_symbol_id_m20 = ' || psymbol
               ELSE
                   ' '
           END
        || ' AND t02.t02_trade_confirm_no IS NOT NULL
             GROUP BY t02_trade_confirm_no) t02
     INNER JOIN u07_trading_account u07
        ON t02.trd_acnt_id_u07 = u07.u07_id
     INNER JOIN u01_customer u01
        ON u07.u07_customer_id_u01 = u01.u01_id
      LEFT JOIN u02_customer_contact_info u02
        ON (u01.u01_id = u02.u02_customer_id_u01 AND u02.u02_is_default = 1)
     INNER JOIN u06_cash_account u06
        ON u07.u07_cash_account_id_u06 = u06.u06_id
     INNER JOIN t64_trade_confirmation_list t64
        ON t64.t64_trade_confirm_no = t02.t02_trade_confirm_no
      LEFT JOIN m151_trade_confirm_config m151
        ON m151.m151_id =
           nvl(u07.u07_trade_conf_config_id_m151, m151.m151_id)
      LEFT JOIN v12_trade_config_format v12
        ON v12.v12_id =
           nvl(u07.u07_trade_conf_format_id_v12,
               m151.m151_trade_confirm_format_v12)
     WHERE m151.m151_is_default =
           decode(nvl(u07.u07_trade_conf_config_id_m151, 0),
                  0,
                  1,
                  m151.m151_is_default)
       AND m151.m151_institute_id_m02 = '
        || pinstitute
        || CASE
               WHEN psignuploc IS NOT NULL
               THEN
                   ' AND u01.u01_signup_location_id_m0 = ' || psignuploc
               ELSE
                   ' '
           END;
    DBMS_OUTPUT.put_line (l_qry);
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
