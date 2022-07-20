DECLARE
    l_broker_id                NUMBER;
    l_primary_institute_id     NUMBER;
    l_disable_exg_acc_req_id   NUMBER;
    l_log_id                   NUMBER;
    l_sqlerrm                  VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (t04_id), 0)
      INTO l_disable_exg_acc_req_id
      FROM dfn_ntp.t04_disable_exchange_acc_req;

    SELECT NVL (MAX (a09_id), 0)
      INTO l_log_id
      FROM dfn_ntp.a09_function_approval_log;

    DELETE FROM error_log
          WHERE mig_table = 'T04_DISABLE_EXCHANGE_ACC_REQ';

    FOR i
        IN (SELECT t87.t87_id,
                   u07_map.new_trading_account_id,
                   NVL (map16.map16_ntp_code, t87.t87_u06_exchange)
                       AS exchange_code,
                   CASE WHEN map01.map01_ntp_id IN (3, 7) THEN 1 ELSE 0 END
                       AS approval_completed,
                   CASE
                       WHEN map01.map01_ntp_id IN (3, 7) THEN 2
                       WHEN map01.map01_ntp_id = 6 THEN 1
                       ELSE 0
                   END
                       AS current_approval_level,
                   CASE
                       WHEN map01.map01_ntp_id = 3 THEN 3
                       WHEN map01.map01_ntp_id = 101 THEN 102
                       WHEN map01.map01_ntp_id = 1 THEN 101
                       ELSE 101
                   END
                       AS next_status,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   t87.t87_created_date AS created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   u17_l1_by.new_employee_id AS l1_by_new_id,
                   t87.t87_l1_approved_date AS l1_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   u17_l2_by.new_employee_id AS l2_by_new_id,
                   t87.t87_l2_approved_date AS l2_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   u17_rejected_by.new_employee_id AS rejected_by_new_id,
                   t87.t87_rejected_date AS rejected_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
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
                       WHEN t87.t87_rejected_date IS NOT NULL
                       THEN
                           t87_rejected_date
                       WHEN t87.t87_l2_approved_date IS NOT NULL
                       THEN
                           t87_l2_approved_date
                       WHEN t87.t87_l1_approved_date IS NOT NULL
                       THEN
                           t87_l1_approved_date
                       ELSE
                           t87.t87_created_date
                   END
                       AS last_updated_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   map01.map01_ntp_id,
                   m01.m01_id,
                   u07.u07_institute_id_m02,
                   t04_map.new_dis_exg_acc_req_id
              FROM mubasher_oms.t87_authorization_request@mubasher_db_link t87,
                   map01_approval_status_v01 map01,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   map16_optional_exchanges_m01 map16,
                   u07_trading_account_mappings u07_map,
                   dfn_ntp.u07_trading_account u07,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_l1_by,
                   u17_employee_mappings u17_l2_by,
                   u17_employee_mappings u17_rejected_by,
                   t04_dis_exg_acc_req_mappings t04_map
             WHERE     t87.t87_status_id = map01.map01_oms_id
                   AND m01.m01_exchange_code = t87.t87_u06_exchange
                   AND t87.t87_u06_security_ac_id =
                           u07_map.old_trading_account_id(+)
                   AND t87.t87_u06_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, t87.t87_u06_exchange) =
                           u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id = u07.u07_id(+)
                   AND t87.t87_created_by = u17_created.old_employee_id(+)
                   AND t87.t87_l1_approved_by = u17_l1_by.old_employee_id(+)
                   AND t87.t87_l2_approved_by = u17_l2_by.old_employee_id(+)
                   AND t87.t87_rejected_by =
                           u17_rejected_by.old_employee_id(+)
                   AND t87.t87_id = t04_map.old_dis_exg_acc_req_id(+))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.new_trading_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Trading Account Not Available',
                                         TRUE);
            END IF;

            IF i.new_dis_exg_acc_req_id IS NULL
            THEN
                l_disable_exg_acc_req_id := l_disable_exg_acc_req_id + 1;

                INSERT
                  INTO dfn_ntp.t04_disable_exchange_acc_req (
                           t04_id,
                           t04_trading_acc_id_u07,
                           t04_exchange_code_m01,
                           t04_no_of_approval,
                           t04_is_approval_completed,
                           t04_current_approval_level,
                           t04_next_status,
                           t04_created_date,
                           t04_last_updated_date,
                           t04_status_id_v01,
                           t04_created_by_id_u17,
                           t04_last_updated_by_id_u17,
                           t04_reject_reason,
                           t04_approved_reason,
                           t04_reason,
                           t04_custom_type,
                           t04_institute_id_m02,
                           t04_exchange_id_m01)
                VALUES (l_disable_exg_acc_req_id, -- t04_id
                        i.new_trading_account_id, -- t04_trading_acc_id_u07
                        i.exchange_code, -- t04_exchange_code_m01
                        2, -- t04_no_of_approval
                        i.approval_completed, -- t04_is_approval_completed
                        i.current_approval_level, -- t04_current_approval_level
                        i.next_status, -- t04_next_status
                        i.created_date, -- t04_created_date
                        i.last_updated_date, -- t04_last_updated_date
                        i.map01_ntp_id, -- t04_status_id_v01
                        i.created_by_new_id, -- t04_created_by_id_u17
                        i.last_updated_by_new_id, -- t04_last_updated_by_id_u17
                        NULL, -- t04_reject_reason
                        NULL, -- t04_approved_reason
                        NULL, -- t04_reason
                        '1', -- t04_custom_type
                        i.u07_institute_id_m02, -- t04_institute_id_m02
                        i.m01_id -- t04_exchange_id_m01
                                );

                INSERT INTO dfn_mig.t04_dis_exg_acc_req_mappings
                     VALUES (i.t87_id, l_disable_exg_acc_req_id);

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
                            19, -- a09_function_id_m88
                            'DISABLE_EXCHANGE_ACCOUNT', -- a09_function_name_m88
                            l_disable_exg_acc_req_id, -- a09_request_id
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
                            19, -- a09_function_id_m88
                            'DISABLE_EXCHANGE_ACCOUNT', -- a09_function_name_m88
                            l_disable_exg_acc_req_id, -- a09_request_id
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
                            19, -- a09_function_id_m88
                            'DISABLE_EXCHANGE_ACCOUNT', -- a09_function_name_m88
                            l_disable_exg_acc_req_id, -- a09_request_id
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
                            19, -- a09_function_id_m88
                            'DISABLE_EXCHANGE_ACCOUNT', -- a09_function_name_m88
                            l_disable_exg_acc_req_id, -- a09_request_id
                            3, -- a09_status_id_v01
                            i.rejected_by_new_id, -- a09_action_by_id_u17
                            i.rejected_date, -- a09_action_date
                            i.created_by_new_id, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Rejected', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                ELSE
                    UPDATE dfn_ntp.t04_disable_exchange_acc_req
                       SET t04_trading_acc_id_u07 = i.new_trading_account_id, -- t04_trading_acc_id_u07
                           t04_exchange_code_m01 = i.exchange_code, -- t04_exchange_code_m01
                           t04_is_approval_completed = i.approval_completed, -- t04_is_approval_completed
                           t04_current_approval_level =
                               i.current_approval_level, -- t04_current_approval_level
                           t04_next_status = i.next_status, -- t04_next_status
                           t04_last_updated_date = i.last_updated_date, -- t04_last_updated_date
                           t04_status_id_v01 = i.map01_ntp_id, -- t04_status_id_v01
                           t04_last_updated_by_id_u17 =
                               NVL (i.last_updated_by_new_id, 0), -- t04_last_updated_by_id_u17
                           t04_institute_id_m02 = i.u07_institute_id_m02, -- t04_institute_id_m02
                           t04_exchange_id_m01 = i.m01_id -- t04_exchange_id_m01
                     WHERE t04_id = i.new_dis_exg_acc_req_id;

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
                                19, -- a09_function_id_m88
                                'DISABLE_EXCHANGE_ACCOUNT', -- a09_function_name_m88
                                i.new_dis_exg_acc_req_id, -- a09_request_id
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
                                19, -- a09_function_id_m88
                                'DISABLE_EXCHANGE_ACCOUNT', -- a09_function_name_m88
                                i.new_dis_exg_acc_req_id, -- a09_request_id
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

                    IF     i.map01_ntp_id = 3
                       AND i.rejected_by_new_id IS NOT NULL
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
                                19, -- a09_function_id_m88
                                'DISABLE_EXCHANGE_ACCOUNT', -- a09_function_name_m88
                                i.new_dis_exg_acc_req_id, -- a09_request_id
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
                                19, -- a09_function_id_m88
                                'DISABLE_EXCHANGE_ACCOUNT', -- a09_function_name_m88
                                i.new_dis_exg_acc_req_id, -- a09_request_id
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
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T04_DISABLE_EXCHANGE_ACC_REQ',
                                i.t87_id,
                                CASE
                                    WHEN i.new_dis_exg_acc_req_id IS NULL
                                    THEN
                                        l_disable_exg_acc_req_id
                                    ELSE
                                        i.new_dis_exg_acc_req_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_dis_exg_acc_req_id IS NULL
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