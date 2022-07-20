CREATE OR REPLACE PROCEDURE dfn_ntp.sp_process_interest_indices (
    p_primary_institution_id IN NUMBER)
IS
    l_existing_item         NUMBER;
    l_existing_item_count   NUMBER;
    l_last_seq              NUMBER (10);
    l_system_user           NUMBER DEFAULT 0;
    l_rec_count             NUMBER (10) := 0;
BEGIN
    SELECT system_user
      INTO l_system_user
      FROM (SELECT m41.*
              FROM     m41_file_processing_job_para m41
                   JOIN
                       m40_file_processing_job_config m40
                   ON     m41.m41_config_id_m40 = m40.m40_id
                      AND m40.m40_file_type_id_v01 = 8  -- InterestIndices = 8
                      AND m40.m40_primary_institute_id_m02 = p_primary_institution_id) PIVOT (MAX (
                                                                                          m41_value)
                                                                               FOR m41_key
                                                                               IN  ('SYSTEM_USER' system_user));

    FOR i
        IN (SELECT m187.m187_rate_type,
                   m187.m187_duration,
                   m187.m187_name,
                   m187.m187_rate,
                   m187.m187_primary_institute_id_m02,
                   v01.v01_id AS rate_type,
                   m64.m64_id AS duration_id
              FROM m187_interest_indices m187
                   LEFT JOIN v01_system_master_data v01
                       ON     v01.v01_type = 79
                          AND v01.v01_description = m187.m187_rate_type
                   LEFT JOIN m64_saibor_basis_durations m64
                       ON m187.m187_duration = m64.m64_duration
             WHERE m187_primary_institute_id_m02 = p_primary_institution_id)
    LOOP
        SELECT MAX (m65_id), COUNT (*)
          INTO l_existing_item, l_existing_item_count
          FROM m65_saibor_basis_rates
         WHERE     m65_type = i.rate_type
               AND m65_duration_id_m64 = i.duration_id
               AND m65_institution_id_m02 = p_primary_institution_id;


        IF l_existing_item_count = 0         -- -- insert item since not exist
        THEN
            SELECT app_seq_value
              INTO l_last_seq
              FROM app_seq_store
             WHERE app_seq_name = 'M65_SAIBOR_BASIS_RATES';

            l_last_seq := NVL (l_last_seq, 0) + 1;

            UPDATE app_seq_store
               SET app_seq_value = l_last_seq
             WHERE app_seq_name = 'M65_SAIBOR_BASIS_RATES';

            INSERT INTO m65_saibor_basis_rates (m65_id,
                                                m65_description,
                                                m65_type,
                                                m65_duration_id_m64,
                                                m65_rate,
                                                m65_tax,
                                                m65_institution_id_m02,
                                                m65_status_id_v01,
                                                m65_status_changed_by_id_u17,
                                                m65_status_changed_date,
                                                m65_created_by_id_u17,
                                                m65_created_date,
                                                m65_custom_type)
                 VALUES (l_last_seq,
                         i.m187_name,
                         i.rate_type,
                         i.duration_id,
                         i.m187_rate,
                         0,
                         p_primary_institution_id,
                         2,                                        -- approved
                         l_system_user,
                         SYSDATE,
                         l_system_user,
                         SYSDATE,
                         1);
        ELSE                                        -- update item since exist
            UPDATE m65_saibor_basis_rates
               SET m65_description = i.m187_name,
                   m65_type = i.rate_type,
                   m65_duration_id_m64 = i.duration_id,
                   m65_rate = i.m187_rate,
                   m65_status_id_v01 = 2,                          -- approved
                   m65_status_changed_by_id_u17 = l_system_user,
                   m65_status_changed_date = SYSDATE,
                   m65_modified_by_id_u17 = l_system_user,
                   m65_modified_date = SYSDATE
             WHERE m65_id = l_existing_item;
        END IF;

        l_rec_count := l_rec_count + 1;

        IF MOD (l_rec_count, 10000) = 0
        THEN
            COMMIT;
        END IF;
    END LOOP;

    COMMIT;
END;
/