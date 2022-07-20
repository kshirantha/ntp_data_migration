-- Duplicating as TDWL & None TDWL to Segregate Customer Groups into Trading Groups

DECLARE
    l_trading_grp_id   NUMBER;
    l_sqlerrm          VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m08_id), 0)
      INTO l_trading_grp_id
      FROM dfn_ntp.m08_trading_group;

    DELETE FROM error_log
          WHERE mig_table = 'M08_TRADING_GROUP';

    FOR i
        IN ( -- Consider All as TDWL Local Exchange
            SELECT m02_map.new_institute_id,
                   m73.m73_id,
                   m73.m73_institution,
                   m73.m73_description,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m73.m73_created_date, SYSDATE) AS created_date,
                   map01.map01_ntp_id,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m73.m73_last_updated_date AS modifed_date,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m73.m73_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m73.m73_additional_details,
                   m73.m73_rank,
                   1 AS is_local_exchange,
                   CASE WHEN m73.m73_id = 1 THEN 1 ELSE 0 END AS is_default, -- Marked First as the Default
                   m08_map.new_trd_group_id
              FROM mubasher_oms.m73_customer_groups@mubasher_db_link m73,
                   map01_approval_status_v01 map01,
                   m02_institute_mappings m02_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   (SELECT *
                      FROM m08_trd_group_mappings
                     WHERE is_local_exchange = 1) m08_map
             WHERE     m73.m73_status_id = map01.map01_oms_id
                   AND m73.m73_institution = m02_map.old_institute_id
                   AND m73.m73_created_by = u17_created.old_employee_id(+)
                   AND m73.m73_last_updated_by =
                           u17_modified.old_employee_id(+)
                   AND m73.m73_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m73.m73_id = m08_map.old_trd_group_id(+)
            UNION ALL
            -- Dplicating as None TDWL
            SELECT m02_map.new_institute_id,
                   m73.m73_id,
                   m73.m73_institution,
                   m73.m73_description || ' - INTL',
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m73.m73_created_date, SYSDATE) AS created_date,
                   map01.map01_ntp_id,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m73.m73_last_updated_date AS modifed_date,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m73.m73_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m73.m73_additional_details,
                   m73.m73_rank,
                   0 AS is_local_exchange,
                   0 is_default, -- None TDWL Groups are Not Default
                   m08_map.new_trd_group_id
              FROM mubasher_oms.m73_customer_groups@mubasher_db_link m73,
                   map01_approval_status_v01 map01,
                   m02_institute_mappings m02_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   (SELECT *
                      FROM m08_trd_group_mappings
                     WHERE is_local_exchange = 0) m08_map
             WHERE     m73.m73_status_id = map01.map01_oms_id
                   AND m73.m73_institution = m02_map.old_institute_id
                   AND m73.m73_created_by = u17_created.old_employee_id(+)
                   AND m73.m73_last_updated_by =
                           u17_modified.old_employee_id(+)
                   AND m73.m73_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m73.m73_id = m08_map.old_trd_group_id(+))
    LOOP
        BEGIN
            IF i.new_trd_group_id IS NULL
            THEN
                l_trading_grp_id := l_trading_grp_id + 1;

                INSERT
                  INTO dfn_ntp.m08_trading_group (m08_id,
                                                  m08_institute_id_m02,
                                                  m08_name,
                                                  m08_name_lang,
                                                  m08_created_by_id_u17,
                                                  m08_created_date,
                                                  m08_status_id_v01,
                                                  m08_modified_by_id_u17,
                                                  m08_modified_date,
                                                  m08_status_changed_by_id_u17,
                                                  m08_status_changed_date,
                                                  m08_external_ref,
                                                  m08_additional_details,
                                                  m08_rank,
                                                  m08_is_default,
                                                  m08_custom_type)
                VALUES (l_trading_grp_id, -- m08_id
                        i.new_institute_id, -- m08_institute_id_m02
                        i.m73_description, -- m08_name
                        i.m73_description, -- m08_name
                        i.created_by_new_id, -- m08_created_by_id_u17
                        i.created_date, -- m08_created_date
                        i.map01_ntp_id, -- m08_status_id_v01
                        i.modifed_by_new_id, -- m08_modified_by_id_u17
                        i.modifed_date, -- m08_modified_date
                        i.status_changed_by_new_id, -- m08_status_changed_by_id_u17
                        i.status_changed_date, -- m08_status_changed_date
                        i.m73_id, -- m08_external_ref
                        i.m73_additional_details, -- m08_additional_details
                        i.m73_rank, -- m08_rank
                        i.is_default, -- m08_is_default
                        '1' -- m08_custom_type
                           );

                INSERT INTO m08_trd_group_mappings
                     VALUES (i.m73_id, l_trading_grp_id, i.is_local_exchange);
            ELSE
                UPDATE dfn_ntp.m08_trading_group
                   SET m08_institute_id_m02 = i.new_institute_id, -- m08_institute_id_m02
                       m08_name = i.m73_description, -- m08_name
                       m08_name_lang = i.m73_description, -- m08_name
                       m08_status_id_v01 = i.map01_ntp_id, -- m08_status_id_v01
                       m08_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m08_modified_by_id_u17
                       m08_modified_date = NVL (i.modifed_date, SYSDATE), -- m08_modified_date
                       m08_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m08_status_changed_by_id_u17
                       m08_status_changed_date = i.status_changed_date, -- m08_status_changed_date
                       m08_external_ref = i.m73_id, -- m08_external_ref
                       m08_additional_details = i.m73_additional_details, -- m08_additional_details
                       m08_rank = i.m73_rank, -- m08_rank
                       m08_is_default = i.is_default -- m08_is_default
                 WHERE m08_id = i.new_trd_group_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M08_TRADING_GROUP',
                                i.m73_id,
                                   'Is Local : '
                                || i.is_local_exchange
                                || CASE
                                       WHEN i.new_trd_group_id IS NULL
                                       THEN
                                           l_trading_grp_id
                                       ELSE
                                           i.new_trd_group_id
                                   END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_trd_group_id IS NULL
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