DECLARE
    l_default_currecny          NUMBER;
    l_default_currecny_code     VARCHAR2 (10);
    l_custody_charges_slab_id   NUMBER;
    l_sqlerrm                   VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_default_currecny
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY';

    SELECT VALUE
      INTO l_default_currecny_code
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY_CODE';

    SELECT NVL (MAX (m167_id), 0)
      INTO l_custody_charges_slab_id
      FROM dfn_ntp.m167_custody_charges_slab;

    DELETE FROM error_log
          WHERE mig_table = 'M167_CUSTODY_CHARGES_SLAB';

    FOR i
        IN (SELECT m337.m337_id,
                   m166_map.new_cstdy_chrgs_grp_id,
                   m337.m337_instrument_type,
                   m337.m337_from,
                   m337.m337_to,
                   m337.m337_percentage,
                   NVL (u17_created.new_employee_id, 0) AS created_by,
                   NVL (m337.m337_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modified_by,
                   m337.m337_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by,
                   NVL (m337.m337_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m167_map.new_cstdy_chrgs_slab_id,
                   m166_map.new_institute_id
              FROM mubasher_oms.m337_custodian_fee_structures@mubasher_db_link m337,
                   m166_cstdy_chrgs_grp_mappings m166_map,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m167_cstdy_chrgs_slab_mappings m167_map
             WHERE     m337.m337_cutodian_group_id =
                           m166_map.old_cstdy_chrgs_grp_id
                   AND m337.m337_status_id = map01.map01_oms_id
                   AND m337.m337_created_by = u17_created.old_employee_id(+)
                   AND m337.m337_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m337.m337_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m337.m337_id = m167_map.old_cstdy_chrgs_slab_id(+)
                   AND m166_map.new_institute_id =
                           m167_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_cstdy_chrgs_slab_id IS NULL
            THEN
                l_custody_charges_slab_id := l_custody_charges_slab_id + 1;

                INSERT
                  INTO dfn_ntp.m167_custody_charges_slab (
                           m167_id,
                           m167_custody_group_id_m166,
                           m167_instrument_type_code_v09,
                           m167_from,
                           m167_to,
                           m167_per_share_charge,
                           m167_fixed_charge,
                           m167_currency_id_m03,
                           m167_currency_code_m03,
                           m167_created_by_id_u17,
                           m167_created_date,
                           m167_modified_by_id_u17,
                           m167_modified_date,
                           m167_status_id_v01,
                           m167_status_changed_by_id_u17,
                           m167_status_changed_date,
                           m167_custom_type)
                VALUES (l_custody_charges_slab_id, -- m167_id
                        i.new_cstdy_chrgs_grp_id, -- m167_custody_group_id_m166
                        i.m337_instrument_type, -- m167_instrument_type_code_v09
                        i.m337_from, -- m167_from
                        i.m337_to, -- m167_to
                        NULL, -- m167_per_share_charge | Not Available
                        NULL, -- m167_fixed_charge | Not Available
                        l_default_currecny, -- m167_currency_id_m03 | Not Available
                        l_default_currecny_code, -- m167_currency_code_m03 | Not Available
                        i.created_by, -- m167_created_by_id_u17
                        i.created_date, -- m167_created_date
                        i.modified_by, -- m167_modified_by_id_u17
                        i.modified_date, -- m167_modified_date
                        i.map01_ntp_id, -- m167_status_id_v01
                        i.status_changed_by, -- m167_status_changed_by_id_u17
                        i.status_changed_date, -- m167_status_changed_date
                        '1' -- m167_custom_type
                           );

                INSERT
                  INTO m167_cstdy_chrgs_slab_mappings (
                           old_cstdy_chrgs_slab_id,
                           new_cstdy_chrgs_slab_id,
                           new_institute_id)
                VALUES (
                           i.m337_id,
                           l_custody_charges_slab_id,
                           i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m167_custody_charges_slab
                   SET m167_custody_group_id_m166 =
                           i.new_cstdy_chrgs_grp_id, -- m167_custody_group_id_m166
                       m167_instrument_type_code_v09 = i.m337_instrument_type, -- m167_instrument_type_code_v09
                       m167_from = i.m337_from, -- m167_from
                       m167_to = i.m337_to, -- m167_to
                       m167_modified_by_id_u17 = NVL (i.modified_by, 0), -- m167_modified_by_id_u17
                       m167_modified_date = NVL (i.modified_date, SYSDATE), -- m167_modified_date
                       m167_status_id_v01 = i.map01_ntp_id, -- m167_status_id_v01
                       m167_status_changed_by_id_u17 = i.status_changed_by, -- m167_status_changed_by_id_u17
                       m167_status_changed_date = i.status_changed_date -- m167_status_changed_date
                 WHERE m167_id = i.new_cstdy_chrgs_slab_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M167_CUSTODY_CHARGES_SLAB',
                                i.m337_id,
                                CASE
                                    WHEN i.new_cstdy_chrgs_slab_id
                                             IS NULL
                                    THEN
                                        l_custody_charges_slab_id
                                    ELSE
                                        i.new_cstdy_chrgs_slab_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cstdy_chrgs_slab_id
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
