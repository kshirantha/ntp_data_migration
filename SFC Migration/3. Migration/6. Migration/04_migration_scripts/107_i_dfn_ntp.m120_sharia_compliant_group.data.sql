DECLARE
    l_sharia_complaint_grp_id   NUMBER;
    l_sqlerrm                   VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m120_id), 0)
      INTO l_sharia_complaint_grp_id
      FROM dfn_ntp.m120_sharia_compliant_group;

    DELETE FROM error_log
          WHERE mig_table = 'M120_SHARIA_COMPLIANT_GROUP';

    FOR i
        IN (SELECT m02_map.new_institute_id, m120.m120_id
              FROM m02_institute_mappings m02_map,
                   dfn_ntp.m120_sharia_compliant_group m120
             WHERE m02_map.new_institute_id = m120.m120_institute_id_m02(+))
    LOOP
        BEGIN
            IF i.m120_id IS NULL
            THEN
                l_sharia_complaint_grp_id := l_sharia_complaint_grp_id + 1;

                INSERT
                  INTO dfn_ntp.m120_sharia_compliant_group (
                           m120_id,
                           m120_name,
                           m120_institute_id_m02,
                           m120_created_by_id_u17,
                           m120_created_date,
                           m120_modified_by_id_u17,
                           m120_modified_date,
                           m120_status_id_v01,
                           m120_status_changed_by_id_u17,
                           m120_status_changed_date,
                           m120_is_default,
                           m120_custom_type)
                VALUES (l_sharia_complaint_grp_id, -- m120_id
                        'Default', -- m120_name
                        i.new_institute_id, -- m120_institute_id_m02
                        0, -- m120_created_by_id_u17
                        SYSDATE, -- m120_created_date
                        NULL, -- m120_modified_by_id_u17
                        NULL, -- m120_modified_date
                        2, -- m120_status_id_v01
                        0, -- m120_status_changed_by_id_u17
                        SYSDATE, -- m120_status_changed_date
                        1, -- m120_is_default
                        '1' -- m120_custom_type
                           );
            ELSE
                NULL; -- Nothing to Update.
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M120_SHARIA_COMPLIANT_GROUP',
                                'Institute : ' || i.new_institute_id,
                                CASE
                                    WHEN i.m120_id IS NULL
                                    THEN
                                        l_sharia_complaint_grp_id
                                    ELSE
                                        i.m120_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.m120_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
