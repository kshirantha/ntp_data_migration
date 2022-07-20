DECLARE
    l_uploaded_doc_pages_id   NUMBER;
    l_sqlerrm                 VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (u45_id), 0)
      INTO l_uploaded_doc_pages_id
      FROM dfn_ntp.u45_uploaded_doc_pages;

    DELETE FROM error_log
          WHERE mig_table = 'U45_UPLOADED_DOC_PAGES';

    FOR i IN (SELECT g07.g07_id,
                     u44_map.new_uploaded_doc_id,
                     g07.g07_file_name,
                     g07.g07_sequence,
                     u45_map.new_uploaded_doc_page_id
                FROM mubasher_oms.g07_uploaded_doc_pages@mubasher_db_link g07
                     JOIN u44_uploaded_doc_mappings u44_map
                         ON g07.g07_uploaded_document =
                                u44_map.old_uploaded_doc_id
                     LEFT JOIN u45_uploaded_doc_page_mappings u45_map
                         ON g07.g07_id = u45_map.old_uploaded_doc_page_id)
    LOOP
        BEGIN
            IF i.new_uploaded_doc_page_id IS NULL
            THEN
                l_uploaded_doc_pages_id := l_uploaded_doc_pages_id + 1;

                INSERT
                  INTO dfn_ntp.u45_uploaded_doc_pages (u45_id,
                                                       u45_upload_doc_id_u44,
                                                       u45_file_name,
                                                       u45_local_file_name,
                                                       u45_sequence,
                                                       u45_uploaded_by_id_u17,
                                                       u45_uploaded_date,
                                                       u45_custom_type)
                VALUES (l_uploaded_doc_pages_id, -- u45_id
                        i.new_uploaded_doc_id, -- u45_upload_doc_id_u44
                        i.g07_file_name, -- u45_file_name
                        NULL, -- u45_local_file_name | Not Available
                        i.g07_sequence, -- u45_sequence
                        0, -- u45_uploaded_by_id_u17
                        SYSDATE, -- u45_uploaded_date
                        '1' -- u45_custom_type
                           );

                INSERT INTO u45_uploaded_doc_page_mappings
                     VALUES (i.g07_id, l_uploaded_doc_pages_id);
            ELSE
                UPDATE dfn_ntp.u45_uploaded_doc_pages
                   SET u45_upload_doc_id_u44 = i.new_uploaded_doc_id, -- u45_upload_doc_id_u44
                       u45_file_name = i.g07_file_name, -- u45_file_name
                       u45_sequence = i.g07_sequence -- u45_sequence
                 WHERE u45_id = i.new_uploaded_doc_page_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U45_UPLOADED_DOC_PAGES',
                                i.g07_id,
                                CASE
                                    WHEN i.new_uploaded_doc_page_id IS NULL
                                    THEN
                                        l_uploaded_doc_pages_id
                                    ELSE
                                        i.new_uploaded_doc_page_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_uploaded_doc_page_id IS NULL
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
