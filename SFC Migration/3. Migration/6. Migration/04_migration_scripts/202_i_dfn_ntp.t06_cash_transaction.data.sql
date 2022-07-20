DECLARE
    l_cash_transaction_id   NUMBER;
    l_log_id                NUMBER;
    l_sqlerrm               VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t06_id), 0)
      INTO l_cash_transaction_id
      FROM dfn_ntp.t06_cash_transaction;

    SELECT NVL (MAX (a09_id), 0)
      INTO l_log_id
      FROM dfn_ntp.a09_function_approval_log;

    DELETE FROM error_log
          WHERE mig_table = 'T06_CASH_TRANSACTION';

    FOR i
        IN (  SELECT t12.t12_id,
                     u06_map.new_cash_account_id,
                     CASE
                         WHEN TRIM (t12.t12_code) = 'TRNFEE'
                         THEN
                             CASE
                                 WHEN m264.m264_type = 2 THEN 'CTRFEE_BNK'
                                 WHEN m264.m264_type = 3 THEN 'CTRFEE_OTR'
                                 ELSE 'CTRFEE_INT'
                             END
                         ELSE
                             m97.m97_code
                     END
                         AS m97_code,
                     t12.t12_date,
                     t12.t12_cust_reference_no, -- [SAME Customer Ref No = Customer No]
                     t12.t12_narration,
                     CASE
                         WHEN UPPER (t12.t12_payment_method) = 'CASH'
                         THEN
                             1
                         WHEN UPPER (t12.t12_payment_method) = 'CHEQUE'
                         THEN
                             2
                         WHEN UPPER (t12.t12_payment_method) = 'TRANSFER'
                         THEN
                             3
                     END
                         AS payment_method,
                     NVL (m03.m03_code, u06.u06_currency_code_m03)
                         AS currency_code,
                     t12.t12_amt_in_trans_currency,
                     t12.t12_trans_base_curr_rate,
                     t12.t12_cheque_no,
                     t12.t12_cheque_date,
                     t12.t12_value_date,
                     u08_map.new_cust_benefcry_acc_id,
                     u08.u08_account_id,
                     NVL (u17_entered_by.new_employee_id, 0)
                         AS created_by_new_id,
                     t12.t12_date AS created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                     CASE
                         WHEN u17_rejected_by.new_employee_id IS NOT NULL
                         THEN
                             u17_rejected_by.new_employee_id
                         WHEN u17_reversed_by.new_employee_id IS NOT NULL
                         THEN
                             u17_reversed_by.new_employee_id
                         WHEN u17_l2_by.new_employee_id IS NOT NULL
                         THEN
                             u17_l2_by.new_employee_id
                         WHEN u17_l1_by.new_employee_id IS NOT NULL
                         THEN
                             u17_l1_by.new_employee_id
                         ELSE
                             u17_entered_by.new_employee_id
                     END
                         AS last_updated_by_new_id,
                     CASE
                         WHEN t12.t12_audit_reject_time IS NOT NULL
                         THEN
                             t12_audit_reject_time
                         WHEN t12.t12_reversed_date IS NOT NULL
                         THEN
                             t12_reversed_date
                         WHEN t12.t12_approved2_date IS NOT NULL
                         THEN
                             t12_approved2_date
                         WHEN t12.t12_approved1_date IS NOT NULL
                         THEN
                             t12_approved1_date
                         ELSE
                             t12.t12_date
                     END
                         AS last_updated_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                     CASE
                         WHEN t12.t12_status = 0 THEN 1
                         WHEN t12.t12_status = 1 THEN 101
                         WHEN t12.t12_status = 2 THEN 2
                         WHEN t12.t12_status = 3 THEN 19
                         WHEN t12.t12_status = 5 THEN 3
                         WHEN t12.t12_status = 6 THEN 7
                         ELSE -1
                     END
                         AS status_id,
                     m93_map.new_bank_accounts_id,
                     m93.m93_accountno,
                     m93.m93_branch_name,
                     CASE
                         WHEN u08.u08_id IS NOT NULL
                         THEN
                             u08.u08_account_type_v01_id
                     END
                         AS type_id,
                     NVL (u17_printed_by.new_employee_id, 0)
                         AS chk_printed_new_id,
                     t12.t12_chk_printed_date AS chk_printed_date,
                     t12.t12_doc_no,
                     CASE
                         WHEN t12.t12_request_channel = 1 THEN 1
                         WHEN t12.t12_request_channel = 2 THEN 3
                         WHEN t12.t12_request_channel = 3 THEN 2
                     END
                         AS request_channel,
                     t12.t12_location,
                     t12.t12_auto_generate,
                     t12.t12_available_buy_power,
                     t12.t12_online_ft, -- [SAME IDs]
                     t12.t12_ft_status, -- [SAME IDs]
                     t12.t12_message_type,
                     t12.t12_stp_type, -- [SAME IDs]
                     t12.t12_stp_status, -- [SAME IDs]
                     t12.t12_stp_naration,
                     t12.t12_cust_bank_ac_id,
                     t12.t12_settlement_key,
                     t12.t12_txn_type,
                     u17_l1_by.new_employee_id AS l1_by_new_id,
                     t12.t12_approved1_date AS l1_date,
                     u17_l2_by.new_employee_id AS l2_by_new_id,
                     t12.t12_approved2_date AS l2_date,
                     u17_reversed_by.new_employee_id AS reversed_by_new_id,
                     t12.t12_reversed_date AS reversed_date,
                     u17_rejected_by.new_employee_id AS rejected_by_new_id,
                     t12.t12_audit_reject_time AS rejected_date,
                     t12.t12_payment_initiated_time,
                     u06.u06_currency_code_m03,
                     t12.t12_amt_in_settle_currency,
                     t12.t12_overdrawn_amt,
                     u06_map_to_acc.new_cash_account_id AS to_new_cash_acc_id,
                     t12.t12_request_channel, -- [SAME IDs]
                     t12.t12_b2b_txn_id,
                     CASE
                         WHEN t12.t12_status IN (2, 3, 5, 6) THEN 2
                         WHEN t12.t12_status IN (1) THEN 1
                         ELSE 0
                     END
                         AS current_approval_level,
                     m93.m93_bank_id_m16,
                     m88.m88_id,
                     m88.m88_function,
                     t12.t12_exchange_vat,
                     t12.t12_broker_vat,
                     u06.u06_institute_id_m02,
                     u06.u06_customer_id_u01,
                     t06_map.new_cash_transaction_id
                FROM mubasher_oms.t12_pending_cash@mubasher_db_link t12,
                     mubasher_oms.m264_beneficiary_accounts@mubasher_db_link m264,
                     u06_cash_account_mappings u06_map,
                     dfn_ntp.u06_cash_account u06,
                     dfn_ntp.m03_currency m03,
                     map15_transaction_codes_m97 map15,
                     dfn_ntp.m97_transaction_codes m97,
                     u08_cust_benefcry_acc_mappings u08_map,
                     dfn_ntp.u08_customer_beneficiary_acc u08,
                     m93_bank_accounts_mappings m93_map,
                     dfn_ntp.m93_bank_accounts m93,
                     u06_cash_account_mappings u06_map_to_acc,
                     dfn_ntp.m88_function_approval m88,
                     u17_employee_mappings u17_entered_by,
                     u17_employee_mappings u17_printed_by,
                     u17_employee_mappings u17_reversed_by,
                     u17_employee_mappings u17_rejected_by,
                     u17_employee_mappings u17_l1_by,
                     u17_employee_mappings u17_l2_by,
                     t06_cash_transaction_mappings t06_map
               WHERE     t12.t12_status NOT IN (4, 7, 8, 9, 10, 24) -- [Corrective Actions Discussed] (7, 8, 9 Not Captured in OMS Code)
                     AND t12.t12_benificiary_id = m264.m264_id(+)
                     AND t12.t12_cash_account_id =
                             u06_map.old_cash_account_id(+)
                     AND u06_map.new_cash_account_id = u06.u06_id(+)
                     AND t12.t12_transaction_currency = m03.m03_code(+)
                     AND TRIM (t12.t12_code) = map15.map15_oms_code(+)
                     AND map15.map15_ntp_code = m97.m97_code(+)
                     AND t12.t12_benificiary_id =
                             u08_map.old_cust_benefcry_acc_id(+)
                     AND u08_map.new_cust_benefcry_acc_id = u08.u08_id(+)
                     AND t12.t12_our_bank_id = m93_map.old_bank_accounts_id(+)
                     AND m93_map.new_bank_accounts_id = m93.m93_id(+)
                     AND t12.t12_related_cash_ref =
                             u06_map_to_acc.old_cash_account_id(+)
                     AND map15.map15_ntp_code = m88.m88_txn_code(+)
                     AND NVL (t12.t12_request_channel, -1) =
                             m88.m88_channel_id_v29(+)
                     AND t12.t12_entered_by = u17_entered_by.old_employee_id(+)
                     AND t12.t12_chk_printed_by =
                             u17_printed_by.old_employee_id(+)
                     AND t12.t12_reversed_by =
                             u17_reversed_by.old_employee_id(+)
                     AND t12.t12_audit_reject_by =
                             u17_rejected_by.old_employee_id(+)
                     AND t12.t12_approved1_by = u17_l1_by.old_employee_id(+)
                     AND t12.t12_approved2_by = u17_l2_by.old_employee_id(+)
                     AND t12.t12_id = t06_map.old_cash_transaction_id(+)
            ORDER BY t12.t12_id)
    LOOP
        BEGIN
            IF i.new_cash_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Cash Account Not Available',
                                         TRUE);
            END IF;

            IF i.m97_code IS NULL
            THEN
                raise_application_error (-20001,
                                         'Transaction Code Not Available',
                                         TRUE);
            END IF;

            IF i.status_id = -1
            THEN
                raise_application_error (-20001, 'Invalid Status', TRUE);
            END IF;

            /* [Discussed to Not to Skip]

            IF i.m88_id IS NULL
             THEN
                 raise_application_error (-20001,
                                          'Function Approval Not Available',
                                          TRUE);
             END IF;

             */

            IF i.new_cash_transaction_id IS NULL
            THEN
                l_cash_transaction_id := l_cash_transaction_id + 1;

                INSERT
                  INTO dfn_ntp.t06_cash_transaction (
                           t06_id,
                           t06_cash_acc_id_u06,
                           t06_code,
                           t06_date,
                           t06_cust_ref_no,
                           t06_narration,
                           t06_payment_method,
                           t06_txn_code_m03,
                           t06_amt_in_txn_currency,
                           t06_settle_currency_rate_m04,
                           t06_cheque_no,
                           t06_cheque_date,
                           t06_settlement_date,
                           t06_beneficiary_id_u08,
                           t06_other_cash_acc_id_u06,
                           t06_entered_by_id_u17,
                           t06_entered_date,
                           t06_last_changed_by_id_u17,
                           t06_last_changed_date,
                           t06_cash_log_acc_id_u30,
                           t06_status_id,
                           t06_bank_id_m93,
                           t06_acc_name,
                           t06_branch,
                           t06_type_id,
                           t06_chk_printed_by,
                           t06_chk_printed_date,
                           t06_extrnl_ref,
                           t06_req_media,
                           t06_location,
                           t06_auto_generate,
                           t06_available_buy_power,
                           t06_online_ft,
                           t06_ft_status,
                           t06_message_type,
                           t06_stp_type,
                           t06_stp_status,
                           t06_stp_narration,
                           t06_cust_bank_acc_id,
                           t06_settlement_key,
                           t06_txn_type,
                           t06_reversed_by_id_u17,
                           t06_reversed_date,
                           t06_payment_initiated_time,
                           t06_settle_currency_code_m03,
                           t06_amt_in_settle_currency,
                           t06_related_txn_id,
                           t06_overdrawn_amt,
                           t06_poa_id_u47,
                           t06_exchange_fee,
                           t06_broker_fee,
                           t06_thirdparty_fee,
                           t06_to_cash_acc_id,
                           t06_client_channel_id_v29,
                           t06_sub_login_id_u09,
                           t06_sub_login_name,
                           t06_b2b_txn_id_m97,
                           t06_bypass_txn_restriction,
                           t06_third_party_txn_id,
                           t06_is_live,
                           t06_no_of_approval,
                           t06_current_approval_level,
                           t06_deposit_bank_id_m16,
                           t06_deposit_bank_no,
                           t06_function_id_m88,
                           t06_reject_reason,
                           t06_exg_vat,
                           t06_brk_vat,
                           t06_institute_id_m02,
                           t06_symbol_code_m20,
                           t06_symbol_id_m20,
                           t06_ref_id,
                           t06_ref_master_id,
                           t06_ref_type,
                           t06_is_allow_overdraw,
                           t06_is_archive_ready,
                           t06_b2b_message,
                           t06_contract_id_t75,
                           t06_system_approval,
                           t06_parent_ref_id,
                           t06_from_cust_id_u01,
                           t06_narration_lang,
                           t06_ip)
                VALUES (l_cash_transaction_id, -- t06_id
                        i.new_cash_account_id, -- t06_cash_acc_id_u06
                        i.m97_code, -- t06_code
                        i.t12_date, -- t06_date
                        i.u06_customer_id_u01, -- t06_cust_ref_no | [To be Dropped] Requested to populated Customer ID until Customer ID (T06_FROM_CUST_ID_U01) column is introduced & refactored from both Aura and OMS
                        i.t12_narration, -- t06_narration
                        i.payment_method, -- t06_payment_method
                        i.currency_code, -- t06_txn_code_m03
                        i.t12_amt_in_trans_currency, -- t06_amt_in_txn_currency
                        i.t12_trans_base_curr_rate, -- t06_settle_currency_rate_m04
                        i.t12_cheque_no, -- t06_cheque_no
                        i.t12_cheque_date, -- t06_cheque_date
                        i.t12_value_date, -- t06_settlement_date
                        i.new_cust_benefcry_acc_id, --t06_beneficiary_id_u08
                        i.u08_account_id, --t06_other_cash_acc_id_u06
                        i.created_by_new_id, -- t06_entered_by_id_u17
                        i.created_date, -- t06_entered_date,
                        i.last_updated_by_new_id, -- t06_last_changed_by_id_u17
                        i.last_updated_date, -- t06_last_changed_date
                        NULL, -- t06_cash_log_acc_id_u30 [Not Available]
                        i.status_id, -- t06_status_id
                        i.new_bank_accounts_id, -- t06_bank_id_m93
                        i.m93_accountno, -- t06_acc_name
                        i.m93_branch_name, -- t06_branch
                        i.type_id, -- t06_type_id
                        i.chk_printed_new_id, -- t06_chk_printed_by
                        i.chk_printed_date, -- t06_chk_printed_date
                        i.t12_doc_no, -- t06_extrnl_ref
                        i.request_channel, -- t06_req_media
                        i.t12_location, -- t06_location
                        i.t12_auto_generate, -- t06_auto_generate
                        i.t12_available_buy_power, -- t06_available_buy_power
                        i.t12_online_ft, -- t06_online_ft
                        i.t12_ft_status, -- t06_ft_status
                        i.t12_message_type, -- t06_message_type
                        i.t12_stp_type, -- t06_stp_type
                        i.t12_stp_status, -- t06_stp_status
                        i.t12_stp_naration, -- t06_stp_narration
                        i.t12_cust_bank_ac_id, -- t06_cust_bank_acc_id
                        i.t12_settlement_key, -- t06_settlement_key
                        i.t12_txn_type, -- t06_txn_type
                        i.reversed_by_new_id, -- t06_reversed_by_id_u17
                        i.reversed_date, -- t06_reversed_date
                        i.t12_payment_initiated_time, -- t06_payment_initiated_time
                        i.u06_currency_code_m03, -- t06_settle_currency_code_m03
                        i.t12_amt_in_settle_currency, -- t06_amt_in_settle_currency
                        0, -- t06_related_txn_id | Not Available
                        i.t12_overdrawn_amt, -- t06_overdrawn_amt
                        NULL, -- t06_poa_id_u47 | Not Available
                        0, -- t06_exchange_fee | Not Available
                        0, -- t06_broker_fee | Not Available
                        0, -- t06_thirdparty_fee | Not Available
                        i.to_new_cash_acc_id, -- t06_to_cash_acc_id
                        i.t12_request_channel, -- t06_client_channel_id_v29
                        NULL, -- t06_sub_login_id_u09 | Not Available
                        NULL, -- t06_sub_login_name | Not Available
                        i.t12_b2b_txn_id, -- t06_b2b_txn_id_m97
                        0, -- t06_bypass_txn_restriction | Not Available
                        0, -- t06_third_party_txn_id | Not Available
                        1, -- t06_is_live | Not Available
                        2, -- t06_no_of_approval
                        i.current_approval_level, -- t06_current_approval_level
                        i.m93_bank_id_m16, -- t06_deposit_bank_id_m16
                        i.m93_accountno, -- t06_deposit_bank_no
                        i.m88_id, -- t06_function_id_m88
                        NULL, -- t06_reject_reason
                        i.t12_exchange_vat, -- t06_exg_vat
                        i.t12_broker_vat, -- t06_brk_vat
                        i.u06_institute_id_m02, -- t06_institute_id_m02
                        NULL, -- t06_symbol_code_m20 | Not Available
                        NULL, -- t06_symbol_id_m20 | Not Available
                        NULL, -- t06_ref_id | Not Available
                        NULL, -- t06_ref_master_id | Not Available
                        NULL, --t06_ref_type | Not Available
                        NULL, -- t06_is_allow_overdraw | Not Available
                        0, -- t06_is_archive_ready
                        NULL, -- t06_b2b_message | Not Available
                        NULL, -- t06_contract_id_t75 | Not Available
                        0, -- t06_system_approval | Not Available
                        NULL, -- t06_parent_ref_id | Not Available
                        i.u06_customer_id_u01, -- t06_from_cust_id_u01
                        i.t12_narration, -- t06_narration_lang
                        NULL -- t06_ip | Not Available
                            );

                INSERT INTO t06_cash_transaction_mappings
                     VALUES (i.t12_id, l_cash_transaction_id);

                IF i.m88_id IS NOT NULL
                THEN
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
                                i.m88_id, -- a09_function_id_m88
                                i.m88_function, -- a09_function_name_m88
                                l_cash_transaction_id, -- a09_request_id
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
                                i.m88_id, -- a09_function_id_m88
                                i.m88_function, -- a09_function_name_m88
                                l_cash_transaction_id, -- a09_request_id
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
                                i.m88_id, -- a09_function_id_m88
                                i.m88_function, -- a09_function_name_m88
                                l_cash_transaction_id, -- a09_request_id
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
                                i.m88_id, -- a09_function_id_m88
                                i.m88_function, -- a09_function_name_m88
                                l_cash_transaction_id, -- a09_request_id
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
                END IF;
            ELSE
                UPDATE dfn_ntp.t06_cash_transaction
                   SET t06_cash_acc_id_u06 = i.new_cash_account_id, -- t06_cash_acc_id_u06
                       t06_code = i.m97_code, -- t06_code
                       t06_date = i.t12_date, -- t06_date
                       t06_cust_ref_no = i.u06_customer_id_u01, -- t06_cust_ref_no | [To be Dropped] Requested to populated Customer ID until Customer ID (T06_FROM_CUST_ID_U01) column is introduced & refactored from both Aura and OMS
                       t06_narration = i.t12_narration, -- t06_narration
                       t06_payment_method = i.payment_method, -- t06_payment_method
                       t06_txn_code_m03 = i.currency_code, -- t06_txn_code_m03
                       t06_amt_in_txn_currency = i.t12_amt_in_trans_currency, -- t06_amt_in_txn_currency
                       t06_settle_currency_rate_m04 =
                           i.t12_trans_base_curr_rate, -- t06_settle_currency_rate_m04
                       t06_cheque_no = i.t12_cheque_no, -- t06_cheque_no
                       t06_cheque_date = i.t12_cheque_date, -- t06_cheque_date
                       t06_settlement_date = i.t12_value_date, -- t06_settlement_date
                       t06_beneficiary_id_u08 = i.new_cust_benefcry_acc_id, --t06_beneficiary_id_u08
                       t06_other_cash_acc_id_u06 = i.u08_account_id, --t06_other_cash_acc_id_u06
                       t06_last_changed_by_id_u17 = i.last_updated_by_new_id, -- t06_last_changed_by_id_u17
                       t06_last_changed_date = i.last_updated_date, -- t06_last_changed_date
                       t06_status_id = i.status_id, -- t06_status_id
                       t06_bank_id_m93 = i.new_bank_accounts_id, -- t06_bank_id_m93
                       t06_acc_name = i.m93_accountno, -- t06_acc_name
                       t06_branch = i.m93_branch_name, -- t06_branch
                       t06_type_id = i.type_id, -- t06_type_id
                       t06_chk_printed_by = i.chk_printed_new_id, -- t06_chk_printed_by
                       t06_chk_printed_date = i.chk_printed_date, -- t06_chk_printed_date
                       t06_extrnl_ref = i.t12_doc_no, -- t06_extrnl_ref
                       t06_req_media = i.request_channel, -- t06_req_media
                       t06_location = i.t12_location, -- t06_location
                       t06_auto_generate = i.t12_auto_generate, -- t06_auto_generate
                       t06_available_buy_power = i.t12_available_buy_power, -- t06_available_buy_power
                       t06_online_ft = i.t12_online_ft, -- t06_online_ft
                       t06_ft_status = i.t12_ft_status, -- t06_ft_status
                       t06_message_type = i.t12_message_type, -- t06_message_type
                       t06_stp_type = i.t12_stp_type, -- t06_stp_type
                       t06_stp_status = i.t12_stp_status, -- t06_stp_status
                       t06_stp_narration = i.t12_stp_naration, -- t06_stp_narration
                       t06_cust_bank_acc_id = i.t12_cust_bank_ac_id, -- t06_cust_bank_acc_id
                       t06_settlement_key = i.t12_settlement_key, -- t06_settlement_key
                       t06_txn_type = i.t12_txn_type, -- t06_txn_type
                       t06_reversed_by_id_u17 = i.reversed_by_new_id, -- t06_reversed_by_id_u17
                       t06_reversed_date = i.reversed_date, -- t06_reversed_date
                       t06_payment_initiated_time =
                           i.t12_payment_initiated_time, -- t06_payment_initiated_time
                       t06_settle_currency_code_m03 = i.u06_currency_code_m03, -- t06_settle_currency_code_m03
                       t06_amt_in_settle_currency =
                           i.t12_amt_in_settle_currency, -- t06_amt_in_settle_currency
                       t06_overdrawn_amt = i.t12_overdrawn_amt, -- t06_overdrawn_amt
                       t06_to_cash_acc_id = i.to_new_cash_acc_id, -- t06_to_cash_acc_id
                       t06_client_channel_id_v29 = i.t12_request_channel, -- t06_client_channel_id_v29
                       t06_b2b_txn_id_m97 = i.t12_b2b_txn_id, -- t06_b2b_txn_id_m97
                       t06_current_approval_level = i.current_approval_level, -- t06_current_approval_level
                       t06_deposit_bank_id_m16 = i.m93_bank_id_m16, -- t06_deposit_bank_id_m16
                       t06_deposit_bank_no = i.m93_accountno, -- t06_deposit_bank_no
                       t06_function_id_m88 = i.m88_id, -- t06_function_id_m88
                       t06_exg_vat = i.t12_exchange_vat, -- t06_exg_vat
                       t06_brk_vat = i.t12_broker_vat, -- t06_brk_vat
                       t06_institute_id_m02 = i.u06_institute_id_m02, -- t06_institute_id_m02
                       t06_from_cust_id_u01 = i.u06_customer_id_u01, -- t06_from_cust_id_u01
                       t06_narration_lang = i.t12_narration -- t06_narration_lang
                 WHERE t06_id = i.new_cash_transaction_id;

                IF i.m88_id IS NOT NULL
                THEN
                    IF i.status_id = 1 AND i.l1_by_new_id IS NOT NULL
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
                                i.m88_id, -- a09_function_id_m88
                                i.m88_function, -- a09_function_name_m88
                                i.new_cash_transaction_id, -- a09_request_id
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

                    IF i.status_id = 101 AND i.l1_by_new_id IS NOT NULL
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
                                i.m88_id, -- a09_function_id_m88
                                i.m88_function, -- a09_function_name_m88
                                i.new_cash_transaction_id, -- a09_request_id
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

                    IF i.status_id = 3 AND i.rejected_by_new_id IS NOT NULL
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
                                i.m88_id, -- a09_function_id_m88
                                i.m88_function, -- a09_function_name_m88
                                i.new_cash_transaction_id, -- a09_request_id
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

                    IF i.status_id = 2 AND i.l2_by_new_id IS NOT NULL
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
                                i.m88_id, -- a09_function_id_m88
                                i.m88_function, -- a09_function_name_m88
                                i.new_cash_transaction_id, -- a09_request_id
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
                                'T06_CASH_TRANSACTION',
                                i.t12_id,
                                CASE
                                    WHEN i.new_cash_transaction_id IS NULL
                                    THEN
                                        l_cash_transaction_id
                                    ELSE
                                        i.new_cash_transaction_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cash_transaction_id IS NULL
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

BEGIN
    dfn_ntp.sp_stat_gather ('T06_CASH_TRANSACTION');
END;
/
