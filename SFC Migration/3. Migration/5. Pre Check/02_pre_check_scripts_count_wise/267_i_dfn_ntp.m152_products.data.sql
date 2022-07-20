DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
    l_error_count_3   NUMBER;
BEGIN
    SELECT COUNT (*)
      INTO l_source_count
      FROM (  SELECT m236_prd_id
                FROM mubasher_oms.m236_price_subscription_fees@mubasher_db_link
            GROUP BY m236_prd_id, m236_currency, m236_customer_group_id) m236,
           mubasher_oms.m238_products@mubasher_db_link m238
     WHERE m236.m236_prd_id = m238.m238_id;

    ----------- Currency Code INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.m238_products@mubasher_db_link m238,
           (  SELECT m236_prd_id, m236_currency
                FROM mubasher_oms.m236_price_subscription_fees@mubasher_db_link
            GROUP BY m236_prd_id, m236_currency, m236_customer_group_id) m236,
           dfn_ntp.m03_currency m03
     WHERE     m238.m238_id = m236.m236_prd_id
           AND m236.m236_currency = m03.m03_code(+)
           AND m03.m03_code IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M152_PRODUCTS',
                 'M238_PRODUCTS , M236_PRICE_SUBSCRIPTION_FEES',
                 l_source_count,
                 l_error_count_1,
                 'MAPPING CURRENCY (M236_CURRENCY) INVALID');

    ----------- Customer Group INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.m238_products@mubasher_db_link m238,
           (  SELECT m236_prd_id, m236_customer_group_id
                FROM mubasher_oms.m236_price_subscription_fees@mubasher_db_link
            GROUP BY m236_prd_id, m236_currency, m236_customer_group_id) m236,
           mubasher_oms.m73_customer_groups@mubasher_db_link m73
     WHERE     m238.m238_id = m236.m236_prd_id
           AND m236.m236_customer_group_id = m73.m73_id(+)
           AND m73.m73_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M152_PRODUCTS',
                 'M238_PRODUCTS , M236_PRICE_SUBSCRIPTION_FEES',
                 l_source_count,
                 l_error_count_2,
                 'MAPPING TRADING GROUP (M236_CUSTOMER_GROUP_ID) INVALID');

    ----------- Product Code INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_3
      FROM mubasher_oms.m238_products@mubasher_db_link m238,
           (  SELECT m236_prd_id, m236_customer_group_id
                FROM mubasher_oms.m236_price_subscription_fees@mubasher_db_link
            GROUP BY m236_prd_id, m236_currency, m236_customer_group_id) m236,
           dfn_ntp.v35_products v35
     WHERE     m238.m238_id = m236.m236_prd_id
           AND m238.m238_product_code = v35.v35_product_code(+)
           AND v35.v35_product_code IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M152_PRODUCTS',
                 'M238_PRODUCTS , M236_PRICE_SUBSCRIPTION_FEES',
                 l_source_count,
                 l_error_count_3,
                 '(M238_PRODUCT_CODE) INVALID');
END;
/
