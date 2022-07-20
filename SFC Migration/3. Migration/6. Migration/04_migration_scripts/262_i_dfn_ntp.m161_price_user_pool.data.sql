DECLARE
    l_price_user_id   NUMBER;
    l_sqlerrm         VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m161_id), 0)
      INTO l_price_user_id
      FROM dfn_ntp.m161_price_user_pool;

    DELETE FROM error_log
          WHERE mig_table = 'M161_PRICE_USER_POOL';

    FOR i
        IN (  SELECT m147.m147_id,
                     m147.m147_price_user,
                     m147.m147_price_password,
                     m147.m147_type, -- [SAME IDs]
                     m147.m147_status,
                     map01.map01_ntp_id,
                     m147.m147_expiry_date,
                     NVL (m147.m147_expiry_date, SYSDATE) AS expiry_date,
                     m147.m147_created_date,
                     NVL (m147.m147_created_date, SYSDATE) AS created_date,
                     m147.m147_customer_id,
                     u01_map.new_customer_id,
                     NVL (m147.m147_assigned_date, SYSDATE) AS assigned_date,
                     NVL (u17_assigned_by.new_employee_id, 0) AS assigned_by,
                     m147.m147_created_by,
                     NVL (u17_created_by.new_employee_id, 0) AS created_by,
                     u09.u09_id,
                     m02.m02_primary_institute_id_m02,
                     m161_map.new_price_user_pool_id
                FROM mubasher_oms.m147_price_user_pool@mubasher_db_link m147,
                     dfn_ntp.u01_customer u01,
                     dfn_ntp.m02_institute m02,
                     map01_approval_status_v01 map01,
                     u01_customer_mappings u01_map,
                     dfn_ntp.u09_customer_login u09,
                     u17_employee_mappings u17_created_by,
                     u17_employee_mappings u17_assigned_by,
                     m161_price_user_pool_mappings m161_map
               WHERE     m147.m147_status = map01.map01_oms_id
                     AND m147_customer_id = u01_map.old_customer_id
                     AND u01_map.new_customer_id = u01.u01_id
                     AND u01.u01_id = u09.u09_customer_id_u01(+)
                     AND u01.u01_institute_id_m02 = m02.m02_id
                     AND m147_created_by = u17_created_by.old_employee_id(+)
                     AND m147.m147_assigned_by =
                             u17_assigned_by.old_employee_id(+)
                     AND m147.m147_id = m161_map.old_price_user_pool_id(+)
            ORDER BY m147.m147_id)
    LOOP
        BEGIN
            IF i.new_price_user_pool_id IS NULL
            THEN
                l_price_user_id := l_price_user_id + 1;

                INSERT
                  INTO dfn_ntp.m161_price_user_pool (
                           m161_id,
                           m161_price_user,
                           m161_price_password,
                           m161_type,
                           m161_status,
                           m161_expiry_date,
                           m161_created_date,
                           m161_customer_id_u01,
                           m161_assigned_date,
                           m161_assigned_by_id_u17,
                           m161_created_by_id_u17,
                           m161_primary_institute_id_m02,
                           m161_custom_type,
                           m161_login_id_u09)
                VALUES (l_price_user_id, -- m161_id
                        i.m147_price_user, -- m161_price_user
                        i.m147_price_password, -- m161_price_password
                        i.m147_type, -- m161_type
                        i.map01_ntp_id, -- m161_status
                        i.expiry_date, -- m161_expiry_date
                        i.created_date, -- m161_created_date
                        i.new_customer_id, -- m161_customer_id_u01
                        i.assigned_date, -- m161_assigned_date
                        i.assigned_by, -- m161_assigned_by_id_u17
                        i.created_by, -- m161_created_by_id_u17
                        i.m02_primary_institute_id_m02, -- m161_primary_institute_id_m02
                        '1', -- m161_custom_type
                        i.u09_id -- m161_login_id_u09
                                );

                INSERT
                  INTO m161_price_user_pool_mappings (old_price_user_pool_id,
                                                      new_price_user_pool_id)
                VALUES (i.m147_id, l_price_user_id);
            ELSE
                UPDATE dfn_ntp.m161_price_user_pool
                   SET m161_price_user = i.m147_price_user, -- m161_price_user
                       m161_price_password = i.m147_price_password, -- m161_price_password
                       m161_type = i.m147_type, -- m161_type
                       m161_status = i.map01_ntp_id, -- m161_status
                       m161_expiry_date = i.expiry_date, -- m161_expiry_date
                       m161_customer_id_u01 = i.new_customer_id, -- m161_customer_id_u01
                       m161_assigned_date = i.assigned_date, -- m161_assigned_date
                       m161_assigned_by_id_u17 = i.assigned_by, -- m161_assigned_by_id_u17
                       m161_primary_institute_id_m02 =
                           i.m02_primary_institute_id_m02, -- m161_primary_institute_id_m02
                       m161_login_id_u09 = i.u09_id -- m161_login_id_u09
                 WHERE m161_id = i.new_price_user_pool_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M161_PRICE_USER_POOL',
                                i.m147_id,
                                CASE
                                    WHEN i.new_price_user_pool_id IS NULL
                                    THEN
                                        l_price_user_id
                                    ELSE
                                        i.new_price_user_pool_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_price_user_pool_id IS NULL
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
