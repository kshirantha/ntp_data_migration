DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
BEGIN
    SELECT COUNT (*)
      INTO l_source_count
      FROM (SELECT t75.t75_id AS id
              FROM mubasher_oms.t75_daily_interest_for_charges@mubasher_db_link t75
            UNION ALL
            SELECT t108.t108_id AS id
              FROM mubasher_oms.t108_custodian_accrual_fee@mubasher_db_link t108);

    ----------- Charge Code INVALID with M97_TRANSACTION_CODES -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.t75_daily_interest_for_charges@mubasher_db_link t75,
           dfn_ntp.m97_transaction_codes m97,
           map15_transaction_codes_m97 map15
     WHERE     t75.t75_charges_code = map15.map15_oms_code(+)
           AND map15.map15_ntp_code = m97.m97_code(+)
           AND m97.m97_code IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES (
                    'T21_DAILY_INTEREST_FOR_CHARGES',
                    'T75_DAILY_INTEREST_FOR_CHARGES, T108_CUSTODIAN_ACCRUAL_FEE',
                    l_source_count,
                    l_error_count_1,
                    '(T75_CHARGES_CODE) INVALID | CHECKED WITH M97_TRANSACTION_CODES');

    ----------- Charge Code INVALID with M41_CHARGES -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.t75_daily_interest_for_charges@mubasher_db_link t75,
           mubasher_oms.m41_charges@mubasher_db_link m41
     WHERE t75.t75_charges_code = m41.m41_code(+) AND m41.m41_code IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES (
                    'T21_DAILY_INTEREST_FOR_CHARGES',
                    'T75_DAILY_INTEREST_FOR_CHARGES, T108_CUSTODIAN_ACCRUAL_FEE',
                    l_source_count,
                    l_error_count_2,
                    '(T75_CHARGES_CODE) INVALID | CHECKED WITH M41_CHARGES');
END;
/