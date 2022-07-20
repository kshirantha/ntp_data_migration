DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_bskt_composition_id    NUMBER;
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

    SELECT NVL (MAX (m182_id), 0)
      INTO l_bskt_composition_id
      FROM dfn_ntp.m182_murabaha_bskt_composition;

    DELETE FROM error_log
          WHERE mig_table = 'M182_MURABAHA_BSKT_COMPOSITION';

    FOR i
        IN (SELECT m285.m285_id,
                   m181_map.new_murabaha_basket_id,
                   NVL (map16.map16_ntp_code, TRIM (m285.m285_m77_exchange))
                       AS exchange,
                   m01.m01_id,
                   m285.m285_m77_symbol_code,
                   m20.m20_id,
                   m285.m285_percentage,
                   m285.m285_allowed_change,
                   NVL (u17_created.new_employee_id, 0) AS created_by,
                   NVL (m285.m285_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modified_by,
                   m285.m285_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   m182_map.new_mrbh_bskt_compst_id
              FROM mubasher_oms.m285_murabaha_bskt_composition@mubasher_db_link m285,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   m181_murabaha_baskets_mappings m181_map,
                   map16_optional_exchanges_m01 map16,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   (SELECT m20_id, m20_symbol_code, m20_exchange_code_m01
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20,
                   m182_mrbh_bskt_compst_mappings m182_map
             WHERE     TRIM (m285.m285_m77_exchange) =
                           map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code,
                            TRIM (m285.m285_m77_exchange)) =
                           m01.m01_exchange_code(+)
                   AND m285.m285_m77_symbol_code = m20.m20_symbol_code
                   AND NVL (map16.map16_ntp_code,
                            TRIM (m285.m285_m77_exchange)) =
                           m20.m20_exchange_code_m01
                   AND m285.m285_status_id = map01.map01_oms_id
                   AND m285.m285_basket_id = m181_map.old_murabaha_basket_id
                   AND m285.m285_created_by = u17_created.old_employee_id(+)
                   AND m285.m285_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m285.m285_id = m182_map.old_mrbh_bskt_compst_id(+))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.new_mrbh_bskt_compst_id IS NULL
            THEN
                l_bskt_composition_id := l_bskt_composition_id + 1;

                INSERT
                  INTO dfn_ntp.m182_murabaha_bskt_composition (
                           m182_id,
                           m182_basket_id_m181,
                           m182_exchange_id_m01,
                           m182_symbol_code_m20,
                           m182_percentage,
                           m182_allowed_change,
                           m182_created_by_id_u17,
                           m182_created_date,
                           m182_modified_by_id_u17,
                           m182_modified_date,
                           m182_status_id_v01,
                           m182_custom_type,
                           m182_symbol_id_m20)
                VALUES (l_bskt_composition_id, -- m182_id
                        i.new_murabaha_basket_id, -- m182_basket_id_m181
                        i.m01_id, -- m182_exchange_id_m01
                        i.m285_m77_symbol_code, -- m182_symbol_code_m20
                        i.m285_percentage, -- m182_percentage
                        i.m285_allowed_change, -- m182_allowed_change
                        i.created_by, -- m182_created_by_id_u17
                        i.created_date, -- m182_created_date
                        i.modified_by, -- m182_modified_by_id_u17
                        i.modified_date, -- m182_modified_date
                        i.map01_ntp_id, -- m182_status_id_v01
                        '1', -- m182_custom_type
                        i.m20_id -- m182_symbol_id_m20
                                );

                INSERT
                  INTO m182_mrbh_bskt_compst_mappings (old_mrbh_bskt_compst_id,
                                                       new_mrbh_bskt_compst_id)
                VALUES (i.m285_id, l_bskt_composition_id);
            ELSE
                UPDATE dfn_ntp.m182_murabaha_bskt_composition
                   SET m182_basket_id_m181 = i.new_murabaha_basket_id, -- m182_basket_id_m181
                       m182_exchange_id_m01 = i.m01_id, -- m182_exchange_id_m01
                       m182_symbol_code_m20 = i.m285_m77_symbol_code, -- m182_symbol_code_m20
                       m182_percentage = i.m285_percentage, -- m182_percentage
                       m182_allowed_change = i.m285_allowed_change, -- m182_allowed_change
                       m182_modified_by_id_u17 = NVL (i.modified_by, 0), -- m182_modified_by_id_u17
                       m182_modified_date = NVL (i.modified_date, SYSDATE), -- m182_modified_date
                       m182_status_id_v01 = i.map01_ntp_id, -- m182_status_id_v01
                       m182_symbol_id_m20 = i.m20_id -- m182_symbol_id_m20
                 WHERE m182_id = i.new_mrbh_bskt_compst_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M182_MURABAHA_BSKT_COMPOSITION',
                                i.m285_id,
                                CASE
                                    WHEN i.new_mrbh_bskt_compst_id IS NULL
                                    THEN
                                        l_bskt_composition_id
                                    ELSE
                                        i.new_mrbh_bskt_compst_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_mrbh_bskt_compst_id IS NULL
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
