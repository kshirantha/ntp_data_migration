DECLARE
    l_cust_marg_req_id   NUMBER;
    l_log_id             NUMBER;
BEGIN
    SELECT NVL (MAX (t24_id), 0)
      INTO l_cust_marg_req_id
      FROM dfn_ntp.t24_customer_margin_request;

    DELETE FROM error_log
          WHERE mig_table = 'T24_CUSTOMER_MARGIN_REQUEST';

    FOR i
        IN (SELECT m192_id,
                   u23_map.new_cust_margin_prod_id,
                   u01_map.new_customer_id,
                   u06_map.new_cash_account_id,
                   m73_map.new_margin_products_id,
                   m74_map.new_margin_int_group_id,
                   m192_u23_max_margin_limit,
                   m03.m03_id,
                   m03.m03_code,
                   m192_u23_margin_expiry_date,
                   m192_u23_margin_call_level_1,
                   m192_u23_margin_call_level_2,
                   m192_u23_liquidation_level,
                   m77_map.new_symbol_margin_grp_id,
                   m192_u23_init_margin_percentag,
                   CASE WHEN map01.map01_ntp_id IN (3, 7) THEN 1 ELSE 0 END
                       AS approval_completed,
                   CASE
                       WHEN map01.map01_ntp_id = 7 THEN 2
                       WHEN map01.map01_ntp_id = 3 THEN 2
                       WHEN map01.map01_ntp_id = 101 THEN 1
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
                   map01.map01_ntp_id,
                   u06.u06_institute_id_m02,
                   u17_rejected_by.new_employee_id AS rejected_by_new_id,
                   m192.m192_rejected_date AS rejected_date,
                   NVL (u17_created_by.new_employee_id, 0)
                       AS created_by_new_id,
                   m192.m192_created_date AS created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   NVL (u17_l1_by.new_employee_id, 0) AS l1_by_new_id,
                   m192.m192_l1_approved_date AS l1_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   NVL (u17_l2_by.new_employee_id, 0) AS l2_by_new_id,
                   m192.m192_l2_approved_date AS l2_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   t24_map.new_cust_margin_req_id,
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
                           u17_created_by.new_employee_id
                   END
                       AS last_updated_by_new_id,
                   CASE
                       WHEN m192.m192_rejected_date IS NOT NULL
                       THEN
                           m192.m192_rejected_date
                       WHEN m192.m192_l2_approved_date IS NOT NULL
                       THEN
                           m192.m192_l2_approved_date
                       WHEN m192.m192_l1_approved_date IS NOT NULL
                       THEN
                           m192.m192_l1_approved_date
                       ELSE
                           m192.m192_created_date
                   END
                       AS last_updated_date -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
              FROM mubasher_oms.m192_cust_margin_changes@mubasher_db_link m192,
                   map01_approval_status_v01 map01,
                   u23_cust_margin_prod_mappings u23_map,
                   u01_customer_mappings u01_map,
                   u06_cash_account_mappings u06_map,
                   dfn_ntp.u06_cash_account u06,
                   m73_margin_products_mappings m73_map,
                   m74_margin_int_group_mappings m74_map,
                   dfn_ntp.m03_currency m03,
                   m77_symbol_margin_grp_mappings m77_map,
                   u17_employee_mappings u17_created_by,
                   u17_employee_mappings u17_rejected_by,
                   u17_employee_mappings u17_l1_by,
                   u17_employee_mappings u17_l2_by,
                   t24_cust_margin_req_mappings t24_map
             WHERE     m192.m192_status_id = map01.map01_oms_id
                   AND m192.m192_cust_margin_product =
                           u23_map.old_cust_margin_prod_id
                   AND m192.m192_customer_id = u01_map.old_customer_id
                   AND m192.m192_cash_account_id =
                           u06_map.old_cash_account_id
                   AND u06_map.new_cash_account_id = u06.u06_id
                   AND m192.m192_u23_margin_product =
                           m73_map.old_margin_products_id
                   AND m192.m192_u23_margin_interst_index =
                           m74_map.old_margin_int_group_id
                   AND m192.m192_u23_max_margin_limit_cur = m03.m03_code
                   AND m192.m192_u23_sym_margin_group =
                           m77_map.old_symbol_margin_grp_id
                   AND m192.m192_created_by =
                           u17_created_by.old_employee_id(+)
                   AND m192.m192_rejected_by =
                           u17_rejected_by.old_employee_id(+)
                   AND m192.m192_l1_approved_by =
                           u17_l1_by.old_employee_id(+)
                   AND m192.m192_l2_approved_by =
                           u17_l2_by.old_employee_id(+)
                   AND m192.m192_id = t24_map.old_cust_margin_req_id(+))
    LOOP
        BEGIN
            IF i.new_cust_margin_req_id IS NULL
            THEN
                l_cust_marg_req_id := l_cust_marg_req_id + 1;

                INSERT INTO t24_cust_margin_req_mappings
                     VALUES (i.m192_id, l_cust_marg_req_id);

                INSERT
                  INTO dfn_ntp.t24_customer_margin_request (
                           t24_id,
                           t24_cust_margin_product_id_u23,
                           t24_customer_id_u01,
                           t24_default_cash_acc_id_u06,
                           t24_margin_products_id_m73,
                           t24_interest_group_id_m74,
                           t24_max_margin_limit,
                           t24_max_limit_curr_id_m03,
                           t24_max_limit_curr_code_m03,
                           t24_margin_expiry_date,
                           t24_margin_call_level_1,
                           t24_margin_call_level_2,
                           t24_liquidation_level,
                           t24_symbol_margnblty_grps_m77,
                           t24_stock_conctrn_group_id_m75,
                           t24_borrowers_name,
                           t24_margin_percentage,
                           t24_no_of_approval,
                           t24_is_approval_completed,
                           t24_current_approval_level,
                           t24_next_status,
                           t24_created_date,
                           t24_last_updated_date,
                           t24_status_id_v01,
                           t24_comment,
                           t24_created_by_id_u17,
                           t24_last_updated_by_id_u17,
                           t24_other_cash_acc_ids_u06,
                           t24_restore_level,
                           t24_exempt_liquidation,
                           t24_custom_type,
                           t24_request_action,
                           t24_institute_id_m02)
                VALUES (l_cust_marg_req_id, -- t24_id
                        i.new_cust_margin_prod_id, -- t24_cust_margin_product_id_u23
                        i.new_customer_id, -- t24_customer_id_u01
                        i.new_cash_account_id, -- t24_default_cash_acc_id_u06
                        i.new_margin_products_id, -- t24_margin_products_id_m73
                        i.new_margin_int_group_id, -- t24_interest_group_id_m74
                        i.m192_u23_max_margin_limit, -- t24_max_margin_limit
                        i.m03_id, -- t24_max_limit_curr_id_m03
                        i.m03_code, -- t24_max_limit_curr_code_m03
                        i.m192_u23_margin_expiry_date, -- t24_margin_expiry_date
                        i.m192_u23_margin_call_level_1, -- t24_margin_call_level_1
                        i.m192_u23_margin_call_level_2, -- t24_margin_call_level_2
                        i.m192_u23_liquidation_level, -- t24_liquidation_level
                        i.new_symbol_margin_grp_id, -- t24_symbol_margnblty_grps_m77
                        NULL, -- t24_stock_conctrn_group_id_m75 | Not Available for AUDI
                        NULL, -- t24_borrowers_name | Not Available for AUDI
                        i.m192_u23_init_margin_percentag, -- t24_margin_percentage
                        2, -- t24_no_of_approval
                        i.approval_completed, -- t24_is_approval_completed
                        i.current_approval_level, -- t24_current_approval_level
                        i.next_status, -- t24_next_status
                        i.created_date, -- t24_created_date
                        i.last_updated_date, -- t24_last_updated_date
                        i.map01_ntp_id, -- t24_status_id_v01
                        NULL, -- t24_comment
                        i.created_by_new_id, -- t24_created_by_id_u17
                        i.last_updated_by_new_id, -- t24_last_updated_by_id_u17
                        NULL, -- t24_other_cash_acc_ids_u06 | Not Available
                        i.m192_u23_margin_call_level_2, -- t24_restore_level | In Case Topup Amount Not Available
                        0, -- t24_exempt_liquidation
                        '1', -- t24_custom_type
                        NULL, -- t24_request_action
                        i.u06_institute_id_m02 -- t24_institute_id_m02
                                              );

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
                            17, -- a09_function_id_m88
                            'CUSTOMER_MARGIN', -- a09_function_name_m88
                            l_cust_marg_req_id, -- a09_request_id
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
                            17, -- a09_function_id_m88
                            'CUSTOMER_MARGIN', -- a09_function_name_m88
                            l_cust_marg_req_id, -- a09_request_id
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
                            17, -- a09_function_id_m88
                            'CUSTOMER_MARGIN', -- a09_function_name_m88
                            l_cust_marg_req_id, -- a09_request_id
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
                            17, -- a09_function_id_m88
                            'CUSTOMER_MARGIN', -- a09_function_name_m88
                            l_cust_marg_req_id, -- a09_request_id
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
                UPDATE dfn_ntp.t24_customer_margin_request
                   SET t24_cust_margin_product_id_u23 =
                           i.new_cust_margin_prod_id, -- t24_cust_margin_product_id_u23
                       t24_customer_id_u01 = i.new_customer_id, -- t24_customer_id_u01
                       t24_default_cash_acc_id_u06 = i.new_cash_account_id, -- t24_default_cash_acc_id_u06
                       t24_margin_products_id_m73 = i.new_margin_products_id, -- t24_margin_products_id_m73
                       t24_interest_group_id_m74 = i.new_margin_int_group_id, -- t24_interest_group_id_m74
                       t24_max_margin_limit = i.m192_u23_max_margin_limit, -- t24_max_margin_limit
                       t24_max_limit_curr_id_m03 = i.m03_id, -- t24_max_limit_curr_id_m03
                       t24_max_limit_curr_code_m03 = i.m03_code, -- t24_max_limit_curr_code_m03
                       t24_margin_expiry_date = i.m192_u23_margin_expiry_date, -- t24_margin_expiry_date
                       t24_margin_call_level_1 =
                           i.m192_u23_margin_call_level_1, -- t24_margin_call_level_1
                       t24_margin_call_level_2 =
                           i.m192_u23_margin_call_level_2, -- t24_margin_call_level_2
                       t24_liquidation_level = i.m192_u23_liquidation_level, -- t24_liquidation_level
                       t24_symbol_margnblty_grps_m77 =
                           i.new_symbol_margin_grp_id, -- t24_symbol_margnblty_grps_m77
                       t24_margin_percentage =
                           i.m192_u23_init_margin_percentag, -- t24_margin_percentage
                       t24_is_approval_completed = i.approval_completed, -- t24_is_approval_completed
                       t24_current_approval_level = i.current_approval_level, -- t24_current_approval_level
                       t24_next_status = i.next_status, -- t24_next_status
                       t24_created_date = i.created_date, -- t24_created_date
                       t24_last_updated_date = i.last_updated_date, -- t24_last_updated_date
                       t24_status_id_v01 = i.map01_ntp_id, -- t24_status_id_v01
                       t24_created_by_id_u17 = i.created_by_new_id, -- t24_created_by_id_u17
                       t24_last_updated_by_id_u17 = i.last_updated_by_new_id, -- t24_last_updated_by_id_u17
                       t24_restore_level = i.m192_u23_margin_call_level_2, -- t24_restore_level | In Case Topup Amount Not Available
                       t24_institute_id_m02 = i.u06_institute_id_m02 -- t24_institute_id_m02
                 WHERE t24_id = i.new_cust_margin_req_id;

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
                            17, -- a09_function_id_m88
                            'CUSTOMER_MARGIN', -- a09_function_name_m88
                            i.new_cust_margin_req_id, -- a09_request_id
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
                            17, -- a09_function_id_m88
                            'CUSTOMER_MARGIN', -- a09_function_name_m88
                            i.new_cust_margin_req_id, -- a09_request_id
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
                            17, -- a09_function_id_m88
                            'CUSTOMER_MARGIN', -- a09_function_name_m88
                            i.new_cust_margin_req_id, -- a09_request_id
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
                            17, -- a09_function_id_m88
                            'CUSTOMER_MARGIN', -- a09_function_name_m88
                            i.new_cust_margin_req_id, -- a09_request_id
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
                                'T54_CUSTOMER_MARGIN_REQUEST',
                                i.m192_id,
                                CASE
                                    WHEN i.new_cust_margin_req_id IS NULL
                                    THEN
                                        l_cust_marg_req_id
                                    ELSE
                                        i.new_cust_margin_req_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cust_margin_req_id IS NULL
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
