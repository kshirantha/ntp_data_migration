DECLARE
    l_od_withdraw_limit_id   NUMBER;
    l_log_id                 NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t08_id), 0)
      INTO l_od_withdraw_limit_id
      FROM dfn_ntp.t08_od_withdraw_limit;

    SELECT NVL (MAX (a09_id), 0)
      INTO l_log_id
      FROM dfn_ntp.a09_function_approval_log;

    DELETE FROM error_log
          WHERE mig_table = 'T08_OD_WITHDRAW_LIMIT';

    FOR i
        IN (  SELECT t16.t16_id,
                     t16.t16_cash_ac_id,
                     t16.t16_amount,
                     t16.t16_trd_lmt_primary_expiry,
                     t16.t16_trd_lmt_secondary,
                     t16.t16_trd_lmt_secondary_expiry,
                     CASE WHEN map01.map01_ntp_id IN (3, 7) THEN 1 ELSE 0 END
                         AS approval_completed,
                     CASE
                         WHEN map01.map01_ntp_id IN (3, 7) THEN 2
                         WHEN map01.map01_ntp_id = 6 THEN 1
                         ELSE 0
                     END
                         AS current_approval_level,
                     CASE
                         WHEN map01.map01_ntp_id = 7 THEN 2
                         WHEN map01.map01_ntp_id = 3 THEN 3
                         WHEN map01.map01_ntp_id = 101 THEN 102
                         WHEN map01.map01_ntp_id = 1 THEN 101
                     END
                         AS next_status,
                     map01.map01_ntp_id,
                     NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                     t16.t16_date AS created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                     u17_l1_by.new_employee_id AS l1_by_new_id,
                     t16.t16_approved1_date AS l1_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                     u17_l2_by.new_employee_id AS l2_by_new_id,
                     t16.t16_approved2_date AS l2_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                     u17_rejected_by.new_employee_id AS rejected_by_new_id,
                     t16.t16_rejected_date AS rejected_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                     u06.u06_institute_id_m02,
                     t08_map.new_od_withdraw_limit_id,
                     CASE
                         WHEN u17_rejected_by.new_employee_id IS NOT NULL
                         THEN
                             u17_rejected_by.new_employee_id
                         WHEN u17_l2_by.new_employee_id IS NOT NULL
                         THEN
                             u17_l2_by.new_employee_id
                         WHEN u17_l1_by.new_employee_id IS NOT NULL
                         THEN
                             u17_l1_by.new_employee_id
                         ELSE
                             u17_created.new_employee_id
                     END
                         AS last_updated_by_new_id,
                     CASE
                         WHEN t16.t16_rejected_date IS NOT NULL
                         THEN
                             t16_rejected_date
                         WHEN t16.t16_approved2_date IS NOT NULL
                         THEN
                             t16_approved2_date
                         WHEN t16.t16_approved1_date IS NOT NULL
                         THEN
                             t16_approved1_date
                         ELSE
                             t16_date
                     END
                         AS last_updated_date -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                FROM mubasher_oms.t16_pending_od@mubasher_db_link t16,
                     map01_approval_status_v01 map01,
                     u06_cash_account_mappings u06_mapping,
                     dfn_ntp.u06_cash_account u06,
                     u17_employee_mappings u17_created,
                     u17_employee_mappings u17_l1_by,
                     u17_employee_mappings u17_l2_by,
                     u17_employee_mappings u17_rejected_by,
                     t08_od_withdraw_limit_mappings t08_map
               WHERE     t16.t16_status = map01.map01_oms_id
                     AND t16.t16_cash_ac_id = u06_mapping.old_cash_account_id
                     AND u06_mapping.new_cash_account_id = u06.u06_id
                     AND t16.t16_entered_by = u17_created.old_employee_id(+)
                     AND t16.t16_approved1_by = u17_l1_by.old_employee_id(+)
                     AND t16.t16_approved2_by = u17_l2_by.old_employee_id(+)
                     AND t16.t16_rejected_by =
                             u17_rejected_by.old_employee_id(+)
                     AND t16.t16_id = t08_map.old_od_withdraw_limit_id(+)
            ORDER BY t16.t16_id)
    LOOP
        BEGIN
            IF i.new_od_withdraw_limit_id IS NULL
            THEN
                l_od_withdraw_limit_id := l_od_withdraw_limit_id + 1;

                INSERT
                  INTO dfn_ntp.t08_od_withdraw_limit (
                           t08_id,
                           t08_cash_account_id_u06,
                           t08_primary_od_limit,
                           t08_primary_start,
                           t08_primary_expiry,
                           t08_secondary_od_limit,
                           t08_secondary_start,
                           t08_secondary_expiry,
                           t08_no_of_approval,
                           t08_is_approval_completed,
                           t08_current_approval_level,
                           t08_next_status,
                           t08_created_date,
                           t08_last_updated_date,
                           t08_status_id_v01,
                           t08_comment,
                           t08_created_by_id_u17,
                           t08_last_updated_by_id_u17,
                           t08_custom_type,
                           t08_institute_id_m02)
                VALUES (l_od_withdraw_limit_id, -- t08_id
                        i.t16_cash_ac_id, -- t08_cash_account_id_u06
                        i.t16_amount, -- t08_primary_od_limit
                        i.created_date, -- t08_primary_start
                        i.t16_trd_lmt_primary_expiry, -- t08_primary_expiry
                        i.t16_trd_lmt_secondary, -- t08_secondary_od_limit
                        i.created_date, -- t08_secondary_start
                        i.t16_trd_lmt_secondary_expiry, -- t08_secondary_expiry
                        2, -- t08_no_of_approval
                        i.approval_completed, -- t08_is_approval_completed
                        i.current_approval_level, --  t08_current_approval_level
                        i.next_status, --t08_next_status
                        i.created_date, -- t08_created_date
                        i.last_updated_date, -- t08_last_updated_date
                        i.map01_ntp_id, -- t08_status_id_v01
                        NULL, -- t08_comment
                        i.created_by_new_id, -- t08_created_by_id_u17
                        i.last_updated_by_new_id, -- t08_last_updated_by_id_u17
                        '1', -- t08_custom_type
                        i.u06_institute_id_m02 -- t08_institute_id_m02
                                              );

                INSERT INTO t08_od_withdraw_limit_mappings
                     VALUES (i.t16_id, l_od_withdraw_limit_id);

                IF i.created_by_new_id IS NOT NULL
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
                            4, -- a09_function_id_m88
                            'ODWITHDRAW', -- a09_function_name_m88
                            l_od_withdraw_limit_id, -- a09_request_id
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

                IF i.l1_by_new_id IS NOT NULL
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
                            4, -- a09_function_id_m88
                            'ODWITHDRAW', -- a09_function_name_m88
                            l_od_withdraw_limit_id, -- a09_request_id
                            101, -- a09_status_id_v01
                            i.l1_by_new_id, -- a09_action_by_id_u17
                            i.l1_date, -- a09_action_date
                            i.created_by_new_id, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Pending Approve', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;

                IF i.l2_by_new_id IS NOT NULL
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
                            4, -- a09_function_id_m88
                            'ODWITHDRAW', -- a09_function_name_m88
                            l_od_withdraw_limit_id, -- a09_request_id
                            2, -- a09_status_id_v01
                            i.l2_by_new_id, -- a09_action_by_id_u17
                            i.l2_date, -- a09_action_date
                            i.created_by_new_id, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Approved', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;

                IF i.rejected_by_new_id IS NOT NULL
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
                            4, -- a09_function_id_m88
                            'ODWITHDRAW', -- a09_function_name_m88
                            l_od_withdraw_limit_id, -- a09_request_id
                            3, -- a09_status_id_v01
                            i.rejected_by_new_id, -- a09_action_by_id_u17
                            i.rejected_date, -- a09_action_date
                            i.created_by_new_id, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Rejected', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;
            ELSE
                UPDATE dfn_ntp.t08_od_withdraw_limit
                   SET t08_cash_account_id_u06 = i.t16_cash_ac_id, -- t08_cash_account_id_u06
                       t08_primary_od_limit = i.t16_amount, -- t08_primary_od_limit
                       t08_primary_start = i.created_date, -- t08_primary_start
                       t08_primary_expiry = i.t16_trd_lmt_primary_expiry, -- t08_primary_expiry
                       t08_secondary_od_limit = i.t16_trd_lmt_secondary, -- t08_secondary_od_limit
                       t08_secondary_start = i.created_date, -- t08_secondary_start
                       t08_secondary_expiry = i.t16_trd_lmt_secondary_expiry, -- t08_secondary_expiry
                       t08_is_approval_completed = i.approval_completed, -- t08_is_approval_completed
                       t08_current_approval_level = i.current_approval_level, --  t08_current_approval_level
                       t08_next_status = i.next_status, --t08_next_status
                       t08_last_updated_date = i.last_updated_date, -- t08_last_updated_date
                       t08_status_id_v01 = i.map01_ntp_id, -- t08_status_id_v01
                       t08_last_updated_by_id_u17 = i.last_updated_by_new_id, -- t08_last_updated_by_id_u17
                       t08_institute_id_m02 = i.u06_institute_id_m02 -- t08_institute_id_m02
                 WHERE t08_id = i.new_od_withdraw_limit_id;

                IF i.map01_ntp_id = 1 AND i.l1_by_new_id IS NOT NULL
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
                            4, -- a09_function_id_m88
                            'ODWITHDRAW', -- a09_function_name_m88
                            i.new_od_withdraw_limit_id, -- a09_request_id
                            1, -- a09_status_id_v01
                            i.l1_by_new_id, -- a09_action_by_id_u17
                            i.l1_date, -- a09_action_date
                            i.created_by_new_id, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Pending', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;

                IF i.map01_ntp_id = 101 AND i.l1_by_new_id IS NOT NULL
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
                            4, -- a09_function_id_m88
                            'ODWITHDRAW', -- a09_function_name_m88
                            i.new_od_withdraw_limit_id, -- a09_request_id
                            101, -- a09_status_id_v01
                            i.l1_by_new_id, -- a09_action_by_id_u17
                            i.l1_date, -- a09_action_date
                            i.created_by_new_id, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Pending Approve', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;

                IF i.map01_ntp_id = 3 AND i.rejected_by_new_id IS NOT NULL
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
                            4, -- a09_function_id_m88
                            'ODWITHDRAW', -- a09_function_name_m88
                            i.new_od_withdraw_limit_id, -- a09_request_id
                            3, -- a09_status_id_v01
                            i.rejected_by_new_id, -- a09_action_by_id_u17
                            i.rejected_date, -- a09_action_date
                            i.created_by_new_id, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Rejected', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;

                IF i.map01_ntp_id = 2 AND i.l2_by_new_id IS NOT NULL
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
                            4, -- a09_function_id_m88
                            'ODWITHDRAW', -- a09_function_name_m88
                            i.new_od_withdraw_limit_id, -- a09_request_id
                            2, -- a09_status_id_v01
                            i.l2_by_new_id, -- a09_action_by_id_u17
                            i.l2_date, -- a09_action_date
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
                                'T08_OD_WITHDRAW_LIMIT',
                                i.t16_id,
                                CASE
                                    WHEN i.new_od_withdraw_limit_id IS NULL
                                    THEN
                                        l_od_withdraw_limit_id
                                    ELSE
                                        i.new_od_withdraw_limit_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_od_withdraw_limit_id IS NULL
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
