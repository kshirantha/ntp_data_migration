DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_share_txn_id           NUMBER;
    l_log_id                 NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (t12_id), 0)
      INTO l_share_txn_id
      FROM dfn_ntp.t12_share_transaction;

    SELECT NVL (MAX (a09_id), 0)
      INTO l_log_id
      FROM dfn_ntp.a09_function_approval_log;

    DELETE FROM error_log
          WHERE mig_table = 'T12_SHARE_TRANSACTION';

    FOR i
        IN (SELECT t24_id,
                   m20.m20_exchange_code_m01,
                   m20.m20_symbol_code,
                   t24_quantity,
                   t24_avgcost,
                   u07_map.new_trading_account_id AS trading_acc_new_id,
                   t24_seller_exchange_ac,
                   u07.u07_customer_id_u01,
                   CASE
                       WHEN t24_status = 1 THEN 1
                       WHEN t24_status = 3 THEN 101
                       WHEN t24_status = 4 THEN 2
                       WHEN t24_status = 5 THEN 19
                       WHEN t24_status = 6 THEN 3
                       WHEN t24_status = 8 THEN 6
                       WHEN t24_status IN (0, 9, 10) THEN 3 -- [Corrective Actions Discussed] (0, 9 & 10 Migrating as REJECTED)
                       ELSE -1
                   END
                       AS status_id,
                   t24_timestamp,
                   t24_txn_type, -- [SAME IDs]
                   CASE
                       WHEN t24_txn_type = 1
                       THEN
                           'HLDDEPOST'
                       WHEN t24_txn_type = 2
                       THEN
                           'HLDWITHDR'
                       WHEN t24_txn_type = 3
                       THEN
                           'HLDBONUSI'
                       WHEN t24_txn_type = 4
                       THEN
                           'HLDADJUST'
                       WHEN t24_txn_type = 5
                       THEN
                           'HLDDEPOST' -- Stock Split (OMS Uses HLDDEPOST)
                       WHEN t24_txn_type = 6
                       THEN
                           'HLDWITHDR' -- Reverse Split (OMS Uses HLDWITHDR)
                       WHEN t24_txn_type = 7
                       THEN
                           'HLDTRN'
                       WHEN t24_txn_type = 13
                       THEN
                           NULL -- Right Subscriptions Will be Captured as Orders
                       WHEN t24_txn_type = 15
                       THEN
                           NULL -- Right Reversals Will be Ignored While Capturing Right Subscriptions
                       WHEN t24_txn_type IN (0, 9, 11, 14)
                       THEN
                           CASE
                               WHEN t24_to_portfolio_id > 0
                               THEN
                                   'HLDTRN'
                               WHEN    t24_to_portfolio_id <= 0
                                    OR     t24_to_portfolio_id IS NULL
                                       AND t24_quantity >= 0
                               THEN
                                   'HLDDEPOST'
                               WHEN    t24_to_portfolio_id <= 0
                                    OR     t24_to_portfolio_id IS NULL
                                       AND t24_quantity < 0
                               THEN
                                   'HLDWITHDR'
                           END
                   END
                       AS m97_code,
                   u07.u07_institute_id_m02,
                   t24_narration,
                   u07_map_buyer_pf.new_trading_account_id
                       AS buyer_trading_ac_new_id,
                   t24_buyer_exchange_ac,
                   t24_send_to_exchange,
                   t24_fees,
                   t06_map.new_cash_transaction_id,
                   t24_transfer_date,
                   t24_transaction_fee,
                   t24_reject_reason,
                   t24_txn_source, -- [SAME IDs]
                   t24_movement_type, -- [SAME IDs]
                   t24_seller_memebr_code,
                   t24_buyer_member_code,
                   CASE
                       WHEN     u17_cancelled.new_employee_id IS NOT NULL
                            AND u17_cancelled.new_employee_id <> -1
                       THEN
                           u17_cancelled.new_employee_id
                       WHEN     u17_l2_by.new_employee_id IS NOT NULL
                            AND u17_l2_by.new_employee_id <> -1
                       THEN
                           u17_l2_by.new_employee_id
                       WHEN     u17_l1_by.new_employee_id IS NOT NULL
                            AND u17_l1_by.new_employee_id <> -1
                       THEN
                           u17_l1_by.new_employee_id
                       WHEN     u17_entered.new_employee_id IS NOT NULL
                            AND u17_entered.new_employee_id <> -1
                       THEN
                           u17_entered.new_employee_id
                   END
                       AS last_changed_by_new_id,
                   CASE
                       WHEN t24_cancelled_date IS NOT NULL
                       THEN
                           t24_cancelled_date
                       WHEN t24_approved2_date IS NOT NULL
                       THEN
                           t24_approved2_date
                       WHEN t24_approved1_date IS NOT NULL
                       THEN
                           t24_approved1_date
                       WHEN t24_timestamp IS NOT NULL
                       THEN
                           t24_timestamp
                   END
                       AS last_changed_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   NVL (u17_entered.new_employee_id, 0) AS created_by_new_id,
                   t24.t24_timestamp AS created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   u17_l1_by.new_employee_id AS l1_by_new_id,
                   t24.t24_approved1_date AS l1_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   u17_l2_by.new_employee_id AS l2_by_new_id,
                   t24.t24_approved2_date AS l2_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   u17_cancelled.new_employee_id AS cancelled_by_new_id,
                   t24.t24_cancelled_date AS cancelled_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   CASE
                       WHEN t24_status IN (4, 5, 6, 7) THEN 2
                       WHEN t24_status IN (3, 8) THEN 1
                       WHEN t24_status = 1 THEN 0
                   END
                       AS current_approval_level,
                   CASE
                       WHEN t24_to_portfolio_id > 0
                       THEN
                           12
                       WHEN    t24_to_portfolio_id <= 0
                            OR     t24_to_portfolio_id IS NULL
                               AND t24_quantity >= 0
                       THEN
                           10
                       WHEN    t24_to_portfolio_id <= 0
                            OR     t24_to_portfolio_id IS NULL
                               AND t24_quantity < 0
                       THEN
                           11
                   END
                       AS function_approval_id,
                   CASE
                       WHEN t24_to_portfolio_id > 0
                       THEN
                           'SHARETRANSFER'
                       WHEN    t24_to_portfolio_id <= 0
                            OR     t24_to_portfolio_id IS NULL
                               AND t24_quantity > 0
                       THEN
                           'SHAREDEPOSIT'
                       WHEN    t24_to_portfolio_id <= 0
                            OR     t24_to_portfolio_id IS NULL
                               AND t24_quantity < 0
                       THEN
                           'SHAREWITHDRAW'
                   END
                       AS function_approval_name,
                   CASE WHEN t24_status IN (4, 5, 6) THEN 1 ELSE 0 END
                       AS final_approval,
                   t24_exchange_vat,
                   t24_broker_vat,
                   m20.m20_id,
                   m20.m20_exchange_id_m01,
                   t12_map.new_share_transaction_id
              FROM mubasher_oms.t24_pending_stocks@mubasher_db_link t24,
                   (SELECT m20_id,
                           m20_symbol_code,
                           m20_exchange_id_m01,
                           m20_exchange_code_m01
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20,
                   map16_optional_exchanges_m01 map16,
                   u07_trading_account_mappings u07_map,
                   dfn_ntp.u07_trading_account u07,
                   -- m02_institute_mappings m02_map -- [Corrective Actions Discussed]
                   u07_trading_account_mappings u07_map_buyer_pf,
                   t06_cash_transaction_mappings t06_map,
                   u17_employee_mappings u17_cancelled,
                   u17_employee_mappings u17_l2_by,
                   u17_employee_mappings u17_l1_by,
                   u17_employee_mappings u17_entered,
                   t12_share_transaction_mappings t12_map
             WHERE     t24.t24_txn_type NOT IN (13, 15) -- 13 (Right Subscriptions) WIll be Captured as Orders | 15 (Right Reversals) Will be Ignored While Capturing Subscriptions
                   AND t24.t24_inst_id <> 0 -- [Corrective Actions Discussed]
                   AND (   REGEXP_LIKE (t24_reference_no, '^-?[0-9]+$')
                        OR t24_reference_no IS NULL)
                   AND t24.t24_symbol = m20.m20_symbol_code(+)
                   AND t24.t24_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, t24.t24_exchange) =
                           m20.m20_exchange_code_m01(+)
                   AND t24.t24_portfolio_id =
                           u07_map.old_trading_account_id(+)
                   AND NVL (map16.map16_ntp_code, t24.t24_exchange) =
                           u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id = u07.u07_id(+)
                   -- AND t24.t24_inst_id = m02_map.old_institute_id(+) -- [Corrective Actions Discussed]
                   AND t24.t24_buyer_portfolio_id =
                           u07_map_buyer_pf.old_trading_account_id(+)
                   AND NVL (map16.map16_ntp_code, t24.t24_exchange) =
                           u07_map_buyer_pf.exchange_code(+)
                   AND t24.t24_reference_no =
                           t06_map.old_cash_transaction_id(+)
                   AND t24.t24_cancelled_by =
                           u17_cancelled.old_employee_id(+)
                   AND t24.t24_approved2_by = u17_l2_by.old_employee_id(+)
                   AND t24.t24_approved1_by = u17_l1_by.old_employee_id(+)
                   AND t24.t24_entered_by = u17_entered.old_employee_id(+)
                   AND t24.t24_id = t12_map.old_share_transaction_id(+))
    LOOP
        BEGIN
            IF i.trading_acc_new_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Trading Account Not Available',
                                         TRUE);
            END IF;

            IF i.m20_symbol_code IS NULL
            THEN
                raise_application_error (-20001,
                                         'Symbol Not Available',
                                         TRUE);
            END IF;

            IF i.status_id = -1
            THEN
                raise_application_error (-20001, 'Invalid Status', TRUE);
            END IF;

            IF i.new_share_transaction_id IS NULL
            THEN
                l_share_txn_id := l_share_txn_id + 1;

                INSERT
                  INTO dfn_ntp.t12_share_transaction (
                           t12_id,
                           t12_exchange_code_m01,
                           t12_symbol_code_m20,
                           t12_quantity,
                           t12_avgcost,
                           t12_trading_acc_id_u07,
                           t12_seller_exchange_ac,
                           t12_customer_id_u01,
                           t12_status_id_v01,
                           t12_timestamp,
                           t12_txn_type,
                           t12_pending_req_id,
                           t12_inst_id_m02,
                           t12_narration,
                           t12_buyer_trading_ac_id_u07,
                           t12_buyer_exchange_ac,
                           t12_send_to_exchange,
                           t12_book_keeper_id,
                           t12_fees,
                           t12_reference_id_t06,
                           t12_transfer_date,
                           t12_exng_fee,
                           t12_brk_fee,
                           t12_custodian_id_m26,
                           t12_transaction_fee,
                           t12_txn_category,
                           t12_reject_reason,
                           t12_poa_id_u47,
                           t12_txn_source,
                           t12_movement_type,
                           t12_seller_memebr_code,
                           t12_seller_nin,
                           t12_buyer_member_code,
                           t12_buyer_nin,
                           t12_channel_id_v29,
                           t12_umsg_id_t19,
                           t12_include_gl,
                           t12_last_changed_by_id_u17,
                           t12_last_changed_date,
                           t12_no_of_approval,
                           t12_current_approval_level,
                           t12_function_id_m88,
                           t12_final_approval,
                           t12_exg_vat,
                           t12_brk_vat,
                           t12_is_b_file,
                           t12_symbol_id_m20,
                           t12_exchange_id_m01,
                           t12_bulk_master_id_t61,
                           t12_exg_discount,
                           t12_brk_discount,
                           t12_contract_id_t75,
                           t12_code_m97,
                           t12_narration_lang,
                           t12_ip)
                VALUES (l_share_txn_id, -- t12_id
                        i.m20_exchange_code_m01, -- t12_exchange_code_m01
                        i.m20_symbol_code, -- t12_symbol_code_m20
                        i.t24_quantity, -- t12_quantity
                        i.t24_avgcost, -- t12_avgcost
                        i.trading_acc_new_id, -- t12_trading_acc_id_u07
                        i.t24_seller_exchange_ac, -- t12_seller_exchange_ac
                        i.u07_customer_id_u01, -- t12_customer_id_u01,
                        i.status_id, -- t12_status_id_v01
                        i.t24_timestamp, -- t12_timestamp
                        i.t24_txn_type, -- t12_txn_type
                        NULL, -- t12_pending_req_id | Not Used
                        i.u07_institute_id_m02, -- t12_inst_id_m02
                        i.t24_narration, -- t12_narration
                        i.buyer_trading_ac_new_id, -- t12_buyer_trading_ac_id_u07
                        i.t24_buyer_exchange_ac, -- t12_buyer_exchange_ac
                        i.t24_send_to_exchange, -- t12_send_to_exchange
                        NULL, -- t12_book_keeper_id
                        i.t24_fees, -- t12_fees
                        i.new_cash_transaction_id, -- t12_reference_id_t06
                        i.t24_transfer_date, -- t12_transfer_date
                        0, -- t12_exng_fee | Not Available
                        0, -- t12_brk_fee | Not Available
                        -1, -- t12_custodian_id_m26 | Updating Later in this Script
                        i.t24_transaction_fee, -- t12_transaction_fee
                        NULL, -- t12_txn_category | Not Available
                        i.t24_reject_reason, -- t12_reject_reason
                        NULL, -- t12_poa_id_u47 | Not Available
                        i.t24_txn_source, -- t12_txn_source
                        i.t24_movement_type, -- t12_movement_type
                        i.t24_seller_memebr_code, -- t12_seller_memebr_code
                        NULL, -- t12_seller_nin | Not Available
                        i.t24_buyer_member_code, -- t12_buyer_member_code
                        NULL, -- t12_buyer_nin | Not Available
                        NULL, -- t12_channel_id_v29 | Not Available
                        NULL, -- Migration Script Not Available for U Messages
                        1, -- t12_include_gl | 1 - By Default  Include
                        i.last_changed_by_new_id, -- t12_last_changed_by_id_u17
                        i.last_changed_date, -- t12_last_changed_date
                        2, -- t12_no_of_approval
                        i.current_approval_level, -- t12_current_approval_level
                        i.function_approval_id, -- t12_function_id_m88
                        i.final_approval, -- t12_final_approval
                        i.t24_exchange_vat, -- t12_exg_vat
                        i.t24_broker_vat, -- t12_brk_vat
                        NULL, -- t12_is_b_file
                        i.m20_id, -- t12_symbol_id_m20
                        i.m20_exchange_id_m01, -- t12_exchange_id_m01
                        NULL, -- t12_bulk_master_id_t61
                        NULL, -- t12_exg_discount | Not Available
                        NULL, -- t12_brk_discount | Not Available
                        NULL, -- t12_contract_id_t75 | Not Available
                        i.m97_code, -- t12_code_m97
                        i.t24_narration, -- t12_narration_lang
                        NULL -- t12_ip | Not Available
                            );

                INSERT INTO t12_share_transaction_mappings
                     VALUES (i.t24_id, l_share_txn_id);

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
                            i.function_approval_id, -- a09_function_id_m88
                            i.function_approval_name, -- a09_function_name_m88
                            l_share_txn_id, -- a09_request_id
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
                            i.function_approval_id, -- a09_function_id_m88
                            i.function_approval_name, -- a09_function_name_m88
                            l_share_txn_id, -- a09_request_id
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
                            i.function_approval_id, -- a09_function_id_m88
                            i.function_approval_name, -- a09_function_name_m88
                            l_share_txn_id, -- a09_request_id
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

                IF i.cancelled_by_new_id IS NOT NULL
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
                            i.function_approval_id, -- a09_function_id_m88
                            i.function_approval_name, -- a09_function_name_m88
                            l_share_txn_id, -- a09_request_id
                            3, -- a09_status_id_v01
                            i.cancelled_by_new_id, -- a09_action_by_id_u17
                            i.cancelled_date, -- a09_action_date
                            i.created_by_new_id, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Rejected', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;
            ELSE
                UPDATE dfn_ntp.t12_share_transaction
                   SET t12_exchange_code_m01 = i.m20_exchange_code_m01, -- t12_exchange_code_m01
                       t12_symbol_code_m20 = i.m20_symbol_code, -- t12_symbol_code_m20
                       t12_quantity = i.t24_quantity, -- t12_quantity
                       t12_avgcost = i.t24_avgcost, -- t12_avgcost
                       t12_trading_acc_id_u07 = i.trading_acc_new_id, -- t12_trading_acc_id_u07
                       t12_seller_exchange_ac = i.t24_seller_exchange_ac, -- t12_seller_exchange_ac
                       t12_customer_id_u01 = i.u07_customer_id_u01, -- t12_customer_id_u01,
                       t12_status_id_v01 = i.status_id, -- t12_status_id_v01
                       t12_timestamp = i.t24_timestamp, -- t12_timestamp
                       t12_txn_type = i.t24_txn_type, -- t12_txn_type
                       t12_inst_id_m02 = i.u07_institute_id_m02, -- t12_inst_id_m02
                       t12_narration = i.t24_narration, -- t12_narration
                       t12_buyer_trading_ac_id_u07 = i.buyer_trading_ac_new_id, -- t12_buyer_trading_ac_id_u07
                       t12_buyer_exchange_ac = i.t24_buyer_exchange_ac, -- t12_buyer_exchange_ac
                       t12_send_to_exchange = i.t24_send_to_exchange, -- t12_send_to_exchange
                       t12_fees = i.t24_fees, -- t12_fees
                       t12_reference_id_t06 = i.new_cash_transaction_id, -- t12_reference_id_t06
                       t12_transfer_date = i.t24_transfer_date, -- t12_transfer_date
                       t12_custodian_id_m26 = -1, -- t12_custodian_id_m26 | Updating Later in this Script
                       t12_transaction_fee = i.t24_transaction_fee, -- t12_transaction_fee
                       t12_reject_reason = i.t24_reject_reason, -- t12_reject_reason
                       t12_txn_source = i.t24_txn_source, -- t12_txn_source
                       t12_movement_type = i.t24_movement_type, -- t12_movement_type
                       t12_seller_memebr_code = i.t24_seller_memebr_code, -- t12_seller_memebr_code
                       t12_buyer_member_code = i.t24_buyer_member_code, -- t12_buyer_member_code
                       t12_last_changed_by_id_u17 =
                           NVL (i.last_changed_by_new_id, 0), -- t12_last_changed_by_id_u17
                       t12_last_changed_date = i.last_changed_date, -- t12_last_changed_date
                       t12_current_approval_level = i.current_approval_level, -- t12_current_approval_level
                       t12_function_id_m88 = i.function_approval_id, -- t12_function_id_m88
                       t12_final_approval = i.final_approval, -- t12_final_approval
                       t12_exg_vat = i.t24_exchange_vat, -- t12_exg_vat
                       t12_brk_vat = i.t24_broker_vat, -- t12_brk_vat
                       t12_symbol_id_m20 = i.m20_id, -- t12_symbol_id_m20
                       t12_exchange_id_m01 = i.m20_exchange_id_m01, -- t12_exchange_id_m01
                       t12_code_m97 = i.m97_code, -- t12_code_m97
                       t12_narration_lang = i.t24_narration -- t12_narration_lang
                 WHERE t12_id = i.new_share_transaction_id;

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
                            i.function_approval_id, -- a09_function_id_m88
                            i.function_approval_name, -- a09_function_name_m88
                            i.new_share_transaction_id, -- a09_request_id
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
                            i.function_approval_id, -- a09_function_id_m88
                            i.function_approval_name, -- a09_function_name_m88
                            i.new_share_transaction_id, -- a09_request_id
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


                IF i.status_id = 3 AND i.cancelled_by_new_id IS NOT NULL
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
                            i.function_approval_id, -- a09_function_id_m88
                            i.function_approval_name, -- a09_function_name_m88
                            i.new_share_transaction_id, -- a09_request_id
                            3, -- a09_status_id_v01
                            i.cancelled_by_new_id, -- a09_action_by_id_u17
                            i.cancelled_date, -- a09_action_date
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
                            i.function_approval_id, -- a09_function_id_m88
                            i.function_approval_name, -- a09_function_name_m88
                            i.new_share_transaction_id, -- a09_request_id
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
                                'T12_SHARE_TRANSACTION',
                                i.t24_id,
                                CASE
                                    WHEN i.new_share_transaction_id IS NULL
                                    THEN
                                        l_share_txn_id
                                    ELSE
                                        i.new_share_transaction_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_share_transaction_id IS NULL
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

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('T12_SHARE_TRANSACTION');
END;
/

-- Updating with Default Custodian

MERGE INTO dfn_ntp.t12_share_transaction t12
     USING (SELECT t12.t12_id, m43.m43_custodian_id_m26
              FROM dfn_ntp.t12_share_transaction t12,
                   dfn_ntp.m43_institute_exchanges m43
             WHERE     t12.t12_exchange_code_m01 = m43.m43_exchange_code_m01
                   AND t12.t12_inst_id_m02 = m43.m43_institute_id_m02) m43
        ON (t12.t12_id = m43.t12_id)
WHEN MATCHED
THEN
    UPDATE SET t12.t12_custodian_id_m26 = m43.m43_custodian_id_m26;

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('T12_SHARE_TRANSACTION');
END;
/
