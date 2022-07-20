DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'T85_MURABAHA_CONTRACTS';

    ----------- None TDWL Exchange Agent Security Accounts -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.t85_murabaha_contracts@mubasher_db_link t85_main,
           (SELECT DISTINCT
                   t85_agent_security_ac_id AS t85_agent_security_ac_id
              FROM mubasher_oms.t85_murabaha_contracts@mubasher_db_link t85,
                   mubasher_oms.u06_routing_accounts@mubasher_db_link u06
             WHERE     u06_exchange = 'TDWL'
                   AND t85.t85_agent_security_ac_id = u06.u06_security_ac_id) t85
     WHERE     t85_main.t85_agent_security_ac_id =
                   t85.t85_agent_security_ac_id(+)
           AND t85.t85_agent_security_ac_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T75_MURABAHA_CONTRACTS',
                 'T85_MURABAHA_CONTRACTS',
                 l_source_count,
                 l_error_count_1,
                 '(T85_AGENT_SECURITY_AC_ID) NOT IN TDWL EXCHANGE');

    ----------- None TDWL Exchange Customer Security Accounts -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.t85_murabaha_contracts@mubasher_db_link t85_main,
           (SELECT DISTINCT
                   t85_customer_security_ac_id AS t85_customer_security_ac_id
              FROM mubasher_oms.t85_murabaha_contracts@mubasher_db_link t85,
                   mubasher_oms.u06_routing_accounts@mubasher_db_link u06
             WHERE     u06_exchange = 'TDWL'
                   AND t85.t85_customer_security_ac_id =
                           u06.u06_security_ac_id) t85
     WHERE     t85_main.t85_customer_security_ac_id =
                   t85.t85_customer_security_ac_id(+)
           AND t85.t85_customer_security_ac_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('T75_MURABAHA_CONTRACTS',
                 'T85_MURABAHA_CONTRACTS',
                 l_source_count,
                 l_error_count_2,
                 '(T85_CUSTOMER_SECURITY_AC_ID) NOT IN TDWL EXCHANGE');
END;
/
