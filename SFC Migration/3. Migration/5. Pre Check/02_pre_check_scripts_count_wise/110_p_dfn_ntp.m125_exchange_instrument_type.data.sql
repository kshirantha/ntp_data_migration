DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link a
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'M291_EXCHANGE_INSTRUMENT_TYPE';

    ----------- Invalid Instrument Type -----------

    SELECT COUNT (*)
      INTO l_error_count
      FROM mubasher_oms.m291_exchange_instrument_type@mubasher_db_link m291,
           dfn_ntp.v09_instrument_types v09
     WHERE     m291.m291_instrument_type = v09.v09_code(+)
           AND v09.v09_code IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M125_EXCHANGE_INSTRUMENT_TYPE',
                 'M291_EXCHANGE_INSTRUMENT_TYPE',
                 l_source_count,
                 l_error_count,
                 '(M291_INSTRUMENT_TYPE) INVALID');
END;
/
