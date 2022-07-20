CREATE OR REPLACE PROCEDURE dfn_ntp.sp_brok_bank_ac_cash_statement (
    p_view             OUT SYS_REFCURSOR,
    prows              OUT NUMBER,
    psearchcriteria        VARCHAR2 DEFAULT NULL,
    pbank_account_id       NUMBER,
    pinst_id               NUMBER DEFAULT 1,
    pfromdate              DATE DEFAULT SYSDATE,
    ptodate                DATE DEFAULT SYSDATE)
IS
    l_qry           VARCHAR2 (15000);
    l_count         NUMBER;
    l_opening_bal   NUMBER;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM h10_bank_accounts_summary
     WHERE     h10_date = TRUNC (pfromdate - 1)
           AND h10_account_id_m93 = pbank_account_id;

    IF (l_count > 0)
    THEN
        SELECT h10_balance
          INTO l_opening_bal
          FROM h10_bank_accounts_summary
         WHERE     h10_date = TRUNC (pfromdate - 1)
               AND h10_account_id_m93 = pbank_account_id;
    ELSE
        l_opening_bal := 0;
    END IF;

    l_qry := 'SELECT id,
       executed_date,
       posted_date,
       action,
       description,
       amount,
       customer_no,
       u06_display_name,
       t05_cust_cash_acc_id_u06,
       CASE
           WHEN amount > 0 THEN amount
           ELSE TO_NUMBER (NULL)
       END
           AS cr,
       CASE
           WHEN amount <= 0 THEN ABS (amount)
           ELSE TO_NUMBER (NULL)
       END
           AS dr,
       SUM (amount) OVER (ORDER BY executed_date, id)
           AS balance,
       SUM(CASE
               WHEN action = ''DEPOST'' THEN amount
               ELSE 0
           END)
           OVER ()
           tot_deposit,
       SUM(CASE
               WHEN action = ''WITHDR'' THEN amount
               ELSE 0
           END)
           OVER ()
           tot_withdrawals,
       SUM(CASE
               WHEN action = ''STLBUY'' THEN amount
               ELSE 0
           END)
           OVER ()
           tot_buy,
       SUM(CASE
               WHEN action = ''STLSEL'' THEN amount
               ELSE 0
           END)
           OVER ()
           tot_sell,
       SUM(CASE
               WHEN action NOT IN
                            (''WITHDR'',
                             ''DEPOST'',
                             ''STLSEL'',
                             ''STLBUY'',
                             ''OPENBALANCE'')
               THEN
                   amount
               ELSE
                   0
           END)
           OVER ()
           other,
       SUM (amount) OVER () close_balance,
       SUM(CASE
               WHEN action = ''OPENBALANCE'' THEN amount
               ELSE 0
           END)
           OVER ()
           open_balance
FROM   (SELECT   0 AS id,
                 TO_DATE(''' || TO_CHAR (pfromdate, ' DD - MM - YYYY ')|| ''' ,'' DD - MM - YYYY '')  AS executed_date,
                 TO_DATE(''' || TO_CHAR (pfromdate, ' DD - MM - YYYY ')|| ''' ,'' DD - MM - YYYY '') -1  AS posted_date,
                 ''OPENBALANCE'' AS action,
                 ''Opening Balance'' AS description, ' ||
                 l_opening_bal || ' AS amount,
                 NULL AS customer_no,
                 NULL AS u06_display_name,
                 NULL AS t05_cust_cash_acc_id_u06
          FROM   DUAL
        UNION ALL
        SELECT   t05.t05_id AS id,
                 t05.t05_txn_date AS executed_date,
                 t05.t05_settle_date AS posted_date,
                 t05.t05_txn_code_m97 AS action,
                 t05.t05_reference_doc_narration AS description,
                 t05.t05_amnt_in_stl_currency AS amount,
                 u06_customer_no_u01 as customer_no,
                 u06.u06_display_name  ,
                 t05_cust_cash_acc_id_u06
          FROM   t05_institute_cash_acc_log t05
          LEFT JOIN vw_u06_cash_account_base u06 ON t05.t05_cust_cash_acc_id_u06 = u06.u06_id
          WHERE  t05.t05_txn_date BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, ' DD - MM - YYYY ')
        || ''' ,
        ''DD - MM - YYYY '') AND
       TO_DATE(
       ''' || TO_CHAR (ptodate, ' DD - MM - YYYY ')|| ''' ,
        '' DD - MM - YYYY '') + 0.99999
                 AND t05.t05_institute_bank_id_m93 =' || pbank_account_id || ' AND t05.t05_institute_id_m02 = ' || pinst_id ||')
ORDER BY   executed_date';

    EXECUTE IMMEDIATE
           'SELECT COUNT ( * ) FROM ('
        || l_qry
        || ')'
        || CASE
               WHEN psearchcriteria IS NOT NULL
               THEN
                   ' WHERE ' || psearchcriteria
               ELSE
                   ''
           END
        INTO prows;

    OPEN p_view FOR
           'SELECT t2.* FROM (SELECT t1.*, ROWNUM rnum FROM (SELECT t3.* '
        || ' FROM ('
        || l_qry
        || ') t3'
        || CASE
               WHEN psearchcriteria IS NOT NULL
               THEN
                   ' WHERE ' || psearchcriteria
               ELSE
                   ''
           END
        || ') t1) t2';
END;
/
