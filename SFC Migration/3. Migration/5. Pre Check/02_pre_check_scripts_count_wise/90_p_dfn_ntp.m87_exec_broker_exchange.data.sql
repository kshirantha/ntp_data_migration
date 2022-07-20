DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link a
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'EX02_EXECUTING_INST_EXCHANGES';

    ----------- Executing Broker Type INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count
      FROM     mubasher_oms.ex02_executing_inst_exchanges@mubasher_db_link ex02
           JOIN
               mubasher_oms.ex01_executing_institution@mubasher_db_link ex01
           ON     ex02.ex02_executing_institution = ex01.ex01_id
              AND ex01.ex01_type NOT IN (1, 2, 4);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M87_EXEC_BROKER_EXCHANGE',
                 'EX02_EXECUTING_INST_EXCHANGES',
                 l_source_count,
                 l_error_count,
                 '(EX01_TYPE) NOT IN (1-BROKER,2-EXCHANGE,4-BROKER-CUSTODY)');
END;
/
