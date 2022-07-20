DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
    l_error_count_3   NUMBER;
    l_error_count_4   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link a
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'T17_PENDING_PLEDGE';

    ----------- Security Account & Exchange INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.t17_pending_pledge@mubasher_db_link t17,
           mubasher_oms.u06_routing_accounts@mubasher_db_link u06
     WHERE     t17.t17_security_ac_id = u06.u06_security_ac_id(+)
           AND t17.t17_exchange = u06.u06_exchange(+)
           AND u06.u06_security_ac_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T20_PENDING_PLEDGE',
                 'T17_PENDING_PLEDGE',
                 l_source_count,
                 l_error_count_1,
                 '(T17_SECURITY_AC_ID, T17_EXCHANGE) INVALID');

    ----------- Symbol Code INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.t17_pending_pledge@mubasher_db_link t17,
           mubasher_oms.m77_symbols@mubasher_db_link m77
     WHERE     t17.t17_symbol = m77.m77_symbol(+)
           AND t17.t17_exchange = m77.m77_exchange(+)
           AND m77.m77_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T20_PENDING_PLEDGE',
                 'T17_PENDING_PLEDGE',
                 l_source_count,
                 l_error_count_2,
                 '(T17_SYMBOL) INVALID');

    ----------- Pledge Type INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_3
      FROM mubasher_oms.t17_pending_pledge@mubasher_db_link t17
     WHERE t17.t17_pledge_type NOT IN ('I', 'O');

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T20_PENDING_PLEDGE',
                 'T17_PENDING_PLEDGE',
                 l_source_count,
                 l_error_count_3,
                 '(T17_PLEDGE_TYPE) NOT IN (I, O)');

    ----------- Transaction Number INVALID (Not a Number)-----------

    SELECT COUNT (*)
      INTO l_error_count_4
      FROM mubasher_oms.t17_pending_pledge@mubasher_db_link t17
     WHERE NOT REGEXP_LIKE (t17_transaction_number, '^[0-9]*$');

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T20_PENDING_PLEDGE',
                 'T17_PENDING_PLEDGE',
                 l_source_count,
                 l_error_count_4,
                 '(T17_TRANSACTION_NUMBER) IS NOT A NUMBER');
END;
/
