DECLARE
    l_murabaha_basket_id   NUMBER;
    l_sqlerrm              VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m181_id), 0)
      INTO l_murabaha_basket_id
      FROM dfn_ntp.m181_murabaha_baskets;

    DELETE FROM error_log
          WHERE mig_table = 'M181_MURABAHA_BASKETS';

    FOR i
        IN (SELECT m284.m284_id,
                   m284.m284_basket_code,
                   m284.m284_basket_name,
                   m284.m284_basket_size,
                   m284.m284_upper_limit,
                   m284.m284_lower_limit,
                   m284.m284_in_use,
                   CASE
                       WHEN m285_customize.customize_type = 1 THEN 1
                       ELSE 0
                   END
                       AS customized_type,
                   NVL (u17_created.new_employee_id, 0) AS created_by,
                   NVL (m284.m284_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modified_by,
                   m284.m284_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by,
                   NVL (m284.m284_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m02_map.new_institute_id,
                   m181_map.new_murabaha_basket_id
              FROM mubasher_oms.m284_murabaha_baskets@mubasher_db_link m284,
                   (SELECT DISTINCT
                           (m285_allowed_change) AS customize_type,
                           m285_basket_id
                      FROM mubasher_oms.m285_murabaha_bskt_composition@mubasher_db_link
                     WHERE m285_status_id = 1 AND m285_allowed_change > 0) m285_customize, -- Logic Used in SFC to Get Customized Type
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   dfn_mig.m181_murabaha_baskets_mappings m181_map
             WHERE     m285_customize.m285_basket_id(+) = m284.m284_id
                   AND m284.m284_status_id = map01.map01_oms_id
                   AND m284.m284_created_by = u17_created.old_employee_id(+)
                   AND m284.m284_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m284.m284_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m284.m284_id = m181_map.old_murabaha_basket_id(+)
                   AND m02_map.new_institute_id =
                           m181_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_murabaha_basket_id IS NULL
            THEN
                l_murabaha_basket_id := l_murabaha_basket_id + 1;

                INSERT
                  INTO dfn_ntp.m181_murabaha_baskets (
                           m181_id,
                           m181_basket_code,
                           m181_basket_name,
                           m181_basket_size,
                           m181_upper_limit,
                           m181_lower_limit,
                           m181_in_use,
                           m181_type,
                           m181_created_by_id_u17,
                           m181_created_date,
                           m181_modified_by_id_u17,
                           m181_modified_date,
                           m181_status_id_v01,
                           m181_status_changed_by_id_u17,
                           m181_status_changed_date,
                           m181_custom_type,
                           m181_institute_id_m02)
                VALUES (l_murabaha_basket_id, -- m181_id
                        i.m284_basket_code, -- m181_basket_code
                        i.m284_basket_name, -- m181_basket_name
                        i.m284_basket_size, -- m181_basket_size
                        i.m284_upper_limit, -- m181_upper_limit
                        i.m284_lower_limit, -- m181_lower_limit
                        i.m284_in_use, -- m181_in_use
                        i.customized_type, -- m181_type
                        i.created_by, -- m181_created_by_id_u17
                        i.created_date, -- m181_created_date
                        i.modified_by, -- m181_modified_by_id_u17
                        i.modified_date, -- m181_modified_date
                        i.map01_ntp_id, -- m181_status_id_v01
                        i.status_changed_by, -- m181_status_changed_by_id_u17
                        i.status_changed_date, -- m181_status_changed_date
                        '1', -- m181_custom_type
                        i.new_institute_id -- m181_institute_id_m02
                                          );

                INSERT
                  INTO m181_murabaha_baskets_mappings (old_murabaha_basket_id,
                                                       new_murabaha_basket_id,
                                                       new_institute_id)
                VALUES (i.m284_id, l_murabaha_basket_id, i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m181_murabaha_baskets
                   SET m181_basket_code = i.m284_basket_code, -- m181_basket_code
                       m181_basket_name = i.m284_basket_name, -- m181_basket_name
                       m181_basket_size = i.m284_basket_size, -- m181_basket_size
                       m181_upper_limit = i.m284_upper_limit, -- m181_upper_limit
                       m181_lower_limit = i.m284_lower_limit, -- m181_lower_limit
                       m181_in_use = i.m284_in_use, -- m181_in_use
                       m181_type = i.customized_type, -- m181_type
                       m181_modified_by_id_u17 = NVL (i.modified_by, 0), -- m181_modified_by_id_u17
                       m181_modified_date = NVL (i.modified_date, SYSDATE), -- m181_modified_date
                       m181_status_id_v01 = i.map01_ntp_id, -- m181_status_id_v01
                       m181_status_changed_by_id_u17 = i.status_changed_by, -- m181_status_changed_by_id_u17
                       m181_status_changed_date = i.status_changed_date -- m181_status_changed_date
                 WHERE m181_id = i.new_murabaha_basket_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M181_MURABAHA_BASKETS',
                                i.m284_id,
                                CASE
                                    WHEN i.new_murabaha_basket_id IS NULL
                                    THEN
                                        l_murabaha_basket_id
                                    ELSE
                                        i.new_murabaha_basket_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_murabaha_basket_id IS NULL
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
