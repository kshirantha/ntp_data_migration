DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link a
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M04_LOGINS';

    ----------- Login ID NULL -----------

    SELECT COUNT (*)
      INTO l_error_count
      FROM mubasher_oms.m04_logins@mubasher_db_link m04,
           (SELECT m01_login_id
              FROM mubasher_oms.m01_customer@mubasher_db_link
             WHERE m01_owner_id > 0) m01
     WHERE m04.m04_id = m01.m01_login_id(+) AND m01.m01_login_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('U09_CUSTOMER_LOGIN',
                 'M04_LOGINS',
                 l_source_count,
                 l_error_count,
                 '(M01_LOGIN_ID) NULL');
END;
/