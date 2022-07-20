DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
    l_error_count_3   NUMBER;
    l_error_count_4   NUMBER;
    l_error_count_5   NUMBER;
BEGIN
    SELECT SUM (rec_count)
      INTO l_source_count
      FROM (SELECT COUNT (*) AS rec_count
              FROM mubasher_oms.t01_order_summary_intraday@mubasher_db_link
            UNION ALL
            SELECT COUNT (*) AS rec_count
              FROM mubasher_oms.t01_order_summary_intraday_arc@mubasher_db_link);

    ----------- Security Account INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM (SELECT t01_security_ac_id, t01_inst_id, t01_m01_customer_id
              FROM mubasher_oms.t01_order_summary_intraday@mubasher_db_link
            UNION ALL
            SELECT t01_security_ac_id, t01_inst_id, t01_m01_customer_id
              FROM mubasher_oms.t01_order_summary_intraday_arc@mubasher_db_link) t01,
           (SELECT u05_id
              FROM mubasher_oms.u05_security_accounts@mubasher_db_link
             WHERE u05_branch_id > 0) u05
     WHERE     t01.t01_inst_id > 0
           AND t01_m01_customer_id > 0
           AND t01.t01_security_ac_id = u05.u05_id(+)
           AND u05.u05_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T01_ORDER',
                 'T01_ORDER_SUMMARY_INTRADAY',
                 l_source_count,
                 l_error_count_1,
                 '(T01_SECURITY_AC_ID) IS INVALID');

    ----------- Symbol INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM (SELECT t01_symbol, t01_inst_id, t01_m01_customer_id
              FROM mubasher_oms.t01_order_summary_intraday@mubasher_db_link
            UNION ALL
            SELECT t01_symbol, t01_inst_id, t01_m01_customer_id
              FROM mubasher_oms.t01_order_summary_intraday_arc@mubasher_db_link) t01,
           mubasher_oms.m77_symbols@mubasher_db_link m77
     WHERE     t01.t01_inst_id > 0
           AND t01.t01_m01_customer_id > 0
           AND t01.t01_symbol = m77.m77_symbol(+)
           AND m77.m77_symbol IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T01_ORDER',
                 'T01_ORDER_SUMMARY_INTRADAY',
                 l_source_count,
                 l_error_count_2,
                 '(T01_SYMBOL) IS INVALID');

    ----------- Security Account & Exchange INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_3
      FROM (SELECT t01_security_ac_id,
                   t01_inst_id,
                   t01_m01_customer_id,
                   t01_exchange
              FROM mubasher_oms.t01_order_summary_intraday@mubasher_db_link
            UNION ALL
            SELECT t01_security_ac_id,
                   t01_inst_id,
                   t01_m01_customer_id,
                   t01_exchange
              FROM mubasher_oms.t01_order_summary_intraday_arc@mubasher_db_link) t01,
           mubasher_oms.u06_routing_accounts@mubasher_db_link u06,
           (SELECT u05_id
              FROM mubasher_oms.u05_security_accounts@mubasher_db_link u05
             WHERE u05.u05_branch_id > 0) u05
     WHERE     t01.t01_inst_id > 0
           AND t01_m01_customer_id > 0
           AND t01.t01_security_ac_id = u05.u05_id
           AND t01.t01_security_ac_id = u06.u06_security_ac_id(+)
           AND t01.t01_exchange = u06.u06_exchange(+)
           AND u06.u06_security_ac_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T01_ORDER',
                 'T01_ORDER_SUMMARY_INTRADAY',
                 l_source_count,
                 l_error_count_3,
                 '(T01_SECURITY_AC_ID, T01_EXCHANGE) IS INVALID');


    ----------- Customer INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_4
      FROM (SELECT t01_inst_id, t01_m01_customer_id
              FROM mubasher_oms.t01_order_summary_intraday@mubasher_db_link
            UNION ALL
            SELECT t01_inst_id, t01_m01_customer_id
              FROM mubasher_oms.t01_order_summary_intraday_arc@mubasher_db_link) t01,
           mubasher_oms.m01_customer@mubasher_db_link
     WHERE     t01_inst_id > 0
           AND t01_m01_customer_id > 0
           AND t01_m01_customer_id = m01_customer_id(+)
           AND m01_customer_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T01_ORDER',
                 'T01_ORDER_SUMMARY_INTRADAY',
                 l_source_count,
                 l_error_count_4,
                 '(T01_M01_CUSTOMER_ID) IS INVALID');


    ----------- Symbol / External Ref. INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_5
      FROM (SELECT t01_inst_id, t01_m01_customer_id, t01_symbol
              FROM mubasher_oms.t01_order_summary_intraday@mubasher_db_link
            UNION ALL
            SELECT t01_inst_id, t01_m01_customer_id, t01_symbol
              FROM mubasher_oms.t01_order_summary_intraday_arc@mubasher_db_link) t01,
           mubasher_oms.m77_symbols@mubasher_db_link m77,
           (SELECT m77_external_ref
              FROM mubasher_oms.m77_symbols@mubasher_db_link
             WHERE m77_external_ref IS NOT NULL) m77_ex_ref
     WHERE     t01_inst_id > 0
           AND t01_m01_customer_id > 0
           AND t01.t01_symbol = m77.m77_symbol(+)
           AND m77.m77_symbol IS NULL
           AND t01.t01_symbol = m77_ex_ref.m77_external_ref(+)
           AND m77_ex_ref.m77_external_ref IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T01_ORDER',
                 'T01_ORDER_SUMMARY_INTRADAY',
                 l_source_count,
                 l_error_count_5,
                 '(T01_SYMBOL) NOT IN (M77_SYMBOL & M77_EXTERNAL_REF)');
END;
/