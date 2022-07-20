DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'U10_RESTRICTED_INSTRMNT_TYPES';

    ----------- Instrument Type INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count
      FROM mubasher_oms.u10_restricted_instrmnt_types@mubasher_db_link u10,
           dfn_ntp.v09_instrument_types v09
     WHERE     u10.u10_instrument_type_id = v09.v09_code(+)
           AND v09.v09_code IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U16_TRADING_INSTRUMENT_RESTRIC',
                 'U10_RESTRICTED_INSTRMNT_TYPES',
                 l_source_count,
                 l_error_count,
                 '(U10_INSTRUMENT_TYPE_ID) INVALID');
END;
/
