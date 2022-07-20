DECLARE
    l_cust_family_mem_id   NUMBER;
    l_sqlerrm              VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m109_id), 0)
      INTO l_cust_family_mem_id
      FROM dfn_ntp.m109_customer_family_members;

    DELETE FROM error_log
          WHERE mig_table = 'M109_CUSTOMER_FAMILY_MEMBERS';

    FOR i
        IN (SELECT m131.m131_id,
                   u01_map.new_customer_id,
                   u01_map_family_mem.new_customer_id AS family_member_id,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m131.m131_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m131.m131_modified_date AS modified_date,
                   u01.u01_institute_id_m02 AS u01_institute_id_m02,
                   m109_map.new_cust_family_mem_id
              FROM mubasher_oms.m131_customer_family_members@mubasher_db_link m131,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_created,
                   dfn_ntp.u17_employee u17,
                   u01_customer_mappings u01_map,
                   dfn_ntp.u01_customer u01,
                   u01_customer_mappings u01_map_family_mem,
                   m109_cust_family_mem_mappings m109_map
             WHERE     m131.m131_customer_id = u01_map.old_customer_id
                   AND m131.m131_family_member =
                           u01_map_family_mem.old_customer_id
                   AND u01_map.new_customer_id = u01.u01_id
                   AND m131.m131_created_by = u17_created.old_employee_id(+)
                   AND u17_created.new_employee_id = u17.u17_id(+)
                   AND m131.m131_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m131.m131_id = m109_map.old_cust_family_mem_id(+))
    LOOP
        BEGIN
            IF i.new_cust_family_mem_id IS NULL
            THEN
                l_cust_family_mem_id := l_cust_family_mem_id + 1;

                INSERT
                  INTO dfn_ntp.m109_customer_family_members (
                           m109_id,
                           m109_customer_id_u01,
                           m109_family_member_id_u01,
                           m109_created_by_id_u17,
                           m109_created_date,
                           m109_modified_by_id_u17,
                           m109_modified_date,
                           m109_status_id_v01,
                           m109_status_changed_by_id_u17,
                           m109_status_changed_date,
                           m109_custom_type,
                           m109_institute_id_m02)
                VALUES (l_cust_family_mem_id, -- m109_id
                        i.new_customer_id, -- m109_customer_id_u01
                        i.family_member_id, -- m109_family_member_id_u01
                        i.created_by_new_id, -- m109_created_by_id_u17
                        i.created_date, -- m109_created_date
                        i.modifed_by_new_id, -- m109_modified_by_id_u17
                        i.modified_date, -- m109_modified_date
                        2, -- m109_status_id_v01
                        i.modifed_by_new_id, -- m109_status_changed_by_id_u17
                        i.modified_date, -- m109_status_changed_date
                        '1', -- m109_custom_type
                        i.u01_institute_id_m02 -- m109_institute_id_m02
                                              );

                INSERT INTO m109_cust_family_mem_mappings
                     VALUES (i.m131_id, l_cust_family_mem_id);
            ELSE
                UPDATE dfn_ntp.m109_customer_family_members
                   SET m109_customer_id_u01 = i.new_customer_id, -- m109_customer_id_u01
                       m109_family_member_id_u01 = i.family_member_id, -- m109_family_member_id_u01
                       m109_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m109_modified_by_id_u17
                       m109_modified_date = NVL (i.modified_date, SYSDATE), -- m109_modified_date
                       m109_status_id_v01 = 2, -- m109_status_id_v01
                       m109_status_changed_by_id_u17 = i.modifed_by_new_id, -- m109_status_changed_by_id_u17
                       m109_status_changed_date = i.modified_date, -- m109_status_changed_date
                       m109_institute_id_m02 = i.u01_institute_id_m02 -- m109_institute_id_m02
                 WHERE m109_id = i.new_cust_family_mem_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M109_CUSTOMER_FAMILY_MEMBERS',
                                i.m131_id,
                                CASE
                                    WHEN i.new_cust_family_mem_id IS NULL
                                    THEN
                                        l_cust_family_mem_id
                                    ELSE
                                        i.new_cust_family_mem_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cust_family_mem_id IS NULL
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
