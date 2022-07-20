DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link a
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'S11_BANK_ACCOUNTS_SUMMARY';

    ----------- Bank Account INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count
      FROM mubasher_oms.s11_bank_accounts_summary@mubasher_db_link s11,
           mubasher_oms.t14_bank_accounts@mubasher_db_link t14
     WHERE     s11.s11_account_id = t14.t14_account_id(+)
           AND t14.t14_account_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('H10_BANK_ACCOUNTS_SUMMARY',
                 'S11_BANK_ACCOUNTS_SUMMARY',
                 l_source_count,
                 l_error_count,
                 '(S11_ACCOUNT_ID) INVALID');
END;
/
