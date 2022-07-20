DECLARE
    l_poa_id    NUMBER;
    l_sqlerrm   VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (u47_id), 0)
      INTO l_poa_id
      FROM dfn_ntp.u47_power_of_attorney;

    DELETE FROM error_log
          WHERE mig_table = 'U47_POWER_OF_ATTORNEY';

    FOR i
        IN (SELECT poa.*, u47_map.new_power_of_attorney_id
              FROM (  SELECT m137.m137_poa,
                             u01_map.new_customer_id,
                             MAX (u01_map.old_customer_id) AS old_customer_id,
                             MAX (m132.m132_power_of_atterny)
                                 AS m132_power_of_atterny,
                             MAX (map07.map07_ntp_id) AS map07_ntp_id,
                             MAX (m132.m132_zip) AS m132_zip,
                             MAX (m132.m132_po_box) AS m132_po_box,
                             MAX (m132.m132_street_address_1)
                                 AS m132_street_address_1,
                             MAX (m132.m132_street_address_2)
                                 AS m132_street_address_2,
                             MAX (m132.m132_nin) AS m132_nin,
                             MAX (m132.m132_nin_expiry_date)
                                 AS m132_nin_expiry_date,
                             MAX (m132.m132_contact_no) AS m132_contact_no,
                             MAX (NVL (u17_created.new_employee_id, 0))
                                 AS created_by_new_id,
                             MAX (NVL (m132.m132_created_date, SYSDATE))
                                 AS created_date,
                             MAX (u17_modified.new_employee_id)
                                 AS modifed_by_new_id,
                             MAX (m137.m137_modified_date) AS modified_date,
                             MAX (map01.map01_ntp_id) AS map01_ntp_id,
                             MAX (NVL (u17_status_changed.new_employee_id, 0))
                                 AS status_changed_by_new_id,
                             MAX (NVL (m137.m137_status_changed_date, SYSDATE))
                                 AS status_changed_date,
                             MAX (u01.u01_institute_id_m02)
                                 AS u01_institute_id_m02
                        FROM mubasher_oms.m137_customer_poa@mubasher_db_link m137,
                             mubasher_oms.m132_power_of_atterny@mubasher_db_link m132,
                             u01_customer_mappings u01_map,
                             (SELECT map07_ntp_id,
                                     UPPER (map07_name) AS map07_name
                                FROM map07_city_m06) map07,
                             dfn_ntp.u01_customer u01,
                             map01_approval_status_v01 map01,
                             u17_employee_mappings u17_created,
                             u17_employee_mappings u17_modified,
                             u17_employee_mappings u17_status_changed
                       WHERE     m137.m137_poa = m132.m132_id
                             AND m137.m137_customer_id =
                                     u01_map.old_customer_id
                             AND u01_map.new_customer_id = u01.u01_id
                             AND m132.m132_status_id = map01.map01_oms_id
                             AND UPPER (m132.m132_city) = map07.map07_name(+)
                             AND m132.m132_created_by =
                                     u17_created.old_employee_id(+)
                             AND m137.m137_modified_by =
                                     u17_modified.old_employee_id(+)
                             AND m137.m137_status_changed_by =
                                     u17_status_changed.old_employee_id(+)
                    GROUP BY m137.m137_poa, u01_map.new_customer_id) poa,
                   u47_power_of_attorney_mappings u47_map
             WHERE     poa.m137_poa = u47_map.old_poa_id(+)
                   AND poa.new_customer_id = u47_map.old_customer_id(+))
    LOOP
        BEGIN
            IF i.new_power_of_attorney_id IS NULL
            THEN
                l_poa_id := l_poa_id + 1;

                INSERT
                  INTO dfn_ntp.u47_power_of_attorney (
                           u47_id,
                           u47_customer_id_u01,
                           u47_poa_customer_id_u01,
                           u47_poa_name,
                           u47_poa_name_lang,
                           u47_zip,
                           u47_po_box,
                           u47_street_address_1,
                           u47_street_address_2,
                           u47_city_id_m06,
                           u47_country_id_m05,
                           u47_nationality_id_m05,
                           u47_id_type_m15,
                           u47_poa_type,
                           u47_id_no,
                           u47_id_expiry_date,
                           u47_contact_no,
                           u47_bank_acc_no,
                           u47_created_by_id_u17,
                           u47_created_date,
                           u47_modified_by_id_u17,
                           u47_modified_date,
                           u47_status_id_v01,
                           u47_status_changed_by_id_u17,
                           u47_status_changed_date,
                           u47_custom_type,
                           u47_institute_id_m02)
                VALUES (l_poa_id, -- u47_id
                        i.new_customer_id, -- u47_customer_id_u01
                        NULL, -- u47_poa_customer_id_u01 | For SFC It is Not Existing Cutsomers
                        i.m132_power_of_atterny, -- u47_poa_name
                        i.m132_power_of_atterny, -- u47_poa_name_lang
                        i.m132_zip, -- u47_zip
                        i.m132_po_box, -- u47_po_box
                        i.m132_street_address_1, -- u47_street_address_1
                        i.m132_street_address_2, -- u47_street_address_2
                        i.map07_ntp_id, -- u47_city_id_m06
                        NULL, -- u47_country_id_m05 | Not Available
                        NULL, -- u47_nationality_id_m05 | Not Available
                        NULL, -- u47_id_type_m15 | Not Available
                        0, -- u47_poa_type | Not Available
                        i.m132_nin, -- u47_id_no
                        i.m132_nin_expiry_date, -- u47_id_expiry_date
                        i.m132_contact_no, -- u47_contact_no
                        NULL, -- u47_bank_acc_no | Not Available
                        i.created_by_new_id, -- u47_created_by_id_u17
                        i.created_date, -- u47_created_date
                        i.modifed_by_new_id, -- u47_modified_by_id_u17
                        i.modified_date, -- u47_modified_date
                        i.map01_ntp_id, -- u47_status_id_v01
                        i.status_changed_by_new_id, -- u47_status_changed_by_id_u17
                        i.status_changed_date, -- u47_status_changed_date
                        '1', -- u47_custom_type
                        i.u01_institute_id_m02 -- u47_institute_id_m02
                                              );

                INSERT INTO u47_power_of_attorney_mappings
                     VALUES (i.m137_poa, i.new_customer_id, l_poa_id);
            ELSE
                UPDATE dfn_ntp.u47_power_of_attorney
                   SET u47_customer_id_u01 = i.new_customer_id, -- u47_customer_id_u01
                       u47_poa_name = i.m132_power_of_atterny, -- u47_poa_name
                       u47_poa_name_lang = i.m132_power_of_atterny, -- u47_poa_name_lang
                       u47_zip = i.m132_zip, -- u47_zip
                       u47_po_box = i.m132_po_box, -- u47_po_box
                       u47_street_address_1 = i.m132_street_address_1, -- u47_street_address_1
                       u47_street_address_2 = i.m132_street_address_2, -- u47_street_address_2
                       u47_city_id_m06 = i.map07_ntp_id, -- u47_city_id_m06
                       u47_id_no = i.m132_nin, -- u47_id_no
                       u47_id_expiry_date = i.m132_nin_expiry_date, -- u47_id_expiry_date
                       u47_contact_no = i.m132_contact_no, -- u47_contact_no
                       u47_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- u47_modified_by_id_u17
                       u47_modified_date = NVL (i.modified_date, SYSDATE), -- u47_modified_date
                       u47_status_id_v01 = i.map01_ntp_id, -- u47_status_id_v01
                       u47_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- u47_status_changed_by_id_u17
                       u47_status_changed_date = i.status_changed_date, -- u47_status_changed_date
                       u47_institute_id_m02 = i.u01_institute_id_m02 -- u47_institute_id_m02
                 WHERE u47_id = i.new_power_of_attorney_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U47_POWER_OF_ATTORNEY',
                                   'POA : '
                                || i.m137_poa
                                || ' - Customer : '
                                || i.old_customer_id,
                                CASE
                                    WHEN i.new_power_of_attorney_id IS NULL
                                    THEN
                                        l_poa_id
                                    ELSE
                                        i.new_power_of_attorney_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_power_of_attorney_id IS NULL
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

COMMIT;

-- Updating Customer POA Avilability

MERGE INTO dfn_ntp.u01_customer u01
     USING (  SELECT u47.u47_customer_id_u01
                FROM dfn_ntp.u47_power_of_attorney u47
               WHERE (   u47.u47_status_id_v01 IN (2, 4) -- Normal Approval
                      OR u47.u47_status_id_v01 BETWEEN 101 AND 110) -- Advance Approval
            GROUP BY u47.u47_customer_id_u01) u47_poa
        ON (u01.u01_id = u47_poa.u47_customer_id_u01)
WHEN MATCHED
THEN
    UPDATE SET u01.u01_poa_available = 1;

COMMIT;