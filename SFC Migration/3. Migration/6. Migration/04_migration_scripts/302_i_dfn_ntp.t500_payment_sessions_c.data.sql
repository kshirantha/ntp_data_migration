DECLARE
    l_payment_session_id   NUMBER;
    l_sqlerrm              VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t500_id), 0)
      INTO l_payment_session_id
      FROM dfn_ntp.t500_payment_sessions_c;

    DELETE FROM error_log
          WHERE mig_table = 'T500_PAYMENT_SESSIONS_C';

    FOR i
        IN (SELECT t122.t122_id,
                   t122.t122_date,
                   t122.t122_symbol,
                   t122.t122_file_name,
                   map01.map01_ntp_id,
                   NVL (u17_uploaded.new_employee_id, 0) AS uploaded_by,
                   t122.t122_uploaded_date AS uploaded_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   NVL (u17_processed.new_employee_id, 0) AS processed_by,
                   t122.t122_processed_date AS processed_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   m02_map.new_institute_id,
                   t500_map.new_paymnt_session_id,
                   CASE
                       WHEN map01.map01_ntp_id IN (3, 7) THEN 2
                       WHEN map01.map01_ntp_id = 6 THEN 1
                       ELSE 0
                   END
                       AS current_approval_level
              FROM mubasher_oms.t122_payment_sessions@mubasher_db_link t122,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_uploaded,
                   u17_employee_mappings u17_processed,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   t500_paymnt_session_c_mappings t500_map
             WHERE     t122.t122_status_id = map01.map01_oms_id
                   AND t122.t122_uploaded_by =
                           u17_uploaded.old_employee_id(+)
                   AND t122.t122_processed_by =
                           u17_processed.old_employee_id(+)
                   AND t122.t122_id = t500_map.old_paymnt_session_id(+))
    LOOP
        BEGIN
            IF i.new_paymnt_session_id IS NULL
            THEN
                l_payment_session_id := l_payment_session_id + 1;

                INSERT
                  INTO dfn_ntp.t500_payment_sessions_c (
                           t500_id,
                           t500_date,
                           t500_symbol_code_m20,
                           t500_file_name,
                           t500_status_id_v01,
                           t500_uploaded_by_id_u17,
                           t500_uploaded_date,
                           t500_validated_by_id_u17,
                           t500_validated_date,
                           t500_processed_by_id_u17,
                           t500_processed_date,
                           t500_custom_type,
                           t500_institute_id_m02,
                           t500_current_approval_level,
                           t500_status_changed_by_id_u17,
                           t500_status_changed_date)
                VALUES (l_payment_session_id, -- t500_id
                        i.t122_date, -- t500_date
                        i.t122_symbol, -- t500_symbol_code_m20
                        i.t122_file_name, -- t500_file_name
                        i.map01_ntp_id, -- t500_status_id_v01
                        i.uploaded_by, -- t500_uploaded_by_id_u17
                        i.uploaded_date, -- t500_uploaded_date
                        i.processed_by, -- t500_validated_by_id_u17
                        i.processed_date, -- t500_validated_date
                        i.processed_by, -- t500_processed_by_id_u17
                        i.processed_date, -- t500_processed_date
                        '1', -- t500_custom_type
                        i.new_institute_id, -- t500_institute_id_m02
                        i.current_approval_level, -- t500_current_approval_level
                        i.processed_by, -- t500_status_changed_by_id_u17
                        i.processed_date -- t500_status_changed_date
                                        );

                INSERT
                  INTO t500_paymnt_session_c_mappings (
                           old_paymnt_session_id,
                           new_paymnt_session_id,
                           new_institute_id)
                VALUES (i.t122_id, l_payment_session_id, i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.t500_payment_sessions_c
                   SET t500_date = i.t122_date, -- t500_date
                       t500_symbol_code_m20 = i.t122_symbol, -- t500_symbol_code_m20
                       t500_file_name = i.t122_file_name, -- t500_file_name
                       t500_status_id_v01 = i.map01_ntp_id, -- t500_status_id_v01
                       t500_uploaded_by_id_u17 = i.uploaded_by, -- t500_uploaded_by_id_u17
                       t500_uploaded_date = i.uploaded_date, -- t500_uploaded_date
                       t500_validated_by_id_u17 = i.processed_by, -- t500_validated_by_id_u17
                       t500_validated_date = i.processed_date, -- t500_validated_date
                       t500_processed_by_id_u17 = i.processed_by, -- t500_processed_by_id_u17
                       t500_processed_date = i.processed_date, -- t500_processed_date
                       t500_institute_id_m02 = i.new_institute_id, -- t500_institute_id_m02
                       t500_current_approval_level = i.current_approval_level, -- t500_current_approval_level
                       t500_status_changed_by_id_u17 = i.processed_by, -- t500_status_changed_by_id_u17
                       t500_status_changed_date = i.processed_date -- t500_status_changed_date
                 WHERE t500_id = i.new_paymnt_session_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T500_PAYMENT_SESSIONS_C',
                                i.t122_id,
                                CASE
                                    WHEN i.new_paymnt_session_id IS NULL
                                    THEN
                                        l_payment_session_id
                                    ELSE
                                        i.new_paymnt_session_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_paymnt_session_id IS NULL
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
