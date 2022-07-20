DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link a
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'T103_TAX_INVOICE_DETAILS';

    ----------- Cash Transaction INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count
      FROM mubasher_oms.t103_tax_invoice_details@mubasher_db_link t103,
           mubasher_oms.t05_cash_account_log@mubasher_db_link t05
     WHERE t103.t103_t05_id = t05.t05_id(+) AND t05.t05_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T49_TAX_INVOICE_DETAILS',
                 'T103_TAX_INVOICE_DETAILS',
                 l_source_count,
                 l_error_count,
                 '(T103_T05_ID) INVALID');
END;
/

