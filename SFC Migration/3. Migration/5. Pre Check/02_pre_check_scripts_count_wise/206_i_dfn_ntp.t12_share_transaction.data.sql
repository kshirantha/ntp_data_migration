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
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'T24_PENDING_STOCKS';

    ----------- Cash Txn Reference INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.t24_pending_stocks@mubasher_db_link
     WHERE     NOT REGEXP_LIKE (t24_reference_no, '^-?[0-9]+$')
           AND t24_inst_id <> 0
           AND t24_txn_type NOT IN (13, 15) -- 13 (Right Subscriptions) WIll be Captured as Orders | 15 (Right Reversals) Will be Ignored While Capturing Subscriptions
                                           ;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T12_SHARE_TRANSACTION',
                 'T24_PENDING_STOCKS',
                 l_source_count,
                 l_error_count_1,
                 '(T24_REFERENCE_NO) INVALID');

    ----------- Portfolio & Exchange INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.t24_pending_stocks@mubasher_db_link t24,
           mubasher_oms.u06_routing_accounts@mubasher_db_link u06
     WHERE     t24_inst_id <> 0
           AND t24.t24_txn_type NOT IN (13, 15) -- 13 (Right Subscriptions) WIll be Captured as Orders | 15 (Right Reversals) Will be Ignored While Capturing Subscriptions
           AND t24.t24_portfolio_id = u06.u06_security_ac_id(+)
           AND t24.t24_exchange = u06.u06_exchange(+)
           AND u06.u06_security_ac_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T12_SHARE_TRANSACTION',
                 'T24_PENDING_STOCKS',
                 l_source_count,
                 l_error_count_2,
                 '(T24_PORTFOLIO_ID, T24_EXCHANGE) INVALID');

    ----------- Status INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_3
      FROM mubasher_oms.t24_pending_stocks@mubasher_db_link t24
     WHERE     t24_inst_id <> 0
           AND t24.t24_status NOT IN (0, 1, 3, 4, 5, 6, 7, 8, 9, 10)
           AND t24.t24_txn_type NOT IN (13, 15) -- 13 (Right Subscriptions) WIll be Captured as Orders | 15 (Right Reversals) Will be Ignored While Capturing Subscriptions
                                               ;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T12_SHARE_TRANSACTION',
                 'T24_PENDING_STOCKS',
                 l_source_count,
                 l_error_count_3,
                 '(T24_STATUS) INVALID');

    ----------- Symbol INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_4
      FROM mubasher_oms.t24_pending_stocks@mubasher_db_link t24,
           mubasher_oms.m77_symbols@mubasher_db_link m77
     WHERE     t24.t24_inst_id <> 0
           AND t24.t24_txn_type NOT IN (13, 15) -- 13 (Right Subscriptions) WIll be Captured as Orders | 15 (Right Reversals) Will be Ignored While Capturing Subscriptions
           AND t24.t24_symbol = m77.m77_symbol(+)
           AND m77.m77_symbol IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T12_SHARE_TRANSACTION',
                 'T24_PENDING_STOCKS',
                 l_source_count,
                 l_error_count_4,
                 '(T24_SYMBOL) INVALID');

    ----------- Institution INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_5
      FROM mubasher_oms.t24_pending_stocks@mubasher_db_link t24,
           mubasher_oms.m05_branches@mubasher_db_link m05
     WHERE     t24.t24_inst_id = m05.m05_branch_id(+)
           AND t24.t24_txn_type NOT IN (13, 15) -- 13 (Right Subscriptions) WIll be Captured as Orders | 15 (Right Reversals) Will be Ignored While Capturing Subscriptions
           AND m05.m05_branch_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T12_SHARE_TRANSACTION',
                 'T24_PENDING_STOCKS',
                 l_source_count,
                 l_error_count_5,
                 '(T24_INST_ID) INVALID');

    ----------- Symbol / External Ref. Invalid -----------

    SELECT COUNT (*)
      INTO l_error_count_6
      FROM mubasher_oms.t24_pending_stocks@mubasher_db_link t24,
           mubasher_oms.m77_symbols@mubasher_db_link m77,
           (SELECT m77_external_ref
              FROM mubasher_oms.m77_symbols@mubasher_db_link
             WHERE m77_external_ref IS NOT NULL) m77_ex
     WHERE     t24.t24_inst_id <> 0
           AND t24.t24_txn_type NOT IN (13, 15) -- 13 (Right Subscriptions) WIll be Captured as Orders | 15 (Right Reversals) Will be Ignored While Capturing Subscriptions
           AND t24.t24_symbol = m77.m77_symbol(+)
           AND m77.m77_symbol IS NULL
           AND t24.t24_symbol = m77_ex.m77_external_ref(+)
           AND m77_ex.m77_external_ref IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T12_SHARE_TRANSACTION',
                 'T24_PENDING_STOCKS',
                 l_source_count,
                 l_error_count_6,
                 '(T24_SYMBOL) NOT IN (M77_SYMBOL / M77_EXTERNAL_REF)');
END;
/