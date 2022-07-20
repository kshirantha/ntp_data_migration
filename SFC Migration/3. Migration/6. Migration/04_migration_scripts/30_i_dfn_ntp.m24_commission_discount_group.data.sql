DECLARE
    l_comm_disc_group_id   NUMBER;
    l_sqlerrm              VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m24_id), 0)
      INTO l_comm_disc_group_id
      FROM dfn_ntp.m24_commission_discount_group;

    DELETE FROM error_log
          WHERE mig_table = 'M24_COMMISSION_DISCOUNT_GROUP';

    FOR i
        IN (SELECT m278.m278_id,
                   m278.m278_description,
                   m278.m278_name,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m278.m278_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m278.m278_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m278.m278_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m278.m278_external_ref,
                   m02_map.new_institute_id,
                   m24_map.new_comm_disc_grp_id
              FROM mubasher_oms.m278_commision_discount_group@mubasher_db_link m278,
                   map01_approval_status_v01 map01,
                   m02_institute_mappings m02_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m24_comm_disc_grp_mappings m24_map
             WHERE     m278.m278_status_id = map01.map01_oms_id
                   AND m278.m278_institution_id = m02_map.old_institute_id
                   AND m278.m278_created_by = u17_created.old_employee_id(+)
                   AND m278.m278_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m278.m278_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m278.m278_id = m24_map.old_comm_disc_grp_id(+))
    LOOP
        BEGIN
            IF i.new_comm_disc_grp_id IS NULL
            THEN
                l_comm_disc_group_id := l_comm_disc_group_id + 1;

                INSERT
                  INTO dfn_ntp.m24_commission_discount_group (
                           m24_id,
                           m24_description,
                           m24_name,
                           m24_name_lang,
                           m24_created_by_id_u17,
                           m24_created_date,
                           m24_modified_by_id_u17,
                           m24_modified_date,
                           m24_status_id_v01,
                           m24_status_changed_by_id_u17,
                           m24_status_changed_date,
                           m24_external_ref,
                           m24_institution_id_m02,
                           m24_custom_type)
                VALUES (l_comm_disc_group_id, -- m24_id,
                        i.m278_description, -- m24_description
                        i.m278_name, -- m24_name
                        i.m278_name, -- m24_name_lang
                        i.created_by_new_id, -- m24_created_by_id_u17
                        i.created_date, -- m24_created_date
                        i.modifed_by_new_id, -- m24_modified_by_id_u17
                        i.modified_date, -- m24_modified_date
                        i.map01_ntp_id, -- m24_status_id_v01
                        i.status_changed_by_new_id, -- m24_status_changed_by_id_u17
                        i.status_changed_date, -- m24_status_changed_date
                        i.m278_id, -- m24_external_ref
                        i.new_institute_id, -- m24_institution_id_m02
                        '1' --m24_custom_type
                           );

                INSERT INTO m24_comm_disc_grp_mappings
                     VALUES (i.m278_id, l_comm_disc_group_id);
            ELSE
                UPDATE dfn_ntp.m24_commission_discount_group
                   SET m24_description = i.m278_description, -- m24_description
                       m24_name = i.m278_name, -- m24_name
                       m24_name_lang = i.m278_name, -- m24_name_lang
                       m24_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m24_modified_by_id_u17
                       m24_modified_date = NVL (i.modified_date, SYSDATE), -- m24_modified_date
                       m24_status_id_v01 = i.map01_ntp_id, -- m24_status_id_v01
                       m24_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m24_status_changed_by_id_u17
                       m24_status_changed_date = i.status_changed_date, -- m24_status_changed_date
                       m24_external_ref = i.m278_id, -- m24_external_ref
                       m24_institution_id_m02 = i.new_institute_id -- m24_institution_id_m02
                 WHERE m24_id = i.new_comm_disc_grp_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M24_COMMISSION_DISCOUNT_GROUP',
                                i.m278_id,
                                CASE
                                    WHEN i.new_comm_disc_grp_id IS NULL
                                    THEN
                                        l_comm_disc_group_id
                                    ELSE
                                        i.new_comm_disc_grp_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_comm_disc_grp_id IS NULL
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
