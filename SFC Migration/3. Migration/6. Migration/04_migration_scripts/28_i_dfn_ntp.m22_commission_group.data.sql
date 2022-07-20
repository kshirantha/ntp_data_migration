DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_comm_group_id          NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (m22_id), 0)
      INTO l_comm_group_id
      FROM dfn_ntp.m22_commission_group;

    DELETE FROM error_log
          WHERE mig_table = 'M22_COMMISSION_GROUP';

    FOR i
        IN (SELECT m51.m51_commission_group_id,
                   m51.m51_description,
                   m51.m51_institute_id,
                   m51.m51_additional_details,
                   NVL (map16.map16_ntp_code, m51.m51_exchange_code)
                       AS exchange_code,
                   m51.m51_currency,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m51.m51_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m51.m51_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m51.m51_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m01.m01_id,
                   NVL (map17.map17_ntp_id, 0) AS map17_ntp_id, -- Default (0 - Standard)
                   m22_map.new_comm_grp_id
              FROM mubasher_oms.m51_commission_groups@mubasher_db_link m51,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   map16_optional_exchanges_m01 map16,
                   map01_approval_status_v01 map01,
                   m02_institute_mappings m02_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   map17_customer_category_v01_86 map17,
                   m22_comm_grp_mappings m22_map
             WHERE     m51.m51_status_id = map01.map01_oms_id
                   AND m51.m51_exchange_code = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, m51.m51_exchange_code) =
                           m01.m01_exchange_code(+)
                   AND m02_map.old_institute_id = m51.m51_institute_id
                   AND m51.m51_created_by = u17_created.old_employee_id(+)
                   AND m51.m51_modified_by = u17_modified.old_employee_id(+)
                   AND m51.m51_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m51.m51_commission_type = map17.map17_oms_id(+)
                   AND m51.m51_commission_group_id =
                           m22_map.old_comm_grp_id(+))
    LOOP
        BEGIN
            IF i.new_comm_grp_id IS NULL
            THEN
                l_comm_group_id := l_comm_group_id + 1;

                INSERT
                  INTO dfn_ntp.m22_commission_group (
                           m22_id,
                           m22_description,
                           m22_institute_id_m02,
                           m22_additional_details,
                           m22_exchange_code_m01,
                           m22_currency_m03,
                           m22_type,
                           m22_commission_category,
                           m22_is_default,
                           m22_created_by_id_u17,
                           m22_created_date,
                           m22_modified_by_id_u17,
                           m22_modified_date,
                           m22_status_id_v01,
                           m22_status_changed_by_id_u17,
                           m22_status_changed_date,
                           m22_exchange_id_m01,
                           m22_custom_type,
                           m22_category_v01)
                VALUES (l_comm_group_id, -- m22_id
                        i.m51_description, -- m22_description
                        i.m51_institute_id, -- m22_institute_id_m02
                        i.m51_additional_details, -- m22_additional_details
                        i.exchange_code, -- m22_exchange_code_m01
                        i.m51_currency, -- m22_currency_m03
                        0, -- m22_type | Not Available
                        0, -- m22_commission_category | Not Available
                        0, -- m22_is_default | Not Available
                        i.created_by_new_id, -- m22_created_by_id_u17
                        i.created_date, -- m22_created_date
                        i.modifed_by_new_id, -- m22_modified_by_id_u17
                        i.modified_date, -- m22_modified_date
                        i.map01_ntp_id, -- m22_status_id_v01
                        i.status_changed_by_new_id, -- m22_status_changed_by_id_u17
                        i.status_changed_date, -- m22_status_changed_date
                        i.m01_id, -- m22_exchange_id_m01
                        '1', -- m22_custom_type
                        i.map17_ntp_id -- m22_category_v01
                                      );

                INSERT INTO m22_comm_grp_mappings
                     VALUES (i.m51_commission_group_id, l_comm_group_id);
            ELSE
                UPDATE dfn_ntp.m22_commission_group
                   SET m22_description = i.m51_description, -- m22_description
                       m22_institute_id_m02 = i.m51_institute_id, -- m22_institute_id_m02
                       m22_additional_details = i.m51_additional_details, -- m22_additional_details
                       m22_exchange_code_m01 = i.exchange_code, -- m22_exchange_code_m01
                       m22_currency_m03 = i.m51_currency, -- m22_currency_m03
                       m22_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m22_modified_by_id_u17
                       m22_modified_date = NVL (i.modified_date, SYSDATE), -- m22_modified_date
                       m22_status_id_v01 = i.map01_ntp_id, -- m22_status_id_v01
                       m22_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m22_status_changed_by_id_u17
                       m22_status_changed_date = i.status_changed_date, -- m22_status_changed_date
                       m22_exchange_id_m01 = i.m01_id, -- m22_exchange_id_m01
                       m22_category_v01 = i.map17_ntp_id -- m22_category_v01
                 WHERE m22_id = i.new_comm_grp_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M22_COMMISSION_GROUP',
                                i.m51_commission_group_id,
                                CASE
                                    WHEN i.new_comm_grp_id IS NULL
                                    THEN
                                        l_comm_group_id
                                    ELSE
                                        i.new_comm_grp_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_comm_grp_id IS NULL
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

-- Default Commission Groups for Those Trading Accounts Not Having a Valid Commission Group

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_comm_group_id          NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (m22_id), 0)
      INTO l_comm_group_id
      FROM dfn_ntp.m22_commission_group;

    FOR i
        IN (SELECT u06.u06_exchange,
                   m11.m11_default_currency,
                   m01.m01_id,
                   m22_default.comm_group
              FROM (SELECT DISTINCT u06_exchange
                      FROM mubasher_oms.u06_routing_accounts@mubasher_db_link
                     WHERE (   u06_commision_group_id IS NULL
                            OR u06_commision_group_id NOT IN
                                   (SELECT m51_commission_group_id
                                      FROM mubasher_oms.m51_commission_groups@mubasher_db_link))) u06,
                   (SELECT m11_default_currency, m11_exchangecode
                      FROM mubasher_oms.m11_exchanges@mubasher_db_link) m11,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   m22_default_comm_groups m22_default
             WHERE     u06.u06_exchange = m11.m11_exchangecode
                   AND m11.m11_exchangecode = m01.m01_exchange_code
                   AND m11.m11_exchangecode = m22_default.exchange(+))
    LOOP
        IF i.comm_group IS NULL
        THEN
            l_comm_group_id := l_comm_group_id + 1;

            INSERT
              INTO dfn_ntp.m22_commission_group (m22_id,
                                                 m22_description,
                                                 m22_institute_id_m02,
                                                 m22_additional_details,
                                                 m22_exchange_code_m01,
                                                 m22_currency_m03,
                                                 m22_type,
                                                 m22_commission_category,
                                                 m22_is_default,
                                                 m22_created_by_id_u17,
                                                 m22_created_date,
                                                 m22_modified_by_id_u17,
                                                 m22_modified_date,
                                                 m22_status_id_v01,
                                                 m22_status_changed_by_id_u17,
                                                 m22_status_changed_date,
                                                 m22_exchange_id_m01,
                                                 m22_custom_type,
                                                 m22_category_v01)
            VALUES (l_comm_group_id, -- m22_id
                    'Migration Correction - ' || i.u06_exchange, -- m22_description
                    l_primary_institute_id, -- m22_institute_id_m02 | Capturing Under Default Institution
                    'Migration Correction - ' || i.u06_exchange, -- m22_additional_details
                    i.u06_exchange, -- m22_exchange_code_m01
                    i.m11_default_currency, -- m22_currency_m03
                    0, -- m22_type | Default Value
                    0, -- m22_commission_category | Default Value
                    0, -- m22_is_default | Default Value
                    0, -- m22_created_by_id_u17
                    SYSDATE, -- m22_created_date
                    NULL, -- m22_modified_by_id_u17
                    NULL, -- m22_modified_date
                    2, -- m22_status_id_v01
                    0, -- m22_status_changed_by_id_u17
                    SYSDATE, -- m22_status_changed_date
                    i.m01_id, -- m22_exchange_id_m01
                    '1', -- m22_custom_type
                    0 -- m22_category_v01 | Default (0 - Standard)
                     );

            INSERT INTO m22_default_comm_groups
                 VALUES (i.u06_exchange, l_comm_group_id);
        END IF;
    END LOOP;
END;
/