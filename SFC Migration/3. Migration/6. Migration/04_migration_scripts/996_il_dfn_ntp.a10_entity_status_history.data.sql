DECLARE
    TYPE refcursor IS REF CURSOR;

    TYPE approval_record IS RECORD
    (
        new_ent_status_hist_id     NUMBER,
        m66_id                     NUMBER,
        map03_ntp_id               NUMBER,
        entity_pk                  NUMBER,
        mapping_table              VARCHAR2 (100),
        map01_ntp_id               NUMBER,
        status_changed_by_new_id   NUMBER,
        status_changed_date        DATE
    );

    c_approval_data              refcursor;
    r_approval_record            approval_record;
    l_query_string               VARCHAR2 (4000);
    l_query_execute              VARCHAR2 (4000);
    l_entity_status_history_id   NUMBER;
    l_sqlerrm                    VARCHAR2 (4000);

    l_rec_cnt                    NUMBER := 0;
BEGIN
    SELECT NVL (MAX (a10_id), 0)
      INTO l_entity_status_history_id
      FROM dfn_ntp.a10_entity_status_history;

    DELETE FROM error_log
          WHERE mig_table = 'Institution - A10_ENTITY_STATUS_HISTORY';

    FOR i IN (SELECT *
                FROM map03_approval_entity_id
               WHERE map03_type = 1)
    LOOP
        l_query_string :=
               'SELECT a10_map.new_ent_status_hist_id, audits.*
                FROM (SELECT m66.m66_id,'
            || i.map03_ntp_id
            || ' AS map03_ntp_id,
                       mapping.'
            || i.map03_new_column
            || ' AS entity_pk,
           '''
            || i.map03_mapping_table
            || ''' AS mapping_table,
                       map01.map01_ntp_id,
                       NVL (u17_map.new_employee_id, 0)
                           AS status_changed_by_new_id,
                       NVL (m66.m66_status_changed_date, SYSDATE)
                           AS status_changed_date
                  FROM mubasher_oms.m66_entity_status_history@mubasher_db_link m66,
                       map01_approval_status_v01 map01,
                       u17_employee_mappings u17_map,'
            || i.map03_mapping_table
            || ' mapping
                 WHERE     m66.m66_approval_entity_id = '
            || i.map03_oms_id
            || '
                       AND m66.m66_approval_status_id = map01.map01_oms_id
                       AND m66.m66_status_changed_by = u17_map.old_employee_id(+)
                       AND m66.m66_entity_pk =
                               TO_CHAR (mapping.'
            || i.map03_old_column
            || '(+))) audits,
              a10_entity_status_his_mappings a10_map
              WHERE audits.m66_id = a10_map.old_ent_status_hist_id(+)
                    AND audits.mapping_table = a10_map.mapping_table(+)
                    AND audits.entity_pk = a10_map.entity_key(+)';

        OPEN c_approval_data FOR l_query_string;

        LOOP
            BEGIN
                FETCH c_approval_data INTO r_approval_record;

                EXIT WHEN c_approval_data%NOTFOUND;

                IF r_approval_record.entity_pk IS NULL
                THEN
                    raise_application_error (-20001,
                                             'Entity Not Available',
                                             TRUE);
                END IF;

                IF r_approval_record.new_ent_status_hist_id IS NULL
                THEN
                    l_entity_status_history_id :=
                        l_entity_status_history_id + 1;

                    INSERT
                      INTO dfn_ntp.a10_entity_status_history (
                               a10_id,
                               a10_approval_entity_id,
                               a10_entity_pk,
                               a10_approval_status_id_v01,
                               a10_status_changed_by_id_u17,
                               a10_status_changed_date)
                    VALUES (l_entity_status_history_id, -- a10_id
                            r_approval_record.map03_ntp_id, -- a10_approval_entity_id
                            r_approval_record.entity_pk, -- a10_entity_pk
                            r_approval_record.map01_ntp_id, -- a10_approval_status_id_v01
                            r_approval_record.status_changed_by_new_id, -- a10_status_changed_by_id_u17
                            r_approval_record.status_changed_date -- a10_status_changed_date
                                                                 );

                    INSERT
                      INTO a10_entity_status_his_mappings (
                               old_ent_status_hist_id,
                               mapping_table,
                               entity_key,
                               new_ent_status_hist_id)
                    VALUES (r_approval_record.m66_id,
                            r_approval_record.mapping_table,
                            r_approval_record.entity_pk,
                            l_entity_status_history_id);
                ELSE
                    UPDATE dfn_ntp.a10_entity_status_history
                       SET a10_approval_status_id_v01 =
                               r_approval_record.map01_ntp_id, -- a10_approval_status_id_v01
                           a10_status_changed_by_id_u17 =
                               r_approval_record.status_changed_by_new_id -- a10_status_changed_by_id_u17
                     WHERE a10_id = r_approval_record.new_ent_status_hist_id;
                END IF;

                l_rec_cnt := l_rec_cnt + 1;

                IF MOD (l_rec_cnt, 25000) = 0
                THEN
                    COMMIT;
                END IF;
            EXCEPTION
                WHEN OTHERS
                THEN
                    l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                    INSERT INTO error_log
                         VALUES (
                                    'Institution - A10_ENTITY_STATUS_HISTORY',
                                       r_approval_record.mapping_table
                                    || ' - '
                                    || r_approval_record.new_ent_status_hist_id,
                                    CASE
                                        WHEN r_approval_record.new_ent_status_hist_id
                                                 IS NULL
                                        THEN
                                            l_entity_status_history_id
                                        ELSE
                                            r_approval_record.new_ent_status_hist_id
                                    END,
                                    l_sqlerrm,
                                    CASE
                                        WHEN r_approval_record.new_ent_status_hist_id
                                                 IS NULL
                                        THEN
                                            'INSERT'
                                        ELSE
                                            'UPDATE'
                                    END,
                                    SYSDATE);
            END;
        END LOOP;
    END LOOP;
END;
/
