DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link a
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M201_PRICEUSER_AGREEMENT';

    ----------- User INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.m201_priceuser_agreement@mubasher_db_link m201,
           mubasher_oms.m04_logins@mubasher_db_link m04
     WHERE m201.m201_user_id = m04.m04_id(+) AND m04.m04_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M158_PRICEUSER_AGREEMENT',
                 'M201_PRICEUSER_AGREEMENT',
                 l_source_count,
                 l_error_count_1,
                 '(M201_USER_ID) INVALID');

    -----------  Multiple Agreements for Same User -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM (  SELECT m201.m201_user_id
                FROM mubasher_oms.m201_priceuser_agreement@mubasher_db_link m201
            GROUP BY m201.m201_user_id
              HAVING COUNT (*) > 1);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M158_PRICEUSER_AGREEMENT',
                 'M201_PRICEUSER_AGREEMENT',
                 l_source_count,
                 l_error_count_2,
                 'MULTIPLE RECORDS FOR (M201_USER_ID)');
END;
/
