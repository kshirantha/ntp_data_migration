DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER;
BEGIN
    SELECT COUNT (*)
      INTO l_source_count
      FROM (SELECT u08.u08_security_ac_id, 12 AS restriction -- 12 - Buy
              FROM mubasher_oms.u08_restricted_symbols@mubasher_db_link u08
             WHERE u08_type IN (1, 3) -- Buy
                                     AND u08_restricted = 1
            UNION ALL
            SELECT u08.u08_security_ac_id, 13 AS restriction -- 13 - Sell
              FROM mubasher_oms.u08_restricted_symbols@mubasher_db_link u08
             WHERE u08_type IN (2, 3) -- Sell
                                     AND u08_restricted = 1);

    SELECT COUNT (*)
      INTO l_error_count
      FROM (SELECT u08.u08_security_ac_id, 12 AS restriction -- 12 - Buy
              FROM mubasher_oms.u08_restricted_symbols@mubasher_db_link u08
             WHERE u08_type IN (1, 3) -- Buy
                                     AND u08_restricted = 1
            UNION ALL
            SELECT u08.u08_security_ac_id, 13 AS restriction -- 13 - Sell
              FROM mubasher_oms.u08_restricted_symbols@mubasher_db_link u08
             WHERE u08_type IN (2, 3) -- Sell
                                     AND u08_restricted = 1) u08
     WHERE    u08.u08_security_ac_id IS NULL
           OR u08.u08_security_ac_id NOT IN
                  (SELECT u05_id
                     FROM mubasher_oms.u05_security_accounts@mubasher_db_link);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U14_TRADING_SYMBOL_RESTRICTION',
                 'U08_RESTRICTED_SYMBOLS',
                 l_source_count,
                 l_error_count,
                 '(U08_SECURITY_AC_ID) INVALID');
END;
/
