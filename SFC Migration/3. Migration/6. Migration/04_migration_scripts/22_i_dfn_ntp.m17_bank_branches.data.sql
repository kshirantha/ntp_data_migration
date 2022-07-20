DECLARE
    l_bank_branch_id   NUMBER;
    l_sqlerrm          VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m17_id), 0)
      INTO l_bank_branch_id
      FROM dfn_ntp.m17_bank_branches;

    DELETE FROM error_log
          WHERE mig_table = 'M17_BANK_BRANCHES';

    FOR i
        IN (SELECT m168_id,
                   m16_map.new_bank_id,
                   m168_branch_name,
                   m168_address,
                   m168_tel,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m168_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m168_updated_date AS modified_date,
                   m17_map.new_bank_branches_id
              FROM mubasher_oms.m168_bank_branches@mubasher_db_link m168,
                   m16_bank_mappings m16_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   m17_bank_branches_mappings m17_map
             WHERE     m168.m168_bank_id = m16_map.old_bank_id
                   AND m168.m168_created_by = u17_created.old_employee_id(+)
                   AND m168.m168_updated_by = u17_modified.old_employee_id(+)
                   AND m168.m168_id = m17_map.old_bank_branches_id(+))
    LOOP
        BEGIN
            IF i.new_bank_branches_id IS NULL
            THEN
                l_bank_branch_id := l_bank_branch_id + 1;

                INSERT
                  INTO dfn_ntp.m17_bank_branches (m17_id,
                                                  m17_bank_id,
                                                  m17_branch_name,
                                                  m17_address,
                                                  m17_tel,
                                                  m17_created_by_id_u17,
                                                  m17_created_date,
                                                  m17_updated_by_id_u17,
                                                  m17_updated_date,
                                                  m17_external_ref,
                                                  m17_custom_type,
                                                  m17_status_id_v01,
                                                  m17_status_changed_by_id_u17,
                                                  m17_status_changed_date)
                VALUES (l_bank_branch_id, -- m17_id
                        i.new_bank_id, -- m17_bank_id
                        i.m168_branch_name, -- m17_branch_name
                        i.m168_address, -- m17_address
                        i.m168_tel, -- m17_tel
                        i.created_by_new_id, -- m17_created_by_id_u17
                        i.created_date, -- m17_created_date
                        i.modifed_by_new_id, -- m17_updated_by_id_u17
                        i.modified_date, -- m17_updated_date
                        i.m168_id, -- m17_external_ref
                        '1', -- m17_custom_type
                        2, -- m17_status_id_v01 | Not Available
                        i.created_by_new_id, -- m17_status_changed_by_id_u17 | Not Available
                        i.created_date -- m17_status_changed_date | Not Available
                                      );

                INSERT INTO m17_bank_branches_mappings
                     VALUES (i.m168_id, l_bank_branch_id);
            ELSE
                UPDATE dfn_ntp.m17_bank_branches
                   SET m17_bank_id = i.new_bank_id, -- m17_bank_id
                       m17_branch_name = i.m168_branch_name, -- m17_branch_name
                       m17_address = i.m168_address, -- m17_address
                       m17_tel = i.m168_tel, -- m17_tel
                       m17_updated_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m17_updated_by_id_u17
                       m17_updated_date = NVL (i.modified_date, SYSDATE), -- m17_updated_date
                       m17_external_ref = i.m168_id -- m17_external_ref
                 WHERE m17_id = i.new_bank_branches_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M17_BANK_BRANCHES',
                                i.m168_id,
                                CASE
                                    WHEN i.new_bank_branches_id IS NULL
                                    THEN
                                        l_bank_branch_id
                                    ELSE
                                        i.new_bank_branches_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_bank_branches_id IS NULL
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
