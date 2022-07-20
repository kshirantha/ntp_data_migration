DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_pledge_id              NUMBER;
    l_log_id                 NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
    l_use_new_key            NUMBER;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (t20_id), 0)
      INTO l_pledge_id
      FROM dfn_ntp.t20_pending_pledge;

    SELECT NVL (MAX (a09_id), 0)
      INTO l_log_id
      FROM dfn_ntp.a09_function_approval_log;

    DELETE FROM error_log
          WHERE mig_table = 'T20_PENDING_PLEDGE';

    l_use_new_key := fn_use_new_key ('T20_PENDING_PLEDGE');

    FOR i
        IN (SELECT t17_id,
                   u07_map.new_trading_account_id,
                   m20.m20_exchange_code_m01,
                   m20.m20_symbol_code,
                   t17_qty,
                   v34.v34_inst_id_v09,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   t17_entered_date AS created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   CASE
                       WHEN t17_status = 0 THEN 1
                       WHEN t17_status = 1 THEN 101
                       WHEN t17_status = 2 THEN 2
                       WHEN t17_status = 3 THEN 3
                       WHEN t17_status = 4 THEN 6
                       ELSE -1
                   END
                       AS status_id,
                   t17_send_to_exchange,
                   t17_send_to_exchange_result,
                   CASE
                       WHEN t17_pledge_type = 'I' THEN 8
                       WHEN t17_pledge_type = 'O' THEN 9
                   END
                       AS pledge_type,
                   t17_transaction_number,
                   t17_pledgee,
                   t17_pledgor,
                   t17_pledgor_ac_no,
                   t17_nin,
                   t17_pledge_call_member,
                   t17_pledge_call_ac_no,
                   t17_pledge_value,
                   t17_text,
                   t17_reject_reason,
                   t17_remaining_qty,
                   CASE
                       WHEN t17.t17_status IN (2, 3, 4) THEN 2
                       WHEN t17.t17_status = 1 THEN 1
                       WHEN t17.t17_status = 0 THEN 0
                   END
                       AS current_approval_level,
                   u07.u07_institute_id_m02,
                   t17_broker_vat,
                   t17_exchange_vat,
                   t17_charges,
                   CASE
                       WHEN t17_pledge_type = 'I' THEN 'SHAREPLEDGEIN'
                       WHEN t17_pledge_type = 'O' THEN 'SHAREPLEDGEOUT'
                   END
                       AS function_approval_name,
                   CASE
                       WHEN t17_pledge_type = 'I' THEN 8
                       WHEN t17_pledge_type = 'O' THEN 9
                       ELSE 0
                   END
                       AS function_approval_id,
                   CASE
                       WHEN t17.t17_status = 1
                       THEN
                           u17_created.new_employee_id
                   END
                       AS l1_by_new_id,
                   CASE WHEN t17.t17_status = 1 THEN t17_entered_date END
                       AS l1_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   CASE
                       WHEN t17.t17_status IN (2, 4)
                       THEN
                           u17_created.new_employee_id
                   END
                       AS l2_by_new_id,
                   CASE
                       WHEN t17.t17_status IN (2, 4) THEN t17_entered_date
                   END
                       AS l2_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   CASE
                       WHEN t17.t17_status = 3
                       THEN
                           u17_created.new_employee_id
                   END
                       AS rejected_by_new_id,
                   CASE WHEN t17.t17_status = 3 THEN t17_entered_date END
                       AS rejected_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   CASE WHEN t17.t17_status IN (2, 3, 4) THEN 1 ELSE 0 END
                       AS final_approval,
                   u07.u07_customer_id_u01,
                   m20.m20_id,
                   map15.map15_ntp_code,
                   t20_map.new_pending_pledg_id
              FROM mubasher_oms.t17_pending_pledge@mubasher_db_link t17,
                   mubasher_oms.t05_cash_account_log@mubasher_db_link t05,
                   map15_transaction_codes_m97 map15,
                   map16_optional_exchanges_m01 map16,
                   u07_trading_account_mappings u07_map,
                   dfn_ntp.u07_trading_account u07,
                   (SELECT m20_id, m20_symbol_code, m20_exchange_code_m01
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20,
                   dfn_ntp.v34_price_instrument_type v34,
                   u17_employee_mappings u17_created,
                   t20_pending_pledg_mappings t20_map
             WHERE     t17.t17_t05_id = t05.t05_id(+)
                   AND t05.t05_code = map15.map15_oms_code(+)
                   AND t17.t17_pledge_type NOT IN ('C', '1', '0') -- [Corrective Actions Discussed]
                   AND t17.t17_security_ac_id =
                           u07_map.old_trading_account_id(+)
                   AND t17.t17_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, t17.t17_exchange) =
                           u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id = u07.u07_id(+)
                   AND NVL (map16.map16_ntp_code, t17.t17_exchange) =
                           m20.m20_exchange_code_m01(+)
                   AND t17.t17_symbol = m20.m20_symbol_code(+)
                   AND t17.t17_instrument_type = v34.v34_price_inst_type_id
                   AND t17.t17_entered_by = u17_created.old_employee_id(+)
                   AND t17.t17_id = t20_map.old_pending_pledg_id(+))
    LOOP
        BEGIN
            IF i.m20_exchange_code_m01 IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF NOT REGEXP_LIKE (i.t17_transaction_number, '^[0-9]*$')
            THEN
                raise_application_error (-20001,
                                         'Invalid Transaction Number',
                                         TRUE);
            END IF;

            IF i.new_trading_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Trading Account Not Available',
                                         TRUE);
            END IF;

            IF i.m20_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Symbol Code Not Available',
                                         TRUE);
            END IF;

            IF i.pledge_type IS NULL
            THEN
                raise_application_error (-20001,
                                         'Pledge Type Not Available',
                                         TRUE);
            END IF;

            IF i.new_pending_pledg_id IS NULL
            THEN
                l_pledge_id :=
                    CASE
                        WHEN l_use_new_key = 0 THEN i.t17_id
                        ELSE l_pledge_id + 1
                    END;

                INSERT
                  INTO dfn_ntp.t20_pending_pledge (t20_id,
                                                   t20_trading_acc_id_u07,
                                                   t20_exchange,
                                                   t20_symbol,
                                                   t20_qty,
                                                   t20_instrument_type,
                                                   t20_last_changed_by_id_u17,
                                                   t20_last_changed_date,
                                                   t20_status_id_v01,
                                                   t20_send_to_exchange,
                                                   t20_send_to_exchange_result,
                                                   t20_pledge_type,
                                                   t20_transaction_number,
                                                   t20_pledgee,
                                                   t20_pledgor,
                                                   t20_pledgor_ac_no,
                                                   t20_nin,
                                                   t20_pledge_call_member,
                                                   t20_pledge_call_ac_no,
                                                   t20_pledge_value,
                                                   t20_narration,
                                                   t20_exchange_fee,
                                                   t20_broker_fee,
                                                   t20_reject_reason,
                                                   t20_remaining_qty,
                                                   t20_custodian_id,
                                                   t20_include_gl,
                                                   t20_current_approval_level,
                                                   t20_no_of_approval,
                                                   t20_institution_id,
                                                   t20_entered_date,
                                                   t20_entered_by_id_u17,
                                                   t20_reference_id_t06,
                                                   t20_exg_vat,
                                                   t20_brk_vat,
                                                   t20_pledge_txn_type,
                                                   t20_ref_no,
                                                   t20_final_approval,
                                                   t20_org_txn_id,
                                                   t20_customer_id_u01,
                                                   t20_symbol_id_m20,
                                                   t20_exg_discount,
                                                   t20_brk_discount,
                                                   t20_channel_id_v29,
                                                   t20_function_id_m88,
                                                   t20_code_m97,
                                                   t20_bfile_ref,
                                                   t20_narration_lang,
                                                   t20_ip)
                VALUES (l_pledge_id, -- t20_id
                        i.new_trading_account_id, -- t20_trading_acc_id_u07
                        i.m20_exchange_code_m01, -- t20_exchange
                        i.m20_symbol_code, -- t20_symbol
                        i.t17_qty, -- t20_qty
                        i.v34_inst_id_v09, -- t20_instrument_typ
                        i.created_by_new_id, -- t20_last_changed_date
                        i.created_date, -- t20_last_changed_by_id_u17
                        i.status_id, -- t20_status_id_v01
                        i.t17_send_to_exchange, -- t20_send_to_exchange
                        i.t17_send_to_exchange_result, -- t20_send_to_exchange_result
                        i.pledge_type, -- t20_pledge_type
                        i.t17_transaction_number, -- t20_transaction_number
                        i.t17_pledgee, -- t20_pledgee
                        i.t17_pledgor, -- t20_pledgor
                        i.t17_pledgor_ac_no, -- t20_pledgor_ac_no
                        i.t17_nin, -- t20_nin
                        i.t17_pledge_call_member, -- t20_pledge_call_member
                        i.t17_pledge_call_ac_no, -- t20_pledge_call_ac_no
                        i.t17_pledge_value, -- t20_pledge_value
                        i.t17_text, -- t20_narration
                        i.t17_charges, -- t20_exchange_fee | Discussed with Sandamal to Migrate Pledge Fee in to Exg. Fee
                        0, -- t20_broker_fee | Discussed with Sandamal to Migrate Broker Fee as 0
                        i.t17_reject_reason, -- t20_reject_reason
                        i.t17_remaining_qty, -- t20_remaining_qty
                        -1, -- t20_custodian_id | Update Later in this Script
                        NULL, -- t20_include_gl
                        i.current_approval_level, -- t20_current_approval_level
                        2, -- t20_no_of_approval
                        i.u07_institute_id_m02, -- t20_institution_id
                        i.created_date, -- t20_entered_date
                        i.created_by_new_id, -- t20_entered_by_id_u17
                        NULL, -- t20_reference_id_t06 | Not Available
                        i.t17_broker_vat, -- t20_exg_vat
                        i.t17_exchange_vat, -- t20_brk_vat
                        0, -- t20_pledge_txn_type | 0 - Single
                        NULL, --  t20_ref_no
                        i.final_approval,
                        NULL, -- t20_org_txn_id
                        i.u07_customer_id_u01, -- t20_customer_id_u01
                        i.m20_id, -- t20_symbol_id_m20
                        NULL, -- t20_exg_discount | Not Available
                        NULL, --t20_brk_discount | Not Available
                        NULL, -- t20_channel_id_v29 | Not Available
                        i.function_approval_id, -- t20_function_id_m88
                        i.map15_ntp_code, -- t20_code_m97
                        NULL, -- t20_bfile_ref | Not Available
                        i.t17_text, -- t20_narration_lang
                        NULL -- t20_ip | Not Available
                            );

                INSERT INTO dfn_mig.t20_pending_pledg_mappings
                     VALUES (i.t17_id, l_pledge_id);

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
                            l_pledge_id, -- a09_request_id
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
                            l_pledge_id, -- a09_request_id
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
                            l_pledge_id, -- a09_request_id
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
                            i.function_approval_id, -- a09_function_id_m88
                            i.function_approval_name, -- a09_function_name_m88
                            l_pledge_id, -- a09_request_id
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
                UPDATE dfn_ntp.t20_pending_pledge
                   SET t20_trading_acc_id_u07 = i.new_trading_account_id, -- t20_trading_acc_id_u07
                       t20_exchange = i.m20_exchange_code_m01, -- t20_exchange
                       t20_symbol = i.m20_symbol_code, -- t20_symbol
                       t20_qty = i.t17_qty, -- t20_qty
                       t20_instrument_type = i.v34_inst_id_v09, -- t20_instrument_typ
                       t20_last_changed_by_id_u17 =
                           NVL (i.created_by_new_id, 0), -- t20_last_changed_date
                       t20_last_changed_date = i.created_date, -- t20_last_changed_by_id_u17
                       t20_status_id_v01 = i.status_id, -- t20_status_id_v01
                       t20_send_to_exchange = i.t17_send_to_exchange, -- t20_send_to_exchange
                       t20_send_to_exchange_result =
                           i.t17_send_to_exchange_result, -- t20_send_to_exchange_result
                       t20_pledge_type = i.pledge_type, -- t20_pledge_type
                       t20_transaction_number = i.t17_transaction_number, -- t20_transaction_number
                       t20_pledgee = i.t17_pledgee, -- t20_pledgee
                       t20_pledgor = i.t17_pledgor, -- t20_pledgor
                       t20_pledgor_ac_no = i.t17_pledgor_ac_no, -- t20_pledgor_ac_no
                       t20_nin = i.t17_nin, -- t20_nin
                       t20_pledge_call_member = i.t17_pledge_call_member, -- t20_pledge_call_member
                       t20_pledge_call_ac_no = i.t17_pledge_call_ac_no, -- t20_pledge_call_ac_no
                       t20_pledge_value = i.t17_pledge_value, -- t20_pledge_value
                       t20_narration = i.t17_text, -- t20_narration
                       t20_exchange_fee = i.t17_charges, -- t20_exchange_fee | Discussed with Sandamal to Migrate Pledge Fee in to Exg. Fee
                       t20_broker_fee = 0, -- t20_broker_fee | Discussed with Sandamal to Migrate Broker Fee as 0
                       t20_reject_reason = i.t17_reject_reason, -- t20_reject_reason
                       t20_remaining_qty = i.t17_remaining_qty, -- t20_remaining_qty
                       t20_custodian_id = -1, -- t20_custodian_id | Update Later in this Script
                       t20_current_approval_level = i.current_approval_level, -- t20_current_approval_level
                       t20_institution_id = i.u07_institute_id_m02, -- t20_institution_id
                       t20_exg_vat = i.t17_broker_vat, -- t20_exg_vat
                       t20_brk_vat = i.t17_exchange_vat, -- t20_brk_vat
                       t20_final_approval = i.final_approval,
                       t20_customer_id_u01 = i.u07_customer_id_u01, -- t20_customer_id_u01
                       t20_symbol_id_m20 = i.m20_id, -- t20_symbol_id_m20
                       t20_function_id_m88 = i.function_approval_id, -- t20_function_id_m88
                       t20_code_m97 = i.map15_ntp_code, -- t20_code_m97
                       t20_narration_lang = i.t17_text -- t20_narration_lang
                 WHERE t20_id = i.new_pending_pledg_id;

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
                            i.new_pending_pledg_id, -- a09_request_id
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
                            i.new_pending_pledg_id, -- a09_request_id
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
                            i.function_approval_id, -- a09_function_id_m88
                            i.function_approval_name, -- a09_function_name_m88
                            i.new_pending_pledg_id, -- a09_request_id
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
                            i.function_approval_id, -- a09_function_id_m88
                            i.function_approval_name, -- a09_function_name_m88
                            i.new_pending_pledg_id, -- a09_request_id
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
                                'T20_PENDING_PLEDGE',
                                i.t17_id,
                                CASE
                                    WHEN i.new_pending_pledg_id IS NULL
                                    THEN
                                        l_pledge_id
                                    ELSE
                                        i.new_pending_pledg_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_pending_pledg_id IS NULL
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

-- Updating with Default Custodian

MERGE INTO dfn_ntp.t20_pending_pledge t20
     USING (SELECT t20.t20_id, m43.m43_custodian_id_m26
              FROM dfn_ntp.t20_pending_pledge t20,
                   dfn_ntp.m43_institute_exchanges m43
             WHERE     t20.t20_exchange = m43.m43_exchange_code_m01
                   AND t20.t20_institution_id = m43.m43_institute_id_m02) m43
        ON (t20.t20_id = m43.t20_id)
WHEN MATCHED
THEN
    UPDATE SET t20.t20_custodian_id = m43.m43_custodian_id_m26;

COMMIT;
