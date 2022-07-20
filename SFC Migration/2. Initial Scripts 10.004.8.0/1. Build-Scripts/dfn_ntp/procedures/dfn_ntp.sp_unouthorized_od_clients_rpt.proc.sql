CREATE OR REPLACE PROCEDURE dfn_ntp.sp_unouthorized_od_clients_rpt (
    p_view                OUT SYS_REFCURSOR,
    prows                 OUT NUMBER,
    psortby                   VARCHAR2 DEFAULT NULL,
    pfromrownumber            NUMBER DEFAULT NULL,
    ptorownumber              NUMBER DEFAULT NULL,
    psearchcriteria           VARCHAR2 DEFAULT NULL,
    pfromdate                 DATE DEFAULT SYSDATE,
    ptodate                   DATE DEFAULT SYSDATE,
    ptype                     NUMBER DEFAULT 0, --1-local, 2-international,0-both
    pprimaryinstitution       NUMBER)
IS
    pdate   DATE := pfromdate;
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;

    IF ptype = 1
    THEN                                                               --local
        l_qry :=
               'SELECT u06.u06_id,
             u01.u01_external_ref_no,
			 u01.u01_customer_no,
             u06.u06_external_ref_no,
             u01.u01_display_name
                 customer_name,
             u06.u06_currency_code_m03,
             openning_balance,
             closing_balance,
             get_pfolio_val_by_cash_ac (
                 p_cash_ac_id           => u06.u06_id,
                 p_institution          => u06.u06_institute_id_m02,
                 p_computation_method   => m02.m02_price_type_for_margin,
                 p_check_buy_pending    => m02.m02_add_buy_pending_for_margin,
                 p_check_pledgedqty     => m02.m02_add_pledge_for_bp,
                 p_check_sym_margin     => m02.m02_add_sym_margin_for_margin)
                 AS portfolio_value,
             ROUND (
                 fn_get_group_buying_power (u06.u06_id,
                                            u06.u06_currency_code_m03,
                                            u01.u01_id),
                 2)
                 AS group_buying_power,
             u01.u01_id
      FROM (SELECT a.h02_cash_account_id_u06,
                   b.t02_cash_acnt_id_u06,
                   NVL (a.openning_balance, 0) openning_balance,
                   NVL (a.openning_balance, 0) + NVL (b.tran_amount_total, 0) AS closing_balance
            FROM (SELECT h02.h02_cash_account_id_u06,
                           NVL (h02.h02_balance, 0)
                         + NVL (h02.h02_payable_blocked, 0)
                         - NVL (h02.h02_receivable_amount, 0) AS openning_balance
                  FROM vw_h02_cash_account_summary h02
                  WHERE h02_date = TRUNC (SYSDATE - 5)) a,
                 (SELECT t02_cash_acnt_id_u06,
                         SUM (t02_amnt_in_stl_currency) tran_amount_total
                  FROM t02_transaction_log t02
                  WHERE     t02.t02_cash_settle_date BETWEEN
                   TRUNC (SYSDATE - 4) AND
                  TO_DATE('''
            || TO_CHAR (pdate, ' DD - MM - YYYY ')
            || ''', '' DD - MM - YYYY '') + .99999
                        AND t02_create_date >= SYSDATE - 10
                        AND t02.t02_amnt_in_stl_currency <> 0
                  GROUP BY t02_cash_acnt_id_u06) b
            WHERE     b.t02_cash_acnt_id_u06 = a.h02_cash_account_id_u06(+)
                  AND   NVL (a.openning_balance, 0)
                      + NVL (b.tran_amount_total, 0) <
                      0) t02
           JOIN u06_cash_account u06 ON u06_id = t02_cash_acnt_id_u06
           JOIN m02_institute m02
               ON     u06.u06_institute_id_m02 = m02.m02_id
                  AND u06.u06_currency_code_m03 = ''SAR''
                  AND NVL (u06.u06_margin_enabled, 0) = 0
           JOIN u01_customer u01 ON u06.u06_customer_id_u01 = u01.u01_id
      ORDER BY closing_balance';
    ELSE
        IF ptype = 2
        THEN                                                  -- international
            l_qry :=
                   'SELECT u06.u06_id,
             u01.u01_external_ref_no,
			 u01.u01_customer_no,
             u06.u06_external_ref_no,
             u01.u01_display_name
                 customer_name,
             u06.u06_currency_code_m03,
             openning_balance,
             closing_balance,
             get_pfolio_val_by_cash_ac (
                 p_cash_ac_id           => u06.u06_id,
                 p_institution          => u06.u06_institute_id_m02,
                 p_computation_method   => m02.m02_price_type_for_margin,
                 p_check_buy_pending    => m02.m02_add_buy_pending_for_margin,
                 p_check_pledgedqty     => m02.m02_add_pledge_for_bp,
                 p_check_sym_margin     => m02.m02_add_sym_margin_for_margin)
                 AS portfolio_value,
             ROUND (
                 fn_get_group_buying_power (u06.u06_id,
                                            u06.u06_currency_code_m03,
                                            u01.u01_id),
                 2)
                 AS group_buying_power,
             u01.u01_id
      FROM (SELECT a.h02_cash_account_id_u06,
                   b.t02_cash_acnt_id_u06,
                   NVL (a.openning_balance, 0) openning_balance,
                   NVL (a.openning_balance, 0) + NVL (b.tran_amount_total, 0) AS closing_balance
            FROM (SELECT h02.h02_cash_account_id_u06,
                           NVL (h02.h02_balance, 0)
                         + NVL (h02.h02_payable_blocked, 0)
                         - NVL (h02.h02_receivable_amount, 0) AS openning_balance
                  FROM vw_h02_cash_account_summary h02
                  WHERE h02_date = TRUNC (SYSDATE - 5)) a,
                 (SELECT t02_cash_acnt_id_u06,
                         SUM (t02_amnt_in_stl_currency) tran_amount_total
                  FROM t02_transaction_log t02
                  WHERE     t02.t02_cash_settle_date BETWEEN TRUNC (SYSDATE - 4) AND
                  TO_DATE('''
                || TO_CHAR (pdate, ' DD - MM - YYYY ')
                || ''', '' DD - MM - YYYY '') + .99999
                        AND t02_create_date >= SYSDATE - 10
                        AND t02.t02_amnt_in_stl_currency <> 0
                  GROUP BY t02_cash_acnt_id_u06) b
            WHERE     b.t02_cash_acnt_id_u06 = a.h02_cash_account_id_u06(+)
                  AND   NVL (a.openning_balance, 0)
                      + NVL (b.tran_amount_total, 0) <
                      0) t02
           JOIN u06_cash_account u06 ON u06_id = t02_cash_acnt_id_u06
           JOIN m02_institute m02
               ON     u06.u06_institute_id_m02 = m02.m02_id
                  AND u06.u06_currency_code_m03 != ''SAR''
                  AND NVL (u06.u06_margin_enabled, 0) = 0
           JOIN u01_customer u01 ON u06.u06_customer_id_u01 = u01.u01_id
      ORDER BY closing_balance';
        ELSE
            l_qry :=
                   'SELECT u06.u06_id,
             u01.u01_external_ref_no,
			 u01.u01_customer_no,
             u06.u06_external_ref_no,
             u01.u01_display_name
                 customer_name,
             u06.u06_currency_code_m03,
             openning_balance,
             closing_balance,
             get_pfolio_val_by_cash_ac (
                 p_cash_ac_id           => u06.u06_id,
                 p_institution          => u06.u06_institute_id_m02,
                 p_computation_method   => m02.m02_price_type_for_margin,
                 p_check_buy_pending    => m02.m02_add_buy_pending_for_margin,
                 p_check_pledgedqty     => m02.m02_add_pledge_for_bp,
                 p_check_sym_margin     => m02.m02_add_sym_margin_for_margin)
                 AS portfolio_value,
             ROUND (
                 fn_get_group_buying_power (u06.u06_id,
                                            u06.u06_currency_code_m03,
                                            u01.u01_id),
                 2)
                 AS group_buying_power,
             u01.u01_id
      FROM (SELECT a.h02_cash_account_id_u06,
                   b.t02_cash_acnt_id_u06,
                   NVL (a.openning_balance, 0) openning_balance,
                   NVL (a.openning_balance, 0) + NVL (b.tran_amount_total, 0) AS closing_balance
            FROM (SELECT h02.h02_cash_account_id_u06,
                           NVL (h02.h02_balance, 0)
                         + NVL (h02.h02_payable_blocked, 0)
                         - NVL (h02.h02_receivable_amount, 0) AS openning_balance
                  FROM vw_h02_cash_account_summary h02
                  WHERE h02_date = TRUNC (SYSDATE - 5)) a,
                 (SELECT t02_cash_acnt_id_u06,
                         SUM (t02_amnt_in_stl_currency) tran_amount_total
                  FROM t02_transaction_log t02
                  WHERE     t02.t02_cash_settle_date BETWEEN  TRUNC (SYSDATE - 4) AND
                  TO_DATE('''
                || TO_CHAR (pdate, ' DD - MM - YYYY ')
                || ''', '' DD - MM - YYYY '') + .99999
                        AND t02_create_date >= SYSDATE - 10
                        AND t02.t02_amnt_in_stl_currency <> 0
                  GROUP BY t02_cash_acnt_id_u06) b
            WHERE     b.t02_cash_acnt_id_u06 = a.h02_cash_account_id_u06(+)
                  AND   NVL (a.openning_balance, 0)
                      + NVL (b.tran_amount_total, 0) <
                      0) t02
           JOIN u06_cash_account u06 ON u06_id = t02_cash_acnt_id_u06
           JOIN m02_institute m02
               ON     u06.u06_institute_id_m02 = m02.m02_id
                  AND NVL (u06.u06_margin_enabled, 0) = 0
           JOIN u01_customer u01 ON u06.u06_customer_id_u01 = u01.u01_id
      ORDER BY closing_balance';
        END IF;
    END IF;

    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              psortby,
                              ptorownumber,
                              pfromrownumber);
    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2
        INTO prows;
END;
/