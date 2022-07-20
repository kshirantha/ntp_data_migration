DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER;
BEGIN
    SELECT COUNT (*)
      INTO l_source_count
      FROM (SELECT m137_poa,
                   m137_security_ac_id,
                   m137_poa_setdate,
                   m137_poa_expiry_date,
                   20 AS u49_privilege_type_id_v31 -- Buy
              FROM mubasher_oms.m137_customer_poa@mubasher_db_link
             WHERE m137_applicable_for_buy = 1
            UNION ALL
            SELECT m137_poa,
                   m137_security_ac_id,
                   m137_poa_setdate,
                   m137_poa_expiry_date,
                   21 AS u49_privilege_type_id_v31 -- Sell
              FROM mubasher_oms.m137_customer_poa@mubasher_db_link
             WHERE m137_applicable_for_sell = 1
            UNION ALL
            SELECT m137_poa,
                   m137_security_ac_id,
                   m137_poa_setdate,
                   m137_poa_expiry_date,
                   24 AS u49_privilege_type_id_v31 -- Cash Withdraw
              FROM mubasher_oms.m137_customer_poa@mubasher_db_link
             WHERE m137_applicable_for_trans = 1
            UNION ALL
            SELECT m137_poa,
                   m137_security_ac_id,
                   m137_poa_setdate,
                   m137_poa_expiry_date,
                   25 AS u49_privilege_type_id_v31 -- Cash Transfer
              FROM mubasher_oms.m137_customer_poa@mubasher_db_link
             WHERE m137_applicable_for_trans = 1);

    SELECT COUNT (*)
      INTO l_error_count
      FROM (SELECT m137_poa,
                   m137_security_ac_id,
                   m137_poa_setdate,
                   m137_poa_expiry_date,
                   20 AS u49_privilege_type_id_v31 -- Buy
              FROM mubasher_oms.m137_customer_poa@mubasher_db_link
             WHERE m137_applicable_for_buy = 1
            UNION ALL
            SELECT m137_poa,
                   m137_security_ac_id,
                   m137_poa_setdate,
                   m137_poa_expiry_date,
                   21 AS u49_privilege_type_id_v31 -- Sell
              FROM mubasher_oms.m137_customer_poa@mubasher_db_link
             WHERE m137_applicable_for_sell = 1
            UNION ALL
            SELECT m137_poa,
                   m137_security_ac_id,
                   m137_poa_setdate,
                   m137_poa_expiry_date,
                   24 AS u49_privilege_type_id_v31 -- Cash Withdraw
              FROM mubasher_oms.m137_customer_poa@mubasher_db_link
             WHERE m137_applicable_for_trans = 1
            UNION ALL
            SELECT m137_poa,
                   m137_security_ac_id,
                   m137_poa_setdate,
                   m137_poa_expiry_date,
                   25 AS u49_privilege_type_id_v31 -- Cash Transfer
              FROM mubasher_oms.m137_customer_poa@mubasher_db_link
             WHERE m137_applicable_for_trans = 1) m137,
           mubasher_oms.u05_security_accounts@mubasher_db_link u05
     WHERE m137.m137_security_ac_id = u05.u05_id(+) AND u05.u05_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U49_POA_TRADING_PRIVILEGES',
                 'M137_CUSTOMER_POA',
                 l_source_count,
                 l_error_count,
                 '(M137_SECURITY_AC_ID) INVALID');
END;
/
