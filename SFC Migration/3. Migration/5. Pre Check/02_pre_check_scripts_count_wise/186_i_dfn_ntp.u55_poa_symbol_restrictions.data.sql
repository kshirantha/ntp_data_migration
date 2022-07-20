DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
    l_error_count_3   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M175_CUTOMER_POA_SYMBOLS';

    ----------- Symbol INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.m175_cutomer_poa_symbols@mubasher_db_link m175,
           mubasher_oms.m77_symbols@mubasher_db_link m77
     WHERE m175.m175_symbol_id = m77.m77_id(+) AND m77.m77_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U55_POA_SYMBOL_RESTRICTIONS',
                 'M175_CUTOMER_POA_SYMBOLS',
                 l_source_count,
                 l_error_count_1,
                 '(M175_SYMBOL_ID) INVALID');

    ----------- POA INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.m175_cutomer_poa_symbols@mubasher_db_link m175,
           mubasher_oms.m137_customer_poa@mubasher_db_link m137
     WHERE m175.m175_poa = m137.m137_id(+) AND m137.m137_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U55_POA_SYMBOL_RESTRICTIONS',
                 'M175_CUTOMER_POA_SYMBOLS',
                 l_source_count,
                 l_error_count_2,
                 '(M175_POA) INVALID');

    ----------- Security Account and Exchange INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_3
      FROM mubasher_oms.m175_cutomer_poa_symbols@mubasher_db_link m175,
           mubasher_oms.m137_customer_poa@mubasher_db_link m137,
           mubasher_oms.m77_symbols@mubasher_db_link m77,
           mubasher_oms.u06_routing_accounts@mubasher_db_link u06
     WHERE     m175.m175_poa = m137.m137_id
           AND m175.m175_symbol_id = m77.m77_id
           AND m137.m137_security_ac_id = u06.u06_security_ac_id(+)
           AND m77.m77_exchange = u06.u06_exchange(+)
           AND u06.u06_security_ac_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U55_POA_SYMBOL_RESTRICTIONS',
                 'M175_CUTOMER_POA_SYMBOLS',
                 l_source_count,
                 l_error_count_3,
                 'MAPPING (U06_SECURITY_AC_ID, U06_EXCHANGE) INVALID');
END;
/