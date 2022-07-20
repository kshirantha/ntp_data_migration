DECLARE
    l_ext_custody_pf_id   NUMBER;
    l_sqlerrm             VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (u13_id), 0)
      INTO l_ext_custody_pf_id
      FROM dfn_ntp.u13_ext_custody_portfolios;

    DELETE FROM error_log
          WHERE mig_table = 'U13_EXT_CUSTODY_PORTFOLIOS';

    FOR i
        IN (  SELECT u07.u07_id,
                     u01_map.new_customer_id,
                     u01.u01_display_name,
                     m105_map.new_other_brokerages_id,
                     u07.u07_id_no,
                     u07.u07_exchange_acc,
                     NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                     NVL (u07.u07_created_date, SYSDATE) AS created_date,
                     u17_modified.new_employee_id AS modifed_by_new_id,
                     u07.u07_modified_date AS modified_date,
                     map01.map01_ntp_id,
                     NVL (u17_status_changed.new_employee_id, 0)
                         AS status_changed_by_new_id,
                     NVL (u07.u07_status_changed_date, SYSDATE)
                         AS status_changed_date,
                     u13_map.new_ext_custody_pf_id
                FROM mubasher_oms.u07_external_broker_accounts@mubasher_db_link u07,
                     map01_approval_status_v01 map01,
                     m105_other_brokerages_mappings m105_map,
                     u01_customer_mappings u01_map,
                     dfn_ntp.u01_customer u01,
                     u17_employee_mappings u17_created,
                     u17_employee_mappings u17_modified,
                     u17_employee_mappings u17_status_changed,
                     u13_ext_custody_pf_mappings u13_map
               WHERE     u07.u07_status_id = map01.map01_oms_id
                     AND u07.u07_exchange_broker =
                             m105_map.old_other_brokerages_id
                     AND u07.u07_customer_id = u01_map.old_customer_id
                     AND u01_map.new_customer_id = u01.u01_id
                     AND u07.u07_created_by = u17_created.old_employee_id(+)
                     AND u07.u07_modified_by = u17_modified.old_employee_id(+)
                     AND u07.u07_status_changed_by =
                             u17_status_changed.old_employee_id(+)
                     AND u07.u07_id = u13_map.old_ext_custody_pf_id(+)
            ORDER BY u07.u07_id)
    LOOP
        BEGIN
            IF i.new_ext_custody_pf_id IS NULL
            THEN
                l_ext_custody_pf_id := l_ext_custody_pf_id + 1;

                INSERT INTO u13_ext_custody_pf_mappings
                     VALUES (i.u07_id, l_ext_custody_pf_id);

                INSERT
                  INTO dfn_ntp.u13_ext_custody_portfolios (
                           u13_id,
                           u13_customer_id_u01,
                           u13_name,
                           u13_exg_broker_id_m105,
                           u13_id_no,
                           u13_exchange_acc,
                           u13_created_by_id_u17,
                           u13_created_date,
                           u13_modified_by_id_u17,
                           u13_modified_date,
                           u13_status_id_v01,
                           u13_status_changed_by_id_u17,
                           u13_status_changed_date,
                           u13_custom_type)
                VALUES (l_ext_custody_pf_id, -- u13_id
                        i.new_customer_id, -- u13_customer_id_u01
                        i.u01_display_name, -- u13_name
                        i.new_other_brokerages_id, -- u13_exg_broker_id_m105
                        i.u07_id_no, -- u13_id_no
                        i.u07_exchange_acc, -- u13_exchange_acc
                        i.created_by_new_id, -- u13_created_by_id_u17
                        i.created_date, -- u13_created_date
                        i.modifed_by_new_id, -- u13_modified_by_id_u17
                        i.modified_date, -- u13_modified_date
                        i.map01_ntp_id, -- u13_status_id_v01
                        i.status_changed_by_new_id, -- u13_status_changed_by_id_u17
                        i.status_changed_date, -- u13_status_changed_date
                        '1' -- u13_custom_type
                           );
            ELSE
                UPDATE dfn_ntp.u13_ext_custody_portfolios
                   SET u13_customer_id_u01 = i.new_customer_id, -- u13_customer_id_u01
                       u13_name = i.u01_display_name, -- u13_name
                       u13_exg_broker_id_m105 = i.new_other_brokerages_id, -- u13_exg_broker_id_m105
                       u13_id_no = i.u07_id_no, -- u13_id_no
                       u13_exchange_acc = i.u07_exchange_acc, -- u13_exchange_acc
                       u13_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- u13_modified_by_id_u17
                       u13_modified_date = NVL (i.modified_date, SYSDATE), -- u13_modified_date
                       u13_status_id_v01 = i.map01_ntp_id, -- u13_status_id_v01
                       u13_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- u13_status_changed_by_id_u17
                       u13_status_changed_date = i.status_changed_date -- u13_status_changed_date
                 WHERE u13_id = i.new_ext_custody_pf_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U13_EXT_CUSTODY_PORTFOLIOS',
                                i.u13_id,
                                CASE
                                    WHEN i.new_ext_custody_pf_id
                                             IS NULL
                                    THEN
                                        l_ext_custody_pf_id
                                    ELSE
                                        i.new_ext_custody_pf_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_ext_custody_pf_id
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
