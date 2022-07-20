DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'U22_CUSTOMER_MARGIN_PRODUCTS';

    ----------- Margin Product INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.u22_customer_margin_products@mubasher_db_link u22,
           mubasher_oms.m265_margin_products@mubasher_db_link m265
     WHERE u22.u22_margin_product = m265.m265_id(+) AND m265.m265_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U23_CUSTOMER_MARGIN_PRODUCT',
                 'U22_CUSTOMER_MARGIN_PRODUCTS',
                 l_source_count,
                 l_error_count_1,
                 '(M265_SYMBOL_MARGINABILITY_GRP) INVALID');

    ----------- Symbol Marginability Group INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.u22_customer_margin_products@mubasher_db_link u22,
           mubasher_oms.m265_margin_products@mubasher_db_link m265,
           mubasher_oms.m291_symbol_marginability_grps@mubasher_db_link m291
     WHERE     u22.u22_margin_product = m265.m265_id
           AND m265.m265_symbol_marginability_grp = m291.m291_id(+)
           AND m291.m291_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U23_CUSTOMER_MARGIN_PRODUCT',
                 'U22_CUSTOMER_MARGIN_PRODUCTS',
                 l_source_count,
                 l_error_count_2,
                 '(M265_SYMBOL_MARGINABILITY_GRP) INVALID');
END;
/
