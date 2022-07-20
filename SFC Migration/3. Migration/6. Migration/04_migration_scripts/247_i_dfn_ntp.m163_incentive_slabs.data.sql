DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_incentive_slab_id      NUMBER;
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

    SELECT NVL (MAX (m163_id), 0)
      INTO l_incentive_slab_id
      FROM dfn_ntp.m163_incentive_slabs;

    DELETE FROM error_log
          WHERE mig_table = 'M163_INCENTIVE_SLABS';

    FOR i
        IN (  SELECT m81.m81_id,
                     m81.m81_commission_group,
                     map162.new_incentive_group_id,
                     m81.m81_order_value_classifier,
                     m81.m81_from_date,
                     m81.m81_to_date,
                     m81.m81_from_value,
                     m81.m81_to_value,
                     m81.m81_percentage,
                     m81.m81_flat_amount,
                     m81.m81_created_by,
                     m81.m81_created_date,
                     NVL (u17_created_by.new_employee_id, 0) AS created_by,
                     NVL (m81.m81_created_date, SYSDATE) AS created_date,
                     u17_last_updated_by.new_employee_id AS last_updated_by,
                     m81.m81_last_updated_date AS last_updated_date,
                     m81.m81_status_id,
                     map1.map01_ntp_id,
                     m81.m81_status_changed_by,
                     m81.m81_status_changed_date,
                     NVL (u17_status_changed_by.new_employee_id, 0)
                         AS status_changed_by,
                     NVL (m81.m81_status_changed_date, SYSDATE)
                         AS status_changed_date,
                     m81.m81_service,
                     m81.m81_currency,
                     m03.m03_id,
                     NVL (map16.map16_ntp_code, m81.m81_exchange) AS exchange,
                     m01.m01_id,
                     m81.m81_third_party_charge,
                     m163_map.new_incentive_slabs_id
                FROM mubasher_oms.m81_agent_commission_structs@mubasher_db_link m81,
                     map01_approval_status_v01 map1,
                     u17_employee_mappings u17_created_by,
                     u17_employee_mappings u17_last_updated_by,
                     u17_employee_mappings u17_status_changed_by,
                     dfn_ntp.m03_currency m03,
                     (SELECT m01_id, m01_exchange_code
                        FROM dfn_ntp.m01_exchanges
                       WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                     map16_optional_exchanges_m01 map16,
                     m162_incentive_group_mappings map162,
                     m163_incentive_slabs_mappings m163_map
               WHERE     m81.m81_created_by = u17_created_by.old_employee_id(+)
                     AND m81.m81_last_updated_by =
                             u17_last_updated_by.old_employee_id(+)
                     AND m81.m81_status_changed_by =
                             u17_status_changed_by.old_employee_id(+)
                     AND m81.m81_status_id = map1.map01_oms_id
                     AND m81.m81_currency = m03.m03_code
                     AND m81.m81_exchange = map16.map16_oms_code(+)
                     AND NVL (map16.map16_ntp_code, m81.m81_exchange) =
                             m01.m01_exchange_code(+)
                     AND m81.m81_commission_group =
                             map162.old_incentive_group_id
                     AND m81.m81_id = m163_map.old_incentive_slabs_id(+)
            ORDER BY m81.m81_id)
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.new_incentive_slabs_id IS NULL
            THEN
                l_incentive_slab_id := l_incentive_slab_id + 1;

                INSERT
                  INTO dfn_ntp.m163_incentive_slabs (
                           m163_id,
                           m163_incentive_group_id_m162,
                           m163_from,
                           m163_to,
                           m163_percentage,
                           m163_currency_code_m03,
                           m163_currency_id_m03,
                           m163_created_by_id_u17,
                           m163_created_date,
                           m163_modified_by_id_u17,
                           m163_modified_date,
                           m163_status_id_v01,
                           m163_status_changed_by_id_u17,
                           m163_status_changed_date,
                           m163_custom_type,
                           m163_exchange_id_m01,
                           m163_exchange_code_m01)
                VALUES (l_incentive_slab_id, -- m163_id,
                        i.new_incentive_group_id, -- m163_commission_group_id_m162,
                        i.m81_from_value, -- m163_from
                        i.m81_to_value, -- m163_to
                        i.m81_percentage, -- m163_percentage
                        i.m81_currency, -- m163_currency_code_m03
                        i.m03_id, -- m163_currency_id_m03
                        i.created_by, -- m163_created_by_id_u17
                        i.created_date, -- m163_created_date
                        i.last_updated_by, -- m163_modified_by_id_u17
                        i.last_updated_date, -- m163_modified_date
                        i.map01_ntp_id, -- m163_status_id_v01
                        i.status_changed_by, -- m163_status_changed_by_id_u17
                        i.status_changed_date, -- m163_status_changed_date
                        '1', -- m163_custom_type,
                        i.m01_id, -- m163_exchange_id_m01
                        i.exchange -- m163_exchange_code_m01
                                  );

                INSERT
                  INTO m163_incentive_slabs_mappings (old_incentive_slabs_id,
                                                      new_incentive_slabs_id)
                VALUES (i.m81_id, l_incentive_slab_id);

                UPDATE dfn_ntp.m163_incentive_slabs
                   SET m163_incentive_group_id_m162 = i.new_incentive_group_id, -- m163_commission_group_id_m162,
                       m163_from = i.m81_from_value, -- m163_from
                       m163_to = i.m81_to_value, -- m163_to
                       m163_percentage = i.m81_percentage, -- m163_percentage
                       m163_currency_code_m03 = i.m81_currency, -- m163_currency_code_m03
                       m163_currency_id_m03 = i.m03_id, -- m163_currency_id_m03
                       m163_modified_by_id_u17 = NVL (i.last_updated_by, 0), -- m163_modified_by_id_u17
                       m163_modified_date = NVL (i.last_updated_date, SYSDATE), -- m163_modified_date
                       m163_status_id_v01 = i.map01_ntp_id, -- m163_status_id_v01
                       m163_status_changed_by_id_u17 = i.status_changed_by, -- m163_status_changed_by_id_u17
                       m163_status_changed_date = i.status_changed_date, -- m163_status_changed_date
                       m163_exchange_id_m01 = i.m01_id, -- m163_exchange_id_m01
                       m163_exchange_code_m01 = i.exchange -- m163_exchange_code_m01
                 WHERE m163_id = i.new_incentive_slabs_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M163_INCENTIVE_SLABS',
                                i.m81_id,
                                CASE
                                    WHEN i.new_incentive_slabs_id IS NULL
                                    THEN
                                        l_incentive_slab_id
                                    ELSE
                                        i.new_incentive_slabs_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_incentive_slabs_id IS NULL
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