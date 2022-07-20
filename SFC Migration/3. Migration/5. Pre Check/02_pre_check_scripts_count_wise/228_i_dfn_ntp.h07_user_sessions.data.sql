DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'U04_USER_SESSIONS_HISTORY';

    ----------- Customer INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM (  SELECT TO_NUMBER (u04_channel_id),
                     u04_userid,
                     TRUNC (u04_login_time)
                FROM mubasher_oms.u04_user_sessions_history@mubasher_db_link u04,
                     mubasher_oms.m01_customer@mubasher_db_link m01
               WHERE     u04.u04_channel_id NOT IN
                             ('TRS01', 'TRS02', '7', '12')
                     AND u04.u04_userid = m01.m01_customer_id(+)
                     AND m01.m01_customer_id IS NULL
            GROUP BY TO_NUMBER (u04_channel_id),
                     u04_userid,
                     TRUNC (u04_login_time));

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('H07_USER_SESSIONS',
                 'U04_USER_SESSIONS_HISTORY',
                 l_source_count,
                 l_error_count_1,
                 '(U04_USERID) INVALID CUSTOMER');

    ----------- User INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM (  SELECT TO_NUMBER (u04_channel_id),
                     u04_userid,
                     TRUNC (u04_login_time)
                FROM mubasher_oms.u04_user_sessions_history@mubasher_db_link u04,
                     mubasher_oms.m06_employees@mubasher_db_link m06
               WHERE     u04.u04_channel_id NOT IN ('TRS01', 'TRS02')
                     AND u04_channel_id IN ('7', '12')
                     AND u04.u04_userid = m06.m06_id(+)
                     AND m06.m06_id IS NULL
            GROUP BY TO_NUMBER (u04_channel_id),
                     u04_userid,
                     TRUNC (u04_login_time));

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('H07_USER_SESSIONS',
                 'U04_USER_SESSIONS_HISTORY',
                 l_source_count,
                 l_error_count_2,
                 '(U04_USERID) INVALID USER');
END;
/