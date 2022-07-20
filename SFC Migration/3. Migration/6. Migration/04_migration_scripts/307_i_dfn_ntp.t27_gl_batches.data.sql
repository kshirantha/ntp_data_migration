DECLARE
    l_gl_batches_id   NUMBER;
    l_sqlerrm         VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t27_id), 0)
      INTO l_gl_batches_id
      FROM dfn_ntp.t27_gl_batches;

    DELETE FROM error_log
          WHERE mig_table = 'T27_GL_BATCHES';

    FOR i
        IN (SELECT t76.t76_batch_id,
                   m02_map.new_institute_id,
                   t76.t76_date,
                   NVL (u17_created.new_employee_id, 0) AS created_by,
                   t76.t76_created_date AS created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   t76.t76_posted_date AS status_changed_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   t27_map.new_gl_batches_id,
                   CASE
                       WHEN t76.t76_batch_type = 1 THEN 2 -- LB GL - Daily
                       WHEN t76.t76_batch_type = 2 THEN 1 -- IB GL - Daily
                   END
                       AS event_category
              FROM mubasher_oms.t76_batch_imports@mubasher_db_link t76,
                   m02_institute_mappings m02_map,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_status_changed,
                   t27_gl_batches_mappings t27_map
             WHERE     t76.t76_inst_id = m02_map.old_institute_id
                   AND t76.t76_status_id = map01.map01_oms_id
                   AND t76.t76_created_by = u17_created.old_employee_id(+)
                   AND t76.t76_posted_by =
                           u17_status_changed.old_employee_id(+)
                   AND t76.t76_batch_id = t27_map.old_gl_batches_id(+))
    LOOP
        BEGIN
            IF i.new_gl_batches_id IS NULL
            THEN
                l_gl_batches_id := l_gl_batches_id + 1;

                INSERT
                  INTO dfn_ntp.t27_gl_batches (t27_id,
                                               t27_institute_id_m02,
                                               t27_date,
                                               t27_event_cat_id_m136,
                                               t27_created_by_id_u17,
                                               t27_created_date,
                                               t27_status_id_v01,
                                               t27_status_changed_by_id_u17,
                                               t27_status_changed_date,
                                               t27_custom_type)
                VALUES (l_gl_batches_id, -- t27_id
                        i.new_institute_id, -- t27_institute_id_m02
                        i.t76_date, -- t27_date
                        i.event_category, -- t27_event_cat_id_m136
                        i.created_by, -- t27_created_by_id_u17
                        i.created_date, -- t27_created_date
                        i.map01_ntp_id, -- t27_status_id_v01
                        i.status_changed_by_new_id, -- t27_status_changed_by_id_u17
                        i.status_changed_date, -- t27_status_changed_date
                        '1' -- t27_custom_type
                           );

                INSERT
                  INTO t27_gl_batches_mappings (old_gl_batches_id,
                                                new_gl_batches_id)
                VALUES (i.t76_batch_id, l_gl_batches_id);
            ELSE
                UPDATE dfn_ntp.t27_gl_batches
                   SET t27_institute_id_m02 = i.new_institute_id, -- t27_institute_id_m02
                       t27_date = i.t76_date, -- t27_date
                       t27_event_cat_id_m136 = i.event_category, -- t27_event_cat_id_m136
                       t27_status_id_v01 = i.map01_ntp_id, -- t27_status_id_v01
                       t27_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- t27_status_changed_by_id_u17
                       t27_status_changed_date = i.status_changed_date -- t27_status_changed_date
                 WHERE t27_id = i.new_gl_batches_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T27_GL_BATCHES',
                                i.t76_batch_id,
                                CASE
                                    WHEN i.new_gl_batches_id IS NULL
                                    THEN
                                        l_gl_batches_id
                                    ELSE
                                        i.new_gl_batches_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_gl_batches_id IS NULL
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
