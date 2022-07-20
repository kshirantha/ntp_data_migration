DECLARE
    l_notification_config_id   NUMBER;
    l_sqlerrm                  VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (u41_id), 0)
      INTO l_notification_config_id
      FROM dfn_ntp.u41_notification_configuration;

    DELETE FROM error_log
          WHERE mig_table = 'U41_NOTIFICATION_CONFIGURATION';

    FOR i
        IN (SELECT m280_id,
                   m02_map.new_institute_id,
                   CASE WHEN m280_notification_type = 1 THEN 48 END
                       AS m280_notification_type,
                   m280_level1_notification,
                   m280_level2_notification,
                   m280_level3_notification,
                   map01.map01_ntp_id,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   u41_map.new_notification_conf_id
              FROM mubasher_oms.m280_master_notifications@mubasher_db_link m280
                   JOIN map01_approval_status_v01 map01
                       ON m280.m280_status_id = map01.map01_oms_id
                   JOIN m02_institute_mappings m02_map
                       ON m280.m280_institution_id = m02_map.old_institute_id
                   LEFT JOIN u17_employee_mappings u17_modified
                       ON m280.m280_modified_by =
                              u17_modified.old_employee_id
                   LEFT JOIN u41_notification_conf_mappings u41_map
                       ON m280.m280_id = u41_map.old_notification_conf_id)
    LOOP
        BEGIN
            IF i.new_notification_conf_id IS NULL
            THEN
                l_notification_config_id := l_notification_config_id + 1;

                INSERT
                  INTO dfn_ntp.u41_notification_configuration (
                           u41_id,
                           u41_institution_id_m02,
                           u41_notification_type_id_m100,
                           u41_status_id_v01,
                           u41_modified_by_id_u17,
                           u41_modified_date,
                           u41_created_by_id_u17,
                           u41_created_date,
                           u41_status_changed_by_id_u17,
                           u41_status_changed_date,
                           u41_date_from,
                           u41_date_to,
                           u41_custom_type,
                           u41_notify_sms_cc_list,
                           u41_notify_email_cc_list)
                VALUES (l_notification_config_id,
                        i.new_institute_id, -- u41_institution_id_m02
                        i.m280_notification_type, -- u41_notification_type_id_m100
                        i.map01_ntp_id, -- u41_status_id_v01
                        i.modifed_by_new_id, -- u41_modified_by_id_u17
                        SYSDATE, -- u41_modified_date
                        i.modifed_by_new_id, -- u41_created_by_id_u17
                        SYSDATE, -- u41_created_date
                        i.modifed_by_new_id, --- u41_status_changed_by_id_u17
                        SYSDATE, -- u41_status_changed_date
                        NULL, -- u41_date_from
                        NULL, -- u41_date_to
                        '1', -- u41_custom_type
                        NULL, -- u41_notify_sms_cc_list | Not Available
                        NULL -- u41_notify_email_cc_list  | Not Available
                            );

                INSERT INTO u41_notification_conf_mappings
                     VALUES (i.m280_id, l_notification_config_id);
            ELSE
                UPDATE dfn_ntp.u41_notification_configuration
                   SET u41_institution_id_m02 = i.new_institute_id, -- u41_institution_id_m02
                       u41_notification_type_id_m100 =
                           i.m280_notification_type, -- u41_notification_type_id_m100
                       u41_status_id_v01 = i.map01_ntp_id, -- u41_status_id_v01
                       u41_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- u41_modified_by_id_u17
                       u41_modified_date = SYSDATE, -- u41_modified_date
                       u41_status_changed_by_id_u17 = i.modifed_by_new_id, --- u41_status_changed_by_id_u17
                       u41_status_changed_date = SYSDATE -- u41_status_changed_date
                 WHERE u41_id = i.new_notification_conf_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U41_NOTIFICATION_CONFIGURATION',
                                i.m280_id,
                                CASE
                                    WHEN i.new_notification_conf_id IS NULL
                                    THEN
                                        l_notification_config_id
                                    ELSE
                                        i.new_notification_conf_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_notification_conf_id IS NULL
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