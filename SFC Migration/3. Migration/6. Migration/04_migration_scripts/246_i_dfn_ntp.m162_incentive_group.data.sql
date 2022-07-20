DECLARE
    l_incentive_group_id   NUMBER;
    l_sqlerrm              VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m162_id), 0)
      INTO l_incentive_group_id
      FROM dfn_ntp.m162_incentive_group;

    DELETE FROM error_log
          WHERE mig_table = 'M162_INCENTIVE_GROUP';

    FOR i
        IN (  SELECT m80.m80_id,
                     m80.m80_description,
                     m80.m80_institute_id,
                     map2.new_institute_id,
                     m80.m80_additional_details,
                     m80.m80_created_by,
                     m80.m80_created_date,
                     NVL (u17_created_by.new_employee_id, 0) AS created_by,
                     NVL (m80.m80_created_date, SYSDATE) AS created_date,
                     u17_last_updated_by.new_employee_id AS last_updated_by,
                     m80.m80_last_updated_date AS last_updated_date,
                     m80.m80_status_id,
                     map1.map01_ntp_id,
                     m80.m80_status_changed_by,
                     m80.m80_status_changed_date,
                     NVL (u17_status_changed_by.new_employee_id, 0)
                         AS status_changed_by,
                     NVL (m80.m80_status_changed_date, SYSDATE)
                         AS status_changed_date,
                     m162_map.new_incentive_group_id
                FROM mubasher_oms.m80_agent_commission_groups@mubasher_db_link m80,
                     m02_institute_mappings map2,
                     map01_approval_status_v01 map1,
                     u17_employee_mappings u17_created_by,
                     u17_employee_mappings u17_last_updated_by,
                     u17_employee_mappings u17_status_changed_by,
                     dfn_mig.m162_incentive_group_mappings m162_map
               WHERE     m80.m80_created_by = u17_created_by.old_employee_id(+)
                     AND m80.m80_last_updated_by =
                             u17_last_updated_by.old_employee_id(+)
                     AND m80.m80_status_changed_by =
                             u17_status_changed_by.old_employee_id(+)
                     AND m80.m80_status_id = map1.map01_oms_id
                     AND m80.m80_institute_id = map2.old_institute_id
                     AND m80.m80_id = m162_map.old_incentive_group_id(+)
            ORDER BY m80.m80_id)
    LOOP
        BEGIN
            IF i.new_incentive_group_id IS NULL
            THEN
                l_incentive_group_id := l_incentive_group_id + 1;

                INSERT
                  INTO dfn_ntp.m162_incentive_group (
                           m162_id,
                           m162_description,
                           m162_institute_id_m02,
                           m162_is_default,
                           m162_created_by_id_u17,
                           m162_created_date,
                           m162_modified_by_id_u17,
                           m162_modified_date,
                           m162_status_id_v01,
                           m162_status_changed_by_id_u17,
                           m162_status_changed_date,
                           m162_custom_type,
                           m162_additional_details,
                           m162_group_type_id_v01,
                           m162_frequency_id_v01,
                           m162_commission_type_id_v01)
                VALUES (l_incentive_group_id, -- m162_id
                        i.m80_description, -- m162_description
                        i.new_institute_id, -- m162_institute_id_m02
                        0, -- m162_is_default | Not Available
                        i.created_by, -- m162_created_by_id_u17
                        i.created_date, -- m162_created_date
                        i.last_updated_by, -- m162_modified_by_id_u17
                        i.last_updated_date, -- m162_modified_date
                        i.map01_ntp_id, -- m162_status_id_v01
                        i.status_changed_by, -- m162_status_changed_by_id_u17
                        i.status_changed_date, -- m162_status_changed_date
                        '1', -- m162_custom_type
                        i.m80_additional_details, -- m162_additional_details
                        3, -- m162_group_type_id_v01 |  3 - Introducing Broker
                        2, -- m162_frequency_id_v01 | 2 - Daily
                        2 -- m162_commission_type_id_v01  | 2 - Broker Commission
                         );

                INSERT
                  INTO m162_incentive_group_mappings (old_incentive_group_id,
                                                      new_incentive_group_id)
                VALUES (i.m80_id, l_incentive_group_id);
            ELSE
                UPDATE dfn_ntp.m162_incentive_group
                   SET m162_description = i.m80_description, -- m162_description
                       m162_institute_id_m02 = i.new_institute_id, -- m162_institute_id_m02
                       m162_modified_by_id_u17 = NVL (i.last_updated_by, 0), -- m162_modified_by_id_u17
                       m162_modified_date = NVL (i.last_updated_date, SYSDATE), -- m162_modified_date
                       m162_status_id_v01 = i.map01_ntp_id, -- m162_status_id_v01
                       m162_status_changed_by_id_u17 = i.status_changed_by, -- m162_status_changed_by_id_u17
                       m162_status_changed_date = i.status_changed_date, -- m162_status_changed_date
                       m162_additional_details = i.m80_additional_details -- m162_additional_details
                 WHERE m162_id = i.new_incentive_group_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M162_INCENTIVE_GROUP',
                                i.m80_id,
                                CASE
                                    WHEN i.new_incentive_group_id IS NULL
                                    THEN
                                        l_incentive_group_id
                                    ELSE
                                        i.new_incentive_group_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_incentive_group_id IS NULL
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
