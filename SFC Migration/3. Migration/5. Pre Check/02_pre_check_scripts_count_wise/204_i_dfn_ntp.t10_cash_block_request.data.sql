DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'T77_FUND_TRANSFER_BLOCK';

    ----------- Cash Account INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count
      FROM mubasher_oms.t77_fund_transfer_block@mubasher_db_link t77,
           mubasher_oms.t03_cash_account@mubasher_db_link t03
     WHERE     t77.t77_cash_acc_id = t03.t03_account_id(+)
           AND t03.t03_account_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T10_CASH_BLOCK_REQUEST',
                 'T77_FUND_TRANSFER_BLOCK',
                 l_source_count,
                 l_error_count,
                 '(T77_CASH_ACC_ID) INVALID');
END;
/
