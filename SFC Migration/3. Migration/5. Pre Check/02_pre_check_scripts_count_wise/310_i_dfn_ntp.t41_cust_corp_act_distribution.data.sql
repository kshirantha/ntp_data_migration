DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
    l_error_count_3   NUMBER;
    l_error_count_4   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'M273_CORPORATE_ACTION_CUSTOMER';

    ----------- Corporate Action INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.m273_corporate_action_customer@mubasher_db_link m273,
           mubasher_oms.m272_corporate_actions@mubasher_db_link m272
     WHERE     m273.m273_corporate_action = m272.m272_id(+)
           AND m272.m272_id IS NULL
           AND m272_inst_id > 0;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T41_CUST_CORP_ACT_DISTRIBUTION',
                 'M273_CORPORATE_ACTION_CUSTOMER',
                 l_source_count,
                 l_error_count_1,
                 '(M273_CORPORATE_ACTION) INVALID');

    ----------- Security Account INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.m273_corporate_action_customer@mubasher_db_link m273,
           mubasher_oms.m272_corporate_actions@mubasher_db_link m272,
           (SELECT u05_id
              FROM mubasher_oms.u05_security_accounts@mubasher_db_link
             WHERE u05_branch_id > 0) u05
     WHERE     m273.m273_corporate_action = m272.m272_id
           AND m272.m272_inst_id > 0
           AND m273.m273_security_account = u05.u05_id(+)
           AND u05.u05_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T41_CUST_CORP_ACT_DISTRIBUTION',
                 'M273_CORPORATE_ACTION_CUSTOMER',
                 l_source_count,
                 l_error_count_2,
                 '(M273_SECURITY_ACCOUNT) INVALID');

    ----------- Security Account & Exchange INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_3
      FROM mubasher_oms.m273_corporate_action_customer@mubasher_db_link m273,
           mubasher_oms.m272_corporate_actions@mubasher_db_link m272,
           mubasher_oms.m77_symbols@mubasher_db_link m77,
           mubasher_oms.u06_routing_accounts@mubasher_db_link u06
     WHERE     m273.m273_corporate_action = m272.m272_id
           AND m272.m272_inst_id > 0
           AND m272.m272_symbol = m77.m77_id
           AND m273.m273_security_account = u06.u06_security_ac_id(+)
           AND m77.m77_exchange = u06.u06_exchange(+)
           AND u06.u06_security_ac_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T41_CUST_CORP_ACT_DISTRIBUTION',
                 'M273_CORPORATE_ACTION_CUSTOMER',
                 l_source_count,
                 l_error_count_3,
                 'MAPPING (U06_SECURITY_AC_ID, U06_EXCHANGE) INVALID');

    ----------- Mapping Symbol INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_4
      FROM mubasher_oms.m273_corporate_action_customer@mubasher_db_link m273,
           mubasher_oms.m272_corporate_actions@mubasher_db_link m272,
           mubasher_oms.m77_symbols@mubasher_db_link m77
     WHERE     m273.m273_corporate_action = m272.m272_id
           AND m272.m272_symbol = m77.m77_id(+)
           AND m77.m77_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T41_CUST_CORP_ACT_DISTRIBUTION',
                 'M273_CORPORATE_ACTION_CUSTOMER',
                 l_source_count,
                 l_error_count_4,
                 '(M272_SYMBOL) INVALID');
END;
/