CREATE OR REPLACE PROCEDURE dfn_ntp.sp_comm_override_all_report (
    p_view   OUT SYS_REFCURSOR,
    prows    OUT NUMBER,
    p_d1         DATE,
    p_d2         DATE)
IS
    l_qry   VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT t01.t01_cl_ord_id AS order_no,
                   CASE t01.t01_side WHEN 1 THEN ''Buy'' WHEN 2 THEN ''Sell'' END
                       AS order_side,
                   v09.v09_description AS product,
                   t01.t01_symbol_code_m20 AS symbol,
                   t01.t01_exchange_code_m01 AS exchange_name,
                   u07.u07_display_name AS cust_portfolio,
                   t01.t01_quantity AS order_qty,
                   t01.t01_symbol_currency_code_m03 AS currency,
                   t01.t01_price AS price,
                   t01.t01_orig_commission AS origin_comm,
                   t01.t01_commission -t01.t01_orig_commission  AS override_comm,
                   u17_a.u17_full_name AS override_by,
                   t01.t01_db_created_date AS order_date
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
                       ON t01.t01_symbol_id_m20 = m20.m20_id
                   LEFT JOIN v09_instrument_types v09
                       ON m20.m20_instrument_type_id_v09 = v09.v09_id
             WHERE (t01.t01_orig_commission > 0 OR t01_orig_exg_commission > 0)'
        || ' AND t01.t01_db_created_date BETWEEN TO_DATE ('''
        || TO_CHAR (p_d1, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'') AND  TO_DATE ('''
        || TO_CHAR (p_d2, 'DD-MM-YYYY')
        || ''',''DD-MM-YYYY'')+ .99999';

    INSERT INTO temp (col_1, col_2, created_datetime)
         VALUES (l_qry, 'SP_COMMISSION_OVERRIDE_ALL_REPORT', SYSDATE);



    OPEN p_view FOR l_qry;
END;
/
