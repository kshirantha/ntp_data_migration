DECLARE
    l_source_count    NUMBER;
    l_error_count_1   NUMBER;
    l_error_count_2   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M18_SYSTEM_GROUPS_TASKS';

    ----------- Duplicate Primary Keys -----------

    SELECT COUNT (*)
      INTO l_error_count_1
      FROM (  SELECT m18.m18_id
                FROM mubasher_oms.m18_system_groups_tasks@mubasher_db_link m18,
                     mubasher_oms.m09_system_groups@mubasher_db_link m09
               WHERE m18.m18_group_id = m09.m09_id AND m09.m09_inst_id > 0
            GROUP BY m18.m18_id
              HAVING COUNT (*) > 1);

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M46_PERMISSION_GRP_ENTLEMENTS',
                 'M18_SYSTEM_GROUPS_TASKS',
                 l_source_count,
                 l_error_count_1,
                 '(M18_ID) DUPLICATED PRIMARY KEY');

    ----------- Entitlements Not Mapped -----------
    
    SELECT COUNT (*)
      INTO l_error_count_2
      FROM mubasher_oms.m18_system_groups_tasks@mubasher_db_link m18,
           map04_entitlements_v04 map04
     WHERE     m18.m18_task_id = map04.map04_oms_id(+)
           AND map04.map04_ntp_id IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M46_PERMISSION_GRP_ENTLEMENTS',
                 'M18_SYSTEM_GROUPS_TASKS',
                 l_source_count,
                 l_error_count_2,
                 '(MAP04_NTP_ID) NOT MAPPED');
END;
/