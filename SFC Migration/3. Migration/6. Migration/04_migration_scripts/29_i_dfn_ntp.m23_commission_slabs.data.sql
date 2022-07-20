DECLARE
    l_comm_slab_id   NUMBER;
    l_sqlerrm        VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m23_id), 0)
      INTO l_comm_slab_id
      FROM dfn_ntp.m23_commission_slabs;

    DELETE FROM error_log
          WHERE mig_table = 'M23_COMMISSION_SLABS';

    FOR i
        IN (SELECT m52.m52_id,
                   m22_map.new_comm_grp_id,
                   m52.m52_from,
                   m52.m52_to,
                   m52.m52_percentage,
                   m52.m52_flat_amount,
                   m52.m52_comm_type,
                   m52.m52_min_comm,
                   NVL (m03.m03_code, m22.m22_currency_m03) AS currency_code,
                   NVL (m03.m03_id, m03_default.m03_id) AS currency_id,
                   m52.m52_instrument_type,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m52.m52_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m52.m52_modified_date AS modified_date,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m52.m52_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   v09.v09_id,
                   m52.m52_vat,
                   NVL (m124.m124_id, 7) AS m124_id, -- [Corrective Actions Discussed]
                   m23_map.new_comm_slab_id
              FROM mubasher_oms.m52_commission_structures@mubasher_db_link m52,
                   m22_comm_grp_mappings m22_map,
                   dfn_ntp.m22_commission_group m22,
                   m02_institute_mappings m02_map,
                   dfn_ntp.m03_currency m03,
                   dfn_ntp.m03_currency m03_default,
                   dfn_ntp.v09_instrument_types v09,
                   dfn_ntp.m124_commission_types m124,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m23_comm_slabs_mappings m23_map
             WHERE     m52.m52_commission_group_id = m22_map.old_comm_grp_id
                   AND m22_map.new_comm_grp_id = m22.m22_id
                   AND m22.m22_institute_id_m02 = m02_map.new_institute_id
                   AND m52.m52_instrument_type = v09.v09_code
                   AND m52.m52_currency = m03.m03_code(+)
                   AND m22.m22_currency_m03 = m03_default.m03_code(+)
                   AND m52.m52_vat_charge_type = m124.m124_value(+)
                   AND m52.m52_created_by = u17_created.old_employee_id(+)
                   AND m52.m52_modified_by = u17_modified.old_employee_id(+)
                   AND m52.m52_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m52.m52_id = m23_map.old_comm_slab_id(+))
    LOOP
        BEGIN
            IF i.m124_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Invalid VAT Charge Type',
                                         TRUE);
            END IF;

            IF i.new_comm_slab_id IS NULL
            THEN
                l_comm_slab_id := l_comm_slab_id + 1;

                INSERT
                  INTO dfn_ntp.m23_commission_slabs (
                           m23_id,
                           m23_commission_group_id_m22,
                           m23_from,
                           m23_to,
                           m23_percentage,
                           m23_flat_commission,
                           m23_commission_type,
                           m23_min_commission,
                           m23_currency_code_m03,
                           m23_currency_id_m03,
                           m23_instrument_type_v09,
                           m23_exchange_txn_fee,
                           m23_created_by_id_u17,
                           m23_created_date,
                           m23_modified_by_id_u17,
                           m23_modified_date,
                           m23_status_id_v01,
                           m23_status_changed_by_id_u17,
                           m23_status_changed_date,
                           m23_instrument_type_id_v09,
                           m23_vat_percentage,
                           m23_vat_charge_type_m124,
                           m23_custom_type)
                VALUES (l_comm_slab_id, -- m23_id
                        i.new_comm_grp_id, -- m23_commission_group_id_m22
                        i.m52_from, -- m23_from
                        i.m52_to, -- m23_to
                        i.m52_percentage, -- m23_percentage
                        i.m52_flat_amount, -- m23_flat_commission
                        i.m52_comm_type, -- m23_commission_type
                        i.m52_min_comm, -- m23_min_commission
                        i.currency_code, -- m23_currency_code_m03
                        i.currency_id, -- m23_currency_id_m03
                        i.m52_instrument_type, -- m23_instrument_type_v09
                        0, -- m23_exchange_txn_fee | Not Available
                        i.created_by_new_id, -- m23_created_by_id_u17
                        i.created_date, -- m23_created_date
                        i.modifed_by_new_id, -- m23_modified_by_id_u17
                        i.modified_date, -- m23_modified_date,
                        2, -- m23_status_id_v01 | [Discussed to Set as Approved as All are Pending and Status is Hidden in Ols System]
                        i.status_changed_by_new_id, -- m23_status_changed_by_id_u17
                        i.status_changed_date, -- m23_status_changed_date
                        i.v09_id, -- m23_instrument_type_id_v09
                        i.m52_vat, -- m23_vat_percentage
                        i.m124_id, -- m23_vat_charge_type_m124
                        '1' -- m22_custom_type
                           );

                INSERT INTO m23_comm_slabs_mappings
                     VALUES (i.m52_id, l_comm_slab_id);
            ELSE
                UPDATE dfn_ntp.m23_commission_slabs
                   SET m23_commission_group_id_m22 = i.new_comm_grp_id, -- m23_commission_group_id_m22
                       m23_from = i.m52_from, -- m23_from
                       m23_to = i.m52_to, -- m23_to
                       m23_percentage = i.m52_percentage, -- m23_percentage
                       m23_flat_commission = i.m52_flat_amount, -- m23_flat_commission
                       m23_commission_type = i.m52_comm_type, -- m23_commission_type
                       m23_min_commission = i.m52_min_comm, -- m23_min_commission
                       m23_currency_code_m03 = i.currency_code, -- m23_currency_code_m03
                       m23_currency_id_m03 = i.currency_id, -- m23_currency_id_m03
                       m23_instrument_type_v09 = i.m52_instrument_type, -- m23_instrument_type_v09
                       m23_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m23_modified_by_id_u17
                       m23_modified_date = NVL (i.modified_date, SYSDATE), -- m23_modified_date
                       m23_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m23_status_changed_by_id_u17
                       m23_status_changed_date = i.status_changed_date, -- m23_status_changed_date
                       m23_instrument_type_id_v09 = i.v09_id, -- m23_instrument_type_id_v09
                       m23_vat_percentage = i.m52_vat, -- m23_vat_percentage
                       m23_vat_charge_type_m124 = i.m124_id -- m23_vat_charge_type_m124
                 WHERE m23_id = i.new_comm_slab_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M23_COMMISSION_SLABS',
                                i.m52_id,
                                CASE
                                    WHEN i.new_comm_slab_id IS NULL
                                    THEN
                                        l_comm_slab_id
                                    ELSE
                                        i.new_comm_slab_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_comm_slab_id IS NULL
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
