CREATE OR REPLACE FORCE VIEW dfn_ntp.t02_transaction_log_all
(
    t02_amnt_in_txn_currency,
    t02_amnt_in_stl_currency,
    t02_cash_acnt_id_u06,
    t02_cash_block,
    t02_cash_block_orig,
    t02_cash_block_adjst,
    t02_cash_balance,
    t02_cash_acnt_seq_id,
    t02_trd_acnt_id_u07,
    t02_holding_net,
    t02_holding_block,
    t02_holding_block_adjst,
    t02_holding_net_adjst,
    t02_symbol_code_m20,
    t02_exchange_code_m01,
    t02_custodian_id_m26,
    t02_holding_avg_cost,
    t02_inst_id_m02,
    t02_txn_entry_status,
    t02_last_shares,
    t02_create_datetime,
    t02_create_date,
    t02_cliordid_t01,
    t02_last_price,
    t02_avgprice,
    t02_cum_commission,
    t02_commission_adjst,
    t02_order_no,
    t02_order_exec_id,
    t02_txn_currency,
    t02_settle_currency,
    t02_exg_commission,
    t02_txn_code,
    t02_fx_rate,
    t02_gl_posted_date,
    t02_gl_posted_status,
    t02_discount,
    t02_cashtxn_id,
    t02_holdingtxn_id,
    t02_customer_id_u01,
    t02_customer_no,
    t02_ordqty,
    t02_pay_method,
    t02_narration,
    t02_cash_settle_date,
    t02_holding_settle_date,
    t02_buy_pending,
    t02_sell_pending,
    t02_instrument_type,
    t02_cum_qty,
    t02_holding_manual_block,
    t02_possision_type,
    t02_accrude_interest,
    t02_accrude_interest_adjst,
    t02_counter_broker,
    t02_txn_time,
    t02_leaves_qty,
    t02_text,
    t02_cumord_value,
    t02_cumord_netvalue,
    t02_cumord_netsettle,
    t02_audit_key,
    t02_pledge_qty,
    t02_side,
    t02_symbol_id_m20,
    t02_gainloss,
    t02_broker_tax,
    t02_exchange_tax,
    t02_update_type,
    t02_db_create_date,
    t02_ord_status_v30,
    t02_fail_management_status,
    t02_ord_value_adjst,
    t02_trade_match_id,
    t02_exg_ord_id,
    t02_act_broker_tax,
    t02_act_exchange_tax,
    t02_cash_settle_date_orig,
    t02_holding_settle_date_orig,
    t02_ib_commission,
    t02_custodian_type_v01,
    t02_base_symbol_code_m20,
    t02_base_sym_exchange_m01,
    t02_base_holding_block,
    t02_unsettle_qty,
    t02_cash_balance_orig,
    t02_trade_process_stat_id_v01,
    t02_last_db_seq_id,
    t02_bank_id_m93,
    t02_settle_cal_conf_id_m95,
    t02_original_exchange_ord_id,
    t02_trade_confirm_no,
    t02_origin_txn_id,
    t02_txn_refrence_id,
    t02_allocated_qty,
    t02_exec_broker_id_m26,
    t02_option_base_holding_block,
    t02_option_base_cash_block,
    t02_reference_type,
    t02_master_ref
)
AS
    SELECT t02_amnt_in_txn_currency,
           t02_amnt_in_stl_currency,
           t02_cash_acnt_id_u06,
           t02_cash_block,
           t02_cash_block_orig,
           t02_cash_block_adjst,
           t02_cash_balance,
           t02_cash_acnt_seq_id,
           t02_trd_acnt_id_u07,
           t02_holding_net,
           t02_holding_block,
           t02_holding_block_adjst,
           t02_holding_net_adjst,
           t02_symbol_code_m20,
           t02_exchange_code_m01,
           t02_custodian_id_m26,
           t02_holding_avg_cost,
           t02_inst_id_m02,
           t02_txn_entry_status,
           t02_last_shares,
           t02_create_datetime,
           t02_create_date,
           t02_cliordid_t01,
           t02_last_price,
           t02_avgprice,
           t02_cum_commission,
           t02_commission_adjst,
           t02_order_no,
           t02_order_exec_id,
           t02_txn_currency,
           t02_settle_currency,
           t02_exg_commission,
           t02_txn_code,
           t02_fx_rate,
           t02_gl_posted_date,
           t02_gl_posted_status,
           t02_discount,
           t02_cashtxn_id,
           t02_holdingtxn_id,
           t02_customer_id_u01,
           t02_customer_no,
           t02_ordqty,
           t02_pay_method,
           t02_narration,
           t02_cash_settle_date,
           t02_holding_settle_date,
           t02_buy_pending,
           t02_sell_pending,
           t02_instrument_type,
           t02_cum_qty,
           t02_holding_manual_block,
           t02_possision_type,
           t02_accrude_interest,
           t02_accrude_interest_adjst,
           t02_counter_broker,
           t02_txn_time,
           t02_leaves_qty,
           t02_text,
           t02_cumord_value,
           t02_cumord_netvalue,
           t02_cumord_netsettle,
           t02_audit_key,
           t02_pledge_qty,
           t02_side,
           t02_symbol_id_m20,
           t02_gainloss,
           t02_broker_tax,
           t02_exchange_tax,
           t02_update_type,
           t02_db_create_date,
           t02_ord_status_v30,
           t02_fail_management_status,
           t02_ord_value_adjst,
           t02_trade_match_id,
           t02_exg_ord_id,
           t02_act_broker_tax,
           t02_act_exchange_tax,
           t02_cash_settle_date_orig,
           t02_holding_settle_date_orig,
           t02_ib_commission,
           t02_custodian_type_v01,
           t02_base_symbol_code_m20,
           t02_base_sym_exchange_m01,
           t02_base_holding_block,
           t02_unsettle_qty,
           t02_cash_balance_orig,
           t02_trade_process_stat_id_v01,
           t02_last_db_seq_id,
           t02_bank_id_m93,
           t02_settle_cal_conf_id_m95,
           t02_original_exchange_ord_id,
           t02_trade_confirm_no,
           t02_origin_txn_id,
           t02_txn_refrence_id,
           t02_allocated_qty,
           t02_exec_broker_id_m26,
           t02_option_base_holding_block,
           t02_option_base_cash_block,
           t02_reference_type,
           t02_master_ref
      FROM dfn_ntp.t02_transaction_log
    UNION ALL
    SELECT t02_amnt_in_txn_currency,
           t02_amnt_in_stl_currency,
           t02_cash_acnt_id_u06,
           t02_cash_block,
           t02_cash_block_orig,
           t02_cash_block_adjst,
           t02_cash_balance,
           t02_cash_acnt_seq_id,
           t02_trd_acnt_id_u07,
           t02_holding_net,
           t02_holding_block,
           t02_holding_block_adjst,
           t02_holding_net_adjst,
           t02_symbol_code_m20,
           t02_exchange_code_m01,
           t02_custodian_id_m26,
           t02_holding_avg_cost,
           t02_inst_id_m02,
           t02_txn_entry_status,
           t02_last_shares,
           t02_create_datetime,
           t02_create_date,
           t02_cliordid_t01,
           t02_last_price,
           t02_avgprice,
           t02_cum_commission,
           t02_commission_adjst,
           t02_order_no,
           t02_order_exec_id,
           t02_txn_currency,
           t02_settle_currency,
           t02_exg_commission,
           t02_txn_code,
           t02_fx_rate,
           t02_gl_posted_date,
           t02_gl_posted_status,
           t02_discount,
           t02_cashtxn_id,
           t02_holdingtxn_id,
           t02_customer_id_u01,
           t02_customer_no,
           t02_ordqty,
           t02_pay_method,
           t02_narration,
           t02_cash_settle_date,
           t02_holding_settle_date,
           t02_buy_pending,
           t02_sell_pending,
           t02_instrument_type,
           t02_cum_qty,
           t02_holding_manual_block,
           t02_possision_type,
           t02_accrude_interest,
           t02_accrude_interest_adjst,
           t02_counter_broker,
           t02_txn_time,
           t02_leaves_qty,
           t02_text,
           t02_cumord_value,
           t02_cumord_netvalue,
           t02_cumord_netsettle,
           t02_audit_key,
           t02_pledge_qty,
           t02_side,
           t02_symbol_id_m20,
           t02_gainloss,
           t02_broker_tax,
           t02_exchange_tax,
           t02_update_type,
           t02_db_create_date,
           t02_ord_status_v30,
           t02_fail_management_status,
           t02_ord_value_adjst,
           t02_trade_match_id,
           t02_exg_ord_id,
           t02_act_broker_tax,
           t02_act_exchange_tax,
           t02_cash_settle_date_orig,
           t02_holding_settle_date_orig,
           t02_ib_commission,
           t02_custodian_type_v01,
           t02_base_symbol_code_m20,
           t02_base_sym_exchange_m01,
           t02_base_holding_block,
           t02_unsettle_qty,
           t02_cash_balance_orig,
           t02_trade_process_stat_id_v01,
           t02_last_db_seq_id,
           t02_bank_id_m93,
           t02_settle_cal_conf_id_m95,
           t02_original_exchange_ord_id,
           t02_trade_confirm_no,
           t02_origin_txn_id,
           t02_txn_refrence_id,
           t02_allocated_qty,
           t02_exec_broker_id_m26,
           t02_option_base_holding_block,
           t02_option_base_cash_block,
           t02_reference_type,
           t02_master_ref
      FROM dfn_arc.t02_transaction_log
/
