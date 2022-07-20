CREATE OR REPLACE PROCEDURE dfn_ntp.sp_populate_rpt_summary_tbls (
    p_date DATE DEFAULT SYSDATE)
IS
    l_date   DATE := TRUNC (p_date);
BEGIN
    DELETE h10_bank_accounts_summary a
     WHERE a.h10_date = l_date;

    INSERT INTO h10_bank_accounts_summary (h10_date,
                                           h10_account_id_m93,
                                           h10_institute_id_m02,
                                           h10_account_no,
                                           h10_balance,
                                           h10_currency,
                                           h10_blocked_amount,
                                           h10_od_limit)
        SELECT l_date,
               a.m93_id,
               m93_institution_id_m02,
               a.m93_accountno,
               a.m93_balance,
               a.m93_currency_code_m03,
               a.m93_blocked_amount,
               a.m93_od_limit
          FROM m93_bank_accounts a;
END;
/