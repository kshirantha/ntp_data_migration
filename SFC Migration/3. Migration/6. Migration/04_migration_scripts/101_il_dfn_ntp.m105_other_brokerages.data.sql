DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_other_brokerages_id    NUMBER;
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

    SELECT NVL (MAX (m105_id), 0)
      INTO l_other_brokerages_id
      FROM dfn_ntp.m105_other_brokerages;

    DELETE FROM error_log
          WHERE mig_table = 'M105_OTHER_BROKERAGES';

    FOR i
        IN (SELECT m116.m116_id,
                   m116.m116_broker_code,
                   m116.m116_broker_name,
                   m116.m116_address,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m116_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modified_by_new_id,
                   m116_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m116_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m02_map.new_institute_id,
                   m01.m01_id,
                   m105_map.new_other_brokerages_id
              FROM mubasher_oms.m116_exchange_brokers@mubasher_db_link m116,
                   map01_approval_status_v01 map01,
                   map16_optional_exchanges_m01 map16,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   m105_other_brokerages_mappings m105_map
             WHERE     m116.m116_status_id = map01.map01_oms_id
                   AND m116.m116_created_by = u17_created.old_employee_id(+)
                   AND m116.m116_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m116.m116_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m116.m116_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, m116.m116_exchange) =
                           m01.m01_exchange_code(+)
                   AND m116.m116_id = m105_map.old_other_brokerages_id(+)
                   AND m02_map.old_institute_id =
                           m105_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.new_other_brokerages_id IS NULL
            THEN
                l_other_brokerages_id := l_other_brokerages_id + 1;

                INSERT
                  INTO dfn_ntp.m105_other_brokerages (
                           m105_id,
                           m105_broker_code,
                           m105_broker_name,
                           m105_address,
                           m105_created_by_id_u17,
                           m105_created_date,
                           m105_modified_by_id_u17,
                           m105_modified_date,
                           m105_status_id_v01,
                           m105_status_changed_by_id_u17,
                           m105_status_changed_date,
                           m105_exchange_id_m01,
                           m105_custom_type,
                           m105_institute_id_m02)
                VALUES (l_other_brokerages_id, -- m105_id
                        i.m116_broker_code, -- m105_broker_code
                        i.m116_broker_name, -- m105_broker_name
                        i.m116_address, -- m105_address
                        i.created_by_new_id, -- m105_created_by_id_u17
                        i.created_date, -- m105_created_date
                        i.modified_by_new_id, -- m105_modified_by_id_u17
                        i.modified_date, -- m105_modified_date
                        i.map01_ntp_id, -- m105_status_id_v01
                        i.status_changed_by_new_id, -- m105_status_changed_by_id_u17
                        i.status_changed_date, -- m105_status_changed_date
                        i.m01_id, -- m105_exchange_id_m01
                        '1', -- m105_custom_type
                        i.new_institute_id -- m105_institute_id_m02
                                          );

                INSERT INTO m105_other_brokerages_mappings
                     VALUES (
                                i.m116_id,
                                l_other_brokerages_id,
                                i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m105_other_brokerages
                   SET m105_broker_code = i.m116_broker_code, -- m105_broker_code
                       m105_broker_name = i.m116_broker_name, -- m105_broker_name
                       m105_address = i.m116_address, -- m105_address
                       m105_modified_by_id_u17 = NVL (i.modified_by_new_id, 0), -- m105_modified_by_id_u17
                       m105_modified_date = NVL (i.modified_date, SYSDATE), -- m105_modified_date
                       m105_status_id_v01 = i.map01_ntp_id, -- m105_status_id_v01
                       m105_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m105_status_changed_by_id_u17
                       m105_status_changed_date = i.status_changed_date, -- m105_status_changed_date
                       m105_exchange_id_m01 = i.m01_id -- m105_exchange_id_m01
                 WHERE m105_id = i.new_other_brokerages_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M105_OTHER_BROKERAGES',
                                i.m116_id,
                                CASE
                                    WHEN i.new_other_brokerages_id IS NULL
                                    THEN
                                        l_other_brokerages_id
                                    ELSE
                                        i.new_other_brokerages_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_other_brokerages_id IS NULL
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