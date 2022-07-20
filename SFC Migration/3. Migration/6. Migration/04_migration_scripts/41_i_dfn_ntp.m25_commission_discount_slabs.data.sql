DECLARE
    l_comm_disc_slab_id       NUMBER;
    l_default_currency        VARCHAR2 (10);
    l_default_currency_code   VARCHAR2 (10);
    l_sqlerrm                 VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m25_id), 0)
      INTO l_comm_disc_slab_id
      FROM dfn_ntp.m25_commission_discount_slabs;

    SELECT VALUE
      INTO l_default_currency
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY';

    SELECT VALUE
      INTO l_default_currency_code
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY_CODE';

    DELETE FROM error_log
          WHERE mig_table = 'M25_COMMISSION_DISCOUNT_SLABS';

    FOR i
        IN (SELECT m279.m279_id,
                   m24_map.new_comm_disc_grp_id,
                   v09.v09_id,
                   m279.m279_percentage,
                   m279.m279_starting_date,
                   m279.m279_ending_date,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m279.m279_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m279.m279_modified_date AS modified_date,
                   NVL (u17_modified.new_employee_id,
                        NVL (u17_created.new_employee_id, 0))
                       AS status_changed_by_new_id,
                   NVL (m279.m279_modified_date,
                        NVL (m279.m279_created_date, SYSDATE))
                       AS status_changed_date,
                   v09.v09_code,
                   m25_map.new_comm_disc_slabs_id
              FROM mubasher_oms.m279_commision_discount_rate@mubasher_db_link m279,
                   m24_comm_disc_grp_mappings m24_map,
                   dfn_ntp.m24_commission_discount_group m24,
                   dfn_ntp.v09_instrument_types v09,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   m25_comm_disc_slabs_mappings m25_map
             WHERE     m279.m279_discount_group =
                           m24_map.old_comm_disc_grp_id
                   AND m24_map.new_comm_disc_grp_id = m24.m24_id
                   AND m279_instrument_type = v09.v09_code
                   AND m279.m279_created_by = u17_created.old_employee_id(+)
                   AND m279.m279_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m279.m279_id = m25_map.old_comm_disc_slabs_id(+))
    LOOP
        BEGIN
            IF i.new_comm_disc_slabs_id IS NULL
            THEN
                l_comm_disc_slab_id := l_comm_disc_slab_id + 1;

                INSERT
                  INTO dfn_ntp.m25_commission_discount_slabs (
                           m25_id,
                           m25_discount_group_id_m24,
                           m25_channel_id_v29,
                           m25_instrument_type_id_v09,
                           m25_percentage,
                           m25_flat_discount,
                           m25_starting_date,
                           m25_ending_date,
                           m25_is_active,
                           m25_from,
                           m25_to,
                           m25_disc_type,
                           m25_frequency,
                           m25_created_by_id_u17,
                           m25_created_date,
                           m25_modified_by_id_u17,
                           m25_modified_date,
                           m25_status_id_v01,
                           m25_status_changed_by_id_u17,
                           m25_status_changed_date,
                           m25_min_discount,
                           m25_currency_id_m03,
                           m25_currency_code_m03,
                           m25_instrument_type_code_v09,
                           m25_custom_type)
                VALUES (l_comm_disc_slab_id, -- m25_id
                        i.new_comm_disc_grp_id, -- m25_discount_group_id_m24
                        7, -- m25_channel_id_v29 | Not Available
                        i.v09_id, -- m25_instrument_type_id_v09
                        i.m279_percentage, -- m25_percentage
                        0, -- m25_flat_discount | Not Available
                        i.m279_starting_date, -- m25_starting_date
                        i.m279_ending_date, -- m25_ending_date
                        0, -- m25_is_active | Not Available
                        0, -- m25_from | Not Available
                        0, -- m25_to | Not Available
                        0, -- m25_disc_type | Not Available
                        1, -- m25_frequency
                        i.created_by_new_id, -- m25_created_by_id_u17
                        i.created_date, -- m25_created_date
                        i.modifed_by_new_id, -- m25_modified_by_id_u17
                        i.modified_date, -- m25_modified_date
                        2, -- m25_status_id_v01
                        i.status_changed_by_new_id, -- m25_status_changed_by_id_u17
                        i.status_changed_date, -- m25_status_changed_date
                        0, -- m25_min_discount
                        l_default_currency, -- m25_currency_id_m03
                        l_default_currency_code, -- m25_currency_code_m03 | Not Available
                        i.v09_code, -- m25_instrument_type_code_v09
                        '1' -- m25_custom_type
                           );

                INSERT INTO m25_comm_disc_slabs_mappings
                     VALUES (i.m279_id, l_comm_disc_slab_id);
            ELSE
                UPDATE dfn_ntp.m25_commission_discount_slabs
                   SET m25_discount_group_id_m24 = i.new_comm_disc_grp_id, -- m25_discount_group_id_m24
                       m25_instrument_type_id_v09 = i.v09_id, -- m25_instrument_type_id_v09
                       m25_percentage = i.m279_percentage, -- m25_percentage
                       m25_starting_date = i.m279_starting_date, -- m25_starting_date
                       m25_ending_date = i.m279_ending_date, -- m25_ending_date
                       m25_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m25_modified_by_id_u17
                       m25_modified_date = NVL (i.modified_date, SYSDATE), -- m25_modified_date
                       m25_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m25_status_changed_by_id_u17
                       m25_status_changed_date = i.status_changed_date, -- m25_status_changed_date
                       m25_instrument_type_code_v09 = i.v09_code -- m25_instrument_type_code_v09
                 WHERE m25_id = i.new_comm_disc_slabs_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M25_COMMISSION_DISCOUNT_SLABS',
                                i.m279_id,
                                CASE
                                    WHEN i.new_comm_disc_slabs_id IS NULL
                                    THEN
                                        l_comm_disc_slab_id
                                    ELSE
                                        i.new_comm_disc_slabs_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_comm_disc_slabs_id IS NULL
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
