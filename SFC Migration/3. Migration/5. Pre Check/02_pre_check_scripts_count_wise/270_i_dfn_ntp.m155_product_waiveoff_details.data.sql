DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'M237_CUST_SUBSCRIPTION_WAVEOFF';

    ----------- Customer Subscription Product INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count
      FROM mubasher_oms.m237_cust_subscription_waveoff@mubasher_db_link m237,
           mubasher_oms.m236_price_subscription_fees@mubasher_db_link m236
     WHERE m237.m237_prd_id = m236.m236_id(+) AND m236.m236_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M155_PRODUCT_WAIVEOFF_DETAILS',
                 'M237_CUST_SUBSCRIPTION_WAVEOFF',
                 l_source_count,
                 l_error_count,
                 '(M237_PRD_ID) INVALID');
END;
/
