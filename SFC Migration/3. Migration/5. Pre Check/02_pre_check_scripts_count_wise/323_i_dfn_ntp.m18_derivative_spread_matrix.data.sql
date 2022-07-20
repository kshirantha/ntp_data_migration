DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'M391_FUTURES_SPREAD_MATRIX';

    ----------- Symbol 1 INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.m391_futures_spread_matrix@mubasher_db_link m391,
           mubasher_oms.m77_symbols@mubasher_db_link m77
     WHERE m391.m391_symbol_1 = m77.m77_symbol(+) AND m77.m77_symbol IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M18_DERIVATIVE_SPREAD_MATRIX',
                 'M391_FUTURES_SPREAD_MATRIX',
                 l_source_count,
                 l_error_count_1,
                 '(M391_SYMBOL_1) INVALID');

    ----------- Symbol 2 INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.m391_futures_spread_matrix@mubasher_db_link m391,
           mubasher_oms.m77_symbols@mubasher_db_link m77
     WHERE m391.m391_symbol_2 = m77.m77_symbol(+) AND m77.m77_symbol IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M18_DERIVATIVE_SPREAD_MATRIX',
                 'M391_FUTURES_SPREAD_MATRIX',
                 l_source_count,
                 l_error_count_2,
                 '(M391_SYMBOL_2) INVALID');
END;
/
