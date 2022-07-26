CREATE OR REPLACE PROCEDURE dfn_ntp.sp_redist_desk_order_generate (
    t09c t09_txn_single_entry_v3%ROWTYPE)
IS
BEGIN
    BEGIN
        MERGE INTO dfn_ntp.t52_desk_orders t
             USING (SELECT *
                      FROM (SELECT t09c.t09_db_seq_id,
                                   t09c.t09_audit_key,
                                   t09c.t09_cash_blk,
                                   t09c.t09_holding_net,
                                   t09c.t09_holding_blk,
                                   t09c.t09_holding_paybale,
                                   t09c.t09_holding_receivable,
                                   t09c.t09_sell_pending,
                                   t09c.t09_buy_pending,
                                   t09c.t09_weighted_avgprice,
                                   t09c.t09_weighted_avgcost,
                                   t09c.t09_ord_type_v06,
                                   t09c.t09_institution_id_m02,
                                   t09c.t09_commission_orig,
                                   t09c.t09_fxrate,
                                   t09c.t09_settle_currency_m03,
                                   t09c.t09_poa_id_u47,
                                   t09c.t09_customer_id_u01,
                                   t09c.t09_remarks,
                                   t09c.t09_last_updated_time,
                                   t09c.t09_price,
                                   t09c.t09_quantity,
                                   t09c.t09_side,
                                   t09c.t09_clordid,
                                   t09c.t09_clordid_orig,
                                   t09c.t09_ordid,
                                   t09c.t09_custodian_id_m26,
                                   t09c.t09_ord_value,
                                   t09c.t09_ord_netvalue,
                                   t09c.t09_commission,
                                   t09c.t09_ord_netsettle,
                                   t09c.t09_exec_brk_commission,
                                   t09c.t09_exchange_m01,
                                   t09c.t09_narration,
                                   t09c.t09_cashacnt_id_u06,
                                   t09c.t09_trading_acc_id_u07,
                                   t09c.t09_minfil_qty,
                                   t09c.t09_netvalue_this_execution,
                                   t09c.t09_netsettle_this_execution,
                                   t09c.t09_ordvalue_this_execution,
                                   t09c.t09_created_time,
                                   t09c.t09_execid,
                                   t09c.t09_last_price,
                                   t09c.t09_avg_price,
                                   t09c.t09_trade_match_id,
                                   t09c.t09_ord_netsettle_diff,
                                   t09c.t09_cumord_value,
                                   t09c.t09_cumord_netvalue,
                                   t09c.t09_cumord_netsettle,
                                   t09c.t09_last_shares,
                                   t09c.t09_leaves_qty,
                                   t09c.t09_cum_qty,
                                   t09c.t09_holding_avg_cost,
                                   t09c.t09_cum_commission,
                                   t09c.t09_cash_settle_date,
                                   t09c.t09_holding_settle_date,
                                   t09c.t09_tenant_code,
                                   t09c.t09_lockseq,
                                   t09c.t09_accrd_intrst_diff,
                                   t09c.t09_txntime,
                                   t09c.t09_symbol_code_m20,
                                   t09c.t09_dealer_id_u18,
                                   t09c.t09_accurd_intrst,
                                   t09c.t09_cash_balance_orig,
                                   t09c.t09_symbol_id_m20,
                                   t09c.t09_cash_balance,
                                   t09c.t09_cash_blk_orig,
                                   t09c.t09_cash_blk_diff,
                                   t09c.t09_cash_payable_orig,
                                   t09c.t09_cash_receivable_orig,
                                   t09c.t09_cash_open_buy_blk,
                                   t09c.t09_cash_open_buy_blk_orig,
                                   t09c.t09_pre_ord_cum_value,
                                   t09c.t09_pre_ord_qty,
                                   t09c.t09_pre_ord_cum_commisn,
                                   t09c.t09_commisn_diff,
                                   t09c.t09_holding_entry_key,
                                   t09c.t09_ord_no,
                                   t09c.t09_remote_clordid,
                                   t09c.t09_remote_orig_clordid,
                                   t09c.t09_created_date,
                                   t09c.t09_disclosed_qty,
                                   t09c.t09_tif_m58,
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
								   t09c.t09_board_code_m54,
                                   t09c.t09_exchange_id_m01
                              FROM DUAL)) s
                ON (t.t52_order_id = s.t09_clordid)
        WHEN MATCHED
        THEN
            UPDATE SET
                t.t52_cum_netsettle = s.t09_cumord_netsettle,
                t.t52_avgcost = s.t09_holding_avg_cost,
                t.t52_internall_order_status = s.t09_internal_order_status_v30,
                t.t52_cum_child_qty = s.t09_cum_child_qty,
                t.t52_last_updated_date = SYSDATE,
                t.t52_status_id_v30 = s.t09_ord_status_v30,
                t.t52_text = s.t09_reject_reason
        WHEN NOT MATCHED
        THEN
            INSERT     (t52_order_id,
                        t52_orig_order_id,
                        t52_orderno,
                        t52_customer_id_u01,
                        t52_trading_acc_id_u07,
                        t52_trading_acntno_u07,
                        t52_tenant_code,
                        t52_cash_acc_id_u06,
                        t52_channel_id_v29,
                        t52_exchange_code_m01,
                        t52_symbol_code_m20,
                        t52_ord_type_id_v06,
                        t52_side,
                        t52_quantity,
                        t52_price,
                        t52_avgpx,
                        t52_tif_id_v10,
                        t52_expiry_date,
                        t52_min_quantity,
                        t52_maxfloor,
                        t52_status_id_v30,
                        t52_remarks,
                        t52_value,
                        t52_netvalue,
                        t52_netsettle,
                        t52_cum_value,
                        t52_cum_netvalue,
                        t52_cum_netsettle,
                        t52_issue_stl_rate,
                        t52_cum_quantity,
                        t52_leavesqty,
                        t52_transacttime,
                        t52_commission,
                        t52_cum_commission,
                        t52_exg_commission,
                        t52_cum_exg_commission,
                        t52_tax,
                        t52_cum_tax,
                        t52_instrument_type,
                        t52_remote_clorderid,
                        t52_remote_origclorderid,
                        t52_remote_tag_22,
                        t52_remote_accountno,
                        t52_remote_tag_48,
                        t52_remote_tag_100,
                        t52_fixmsgtype,
                        t52_exec_broker_id_m26,
                        t52_custodian_id_m26,
                        t52_created_date,
                        t52_avgcost,
                        t52_internall_order_status,
                        t52_cum_child_qty,
                        t52_desk_order_type,
                        t52_last_updated_date,
                        t52_text,
                        t52_dealer_id_u17,
                        t52_app_server_id,
                        t52_institution_id_m02,
                        t52_symbol_id_m20,
                        t52_exchange_id_m01,
						t52_board_code_m54,
                        t52_market_code_m29)
                VALUES (
                           s.t09_clordid,
                           s.t09_clordid_orig,
                           s.t09_ord_no,
                           s.t09_customer_id_u01,
                           TO_NUMBER (s.t09_trading_acc_id_u07),
                           s.t09_trading_acntno_u07,
                           s.t09_tenant_code,
                           s.t09_cashacnt_id_u06,
                           s.t09_channel_id_v29,
                           s.t09_exchange_m01,
                           s.t09_symbol_code_m20,
                           s.t09_ord_type_v06,
                           TO_NUMBER (s.t09_side),
                           TO_NUMBER (s.t09_quantity),
                           TO_NUMBER (s.t09_price),
                           TO_NUMBER (s.t09_avg_price),
                           s.t09_tif_m58,
                           TO_DATE (s.t09_exp_date, 'YYYYMMDD'),
                           --NVL (TO_DATE (s.t09_exp_date, 'YYYYMMDD'),
                               -- TO_DATE ('99991201', 'YYYYMMDD')),
                           TO_NUMBER (s.t09_minfil_qty),
                           TO_NUMBER (s.t09_disclosed_qty),
                           s.t09_ord_status_v30,
                           s.t09_remarks,
                           s.t09_ord_value,
                           s.t09_ord_netvalue,
                           s.t09_ord_netsettle,
                           (s.t09_cumord_value),
                           s.t09_cumord_netvalue,
                           TO_NUMBER (s.t09_cumord_netsettle),
                           TO_NUMBER (s.t09_fxrate),
                           TO_NUMBER (s.t09_cum_qty),
                           s.t09_leaves_qty,
                           TO_TIMESTAMP (s.t09_created_time,
                                         'YYYYMMDDHH24MISS'),
                           NVL (TO_NUMBER (s.t09_commission), -1),
                           TO_NUMBER (s.t09_cum_commission),
                           TO_NUMBER (s.t09_exec_brk_commission),
                           TO_NUMBER (s.t09_cum_exec_brk_commisn),
                             TO_NUMBER (NVL (s.t09_broker_tax, 0))
                           + TO_NUMBER (NVL (s.t09_exchange_tax, 0)),
                             TO_NUMBER (NVL (s.t09_cum_broker_tax, 0))
                           + TO_NUMBER (NVL (s.t09_cum_exchange_tax, 0)),
                           s.t09_instrument_type,
                           s.t09_remote_clordid,
                           s.t09_remote_orig_clordid,
                           s.t09_remote_tag_22,
                           'Remote Account',
                           'TAG 48',
                           s.t09_remote_tag_100,
                           s.t09_fix_msg_type,
                           TO_NUMBER (s.t09_exec_brkr_id_m26),
                           TO_NUMBER (s.t09_custodian_id_m26),
                           TO_TIMESTAMP (s.t09_created_time,
                                         'YYYYMMDDHH24MISS'),
                           s.t09_holding_avg_cost,
                           s.t09_internal_order_status_v30,
                           s.t09_cum_child_qty,
                           s.t09_desk_order_type,
                           SYSDATE,
                           s.t09_reject_reason,
                           s.t09_dealer_id_u18,
                           s.t09_app_server_id,
                           s.t09_institution_id_m02,
                           s.t09_symbol_id_m20,
                           s.t09_exchange_id_m01,
						   s.t09_board_code_m54,
                           s.t09_market_code_m29);

        IF (    t09c.t09_clordid_orig IS NOT NULL
            AND t09c.t09_clordid_orig > 0
            AND t09c.t09_orig_ord_status_v30 IS NOT NULL)
        THEN
            IF t09c.t09_orig_ord_status_v30 = 'e'
            THEN
                --Update Desk Order References of Child Orders
                UPDATE t01_order t01
                   SET t01.t01_desk_order_ref_t52 = t09c.t09_clordid
                 WHERE t01.t01_desk_order_ref_t52 = t09c.t09_clordid_orig
                 AND t01.t01_status_id_v30 in ('0','1','5','o');
            END IF;

            --Update Original Order Status
            UPDATE t52_desk_orders t52
               SET t52.t52_status_id_v30 = t09c.t09_orig_ord_status_v30,
                   t52.t52_internall_order_status =
                       t09c.t09_orig_ord_status_v30
             WHERE t52.t52_order_id = t09c.t09_clordid_orig;
        END IF;
    END;
END;
/



-- End of DDL Script for Procedure DFN_NTP.SP_REDIST_DESK_ORDER_GENERATE