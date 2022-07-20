DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_u17_id                 NUMBER;
    l_m02_id                 NUMBER;
    l_m12_id                 NUMBER;
    l_m07_id                 NUMBER;
    l_u28_id                 NUMBER;
    l_m45_id                 NUMBER;
    l_m46_id                 NUMBER;
    l_m47_id                 NUMBER;
    l_m51_id                 NUMBER;
    l_count                  NUMBER;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT MAX (u17_id) + 1 INTO l_u17_id FROM dfn_ntp.u17_employee;

    SELECT m02_id
      INTO l_m02_id
      FROM dfn_ntp.m02_institute m02
     WHERE m02_id = l_primary_institute_id;

    SELECT MAX (m12.m12_id)
      INTO l_m12_id
      FROM dfn_ntp.m12_employee_department m12
     WHERE     m12.m12_institute_id_m02 = l_m02_id
           AND UPPER (m12.m12_name) LIKE '%ADMIN%';

    IF l_m12_id IS NULL
    THEN
        SELECT MAX (m12.m12_id)
          INTO l_m12_id
          FROM dfn_ntp.m12_employee_department m12
         WHERE     m12.m12_institute_id_m02 = l_m02_id
               AND UPPER (m12.m12_name) LIKE '%BACK OFFICE%';

        IF l_m12_id IS NULL
        THEN
            SELECT MAX (m12.m12_id)
              INTO l_m12_id
              FROM dfn_ntp.m12_employee_department m12
             WHERE     m12.m12_institute_id_m02 = l_m02_id
                   AND UPPER (m12.m12_name) LIKE '%IT%';

            IF l_m12_id IS NULL
            THEN
                SELECT MAX (m12.m12_id)
                  INTO l_m12_id
                  FROM dfn_ntp.m12_employee_department m12
                 WHERE     m12.m12_institute_id_m02 = l_m02_id
                       AND UPPER (m12.m12_name) LIKE
                               '%INFORMATION TECHNOLOGY%';

                IF l_m12_id IS NULL
                THEN
                    SELECT MAX (m12.m12_id)
                      INTO l_m12_id
                      FROM dfn_ntp.m12_employee_department m12
                     WHERE m12.m12_institute_id_m02 = l_m02_id;
                END IF;
            END IF;
        END IF;
    END IF;

    SELECT MAX (m07.m07_id)
      INTO l_m07_id
      FROM dfn_ntp.m07_location m07
     WHERE     m07.m07_institute_id_m02 = l_m02_id
           AND UPPER (m07.m07_name) LIKE '%HEAD OFFICE%';

    SELECT NVL (MAX (u28_id), 0) + 1
      INTO l_u28_id
      FROM dfn_ntp.u28_employee_exchanges;

    SELECT MAX (m45_id) + 1 INTO l_m45_id FROM dfn_ntp.m45_permission_groups;

    SELECT MAX (m46_id) + 1
      INTO l_m46_id
      FROM dfn_ntp.m46_permission_grp_entlements;

    SELECT MAX (m47_id) + 1
      INTO l_m47_id
      FROM dfn_ntp.m47_permission_grp_users;

    SELECT NVL (MAX (m51_id), 0)
      INTO l_m51_id
      FROM dfn_ntp.m51_employee_trading_groups;

    SELECT COUNT (*)
      INTO l_count
      FROM dfn_ntp.u17_employee
     WHERE u17_login_name = 'DFNADMIN';

    ------------ DFN Admin User ------------

    IF l_count = 0
    THEN
        INSERT INTO dfn_ntp.u17_employee (u17_id,
                                          u17_institution_id_m02,
                                          u17_full_name,
                                          u17_login_name,
                                          u17_password,
                                          u17_failed_attempts,
                                          u17_is_first_time,
                                          u17_created_by_id_u17,
                                          u17_created_date,
                                          u17_status_id_v01,
                                          u17_login_status,
                                          u17_type_id_m11,
                                          u17_price_login_name,
                                          u17_price_password,
                                          u17_pw_expire_date,
                                          u17_last_login_date,
                                          u17_telephone,
                                          u17_telephone_ext,
                                          u17_mobile,
                                          u17_email,
                                          u17_department_id_m12,
                                          u17_employee_no,
                                          u17_modified_by_id_u17,
                                          u17_modified_date,
                                          u17_status_changed_by_u17,
                                          u17_status_changed_date,
                                          u17_history_passwords,
                                          u17_user_category,
                                          u17_client_version,
                                          u17_trading_enabled,
                                          u17_full_name_saudi,
                                          u17_location_id_m07,
                                          u17_custom_type,
                                          u17_authentication_type)
             VALUES (
                        l_u17_id,
                        l_m02_id,
                        'DFN Admin',
                        'DFNADMIN',
                        'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3',
                        0,
                        0,
                        0,
                        SYSDATE,
                        2,
                        1,
                        1,
                        NULL,
                        NULL,
                        SYSDATE + 360,
                        SYSDATE,
                        NULL,
                        NULL,
                        '+94-117-142-700',
                        'info@directfn.com',
                        l_m12_id,
                        NULL,
                        0,
                        SYSDATE,
                        0,
                        SYSDATE,
                        NULL,
                        0,
                        NULL,
                        NULL,
                        NULL,
                        l_m07_id,
                        '1',
                        0);
    ELSE
        SELECT u17_id
          INTO l_u17_id
          FROM dfn_ntp.u17_employee
         WHERE u17_login_name = 'DFNADMIN';
    END IF;

    SELECT COUNT (*)
      INTO l_count
      FROM dfn_ntp.m45_permission_groups
     WHERE m45_group_name = 'Administrator - DirectFN';

    IF l_count = 0
    THEN
        INSERT
          INTO dfn_ntp.m45_permission_groups (m45_id,
                                              m45_group_name,
                                              m45_group_enabled,
                                              m45_created_date,
                                              m45_created_by_id_u17,
                                              m45_institute_id_m02,
                                              m45_modified_by_id_u17,
                                              m45_modified_date,
                                              m45_status_id_v01,
                                              m45_status_changed_by_id_u17,
                                              m45_status_changed_date,
                                              m45_editable,
                                              m45_is_root_inst_only,
                                              m45_custom_type)
        VALUES (l_m45_id,
                'Administrator - DirectFN',
                1,
                SYSDATE,
                0,
                l_m02_id,
                NULL,
                NULL,
                2,
                0,
                SYSDATE,
                1,
                0,
                '1');
    ELSE
        SELECT m45_id
          INTO l_m45_id
          FROM dfn_ntp.m45_permission_groups
         WHERE m45_group_name = 'Administrator - DirectFN';
    END IF;

    SELECT COUNT (*)
      INTO l_count
      FROM dfn_ntp.m47_permission_grp_users
     WHERE m47_user_id_u17 = l_u17_id AND m47_group_id_m45 = l_m45_id;

    IF l_count = 0
    THEN
        INSERT
          INTO dfn_ntp.m47_permission_grp_users (m47_id,
                                                 m47_user_id_u17,
                                                 m47_group_id_m45,
                                                 m47_granted_by_id_u17,
                                                 m47_granted_date,
                                                 m47_l1_by_id_u17,
                                                 m47_l1_date,
                                                 m47_l2_by_id_u17,
                                                 m47_l2_date,
                                                 m47_status_id_v01,
                                                 m47_status_changed_by_id_u17,
                                                 m47_status_changed_date,
                                                 m47_custom_type)
        VALUES (l_m47_id,
                l_u17_id, -- DFNADMIN
                l_m45_id, -- Administrator - DirectFN
                0,
                SYSDATE,
                0,
                SYSDATE,
                0,
                SYSDATE,
                2,
                0,
                SYSDATE,
                '1');
    ELSE
        SELECT m47_id
          INTO l_m47_id
          FROM dfn_ntp.m47_permission_grp_users
         WHERE m47_user_id_u17 = l_u17_id AND m47_group_id_m45 = l_m45_id;
    END IF;

    -- Adding 33, 34 & 35 Entitlements to Admin User Group [If Empty Will Add Otehrwise Decide and Delete Probably During Parallel Run]

    SELECT COUNT (*)
      INTO l_count
      FROM dfn_ntp.m46_permission_grp_entlements
     WHERE m46_group_id_m45 = l_m45_id AND m46_task_id_v04 IN (33, 34, 35);

    IF l_count = 0
    THEN
        FOR entitlement_id IN 33 .. 35
        LOOP
            l_m46_id := l_m46_id + 1;

            INSERT
              INTO dfn_ntp.m46_permission_grp_entlements (
                       m46_id,
                       m46_group_id_m45,
                       m46_task_id_v04,
                       m46_added_by_id_u17,
                       m46_added_date,
                       m46_l1_by_id_u17,
                       m46_l1_date,
                       m46_l2_by_id_u17,
                       m46_l2_date,
                       m46_status_id_v01,
                       m46_status_changed_by_id_u17,
                       m46_status_changed_date,
                       m46_custom_type)
            VALUES (l_m46_id,
                    l_m45_id,
                    entitlement_id,
                    0,
                    SYSDATE,
                    0,
                    SYSDATE,
                    0,
                    SYSDATE,
                    2,
                    0,
                    SYSDATE,
                    '1');
        END LOOP;
    END IF;

    SELECT COUNT (*)
      INTO l_count
      FROM dfn_ntp.m51_employee_trading_groups
     WHERE m51_employee_id_u17 = l_u17_id;

    IF l_count = 0
    THEN
        FOR i IN (SELECT *
                    FROM dfn_ntp.m08_trading_group
                   WHERE m08_institute_id_m02 = l_m02_id)
        LOOP
            l_m51_id := l_m51_id + 1;

            INSERT
              INTO dfn_ntp.m51_employee_trading_groups (
                       m51_id,
                       m51_trading_group_id_m08,
                       m51_employee_id_u17,
                       m51_assigned_date,
                       m51_assigned_by_u17,
                       m51_custom_type)
            VALUES (l_m51_id,
                    i.m08_id,
                    l_u17_id,
                    SYSDATE,
                    0,
                    '1');
        END LOOP;
    END IF;

    ------------ DFN Integration User  ------------

    SELECT COUNT (*)
      INTO l_count
      FROM dfn_ntp.u17_employee
     WHERE u17_login_name = 'INTEGRATION_USER';

    IF l_count = 0
    THEN
        l_u17_id := l_u17_id + 1;

        INSERT INTO dfn_ntp.u17_employee (u17_id,
                                          u17_institution_id_m02,
                                          u17_full_name,
                                          u17_login_name,
                                          u17_password,
                                          u17_failed_attempts,
                                          u17_is_first_time,
                                          u17_created_by_id_u17,
                                          u17_created_date,
                                          u17_status_id_v01,
                                          u17_login_status,
                                          u17_type_id_m11,
                                          u17_price_login_name,
                                          u17_price_password,
                                          u17_pw_expire_date,
                                          u17_last_login_date,
                                          u17_telephone,
                                          u17_telephone_ext,
                                          u17_mobile,
                                          u17_email,
                                          u17_department_id_m12,
                                          u17_employee_no,
                                          u17_modified_by_id_u17,
                                          u17_modified_date,
                                          u17_status_changed_by_u17,
                                          u17_status_changed_date,
                                          u17_history_passwords,
                                          u17_user_category,
                                          u17_client_version,
                                          u17_trading_enabled,
                                          u17_full_name_saudi,
                                          u17_location_id_m07,
                                          u17_custom_type,
                                          u17_authentication_type)
             VALUES (
                        l_u17_id,
                        l_m02_id,
                        'Integration User',
                        'INTEGRATION_USER', -- Hardcoded in Gateway
                        '00e85b2dda7e0b8fefeac9d28c1b1868a8c2bc241d6017824eab2022ff8eec91', -- (Password: intu123) Hardcoded in Gateway
                        0,
                        0,
                        0,
                        SYSDATE,
                        2,
                        1,
                        14, -- System
                        NULL,
                        NULL,
                        SYSDATE + 360,
                        SYSDATE,
                        NULL,
                        NULL,
                        '+94-117-142-700',
                        'info@directfn.com',
                        l_m12_id,
                        NULL,
                        0,
                        SYSDATE,
                        0,
                        SYSDATE,
                        NULL,
                        0,
                        NULL,
                        NULL,
                        NULL,
                        l_m07_id,
                        '1',
                        2 -- Type: 2 - DB
                         );
    ELSE
        SELECT u17_id
          INTO l_u17_id
          FROM dfn_ntp.u17_employee
         WHERE u17_login_name = 'INTEGRATION_USER';

        -- Even if it has changed will be reset to original
        
        UPDATE dfn_ntp.u17_employee
           SET u17_password =
                   '00e85b2dda7e0b8fefeac9d28c1b1868a8c2bc241d6017824eab2022ff8eec91' -- (Password: intu123) Hardcoded in Gateway
         WHERE u17_id = l_u17_id;
    END IF;

    -- New User Group for Integration User

    SELECT COUNT (*)
      INTO l_count
      FROM dfn_ntp.m45_permission_groups
     WHERE m45_group_name = 'Integration - DirectFN';

    IF l_count = 0
    THEN
        l_m45_id := l_m45_id + 1;

        INSERT
          INTO dfn_ntp.m45_permission_groups (m45_id,
                                              m45_group_name,
                                              m45_group_enabled,
                                              m45_created_date,
                                              m45_created_by_id_u17,
                                              m45_institute_id_m02,
                                              m45_modified_by_id_u17,
                                              m45_modified_date,
                                              m45_status_id_v01,
                                              m45_status_changed_by_id_u17,
                                              m45_status_changed_date,
                                              m45_editable,
                                              m45_is_root_inst_only,
                                              m45_custom_type)
        VALUES (l_m45_id,
                'Integration - DirectFN',
                1,
                SYSDATE,
                0,
                l_m02_id,
                NULL,
                NULL,
                2,
                0,
                SYSDATE,
                1,
                0,
                '1');
    ELSE
        SELECT m45_id
          INTO l_m45_id
          FROM dfn_ntp.m45_permission_groups
         WHERE m45_group_name = 'Integration - DirectFN';
    END IF;

    -- Adding Integration User to New Integration User group

    SELECT COUNT (*)
      INTO l_count
      FROM dfn_ntp.m47_permission_grp_users
     WHERE m47_user_id_u17 = l_u17_id AND m47_group_id_m45 = l_m45_id;

    IF l_count = 0
    THEN
        l_m47_id := l_m47_id + 1;

        INSERT
          INTO dfn_ntp.m47_permission_grp_users (m47_id,
                                                 m47_user_id_u17,
                                                 m47_group_id_m45,
                                                 m47_granted_by_id_u17,
                                                 m47_granted_date,
                                                 m47_l1_by_id_u17,
                                                 m47_l1_date,
                                                 m47_l2_by_id_u17,
                                                 m47_l2_date,
                                                 m47_status_id_v01,
                                                 m47_status_changed_by_id_u17,
                                                 m47_status_changed_date,
                                                 m47_custom_type)
        VALUES (l_m47_id,
                l_u17_id, -- INTEGRATION_USER
                l_m45_id, -- Integration - DirectFN
                0,
                SYSDATE,
                0,
                SYSDATE,
                0,
                SYSDATE,
                2,
                0,
                SYSDATE,
                '1');
    ELSE
        SELECT m47_id
          INTO l_m47_id
          FROM dfn_ntp.m47_permission_grp_users
         WHERE m47_user_id_u17 = l_u17_id AND m47_group_id_m45 = l_m45_id;
    END IF;

    -- Adding All Entitlements Except 33,34,35,36 to Integration User Group [If Empty Will Add Otehrwise Decide and Delete Probably During Parallel Run]

    SELECT COUNT (*)
      INTO l_count
      FROM dfn_ntp.m46_permission_grp_entlements
     WHERE     m46_group_id_m45 = l_m45_id
           AND m46_task_id_v04 NOT IN (33, 34, 35, 36);

    IF l_count = 0
    THEN
        FOR i
            IN (SELECT m44.m44_entitlement_id_v04
                  FROM dfn_ntp.m44_institution_entitlements m44,
                       dfn_ntp.m45_permission_groups m45
                 WHERE     m44.m44_institution_id_m02 =
                               m45.m45_institute_id_m02
                       AND m45.m45_id = l_m45_id
                       AND m44.m44_entitlement_id_v04 NOT IN (33, 34, 35, 36))
        LOOP
            l_m46_id := l_m46_id + 1;

            INSERT
              INTO dfn_ntp.m46_permission_grp_entlements (
                       m46_id,
                       m46_group_id_m45,
                       m46_task_id_v04,
                       m46_added_by_id_u17,
                       m46_added_date,
                       m46_l1_by_id_u17,
                       m46_l1_date,
                       m46_l2_by_id_u17,
                       m46_l2_date,
                       m46_status_id_v01,
                       m46_status_changed_by_id_u17,
                       m46_status_changed_date,
                       m46_custom_type)
            VALUES (l_m46_id,
                    l_m45_id,
                    i.m44_entitlement_id_v04,
                    0,
                    SYSDATE,
                    0,
                    SYSDATE,
                    0,
                    SYSDATE,
                    2,
                    0,
                    SYSDATE,
                    '1');
        END LOOP;
    END IF;

    -- Defining Integration User Applicable Exchanges

    SELECT COUNT (*)
      INTO l_count
      FROM dfn_ntp.u28_employee_exchanges
     WHERE u28_employee_id_u17 = l_u17_id;

    IF l_count = 0
    THEN
        INSERT
          INTO dfn_ntp.u28_employee_exchanges (u28_id,
                                               u28_exchange_code_m01,
                                               u28_employee_id_u17,
                                               u28_created_by_id_u17,
                                               u28_created_date,
                                               u28_modified_by_id_u17,
                                               u28_modified_date,
                                               u28_status_id_v01,
                                               u28_status_changed_by_id_u17,
                                               u28_status_changed_date,
                                               u28_dealer_exchange_code,
                                               u28_price_subscribed,
                                               u28_custom_type,
                                               u28_exchange_id_m01,
                                               u28_market_id_m29)
        VALUES (l_u28_id,
                'TDWL',
                l_u17_id,
                0,
                SYSDATE,
                NULL,
                NULL,
                2,
                0,
                SYSDATE,
                NULL,
                0,
                '1',
                1,
                NULL);
    END IF;
END;
/