CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t01_order_list_base
(
    t01_cl_ord_id,
    t01_remote_cl_ord_id,
    t01_ord_no,
    t01_side,
    order_side,
    t01_quantity,
    t01_leaves_qty,
    t01_price,
    t01_cum_quantity,
    t01_avg_price,
    t01_cum_ord_value,
    t01_cum_net_value,
    t01_ord_type_id_v06,
    t01_ord_value,
    t01_commission,
    t01_min_quantity,
    t01_date,
    t01_date_time,
    t01_expiry_date,
    t01_cash_settle_date,
    t01_holding_settle_date,
    t01_exchange_code_m01,
    t01_tif_id_v10,
    t01_status_id_v30,
    t01_order_mode,
    t01_disclose_qty,
    t01_broker_tax,
    t01_exchange_tax,
    t01_cum_commission,
    t01_instrument_type_code,
    t01_cum_exec_brk_commission,
    t01_exec_brk_commission,
    cum_broker_commission,
    t01_ord_net_value,
    t01_settle_currency,
    t01_cum_exchange_tax,
    t01_cum_broker_tax,
    cum_total_tax,
    t01_settle_currency_rate,
    t01_ord_net_settle,
    t01_exec_broker_id_m26,
    v10_description,
    t01_symbol_id_m20,
    v06_description,
    v06_description_lang,
    t01_trading_acntno_u07,
    t01_last_shares,
    t01_last_price,
    t01_ord_channel_id_v29,
    v29_description,
    t01_custodian_id_m26,
    t01_reject_reason,
    t01_accrued_interest,
    t01_position_effect,
    position_effect_desc,
    position_covered,
    t01_orig_cl_ord_id,
    t01_trading_acc_id_u07,
    t01_cash_acc_id_u06,
    t01_block_amount,
    t01_cum_netstl,
    t01_market_code_m29,
    t01_board_code_m54,
    t01_tenant_code,
    t01_exchange_ord_id,
    t01_price_inst_type,
    t01_dealer_id_u17,
    t01_last_updated_date_time,
    format_last_update_date_time,
    t01_fail_mngmnt_status,
    t01_fail_mngmnt_status_desc,
    t01_institution_id_m02,
    t01_customer_id_u01,
    custodian_type,
    t01_desk_order_ref_t52,
    t01_desk_order_no_t52,
    t01_trade_process_stat_id_v01,
    total_tax,
    t01_original_exchange_ord_id,
    t01_custodian_type_v01,
    t01_remote_orig_cl_ord_id,
    t01_algo_ord_ref_t54,
    t01_con_ord_ref_t38,
    t01_parent_ord_category_t38,
    t01_orig_exg_tax,
    t01_orig_brk_tax,
    t01_cma_tax,
    t01_cpp_tax,
    t01_dcm_tax,
    t01_cum_cma_tax,
    t01_cum_cpp_tax,
    t01_cum_dcm_tax,
    t01_act_cma_tax,
    t01_act_cpp_tax,
    t01_act_dcm_tax,
    t01_cum_act_cma_tax,
    t01_cum_act_cpp_tax,
    t01_cum_act_dcm_tax,
    t01_cma_commission,
    t01_cpp_commission,
    t01_dcm_commission,
    t01_cma_cum_commission,
    t01_cpp_cum_commission,
    t01_dcm_cum_commission,
    t01_initial_margin_amount,
    t01_maintain_margin_amount,
    t01_cum_initial_margin_amount,
    t01_cum_maintain_margin_amount,
    t01_approved_by_id_u17,
    t01_customer_login_id_u09,
    t01_poa_id_u47,
    t01_contract_id_t75,
    m02_primary_institute_id_m02,
    m02_name,
    t01_wfa_reason,
    t01_exchange_id_m01,
    t01_negotiated_request_id_t85,
    t01_orig_commission,
     t01_other_commission,
    t01_other_tax,
    t01_other_cum_commission,
    t01_other_cum_tax,
	t01_bypass_rms_validation,
    bypass_rms_validation
)
AS
    SELECT t01_cl_ord_id,
           t01_remote_cl_ord_id,
           t01_ord_no,
           t01_side,
           CASE t01_side
               WHEN 1 THEN 'Buy'
               WHEN 2 THEN 'Sell'
               WHEN 3 THEN 'Subscription'
           END
               AS order_side,
           t01_quantity,
           t01_leaves_qty,
           t01_price,
           t01_cum_quantity,
           t01_avg_price,
           t01_cum_ord_value,
           t01_cum_net_value,
           t01_ord_type_id_v06,
           t01_ord_value,
           t01_commission,
           t01_min_quantity,
           t01_date,
           t01_date_time,
           t01_expiry_date,
           t01_cash_settle_date,
           t01_holding_settle_date,
           t01_exchange_code_m01,
           t01_tif_id_v10,
           t01_status_id_v30,
           t01_order_mode,
           t01_disclose_qty,
           t01_broker_tax,
           t01_exchange_tax,
           t01_cum_commission,
           t01_instrument_type_code,
           t01_cum_exec_brk_commission,
           t01_exec_brk_commission,
           t01_cum_commission - t01_cum_exec_brk_commission
               AS cum_broker_commission,
           t01_ord_net_value,
           t01_settle_currency,
           t01_cum_exchange_tax,
           t01_cum_broker_tax,
           (t01_cum_exchange_tax + t01_cum_broker_tax) AS cum_total_tax,
           t01_settle_currency_rate,
           t01_ord_net_settle,
           t01_exec_broker_id_m26,
           CASE t01_tif_id_v10
               WHEN 0 THEN 'Day'
               WHEN 1 THEN 'Good Till Cancel'
               WHEN 2 THEN 'At the Opening'
               WHEN 3 THEN 'FAK'
               WHEN 4 THEN 'Fill or Kill'
               WHEN 5 THEN 'Good Till Crossing'
               WHEN 6 THEN 'Good Till Date'
               WHEN 7 THEN 'End of Week'
               WHEN 8 THEN 'End of Month'
               WHEN 9 THEN 'Session'
               WHEN 10 THEN 'Good Till Time'
           END
               AS v10_description,
           t01_symbol_id_m20,
           CASE t01_ord_type_id_v06
               WHEN '1' THEN 'Market'
               WHEN '2' THEN 'Limit'
               WHEN 'y' THEN 'Trl. Stp.Loss Limit'
               WHEN 'z' THEN 'Trl. Stp.Loss Market'
               WHEN '5' THEN 'Market On Close'
               WHEN 'B' THEN 'Limit On Close'
               WHEN 'c' THEN 'Square Off'
               WHEN '3' THEN 'Stop Market'
               WHEN '4' THEN 'Stop Limit'
           END
               AS v06_description,
           CASE t01_ord_type_id_v06
               WHEN '1' THEN 'Market'
               WHEN '2' THEN 'Limit'
               WHEN 'y' THEN 'Trl. Stp.Loss Limit'
               WHEN 'z' THEN 'Trl. Stp.Loss Market'
               WHEN '5' THEN 'Market On Close'
               WHEN 'B' THEN 'Limit On Close'
               WHEN 'c' THEN 'Square Off'
               WHEN '3' THEN 'Stop Market'
               WHEN '4' THEN 'Stop Limit'
           END
               AS v06_description_lang,
           t01_trading_acntno_u07,
           t01_last_shares,
           t01_last_price,
           t01_ord_channel_id_v29,
           v29.v29_description AS v29_description,
           t01_custodian_id_m26,
           t01_reject_reason,
           t01_accrued_interest,
           t01_position_effect,
           CASE
               WHEN t01_position_effect = 'O' THEN 'Open'
               WHEN t01_position_effect = 'C' THEN 'Close'
           END
               AS position_effect_desc,
           /* CASE
                WHEN    (t01_side = 1 AND t01_position_effect = 'O')
                     OR (t01_side = 2 AND t01_position_effect = 'C')
                THEN
                    'Naked'
                WHEN    (t01_side = 1 AND t01_position_effect = 'C')
                     OR (t01_side = 2 AND t01_position_effect = 'O')
                THEN
                    'Covered'
            END*/
           'Covered' AS position_covered,
           t01_orig_cl_ord_id,
           t01_trading_acc_id_u07,
           t01_cash_acc_id_u06,
           t01_block_amount,
           t01_cum_netstl,
           t01_market_code_m29,
           t01_board_code_m54,
           t01_tenant_code,
           t01_exchange_ord_id,
           t01_price_inst_type,
           t01_dealer_id_u17,
           t01_last_updated_date_time,
           TO_DATE (
               TO_CHAR (t01_last_updated_date_time, 'YYYY-MM-DD HH:MI:SS AM'),
               'YYYY-MM-DD HH:MI:SS AM')
               AS format_last_update_date_time,
           t01_fail_mngmnt_status,
           DECODE (t01_fail_mngmnt_status,
                   1, 'ICM Reeject',
                   2, 'ICM Settle',
                   3, 'ICM Buy In',
                   4, 'ICM Fail Chain',
                   5, 'Recapture ICM Reject')
               AS t01_fail_mngmnt_status_desc,
           t01_institution_id_m02,
           t01_customer_id_u01,
           CASE t01_custodian_type_v01
               WHEN 0 THEN 'None'
               WHEN 1 THEN 'ICM'
           END
               AS custodian_type,
           t01_desk_order_ref_t52,
           t01_desk_order_no_t52,
           t01_trade_process_stat_id_v01,
           t01_broker_tax + t01_exchange_tax AS total_tax,
           t01_original_exchange_ord_id,
           t01_custodian_type_v01,
           t01_remote_orig_cl_ord_id,
           t01_algo_ord_ref_t54,
           t01_con_ord_ref_t38,
           t01_parent_ord_category_t38,
           t01_orig_exg_tax,
           t01_orig_brk_tax,
           t01_cma_tax,
           t01_cpp_tax,
           t01_dcm_tax,
           t01_cum_cma_tax,
           t01_cum_cpp_tax,
           t01_cum_dcm_tax,
           t01_act_cma_tax,
           t01_act_cpp_tax,
           t01_act_dcm_tax,
           t01_cum_act_cma_tax,
           t01_cum_act_cpp_tax,
           t01_cum_act_dcm_tax,
           t01_cma_commission,
           t01_cpp_commission,
           t01_dcm_commission,
           t01_cma_cum_commission,
           t01_cpp_cum_commission,
           t01_dcm_cum_commission,
           t01_initial_margin_amount,
           t01_maintain_margin_amount,
           t01_cum_initial_margin_amount,
           t01_cum_maintain_margin_amount,
           t01.t01_approved_by_id_u17,
           t01.t01_customer_login_id_u09,
           t01.t01_poa_id_u47,
           t01.t01_contract_id_t75,
           m02.m02_primary_institute_id_m02,
           m02.m02_name,
           t01.t01_wfa_reason,
           t01.t01_exchange_id_m01,
           t01_negotiated_request_id_t85,
           t01_orig_commission,
            t01_other_commission,
           t01_other_tax,
           t01_other_cum_commission,
           t01_other_cum_tax,
		   t01_bypass_rms_validation,
           CASE t01_bypass_rms_validation
               WHEN 0 THEN 'No'
               WHEN 1 THEN 'Yes'
           END
               AS bypass_rms_validation
      FROM     t01_order_all t01
           INNER JOIN m02_institute m02
           ON t01_institution_id_m02 = m02.m02_id
           JOIN v29_order_channel v29
               ON t01_ord_channel_id_v29 = v29.v29_id
/