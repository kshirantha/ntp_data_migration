CREATE OR REPLACE PROCEDURE dfn_ntp.sp_redist_algo_order_generate (

    t09c    t09_txn_single_entry_v3%ROWTYPE)
IS
BEGIN
    BEGIN
        MERGE INTO dfn_ntp.t54_slice_orders t
         USING (SELECT *
                  FROM (SELECT t09c.t09_db_seq_id,
                               t09c.t09_audit_key,
                               t09c.t09_ord_type_v06,
                               t09c.t09_institution_id_m02,
                               t09c.t09_customer_id_u01,
                               t09c.t09_remarks,
                               t09c.t09_last_updated_time,
                               t09c.t09_quantity,
                               t09c.t09_clordid,
                               t09c.t09_clordid_orig,
                               t09c.t09_ordid,
                               t09c.t09_custodian_id_m26,
                               t09c.t09_ord_value,
                               t09c.t09_ord_netvalue,
                               t09c.t09_exchange_m01,
                               t09c.t09_narration,
                               t09c.t09_trading_acc_id_u07,
                               t09c.t09_created_time,
                               t09c.t09_last_price,
                               t09c.t09_avg_price,
                               t09c.t09_last_shares,
                               t09c.t09_cum_qty,
                               t09c.t09_tenant_code,
                               t09c.t09_txntime,
                               t09c.t09_symbol_code_m20,
                               t09c.t09_dealer_id_u18,
                               t09c.t09_symbol_id_m20,
                               t09c.t09_ord_no,
                               t09c.t09_remote_clordid,
                               t09c.t09_remote_orig_clordid,
                               t09c.t09_created_date,
                               t09c.t09_disclosed_qty,
                               t09c.t09_instruction_type,
                               t09c.t09_commisn_discount,
                               t09c.t09_exp_date,
                               t09c.t09_cum_exec_brk_commisn,
                               t09c.t09_cum_accrd_intrst,
                               t09c.t09_exec_brkr_id_m26,
                               t09c.t09_holding_blk_manual,
                               t09c.t09_position_effect,
                               t09c.t09_remote_sub_comp_id,
                               t09c.t09_remote_tag_22,
                               t09c.t09_remote_tag_100,
                               t09c.t09_remote_sid,
                               t09c.t09_txn_currency_m03,
                               t09c.t09_txlogid,
                               t09c.t09_netholding_orig,
                               t09c.t09_avg_cost_orig,
                               t09c.t09_extnl_ref,
                               t09c.t09_gain_loss,
                               t09c.t09_cust_beneficiary_acc_u08,
                               t09c.t09_customer_no_u01,
                               t09c.t09_instrument_type,
                               t09c.t09_ord_blk,
                               t09c.t09_ord_status_v30,
                               t09c.t09_channel_id_v29,
                               t09c.t09_display_name,
                               t09c.t09_app_server_id,
                               t09c.t09_cash_payable_blk,
                               t09c.t09_cash_receivable_amnt,
                               t09c.t09_pending_deposit,
                               t09c.t09_pending_deposit_orig,
                               t09c.t09_pending_withdraw,
                               t09c.t09_pending_withdraw_orig,
                               t09c.t09_txn_code,
                               t09c.t09_market_code_m29,
                               t09c.t09_db_created_time,
                               t09c.t09_tnsfer_paymethod,
                               t09c.t09_reject_reason,
                               t09c.t09_commisn_this_execution,
                               t09c.t09_holding_net_diff,
                               t09c.t09_holding_blk_diff,
                               t09c.t09_online_login_id_u09,
                               t09c.t09_ord_mode,
                               t09c.t09_fix_msg_type,
                               t09c.t09_price_inst_type,
                               t09c.t09_brker_fix_id,
                               t09c.t09_trading_acntno_u07,
                               t09c.t09_is_active_order,
                               t09c.t09_fail_mngmnt_status,
                               t09c.t09_fail_mngmnt_clord_id,
                               t09c.t09_fail_mngmnt_exec_id,
                               t09c.t09_profit_loss,
                               t09c.t09_profit_loss_this_exec,
                               t09c.t09_broker_tax,
                               t09c.t09_exchange_tax,
                               t09c.t09_cum_broker_tax,
                               t09c.t09_cum_exchange_tax,
                               t09c.t09_act_broker_tax,
                               t09c.t09_act_exchange_tax,
                               t09c.t09_cum_act_broker_tax,
                               t09c.t09_cum_act_exchange_tax,
                               t09c.t09_wfa_current_level,
                               t09c.t09_ib_commission,
                               t09c.t09_cum_ib_commission,
                               t09c.t09_custodian_type_v01,
                               t09c.t09_exec_instruction,
                               t09c.t09_internal_order_status_v30,
                               t09c.t09_cum_child_qty,
                               t09c.t09_desk_order_type,
                               t09c.t09_cumord_netsettle,
                               t09c.t09_thirdparty_mre, --t09c.t09_thirdparty_mre
                               t09c.t09_algorithm_id,  --t09c.t09_algorithm_id
                               t09c.t09_algo_start_time, --t09c.t09_Algo_Start_Time
                               t09c.t09_algo_end_time, --t09c.t09_Algo_End_Time
                               t09c.t09_participation_perc, --t09c.t09_Participation_Perc
                               t09c.t09_min_order_amount, --t09c.t09_Min_Order_Amount
                               t09c.t09_behind_perc,    --t09c.t09_Behind_Perc
                               t09c.t09_kickoff_perc,  --t09c.t09_kickoff_Perc
                               t09c.t09_aggressive_chase, --t09c.t09_Aggressive_Chase
                               t09c.t09_shadowing_depth, --t09c.t09_Shadowing_Depth
                               t09c.t09_opening,            --t09c.t09_Opening
                               t09c.t09_closing,            --t09c.t09_Closing
                               t09c.t09_waves,                --t09c.t09_Waves
                               t09c.t09_would_price,    --t09c.t09_Would_Price
                               t09c.t09_perc_at_open,  --t09c.t09_Perc_At_Open
                               t09c.t09_perc_at_close, --t09c.t09_Perc_At_Close
                               t09c.t09_style,                --t09c.t09_Style
                               t09c.t09_slices,              --t09c.t09_Slices
                               t09c.t09_strategy_status,
                               t09c.t09_condition,        --t09c.t09_condition
                               t09c.t09_trig_interval, --t09c.t09_Trig_Interval
                               t09c.t09_interval_type, --t09c.t09_Interval_Type
                               t09c.t09_max_percentage_vol, --t09c.t09_Max_Percentage_Vol
                               t09c.t09_would_level,    --t09c.t09_Would_Level
                               t09c.t09_would_condition, --t09c.t09_Would_Condition
                               t09c.t09_price,          --t09c.t09_Limit_Price
                               t09c.t09_limit_condition, --t09c.t09_Limit_Condition
                               t09c.t09_max_orders,      --t09c.t09_Max_Orders
                               t09c.t09_renewal_percentage,
                               t09c.t09_inst_service_id, --t09c.t09_inst_service_id
                               t09c.t09_exec_type,        --t09c.t09_Exec_Type
                               t09c.t09_ord_qty_sent,
                               t09c.t09_accumulate_volume, --t09c.t09_Accumulate_Volume
                               t09c.t09_close_simulation,
                               t09c.t09_desk_order_no_t52,
                               t09c.t09_desk_order_ref_t52,
                               t09c.t09_tif_m58,
                               t09c.t09_block_size,
                               t09c.t09_start_time
                          FROM DUAL)) s
            ON (t.t54_ordid = s.t09_clordid)
        WHEN MATCHED
        THEN
            UPDATE SET
                t.t54_cum_ordnetvalue = s.t09_cumord_netsettle,
                t.t54_order_status = s.t09_ord_status_v30,
                t.t54_ord_reject_reason = s.t09_reject_reason
        WHEN NOT MATCHED
        THEN
            INSERT (t54_ordid,
                    t54_inst_service_id,
                    t54_exec_type,
                    t54_ord_qty_sent,
                    t54_ord_qty_filled,
                    t54_ord_qty_part_filled,
                    t54_portfoliono,
                    t54_user_id,
                    t54_ord_reject_reason,
                    t54_exchange,
                    t54_symbol,
                    t54_instrument_type,
                    t54_order_no,
                    t54_create_date,
                    t54_expired_date,
                    t54_start_time,
                    t54_ord_qty,
                    t54_order_status,
                    t54_block_size,
                    t54_order,
                    t54_condition,
                    t54_trig_interval,
                    t54_interval_type,
                    t54_max_percentage_vol,
                    t54_would_level,
                    t54_would_condition,
                    t54_limit_price,
                    t54_limit_condition,
                    t54_max_orders,
                    t54_renewal_percentage,
                    t54_routingac,
                    t54_customer_id,
                    t54_mubasher_no,
                    t54_thirdparty_mre,
                    t54_algorithm_id,
                    t54_algo_start_time,
                    t54_algo_end_time,
                    t54_participation_perc,
                    t54_min_order_amount,
                    t54_behind_perc,
                    t54_kickoff_perc,
                    t54_aggressive_chase,
                    t54_shadowing_depth,
                    t54_opening,
                    t54_closing,
                    t54_waves,
                    t54_would_price,
                    t54_perc_at_open,
                    t54_perc_at_close,
                    t54_style,
                    t54_slices,
                    t54_strategy_status,
                    t54_orig_ord_id,
                    t54_accumulate_volume,
                    t54_close_simulation,
                    t54_custodian_inst_id,
                    t54_exec_broker_inst,
                    t54_timeinforce,
                    t54_desk_order_ref,
                    t54_desk_order_number,
                    t54_channel,
                    t54_institution_id_m02,
                    t54_symbol_id_m20)
            VALUES (
                       t09_clordid,
                       t09_inst_service_id,              --t09_inst_service_id
                       t09_exec_type,                          --t09_Exec_Type
                       t09_ord_qty_sent,                    --t09_Ord_Qty_Sent
                       t09_cum_qty,                       --t09_Ord_Qty_Filled
                       t09_last_shares,              --t09_Ord_Qty_Part_Filled
                       s.t09_trading_acntno_u07,
                       1,                                        --t09_User_Id
                       t09_reject_reason,              --t09_Ord_Reject_Reason
                       t09_exchange_m01,
                       t09_symbol_code_m20,
                       t09_instrument_type,
                       t09_ord_no,
                       NULL,               --TO_TIMESTAMP (s.t09_created_time,
                       --              'YYYYMMDDHH24MISS')
                       NVL (TO_DATE (s.t09_exp_date, 'YYYYMMDD'),
                            TO_DATE ('99991201', 'YYYYMMDD')),
                       t09_start_time,                        --t09_Start_Time
                       TO_NUMBER (s.t09_quantity),
                       t09_ord_status_v30,
                       t09_block_size,                        --t09_Block_Size
                       NULL,                                       --t09_order
                       t09_condition,                          --t09_condition
                       t09_trig_interval,                  --t09_Trig_Interval
                       t09_interval_type,                  --t09_Interval_Type
                       t09_max_percentage_vol,        --t09_Max_Percentage_Vol
                       t09_would_level,                      --t09_Would_Level
                       t09_would_condition,              --t09_Would_Condition
                       t09_price,
                       t09_limit_condition,              --t09_Limit_Condition
                       t09_max_orders,                        --t09_Max_Orders
                       t09_renewal_percentage,        --t09_Renewal_Percentage
                       t09_trading_acntno_u07,
                       t09_customer_id_u01,
                       NULL,                                 --t09_mubasher_no
                       t09_thirdparty_mre,                --t09_thirdparty_mre
                       t09_algorithm_id,                    --t09_algorithm_id
                       t09_algo_start_time,              --t09_Algo_Start_Time
                       t09_algo_end_time,                  --t09_Algo_End_Time
                       t09_participation_perc,        --t09_Participation_Perc
                       t09_min_order_amount,            --t09_Min_Order_Amount
                       t09_behind_perc,                      --t09_Behind_Perc
                       t09_kickoff_perc,                    --t09_kickoff_Perc
                       t09_aggressive_chase,            --t09_Aggressive_Chase
                       t09_shadowing_depth,              --t09_Shadowing_Depth
                       t09_opening,                              --t09_Opening
                       t09_closing,                              --t09_Closing
                       t09_waves,                                  --t09_Waves
                       t09_would_price,                      --t09_Would_Price
                       t09_perc_at_open,                    --t09_Perc_At_Open
                       t09_perc_at_close,                  --t09_Perc_At_Close
                       t09_style,                                  --t09_Style
                       t09_slices,                                --t09_Slices
                       t09_strategy_status,              --t09_Strategy_Status
                       t09_clordid_orig,
                       t09_accumulate_volume,          --t09_Accumulate_Volume
                       t09_close_simulation,            --t09_Close_Simulation
                       TO_NUMBER (s.t09_custodian_id_m26),
                       TO_NUMBER (s.t09_exec_brkr_id_m26),
                       t09_tif_m58,                           --t09TimeInForce
                       t09_desk_order_ref_t52,               --t09DeskOrderRef
                       t09_desk_order_no_t52,                 --t09DeskOrderNo
                       t09_channel_id_v29,
                       t09_institution_id_m02,
                       t09_symbol_id_m20);

        IF (    t09c.t09_clordid_orig IS NOT NULL
            AND t09c.t09_orig_ord_status_v30 IS NOT NULL)
        THEN
            UPDATE t54_slice_orders t54
               SET t54.t54_order_status = t09c.t09_orig_ord_status_v30
             WHERE t54.t54_ordid = t09c.t09_clordid_orig;
        END IF;

        IF (    t09c.t09_desk_order_ref_t52 IS NOT NULL
            AND t09c.t09_desk_order_ref_t52 > 0)
        THEN
            UPDATE t52_desk_orders t
               SET t.t52_cum_child_qty = t09c.t09_cum_child_qty,
                   t.t52_last_updated_date = SYSDATE
             WHERE t.t52_order_id = t09c.t09_desk_order_ref_t52;
        END IF;
    END;
END;                                                              -- Procedure
/