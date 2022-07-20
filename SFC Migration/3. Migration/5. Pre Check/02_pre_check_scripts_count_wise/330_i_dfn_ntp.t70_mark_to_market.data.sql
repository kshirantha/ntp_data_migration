DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
    l_error_count_3   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'T119_MARK_TO_MARKET';

    ----------- Trading Account INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.t119_mark_to_market@mubasher_db_link t119,
           mubasher_oms.u05_security_accounts@mubasher_db_link u05
     WHERE t119.t119_security_ac_id = u05.u05_id(+) AND u05.u05_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T70_MARK_TO_MARKET',
                 'T119_MARK_TO_MARKET',
                 l_source_count,
                 l_error_count_1,
                 '(T119_SECURITY_AC_ID) INVALID');

    ----------- DUPLICATE (T119_SECURITY_AC_ID, T119_EXCHANGE, T119_SYMBOL) COMBINATION -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM (SELECT t119_id
              FROM mubasher_oms.t119_mark_to_market@mubasher_db_link
            MINUS
              SELECT MAX (t119_id) AS t119_id
                FROM mubasher_oms.t119_mark_to_market@mubasher_db_link
            GROUP BY t119_security_ac_id, t119_exchange, t119_symbol
              HAVING COUNT (*) > 1);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES (
                    'T70_MARK_TO_MARKET',
                    'T119_MARK_TO_MARKET',
                    l_source_count,
                    l_error_count_2,
                    'DUPLICATE (T119_SECURITY_AC_ID, T119_EXCHANGE, T119_SYMBOL) COMBINATION');

    ----------- DUPLICATE (T119_DATE, T119_SECURITY_AC_ID, T119_EXCHANGE, T119_SYMBOL) COMBINATION -----------

    SELECT COUNT (*)
      INTO l_error_count_3
      FROM (SELECT t119_id
              FROM mubasher_oms.t119_mark_to_market@mubasher_db_link
            MINUS
              SELECT MAX (t119_id) AS t119_id
                FROM mubasher_oms.t119_mark_to_market@mubasher_db_link
            GROUP BY TRUNC (t119_date),
                     t119_security_ac_id,
                     t119_exchange,
                     t119_symbol
              HAVING COUNT (*) > 1);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES (
                    'T70_MARK_TO_MARKET',
                    'T119_MARK_TO_MARKET',
                    l_source_count,
                    l_error_count_3,
                    'DUPLICATE (T119_DATE, T119_SECURITY_AC_ID, T119_EXCHANGE, T119_SYMBOL) COMBINATION');
END;
/
