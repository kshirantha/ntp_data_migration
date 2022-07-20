DECLARE
    l_source_count   NUMBER;
    l_error_count1   NUMBER;
    l_error_count2   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'M196_PENDNG_SYMBL_MRG_REQUESTS';

    ----------- Symbol Invalid -----------

    SELECT COUNT (*)
      INTO l_error_count1
      FROM mubasher_oms.m196_pendng_symbl_mrg_requests@mubasher_db_link m196,
           mubasher_oms.m77_symbols@mubasher_db_link m77
     WHERE m196.m196_symbol_id = m77.m77_id(+) AND m77.m77_id IS NULL;


    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M79_PENDING_SYMBL_MRG_REQUEST',
                 'M196_PENDNG_SYMBL_MRG_REQUESTS',
                 l_source_count,
                 l_error_count1,
                 '(M196_SYMBOL_ID) INVALID');

    ----------- Symbol Margin Group Invalid -----------

    SELECT COUNT (*)
      INTO l_error_count2
      FROM mubasher_oms.m196_pendng_symbl_mrg_requests@mubasher_db_link m196,
           mubasher_oms.m291_symbol_marginability_grps@mubasher_db_link m291
     WHERE     m196.m196_sym_margin_group = m291.m291_id(+)
           AND m291.m291_id IS NULL;


    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M79_PENDING_SYMBL_MRG_REQUEST',
                 'M196_PENDNG_SYMBL_MRG_REQUESTS',
                 l_source_count,
                 l_error_count2,
                 '(M196_SYM_MARGIN_GROUP) INVALID');
END;
/
