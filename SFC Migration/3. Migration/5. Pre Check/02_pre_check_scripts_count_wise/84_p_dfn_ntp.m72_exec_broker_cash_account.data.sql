DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link a
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'EX03_EXE_INST_CASH_ACCOUNT';

    ----------- Custody Type INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.ex03_exe_inst_cash_account@mubasher_db_link ex03,
           mubasher_oms.ex01_executing_institution@mubasher_db_link ex01
     WHERE     ex03.ex03_execution_instituion = ex01.ex01_id
           AND ex01.ex01_type <> 3;


    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M72_EXEC_BROKER_CASH_ACCOUNT',
                 'EX03_EXE_INST_CASH_ACCOUNT',
                 l_source_count,
                 l_error_count_1,
                 '(EX01_TYPE) NOT IN (3-CUSTODY)');

    ----------- Account No DUPLICATED -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM (  SELECT MAX (ex03_id)
                FROM mubasher_oms.ex03_exe_inst_cash_account@mubasher_db_link
            GROUP BY ex03_accountno
              HAVING COUNT (*) > 1);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M72_EXEC_BROKER_CASH_ACCOUNT',
                 'EX03_EXE_INST_CASH_ACCOUNT',
                 l_source_count,
                 l_error_count_2,
                 '(EX03_ACCOUNTNO) DUPLICATED');
END;
/
