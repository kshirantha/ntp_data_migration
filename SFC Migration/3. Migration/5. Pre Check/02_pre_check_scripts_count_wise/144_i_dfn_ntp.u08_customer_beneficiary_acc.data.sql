DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
    l_error_count_3   NUMBER;
BEGIN
    SELECT COUNT (*)
      INTO l_source_count
      FROM (SELECT m264.m264_id AS id
              FROM mubasher_oms.m264_beneficiary_accounts@mubasher_db_link m264);


    ------------ Currency INVALID ----------------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM (SELECT m264.m264_id AS id
              FROM mubasher_oms.m264_beneficiary_accounts@mubasher_db_link m264,
                   dfn_ntp.m03_currency m03
             WHERE     m264.m264_currency = m03.m03_code(+)
                   AND m03.m03_code IS NULL);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U08_CUSTOMER_BENEFICIARY_ACC',
                 'M264_BENEFICIARY_ACCOUNTS',
                 l_source_count,
                 l_error_count_1,
                 '(M264_CURRENCY) INVALID');

    ------------ Account Number INVALID ----------------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM (SELECT m264.m264_id AS id
              FROM mubasher_oms.m264_beneficiary_accounts@mubasher_db_link m264
             WHERE m264.m264_account_number IS NULL);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U08_CUSTOMER_BENEFICIARY_ACC',
                 'M264_BENEFICIARY_ACCOUNTS',
                 l_source_count,
                 l_error_count_2,
                 '(M264_ACCOUNT_NUMBER) INVALID');

    ------------ Customer INVALID ----------------

    SELECT COUNT (*)
      INTO l_error_count_3
      FROM (SELECT m264.m264_id AS id
              FROM mubasher_oms.m264_beneficiary_accounts@mubasher_db_link m264,
                   mubasher_oms.t03_cash_account@mubasher_db_link t03,
                   mubasher_oms.m01_customer@mubasher_db_link m01
             WHERE     m264.m264_cash_account = t03.t03_account_id(+)
                   AND t03.t03_profile_id = m01.m01_customer_id(+)
                   AND m01.m01_customer_id IS NULL);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U08_CUSTOMER_BENEFICIARY_ACC',
                 'M264_BENEFICIARY_ACCOUNTS',
                 l_source_count,
                 l_error_count_3,
                 '(M264_CASH_ACCOUNT LINKED CUSTOMER) INVALID');
END;
/