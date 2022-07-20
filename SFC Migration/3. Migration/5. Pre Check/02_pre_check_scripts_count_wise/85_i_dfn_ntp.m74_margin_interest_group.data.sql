DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'M94_MARGIN_INTE_RATE_GROUP';

    ----------- M94_SAIBOR_BASIS_GROUP_ID INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count
      FROM mubasher_oms.m94_margin_inte_rate_group@mubasher_db_link m94,
           mubasher_oms.m253_saibor_basis_rates@mubasher_db_link m253
     WHERE     m94.m94_saibor_basis_group_id = m253.m253_id(+)
           AND m253.m253_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M74_MARGIN_INTEREST_GROUP',
                 'M94_MARGIN_INTE_RATE_GROUP',
                 l_source_count,
                 l_error_count,
                 '(M94_SAIBOR_BASIS_GROUP_ID) INVALID');
END;
/
