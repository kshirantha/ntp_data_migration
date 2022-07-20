DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'T123_PAYMENT_LOG';

    ----------- Sesscion ID INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.t123_payment_log@mubasher_db_link t123,
           mubasher_oms.t122_payment_sessions@mubasher_db_link t122
     WHERE t123.t123_t122_id = t122.t122_id(+) AND t122.t122_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T501_PAYMENT_DETAIL_C',
                 'T123_PAYMENT_LOG',
                 l_source_count,
                 l_error_count_1,
                 '(T123_T122_ID) INVALID');

    ----------- Cash Account INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.t123_payment_log@mubasher_db_link t123,
           mubasher_oms.t03_cash_account@mubasher_db_link t03
     WHERE     t123.t123_t03_account_id = t03.t03_account_id(+)
           AND t03.t03_account_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T501_PAYMENT_DETAIL_C',
                 'T123_PAYMENT_LOG',
                 l_source_count,
                 l_error_count_2,
                 '(T123_T03_ACCOUNT_ID) INVALID');
END;
/
