DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M253_SAIBOR_BASIS_RATES';

    ----------- Institution Not Available -----------

    SELECT COUNT (*)
      INTO l_error_count
      FROM mubasher_oms.m253_saibor_basis_rates@mubasher_db_link
     WHERE m253_institution IS NULL;


    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M65_SAIBOR_BASIS_RATES',
                 'M253_SAIBOR_BASIS_RATES',
                 l_source_count,
                 l_error_count,
                 '(M253_INSTITUTION) IS NULL');
END;
/
