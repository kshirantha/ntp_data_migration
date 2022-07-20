DECLARE
    l_corp_cust_contact_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (u48_id), 0)
      INTO l_corp_cust_contact_id
      FROM dfn_ntp.u48_corp_customer_contact;

    DELETE FROM error_log
          WHERE mig_table = 'U48_CORP_CUSTOMER_CONTACT';

    FOR i
        IN (SELECT u01_map.new_customer_id,
                   m160.m160_mobile,
                   m160.m160_fax,
                   m160.m160_email,
                   m160.m160_tel,
                   m160.m160_title,
                   m160.m160_name,
                   m160.m160_position,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m160.m160_created_date, SYSDATE) AS created_date,
                   map01.map01_ntp_id,
                   u17_modified.new_employee_id AS modified_by_new_id,
                   m160.m160_modified_date AS modified_date,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m160.m160_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m160.m160_id,
                   u48_map.new_corp_cust_contact_id
              FROM mubasher_oms.m160_customer_contacts@mubasher_db_link m160,
                   u01_customer_mappings u01_map,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   u48_corp_cust_contact_mappings u48_map
             WHERE     m160.m160_customer_id = u01_map.old_customer_id
                   AND m160.m160_status_id = map01.map01_oms_id
                   AND m160.m160_created_by = u17_created.old_employee_id(+)
                   AND m160.m160_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m160.m160_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m160.m160_id = u48_map.old_corp_cust_contact_id(+))
    LOOP
        BEGIN
            IF i.new_corp_cust_contact_id IS NULL
            THEN
                l_corp_cust_contact_id := l_corp_cust_contact_id + 1;

                INSERT
                  INTO dfn_ntp.u48_corp_customer_contact (
                           u48_id,
                           u48_customer_id_u01,
                           u48_is_default,
                           u48_mobile,
                           u48_fax,
                           u48_email,
                           u48_telephone,
                           u48_title_id_v01,
                           u48_name,
                           u48_position,
                           u48_date_of_birth,
                           u48_created_by_id_u17,
                           u48_created_date,
                           u48_status_id_v01,
                           u48_modified_by_id_u17,
                           u48_modified_date,
                           u48_status_changed_by_id_u17,
                           u48_status_changed_date,
                           u48_custom_type)
                VALUES (l_corp_cust_contact_id, -- u02_id
                        i.new_customer_id, -- u48_customer_id_u01
                        1, -- u48_is_default
                        i.m160_mobile, -- u48_mobile
                        i.m160_fax, -- u48_fax
                        i.m160_email, -- u48_email
                        i.m160_tel, -- u48_telephone
                        i.m160_title, -- u48_title_id_v01
                        i.m160_name, -- u48_name
                        i.m160_position, -- u48_position
                        NULL, -- u48_date_of_birth
                        i.created_by_new_id, -- u48_created_by_id_u17
                        i.created_date, -- u48_created_date
                        i.map01_ntp_id, -- u48_status_id_v01
                        i.modified_by_new_id, -- u48_modified_by_id_u17
                        i.modified_date, -- u48_modified_date
                        i.status_changed_by_new_id, -- u48_status_changed_by_id_u17
                        i.status_changed_date, -- u48_status_changed_date
                        '1' -- u48_custom_type
                           );

                INSERT INTO u48_corp_cust_contact_mappings
                     VALUES (i.m160_id, l_corp_cust_contact_id);
            ELSE
                UPDATE dfn_ntp.u48_corp_customer_contact
                   SET u48_customer_id_u01 = i.new_customer_id, -- u48_customer_id_u01
                       u48_mobile = i.m160_mobile, -- u48_mobile
                       u48_fax = i.m160_fax, -- u48_fax
                       u48_email = i.m160_email, -- u48_email
                       u48_telephone = i.m160_tel, -- u48_telephone
                       u48_title_id_v01 = i.m160_title, -- u48_title_id_v01
                       u48_name = i.m160_name, -- u48_name
                       u48_position = i.m160_position, -- u48_position
                       u48_status_id_v01 = i.map01_ntp_id, -- u48_status_id_v01
                       u48_modified_by_id_u17 = NVL (i.modified_by_new_id, 0), -- u48_modified_by_id_u17
                       u48_modified_date = NVL (i.modified_date, SYSDATE), -- u48_modified_date
                       u48_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- u48_status_changed_by_id_u17
                       u48_status_changed_date = i.status_changed_date -- u48_status_changed_date
                 WHERE u48_id = i.new_corp_cust_contact_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U48_CORP_CUSTOMER_CONTACT',
                                i.m160_id,
                                CASE
                                    WHEN i.new_corp_cust_contact_id
                                             IS NULL
                                    THEN
                                        l_corp_cust_contact_id
                                    ELSE
                                        i.new_corp_cust_contact_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_corp_cust_contact_id
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
