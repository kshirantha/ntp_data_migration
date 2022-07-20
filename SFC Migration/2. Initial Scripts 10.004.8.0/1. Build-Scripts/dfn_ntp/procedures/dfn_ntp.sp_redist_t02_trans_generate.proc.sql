CREATE OR REPLACE PROCEDURE dfn_ntp.sp_redist_t02_trans_generate (
    t09c                     t09_txn_single_entry_v3%ROWTYPE,
    t09c_txn_code            t09_txn_single_entry_v3.t09_txn_code%TYPE,
    t09c_amnt_in_txn_curr    t09_txn_single_entry_v3.t09_amnt_in_txn_curr%TYPE,
    t09c_amnt_in_stl_curr    t09_txn_single_entry_v3.t09_amnt_in_stl_curr%TYPE)
IS
    l_charge_code   VARCHAR2 (10);
BEGIN
    BEGIN
        INSERT INTO dfn_ntp.t02_transaction_log (
                        t02_amnt_in_txn_currency,                          --1
                        t02_amnt_in_stl_currency,                          --2
                        t02_cash_acnt_id_u06,                              --3
                        t02_cash_block,                                    --4
                        t02_cash_block_orig,                               --5
                        t02_cash_block_adjst,                              --6
                        t02_cash_balance,                                  --7
                        t02_cash_acnt_seq_id,                              --8
                        t02_trd_acnt_id_u07,                               --9
                        t02_holding_net,                                  --10
                        t02_holding_block,                                --11
                        t02_holding_block_adjst,                          --12
                        t02_holding_net_adjst,                            --13
                        t02_symbol_code_m20,                              --14
                        t02_exchange_code_m01,                            --15
                        t02_custodian_id_m26,                             --16
                        t02_holding_avg_cost,                             --17
                        t02_inst_id_m02,                                  --18
                        t02_ord_status_v30,                               --19
                        t02_last_shares,                                  --20
                        t02_create_datetime,                              --21
                        t02_create_date,                                  --22
                        t02_cliordid_t01,                                 --23
                        t02_last_price,                                   --24
                        t02_avgprice,                                     --25
                        t02_cum_commission,                               --26
                        t02_commission_adjst,                             --27
                        t02_order_no,                                     --28
                        t02_order_exec_id,                                --29
                        t02_txn_currency,                                 --30
                        t02_settle_currency,                              --31
                        t02_txn_code,                                     --32
                        t02_fx_rate,                                      --33
                        t02_cashtxn_id,                                   --34
                        t02_holdingtxn_id,                                --35
                        t02_customer_id_u01,                              --36
                        t02_customer_no,                                  --37
                        t02_ordqty,                                       --38
                        t02_pay_method,                                   --39
                        t02_narration,                                    --40
                        t02_cash_settle_date,                             --41
                        t02_holding_settle_date,                          --42
                        t02_buy_pending,                                  --43
                        t02_sell_pending,                                 --44
                        t02_instrument_type,                              --45
                        t02_cum_qty,                                      --46
                        t02_holding_manual_block,                         --47
                        t02_accrude_interest,                             --48
                        t02_accrude_interest_adjst,                       --49
                        t02_txn_time,                                     --50
                        t02_leaves_qty,                                   --51
                        t02_text,                                         --52
                        t02_cumord_value,                                 --53
                        t02_cumord_netvalue,                              --54
                        t02_cumord_netsettle,                             --55
                        t02_discount,                                     --56
                        t02_exg_commission,                               --57
                        t02_audit_key,                                    --58
                        t02_pledge_qty,                                   --59
                        t02_side,                                         --60
                        t02_symbol_id_m20,                                --61
                        t02_gainloss,                                     --62
                        t02_update_type,                                 --63,
                        t02_db_create_date,                               --64
                        t02_ord_value_adjst,                              --65
                        t02_trade_match_id,                               --66
                        t02_exg_ord_id,                                   --67
                        t02_exchange_tax,                                 --68
                        t02_broker_tax,                                   --69
                        t02_act_exchange_tax,                             --70
                        t02_act_broker_tax,                              --71,
                        t02_ib_commission,                                --72
                        t02_custodian_type_v01,                           --73
                        t02_base_symbol_code_m20,                         --74
                        t02_base_sym_exchange_m01,                        --75
                        t02_base_holding_block,                           --76
                        t02_cash_balance_orig,                            --77
                        t02_trade_process_stat_id_v01,                    --78
                        t02_last_db_seq_id,                               --79
                        t02_origin_txn_id,                                --80
                        t02_bank_id_m93,                                  --81
                        t02_settle_cal_conf_id_m95,                       --82
                        t02_original_exchange_ord_id,                     --83
                        t02_txn_refrence_id,                              --84
                        t02_master_ref,                                   --85
                        t02_exec_broker_id_m26,                           --86
                        t02_trade_confirm_no,                             --87
                        t02_option_base_holding_block,                    --88
                        t02_option_base_cash_block,                       --89
                        t02_reference_type,                               --90
                        t02_short_holding_block,                          --91
                        t02_orig_exg_tax,                                 --92
                        t02_orig_brk_tax,                                 --93
                        t02_exec_cma_tax,                                 --94
                        t02_exec_cpp_tax,                                 --95
                        t02_exec_dcm_tax,                                 --96
                        t02_exec_act_cma_tax,                             --97
                        t02_exec_act_cpp_tax,                             --98
                        t02_exec_act_dcm_tax,                             --99
                        t02_exec_cma_comission,                          --100
                        t02_exec_cpp_comission,                          --101
                        t02_exec_dcm_comission,                          --102
                        t02_exec_initial_margin_value,                   --103
                        t02_exec_maintain_margin_value,                  --104
                        t02_loan_amount,                                 --105
                        t02_withdr_overdrawn_amt,                        --106
                        t02_incident_overdrawn_amt,                      --107
                        t02_ord_channel_id_v29,                          --108
                        t02_dealer_id_u17,                               --109
                        t02_exchange_id_m01,							 --110
						t02_narration_lang,                              --111
						t02_other_commission,                             --112
                        t02_other_tax,                                    --113
                        t02_other_cum_commission,                         --114
                        t02_other_cum_tax,                                --115
                        t02_exec_other_commission,                        --116
                        t02_exec_other_tax)                               --117
            SELECT t09c_amnt_in_txn_curr,                                  --1
                   t09c_amnt_in_stl_curr,                                  --2
                   t09c.t09_cashacnt_id_u06,                               --3
                   t09c.t09_cash_blk,                                      --4
                   t09c.t09_cash_blk_orig,                                 --5
                   t09c.t09_cash_blk_diff,                                 --6
                   t09c.t09_cash_balance,                                  --7
                   t09c.t09_lockseq,                                       --8
                   t09c.t09_trading_acc_id_u07,                            --9
                   t09c.t09_holding_net,                                  --10
                   t09c.t09_holding_blk,                                  --11
                   t09c.t09_holding_blk_diff,                             --12
                   t09c.t09_holding_net_diff,                             --13
                   t09c.t09_symbol_code_m20,                              --14
                   t09c.t09_exchange_m01,                                 --15
                   t09c.t09_custodian_id_m26,                             --16
                   t09c.t09_holding_avg_cost,                             --17
                   t09c.t09_institution_id_m02,                           --18
                   t09c.t09_ord_status_v30,                               --19
                   t09c.t09_last_shares,                                  --20
                   NVL (
                       TO_DATE (t09c.t09_last_updated_time,
                                'YYYYMMDDHH24MISS'),
                       SYSDATE),                                          --21
                   TRUNC (
                       NVL (
                           TO_DATE (t09c.t09_last_updated_time,
                                    'YYYYMMDDHH24MISS'),
                           SYSDATE)),                                     --22
                   t09c.t09_clordid,                                      --23
                   t09c.t09_last_price,                                   --24
                   t09c.t09_avg_price,                                    --25
                   t09c.t09_cum_commission,                               --26
                   t09c.t09_commisn_diff,                                 --27
                   t09c.t09_ord_no,                                       --28
                   t09c.t09_execid,                                       --29
                   t09c.t09_txn_currency_m03,                             --30
                   t09c.t09_settle_currency_m03,                          --31
                   t09c_txn_code,                                         --32
                   t09c.t09_fxrate,                                       --33
                   t09c.t09_cash_txn_id,                                  --34
                   t09c.t09_holding_txn_id,                               --35
                   t09c.t09_customer_id_u01,                              --36
                   t09c.t09_customer_no_u01,                              --37
                   t09c.t09_quantity,                                     --38
                   t09c.t09_tnsfer_paymethod,                             --39
                   t09c.t09_narration,                                    --40
                   TRUNC (
                       NVL (TO_DATE (t09c.t09_cash_settle_date, 'YYYYMMDD'),
                            SYSDATE)),                                    --41
                   DECODE (
                       t09c.t09_holding_settle_date,
                       NULL, '',
                       TRUNC (
                           TO_DATE (t09c.t09_holding_settle_date, 'YYYYMMDD'))), --42
                   t09c.t09_buy_pending,                                  --43
                   t09c.t09_sell_pending,                                 --44
                   t09c.t09_instrument_type,                              --45
                   t09c.t09_cum_qty,                                      --46
                   t09c.t09_holding_blk_manual,                           --47
                   t09c.t09_accurd_intrst,                                --48
                   t09c.t09_accrd_intrst_diff,                            --49
                   --t09c.t09_txntime,
                   --20180718-13:11:09.635
                   NVL (
                       TO_TIMESTAMP (t09c.t09_txntime,
                                     'YYYYMMDD-HH24:MI:SS.FF'),
                       SYSDATE),                                          --50
                   t09c.t09_leaves_qty,                                   --51
                   t09c.t09_narration,                                    --52
                   t09c.t09_cumord_value,                                 --53
                   t09c.t09_cumord_netvalue,                              --54
                   t09c.t09_cumord_netsettle,                             --55
                   t09c.t09_discount_diff,                                --56
                   t09c.t09_exec_brk_commisn_diff,                        --57
                   t09c.t09_audit_key,                                    --58
                   t09c.t09_pledge_qty,                                   --59
                   t09c.t09_side,                                         --60
                   t09c.t09_symbol_id_m20,                                --61
                   t09c.t09_profit_loss,                                  --62
                   t09c.t09_update_impact_code,                           --63
                   SYSDATE,                                               --64
                   t09c.t09_ordvalue_this_execution,                      --65
                   t09c.t09_trade_match_id,                               --66
                   t09c.t09_ordid,                                        --67
                   t09c.t09_exec_exchange_tax,                            --68
                   t09c.t09_exec_brk_tax,                                 --69
                   t09c.t09_exec_act_exchange_tax,                        --70
                   t09c.t09_exec_act_brk_tax,                             --71
                   t09c.t09_exec_ib_commission,                           --72
                   t09c.t09_custodian_type_v01,                           --73
                   t09c.t09_base_symbol_code_m20,                         --74
                   t09c.t09_base_sym_exchange_m01,                        --75
                   t09c.t09_base_holding_block,                           --76
                   t09c.t09_cash_balance_orig,                            --77
                   t09c.t09_trade_processing_status_id,                   --78
                   t09c.t09_db_seq_id,                                    --79
                   t09c.t09_origin_txn_id,                                --80
                   t09c.t09_bank_id_m93,                                  --81
                   t09c.t09_settle_cal_conf_id_m95,                       --82
                   t09c.t09_original_ordid,                               --83
                   t09c.t09_txn_refrence_id,                              --84
                   t09c.t09_master_ref,                                   --85
                   t09c.t09_exec_brkr_id_m26,                             --86
                   t09c.t09_trade_confirm_no,                             --87
                   t09c.t09_option_base_holding_block,                    --88
                   t09c.t09_option_base_cash_block,                       --89
                   t09c.t09_reference_type,                               --90
                   t09c.t09_short_holding_block,                          --91
                   t09c.t09_orig_exg_tax,                                 --92
                   t09c.t09_orig_brk_tax,                                 --93
                   t09c.t09_exec_cma_tax,                                 --94
                   t09c.t09_exec_cpp_tax,                                 --95
                   t09c.t09_exec_dcm_tax,                                 --96
                   t09c.t09_exec_act_cma_tax,                             --97
                   t09c.t09_exec_act_cpp_tax,                             --98
                   t09c.t09_exec_act_dcm_tax,                             --99
                   t09c.t09_exec_cma_comission,                          --100
                   t09c.t09_exec_cpp_comission,                          --101
                   t09c.t09_exec_dcm_comission,                          --102
                   t09c.t09_exec_initial_margin_charge,                  --103
                   t09c.t09_exe_maintain_margin_charge,                  --104
                   t09c.t09_loan_amount,                                 --105
                   t09c.t09_withdr_overdrawn_amt,                        --106
                   t09c.t09_incident_overdrawn_amt,                      --107
                   t09c.t09_channel_id_v29,                              --108
                   t09c.t09_dealer_id_u18,                               --109
                   t09c.t09_exchange_id_m01,                             --110
				   t09c.t09_narration_lang, 							 --111
				   t09c.t09_other_commission,                             --112
                   t09c.t09_other_tax,                                    --113
                   t09c.t09_other_cum_commission,                         --114
                   t09c.t09_other_cum_tax,                                --115
                   t09c.t09_exec_other_commission,                        --116
                   t09c.t09_exec_other_tax                                --117
              FROM DUAL;

        ------------------Handle Trade Rejection--------------------
        IF (t09c.t09_fail_mngmnt_status > 0)
        THEN
            IF (    t09c.t09_fail_mngmnt_clord_id IS NOT NULL
                AND t09c.t09_fail_mngmnt_exec_id IS NOT NULL)
            THEN
                UPDATE t02_transaction_log t02
                   SET t02.t02_fail_management_status = 5 -- RECAPTURE_ICM_REJECT
                 WHERE t02.t02_order_exec_id = t09c.t09_fail_mngmnt_exec_id;
            END IF;
        END IF;

        --- update original execution's t02_txn_entry_status on order revasal (1 = reversed)

        IF (t09c_txn_code = 'REVSEL' OR t09c_txn_code = 'REVBUY')
        THEN
            IF (t09c.t09_origin_txn_id IS NOT NULL)
            THEN
                UPDATE t02_transaction_log t02
                   SET t02.t02_txn_entry_status = 1
                 WHERE t02.t02_order_exec_id =
                           TO_CHAR (t09c.t09_origin_txn_id);
            ELSIF (t09c.t09_clordid IS NOT NULL)
            THEN
                UPDATE t02_transaction_log t02
                   SET t02.t02_txn_entry_status = 1
                 WHERE t02.t02_cliordid_t01 = t09c.t09_clordid;
            END IF;
        END IF;

        IF (    t09c.t09_instrument_type = 'FUT'
            AND (t09c_txn_code = 'STLSEL' OR t09c_txn_code = 'STLBUY'))
        THEN
            IF (t09c.t09_exe_maintain_margin_charge <> 0)
            THEN
                IF (t09c.t09_exe_maintain_margin_charge > 0)
                THEN
                    l_charge_code := 'MMIN';
                ELSE
                    l_charge_code := 'MMOT';
                END IF;

                sp_redist_t02_trans_generate (
                    t09c,
                    l_charge_code,
                    t09c.t09_exe_maintain_margin_charge,
                    t09c.t09_exe_maintain_margin_charge * t09c.t09_fxrate);
            END IF;


            IF (t09c.t09_exec_initial_margin_charge <> 0)
            THEN
                IF (t09c.t09_exec_initial_margin_charge > 0)
                THEN
                    l_charge_code := 'IN';
                ELSE
                    l_charge_code := 'OT';
                END IF;

                IF (t09c.t09_position_effect > 'O')
                THEN
                    IF (t09c.t09_side = 1)
                    THEN
                        l_charge_code := 'LF' || l_charge_code;
                    ELSE
                        l_charge_code := 'SF' || l_charge_code;
                    END IF;
                ELSE
                    IF (t09c.t09_side = 1)
                    THEN
                        l_charge_code := 'SF' || l_charge_code;
                    ELSE
                        l_charge_code := 'LF' || l_charge_code;
                    END IF;
                END IF;

                sp_redist_t02_trans_generate (
                    t09c,
                    l_charge_code,
                    t09c.t09_exec_initial_margin_charge,
                    t09c.t09_exec_initial_margin_charge * t09c.t09_fxrate);
            END IF;
        END IF;
    END;
END;
/
