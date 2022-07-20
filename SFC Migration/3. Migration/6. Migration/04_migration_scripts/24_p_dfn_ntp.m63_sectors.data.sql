DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_sector_id              NUMBER;
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

    SELECT NVL (MAX (m63_id), 0) INTO l_sector_id FROM dfn_ntp.m63_sectors;

    DELETE FROM error_log
          WHERE mig_table = 'M63_SECTORS';

    FOR i
        IN (SELECT m01.m01_id,
                   NVL (map16.map16_ntp_code, m99.m99_exchangecode)
                       AS exchange_code,
                   m99.m99_sector_id,
                   m99.m99_description_1,
                   m99.m99_description_2,
                   m99.m99_shortdescription_1,
                   m99.m99_shortdescription_2,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m99.m99_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m99.m99_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m99.m99_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m63.m63_id
              FROM mubasher_oms.m99_sectors@mubasher_db_link m99,
                   map01_approval_status_v01 map01,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   map16_optional_exchanges_m01 map16,
                   (SELECT m63_id, m63_exchange_code_m01, m63_sector_code
                      FROM dfn_ntp.m63_sectors
                     WHERE m63_institute_id_m02 = l_primary_institute_id) m63
             WHERE     m99.m99_status_id = map01.map01_oms_id
                   AND m99.m99_exchangecode = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, m99.m99_exchangecode) =
                           m01.m01_exchange_code(+)
                   AND m99.m99_created_by = u17_created.old_employee_id(+)
                   AND m99.m99_modified_by = u17_modified.old_employee_id(+)
                   AND m99.m99_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND NVL (map16.map16_ntp_code, m99.m99_exchangecode) =
                           m63_exchange_code_m01(+)
                   AND m99.m99_sector_id = m63_sector_code(+))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.m63_id IS NULL
            THEN
                l_sector_id := l_sector_id + 1;

                INSERT
                  INTO dfn_ntp.m63_sectors (m63_id,
                                            m63_exchange_id_m01,
                                            m63_exchange_code_m01,
                                            m63_sector_code,
                                            m63_description,
                                            m63_description_lang,
                                            m63_shortdescription,
                                            m63_shortdescription_lang,
                                            m63_created_by_id_u17,
                                            m63_created_date,
                                            m63_modified_by_id_u17,
                                            m63_modified_date,
                                            m63_status_id_v01,
                                            m63_status_changed_by_id_u17,
                                            m63_status_changed_date,
                                            m63_custom_type,
                                            m63_institute_id_m02)
                VALUES (l_sector_id, -- m63_id
                        i.m01_id, -- m63_exchange_id_m01
                        i.exchange_code, -- m63_exchange_code_m01
                        i.m99_sector_id, -- m63_sector_code
                        i.m99_description_1, -- m63_description
                        i.m99_description_2, -- m63_description_lang
                        i.m99_description_1, -- m63_shortdescription
                        i.m99_description_2, -- m63_shortdescription_lang
                        i.created_by_new_id, -- m63_created_by_id_u17
                        i.created_date, -- m63_created_date
                        i.modifed_by_new_id, -- m63_modified_by_id_u17
                        i.modified_date, -- m63_modified_date
                        i.map01_ntp_id, -- m63_status_id_v01
                        i.status_changed_by_new_id, -- m63_status_changed_by_id_u17
                        i.status_changed_date, -- m63_status_changed_date
                        '1', -- m63_custom_type
                        l_primary_institute_id -- m63_institute_id_m02
                                              );
            ELSE
                UPDATE dfn_ntp.m63_sectors
                   SET m63_exchange_id_m01 = i.m01_id, -- m63_exchange_id_m01
                       m63_description = i.m99_description_1, -- m63_description
                       m63_description_lang = i.m99_description_2, -- m63_description_lang
                       m63_shortdescription = i.m99_description_1, -- m63_shortdescription
                       m63_shortdescription_lang = i.m99_description_2, -- m63_shortdescription_lang
                       m63_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m63_modified_by_id_u17
                       m63_modified_date = NVL (i.modified_date, SYSDATE), -- m63_modified_date
                       m63_status_id_v01 = i.map01_ntp_id, -- m63_status_id_v01
                       m63_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m63_status_changed_by_id_u17
                       m63_status_changed_date = i.status_changed_date -- m63_status_changed_date
                 WHERE m63_id = i.m63_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M63_SECTORS',
                                   'Exchange : '
                                || i.exchange_code
                                || ' | Sector : '
                                || i.m99_sector_id,
                                CASE
                                    WHEN i.m63_id IS NULL THEN l_sector_id
                                    ELSE i.m63_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.m63_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/