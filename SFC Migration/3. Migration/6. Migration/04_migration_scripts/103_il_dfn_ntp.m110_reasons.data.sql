DECLARE
    l_reason_id   NUMBER;
    l_sqlerrm     VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m110_id), 0) INTO l_reason_id FROM dfn_ntp.m110_reasons;

    DELETE FROM error_log
          WHERE mig_table = 'M110_REASONS';

    FOR i
        IN (SELECT m252.m252_id,
                   m252.m252_description,
                   m02_map.new_institute_id,
                   m110_map.new_reasons_id
              FROM mubasher_oms.m252_withdraw_block_reason@mubasher_db_link m252,
                   m110_reasons_mappings m110_map,
                   m02_institute_mappings m02_map -- [Cross Join - Repeating for each Institution]
             WHERE     m252.m252_id = m110_map.old_reasons_id(+)
                   AND m02_map.new_institute_id =
                           m110_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_reasons_id IS NULL
            THEN
                l_reason_id := l_reason_id + 1;

                INSERT
                  INTO dfn_ntp.m110_reasons (m110_id,
                                             m110_type,
                                             m110_reason_text,
                                             m110_created_by_id_u17,
                                             m110_created_date,
                                             m110_modified_by_id_u17,
                                             m110_modified_date,
                                             m110_status_id_v01,
                                             m110_status_changed_by_id_u17,
                                             m110_status_changed_date,
                                             m110_eod_operation,
                                             m110_custom_type,
                                             m110_institute_id_m02)
                VALUES (l_reason_id, -- m110_id
                        5, -- m110_type | 5 - Cash Transaction Block
                        i.m252_description, -- m110_reason_text
                        0, -- m110_created_by_id_u17
                        SYSDATE, -- m110_created_date
                        NULL, -- m110_modified_by_id_u17
                        NULL, -- m110_modified_date
                        2, -- m110_status_id_v01
                        0, -- m110_status_changed_by_id_u17
                        SYSDATE, -- m110_status_changed_date
                        NULL, -- m110_eod_operation
                        '1', -- m110_custom_type
                        i.new_institute_id -- m110_institute_id_m02
                                          );

                INSERT
                  INTO m110_reasons_mappings (old_reasons_id,
                                              new_reasons_id,
                                              new_institute_id)
                VALUES (i.m252_id, l_reason_id, i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m110_reasons
                   SET m110_reason_text = i.m252_description, -- m110_reason_text
                       m110_modified_by_id_u17 = 0, -- m110_modified_by_id_u17
                       m110_modified_date = SYSDATE -- m110_modified_date
                 WHERE m110_id = i.new_reasons_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M110_REASONS',
                                   'Reason : '
                                || i.m252_id
                                || ' Institution : '
                                || i.new_institute_id,
                                CASE
                                    WHEN i.new_reasons_id IS NULL
                                    THEN
                                        l_reason_id
                                    ELSE
                                        i.new_reasons_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_reasons_id IS NULL
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
