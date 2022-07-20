DECLARE
    l_institute_documents_id   NUMBER;
    l_sqlerrm                  VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m62_id), 0)
      INTO l_institute_documents_id
      FROM dfn_ntp.m62_institute_documents;

    DELETE FROM error_log
          WHERE mig_table = 'M62_INSTITUTE_DOCUMENTS';

    FOR i
        IN (SELECT m02_map.new_institute_id,
                   map01.map01_ntp_id,
                   g05.g05_id,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (g05.g05_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   g05.g05_modified_date AS modified_date,
                   map09.map09_ntp_id,
                   g05.g05_document_type,
                   g05.g05_is_mandatory,
                   m62_map.new_inst_documents_id
              FROM mubasher_oms.g05_branch_documents@mubasher_db_link g05,
                   map01_approval_status_v01 map01,
                   m02_institute_mappings m02_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   map09_uploadable_documents_m61 map09,
                   m62_inst_documents_mappings m62_map
             WHERE     g05.g05_status = map01.map01_oms_id
                   AND g05.g05_branch = m02_map.old_institute_id
                   AND g05.g05_document = map09.map09_oms_id
                   AND g05.g05_created_by = u17_created.old_employee_id(+)
                   AND g05.g05_modified_by = u17_modified.old_employee_id(+)
                   AND g05.g05_id = m62_map.new_inst_documents_id(+))
    LOOP
        BEGIN
            IF i.new_inst_documents_id IS NULL
            THEN
                l_institute_documents_id := l_institute_documents_id + 1;

                INSERT
                  INTO dfn_ntp.m62_institute_documents (
                           m62_id,
                           m62_institute_id_m02,
                           m62_document_id_m61,
                           m62_document_type_id_v28,
                           m62_is_mandatory,
                           m62_created_by_id_u17,
                           m62_created_date,
                           m62_modified_by_id_u17,
                           m62_modified_date,
                           m62_status_id_v01,
                           m62_custom_type)
                VALUES (l_institute_documents_id, -- m62_id
                        i.new_institute_id, -- m62_institute_id_m02
                        i.map09_ntp_id, -- m62_document_id_m61
                        i.g05_document_type, -- m62_document_type_id_v28
                        i.g05_is_mandatory, -- m62_is_mandatory
                        i.created_by_new_id, -- m62_created_by_id_u17
                        i.created_date, -- m62_created_date
                        i.modifed_by_new_id, -- m62_modified_by_id_u17
                        i.modified_date, -- m62_modified_date
                        i.map01_ntp_id, -- m62_status_id_v01
                        '1' -- m62_custom_type
                           );

                INSERT INTO m62_inst_documents_mappings
                     VALUES (i.g05_id, l_institute_documents_id);
            ELSE
                UPDATE dfn_ntp.m62_institute_documents
                   SET m62_institute_id_m02 = i.new_institute_id, -- m62_institute_id_m02
                       m62_document_id_m61 = i.map09_ntp_id, -- m62_document_id_m61
                       m62_document_type_id_v28 = i.g05_document_type, -- m62_document_type_id_v28
                       m62_is_mandatory = i.g05_is_mandatory, -- m62_is_mandatory
                       m62_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m62_modified_by_id_u17
                       m62_modified_date = NVL (i.modified_date, SYSDATE), -- m62_modified_date
                       m62_status_id_v01 = i.map01_ntp_id -- m62_status_id_v01
                 WHERE m62_id = i.new_inst_documents_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M62_INSTITUTE_DOCUMENTS',
                                i.g05_id,
                                CASE
                                    WHEN i.new_inst_documents_id IS NULL
                                    THEN
                                        l_institute_documents_id
                                    ELSE
                                        i.new_inst_documents_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_inst_documents_id IS NULL
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
