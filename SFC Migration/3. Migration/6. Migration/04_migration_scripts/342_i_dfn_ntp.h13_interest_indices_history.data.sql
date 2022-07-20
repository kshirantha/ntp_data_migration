DECLARE
    l_interest_index_id   NUMBER;
    l_current_section     VARCHAR2 (4000);
    l_sqlerrm             VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (h13_id), 0)
      INTO l_interest_index_id
      FROM dfn_ntp.h13_interest_indices_history;

    DELETE FROM error_log
          WHERE mig_table = 'H13_INTEREST_INDICES_HISTORY';

    FOR i
        IN (SELECT h08.h08_index_id_sibor,
                   h08.h08_index_id_libor,
                   m65_map_sibor.new_saibor_basis_rate_id
                       AS new_index_id_sibor,
                   m65_map_libor.new_saibor_basis_rate_id
                       AS new_index_id_libor,
                   h08.h08_date,
                   m65_sibor.m65_description AS description_sibor,
                   m65_sibor.m65_duration_id_m64 AS duration_sibor,
                   h08.h08_rate_sibor,
                   m65_sibor.m65_institution_id_m02 AS institution_sibor,
                   m65_libor.m65_description AS description_libor,
                   m65_libor.m65_duration_id_m64 AS duration_libor,
                   h08.h08_rate_libor,
                   m65_libor.m65_institution_id_m02 AS institution_libor,
                   h13_map_sibor.new_inst_indices_hist_id
                       AS mapped_interest_index_id_sibor,
                   h13_map_libor.new_inst_indices_hist_id
                       AS mapped_interest_index_id_libor
              FROM mubasher_oms.h08_interest_indices_history@mubasher_db_link h08,
                   m65_saibor_basis_rate_mappings m65_map_sibor,
                   m65_saibor_basis_rate_mappings m65_map_libor,
                   dfn_ntp.m65_saibor_basis_rates m65_sibor,
                   dfn_ntp.m65_saibor_basis_rates m65_libor,
                   h13_inst_indices_hist_mappings h13_map_sibor,
                   h13_inst_indices_hist_mappings h13_map_libor
             WHERE     h08.h08_index_id_sibor =
                           m65_map_sibor.old_saibor_basis_rate_id(+)
                   AND h08.h08_index_id_libor =
                           m65_map_libor.old_saibor_basis_rate_id(+)
                   AND m65_map_sibor.new_saibor_basis_rate_id =
                           m65_sibor.m65_id(+)
                   AND m65_map_libor.new_saibor_basis_rate_id =
                           m65_libor.m65_id(+)
                   AND h08.h08_date = h13_map_sibor.history_date(+)
                   AND h08.h08_index_id_sibor =
                           h13_map_sibor.old_inst_indices_hist_id(+)
                   AND h08.h08_date = h13_map_libor.history_date(+)
                   AND h08.h08_index_id_libor =
                           h13_map_libor.old_inst_indices_hist_id(+))
    LOOP
        BEGIN
            IF i.new_index_id_sibor IS NOT NULL
            THEN
                l_current_section := 'SAIBOR';

                IF i.mapped_interest_index_id_sibor IS NULL
                THEN
                    l_interest_index_id := l_interest_index_id + 1;

                    INSERT
                      INTO dfn_ntp.h13_interest_indices_history (
                               h13_date,
                               h13_id,
                               h13_description,
                               h13_type,
                               h13_duration_id_m64,
                               h13_rate,
                               h13_institution_id_m02,
                               h13_custom_type,
                               h13_tax)
                    VALUES (i.h08_date, -- h13_date
                            l_interest_index_id, -- h13_id
                            i.description_sibor, -- h13_description
                            3, -- h13_type | 3 : SIBOR
                            i.duration_sibor, -- h13_duration_id_m64
                            i.h08_rate_sibor, -- h13_rate
                            i.institution_sibor, -- h13_institution_id_m02
                            '1', -- h13_custom_type
                            NULL -- h13_tax | Not Available
                                );

                    INSERT
                      INTO h13_inst_indices_hist_mappings (
                               old_inst_indices_hist_id,
                               new_inst_indices_hist_id,
                               history_date)
                    VALUES (
                               i.h08_index_id_sibor,
                               l_interest_index_id,
                               i.h08_date);
                ELSE
                    UPDATE dfn_ntp.h13_interest_indices_history
                       SET h13_duration_id_m64 = i.duration_sibor, -- h13_duration_id_m64
                           h13_rate = i.h08_rate_sibor, -- h13_rate
                           h13_institution_id_m02 = i.institution_sibor -- h13_institution_id_m02
                     WHERE h13_id = i.mapped_interest_index_id_sibor;
                END IF;
            END IF;

            IF i.new_index_id_libor IS NOT NULL
            THEN
                l_current_section := 'LAIBOR';

                IF i.mapped_interest_index_id_libor IS NULL
                THEN
                    l_interest_index_id := l_interest_index_id + 1;

                    INSERT
                      INTO dfn_ntp.h13_interest_indices_history (
                               h13_date,
                               h13_id,
                               h13_description,
                               h13_type,
                               h13_duration_id_m64,
                               h13_rate,
                               h13_institution_id_m02,
                               h13_custom_type,
                               h13_tax)
                    VALUES (i.h08_date, -- h13_date
                            l_interest_index_id, -- h13_id
                            i.description_libor, -- h13_description
                            4, -- h13_type | 4 : LIBOR
                            i.duration_libor, -- h13_duration_id_m64
                            i.h08_rate_libor, -- h13_rate
                            i.institution_libor, -- h13_institution_id_m02
                            '1', -- h13_custom_type
                            NULL -- h13_tax | Not Available
                                );

                    INSERT
                      INTO h13_inst_indices_hist_mappings (
                               old_inst_indices_hist_id,
                               new_inst_indices_hist_id,
                               history_date)
                    VALUES (
                               i.h08_index_id_libor,
                               l_interest_index_id,
                               i.h08_date);
                ELSE
                    UPDATE dfn_ntp.h13_interest_indices_history
                       SET h13_duration_id_m64 = i.duration_libor, -- h13_duration_id_m64
                           h13_rate = i.h08_rate_libor, -- h13_rate
                           h13_institution_id_m02 = i.institution_libor -- h13_institution_id_m02
                     WHERE h13_id = i.mapped_interest_index_id_libor;
                END IF;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'H13_INTEREST_INDICES_HISTORY',
                                   'Current Section: '
                                || l_current_section
                                || ' - Date: '
                                || i.h08_date
                                || ' - Sibor Index: '
                                || i.h08_index_id_sibor
                                || ' - Libor Index: '
                                || i.h08_index_id_libor,
                                CASE
                                    WHEN     i.new_index_id_sibor IS NOT NULL
                                         AND i.mapped_interest_index_id_sibor
                                                 IS NULL
                                    THEN
                                           'Sibor Index: '
                                        || l_interest_index_id
                                    WHEN     i.new_index_id_sibor IS NOT NULL
                                         AND i.mapped_interest_index_id_sibor
                                                 IS NOT NULL
                                    THEN
                                           'Sibor Index: '
                                        || i.mapped_interest_index_id_sibor
                                    WHEN     i.new_index_id_libor IS NOT NULL
                                         AND i.mapped_interest_index_id_libor
                                                 IS NULL
                                    THEN
                                           'Libor Index: '
                                        || l_interest_index_id
                                    WHEN     i.new_index_id_libor IS NOT NULL
                                         AND i.mapped_interest_index_id_libor
                                                 IS NOT NULL
                                    THEN
                                           'Libor Index: '
                                        || i.mapped_interest_index_id_libor
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN (   (    i.new_index_id_sibor
                                                      IS NOT NULL
                                              AND i.mapped_interest_index_id_sibor
                                                      IS NULL)
                                          OR (    i.new_index_id_libor
                                                      IS NOT NULL
                                              AND i.mapped_interest_index_id_libor
                                                      IS NULL))
                                    THEN
                                        'INSERT'
                                    WHEN (   (    i.new_index_id_sibor
                                                      IS NOT NULL
                                              AND i.mapped_interest_index_id_sibor
                                                      IS NOT NULL)
                                          OR (    i.new_index_id_libor
                                                      IS NOT NULL
                                              AND i.mapped_interest_index_id_libor
                                                      IS NOT NULL))
                                    THEN
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
