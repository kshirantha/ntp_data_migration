DECLARE
    l_source_count   NUMBER;
    l_error_count1   NUMBER;
    l_error_count2   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'M77_OFLINE_SYMBOLS_UPDATE_LOG';

    ----------- Exchange INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count1
      FROM mubasher_oms.m77_ofline_symbols_update_log@mubasher_db_link m77
     WHERE    m77.m77_exchange IS NULL
           OR m77.m77_exchange NOT IN
                  (SELECT m11_exchangecode
                     FROM mubasher_oms.m11_exchanges@mubasher_db_link);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M160_OFFLINE_SYMBOL_UPDATE_LOG',
                 'M77_OFLINE_SYMBOLS_UPDATE_LOG',
                 l_source_count,
                 l_error_count1,
                 '(M77_EXCHANGE) INVALID');

    ----------- Symbol Invalid -----------

    SELECT COUNT (*)
      INTO l_error_count2
      FROM mubasher_oms.m77_ofline_symbols_update_log@mubasher_db_link m77
     WHERE    m77.m77_symbol IS NULL
           OR m77.m77_symbol NOT IN
                  (SELECT m77_symbol
                     FROM mubasher_oms.m77_symbols@mubasher_db_link);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M160_OFFLINE_SYMBOL_UPDATE_LOG',
                 'M77_OFLINE_SYMBOLS_UPDATE_LOG',
                 l_source_count,
                 l_error_count2,
                 '(M77_SYMBOL) INVALID');
END;
/