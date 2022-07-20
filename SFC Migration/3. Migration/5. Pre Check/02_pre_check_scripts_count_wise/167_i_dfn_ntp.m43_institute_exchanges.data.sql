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
           AND table_name = 'M39_BROKER_EXEC_BROKER_MAP';

    ----------- Exchange INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.m39_broker_exec_broker_map@mubasher_db_link m39,
           mubasher_oms.m11_exchanges@mubasher_db_link m11
     WHERE     m39.m39_exchange = m11.m11_exchangecode(+)
           AND m11.m11_exchangecode IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M43_INSTITUTE_EXCHANGES',
                 'M39_BROKER_EXEC_BROKER_MAP',
                 l_source_count,
                 l_error_count_1,
                 '(M39_EXCHANGE) INVALID');

    ----------- Institute INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.m39_broker_exec_broker_map@mubasher_db_link m39,
           mubasher_oms.m05_branches@mubasher_db_link m05
     WHERE     m39.m39_from_broker = m05.m05_branch_id(+)
           AND m05.m05_branch_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M43_INSTITUTE_EXCHANGES',
                 'M39_BROKER_EXEC_BROKER_MAP',
                 l_source_count,
                 l_error_count_2,
                 '(M39_FROM_BROKER) INVALID');


    ----------- Duplicate Exchange, Institution Combination -----------

    SELECT COUNT (*)
      INTO l_error_count_3
      FROM (  SELECT m39_from_broker,
                     m39_exchange,
                     ex01.ex01_type,
                     COUNT (*)
                FROM mubasher_oms.m39_broker_exec_broker_map@mubasher_db_link m128,
                     mubasher_oms.ex01_executing_institution@mubasher_db_link ex01
               WHERE m128.m39_to_broker = ex01.ex01_id
            GROUP BY m39_from_broker, m39_exchange, ex01.ex01_type
              HAVING COUNT (*) > 1);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M43_INSTITUTE_EXCHANGES',
                 'M39_BROKER_EXEC_BROKER_MAP',
                 l_source_count,
                 l_error_count_3,
                 'DUPLICATE (M39_FROM_BROKER, M39_EXCHANGE) COMBINATION');
END;
/
