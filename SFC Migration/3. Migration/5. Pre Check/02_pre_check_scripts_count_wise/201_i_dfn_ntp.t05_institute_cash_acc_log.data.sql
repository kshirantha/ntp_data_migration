DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link a
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'T43_EXE_INST_CASH_ACC_LOG';

    ----------- Txn Code INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count
      FROM mubasher_oms.t43_exe_inst_cash_acc_log@mubasher_db_link t43,
           dfn_ntp.m97_transaction_codes m97,
           map15_transaction_codes_m97 map15
     WHERE     t43.t43_code = map15.map15_oms_code(+)
           AND map15.map15_ntp_code = m97.m97_code(+)
           AND m97.m97_code IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T05_INSTITUTE_CASH_ACC_LOG',
                 'T43_EXE_INST_CASH_ACC_LOG',
                 l_source_count,
                 l_error_count,
                 '(T43_CODE) INVALID');
END;
/