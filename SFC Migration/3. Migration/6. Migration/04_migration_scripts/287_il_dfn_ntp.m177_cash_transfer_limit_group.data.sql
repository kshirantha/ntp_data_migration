DECLARE
    l_cash_transfer_limit_group_id   NUMBER;
    l_sqlerrm                        VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m177_id), 0)
      INTO l_cash_transfer_limit_group_id
      FROM dfn_ntp.m177_cash_transfer_limit_group;

    DELETE FROM error_log
          WHERE mig_table = 'M177_CASH_TRANSFER_LIMIT_GROUP';

    FOR i
        IN (SELECT m279.m279_id,
                   m279.m279_name,
                   m279.m279_buy_order_limit,
                   m279.m279_sell_order_limit,
                   m279.m279_transfer_limit,
                   m279.m279_default,
                   NVL (u17_created.new_employee_id, 0) AS created_by,
                   NVL (m279.m279_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modified_by,
                   m279.m279_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   m02_map.new_institute_id,
                   m177_map.new_csh_trns_lmt_grp_id
              FROM mubasher_oms.m279_transaction_limit_group@mubasher_db_link m279,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   m177_csh_trns_lmt_grp_mappings m177_map
             WHERE     m279.m279_status_id = map01.map01_oms_id
                   AND m279.m279_created_by = u17_created.old_employee_id(+)
                   AND m279.m279_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m279_type = 1
                   AND m279.m279_id =
                           m177_map.old_csh_trns_lmt_grp_id(+)
                   AND m02_map.new_institute_id =
                           m177_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_csh_trns_lmt_grp_id IS NULL
            THEN
                l_cash_transfer_limit_group_id :=
                    l_cash_transfer_limit_group_id + 1;

                INSERT
                  INTO dfn_ntp.m177_cash_transfer_limit_group (
                           m177_id,
                           m177_group_name,
                           m177_cash_transfer_limit,
                           m177_frequency_id_v01,
                           m177_is_default,
                           m177_status_id_v01,
                           m177_created_by_id_u17,
                           m177_created_date,
                           m177_status_changed_by_id_u17,
                           m177_status_changed_date,
                           m177_modified_by_id_u17,
                           m177_modified_date,
                           m177_custom_type,
                           m177_institute_id_m02)
                VALUES (l_cash_transfer_limit_group_id, -- m177_id
                        i.m279_name, -- m177_group_name
                        i.m279_transfer_limit, -- m177_cash_transfer_limit
                        2, -- m177_frequency_id_v01 | Not Available (2 - Per Transactions)
                        i.m279_default, -- m177_is_default
                        i.map01_ntp_id, -- m177_status_id_v01
                        i.created_by, -- m177_created_by_id_u17
                        i.created_date, -- m177_created_date
                        i.created_by, -- m177_status_changed_by_id_u17
                        i.created_date, -- m177_status_changed_date
                        i.modified_by, -- m177_modified_by_id_u17
                        i.modified_date, -- m177_modified_date
                        '1', -- m177_custom_type
                        i.new_institute_id -- m177_institute_id_m02
                                          );

                INSERT
                  INTO m177_csh_trns_lmt_grp_mappings (
                           old_csh_trns_lmt_grp_id,
                           new_csh_trns_lmt_grp_id,
                           new_institute_id)
                VALUES (
                           i.m279_id,
                           l_cash_transfer_limit_group_id,
                           i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m177_cash_transfer_limit_group
                   SET m177_group_name = i.m279_name, -- m177_group_name
                       m177_cash_transfer_limit = i.m279_transfer_limit, -- m177_cash_transfer_limit
                       m177_is_default = i.m279_default, -- m177_is_default
                       m177_status_id_v01 = i.map01_ntp_id, -- m177_status_id_v01
                       m177_status_changed_by_id_u17 = i.created_by, -- m177_status_changed_by_id_u17
                       m177_status_changed_date = i.created_date, -- m177_status_changed_date
                       m177_modified_by_id_u17 = NVL (i.modified_by, 0), -- m177_modified_by_id_u17
                       m177_modified_date = NVL (i.modified_date, SYSDATE) -- m177_modified_date
                 WHERE m177_id = i.new_csh_trns_lmt_grp_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M177_CASH_TRANSFER_LIMIT_GROUP',
                                i.m279_id,
                                CASE
                                    WHEN i.new_csh_trns_lmt_grp_id
                                             IS NULL
                                    THEN
                                        l_cash_transfer_limit_group_id
                                    ELSE
                                        i.new_csh_trns_lmt_grp_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_csh_trns_lmt_grp_id
                                             IS NULL
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
