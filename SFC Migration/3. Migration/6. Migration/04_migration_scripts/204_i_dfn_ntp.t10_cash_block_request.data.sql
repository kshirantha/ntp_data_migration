DECLARE
    l_cash_block_request_id   NUMBER;
    l_log_id                  NUMBER;
    l_sqlerrm                 VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t10_id), 0)
      INTO l_cash_block_request_id
      FROM dfn_ntp.t10_cash_block_request;

    SELECT NVL (MAX (a09_id), 0)
      INTO l_log_id
      FROM dfn_ntp.a09_function_approval_log;

    DELETE FROM error_log
          WHERE mig_table = 'T10_CASH_BLOCK_REQUEST';

    FOR i
        IN (SELECT t77.t77_id,
                   u06_map.new_cash_account_id,
                   t77.t77_amount_blocked,
                   t77.t77_from_date,
                   t77.t77_to_date,
                   t77.t77_reason_for_block,
                   t77.t77_type, -- [SAME IDs]
                   CASE WHEN map01.map01_ntp_id IN (3, 7) THEN 1 ELSE 0 END
                       AS approval_completed,
                   CASE
                       WHEN map01.map01_ntp_id IN (3, 7) THEN 2
                       WHEN map01.map01_ntp_id = 6 THEN 1
                       WHEN map01.map01_ntp_id = 1 THEN 0
                   END
                       AS current_approval_level,
                   CASE
                       WHEN map01.map01_ntp_id = 7 THEN 2
                       WHEN map01.map01_ntp_id = 3 THEN 3
                       WHEN map01.map01_ntp_id = 101 THEN 102
                       WHEN map01.map01_ntp_id = 1 THEN 101
                   END
                       AS next_status,
                   t77.t77_status_changed_date AS status_changed_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   NVL (status_changed_by.new_employee_id,
                        u17_created.new_employee_id)
                       AS status_changed_by_new_id,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   map01.map01_ntp_id,
                   t77.t77_created_date AS created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   CASE WHEN map01_ntp_id = 9 THEN 5 ELSE 0 END -- If Expired then Deleted
                       AS delete_status,
                   u06.u06_institute_id_m02,
                   t10_map.new_cash_block_req_id
              FROM mubasher_oms.t77_fund_transfer_block@mubasher_db_link t77,
                   map01_approval_status_v01 map01,
                   u06_cash_account_mappings u06_map,
                   dfn_ntp.u06_cash_account u06,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings status_changed_by,
                   t10_cash_block_req_mappings t10_map
             WHERE     t77.t77_status_id = map01.map01_oms_id
                   AND t77.t77_cash_acc_id = u06_map.old_cash_account_id(+)
                   AND u06_map.new_cash_account_id = u06.u06_id(+)
                   AND t77.t77_created_by = u17_created.old_employee_id(+)
                   AND t77.t77_status_changed_by =
                           status_changed_by.old_employee_id(+)
                   AND t77.t77_id = t10_map.old_cash_block_req_id(+))
    LOOP
        BEGIN
            IF i.new_cash_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Cash Account Not Available',
                                         TRUE);
            END IF;

            IF i.new_cash_block_req_id IS NULL
            THEN
                l_cash_block_request_id := l_cash_block_request_id + 1;

                INSERT
                  INTO dfn_ntp.t10_cash_block_request (
                           t10_id,
                           t10_cash_account_id_u06,
                           t10_amount_blocked,
                           t10_from_date,
                           t10_to_date,
                           t10_reason_for_block,
                           t10_type,
                           t10_no_of_approval,
                           t10_is_approval_completed,
                           t10_current_approval_level,
                           t10_next_status,
                           t10_status,
                           t10_created_date,
                           t10_created_by,
                           t10_last_updated_date,
                           t10_last_updated_by,
                           t10_comment,
                           t10_delete_status,
                           t10_custom_type,
                           t10_institute_id_m02)
                VALUES (l_cash_block_request_id, -- t10_id
                        i.new_cash_account_id, -- t10_cash_account_id_u06
                        i.t77_amount_blocked, -- t10_amount_blocked
                        i.t77_from_date, -- t10_from_date
                        i.t77_to_date, -- t10_to_date
                        i.t77_reason_for_block, -- t10_reason_for_block
                        i.t77_type, -- t10_type
                        2, -- t10_no_of_approval
                        i.approval_completed, -- t10_is_approval_completed
                        i.current_approval_level, -- t10_current_approval_level
                        i.next_status, -- t10_next_status
                        i.map01_ntp_id, -- t10_status
                        i.created_date, -- t10_created_date
                        i.created_by_new_id, -- t10_created_by
                        i.status_changed_date, -- t10_last_updated_date
                        i.status_changed_by_new_id, -- t10_last_updated_by
                        NULL, -- t10_comment
                        i.delete_status, -- t10_delete_status
                        '1', -- t10_custom_type
                        i.u06_institute_id_m02 -- t10_institute_id_m02
                                              );

                INSERT INTO t10_cash_block_req_mappings
                     VALUES (i.t77_id, l_cash_block_request_id);

                IF (i.created_by_new_id IS NOT NULL)
                THEN
                    l_log_id := l_log_id + 1;

                    INSERT
                      INTO dfn_ntp.a09_function_approval_log (
                               a09_id,
                               a09_function_id_m88,
                               a09_function_name_m88,
                               a09_request_id,
                               a09_status_id_v01,
                               a09_action_by_id_u17,
                               a09_action_date,
                               a09_created_by_id_u17,
                               a09_created_date,
                               a09_narration,
                               a09_reject_reason,
                               a09_custom_type)
                    VALUES (l_log_id, -- a09_id
                            7, -- a09_function_id_m88
                            'CASHBLOCK', -- a09_function_name_m88
                            l_cash_block_request_id, -- a09_request_id
                            1, -- a09_status_id_v01
                            i.created_by_new_id, -- a09_action_by_id_u17
                            i.created_date, -- a09_action_date
                            i.created_by_new_id, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Pending', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;

                IF (i.map01_ntp_id = 9)
                THEN
                    l_log_id := l_log_id + 1;

                    INSERT INTO dfn_ntp.a09_function_approval_log
                         VALUES (l_log_id, -- a09_id
                                 7, -- a09_function_id_m88
                                 'CASHBLOCK', -- a09_function_name_m88
                                 l_cash_block_request_id, -- a09_request_id
                                 5, -- a09_status_id_v01
                                 i.status_changed_by_new_id, -- a09_action_by_id_u17
                                 i.status_changed_date, -- a09_action_date
                                 i.created_by_new_id, -- a09_created_by_id_u17
                                 i.created_date, -- a09_created_date
                                 'Deleted', -- a09_narration
                                 NULL, -- a09_reject_reason
                                 '1' -- a09_custom_type
                                    );
                END IF;

                IF (i.map01_ntp_id = 6)
                THEN
                    l_log_id := l_log_id + 1;

                    INSERT
                      INTO dfn_ntp.a09_function_approval_log (
                               a09_id,
                               a09_function_id_m88,
                               a09_function_name_m88,
                               a09_request_id,
                               a09_status_id_v01,
                               a09_action_by_id_u17,
                               a09_action_date,
                               a09_created_by_id_u17,
                               a09_created_date,
                               a09_narration,
                               a09_reject_reason,
                               a09_custom_type)
                    VALUES (l_log_id, -- a09_id
                            7, -- a09_function_id_m88
                            'CASHBLOCK', -- a09_function_name_m88
                            l_cash_block_request_id, -- a09_request_id
                            101, -- a09_status_id_v01
                            i.status_changed_by_new_id, -- a09_action_by_id_u17
                            i.status_changed_date, -- a09_action_date
                            i.created_by_new_id, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Pending Approve', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;

                IF (i.map01_ntp_id = 7)
                THEN
                    l_log_id := l_log_id + 1;

                    INSERT
                      INTO dfn_ntp.a09_function_approval_log (
                               a09_id,
                               a09_function_id_m88,
                               a09_function_name_m88,
                               a09_request_id,
                               a09_status_id_v01,
                               a09_action_by_id_u17,
                               a09_action_date,
                               a09_created_by_id_u17,
                               a09_created_date,
                               a09_narration,
                               a09_reject_reason,
                               a09_custom_type)
                    VALUES (l_log_id, -- a09_id
                            7, -- a09_function_id_m88
                            'CASHBLOCK', -- a09_function_name_m88
                            l_cash_block_request_id, -- a09_request_id
                            101, -- a09_status_id_v01
                            i.status_changed_by_new_id, -- a09_action_by_id_u17
                            i.status_changed_date, -- a09_action_date
                            i.created_by_new_id, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Pending Approve', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );

                    l_log_id := l_log_id + 1;

                    INSERT
                      INTO dfn_ntp.a09_function_approval_log (
                               a09_id,
                               a09_function_id_m88,
                               a09_function_name_m88,
                               a09_request_id,
                               a09_status_id_v01,
                               a09_action_by_id_u17,
                               a09_action_date,
                               a09_created_by_id_u17,
                               a09_created_date,
                               a09_narration,
                               a09_reject_reason,
                               a09_custom_type)
                    VALUES (l_log_id, -- a09_id
                            7, -- a09_function_id_m88
                            'CASHBLOCK', -- a09_function_name_m88
                            l_cash_block_request_id, -- a09_request_id
                            2, -- a09_status_id_v01
                            i.status_changed_by_new_id, -- a09_action_by_id_u17
                            i.status_changed_date, -- a09_action_date
                            i.created_by_new_id, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Approved', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;
            ELSE
                UPDATE dfn_ntp.t10_cash_block_request
                   SET t10_cash_account_id_u06 = i.new_cash_account_id, -- t10_cash_account_id_u06
                       t10_amount_blocked = i.t77_amount_blocked, -- t10_amount_blocked
                       t10_from_date = i.t77_from_date, -- t10_from_date
                       t10_to_date = i.t77_to_date, -- t10_to_date
                       t10_reason_for_block = i.t77_reason_for_block, -- t10_reason_for_block
                       t10_type = i.t77_type, -- t10_type
                       t10_is_approval_completed = i.approval_completed, -- t10_is_approval_completed
                       t10_current_approval_level = i.current_approval_level, -- t10_current_approval_level
                       t10_next_status = i.next_status, -- t10_next_status
                       t10_status = i.map01_ntp_id, -- t10_status
                       t10_last_updated_date = i.status_changed_date, -- t10_last_updated_date
                       t10_last_updated_by = i.status_changed_by_new_id, -- t10_last_updated_by
                       t10_delete_status = i.delete_status, -- t10_delete_status
                       t10_institute_id_m02 = i.u06_institute_id_m02 -- t10_institute_id_m02
                 WHERE t10_id = i.new_cash_block_req_id;

                IF     i.map01_ntp_id = 1
                   AND i.status_changed_by_new_id IS NOT NULL
                THEN
                    l_log_id := l_log_id + 1;

                    INSERT
                      INTO dfn_ntp.a09_function_approval_log (
                               a09_id,
                               a09_function_id_m88,
                               a09_function_name_m88,
                               a09_request_id,
                               a09_status_id_v01,
                               a09_action_by_id_u17,
                               a09_action_date,
                               a09_created_by_id_u17,
                               a09_created_date,
                               a09_narration,
                               a09_reject_reason,
                               a09_custom_type)
                    VALUES (l_log_id, -- a09_id
                            7, -- a09_function_id_m88
                            'CASHBLOCK', -- a09_function_name_m88
                            i.new_cash_block_req_id, -- a09_request_id
                            1, -- a09_status_id_v01
                            i.status_changed_by_new_id, -- a09_action_by_id_u17
                            i.status_changed_date, -- a09_action_date
                            i.created_by_new_id, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Pending', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;

                IF     i.map01_ntp_id = 101
                   AND i.status_changed_by_new_id IS NOT NULL
                THEN
                    l_log_id := l_log_id + 1;

                    INSERT
                      INTO dfn_ntp.a09_function_approval_log (
                               a09_id,
                               a09_function_id_m88,
                               a09_function_name_m88,
                               a09_request_id,
                               a09_status_id_v01,
                               a09_action_by_id_u17,
                               a09_action_date,
                               a09_created_by_id_u17,
                               a09_created_date,
                               a09_narration,
                               a09_reject_reason,
                               a09_custom_type)
                    VALUES (l_log_id, -- a09_id
                            7, -- a09_function_id_m88
                            'CASHBLOCK', -- a09_function_name_m88
                            i.new_cash_block_req_id, -- a09_request_id
                            101, -- a09_status_id_v01
                            i.status_changed_by_new_id, -- a09_action_by_id_u17
                            i.status_changed_date, -- a09_action_date
                            i.created_by_new_id, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Pending Approve', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;

                IF     i.map01_ntp_id = 3
                   AND i.status_changed_by_new_id IS NOT NULL
                THEN
                    l_log_id := l_log_id + 1;

                    INSERT
                      INTO dfn_ntp.a09_function_approval_log (
                               a09_id,
                               a09_function_id_m88,
                               a09_function_name_m88,
                               a09_request_id,
                               a09_status_id_v01,
                               a09_action_by_id_u17,
                               a09_action_date,
                               a09_created_by_id_u17,
                               a09_created_date,
                               a09_narration,
                               a09_reject_reason,
                               a09_custom_type)
                    VALUES (l_log_id, -- a09_id
                            7, -- a09_function_id_m88
                            'CASHBLOCK', -- a09_function_name_m88
                            i.new_cash_block_req_id, -- a09_request_id
                            5, -- a09_status_id_v01
                            i.status_changed_by_new_id, -- a09_action_by_id_u17
                            i.status_changed_date, -- a09_action_date
                            i.created_by_new_id, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Deleted', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;

                IF     i.map01_ntp_id = 2
                   AND i.status_changed_by_new_id IS NOT NULL
                THEN
                    l_log_id := l_log_id + 1;

                    INSERT
                      INTO dfn_ntp.a09_function_approval_log (
                               a09_id,
                               a09_function_id_m88,
                               a09_function_name_m88,
                               a09_request_id,
                               a09_status_id_v01,
                               a09_action_by_id_u17,
                               a09_action_date,
                               a09_created_by_id_u17,
                               a09_created_date,
                               a09_narration,
                               a09_reject_reason,
                               a09_custom_type)
                    VALUES (l_log_id, -- a09_id
                            7, -- a09_function_id_m88
                            'CASHBLOCK', -- a09_function_name_m88
                            i.new_cash_block_req_id, -- a09_request_id
                            2, -- a09_status_id_v01
                            i.status_changed_by_new_id, -- a09_action_by_id_u17
                            i.status_changed_date, -- a09_action_date
                            i.created_by_new_id, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Approved', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T10_CASH_BLOCK_REQUEST',
                                i.t77_id,
                                CASE
                                    WHEN i.new_cash_block_req_id IS NULL
                                    THEN
                                        l_cash_block_request_id
                                    ELSE
                                        i.new_cash_block_req_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cash_block_req_id IS NULL
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