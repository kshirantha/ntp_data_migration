CREATE OR REPLACE PROCEDURE dfn_ntp.sp_h24_gl_cash_acc_sum_list (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2,
    pfromrownumber        NUMBER,
    ptorownumber          NUMBER,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT u06.u06_customer_no_u01,
                   u06.u06_display_name_u01,
                   u06.u06_display_name,
                   u06.u06_currency_code_m03,
                   u06.u06_institute_id_m02,
                   h24.h24_opening_balance,
                   h24.h24_deposits,
                   h24.h24_withdrawals,
                   h24.h24_buy,
                   h24.h24_sell,
                   h24.h24_charges,
                   h24.h24_refunds,
                   h24.h24_broker_commission,
                   h24.h24_exg_commission,
                   h24.h24_accrued_interest,
                   h24.h24_settled_balance,
                   h24.h24_blocked,
                   h24.h24_open_buy_blocked,
                   h24.h24_pending_withdraw,
                   h24.h24_manual_trade_blocked,
                   h24.h24_manual_full_blocked,
                   h24.h24_manual_transfer_blocked,
                   h24.h24_payable_blocked,
                   h24.h24_receivable_amount
      FROM vw_h24_gl_cash_account_summary h24
           JOIN u06_cash_account u06
               ON h24.h24_cash_account_id_u06 = u06.u06_id
     WHERE h24.h24_date BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, 'DD/MM/YYYY')
        || ''',''DD/MM/YYYY'') AND TO_DATE('''
        || TO_CHAR (pfromdate, 'DD/MM/YYYY')
        || ''',''DD/MM/YYYY'') + 0.99999';

    s1 :=
        fn_get_sp_data_query (psearchcriteria   => psearchcriteria,
                              l_qry             => l_qry,
                              psortby           => NULL, --Sorting will slow down the report, Not required for this report
                              ptorownumber      => ptorownumber,
                              pfromrownumber    => pfromrownumber);

    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/