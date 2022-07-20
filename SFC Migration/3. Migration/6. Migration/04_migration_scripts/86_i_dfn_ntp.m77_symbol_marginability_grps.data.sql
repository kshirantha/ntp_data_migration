DECLARE
    l_symbol_margin_grp_id   NUMBER;
    l_global_percentage      NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m77_id), 0)
      INTO l_symbol_margin_grp_id
      FROM dfn_ntp.m77_symbol_marginability_grps;

    SELECT NVL (MAX (m48_value), 0)
      INTO l_global_percentage
      FROM mubasher_oms.m48_sys_para@mubasher_db_link
     WHERE m48_id = 'DEFAULT_MARGIN_PERCENTAGE';

    DELETE FROM error_log
          WHERE mig_table = 'M77_SYMBOL_MARGINABILITY_GRPS';

    FOR i
        IN (SELECT m291.m291_id,
                   m02_map.new_institute_id,
                   m291.m291_name,
                   m291.m291_additional_details,
                   map01.map01_ntp_id,
                   NVL (u17_created_by.new_employee_id, 0)
                       AS created_by_new_id,
                   NVL (m291_created_date, SYSDATE) AS created_date,
                   u17_modified_by.new_employee_id AS last_updated_by_new_id,
                   m291_last_updated_date AS last_updated_date,
                   NVL (u17_status_changed_by.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m291_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m291_is_default,
                   m77_map.new_symbol_margin_grp_id
              FROM mubasher_oms.m291_symbol_marginability_grps@mubasher_db_link m291,
                   map01_approval_status_v01 map01,
                   m02_institute_mappings m02_map,
                   u17_employee_mappings u17_created_by,
                   u17_employee_mappings u17_modified_by,
                   u17_employee_mappings u17_status_changed_by,
                   m77_symbol_margin_grp_mappings m77_map
             WHERE     m291.m291_status_id = map01.map01_oms_id
                   AND m291.m291_institution = m02_map.old_institute_id
                   AND m291.m291_created_by =
                           u17_created_by.old_employee_id(+)
                   AND m291.m291_last_updated_by =
                           u17_modified_by.old_employee_id(+)
                   AND m291.m291_status_changed_by =
                           u17_status_changed_by.old_employee_id(+)
                   AND m291.m291_id = m77_map.old_symbol_margin_grp_id(+))
    LOOP
        BEGIN
            IF i.new_symbol_margin_grp_id IS NULL
            THEN
                l_symbol_margin_grp_id := l_symbol_margin_grp_id + 1;

                INSERT
                  INTO dfn_ntp.m77_symbol_marginability_grps (
                           m77_id,
                           m77_institution_m02,
                           m77_name,
                           m77_additional_details,
                           m77_allow_online_cash_out,
                           m77_category_percentage_a,
                           m77_category_percentage_b,
                           m77_category_percentage_c,
                           m77_category_percentage_d,
                           m77_category_percentage_e,
                           m77_category_percentage_f,
                           m77_is_default,
                           m77_status_id_v01,
                           m77_status_changed_date,
                           m77_status_changed_by_id_u17,
                           m77_created_date,
                           m77_created_by_id_u17,
                           m77_last_updated_date,
                           m77_last_updated_by_id_u17,
                           m77_mrg_call_notify_lvl,
                           m77_mrg_call_remind_lvl,
                           m77_mrg_call_liquid_lvl,
                           m77_custom_type,
                           m77_global_marginable_per)
                VALUES (l_symbol_margin_grp_id, -- m77_id
                        i.new_institute_id, -- m77_institution_m02
                        i.m291_name, -- m77_name
                        i.m291_additional_details, -- m77_additional_details
                        0, -- m77_allow_online_cash_out | Not Available
                        NULL, -- m77_category_percentage_a
                        NULL, -- m77_category_percentage_b
                        NULL, -- m77_category_percentage_c
                        NULL, -- m77_category_percentage_d
                        NULL, -- m77_category_percentage_e
                        NULL, -- m77_category_percentage_f
                        i.m291_is_default, -- m77_is_default
                        i.map01_ntp_id, -- m77_status_id_v01
                        i.status_changed_date, -- m77_status_changed_date
                        i.status_changed_by_new_id, -- m77_status_changed_by_id_u17
                        i.created_date, -- m77_created_date
                        i.created_by_new_id, -- m77_created_by_id_u17
                        i.last_updated_date, -- m77_last_updated_date
                        i.last_updated_by_new_id, -- m77_last_updated_by_id_u17
                        0, -- m77_mrg_call_notify_lvl
                        0, -- m77_mrg_call_remind_lvl
                        0, -- m77_mrg_call_liquid_lvl
                        '1', -- m77_custom_type
                        l_global_percentage -- m77_global_marginable_per
                                           );

                INSERT INTO m77_symbol_margin_grp_mappings
                     VALUES (i.m291_id, l_symbol_margin_grp_id);
            ELSE
                UPDATE dfn_ntp.m77_symbol_marginability_grps
                   SET m77_institution_m02 = i.new_institute_id, -- m77_institution_m02
                       m77_name = i.m291_name, -- m77_name
                       m77_additional_details = i.m291_additional_details, -- m77_additional_details
                       m77_is_default = i.m291_is_default, -- m77_is_default
                       m77_status_id_v01 = i.map01_ntp_id, -- m77_status_id_v01
                       m77_status_changed_date = i.status_changed_date, -- m77_status_changed_date
                       m77_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m77_status_changed_by_id_u17
                       m77_last_updated_date =
                           NVL (i.last_updated_date, SYSDATE), -- m77_last_updated_date
                       m77_last_updated_by_id_u17 =
                           NVL (i.last_updated_by_new_id, 0), -- m77_last_updated_by_id_u17
                       m77_global_marginable_per = l_global_percentage -- m77_global_marginable_per
                 WHERE m77_id = i.new_symbol_margin_grp_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M77_SYMBOL_MARGINABILITY_GRPS',
                                i.m291_id,
                                CASE
                                    WHEN i.new_symbol_margin_grp_id IS NULL
                                    THEN
                                        l_symbol_margin_grp_id
                                    ELSE
                                        i.new_symbol_margin_grp_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_symbol_margin_grp_id IS NULL
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
