DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
    l_error_count_3   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'T87_AUTHORIZATION_REQUEST';

    ----------- Trading Account INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.t87_authorization_request@mubasher_db_link t87,
           mubasher_oms.u05_security_accounts@mubasher_db_link u05
     WHERE t87_u06_security_ac_id = u05.u05_id(+) AND u05.u05_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T15_AUTHORIZATION_REQUEST',
                 'T87_AUTHORIZATION_REQUEST',
                 l_source_count,
                 l_error_count_1,
                 '(T87_U06_SECURITY_AC_ID) INVALID');

    ----------- Cash Account INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.t87_authorization_request@mubasher_db_link t87,
           mubasher_oms.u05_security_accounts@mubasher_db_link u05,
           mubasher_oms.t03_cash_account@mubasher_db_link t03
     WHERE     t87.t87_u06_security_ac_id = u05.u05_id(+)
           AND u05.u05_cash_account_id = t03.t03_account_id(+)
           AND t03.t03_account_id IS NULL;


    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T15_AUTHORIZATION_REQUEST',
                 'T87_AUTHORIZATION_REQUEST',
                 l_source_count,
                 l_error_count_2,
                 'MAPPING (T03_ACCOUNT_ID) INVALID');

    ----------- Customer INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_3
      FROM mubasher_oms.t87_authorization_request@mubasher_db_link t87,
           mubasher_oms.u05_security_accounts@mubasher_db_link u05,
           mubasher_oms.m01_customer@mubasher_db_link m01
     WHERE     t87.t87_u06_security_ac_id = u05.u05_id(+)
           AND u05.u05_customer_id = m01.m01_customer_id(+)
           AND m01.m01_customer_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T15_AUTHORIZATION_REQUEST',
                 'T87_AUTHORIZATION_REQUEST',
                 l_source_count,
                 l_error_count_3,
                 'MAPPING (M01_CUSTOMER_ID) INVALID');
END;
/
