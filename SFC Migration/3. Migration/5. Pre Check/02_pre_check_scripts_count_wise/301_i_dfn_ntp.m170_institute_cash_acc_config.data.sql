DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M379_PAYING_AGENTS';

    ----------- Status INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count
      FROM mubasher_oms.m379_paying_agents@mubasher_db_link m379,
           mubasher_oms.m64_approval_status@mubasher_db_link m64
     WHERE m379_status_id = m64.m64_id(+) AND m64.m64_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M170_INSTITUTE_CASH_ACC_CONFIG',
                 'M379_PAYING_AGENTS',
                 l_source_count,
                 l_error_count,
                 '(M379_STATUS_ID) INVALID');
END;
/
