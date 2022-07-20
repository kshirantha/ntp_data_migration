DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'T102_TAX_INVOICES';

    ----------- Customer INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.t102_tax_invoices@mubasher_db_link t102,
           mubasher_oms.m01_customer@mubasher_db_link m01
     WHERE     t102.t102_m01_customer_id = m01.m01_customer_id(+)
           AND m01.m01_customer_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T48_TAX_INVOICES',
                 'T102_TAX_INVOICES',
                 l_source_count,
                 l_error_count_1,
                 '(T102_M01_CUSTOMER_ID) INVALID');

    ----------- Transaction Type INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.t102_tax_invoices@mubasher_db_link t102
     WHERE t102.t102_txn_type NOT IN
               (SELECT m97_code FROM dfn_ntp.m97_transaction_codes
                UNION
                SELECT 'TRNSFR' FROM DUAL
                UNION
                SELECT 'TRNFEE' FROM DUAL
                UNION
                SELECT 'ALL' FROM DUAL);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T48_TAX_INVOICES',
                 'T102_TAX_INVOICES',
                 l_source_count,
                 l_error_count_2,
                 '(T102_TXN_TYPE) INVALID');
END;
/