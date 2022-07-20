DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M90_SYMBOL_MARGINABILITY';

    ----------- Symbol Margin Group INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.m90_symbol_marginability@mubasher_db_link m90,
           mubasher_oms.m291_symbol_marginability_grps@mubasher_db_link m291
     WHERE     m90.m90_sym_margin_group = m291.m291_id(+)
           AND m291.m291_id IS NULL;


    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M78_SYMBOL_MARGINABILITY',
                 'M90_SYMBOL_MARGINABILITY',
                 l_source_count,
                 l_error_count_1,
                 '(M90_SYM_MARGIN_GROUP) INVALID');

    ----------- Symbol INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.m90_symbol_marginability@mubasher_db_link m90,
           mubasher_oms.m77_symbols@mubasher_db_link m77
     WHERE m90.m90_symbol_id = m77.m77_id(+) AND m77.m77_id IS NULL;


    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M78_SYMBOL_MARGINABILITY',
                 'M90_SYMBOL_MARGINABILITY',
                 l_source_count,
                 l_error_count_2,
                 '(M90_SYMBOL_ID) INVALID');
END;
/
