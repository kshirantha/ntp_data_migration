DECLARE
    l_subs_waiveoff_grp_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m154_id), 0)
      INTO l_subs_waiveoff_grp_id
      FROM dfn_ntp.m154_subscription_waiveoff_grp;

    DELETE FROM error_log
          WHERE mig_table = 'M154_SUBSCRIPTION_WAIVEOFF_GRP';

    FOR i
        IN (SELECT DISTINCT
                   m237.m237_customer_id,
                   m237.m237_prd_id,
                   u01.u01_institute_id_m02,
                   NVL (u17_created.new_employee_id, 0) AS created_by,
                   NVL (m237.m237_from_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modified_by,
                   m237.m237_modified_date AS modified_date,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m237.m237_status_changed_date, SYSDATE)
                       status_changed_date,
                   m154_map.new_waiveoff_grp_id
              FROM mubasher_oms.m237_cust_subscription_waveoff@mubasher_db_link m237,
                   u01_customer_mappings u01_map,
                   dfn_ntp.u01_customer u01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m154_sub_waiveoff_grp_mappings m154_map
             WHERE     m237.m237_customer_id = u01_map.old_customer_id
                   AND u01_map.new_customer_id = u01.u01_id
                   AND m237.m237_created_user_id =
                           u17_created.old_employee_id(+)
                   AND m237.m237_modified_user_id =
                           u17_modified.old_employee_id(+)
                   AND m237.m237_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m237.m237_customer_id = m154_map.old_customer_id(+)
                   AND m237.m237_prd_id = m154_map.old_product_id(+))
    LOOP
        BEGIN
            IF i.new_waiveoff_grp_id IS NULL
            THEN
                l_subs_waiveoff_grp_id := l_subs_waiveoff_grp_id + 1;

                INSERT
                  INTO dfn_ntp.m154_subscription_waiveoff_grp (
                           m154_id,
                           m154_name,
                           m154_name_lang,
                           m154_institution_id_m02,
                           m154_created_by_id_u17,
                           m154_created_date,
                           m154_status_id_v01,
                           m154_modified_by_id_u17,
                           m154_modified_date,
                           m154_status_changed_by_id_u17,
                           m154_status_changed_date,
                           m154_custom_type)
                VALUES (l_subs_waiveoff_grp_id, -- m154_id
                        'Subs. Waiveoff Group - ' || l_subs_waiveoff_grp_id, -- m154_name
                        'Subs. Waiveoff Group ' || l_subs_waiveoff_grp_id, -- m154_name_lang
                        i.u01_institute_id_m02, -- m154_institution_id_m02
                        i.created_by, -- m154_created_by_id_u17
                        i.created_date, -- m154_created_date
                        2, -- m154_status_id_v01
                        i.modified_by, -- m154_modified_by_id_u17
                        i.modified_date, -- m154_modified_date
                        i.status_changed_by_new_id, -- m154_status_changed_by_id_u17
                        i.status_changed_date, -- m154_status_changed_date
                        '1' -- m154_custom_type
                           );

                INSERT
                  INTO m154_sub_waiveoff_grp_mappings (old_customer_id,
                                                       old_product_id,
                                                       new_waiveoff_grp_id)
                VALUES (
                           i.m237_customer_id,
                           i.m237_prd_id,
                           l_subs_waiveoff_grp_id);
            ELSE
                UPDATE dfn_ntp.m154_subscription_waiveoff_grp
                   SET m154_institution_id_m02 = i.u01_institute_id_m02, -- m154_institution_id_m02
                       m154_status_id_v01 = 2, -- m154_status_id_v01
                       m154_modified_by_id_u17 = NVL (i.modified_by, 0), -- m154_modified_by_id_u17
                       m154_modified_date = NVL (i.modified_date, SYSDATE), -- m154_modified_date
                       m154_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m154_status_changed_by_id_u17
                       m154_status_changed_date = i.status_changed_date -- m154_status_changed_date
                 WHERE m154_id = i.new_waiveoff_grp_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M154_SUBSCRIPTION_WAIVEOFF_GRP',
                                   'Customer : '
                                || i.m237_customer_id
                                || ' - Product : '
                                || i.m237_prd_id,
                                CASE
                                    WHEN i.new_waiveoff_grp_id IS NULL
                                    THEN
                                        l_subs_waiveoff_grp_id
                                    ELSE
                                        i.new_waiveoff_grp_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_waiveoff_grp_id IS NULL
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
