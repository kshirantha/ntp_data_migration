DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_symbol_margin_id       NUMBER;
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

    SELECT NVL (MAX (m78_id), 0)
      INTO l_symbol_margin_id
      FROM dfn_ntp.m78_symbol_marginability;

    DELETE FROM error_log
          WHERE mig_table = 'M78_SYMBOL_MARGINABILITY';

    FOR i
        IN (SELECT m90.m90_id,
                   m20_map.new_symbol_id,
                   m20.m20_symbol_code,
                   m02_map.new_institute_id,
                   m90.m90_mariginability,
                   m90.m90_marginable_per,
                   m77_map.new_symbol_margin_grp_id,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed_by.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m90_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   NVL (u17_created_by.new_employee_id, 0)
                       AS created_by_new_id,
                   NVL (m90_created_date, SYSDATE) AS created_date,
                   u17_last_updated_by.new_employee_id
                       AS last_updated_by_new_id,
                   m90_last_updated_date AS last_updated_date,
                   m20.m20_exchange_id_m01,
                   m20.m20_exchange_code_m01,
                   m78_map.new_sym_marginability_id
              FROM mubasher_oms.m90_symbol_marginability@mubasher_db_link m90,
                   map01_approval_status_v01 map01,
                   m20_symbol_mappings m20_map,
                   (SELECT m20_id,
                           m20_symbol_code,
                           m20_exchange_id_m01,
                           m20_exchange_code_m01
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20,
                   m02_institute_mappings m02_map,
                   m77_symbol_margin_grp_mappings m77_map,
                   u17_employee_mappings u17_created_by,
                   u17_employee_mappings u17_last_updated_by,
                   u17_employee_mappings u17_status_changed_by,
                   m78_sym_marginability_mappings m78_map
             WHERE     m90.m90_status_id = map01.map01_oms_id
                   AND m90.m90_symbol_id = m20_map.old_symbol_id(+)
                   AND m20_map.new_symbol_id = m20.m20_id(+)
                   AND m90.m90_institution = m02_map.old_institute_id
                   AND m90.m90_sym_margin_group =
                           m77_map.old_symbol_margin_grp_id -- [Discussed Point with Janaka to Use Inner Join]
                   AND m90.m90_created_by = u17_created_by.old_employee_id(+)
                   AND m90.m90_last_updated_by =
                           u17_last_updated_by.old_employee_id(+)
                   AND m90.m90_status_chanegd_by =
                           u17_status_changed_by.old_employee_id(+)
                   AND m90.m90_id = m78_map.old_sym_marginability_id(+))
    LOOP
        BEGIN
            IF i.new_symbol_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Symbol Not Available',
                                         TRUE);
            END IF;

            -- [Discussion Point by Janaka]
            /*IF i.new_symbol_margin_grp_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Symbol Margin Group Not Available',
                                         TRUE);
            END IF;*/

            IF i.new_sym_marginability_id IS NULL
            THEN
                l_symbol_margin_id := l_symbol_margin_id + 1;

                INSERT
                  INTO dfn_ntp.m78_symbol_marginability (
                           m78_id,
                           m78_symbol_id_m20,
                           m78_symbol_code_m20,
                           m78_institution_id_m02,
                           m78_mariginability,
                           m78_marginable_per,
                           m78_sym_margin_group_m77,
                           m78_status_id_v01,
                           m78_status_changed_date,
                           m78_status_changed_by_id_u17,
                           m78_created_date,
                           m78_created_by_id_u17,
                           m78_last_updated_date,
                           m78_last_updated_by_id_u17,
                           m78_exchange_id_m01,
                           m78_exchange_code_m01,
                           m78_custom_type)
                VALUES (l_symbol_margin_id, -- m78_id
                        i.new_symbol_id, -- m78_symbol_id_m20
                        i.m20_symbol_code, -- m78_symbol_code_m20
                        i.new_institute_id, -- m78_institution_id_m02
                        i.m90_mariginability, -- m78_mariginability
                        i.m90_marginable_per, -- m78_marginable_per
                        i.new_symbol_margin_grp_id, -- m78_sym_margin_group_m77
                        i.map01_ntp_id, -- m78_status_id_v01
                        i.status_changed_date, -- m78_status_changed_date
                        i.status_changed_by_new_id, -- m78_status_changed_by_id_u17
                        i.created_date, -- m78_created_date
                        i.created_by_new_id, -- m78_created_by_id_u17
                        i.last_updated_date, -- m78_last_updated_date
                        i.last_updated_by_new_id, -- m78_last_updated_by_id_u17
                        i.m20_exchange_id_m01, -- m78_exchange_id_m01
                        i.m20_exchange_code_m01, -- m78_exchange_code_m01
                        '1' -- m78_custom_type
                           );

                INSERT INTO m78_sym_marginability_mappings
                     VALUES (i.m90_id, l_symbol_margin_id);
            ELSE
                UPDATE dfn_ntp.m78_symbol_marginability
                   SET m78_symbol_id_m20 = i.new_symbol_id, -- m78_symbol_id_m20
                       m78_symbol_code_m20 = i.m20_symbol_code, -- m78_symbol_code_m20
                       m78_institution_id_m02 = i.new_institute_id, -- m78_institution_id_m02
                       m78_mariginability = i.m90_mariginability, -- m78_mariginability
                       m78_marginable_per = i.m90_marginable_per, -- m78_marginable_per
                       m78_sym_margin_group_m77 = i.new_symbol_margin_grp_id, -- m78_sym_margin_group_m77
                       m78_status_id_v01 = i.map01_ntp_id, -- m78_status_id_v01
                       m78_status_changed_date = i.status_changed_date, -- m78_status_changed_date
                       m78_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m78_status_changed_by_id_u17
                       m78_last_updated_date =
                           NVL (i.last_updated_date, SYSDATE), -- m78_last_updated_date
                       m78_last_updated_by_id_u17 =
                           NVL (i.last_updated_by_new_id, 0), -- m78_last_updated_by_id_u17
                       m78_exchange_id_m01 = i.m20_exchange_id_m01, -- m78_exchange_id_m01
                       m78_exchange_code_m01 = i.m20_exchange_code_m01 -- m78_exchange_code_m01
                 WHERE m78_id = i.new_sym_marginability_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M78_SYMBOL_MARGINABILITY',
                                i.m90_id,
                                CASE
                                    WHEN i.new_sym_marginability_id IS NULL
                                    THEN
                                        l_symbol_margin_id
                                    ELSE
                                        i.new_sym_marginability_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_sym_marginability_id IS NULL
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