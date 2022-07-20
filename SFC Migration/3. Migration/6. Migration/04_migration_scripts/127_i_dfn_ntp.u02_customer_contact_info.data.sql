DECLARE
    l_cust_contact_info_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);

    l_rec_cnt                NUMBER := 0;
BEGIN
    SELECT NVL (MAX (u02_id), 0)
      INTO l_cust_contact_info_id
      FROM dfn_ntp.u02_customer_contact_info;

    DELETE FROM error_log
          WHERE mig_table = 'U02_CUSTOMER_CONTACT_INFO';

    FOR i
        IN (SELECT u01_map.new_customer_id,
                   1 AS is_default,
                   REPLACE (m01.m01_c1_mobile, ' ', '') AS m01_c1_mobile,
                   REPLACE (m01.m01_c1_fax, ' ', '') AS m01_c1_fax,
                   m01.m01_c1_email,
                   m01.m01_c1_pobox,
                   m01.m01_c1_zip,
                   m01.m01_c1_street_address_1,
                   m01.m01_c1_arabic_address,
                   m01.m01_c1_street_address_2,
                   m01.m01_c2_arabic_address,
                   REPLACE (m01.m01_c1_home_tel, ' ', '') AS telephone, -- For  Mailing Address Type It is Home Telepehone
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m01.m01_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modified_by_new_id,
                   m01.m01_modified_date AS modified_date,
                   map07.map07_ntp_id,
                   map06.map06_ntp_id,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m01.m01_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m01.m01_customer_id,
                   1 AS contact_type, -- [ 1 : Mailing Address] - One for Each Customer
                   u02.u02_id
              FROM mubasher_oms.m01_customer@mubasher_db_link m01,
                   u01_customer_mappings u01_map,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   map07_city_m06 map07,
                   map06_country_m05 map06,
                   (SELECT *
                      FROM dfn_ntp.u02_customer_contact_info
                     WHERE u02_contact_description = 1) u02
             WHERE     m01.m01_customer_id = u01_map.old_customer_id
                   AND m01.m01_status_id = map01.map01_oms_id
                   AND m01.m01_created_by = u17_created.old_employee_id(+)
                   AND m01.m01_modified_by = u17_modified.old_employee_id(+)
                   AND m01.m01_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m01.m01_city = map07.map07_oms_id(+)
                   AND m01.m01_country_id = map06.map06_oms_id(+)
                   AND u01_map.new_customer_id = u02.u02_customer_id_u01(+)
            UNION
            SELECT u01_map.new_customer_id,
                   0 AS is_default,
                   REPLACE (m01.m01_c1_mobile, ' ', '') AS m01_c1_mobile,
                   REPLACE (m01.m01_c1_fax, ' ', '') AS m01_c1_fax,
                   m01.m01_c1_email,
                   m01.m01_c1_pobox,
                   m01.m01_c1_zip,
                   m01.m01_c1_street_address_1,
                   m01.m01_c1_arabic_address,
                   m01.m01_c1_street_address_2,
                   m01.m01_c2_arabic_address,
                   REPLACE (m01.m01_c1_office_tel, ' ', '') AS telephone, -- For Office Address Type It is Office Telepehone
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m01.m01_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modified_by_new_id,
                   m01.m01_modified_date AS modified_date,
                   map07.map07_ntp_id,
                   map06.map06_ntp_id,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m01.m01_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m01.m01_customer_id,
                   2 AS contact_type, -- [ 2 : Office Address] - Extra Entry for Office Telephone
                   u02.u02_id
              FROM mubasher_oms.m01_customer@mubasher_db_link m01,
                   u01_customer_mappings u01_map,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   map07_city_m06 map07,
                   map06_country_m05 map06,
                   (SELECT *
                      FROM dfn_ntp.u02_customer_contact_info
                     WHERE u02_contact_description = 2) u02
             WHERE     m01.m01_c1_office_tel IS NOT NULL
                   AND m01.m01_customer_id = u01_map.old_customer_id
                   AND m01.m01_status_id = map01.map01_oms_id
                   AND m01.m01_created_by = u17_created.old_employee_id(+)
                   AND m01.m01_modified_by = u17_modified.old_employee_id(+)
                   AND m01.m01_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m01.m01_city = map07.map07_oms_id(+)
                   AND m01.m01_country_id = map06.map06_oms_id(+)
                   AND u01_map.new_customer_id = u02.u02_customer_id_u01(+))
    LOOP
        BEGIN
            IF i.u02_id IS NULL
            THEN
                l_cust_contact_info_id := l_cust_contact_info_id + 1;

                INSERT
                  INTO dfn_ntp.u02_customer_contact_info (
                           u02_id,
                           u02_customer_id_u01,
                           u02_is_default,
                           u02_mobile,
                           u02_fax,
                           u02_email,
                           u02_po_box,
                           u02_zip_code,
                           u02_address_line1,
                           u02_address_line1_lang,
                           u02_address_line2,
                           u02_address_line2_lang,
                           u02_telephone,
                           u02_contact_description,
                           u02_created_by_id_u17,
                           u02_created_date,
                           u02_modified_by_id_u17,
                           u02_modified_date,
                           u02_city_id_m06,
                           u02_country_id_m05,
                           u02_building_no,
                           u02_unit_no,
                           u02_district,
                           u02_additional_code,
                           u02_status_id_v01,
                           u02_status_changed_by_id_u17,
                           u02_status_changed_date,
                           u02_district_lang,
                           u02_custom_type,
                           u02_cc_email,
                           u02_bcc_email)
                VALUES (l_cust_contact_info_id, -- u02_id
                        i.new_customer_id, -- u02_customer_id_u01
                        i.is_default, -- u02_is_default
                        i.m01_c1_mobile, -- u02_mobile
                        i.m01_c1_fax, -- u02_fax
                        i.m01_c1_email, -- u02_email
                        i.m01_c1_pobox, -- u02_po_box
                        i.m01_c1_zip, -- u02_zip_code
                        i.m01_c1_street_address_1, -- u02_address_line1
                        i.m01_c1_arabic_address, -- u02_address_line1_lang
                        i.m01_c1_street_address_2, -- u02_address_line2
                        i.m01_c2_arabic_address, -- u02_address_line2_lang
                        i.telephone, -- u02_telephone
                        i.contact_type, -- u02_contact_description
                        i.created_by_new_id, -- u02_created_by_id_u17
                        i.created_date, -- u02_created_date
                        i.modified_by_new_id, -- u02_modified_by_id_u17
                        i.modified_date, -- u02_modified_date
                        i.map07_ntp_id, -- u02_city_id_m06
                        i.map06_ntp_id, -- u02_country_id_m05
                        NULL, -- u02_building_no | Not Available
                        NULL, -- u02_unit_no | Not Available
                        NULL, -- u02_district | Not Available
                        NULL, -- u02_additional_code | Not Available
                        i.map01_ntp_id, -- u02_status_id_v01
                        i.status_changed_by_new_id, -- u02_status_changed_by_id_u17
                        i.status_changed_date, -- u02_status_changed_date
                        NULL, -- u02_district_lang | Not Available
                        '1', -- u02_custom_type
                        NULL, -- u02_cc_email
                        NULL -- u02_bcc_email
                            );
            ELSE
                UPDATE dfn_ntp.u02_customer_contact_info
                   SET u02_mobile = i.m01_c1_mobile, -- u02_mobile
                       u02_is_default = i.is_default, -- u02_is_default
                       u02_fax = i.m01_c1_fax, -- u02_fax
                       u02_email = i.m01_c1_email, -- u02_email
                       u02_po_box = i.m01_c1_pobox, -- u02_po_box
                       u02_zip_code = i.m01_c1_zip, -- u02_zip_code
                       u02_address_line1 = i.m01_c1_street_address_1, -- u02_address_line1
                       u02_address_line1_lang = i.m01_c1_arabic_address, -- u02_address_line1_lang
                       u02_address_line2 = i.m01_c1_street_address_2, -- u02_address_line2
                       u02_address_line2_lang = i.m01_c2_arabic_address, -- u02_address_line2_lang
                       u02_telephone = i.telephone, -- u02_telephone
                       u02_contact_description = i.contact_type, -- u02_contact_description
                       u02_modified_by_id_u17 = NVL (i.modified_by_new_id, 0), -- u02_modified_by_id_u17
                       u02_modified_date = NVL (i.modified_date, SYSDATE), -- u02_modified_date
                       u02_city_id_m06 = i.map07_ntp_id, -- u02_city_id_m06
                       u02_country_id_m05 = i.map06_ntp_id, -- u02_country_id_m05
                       u02_status_id_v01 = i.map01_ntp_id, -- u02_status_id_v01
                       u02_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- u02_status_changed_by_id_u17
                       u02_status_changed_date = i.status_changed_date -- u02_status_changed_date
                 WHERE u02_id = i.u02_id;
            END IF;

            l_rec_cnt := l_rec_cnt + 1;

            IF MOD (l_rec_cnt, 25000) = 0
            THEN
                COMMIT;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U02_CUSTOMER_CONTACT_INFO',
                                i.m01_customer_id,
                                CASE
                                    WHEN i.u02_id IS NULL
                                    THEN
                                        l_cust_contact_info_id
                                    ELSE
                                        i.u02_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.u02_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/

BEGIN
    dfn_ntp.sp_stat_gather ('U02_CUSTOMER_CONTACT_INFO');
END;
/