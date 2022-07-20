DECLARE
    l_order_limit_group_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m176_id), 0)
      INTO l_order_limit_group_id
      FROM dfn_ntp.m176_order_limit_group;

    DELETE FROM error_log
          WHERE mig_table = 'M176_ORDER_LIMIT_GROUP';

    FOR i
        IN (SELECT m279.m279_id,
                   m279.m279_name,
                   m279.m279_buy_order_limit,
                   m279.m279_sell_order_limit,
                   m279.m279_default,
                   NVL (u17_created.new_employee_id, 0) AS created_by,
                   NVL (m279.m279_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modified_by,
                   m279.m279_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   m02_map.new_institute_id,
                   m176_map.new_order_limit_grp_id
              FROM mubasher_oms.m279_transaction_limit_group@mubasher_db_link m279,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   m176_order_limit_grp_mappings m176_map
             WHERE     m279.m279_status_id = map01.map01_oms_id
                   AND m279.m279_created_by = u17_created.old_employee_id(+)
                   AND m279.m279_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m279_type = 0
                   AND m279.m279_id = m176_map.old_order_limit_grp_id(+)
                   AND m02_map.new_institute_id =
                           m176_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_order_limit_grp_id IS NULL
            THEN
                l_order_limit_group_id := l_order_limit_group_id + 1;

                INSERT
                  INTO dfn_ntp.m176_order_limit_group (
                           m176_id,
                           m176_group_name,
                           m176_buy_order_limit,
                           m176_sell_order_limit,
                           m176_frequency_id_v01,
                           m176_is_default,
                           m176_status_id_v01,
                           m176_created_by_id_u17,
                           m176_created_date,
                           m176_status_changed_by_id_u17,
                           m176_status_changed_date,
                           m176_modified_by_id_u17,
                           m176_modified_date,
                           m176_custom_type,
                           m176_institute_id_m02,
                           m176_enable_category_limit,
                           m176_online_buy_order_limit,
                           m176_online_sell_order_limit,
                           m176_offline_buy_order_limit,
                           m176_offline_sell_order_limit)
                VALUES (l_order_limit_group_id, -- m176_id
                        i.m279_name, -- m176_group_name
                        0, -- m176_buy_order_limit | Not Used by SFC
                        0, -- m176_sell_order_limit | Not Used by SFC
                        2, -- m176_frequency_id_v01 | Not Available (2 - Per Transactions)
                        i.m279_default, -- m176_is_default
                        i.map01_ntp_id, -- m176_status_id_v01
                        i.created_by, -- m176_created_by_id_u17
                        i.created_date, -- m176_created_date
                        i.created_by, -- m176_status_changed_by_id_u17
                        i.created_date, -- m176_status_changed_date
                        i.modified_by, -- m176_modified_by_id_u17
                        i.modified_date, -- m176_modified_date
                        '1', -- m176_custom_type
                        i.new_institute_id, -- m176_institute_id_m02
                        1, -- M176_enable_category_limit | Set for Online Scenario [Onsite Changes]
                        i.m279_buy_order_limit, -- m176_online_buy_order_limit
                        i.m279_sell_order_limit, -- m176_online_sell_order_limit
                        0, -- m176_offline_buy_order_limit | Not Available
                        0 -- m176_offline_sell_order_limit | Not Available
                         );

                INSERT
                  INTO m176_order_limit_grp_mappings (old_order_limit_grp_id,
                                                      new_order_limit_grp_id,
                                                      new_institute_id)
                VALUES (
                           i.m279_id,
                           l_order_limit_group_id,
                           i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m176_order_limit_group
                   SET m176_group_name = i.m279_name, -- m176_group_name
                       m176_is_default = i.m279_default, -- m176_is_default
                       m176_status_id_v01 = i.map01_ntp_id, -- m176_status_id_v01
                       m176_status_changed_by_id_u17 = i.created_by, -- m176_status_changed_by_id_u17
                       m176_status_changed_date = i.created_date, -- m176_status_changed_date
                       m176_modified_by_id_u17 = NVL (i.modified_by, 0), -- m176_modified_by_id_u17
                       m176_modified_date = NVL (i.modified_date, SYSDATE), -- m176_modified_date
                       m176_online_buy_order_limit = i.m279_buy_order_limit, -- m176_online_buy_order_limit
                       m176_online_sell_order_limit = i.m279_sell_order_limit -- m176_online_sell_order_limit
                 WHERE m176_id = i.new_order_limit_grp_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M176_ORDER_LIMIT_GROUP',
                                i.m279_id,
                                CASE
                                    WHEN i.new_order_limit_grp_id IS NULL
                                    THEN
                                        l_order_limit_group_id
                                    ELSE
                                        i.new_order_limit_grp_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_order_limit_grp_id IS NULL
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
