DECLARE
    l_broker_id                  NUMBER;
    l_primary_institute_id       NUMBER;
    l_authorization_request_id   NUMBER;
    l_log_id                     NUMBER;
    l_sqlerrm                    VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (t15_id), 0)
      INTO l_authorization_request_id
      FROM dfn_ntp.t15_authorization_request;

    SELECT NVL (MAX (a09_id), 0)
      INTO l_log_id
      FROM dfn_ntp.a09_function_approval_log;

    DELETE FROM error_log
          WHERE mig_table = 'T15_AUTHORIZATION_REQUEST';

    FOR i
        IN (SELECT t87.t87_id,
                   u07_map.new_trading_account_id,
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
                       WHEN map01.map01_ntp_id = 6 THEN 102
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
                   u07.u07_cash_account_id_u06,
                   t87.t87_member_code,
                   u07.u07_customer_id_u01,
                   m110.m110_reason_text,
                   t87.t87_sent_to_exchange, -- [SAME IDs]
                   t87.t87_reject_reason,
                   t87.t87_approved_reason,
                   t87.t87_remarks,
                   u07.u07_exchange_account_no,
                   map01_original.map01_ntp_id AS original_status_id,
                   t15_map.new_auth_request_id
              FROM mubasher_oms.t87_authorization_request@mubasher_db_link t87,
                   map01_approval_status_v01 map01,
                   map16_optional_exchanges_m01 map16,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   u07_trading_account_mappings u07_map,
                   dfn_ntp.u07_trading_account u07,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_l1_by,
                   u17_employee_mappings u17_l2_by,
                   u17_employee_mappings u17_rejected_by,
                   m110_reasons_mappings m110_map,
                   dfn_ntp.m110_reasons m110,
                   map01_approval_status_v01 map01_original,
                   t15_auth_request_mappings t15_map
             WHERE     t87.t87_status_id = map01.map01_oms_id
                   AND t87.t87_u06_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, t87.t87_u06_exchange) =
                           m01.m01_exchange_code(+)
                   AND t87.t87_u06_security_ac_id =
                           u07_map.old_trading_account_id(+)
                   AND NVL (map16.map16_ntp_code, t87.t87_u06_exchange) =
                           u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id = u07.u07_id(+)
                   AND t87.t87_created_by = u17_created.old_employee_id(+)
                   AND t87.t87_l1_approved_by = u17_l1_by.old_employee_id(+)
                   AND t87.t87_l2_approved_by = u17_l2_by.old_employee_id(+)
                   AND t87.t87_rejected_by =
                           u17_rejected_by.old_employee_id(+)
                   AND t87.t87_closure_reason_id = m110_map.old_reasons_id(+)
                   AND u07.u07_institute_id_m02 =
                           m110_map.new_institute_id(+)
                   AND m110_map.new_reasons_id = m110.m110_id(+)
                   AND t87.t87_acc_org_status =
                           map01_original.map01_oms_id(+)
                   AND t87.t87_id = t15_map.old_auth_request_id(+))
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

            IF i.u07_cash_account_id_u06 IS NULL
            THEN
                raise_application_error (-20001,
                                         'Cash Account Not Available',
                                         TRUE);
            END IF;

            IF i.u07_customer_id_u01 IS NULL
            THEN
                raise_application_error (-20001,
                                         'Customer Not Available',
                                         TRUE);
            END IF;

            IF i.new_auth_request_id IS NULL
            THEN
                l_authorization_request_id := l_authorization_request_id + 1;

                INSERT
                  INTO dfn_ntp.t15_authorization_request (
                           t15_id,
                           t15_cash_account_id_u06,
                           t15_exchange_id_m01,
                           t15_trading_account_id_u07,
                           t15_member_code,
                           t15_customer_id_u01,
                           t15_closure_reason,
                           t15_sent_to_exchange,
                           t15_reject_reason,
                           t15_approved_reason,
                           t15_no_of_approval,
                           t15_is_approval_completed,
                           t15_current_approval_level,
                           t15_next_status,
                           t15_created_date,
                           t15_last_updated_date,
                           t15_status_id_v01,
                           t15_comment,
                           t15_created_by_id_u17,
                           t15_last_updated_by_id_u17,
                           t15_acc_org_status_id_v01,
                           t15_exchange_account_no,
                           t15_custom_type)
                VALUES (l_authorization_request_id, -- t15_id
                        i.u07_cash_account_id_u06, -- t15_cash_account_id_u06
                        i.m01_id, -- t15_exchange_id_m01
                        i.new_trading_account_id, -- t15_trading_account_id_u07
                        i.t87_member_code, -- t15_member_code
                        i.u07_customer_id_u01, -- t15_customer_id_u01
                        i.m110_reason_text, -- t15_closure_reason
                        i.t87_sent_to_exchange, -- t15_sent_to_exchange
                        i.t87_reject_reason, -- t15_reject_reason
                        i.t87_approved_reason, -- t15_approved_reason
                        2, -- t15_no_of_approval
                        i.approval_completed, -- t15_is_approval_completed
                        i.current_approval_level, -- t15_current_approval_level
                        i.next_status, -- t15_next_status
                        i.created_date, -- t15_created_date
                        i.last_updated_date, -- t15_last_updated_date
                        i.map01_ntp_id, -- t15_status_id_v01
                        i.t87_remarks, -- t15_comment
                        i.created_by_new_id, -- t15_created_by_id_u17
                        i.last_updated_by_new_id, -- t15_last_updated_by_id_u17
                        i.original_status_id, -- t15_acc_org_status_id_v01
                        i.u07_exchange_account_no, -- t15_exchange_account_no
                        '1' -- t15_custom_type
                           );

                INSERT INTO dfn_mig.t15_auth_request_mappings
                     VALUES (i.t87_id, l_authorization_request_id);

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
                            9, -- a09_function_id_m88
                            'ACCOUNTCLOSURE', -- a09_function_name_m88
                            l_authorization_request_id, -- a09_request_id
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
                            9, -- a09_function_id_m88
                            'ACCOUNTCLOSURE', -- a09_function_name_m88
                            l_authorization_request_id, -- a09_request_id
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
                            9, -- a09_function_id_m88
                            'ACCOUNTCLOSURE', -- a09_function_name_m88
                            l_authorization_request_id, -- a09_request_id
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
                            9, -- a09_function_id_m88
                            'ACCOUNTCLOSURE', -- a09_function_name_m88
                            l_authorization_request_id, -- a09_request_id
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
                UPDATE dfn_ntp.t15_authorization_request
                   SET t15_cash_account_id_u06 = i.u07_cash_account_id_u06, -- t15_cash_account_id_u06
                       t15_exchange_id_m01 = i.m01_id, -- t15_exchange_id_m01
                       t15_trading_account_id_u07 = i.new_trading_account_id, -- t15_trading_account_id_u07
                       t15_member_code = i.t87_member_code, -- t15_member_code
                       t15_customer_id_u01 = i.u07_customer_id_u01, -- t15_customer_id_u01
                       t15_closure_reason = i.m110_reason_text, -- t15_closure_reason
                       t15_sent_to_exchange = i.t87_sent_to_exchange, -- t15_sent_to_exchange
                       t15_reject_reason = i.t87_reject_reason, -- t15_reject_reason
                       t15_approved_reason = i.t87_approved_reason, -- t15_approved_reason
                       t15_is_approval_completed = i.approval_completed, -- t15_is_approval_completed
                       t15_current_approval_level = i.current_approval_level, -- t15_current_approval_level
                       t15_next_status = i.next_status, -- t15_next_status
                       t15_last_updated_date = i.last_updated_date, -- t15_last_updated_date
                       t15_status_id_v01 = i.map01_ntp_id, -- t15_status_id_v01
                       t15_comment = i.t87_remarks, -- t15_comment
                       t15_last_updated_by_id_u17 = i.last_updated_by_new_id, -- t15_last_updated_by_id_u17
                       t15_acc_org_status_id_v01 = i.original_status_id, -- t15_acc_org_status_id_v01
                       t15_exchange_account_no = i.u07_exchange_account_no -- t15_exchange_account_no
                 WHERE t15_id = i.new_auth_request_id;


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
                            9, -- a09_function_id_m88
                            'ACCOUNTCLOSURE', -- a09_function_name_m88
                            l_authorization_request_id, -- a09_request_id
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
                            9, -- a09_function_id_m88
                            'ACCOUNTCLOSURE', -- a09_function_name_m88
                            l_authorization_request_id, -- a09_request_id
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
                            9, -- a09_function_id_m88
                            'ACCOUNTCLOSURE', -- a09_function_name_m88
                            l_authorization_request_id, -- a09_request_id
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
                            9, -- a09_function_id_m88
                            'ACCOUNTCLOSURE', -- a09_function_name_m88
                            l_authorization_request_id, -- a09_request_id
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
                                'T15_AUTHORIZATION_REQUEST',
                                i.t87_id,
                                CASE
                                    WHEN i.new_auth_request_id IS NULL
                                    THEN
                                        l_authorization_request_id
                                    ELSE
                                        i.new_auth_request_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_auth_request_id IS NULL
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