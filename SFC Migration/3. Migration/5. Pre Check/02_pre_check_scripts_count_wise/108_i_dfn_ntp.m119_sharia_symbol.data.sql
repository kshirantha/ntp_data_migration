DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'U16_INST_SHARIA_SYMBOLS';

    ----------- Invalid Symbol -----------

    SELECT COUNT (*)
      INTO l_error_count
      FROM mubasher_oms.u16_inst_sharia_symbols@mubasher_db_link u16,
           mubasher_oms.m77_symbols@mubasher_db_link m77
     WHERE u16.u16_symbol = m77.m77_symbol(+) AND m77.m77_symbol IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M119_SHARIA_SYMBOL',
                 'U16_INST_SHARIA_SYMBOLS',
                 l_source_count,
                 l_error_count,
                 '(U16_SYMBOL) INVALID');
END;
/
