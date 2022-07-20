DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link a
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'M166_EXCHANGE_MARKET_STATUS';

    ----------- Market Status INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count
      FROM mubasher_oms.m166_exchange_market_status@mubasher_db_link m166,
           dfn_ntp.v19_market_status v19
     WHERE     m166.m166_market_status = v19.v19_price_mapping_id(+)
           AND v19.v19_price_mapping_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M59_EXCHANGE_MARKET_STATUS',
                 'M166_EXCHANGE_MARKET_STATUS',
                 l_source_count,
                 l_error_count,
                 '(M166_MARKET_STATUS) INVALID');
END;
/
