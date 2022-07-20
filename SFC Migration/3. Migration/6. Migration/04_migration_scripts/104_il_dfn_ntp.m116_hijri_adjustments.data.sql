DECLARE
    l_hijri_adjustments_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m116_id), 0)
      INTO l_hijri_adjustments_id
      FROM dfn_ntp.m116_hijri_adjustments;

    DELETE FROM error_log
          WHERE mig_table = 'M116_HIJRI_ADJUSTMENTS';

    FOR i
        IN (SELECT m268.m268_id,
                   m268.m268_date_from,
                   m268.m268_date_to,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m268_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modified_by_new_id,
                   m268_modified_date AS modified_date,
                   m268.m268_adjustment,
                   m02_map.new_institute_id,
                   m116_map.new_hijri_adjustment_id
              FROM mubasher_oms.m268_hijri_adjustments@mubasher_db_link m268,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   m116_hijri_adjustment_mappings m116_map
             WHERE     m268.m268_created_by = u17_created.old_employee_id(+)
                   AND m268.m268_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m268.m268_id = m116_map.old_hijri_adjustment_id(+)
                   AND m02_map.old_institute_id =
                           m116_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_hijri_adjustment_id IS NULL
            THEN
                INSERT
                  INTO dfn_ntp.m116_hijri_adjustments (
                           m116_id,
                           m116_from_date,
                           m116_to_date,
                           m116_created_by_id_u17,
                           m116_created_date,
                           m116_modified_by_id_u17,
                           m116_modified_date,
                           m116_adjustment,
                           m116_status_id_v01,
                           m116_status_changed_by_id_u17,
                           m116_status_changed_date,
                           m116_custom_type,
                           m116_institute_id_m02)
                VALUES (l_hijri_adjustments_id, -- m116_id
                        i.m268_date_from, -- m116_from_date
                        i.m268_date_to, -- m116_to_date
                        i.created_by_new_id, -- m116_created_by_id_u17
                        i.created_date, -- m116_created_date
                        i.modified_by_new_id, -- m116_modified_by_id_u17
                        i.modified_date, -- m116_modified_date
                        i.m268_adjustment, -- m116_adjustment
                        2, -- m116_status_id_v01
                        i.modified_by_new_id, -- m116_status_changed_by_id_u17
                        i.modified_date, -- m116_status_changed_date
                        '1', -- m116_custom_type
                        i.new_institute_id -- m116_institute_id_m02
                                          );

                INSERT INTO m116_hijri_adjustment_mappings
                     VALUES (
                                i.m268_id,
                                l_hijri_adjustments_id,
                                i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m116_hijri_adjustments
                   SET m116_from_date = i.m268_date_from, -- m116_from_date
                       m116_to_date = i.m268_date_to, -- m116_to_date
                       m116_modified_by_id_u17 = i.modified_by_new_id, -- m116_modified_by_id_u17
                       m116_modified_date = i.modified_date, -- m116_modified_date
                       m116_adjustment = i.m268_adjustment, -- m116_adjustment
                       m116_status_changed_by_id_u17 =
                           NVL (i.modified_by_new_id, 0), -- m116_status_changed_by_id_u17
                       m116_status_changed_date =
                           NVL (i.modified_date, SYSDATE) -- m116_status_changed_date
                 WHERE m116_id = i.new_hijri_adjustment_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M116_HIJRI_ADJUSTMENTS',
                                i.m268_id,
                                CASE
                                    WHEN i.new_hijri_adjustment_id IS NULL
                                    THEN
                                        l_hijri_adjustments_id
                                    ELSE
                                        i.new_hijri_adjustment_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_hijri_adjustment_id IS NULL
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