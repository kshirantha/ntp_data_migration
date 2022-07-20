DECLARE
    l_asset_management_comp_id   NUMBER;
    l_sqlerrm                    VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m178_id), 0)
      INTO l_asset_management_comp_id
      FROM dfn_ntp.m178_asset_management_company;

    DELETE FROM error_log
          WHERE mig_table = 'M178_ASSET_MANAGEMENT_COMPANY';

    FOR i
        IN (SELECT m120.m120_id,
                   m120.m120_company_name,
                   m120.m120_code,
                   m120.m120_address,
                   m120.m120_phone,
                   m120.m120_fax,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m120.m120_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m120.m120_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m120.m120_status_changed_date, SYSDATE)
                       status_changed_date,
                   m05.m05_id,
                   m02_map.new_institute_id,
                   m178_map.new_asset_mngmnt_comp_id
              FROM mubasher_oms.m120_asset_management_companie@mubasher_db_link m120,
                   mubasher_oms.m30_country@mubasher_db_link m30,
                   dfn_ntp.m05_country m05,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   m178_asset_mngmnt_cmp_mappings m178_map
             WHERE     m120.m120_status_id = map01.map01_oms_id
                   AND m120.m120_country = m30.m30_country_id
                   AND m30.m30_country_code = m05.m05_code
                   AND m120.m120_created_by = u17_created.old_employee_id(+)
                   AND m120.m120_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m120.m120_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m120.m120_id =
                           m178_map.old_asset_mngmnt_comp_id(+)
                   AND m02_map.new_institute_id =
                           m178_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_asset_mngmnt_comp_id IS NULL
            THEN
                l_asset_management_comp_id := l_asset_management_comp_id + 1;

                INSERT
                  INTO dfn_ntp.m178_asset_management_company (
                           m178_id,
                           m178_company_name,
                           m178_address,
                           m178_phone,
                           m178_fax,
                           m178_country_id_m05,
                           m178_code,
                           m178_created_by_id_u17,
                           m178_created_date,
                           m178_status_changed_by_id_u17,
                           m178_status_id_v01,
                           m178_status_changed_date,
                           m178_modified_by_id_u17,
                           m178_modified_date,
                           m178_custom_type,
                           m178_institute_id_m02)
                VALUES (l_asset_management_comp_id, -- m178_id
                        i.m120_company_name, -- m178_company_name
                        i.m120_address, -- m178_address
                        i.m120_phone, -- m178_phone
                        i.m120_fax, -- m178_fax
                        i.m05_id, -- m178_country_id_m05
                        i.m120_code, -- m178_code
                        i.created_by_new_id, -- m178_created_by_id_u17
                        i.created_date, -- m178_created_date
                        i.status_changed_by_new_id, -- m178_status_changed_by_id_u17
                        i.map01_ntp_id, -- m178_status_id_v01
                        i.status_changed_date, -- m178_status_changed_date
                        i.modifed_by_new_id, -- m178_modified_by_id_u17
                        i.modified_date, -- m178_modified_date
                        '1', -- m178_custom_type
                        i.new_institute_id -- m178_institute_id_m02
                                          );

                INSERT INTO m178_asset_mngmnt_cmp_mappings
                     VALUES (
                                i.m120_id,
                                l_asset_management_comp_id,
                                i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m178_asset_management_company
                   SET m178_company_name = i.m120_company_name, -- m178_company_name
                       m178_address = i.m120_address, -- m178_address
                       m178_phone = i.m120_phone, -- m178_phone
                       m178_fax = i.m120_fax, -- m178_fax
                       m178_country_id_m05 = i.m05_id, -- m178_country_id_m05
                       m178_code = i.m120_code, -- m178_code
                       m178_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m178_status_changed_by_id_u17
                       m178_status_id_v01 = i.map01_ntp_id, -- m178_status_id_v01
                       m178_status_changed_date = i.status_changed_date, -- m178_status_changed_date
                       m178_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m178_modified_by_id_u17
                       m178_modified_date = NVL (i.modified_date, SYSDATE) -- m178_modified_date
                 WHERE m178_id = i.new_asset_mngmnt_comp_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M09_COMPANIES',
                                i.m120_id,
                                CASE
                                    WHEN i.new_asset_mngmnt_comp_id
                                             IS NULL
                                    THEN
                                        l_asset_management_comp_id
                                    ELSE
                                        i.new_asset_mngmnt_comp_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_asset_mngmnt_comp_id
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
