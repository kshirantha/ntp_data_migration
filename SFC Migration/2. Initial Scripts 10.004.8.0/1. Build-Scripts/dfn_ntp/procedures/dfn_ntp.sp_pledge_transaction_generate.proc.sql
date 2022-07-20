CREATE OR REPLACE 
PROCEDURE dfn_ntp.sp_pledge_transaction_generate (
    t09c t09_txn_single_entry_v3%ROWTYPE)
IS
BEGIN
    BEGIN
        INSERT INTO t20_pending_pledge (t20_id,
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
                                        t20_no_of_approval,
                                        t20_current_approval_level,
                                        t20_remaining_qty,
                                        t20_custodian_id,
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
                                        t20_bfile_ref)
             VALUES (t09c.t09_holding_txn_id,                         --t20_id
                     t09c.t09_trading_acc_id_u07,     --t20_trading_acc_id_u07
                     t09c.t09_exchange_m01,                     --t20_exchange
                     t09c.t09_symbol_code_m20,                    --t20_symbol
                     t09c.t09_quantity,                              --t20_qty
                     t09c.t09_instrument_type,           --t20_instrument_type
                     t09c.t09_approved_by_id_u17, --t20_last_changed_by_id_u17
                     SYSDATE,                          --t20_last_changed_date
                     2,                                    --t20_status_id_v01
                     0,                                 --t20_send_to_exchange
                     0,                          --t20_send_to_exchange_result
                     CASE WHEN t09c.t09_txn_code = 'PLGIN' THEN 8 ELSE 9 END, --t20_pledge_type
                     t09c.t09_holding_txn_id,         --t20_transaction_number
                     null,                                         --t20_pledgee
                     null,                                         --t20_pledgor
                     null,                                   --t20_pledgor_ac_no
                     null,                                             --t20_nin
                     null,                              --t20_pledge_call_member
                     null,                               --t20_pledge_call_ac_no
                     0,                                     --t20_pledge_value
                     t09c.t09_narration,                       --t20_narration
                     t09c.t09_exchange_fee,                 --t20_exchange_fee
                     t09c.t09_broker_fee,                     --t20_broker_fee
                     t09c.t09_reject_reason,               --t20_reject_reason
                     t09c.t09_no_of_approval,             --t20_no_of_approval
                     t09c.t09_current_approval_level, --t20_current_approval_level
                     t09c.t09_quantity,                    --t20_remaining_qty
                     t09c.t09_custodian_id_m26,             --t20_custodian_id
                     t09c.t09_institution_id_m02,         --t20_institution_id
                     SYSDATE,                               --t20_entered_date
                     t09c.t09_approved_by_id_u17,      --t20_entered_by_id_u17
                     0,                              --t20_reference_id_t06
                     t09c.t09_exchange_tax,          --t20_exg_vat
                     t09c.t09_broker_tax,                --t20_brk_vat
                     0,                                  --t20_pledge_txn_type
                     t09c.t09_txn_refrence_id,            --t20_ref_no
                     t09c.t09_final_approval,             --t20_final_approval
                     t09c.t09_origin_txn_id,                  --t20_org_txn_id
                     t09c.t09_customer_id_u01,           --t20_customer_id_u01
                     t09c.t09_symbol_id_m20,               --t20_symbol_id_m20
                     0,                                     --t20_exg_discount
                     0,                                     --t20_brk_discount
                     t09c.t09_channel_id_v29,             --t20_channel_id_v29
                     t09c.t09_function_id_m88,           --t20_function_id_m88
                     t09c.t09_txn_code,                         --t20_code_m97
                     t09c.t09_master_ref                        --t20_bulk_ref
                                        );
        --------------- UPDATE REMAINING QUANTITY IN PLEDGE IN ENTRY ------------------------------------------
        IF t09c.t09_txn_code = 'PLGOUT'
        THEN
            UPDATE t20_pending_pledge t20
               SET t20.t20_remaining_qty =
                       t20.t20_remaining_qty - t09c.t09_quantity
             WHERE t20.t20_id = t09c.t09_origin_txn_id;
        END IF;
    END;
END;
/
