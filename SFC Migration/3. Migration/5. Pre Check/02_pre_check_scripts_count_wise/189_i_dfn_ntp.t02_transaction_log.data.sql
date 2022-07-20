DECLARE
    l_source_count     NUMBER;
    l_error_count_1    NUMBER;
    l_error_count_2    NUMBER;
    l_error_count_3    NUMBER;
    l_error_count_4    NUMBER;
    l_error_count_5    NUMBER;
    l_error_count_6    NUMBER;
    l_error_count_7    NUMBER;
    l_error_count_8    NUMBER;
    l_error_count_9    NUMBER;
    l_error_count_10   NUMBER;
    l_error_count_11   NUMBER;
BEGIN
    SELECT COUNT (*)
      INTO l_source_count
      FROM (SELECT t05.t05_id AS id
              FROM mubasher_oms.t05_cash_account_log@mubasher_db_link t05
            UNION ALL
            SELECT t06.t06_security_ac_id AS id
              FROM mubasher_oms.t06_holdings_log@mubasher_db_link t06
             WHERE t06.t06_side NOT IN (1, 2));

    ----------- Transaction Code INVALID | T06_TXN_TYPE -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.t06_holdings_log@mubasher_db_link t06
     WHERE     t06.t06_inst_id <> 0 -- [Corrective Actions Discussed] (Use Trading Account's Institute)
           AND t06.t06_side NOT IN (1, 2)
           AND t06.t06_txn_type NOT BETWEEN 3 AND 13
           AND t06.t06_txn_type <> 0 -- [Corrective Actions Discussed] (NetHoldings >= 0 Deposit Else Withdraw)
                                    ;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T02_TRANSACTION_LOG',
                 'T06_HOLDINGS_LOG',
                 l_source_count,
                 l_error_count_1,
                 '(T06_TXN_TYPE) INVALID');

    ----------- Institute INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.t06_holdings_log@mubasher_db_link t06,
           mubasher_oms.m05_branches@mubasher_db_link m05
     WHERE     t06.t06_side NOT IN (1, 2)
           AND t06.t06_inst_id = m05.m05_branch_id(+)
           AND m05.m05_branch_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T02_TRANSACTION_LOG',
                 'T06_HOLDINGS_LOG',
                 l_source_count,
                 l_error_count_2,
                 '(T06_INST_ID) INVALID');

    ----------- Transaction Code Invalid | T05_CODE with M41_CHARGES -----------

    SELECT COUNT (*)
      INTO l_error_count_3
      FROM mubasher_oms.t05_cash_account_log@mubasher_db_link t05,
           mubasher_oms.m05_branches@mubasher_db_link m05,
           mubasher_oms.m41_charges@mubasher_db_link m41
     WHERE     m05_branch_id > 0
           AND t05.t05_inst_id = m05.m05_branch_id
           AND t05.t05_code = m41.m41_code(+)
           AND m41.m41_code IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T02_TRANSACTION_LOG',
                 'T05_CASH_ACCOUNT_LOG',
                 l_source_count,
                 l_error_count_3,
                 '(T05_CODE) INVALID | CHECKED WITH M41_CHARGES');

    ----------- Transaction Code Invalid | T05_CODE with M97_TRANSACTION_CODES -----------

    SELECT COUNT (*)
      INTO l_error_count_4
      FROM mubasher_oms.t05_cash_account_log@mubasher_db_link t05,
           mubasher_oms.m05_branches@mubasher_db_link m05,
           map15_transaction_codes_m97 map15,
           dfn_ntp.m97_transaction_codes m97
     WHERE     m05_branch_id > 0
           AND t05.t05_inst_id = m05.m05_branch_id
           AND t05.t05_code = map15.map15_oms_code(+)
           AND map15.map15_ntp_code = m97.m97_code(+)
           AND m97.m97_code IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T02_TRANSACTION_LOG',
                 'T05_CASH_ACCOUNT_LOG',
                 l_source_count,
                 l_error_count_4,
                 '(T05_CODE) INVALID | CHECKED WITH M97_TRANSACTION_CODES');

    ----------- Cash Account Invalid -----------

    SELECT COUNT (*)
      INTO l_error_count_5
      FROM mubasher_oms.t05_cash_account_log@mubasher_db_link t05,
           mubasher_oms.m05_branches@mubasher_db_link m05,
           (SELECT t03_account_id
              FROM mubasher_oms.t03_cash_account@mubasher_db_link
             WHERE t03_branch_id > 0) t03
     WHERE     t05.t05_inst_id = m05.m05_branch_id
           AND m05_branch_id > 0
           AND t05.t05_cash_account_id = t03.t03_account_id(+)
           AND t03.t03_account_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T02_TRANSACTION_LOG',
                 'T05_CASH_ACCOUNT_LOG',
                 l_source_count,
                 l_error_count_5,
                 '(T05_CASH_ACCOUNT_ID) INVALID');

    ----------- Trading Account Invalid -----------

    SELECT COUNT (*)
      INTO l_error_count_6
      FROM mubasher_oms.t06_holdings_log@mubasher_db_link t06,
           mubasher_oms.u06_routing_accounts@mubasher_db_link u06,
           (SELECT u05_id
              FROM mubasher_oms.u05_security_accounts@mubasher_db_link
             WHERE u05_branch_id > 0) u05
     WHERE     t06.t06_inst_id <> 0 -- [Corrective Actions Discussed] (Use Trading Account's Institute)
           AND t06.t06_side NOT IN (1, 2)
           AND t06.t06_security_ac_id = u06.u06_security_ac_id(+)
           AND t06.t06_exchange = u06.u06_exchange(+)
           AND t06.t06_security_ac_id = u05.u05_id(+)
           AND (u06.u06_security_ac_id IS NULL OR u05.u05_id IS NULL);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T02_TRANSACTION_LOG',
                 'T06_HOLDINGS_LOG',
                 l_source_count,
                 l_error_count_6,
                 '(T06_SECURITY_AC_ID) INVALID');

    ----------- Customer Invalid -----------

    SELECT COUNT (*)
      INTO l_error_count_7
      FROM (SELECT t05.t05_id AS id
              FROM mubasher_oms.t05_cash_account_log@mubasher_db_link t05,
                   mubasher_oms.t03_cash_account@mubasher_db_link t03,
                   mubasher_oms.m01_customer@mubasher_db_link m01,
                   mubasher_oms.m05_branches@mubasher_db_link m05
             WHERE     t05.t05_inst_id = m05.m05_branch_id
                   AND m05_branch_id > 0
                   AND t05.t05_cash_account_id = t03.t03_account_id(+)
                   AND t03.t03_profile_id = m01.m01_customer_id(+)
                   AND m01.m01_customer_id IS NULL
            UNION ALL
            SELECT t06.t06_sequenceno AS id
              FROM mubasher_oms.t06_holdings_log@mubasher_db_link t06,
                   mubasher_oms.u05_security_accounts@mubasher_db_link u05,
                   mubasher_oms.m01_customer@mubasher_db_link m01,
                   mubasher_oms.m05_branches@mubasher_db_link m05
             WHERE     t06.t06_inst_id = m05.m05_branch_id
                   AND m05_branch_id > 0
                   AND t06.t06_side NOT IN (1, 2)
                   AND t06.t06_security_ac_id = u05.u05_id(+)
                   AND u05.u05_customer_id = m01.m01_customer_id(+)
                   AND m01.m01_customer_id IS NULL);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T02_TRANSACTION_LOG',
                 'T05_CASH_ACCOUNT_LOG, T06_HOLDINGS_LOG',
                 l_source_count,
                 l_error_count_7,
                 'MAPPING (M01_CUSTOMER_ID) INVALID');

    ----------- Symbol Invalid -----------

    SELECT COUNT (*)
      INTO l_error_count_8
      FROM mubasher_oms.t06_holdings_log@mubasher_db_link t06,
           mubasher_oms.m05_branches@mubasher_db_link m05,
           mubasher_oms.m77_symbols@mubasher_db_link m77
     WHERE     t06.t06_inst_id = m05.m05_branch_id
           AND m05.m05_branch_id > 0
           AND t06.t06_side NOT IN (1, 2)
           AND t06.t06_symbol = m77.m77_symbol(+)
           AND m77.m77_symbol IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T02_TRANSACTION_LOG',
                 'T06_HOLDINGS_LOG',
                 l_source_count,
                 l_error_count_8,
                 '(T06_SYMBOL) INVALID');

    ----------- Symbol / External Ref. Invalid -----------

    SELECT COUNT (*)
      INTO l_error_count_9
      FROM mubasher_oms.t06_holdings_log@mubasher_db_link t06,
           mubasher_oms.m77_symbols@mubasher_db_link m77,
           (SELECT m77_external_ref
              FROM mubasher_oms.m77_symbols@mubasher_db_link
             WHERE m77_external_ref IS NOT NULL) m77_ex_ref
     WHERE     t06.t06_symbol = m77.m77_symbol(+)
           AND m77.m77_symbol IS NULL
           AND t06.t06_symbol = m77_ex_ref.m77_external_ref(+)
           AND m77_ex_ref.m77_external_ref IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T02_TRANSACTION_LOG',
                 'T06_HOLDINGS_LOG',
                 l_source_count,
                 l_error_count_9,
                 '(T06_SYMBOL) NOT IN (M77_SYMBOL / M77_EXTERNAL_REF)');

    ----------- Order Execution Invalid -----------

    /* This validation skipped and migrated

        SELECT COUNT (*)
          INTO l_error_count_10
          FROM mubasher_oms.t11_executed_orders@mubasher_db_link t11,
               mubasher_oms.t05_cash_account_log@mubasher_db_link t05
         WHERE     t05.t05_id = t11.t11_t05_exec_id(+)
               AND t05.t05_code IN
                       ('STLBUY',
                        'STLSEL',
                        'STKSUB',
                        'REVBUY',
                        'REVSEL',
                        'REVSUB')
               AND t11.t11_exec_id IS NULL;


        INSERT INTO pre_check_table_count_wise (target_table,
                                                source_table,
                                                source_count,
                                                error_count,
                                                error_reason)
             VALUES ('T02_TRANSACTION_LOG',
                     'T11_EXECUTED_ORDERS',
                     l_source_count,
                     l_error_count_10,
                     '(T11_T05_EXEC_ID) INVALID');
    */
    ----------- Symbol & Exchange Invalid -----------

    SELECT COUNT (*)
      INTO l_error_count_11
      FROM (SELECT m77_symbol
              FROM mubasher_oms.t06_holdings_log@mubasher_db_link t06,
                   mubasher_oms.u06_routing_accounts@mubasher_db_link u06,
                   mubasher_oms.m77_symbols@mubasher_db_link m77
             WHERE     t06.t06_inst_id <> 0 -- [Corrective Actions Discussed]
                   AND t06.t06_security_ac_id = u06.u06_security_ac_id
                   AND t06.t06_exchange = u06.u06_exchange
                   AND t06.t06_symbol = m77.m77_symbol(+)
                   AND t06.t06_exchange = m77.m77_exchange(+)
                   AND t06.t06_side NOT IN (1, 2))
     WHERE m77_symbol IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T02_TRANSACTION_LOG',
                 'T06_HOLDINGS_LOG',
                 l_source_count,
                 l_error_count_11,
                 '(T06_SYMBOL, T06_EXCHANGE) INVALID');
END;
/