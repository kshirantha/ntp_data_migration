DECLARE
    l_stk_blk_rqst_id   NUMBER;
    l_sqlerrm           VARCHAR2 (4000);
    l_log_id            NUMBER;
BEGIN
    SELECT NVL (MAX (t67_id), 0)
      INTO l_stk_blk_rqst_id
      FROM dfn_ntp.t67_stock_block_request;

    SELECT NVL (MAX (a09_id), 0)
      INTO l_log_id
      FROM dfn_ntp.a09_function_approval_log;

    DELETE FROM error_log
          WHERE mig_table = 'T67_STOCK_BLOCK_REQUEST';

    FOR i
        IN (SELECT t78.t78_id,
                   u07_map.new_trading_account_id,
                   t78.t78_quantity_block,
                   t78.t78_reason_for_block,
                   map01.map01_ntp_id,
                   CASE t78.t78_type
                       WHEN 1
                       THEN
                           map01.map01_ntp_id -- T78_TYPE = 1 Block (Staus is Same as Old)
                       WHEN 2
                       THEN
                           CASE map01.map01_ntp_id WHEN 2 THEN 5 ELSE 2 END -- T78_TYPE = 2 Release (If Status is APPROVED then DELETED Otherwise Always APPROVED)
                   END
                       AS status_id,
                   NVL (u17_created_by.new_employee_id, 0) AS created_by,
                   t78.t78_created_date AS created_date,
                   u17_modified_by.new_employee_id AS last_updated_by,
                   t78.t78_modified_date AS last_updated_date,
                   u07.u07_institute_id_m02,
                   m20.m20_id,
                   m20.m20_symbol_code,
                   NVL (map16.map16_ntp_code, t78.t78_exchange) AS exchange,
                   CASE t78.t78_type
                       WHEN 1
                       THEN
                           0 -- T78_TYPE = 1 Block (Delete Staus 0 Always)
                       WHEN 2
                       THEN
                           CASE map01_ntp_id -- T78_TYPE = 2 Release
                               WHEN 1 THEN 200 -- PENDING => REQUESTED FOR DELETE (200)
                               WHEN 101 THEN 201 -- APPROVED L1 => DELETE L1 (201)
                               WHEN 2 THEN 5 -- APPROVED => DELETE (5)
                               ELSE map01_ntp_id
                           END
                   END
                       AS delete_status,
                   CASE -- Considering Both Stock Blocks and Releases Possible Values for MAP01_NTP_ID => (1, 101, 2, 3)
                       WHEN map01_ntp_id = 1 THEN 0
                       WHEN map01_ntp_id = 101 THEN 1
                       WHEN map01_ntp_id IN (2, 3) THEN 2
                   END
                       AS current_approval_level,
                   CASE WHEN map01_ntp_id IN (2, 3) THEN 1 ELSE 0 END -- Considering Both Stock Blocka and Releases Possible Values for MAP01_NTP_ID => (1, 101, 2, 3)
                       AS is_approval_completed,
                   CASE
                       WHEN t78.t78_type = 1 -- T78_TYPE = 1 Block (Delete Staus 0 Always)
                       THEN
                           CASE map01_ntp_id
                               WHEN 1 THEN 101
                               WHEN 101 THEN 2
                               WHEN 2 THEN 5
                           END
                       WHEN t78.t78_type = 2 -- T78_TYPE = 2 Release
                       THEN
                           CASE map01_ntp_id
                               WHEN 1 THEN 201 -- APPROVED L1 => DELETE L1 (201)
                               WHEN 101 THEN 5 -- APPROVED => DELETE (5)
                           END
                   END
                       AS next_status_id_v01,
                   m43.m43_custodian_id_m26,
                   t67_map.new_stk_blk_rqst_id
              FROM mubasher_oms.t78_holdings_block@mubasher_db_link t78,
                   map16_optional_exchanges_m01 map16,
                   u07_trading_account_mappings u07_map,
                   dfn_ntp.u07_trading_account u07,
                   dfn_ntp.m20_symbol m20,
                   dfn_ntp.m43_institute_exchanges m43,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created_by,
                   u17_employee_mappings u17_modified_by,
                   t67_stk_blk_rqst_mappings t67_map
             WHERE     t78.t78_security_ac_id =
                           u07_map.old_trading_account_id
                   AND t78.t78_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, t78.t78_exchange) =
                           u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id = u07.u07_id
                   AND t78.t78_symbol = m20.m20_symbol_code
                   AND t78.t78_exchange = m20.m20_exchange_code_m01
                   AND t78.t78_exchange = m43.m43_exchange_code_m01
                   AND u07.u07_institute_id_m02 = m43.m43_institute_id_m02
                   AND t78.t78_status_id = map01.map01_oms_id
                   AND t78.t78_created_by = u17_created_by.old_employee_id(+)
                   AND t78.t78_modified_by =
                           u17_modified_by.old_employee_id(+)
                   AND t78.t78_id = t67_map.old_stk_blk_rqst_id(+))
    LOOP
        BEGIN
            IF i.exchange IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.new_stk_blk_rqst_id IS NULL
            THEN
                l_stk_blk_rqst_id := l_stk_blk_rqst_id + 1;

                INSERT
                  INTO dfn_ntp.t67_stock_block_request (
                           t67_id,
                           t67_trading_account_id_u07,
                           t67_qty_blocked,
                           t67_from_date,
                           t67_to_date,
                           t67_reason_for_block,
                           t67_status_id_v01,
                           t67_created_date,
                           t67_created_by_id_u17,
                           t67_last_updated_date,
                           t67_last_updated_by_id_u17,
                           t67_custom_type,
                           t67_institute_id_m02,
                           t67_symbol_id_m20,
                           t67_symbol_code_m20,
                           t67_exchange_code_m01,
                           t67_custodian_id_m26,
                           t67_no_of_approval,
                           t67_is_approval_completed,
                           t67_current_approval_level,
                           t67_next_status_id_v01,
                           t67_delete_status_id_v01,
                           t67_comment)
                VALUES (l_stk_blk_rqst_id, -- t67_id
                        i.new_trading_account_id, -- t67_trading_account_id_u07
                        i.t78_quantity_block, -- t67_qty_blocked
                        NULL, -- t67_from_date
                        NULL, -- t67_to_date | Not Available
                        i.t78_reason_for_block, -- t67_reason_for_block
                        i.status_id, -- t67_status_id_v01
                        i.created_date, -- t67_created_date
                        i.created_by, -- t67_created_by_id_u17
                        i.last_updated_date, -- t67_last_updated_date
                        i.last_updated_by, -- t67_last_updated_by_id_u17
                        '1', -- t67_custom_type
                        i.u07_institute_id_m02, -- t67_institute_id_m02
                        i.m20_id, -- t67_symbol_id_m20
                        i.m20_symbol_code, -- t67_symbol_code_m20
                        i.exchange, -- t67_exchange_code_m01
                        i.m43_custodian_id_m26, -- t67_custodian_id_m26
                        2, -- t67_no_of_approval
                        i.is_approval_completed, -- t67_is_approval_completed
                        i.current_approval_level, -- t67_current_approval_level
                        i.next_status_id_v01, -- t67_next_status_id_v01
                        i.delete_status, -- t67_delete_status_id_v01
                        NULL -- t67_comment | Not Available
                            );

                INSERT
                  INTO t67_stk_blk_rqst_mappings (old_stk_blk_rqst_id,
                                                  new_stk_blk_rqst_id)
                VALUES (i.t78_id, l_stk_blk_rqst_id);

                IF i.created_by IS NOT NULL
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
                            24, -- a09_function_id_m88
                            'STOCKBLOCK', -- a09_function_name_m88
                            l_stk_blk_rqst_id, -- a09_request_id
                            1, -- a09_status_id_v01
                            i.created_by, -- a09_action_by_id_u17
                            i.created_date, -- a09_action_date
                            i.created_by, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Pending', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;

                IF i.map01_ntp_id = 101 AND i.last_updated_by IS NOT NULL
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
                    VALUES (
                               l_log_id, -- a09_id
                               24, -- a09_function_id_m88
                               'STOCKBLOCK', -- a09_function_name_m88
                               l_stk_blk_rqst_id, -- a09_request_id
                               CASE
                                   WHEN i.delete_status = 0 THEN 101 -- Block
                                   ELSE 201 -- Release
                               END, -- a09_status_id_v01
                               i.last_updated_by, -- a09_action_by_id_u17
                               i.last_updated_date, -- a09_action_date
                               i.created_by, -- a09_created_by_id_u17
                               i.created_date, -- a09_created_date
                               'Pending Approve', -- a09_narration
                               NULL, -- a09_reject_reason
                               '1' -- a09_custom_type
                                  );
                END IF;

                IF i.map01_ntp_id = 2 AND i.last_updated_by IS NOT NULL
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
                            24, -- a09_function_id_m88
                            'STOCKBLOCK', -- a09_function_name_m88
                            l_stk_blk_rqst_id, -- a09_request_id
                            CASE WHEN i.delete_status = 0 THEN 2 -- Block
                                                                ELSE 5 -- Release
                                                                      END, -- a09_status_id_v01
                            i.last_updated_by, -- a09_action_by_id_u17
                            i.last_updated_date, -- a09_action_date
                            i.created_by, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Approved', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;

                IF i.map01_ntp_id = 3 AND i.last_updated_by IS NOT NULL
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
                            24, -- a09_function_id_m88
                            'STOCKBLOCK', -- a09_function_name_m88
                            l_stk_blk_rqst_id, -- a09_request_id
                            3, -- a09_status_id_v01
                            i.last_updated_by, -- a09_action_by_id_u17
                            i.last_updated_date, -- a09_action_date
                            i.created_by, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Rejected', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;
            ELSE
                UPDATE dfn_ntp.t67_stock_block_request
                   SET t67_trading_account_id_u07 = i.new_trading_account_id, -- t67_trading_account_id_u07
                       t67_qty_blocked = i.t78_quantity_block, -- t67_qty_blocked
                       t67_from_date = i.created_date, -- t67_from_date
                       t67_to_date = NULL, -- t67_to_date
                       t67_reason_for_block = i.t78_reason_for_block, -- t67_reason_for_block
                       t67_status_id_v01 = i.map01_ntp_id, -- t67_status_id_v01
                       t67_created_date = i.created_date, -- t67_created_date
                       t67_created_by_id_u17 = i.created_by, -- t67_created_by_id_u17
                       t67_last_updated_date = i.last_updated_date, -- t67_last_updated_date
                       t67_last_updated_by_id_u17 = i.last_updated_by, -- t67_last_updated_by_id_u17
                       t67_institute_id_m02 = i.u07_institute_id_m02, -- t67_institute_id_m02
                       t67_symbol_id_m20 = i.m20_id, -- t67_symbol_id_m20
                       t67_symbol_code_m20 = i.m20_symbol_code, -- t67_symbol_code_m20
                       t67_exchange_code_m01 = i.exchange, -- t67_exchange_code_m01
                       t67_custodian_id_m26 = i.m43_custodian_id_m26, -- -- t67_custodian_id_m26
                       t67_is_approval_completed = i.is_approval_completed, -- t67_is_approval_completed
                       t67_current_approval_level = i.current_approval_level, -- t67_current_approval_level
                       t67_next_status_id_v01 = i.next_status_id_v01, -- t67_next_status_id_v01
                       t67_delete_status_id_v01 = i.delete_status -- t67_delete_status_id_v01
                 WHERE t67_id = i.new_stk_blk_rqst_id;

                IF i.map01_ntp_id = 1 AND i.last_updated_by IS NOT NULL
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
                            24, -- a09_function_id_m88
                            'STOCKBLOCK', -- a09_function_name_m88
                            i.new_stk_blk_rqst_id, -- a09_request_id
                            1, -- a09_status_id_v01
                            i.last_updated_by, -- a09_action_by_id_u17
                            i.last_updated_date, -- a09_action_date
                            i.created_by, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Pending', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;

                IF i.map01_ntp_id = 101 AND i.last_updated_by IS NOT NULL
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
                    VALUES (
                               l_log_id, -- a09_id
                               24, -- a09_function_id_m88
                               'STOCKBLOCK', -- a09_function_name_m88
                               i.new_stk_blk_rqst_id, -- a09_request_id
                               CASE
                                   WHEN i.delete_status = 0 THEN 101 -- Block
                                   ELSE 201 -- Release
                               END, -- a09_status_id_v01
                               i.last_updated_by, -- a09_action_by_id_u17
                               i.last_updated_date, -- a09_action_date
                               i.created_by, -- a09_created_by_id_u17
                               i.created_date, -- a09_created_date
                               'Pending Approve', -- a09_narration
                               NULL, -- a09_reject_reason
                               '1' -- a09_custom_type
                                  );
                END IF;

                IF i.map01_ntp_id = 2 AND i.last_updated_by IS NOT NULL
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
                            24, -- a09_function_id_m88
                            'STOCKBLOCK', -- a09_function_name_m88
                            i.new_stk_blk_rqst_id, -- a09_request_id
                            CASE WHEN i.delete_status = 0 THEN 2 -- Block
                                                                ELSE 5 -- Release
                                                                      END, -- a09_status_id_v01
                            i.last_updated_by, -- a09_action_by_id_u17
                            i.last_updated_date, -- a09_action_date
                            i.created_by, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Approved', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;

                IF i.map01_ntp_id = 3 AND i.last_updated_by IS NOT NULL
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
                            24, -- a09_function_id_m88
                            'STOCKBLOCK', -- a09_function_name_m88
                            i.new_stk_blk_rqst_id, -- a09_request_id
                            3, -- a09_status_id_v01
                            i.last_updated_by, -- a09_action_by_id_u17
                            i.last_updated_date, -- a09_action_date
                            i.created_by, -- a09_created_by_id_u17
                            i.created_date, -- a09_created_date
                            'Rejected', -- a09_narration
                            NULL, -- a09_reject_reason
                            '1' -- a09_custom_type
                               );
                END IF;

                NULL;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T67_STOCK_BLOCK_REQUEST',
                                i.t78_id,
                                CASE
                                    WHEN i.new_stk_blk_rqst_id IS NULL
                                    THEN
                                        l_stk_blk_rqst_id
                                    ELSE
                                        i.new_stk_blk_rqst_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_stk_blk_rqst_id IS NULL
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