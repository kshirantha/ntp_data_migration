DECLARE
    l_broker_id                     NUMBER;
    l_primary_institute_id          NUMBER;
    l_derivative_spread_matrix_id   NUMBER;
    l_sqlerrm                       VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (m18_id), 0)
      INTO l_derivative_spread_matrix_id
      FROM dfn_ntp.m18_derivative_spread_matrix;

    DELETE FROM error_log
          WHERE mig_table = 'M18_DERIVATIVE_SPREAD_MATRIX';

    FOR i
        IN (SELECT m391.m391_id,
                   m20_1.m20_id AS symbol_id_1,
                   m20_2.m20_id AS symbol_id_2,
                   m391.m391_spread,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m391.m391_created_date, SYSDATE) AS created_date,
                   map01.map01_ntp_id,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m391.m391_modified_date AS modified_date,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m391.m391_status_change_date, SYSDATE)
                       AS status_changed_date,
                   m18_map.new_derivat_sprd_mtrx_id
              FROM mubasher_oms.m391_futures_spread_matrix@mubasher_db_link m391,
                   map16_optional_exchanges_m01 map16_1,
                   (SELECT m20_id, m20_symbol_code, m20_exchange_code_m01
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20_1,
                   map16_optional_exchanges_m01 map16_2,
                   (SELECT m20_id, m20_symbol_code, m20_exchange_code_m01
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20_2,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m18_derivat_sprd_mtrx_mappings m18_map
             WHERE     m391.m391_symbol_1 = m20_1.m20_symbol_code(+)
                   AND m391.m391_exchange_1 = map16_1.map16_oms_code(+)
                   AND NVL (map16_1.map16_ntp_code, m391.m391_exchange_1) =
                           m20_1.m20_exchange_code_m01(+)
                   AND m391.m391_symbol_2 = m20_2.m20_symbol_code(+)
                   AND m391.m391_exchange_2 = map16_2.map16_oms_code(+)
                   AND NVL (map16_2.map16_ntp_code, m391.m391_exchange_2) =
                           m20_2.m20_exchange_code_m01(+)
                   AND m391.m391_status = map01.map01_oms_id
                   AND m391.m391_created_by = u17_created.old_employee_id(+)
                   AND m391.m391_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m391.m391_status_change_by =
                           u17_status_changed.old_employee_id(+)
                   AND m391.m391_id = m18_map.old_derivat_sprd_mtrx_id(+))
    LOOP
        BEGIN
            IF i.symbol_id_1 IS NULL OR i.symbol_id_2 IS NULL
            THEN
                raise_application_error (-20001,
                                         'Symbol Not Available',
                                         TRUE);
            END IF;

            IF i.new_derivat_sprd_mtrx_id IS NULL
            THEN
                l_derivative_spread_matrix_id :=
                    l_derivative_spread_matrix_id + 1;

                INSERT
                  INTO dfn_ntp.m18_derivative_spread_matrix (
                           m18_id,
                           m18_symbol1_id_m20,
                           m18_symbol2_id_m20,
                           m18_spread_value,
                           m18_status_id_v01,
                           m18_created_by_id_u17,
                           m18_created_date,
                           m18_status_change_by_id_u17,
                           m18_status_change_date,
                           m18_modified_by_id_u17,
                           m18_modified_date,
                           m18_custom_type,
                           m18_institute_id_m02)
                VALUES (l_derivative_spread_matrix_id, -- m18_id
                        i.symbol_id_1, -- m18_symbol1_id_m20
                        i.symbol_id_2, -- m18_symbol2_id_m20
                        i.m391_spread, -- m18_spread_value
                        i.map01_ntp_id, -- m18_status_id_v01
                        i.created_by_new_id, -- m18_created_by_id_u17
                        i.created_date, -- m18_created_date
                        i.status_changed_by_new_id, -- m18_status_change_by_id_u17
                        i.status_changed_date, -- m18_status_change_date
                        i.modifed_by_new_id, -- m18_modified_by_id_u17
                        i.modified_date, -- m18_modified_date
                        '1', -- m18_custom_type,
                        l_primary_institute_id -- m18_institute_id_m02
                                              );

                INSERT
                  INTO m18_derivat_sprd_mtrx_mappings (
                           old_derivat_sprd_mtrx_id,
                           new_derivat_sprd_mtrx_id)
                VALUES (i.m391_id, l_derivative_spread_matrix_id);
            ELSE
                UPDATE dfn_ntp.m18_derivative_spread_matrix
                   SET m18_symbol1_id_m20 = i.symbol_id_1, -- m18_symbol1_id_m20
                       m18_symbol2_id_m20 = i.symbol_id_2, -- m18_symbol2_id_m20
                       m18_spread_value = i.m391_spread, -- m18_spread_value
                       m18_status_id_v01 = i.map01_ntp_id, -- m18_status_id_v01
                       m18_status_change_by_id_u17 =
                           i.status_changed_by_new_id, -- m18_status_change_by_id_u17
                       m18_status_change_date = i.status_changed_date, -- m18_status_change_date
                       m18_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m18_modified_by_id_u17
                       m18_modified_date = NVL (i.modified_date, SYSDATE) -- m18_modified_date
                 WHERE m18_id = i.new_derivat_sprd_mtrx_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M18_DERIVATIVE_SPREAD_MATRIX',
                                i.m391_id,
                                CASE
                                    WHEN i.new_derivat_sprd_mtrx_id IS NULL
                                    THEN
                                        l_derivative_spread_matrix_id
                                    ELSE
                                        i.new_derivat_sprd_mtrx_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_derivat_sprd_mtrx_id IS NULL
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