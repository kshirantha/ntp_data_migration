DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link a
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'U01_USER_SESSIONS';

    ----------- Customer Login ID INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.u01_user_sessions@mubasher_db_link u01_oms,
           mubasher_oms.m04_logins@mubasher_db_link m04_oms,
           mubasher_oms.m01_customer@mubasher_db_link m01_oms
     WHERE     u01_oms.u01_login_id = m04_oms.m04_id(+)
           AND m04_oms.m04_id = m01_oms.m01_login_id(+)
           AND u01_oms.u01_usertype NOT IN (7, 12)
           AND m04_oms.m04_user_type = 0
           AND m01_oms.m01_login_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('H07_USER_SESSIONS - Live',
                 'U01_USER_SESSIONS',
                 l_source_count,
                 l_error_count_1,
                 '(U01_LOGIN_ID) INVALID');

    ----------- User ID INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.u01_user_sessions@mubasher_db_link u01_oms,
           mubasher_oms.m04_logins@mubasher_db_link m04_oms,
           mubasher_oms.m06_employees@mubasher_db_link m06_oms
     WHERE     u01_oms.u01_login_id = m04_oms.m04_id(+)
           AND m04_oms.m04_id = m06_oms.m06_login_id(+)
           AND u01_oms.u01_usertype IN (7, 12)
           AND m04_oms.m04_user_type = 1
           AND m06_oms.m06_login_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('H07_USER_SESSIONS - Live',
                 'U01_USER_SESSIONS',
                 l_source_count,
                 l_error_count_2,
                 '(U01_USERID) INVALID');
END;
/