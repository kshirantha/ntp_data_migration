DECLARE
    l_uploaded_documents_id   NUMBER;
    l_sqlerrm                 VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (u44_id), 0)
      INTO l_uploaded_documents_id
      FROM dfn_ntp.u44_uploaded_documents;

    DELETE FROM error_log
          WHERE mig_table = 'U44_UPLOADED_DOCUMENTS';

    FOR i IN (SELECT g06_id,
                     m62_map.new_inst_documents_id,
                     g06_version,
                     u01_map.new_customer_id,
                     u44_map.new_uploaded_doc_id
                FROM mubasher_oms.g06_uploaded_documents@mubasher_db_link g06
                     INNER JOIN u01_customer_mappings u01_map
                         ON g06.g06_owner = u01_map.old_customer_id
                     INNER JOIN m62_inst_documents_mappings m62_map
                         ON g06.g06_branch_document =
                                m62_map.old_inst_documents_id
                     LEFT JOIN u44_uploaded_doc_mappings u44_map
                         ON g06.g06_id = u44_map.old_uploaded_doc_id)
    LOOP
        BEGIN
            IF i.new_uploaded_doc_id IS NULL
            THEN
                l_uploaded_documents_id := l_uploaded_documents_id + 1;

                INSERT
                  INTO dfn_ntp.u44_uploaded_documents (
                           u44_id,
                           u44_institute_document_id_m62,
                           u44_version,
                           u44_owner_id_u01,
                           u44_file_availability,
                           u44_custom_type)
                VALUES (l_uploaded_documents_id,
                        i.new_inst_documents_id, -- u44_institute_document_id_m62
                        i.g06_version, -- u44_version
                        i.new_customer_id, -- u44_owner_id_u01
                        1, -- u44_file_availability
                        1 -- u44_custom_type
                         );

                INSERT INTO u44_uploaded_doc_mappings
                     VALUES (i.g06_id, l_uploaded_documents_id);
            ELSE
                UPDATE dfn_ntp.u44_uploaded_documents
                   SET u44_institute_document_id_m62 = i.new_inst_documents_id, -- u44_institute_document_id_m62
                       u44_version = i.g06_version, -- u44_version
                       u44_owner_id_u01 = i.new_customer_id -- u44_owner_id_u01
                 WHERE u44_id = i.new_uploaded_doc_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U44_UPLOADED_DOCUMENTS',
                                i.g06_id,
                                CASE
                                    WHEN i.new_uploaded_doc_id IS NULL
                                    THEN
                                        l_uploaded_documents_id
                                    ELSE
                                        i.new_uploaded_doc_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_uploaded_doc_id IS NULL
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
