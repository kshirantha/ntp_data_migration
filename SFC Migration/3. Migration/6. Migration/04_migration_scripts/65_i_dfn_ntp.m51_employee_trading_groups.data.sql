DECLARE
    l_emp_trading_grp_id   NUMBER;
    l_sqlerrm              VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m51_id), 0)
      INTO l_emp_trading_grp_id
      FROM dfn_ntp.m51_employee_trading_groups;

    DELETE FROM error_log
          WHERE mig_table = 'M51_EMPLOYEE_TRADING_GROUPS';

    FOR i
        IN (SELECT m278_id,
                   m08_map.new_trd_group_id,
                   NVL (u17_map.new_employee_id, 0) AS new_employee_id,
                   NVL (m278.m278_assigned_date, SYSDATE) AS assigned_date,
                   NVL (assigned_by.new_employee_id, 0) AS assigned_by_new_id,
                   m51_map.new_emp_trading_grp_id
              FROM mubasher_oms.m278_dealer_customer_group@mubasher_db_link m278
                   JOIN mubasher_oms.m06_employees@mubasher_db_link m06
                       ON m278.m278_exmployee_id = m06.m06_id
                   JOIN m08_trd_group_mappings m08_map
                       ON     m278.m278_customer_group =
                                  m08_map.old_trd_group_id
                          AND CASE
                                  WHEN m06.m06_user_category = 1 THEN 1
                                  ELSE 0
                              END = m08_map.is_local_exchange
                   JOIN u17_employee_mappings u17_map
                       ON m278.m278_exmployee_id = u17_map.old_employee_id
                   LEFT OUTER JOIN u17_employee_mappings assigned_by
                       ON m278.m278_assigned_by = assigned_by.old_employee_id
                   LEFT JOIN m51_emp_trading_grp_mappings m51_map
                       ON m278.m278_id = m51_map.old_emp_trading_grp_id)
    LOOP
        BEGIN
            IF i.new_emp_trading_grp_id IS NULL
            THEN
                l_emp_trading_grp_id := l_emp_trading_grp_id + 1;

                INSERT
                  INTO dfn_ntp.m51_employee_trading_groups (
                           m51_id,
                           m51_trading_group_id_m08,
                           m51_employee_id_u17,
                           m51_assigned_date,
                           m51_assigned_by_u17,
                           m51_custom_type)
                VALUES (l_emp_trading_grp_id, -- m51_id
                        i.new_trd_group_id, -- m51_trading_group_id_m08
                        i.new_employee_id, -- m51_employee_id_u17
                        i.assigned_date, -- m51_assigned_date
                        i.assigned_by_new_id, -- m51_assigned_by_u17
                        '1');

                INSERT INTO m51_emp_trading_grp_mappings
                     VALUES (i.m278_id, l_emp_trading_grp_id);
            ELSE
                UPDATE dfn_ntp.m51_employee_trading_groups
                   SET m51_trading_group_id_m08 = i.new_trd_group_id, -- m51_trading_group_id_m08
                       m51_employee_id_u17 = i.new_employee_id, -- m51_employee_id_u17
                       m51_assigned_date = i.assigned_date, -- m51_assigned_date
                       m51_assigned_by_u17 = i.assigned_by_new_id -- m51_assigned_by_u17
                 WHERE m51_id = i.new_emp_trading_grp_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M51_EMPLOYEE_TRADING_GROUPS',
                                i.m278_id,
                                CASE
                                    WHEN i.new_emp_trading_grp_id IS NULL
                                    THEN
                                        l_emp_trading_grp_id
                                    ELSE
                                        i.new_emp_trading_grp_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_emp_trading_grp_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/