DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
    l_error_count_3   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link a
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'T22_AUDIT';

    ----------- Customer INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM mubasher_oms.t22_audit@mubasher_db_link t22,
           mubasher_oms.m04_logins@mubasher_db_link m04,
           mubasher_oms.m01_customer@mubasher_db_link m01
     WHERE     t22.t22_login_id = m04.m04_id(+)
           AND m04.m04_id = m01.m01_login_id(+)
           AND m04.m04_user_type = 0
           AND m01.m01_owner_id > 0
           AND m01.m01_customer_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('A06_AUDIT',
                 'T22_AUDIT',
                 l_source_count,
                 l_error_count_1,
                 'MAPPING (M01_LOGIN_ID) INVALID');

    ----------- User INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.t22_audit@mubasher_db_link t22,
           mubasher_oms.m04_logins@mubasher_db_link m04,
           mubasher_oms.m06_employees@mubasher_db_link m06
     WHERE     t22.t22_login_id = m04.m04_id(+)
           AND m04.m04_id = m06.m06_login_id(+)
           AND m04.m04_user_type = 1
           AND m06.m06_branch_id > 0
           AND m06.m06_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('A06_AUDIT',
                 'T22_AUDIT',
                 l_source_count,
                 l_error_count_2,
                 'MAPPING (M06_LOGIN_ID) INVALID');

    ----------- Audit Activity INVALID -----------

    SELECT COUNT (t22.t22_activity_id)
      INTO l_error_count_3
      FROM mubasher_oms.t22_audit@mubasher_db_link t22,
           mubasher_oms.m04_logins@mubasher_db_link m04,
           map02_audit_activity_m82 map02
     WHERE     t22.t22_login_id = m04.m04_id(+)
           AND t22.t22_activity_id = map02.map02_oms_id(+)
           AND map02.map02_ntp_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('A06_AUDIT',
                 'T22_AUDIT',
                 l_source_count,
                 l_error_count_3,
                 '(T22_ACTIVITY_ID) INVALID');
END;
/