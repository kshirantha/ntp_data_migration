DECLARE
    l_source_count   NUMBER;
    l_error_count1   NUMBER;
    l_error_count2   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link a
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'M10_EXCHANGE_COMMISSION_EXEC';

    ----------- Currency INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count2
      FROM mubasher_oms.m10_exchange_commission_exec@mubasher_db_link m10,
           dfn_ntp.m03_currency m03
     WHERE m10.m10_currency = m03.m03_code(+) AND m03_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M34_EXEC_BROKER_COMMISSION',
                 'M10_EXCHANGE_COMMISSION_EXEC',
                 l_source_count,
                 l_error_count2,
                 '(M10_CURRENCY) INVALID');
END;
/