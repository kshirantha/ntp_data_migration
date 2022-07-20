DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
    l_error_count_3   NUMBER;
    l_error_count_4   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'U06_ROUTING_ACCOUNTS';

    ----------- Commission Group NULL -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.u06_routing_accounts@mubasher_db_link u06_oms,
           mubasher_oms.u05_security_accounts@mubasher_db_link u05_oms
     WHERE     u06_oms.u06_security_ac_id = u05_oms.u05_id
           AND u05_oms.u05_branch_id > 0
           AND u06_oms.u06_commision_group_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U07_TRADING_ACCOUNT',
                 'U06_ROUTING_ACCOUNTS',
                 l_source_count,
                 l_error_count_1,
                 '(U06_COMMISION_GROUP_ID) NULL');

    ----------- Commission Group INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.u06_routing_accounts@mubasher_db_link u06_oms,
           mubasher_oms.u05_security_accounts@mubasher_db_link u05_oms,
           mubasher_oms.m51_commission_groups@mubasher_db_link m51
     WHERE     u06_oms.u06_security_ac_id = u05_oms.u05_id
           AND u05_oms.u05_branch_id > 0
           AND u06_oms.u06_commision_group_id =
                   m51.m51_commission_group_id(+)
           AND m51.m51_commission_group_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U07_TRADING_ACCOUNT',
                 'U06_ROUTING_ACCOUNTS',
                 l_source_count,
                 l_error_count_2,
                 '(U06_COMMISION_GROUP_ID) INVALID');

    ----------- Customer INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_3
      FROM mubasher_oms.u06_routing_accounts@mubasher_db_link u06_oms,
           mubasher_oms.u05_security_accounts@mubasher_db_link u05_oms,
           mubasher_oms.m01_customer@mubasher_db_link m01_oms
     WHERE     u06_oms.u06_security_ac_id = u05_oms.u05_id
           AND u05_oms.u05_customer_id = m01_oms.m01_customer_id(+)
           AND u05_oms.u05_branch_id > 0
           AND m01_oms.m01_customer_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U07_TRADING_ACCOUNT',
                 'U06_ROUTING_ACCOUNTS',
                 l_source_count,
                 l_error_count_3,
                 '(CUSTOMER_ID) INVALID');

      ----------- Duplicate Security Account and Exchnage Combination -----------

      SELECT NVL (MAX (COUNT (*)), 0)
        INTO l_error_count_4
        FROM mubasher_oms.u06_routing_accounts@mubasher_db_link u06_oms,
             mubasher_oms.u05_security_accounts@mubasher_db_link u05_oms
       WHERE     u06_oms.u06_security_ac_id = u05_oms.u05_id
             AND u05_oms.u05_branch_id > 0
    GROUP BY u06_oms.u06_security_ac_id, u06_oms.u06_exchange
      HAVING COUNT (*) > 1;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U07_TRADING_ACCOUNT',
                 'U06_ROUTING_ACCOUNTS',
                 l_source_count,
                 l_error_count_4,
                 'DUPLICATE (U06_SECURITY_AC_ID, U06_EXCHANGE) COMBINATION');
END;
/
