DECLARE
    l_source_count   NUMBER;
    l_error_count1   NUMBER;
    l_error_count2   NUMBER;
    l_error_count3   NUMBER;
    l_error_count4   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link a
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M77_SYMBOLS';

    ----------- Instrument Type INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count1
      FROM mubasher_oms.m77_symbols@mubasher_db_link m77,
           dfn_ntp.v34_price_instrument_type v34
     WHERE     m77.m77_instrument_type_id = v34.v34_price_inst_type_id(+)
           AND m77.m77_instrument_type = v34.v34_inst_code_v09(+)
           AND v34_inst_code_v09 IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M20_SYMBOL',
                 'M77_SYMBOLS',
                 l_source_count,
                 l_error_count1,
                 '(M77_INSTRUMENT_TYPE, M77_INSTRUMENT_TYPE_ID) INVALID');

    ----------- ISIN CODE INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count2
      FROM mubasher_oms.m77_symbols@mubasher_db_link m77
     WHERE m77.m77_isincode IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M20_SYMBOL',
                 'M77_SYMBOLS',
                 l_source_count,
                 l_error_count2,
                 '(M77_ISINCODE) INVALID');

    ----------- RIC INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count3
      FROM mubasher_oms.m77_symbols@mubasher_db_link m77
     WHERE m77.m77_reuters_code IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M20_SYMBOL',
                 'M77_SYMBOLS',
                 l_source_count,
                 l_error_count3,
                 '(M77_REUTERS_CODE) INVALID');

    ----------- MORE THAN ONE DESCRIPTION FOR ONE SYMBOL ID -----------

    SELECT COUNT (*)
      INTO l_error_count4
      FROM (  SELECT m107_symbol_id
                FROM mubasher_oms.m107_symbol_descriptions@mubasher_db_link m107
               WHERE m107.m107_language = 'AR'
            GROUP BY m107_symbol_id
              HAVING COUNT (*) > 1
            UNION ALL
              SELECT m107_symbol_id
                FROM mubasher_oms.m107_symbol_descriptions@mubasher_db_link m107
               WHERE m107.m107_language = 'EN'
            GROUP BY m107_symbol_id
              HAVING COUNT (*) > 1);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M20_SYMBOL',
                 'M77_SYMBOLS',
                 l_source_count,
                 l_error_count4,
                 '(M107_SYMBOL_ID) MULTIPLE DESCRIPTION FOR ONE SYMBOL');
END;
/
