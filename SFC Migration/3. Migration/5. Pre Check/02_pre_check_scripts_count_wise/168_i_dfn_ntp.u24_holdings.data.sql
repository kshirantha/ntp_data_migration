DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
    l_error_count_3   NUMBER;
    l_error_count_4   NUMBER;
BEGIN
    SELECT COUNT (*)
      INTO l_source_count
      FROM (SELECT t04_dtl.t04_security_ac_id
              FROM mubasher_oms.t04_holdings_intraday_dtl@mubasher_db_link t04_dtl
             WHERE t04_dtl.t04_exchange <> 'TDWL'
            UNION ALL
            SELECT t04.t04_security_ac_id
              FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04
             WHERE t04.t04_exchange = 'TDWL');


    ----------- Trading Account INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM (SELECT t04_dtl.t04_security_ac_id
              FROM mubasher_oms.t04_holdings_intraday_dtl@mubasher_db_link t04_dtl,
                   (SELECT *
                      FROM mubasher_oms.u05_security_accounts@mubasher_db_link
                     WHERE u05_branch_id > 0) u05,
                   (SELECT u06_security_ac_id, u06_exchange
                      FROM mubasher_oms.u06_routing_accounts@mubasher_db_link) u06
             WHERE     t04_dtl.t04_security_ac_id = u05.u05_id
                   AND t04_dtl.t04_exchange <> 'TDWL'
                   AND t04_dtl.t04_security_ac_id = u06.u06_security_ac_id(+)
                   AND t04_dtl.t04_exchange = u06.u06_exchange(+)
                   AND (   t04_dtl.t04_security_ac_id IS NULL
                        OR u06.u06_security_ac_id IS NULL)
            UNION ALL
            SELECT t04.t04_security_ac_id
              FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04,
                   (SELECT *
                      FROM mubasher_oms.u05_security_accounts@mubasher_db_link
                     WHERE u05_branch_id > 0) u05,
                   (SELECT u06_security_ac_id, u06_exchange
                      FROM mubasher_oms.u06_routing_accounts@mubasher_db_link) u06
             WHERE     t04.t04_security_ac_id = u05.u05_id(+)
                   AND t04.t04_exchange = 'TDWL'
                   AND t04.t04_security_ac_id = u06.u06_security_ac_id(+)
                   AND t04.t04_exchange = u06.u06_exchange(+)
                   AND (   t04.t04_security_ac_id IS NULL
                        OR u06.u06_security_ac_id IS NULL));

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U24_HOLDINGS',
                 'T04_HOLDINGS_INTRADAY, T04_HOLDINGS_INTRADAY_DTL',
                 l_source_count,
                 l_error_count_1,
                 '(T04_SECURITY_AC_ID) INVALID');


    ----------- Symbol INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM (SELECT t04_dtl.t04_security_ac_id
              FROM mubasher_oms.t04_holdings_intraday_dtl@mubasher_db_link t04_dtl,
                   mubasher_oms.m77_symbols@mubasher_db_link m77
             WHERE     t04_dtl.t04_exchange <> 'TDWL'
                   AND t04_dtl.t04_symbol = m77.m77_symbol(+)
                   AND m77.m77_symbol IS NULL
            UNION ALL
            SELECT t04.t04_security_ac_id
              FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04,
                   mubasher_oms.m77_symbols@mubasher_db_link m77
             WHERE     t04.t04_exchange = 'TDWL'
                   AND t04.t04_symbol = m77.m77_symbol(+)
                   AND m77.m77_symbol IS NULL);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U24_HOLDINGS',
                 'T04_HOLDINGS_INTRADAY, T04_HOLDINGS_INTRADAY_DTL',
                 l_source_count,
                 l_error_count_2,
                 '(T04_SYMBOL) INVALID');

    ----------- T04_NET_HOLDING of T04 & T04_DTL MISMATCHED -----------

    SELECT COUNT (*)
      INTO l_error_count_3
      FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04,
           (  SELECT SUM (t04_net_holdings) AS t04_net_holdings_dtl,
                     t04_exchange,
                     t04_security_ac_id,
                     t04_symbol
                FROM mubasher_oms.t04_holdings_intraday_dtl@mubasher_db_link
            GROUP BY t04_exchange, t04_security_ac_id, t04_symbol) t04_dtl
     WHERE     t04.t04_security_ac_id = t04_dtl.t04_security_ac_id
           AND t04.t04_exchange = t04_dtl.t04_exchange
           AND t04.t04_symbol = t04_dtl.t04_symbol
           AND t04.t04_exchange <> 'TDWL'
           AND t04.t04_net_holdings <> t04_dtl.t04_net_holdings_dtl;


    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U24_HOLDINGS',
                 'T04_HOLDINGS_INTRADAY, T04_HOLDINGS_INTRADAY_DTL',
                 l_source_count,
                 l_error_count_3,
                 'T04_NET_HOLDING OF T04 & T04_DTL MISMATCHED');

    ----------- Symbol / External Ref. INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_4
      FROM (SELECT DISTINCT t04_dtl.t04_symbol
              FROM mubasher_oms.t04_holdings_intraday_dtl@mubasher_db_link t04_dtl,
                   mubasher_oms.m77_symbols@mubasher_db_link m77,
                   (SELECT m77_external_ref
                      FROM mubasher_oms.m77_symbols@mubasher_db_link
                     WHERE m77_external_ref IS NOT NULL) m77_ex_ref
             WHERE     t04_dtl.t04_exchange <> 'TDWL'
                   AND t04_dtl.t04_symbol = m77.m77_symbol(+)
                   AND m77.m77_symbol IS NULL
                   AND t04_dtl.t04_symbol = m77_ex_ref.m77_external_ref(+)
                   AND m77_ex_ref.m77_external_ref IS NULL
            UNION ALL
            SELECT DISTINCT t04_dtl.t04_symbol
              FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04_dtl,
                   mubasher_oms.m77_symbols@mubasher_db_link m77,
                   (SELECT m77_external_ref
                      FROM mubasher_oms.m77_symbols@mubasher_db_link
                     WHERE m77_external_ref IS NOT NULL) m77_ex_ref
             WHERE     t04_dtl.t04_exchange = 'TDWL'
                   AND t04_dtl.t04_symbol = m77.m77_symbol(+)
                   AND m77.m77_symbol IS NULL
                   AND t04_dtl.t04_symbol = m77_ex_ref.m77_external_ref(+)
                   AND m77_ex_ref.m77_external_ref IS NULL);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U24_HOLDINGS',
                 'T04_HOLDINGS_INTRADAY, T04_HOLDINGS_INTRADAY_DTL',
                 l_source_count,
                 l_error_count_4,
                 '(T04_SYMBOL) NOT IN (M77_SYMBOL / M77_EXTERNAL_REF)');
END;
/