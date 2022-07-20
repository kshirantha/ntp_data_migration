DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
    l_error_count_3   NUMBER;
    l_error_count_4   NUMBER;
    l_error_count_5   NUMBER;
    l_error_count_6   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link a
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'T12_PENDING_CASH';

    ----------- Cash Account INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.t12_pending_cash@mubasher_db_link t12,
           (SELECT t03_account_id
              FROM mubasher_oms.t03_cash_account@mubasher_db_link
             WHERE t03_branch_id > 0) t03
     WHERE     t12.t12_cash_account_id = t03.t03_account_id(+)
           AND t03.t03_account_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T06_CASH_TRANSACTION',
                 'T12_PENDING_CASH',
                 l_source_count,
                 l_error_count_1,
                 '(T12_CASH_ACCOUNT_ID) INVALID');

    ----------- Transaction Code INVALID | T12_CODE with  M97_TRANSACTION_CODES-----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.t12_pending_cash@mubasher_db_link t12,
           dfn_ntp.m97_transaction_codes m97,
           map15_transaction_codes_m97 map15
     WHERE     t12.t12_code = map15.map15_oms_code(+)
           AND map15.map15_ntp_code = m97.m97_code(+)
           AND m97.m97_code IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T06_CASH_TRANSACTION',
                 'T12_PENDING_CASH',
                 l_source_count,
                 l_error_count_2,
                 '(T12_CODE) INVALID | CHECKED WITH M97_TRANSACTION_CODES');

    ----------- Status INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_3
      FROM mubasher_oms.t12_pending_cash@mubasher_db_link t12
     WHERE     t12.t12_status NOT IN (0, 1, 2, 3, 5, 6)
           AND t12.t12_status NOT IN (4, 7, 8, 9, 10, 24 -- [Corrective Actions Discussed]
                                                        );

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T06_CASH_TRANSACTION',
                 'T12_PENDING_CASH',
                 l_source_count,
                 l_error_count_3,
                 '(T12_STATUS) INVALID');

    ----------- Function Approval ID INVALID -----------

    /* This is not required. There could be transactions without change code and channel. Need to migarete them. So this is ignored

            SELECT COUNT (*)
              INTO l_error_count_4
              FROM mubasher_oms.t12_pending_cash@mubasher_db_link t12,
                   map15_transaction_codes_m97 map15,
                   dfn_ntp.m88_function_approval m88
             WHERE     TRIM (t12.t12_code) = map15.map15_oms_code(+)
                   AND map15.map15_ntp_code = m88.m88_txn_code(+)
                   AND NVL (t12.t12_request_channel, -1) = m88.m88_channel_id_v29(+)
                   AND m88.m88_id IS NULL;

            INSERT INTO pre_check_table_count_wise (target_table,
                                                    source_table,
                                                    source_count,
                                                    error_count,
                                                    error_reason)
                 VALUES ('T06_CASH_TRANSACTION',
                         'T12_PENDING_CASH',
                         l_source_count,
                         l_error_count_4,
                         '(T12_CODE, T12_REQUEST_CHANNEL) INVALID');
        */

    ----------- Transaction Code INVALID | T12_CODE with  with M41_CHARGES-----------

    SELECT COUNT (*)
      INTO l_error_count_5
      FROM mubasher_oms.t12_pending_cash@mubasher_db_link t12,
           mubasher_oms.m41_charges@mubasher_db_link m41
     WHERE t12.t12_code = m41.m41_code(+) AND m41.m41_code IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T06_CASH_TRANSACTION',
                 'T12_PENDING_CASH',
                 l_source_count,
                 l_error_count_5,
                 '(T12_CODE) INVALID | CHECKED WITH M41_CHARGES');
END;
/