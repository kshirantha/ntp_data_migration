DECLARE
    l_broker_id               NUMBER;
    l_primary_institute_id    NUMBER;
    l_saibor_basis_rates_id   NUMBER;
    l_sqlerrm                 VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (m65_id), 0)
      INTO l_saibor_basis_rates_id
      FROM dfn_ntp.m65_saibor_basis_rates;

    DELETE FROM error_log
          WHERE mig_table = 'M65_SAIBOR_BASIS_RATES';

    FOR i
        IN (SELECT m253_id,
                   m253_description,
                   CASE
                       WHEN m253_type = 0 THEN 3 -- SIBOR
                       WHEN m253_type = 1 THEN 4 -- LIBOR
                   END
                       AS m253_type,
                   m253_duration, -- [SAME IDs]
                   m253_rate,
                   NVL (new_institute_id, l_primary_institute_id)
                       AS new_institute_id, -- [Corrective Actions Discussed]
                   map01.map01_ntp_id,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m253_created_date, SYSDATE) AS created_date,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m253_status_chaged_date, SYSDATE)
                       AS status_chaged_date,
                   u17_modified.new_employee_id AS modified_by_new_id,
                   m253_modified_date AS modified_date,
                   NVL (m253_vat, 0) AS m253_vat,
                   m65_map.new_saibor_basis_rate_id
              FROM mubasher_oms.m253_saibor_basis_rates@mubasher_db_link m253,
                   map01_approval_status_v01 map01,
                   m02_institute_mappings m02_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m65_saibor_basis_rate_mappings m65_map
             WHERE     m253.m253_status = map01.map01_oms_id
                   AND m253.m253_institution = m02_map.old_institute_id(+)
                   AND m253.m253_created_by = u17_created.old_employee_id(+)
                   AND m253.m253_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m253.m253_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m253.m253_id = m65_map.old_saibor_basis_rate_id(+))
    LOOP
        BEGIN
            IF i.new_institute_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Institute Not Available',
                                         TRUE);
            END IF;

            IF i.new_saibor_basis_rate_id IS NULL
            THEN
                l_saibor_basis_rates_id := l_saibor_basis_rates_id + 1;

                INSERT
                  INTO dfn_ntp.m65_saibor_basis_rates (
                           m65_id,
                           m65_description,
                           m65_type,
                           m65_duration_id_m64,
                           m65_rate,
                           m65_institution_id_m02,
                           m65_status_id_v01,
                           m65_status_changed_by_id_u17,
                           m65_status_changed_date,
                           m65_created_by_id_u17,
                           m65_created_date,
                           m65_modified_by_id_u17,
                           m65_modified_date,
                           m65_custom_type,
                           m65_tax)
                VALUES (l_saibor_basis_rates_id,
                        i.m253_description, -- m65_description
                        i.m253_type, -- m65_type
                        i.m253_duration, -- m65_duration_id_m64
                        i.m253_rate, -- m65_rate
                        i.new_institute_id, -- m65_institution_id_m02
                        i.map01_ntp_id, -- m65_status_id_v01
                        i.status_changed_by_new_id, -- m65_status_changed_by_id_u17
                        i.status_chaged_date, -- m65_status_changed_date
                        i.created_by_new_id, -- m65_created_by_id_u17
                        i.created_date, -- m65_created_date
                        i.modified_by_new_id, -- m65_modified_by_id_u17
                        i.modified_date, -- m65_modified_date
                        '1', -- m65_custom_type
                        i.m253_vat -- m65_tax
                                  );

                INSERT INTO m65_saibor_basis_rate_mappings
                     VALUES (i.m253_id, l_saibor_basis_rates_id);
            ELSE
                UPDATE dfn_ntp.m65_saibor_basis_rates
                   SET m65_description = i.m253_description, -- m65_description
                       m65_type = i.m253_type, -- m65_type
                       m65_duration_id_m64 = i.m253_duration, -- m65_duration_id_m64
                       m65_rate = i.m253_rate, -- m65_rate
                       m65_institution_id_m02 = i.new_institute_id, -- m65_institution_id_m02
                       m65_status_id_v01 = i.map01_ntp_id, -- m65_status_id_v01
                       m65_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m65_status_changed_by_id_u17
                       m65_status_changed_date = i.status_chaged_date, -- m65_status_changed_date
                       m65_modified_by_id_u17 = NVL (i.modified_by_new_id, 0), -- m65_modified_by_id_u17
                       m65_modified_date = NVL (i.modified_date, SYSDATE), -- m65_modified_date
                       m65_tax = i.m253_vat -- m65_tax
                 WHERE m65_id = i.new_saibor_basis_rate_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M65_SAIBOR_BASIS_RATES',
                                i.m253_id,
                                CASE
                                    WHEN i.new_saibor_basis_rate_id IS NULL
                                    THEN
                                        l_saibor_basis_rates_id
                                    ELSE
                                        i.new_saibor_basis_rate_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_saibor_basis_rate_id IS NULL
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

-- Default Saibor Basis Rates for Default Margin Interest Groups [SFC Specific Logic]

DECLARE
    l_saibor_basis_rates_id   NUMBER;
BEGIN
    SELECT NVL (MAX (m65_id), 0)
      INTO l_saibor_basis_rates_id
      FROM dfn_ntp.m65_saibor_basis_rates;

    FOR i
        IN (SELECT m02_map.new_institute_id, m65_default.sibor_basis_rate
              FROM m02_institute_mappings m02_map,
                   m65_default_sibor_basis_rates m65_default
             WHERE m02_map.new_institute_id = m65_default.institution(+))
    LOOP
        BEGIN
            IF i.sibor_basis_rate IS NULL
            THEN
                l_saibor_basis_rates_id := l_saibor_basis_rates_id + 1;

                INSERT
                  INTO dfn_ntp.m65_saibor_basis_rates (
                           m65_id,
                           m65_description,
                           m65_type,
                           m65_duration_id_m64,
                           m65_rate,
                           m65_institution_id_m02,
                           m65_status_id_v01,
                           m65_status_changed_by_id_u17,
                           m65_status_changed_date,
                           m65_created_by_id_u17,
                           m65_created_date,
                           m65_modified_by_id_u17,
                           m65_modified_date,
                           m65_custom_type,
                           m65_tax)
                VALUES (
                           l_saibor_basis_rates_id, -- m65_id
                              'Default Rate for Institution: '
                           || i.new_institute_id, -- m65_description
                           3, -- m65_type | SIBOR
                           NULL, -- m65_duration_id_m64
                           0, -- m65_rate
                           i.new_institute_id, -- m65_institution_id_m02
                           2, -- m65_status_id_v01
                           0, -- m65_status_changed_by_id_u17
                           SYSDATE, -- m65_status_changed_date
                           0, -- m65_created_by_id_u17
                           SYSDATE, -- m65_created_date
                           0, -- m65_modified_by_id_u17
                           SYSDATE, -- m65_modified_date
                           '1', -- m65_custom_type
                           0 -- m65_tax
                            );

                INSERT INTO m65_default_sibor_basis_rates
                     VALUES (i.new_institute_id, l_saibor_basis_rates_id);
            END IF;
        END;
    END LOOP;
END;
/
