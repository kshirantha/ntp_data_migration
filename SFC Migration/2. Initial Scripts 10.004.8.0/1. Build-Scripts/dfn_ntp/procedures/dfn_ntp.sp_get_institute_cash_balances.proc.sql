CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_institute_cash_balances (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2,
    pfromrownumber        NUMBER,
    ptorownumber          NUMBER,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE,
    ptodate               DATE,
    pinstitute            NUMBER)
IS
    p_date   DATE := SYSDATE;
    l_qry    VARCHAR2 (10000);
    s1       VARCHAR2 (15000);
    s2       VARCHAR2 (15000);
BEGIN
    IF (TRUNC (p_date) = TRUNC (pfromdate))
    THEN
        l_qry :=
               'SELECT SYSDATE AS as_of_date,
                   institute.m16_name,
                   institute.m16_name_lang,
                   institute.m93_branch_name,
                   institute.v01_description,
                   institute.v01_description_lang,
                   institute.m93_accountno,
                   institute.m93_currency_code_m03,
                   institute.m93_balance,
                   customer.tot_cust_balance,
                   institute.m93_balance - customer.tot_cust_balance
                       AS difference
              FROM (SELECT m16.m16_name,
                           m16.m16_name_lang,
                           m93.m93_branch_name,
                           v01.v01_description,
                           v01.v01_description_lang,
                           m93.m93_accountno,
                           m93.m93_balance,
                           m93.m93_currency_code_m03
                      FROM m93_bank_accounts m93
                           JOIN m16_bank m16
                               ON     m93.m93_bank_id_m16 = m16.m16_id
                                  AND m93.m93_is_default_omnibus = 1
                                  AND m93.m93_institution_id_m02 = '
            || pinstitute
            || ' JOIN v01_system_master_data v01
                               ON     m93.m93_account_type_id_v01 =
                                          v01.v01_id
                                  AND v01.v01_type = 43) institute
                   LEFT JOIN
                   (SELECT u06.u06_currency_code_m03,
                           SUM (
                                 u06.u06_balance
                               + u06.u06_payable_blocked
                               - u06.u06_receivable_amount)
                               AS tot_cust_balance
                      FROM u06_cash_account u06
                           JOIN u01_customer u01
                               ON     u06.u06_customer_id_u01 = u01.u01_id
                                  AND u01.u01_account_type_id_v01 <> 1
                                  AND u06.u06_institute_id_m02 = '
            || pinstitute
            || ' GROUP BY u06.u06_currency_code_m03) customer
                       ON institute.m93_currency_code_m03 =
                              customer.u06_currency_code_m03';
    ELSE
        l_qry :=
               'SELECT SYSDATE AS as_of_date,
                   institute.m16_name,
                   institute.m16_name_lang,
                   institute.m93_branch_name,
                   institute.v01_description,
                   institute.v01_description_lang,
                   institute.m93_accountno,
                   institute.m93_currency_code_m03,
                   institute.m93_balance,
                   customer.tot_cust_balance,
                   institute.m93_balance - customer.tot_cust_balance
                       AS difference
              FROM (SELECT m16.m16_name,
                           m16.m16_name_lang,
                           m93.m93_branch_name,
                           v01.v01_description,
                           v01.v01_description_lang,
                           m93.m93_accountno,
                           m93.m93_balance,
                           m93.m93_currency_code_m03
                      FROM h10_bank_accounts_summary h10
                           JOIN m93_bank_accounts m93
                               ON     h10.h10_account_id_m93 = m93.m93_id
                                  AND h10.h10_date =  TO_DATE('''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'')
            AND h10.h10_institute_id_m02 = '
            || pinstitute
            || ' JOIN m16_bank m16
                               ON     m93.m93_bank_id_m16 = m16.m16_id
                                  AND m93.m93_is_default_omnibus = 1
                                  AND m93.m93_institution_id_m02 = '
            || pinstitute
            || ' JOIN v01_system_master_data v01
                               ON     m93.m93_account_type_id_v01 =
                                          v01.v01_id
                                  AND v01.v01_type = 43) institute
                   LEFT JOIN
                   (SELECT h02.h02_currency_code_m03,
                           SUM (
                                 h02.h02_balance
                               + h02.h02_payable_blocked
                               - h02.h02_receivable_amount)
                               AS tot_cust_balance
                      FROM vw_h02_cash_account_summary h02
                           JOIN u01_customer u01
                               ON     h02.h02_cash_account_id_u06 =
                                          u01.u01_id
                                  AND h02.h02_date = TO_DATE('''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'')
            AND u01.u01_account_type_id_v01 <> 1
                    GROUP BY h02.h02_currency_code_m03) customer
                       ON institute.m93_currency_code_m03 =
                              customer.h02_currency_code_m03';
    END IF;

    IF (psearchcriteria IS NOT NULL)
    THEN
        s1 := ' WHERE ' || psearchcriteria;
        s2 :=
               'SELECT COUNT(*) FROM ('
            || l_qry
            || ') WHERE '
            || psearchcriteria;
    ELSE
        s1 := '';
        s2 := 'SELECT COUNT(*) FROM (' || l_qry || ')';
    END IF;

    IF psortby IS NOT NULL
    THEN
        OPEN p_view FOR
               'SELECT t2.*
FROM (SELECT t1.*, rownum rnum
        FROM (SELECT t3.*, row_number() OVER(ORDER BY '
            || psortby
            || ') runm
              FROM ('
            || l_qry
            || ') t3'
            || s1
            || ') t1 WHERE rownum <= '
            || ptorownumber
            || ') t2 WHERE rnum >= '
            || pfromrownumber;
    ELSE
        OPEN p_view FOR
               'SELECT t2.* FROM (SELECT t1.*, rownum rn FROM (
      SELECT * FROM ('
            || l_qry
            || ')'
            || s1
            || ') t1 WHERE rownum <= '
            || ptorownumber
            || ') t2 WHERE rn >= '
            || pfromrownumber;
    END IF;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/