DECLARE
    l_source_count   NUMBER;
    l_error_count1   NUMBER;
    l_error_count2   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'T03_CASH_ACCOUNT';

    ----------- Customer INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count1
      FROM mubasher_oms.t03_cash_account@mubasher_db_link t03_oms,
           mubasher_oms.m01_customer@mubasher_db_link m01_oms
     WHERE     t03_oms.t03_profile_id = m01_oms.m01_customer_id(+)
           AND t03_oms.t03_branch_id > 0
           AND m01_oms.m01_customer_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U06_CASH_ACCOUNT',
                 'T03_CASH_ACCOUNT',
                 l_source_count,
                 l_error_count1,
                 '(T03_PROFILE_ID) INVALID');

    ----------- POSITIVE BALANCE WHEN HAVING A MARGIN DUE -----------

    SELECT COUNT (*)
      INTO l_error_count2
      FROM mubasher_oms.t03_cash_account@mubasher_db_link t03
     WHERE ABS (t03.t03_margin_due) > 0 AND t03.t03_balance > 0;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U06_CASH_ACCOUNT',
                 'T03_CASH_ACCOUNT',
                 l_source_count,
                 l_error_count2,
                 'POSITIVE BALANCE WHEN HAVING A MARGIN DUE');
END;
/
