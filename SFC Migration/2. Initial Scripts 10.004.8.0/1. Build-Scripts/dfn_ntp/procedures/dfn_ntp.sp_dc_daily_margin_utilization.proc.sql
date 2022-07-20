CREATE OR REPLACE PROCEDURE dfn_ntp.sp_dc_daily_margin_utilization (
    p_view               OUT SYS_REFCURSOR,
    prows                OUT NUMBER,
    pinstituteid      IN     NUMBER,
    pcustomerid       IN     VARCHAR2 DEFAULT NULL,
    pfromdate         IN     DATE,
    ptodate           IN     DATE,
    psortby           IN     VARCHAR2 DEFAULT NULL,
    pfromrownumber    IN     NUMBER DEFAULT NULL,
    ptorownumber      IN     NUMBER DEFAULT NULL,
    psearchcriteria   IN     VARCHAR2 DEFAULT NULL)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT
                  u01.u01_id,
                  u01.u01_customer_no,
                  u01.u01_external_ref_no,
                  u01.u01_display_name,
                  u07.u07_id,
                  u07.u07_display_name,
                  u06.u06_display_name,
                  u06.u06_id,
                  u06.u06_currency_code_m03,
                  ABS(ROUND(SUM(NVL(h02.h02_margin_utilized,0)),5)) AS total_margin_utilization,
                  ABS (ROUND (SUM (NVL (h02.h02_margin_utilized, 0)) / COUNT(u06.u06_id),5)) AS average_margin_utilization
                FROM
                (SELECT u06_id AS h02_cash_account_id_u06,
                 TRUNC (SYSDATE),
                   u06.u06_balance
                 + u06.u06_payable_blocked
                 - u06.u06_receivable_amount
                     AS h02_margin_utilized
            FROM u06_cash_account u06
           WHERE     u06.u06_margin_enabled = 1
                 AND (u06.u06_balance + u06.u06_payable_blocked - u06.u06_receivable_amount) <
                         0
                    AND TRUNC (SYSDATE) BETWEEN TO_DATE ('''
        || pfromdate
        || ''')
                    AND TO_DATE('''
        || ptodate
        || ''') + 0.99999
                UNION ALL
                    SELECT
                        h02.h02_cash_account_id_u06,
                        h02.h02_date,
                        h02.h02_margin_utilized
                    FROM
                        h02_cash_account_summary_all h02
                    WHERE
                        h02.h02_date BETWEEN TO_DATE('''
        || pfromdate
        || ''')
                        AND TO_DATE('''
        || ptodate
        || ''') + 0.99999) h02
                JOIN u06_cash_account u06 ON h02.h02_cash_account_id_u06 = u06.u06_id '
        || ' JOIN u01_customer u01 ON u01.u01_id = u06.u06_customer_id_u01 '
        || CASE
               WHEN pcustomerid IS NOT NULL
               THEN
                   ' AND u01.u01_id = ' || pcustomerid
               ELSE
                   ''
           END
        || ' JOIN u07_trading_account u07 ON u06.u06_id = u07.u07_cash_account_id_u06
            WHERE u06.u06_margin_enabled = 1
                AND h02.h02_margin_utilized <> 0
                AND u01.u01_institute_id_m02 = '
        || pinstituteid
        || ' GROUP BY
                u01.u01_id,
                u01.u01_external_ref_no,
                u01.u01_customer_no,
                u01.u01_display_name,
                u07.u07_id,
                u07.u07_display_name,
                u06.u06_display_name,
                u06.u06_id,
                u06.u06_currency_code_m03';

    s1 :=
        fn_get_sp_data_query (psearchcriteria   => psearchcriteria,
                              psortby           => psortby,
                              ptorownumber      => ptorownumber,
                              pfromrownumber    => pfromrownumber,
                              l_qry             => l_qry);

    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/
