SPOOL log.run.dfn_ntp.procedures REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 'validte_trad_acc_by_cash_acc' AS procedure_name FROM DUAL;

@@dfn_ntp.validte_trad_acc_by_cash_acc.proc.sql

SELECT 'u07_set_trading' AS procedure_name FROM DUAL;

@@dfn_ntp.u07_set_trading.proc.sql

SELECT 'sp_write_blob_to_file' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_write_blob_to_file.proc.sql

SELECT 'sp_upload_weekly_file' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_upload_weekly_file.proc.sql

SELECT 'sp_upload_file_to_ext_table' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_upload_file_to_ext_table.proc.sql

SELECT 'sp_upload_file_as_blob' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_upload_file_as_blob.proc.sql

SELECT 'sp_upload_ca_local_tdwl_file' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_upload_ca_local_tdwl_file.proc.sql

SELECT 'sp_update_pending_holding' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_pending_holding.proc.sql

SELECT 'sp_update_pending_holding_old' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_pending_holding_old.proc.sql

SELECT 'sp_update_pending_cash' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_pending_cash.proc.sql

SELECT 'sp_update_pending_cash_old' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_pending_cash_old.proc.sql

SELECT 'sp_update_omini_bank_balances' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_omini_bank_balances.proc.sql

SELECT 'sp_update_cash_net_receivable' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_cash_net_receivable.proc.sql

SELECT 'sp_update_cash_net_receiv_old' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_cash_net_receiv_old.proc.sql

SELECT 'sp_update_customer_grades' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_customer_grades.proc.sql

SELECT 'sp_trading_acc_wise_restrict' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_trading_acc_wise_restrict.proc.sql

SELECT 'sp_t02_get_eod_settlement' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_t02_get_eod_settlement.proc.sql

SELECT 'sp_t02_get_eod_recon_orders' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_t02_get_eod_recon_orders.proc.sql

SELECT 'sp_t02_get_eod_recon_execution' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_t02_get_eod_recon_execution.proc.sql

SELECT 'sp_swap_trade_notification' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_swap_trade_notification.proc.sql

SELECT 'sp_stop_trading_tradeable_rht' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_stop_trading_tradeable_rht.proc.sql

SELECT 'sp_sms_email_add' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_sms_email_add.proc.sql

SELECT 'sp_show_range' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_show_range.proc.sql

SELECT 'sp_set_icm_status' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_set_icm_status.proc.sql

SELECT 'sp_send_sms_email_notification' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_send_sms_email_notification.proc.sql

SELECT 'sp_send_customer_sms_email' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_send_customer_sms_email.proc.sql

SELECT 'sp_reditribution_single_row' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_reditribution_single_row.proc.sql

SELECT 'sp_redis_t09_error_values' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_redis_t09_error_values.proc.sql

SELECT 'sp_redis_t09_error_insert' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_redis_t09_error_insert.proc.sql

SELECT 'sp_redist_t02_trans_generate' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_redist_t02_trans_generate.proc.sql

SELECT 'sp_redist_order_generate' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_redist_order_generate.proc.sql

SELECT 'sp_redist_holding_generate' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_redist_holding_generate.proc.sql

SELECT 'sp_redist_desk_order_generate' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_redist_desk_order_generate.proc.sql

SELECT 'sp_redist_cash_acc_generate' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_redist_cash_acc_generate.proc.sql

SELECT 'sp_redist_base_hld_generate' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_redist_base_hld_generate.proc.sql

SELECT 'sp_process_weekly_recon' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_process_weekly_recon.proc.sql

SELECT 'sp_process_corporate_action' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_process_corporate_action.proc.sql

SELECT 'sp_order_audit_log_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_order_audit_log_report.proc.sql

SELECT 'sp_notify_tradable_rights_sms' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_notify_tradable_rights_sms.proc.sql

SELECT 'sp_monthly_summary_swap_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_monthly_summary_swap_report.proc.sql

SELECT 'sp_mark_weekly_recon_done' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_mark_weekly_recon_done.proc.sql

SELECT 'sp_mark_corporate_action_done' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_mark_corporate_action_done.proc.sql

SELECT 'sp_inactive_dormant_account' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_inactive_dormant_account.proc.sql

SELECT 'sp_holding_statement' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_holding_statement.proc.sql

SELECT 'sp_h02_populate_cash' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_h02_populate_cash.proc.sql

SELECT 'sp_h01_populate_holding' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_h01_populate_holding.proc.sql

SELECT 'sp_gl_process' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_gl_process.proc.sql

SELECT 'sp_gl_prepare_column_value' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_gl_prepare_column_value.proc.sql

SELECT 'sp_gl_get_record_name_val' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_gl_get_record_name_val.proc.sql

SELECT 'sp_gl_get_column_name_val' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_gl_get_column_name_val.proc.sql

SELECT 'sp_get_weekly_recon_detail' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_weekly_recon_detail.proc.sql

SELECT 'sp_get_weekly_rec_exep_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_weekly_rec_exep_report.proc.sql

SELECT 'sp_get_trade_settlements' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_trade_settlements.proc.sql

SELECT 'sp_get_swap_monthly_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_swap_monthly_report.proc.sql

SELECT 'sp_get_oms_account_details' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_oms_account_details.proc.sql

SELECT 'sp_get_institute_cash_balances' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_institute_cash_balances.proc.sql

SELECT 'sp_get_holding_summary' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_holding_summary.proc.sql

SELECT 'sp_get_exg_account_oms_details' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_exg_account_oms_details.proc.sql

SELECT 'sp_get_daily_status_summary' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_daily_status_summary.proc.sql

SELECT 'sp_get_daily_cash_summary' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_daily_cash_summary.proc.sql

SELECT 'sp_get_cust_portfolio_summary' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_cust_portfolio_summary.proc.sql

SELECT 'sp_get_cust_holding_summary' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_cust_holding_summary.proc.sql

SELECT 'sp_get_cust_cash_summary' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_cust_cash_summary.proc.sql

SELECT 'sp_get_corporate_action_detail' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_corporate_action_detail.proc.sql

SELECT 'sp_get_bulk_tc_data' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_bulk_tc_data.proc.sql

SELECT 'sp_exchange_settlement_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_exchange_settlement_report.proc.sql

SELECT 'sp_dealer_activity_statistics' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_dealer_activity_statistics.proc.sql

SELECT 'sp_customer_restriction' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_customer_restriction.proc.sql

SELECT 'sp_customer_holdings' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_customer_holdings.proc.sql

SELECT 'sp_customer_account_freez' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_customer_account_freez.proc.sql

SELECT 'sp_cash_statement' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_cash_statement.proc.sql

SELECT 'sp_cash_acc_wise_restrict' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_cash_acc_wise_restrict.proc.sql

SELECT 'sp_can_delete_trading_account' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_can_delete_trading_account.proc.sql

SELECT 'sp_calc_incident_od_interest' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_calc_incident_od_interest.proc.sql

SELECT 'sp_apply_cash_block' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_apply_cash_block.proc.sql

SELECT 'sp_add_trading_restrictions' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_add_trading_restrictions.proc.sql

SELECT 'sp_add_ord_cancel_req' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_add_ord_cancel_req.proc.sql

SELECT 'sp_add_cash_restrictions' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_add_cash_restrictions.proc.sql

SELECT 'sp_add_accont_closure_restrict' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_add_accont_closure_restrict.proc.sql

SELECT 'show_html_from_url' AS procedure_name FROM DUAL;

@@dfn_ntp.show_html_from_url.proc.sql

SELECT 'set_trd_acc_status_by_cash_acc' AS procedure_name FROM DUAL;

@@dfn_ntp.set_trd_acc_status_by_cash_acc.proc.sql

SELECT 'r12_mismatch_orderid_v2' AS procedure_name FROM DUAL;

@@dfn_ntp.r12_mismatch_orderid_v2.proc.sql

SELECT 'r12_mismatch_orderid' AS procedure_name FROM DUAL;

@@dfn_ntp.r12_mismatch_orderid.proc.sql

SELECT 'r11_mismatch_holdings_v2' AS procedure_name FROM DUAL;

@@dfn_ntp.r11_mismatch_holdings_v2.proc.sql

SELECT 'r11_mismatch_holdings' AS procedure_name FROM DUAL;

@@dfn_ntp.r11_mismatch_holdings.proc.sql

SELECT 'r10_mismatch_accountid_v2' AS procedure_name FROM DUAL;

@@dfn_ntp.r10_mismatch_accountid_v2.proc.sql

SELECT 'r10_mismatch_accountid' AS procedure_name FROM DUAL;

@@dfn_ntp.r10_mismatch_accountid.proc.sql

SELECT 'proc_partial_settlement_tdwl' AS procedure_name FROM DUAL;

@@dfn_ntp.proc_partial_settlement_tdwl.proc.sql

SELECT 'portfolio_val_by_cash_account' AS procedure_name FROM DUAL;

@@dfn_ntp.portfolio_val_by_cash_account.proc.sql

SELECT 'pfolio_val_by_cash_ac' AS procedure_name FROM DUAL;

@@dfn_ntp.pfolio_val_by_cash_ac.proc.sql

SELECT 'oms_cache_clear_invoke' AS procedure_name FROM DUAL;

@@dfn_ntp.oms_cache_clear_invoke.proc.sql

SELECT 'job_update_pending_holding_eod' AS procedure_name FROM DUAL;

@@dfn_ntp.job_update_pending_holding_eod.proc.sql

SELECT 'job_update_pending_holding' AS procedure_name FROM DUAL;

@@dfn_ntp.job_update_pending_holding.proc.sql

SELECT 'job_update_pending_cash_eod' AS procedure_name FROM DUAL;

@@dfn_ntp.job_update_pending_cash_eod.proc.sql

SELECT 'job_update_pending_cash' AS procedure_name FROM DUAL;

@@dfn_ntp.job_update_pending_cash.proc.sql

SELECT 'job_update_omini_bank_balances' AS procedure_name FROM DUAL;

@@dfn_ntp.job_update_omini_bank_balances.proc.sql

SELECT 'sp_expire_direct_dealing' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_expire_direct_dealing.proc.sql

SELECT 'job_update_customers' AS procedure_name FROM DUAL;

@@dfn_ntp.job_update_customers.proc.sql

SELECT 'job_sch_verify_job_dependancy' AS procedure_name FROM DUAL;

@@dfn_ntp.job_sch_verify_job_dependancy.proc.sql

SELECT 'job_sch_update_job_history' AS procedure_name FROM DUAL;

@@dfn_ntp.job_sch_update_job_history.proc.sql

SELECT 'job_sch_send_notification' AS procedure_name FROM DUAL;

@@dfn_ntp.job_sch_send_notification.proc.sql

SELECT 'job_sch_insert_job_history' AS procedure_name FROM DUAL;

@@dfn_ntp.job_sch_insert_job_history.proc.sql

SELECT 'job_populate_history_tables' AS procedure_name FROM DUAL;

@@dfn_ntp.job_populate_history_tables.proc.sql

SELECT 'job_populate_eod_prices' AS procedure_name FROM DUAL;

@@dfn_ntp.job_populate_eod_prices.proc.sql

SELECT 'job_notify_tradable_rights_sms' AS procedure_name FROM DUAL;

@@dfn_ntp.job_notify_tradable_rights_sms.proc.sql

SELECT 'job_enable_cash_transaction' AS procedure_name FROM DUAL;

@@dfn_ntp.job_enable_cash_transaction.proc.sql

SELECT 'job_disable_trading_for_rht' AS procedure_name FROM DUAL;

@@dfn_ntp.job_disable_trading_for_rht.proc.sql

SELECT 'job_disable_cash_transaction' AS procedure_name FROM DUAL;

@@dfn_ntp.job_disable_cash_transaction.proc.sql

SELECT 'job_apply_position_blocks' AS procedure_name FROM DUAL;

@@dfn_ntp.job_apply_position_blocks.proc.sql

SELECT 'get_vat_by_customer' AS procedure_name FROM DUAL;

@@dfn_ntp.get_vat_by_customer.proc.sql

SELECT 'get_trd_symbol_restriction' AS procedure_name FROM DUAL;

@@dfn_ntp.get_trd_symbol_restriction.proc.sql

SELECT 'get_trd_instr_type_restriction' AS procedure_name FROM DUAL;

@@dfn_ntp.get_trd_instr_type_restriction.proc.sql

SELECT 'get_trd_channel_restriction' AS procedure_name FROM DUAL;

@@dfn_ntp.get_trd_channel_restriction.proc.sql

SELECT 'get_rm_wise_commission' AS procedure_name FROM DUAL;

@@dfn_ntp.get_rm_wise_commission.proc.sql

SELECT 'get_form_columns' AS procedure_name FROM DUAL;

@@dfn_ntp.get_form_columns.proc.sql

SELECT 'get_form_colors' AS procedure_name FROM DUAL;

@@dfn_ntp.get_form_colors.proc.sql

SELECT 'get_forms_menu' AS procedure_name FROM DUAL;

@@dfn_ntp.get_forms_menu.proc.sql

SELECT 'get_form' AS procedure_name FROM DUAL;

@@dfn_ntp.get_form.proc.sql

SELECT 'get_executingbroker_exchange' AS procedure_name FROM DUAL;

@@dfn_ntp.get_executingbroker_exchange.proc.sql

SELECT 'get_exchange_tif' AS procedure_name FROM DUAL;

@@dfn_ntp.get_exchange_tif.proc.sql

SELECT 'get_exchange_ordertypes' AS procedure_name FROM DUAL;

@@dfn_ntp.get_exchange_ordertypes.proc.sql

SELECT 'get_exchange_marketstatus' AS procedure_name FROM DUAL;

@@dfn_ntp.get_exchange_marketstatus.proc.sql

SELECT 'get_dealer_wise_commission' AS procedure_name FROM DUAL;

@@dfn_ntp.get_dealer_wise_commission.proc.sql

SELECT 'get_daily_vat_collection' AS procedure_name FROM DUAL;

@@dfn_ntp.get_daily_vat_collection.proc.sql

SELECT 'get_daily_holding_report' AS procedure_name FROM DUAL;

@@dfn_ntp.get_daily_holding_report.proc.sql

SELECT 'get_cust_trding_statmnt_mastr' AS procedure_name FROM DUAL;

@@dfn_ntp.get_cust_trding_statmnt_mastr.proc.sql

SELECT 'get_cust_and_trade_details' AS procedure_name FROM DUAL;

@@dfn_ntp.get_cust_and_trade_details.proc.sql

SELECT 'get_customer_wise_commission' AS procedure_name FROM DUAL;

@@dfn_ntp.get_customer_wise_commission.proc.sql

SELECT 'get_customer_trading_statement' AS procedure_name FROM DUAL;

@@dfn_ntp.get_customer_trading_statement.proc.sql

SELECT 'get_custody_exchange' AS procedure_name FROM DUAL;

@@dfn_ntp.get_custody_exchange.proc.sql

SELECT 'get_branch_wise_commission' AS procedure_name FROM DUAL;

@@dfn_ntp.get_branch_wise_commission.proc.sql

SELECT 'get_available_symbols' AS procedure_name FROM DUAL;

@@dfn_ntp.get_available_symbols.proc.sql

SELECT 'get_account_summary' AS procedure_name FROM DUAL;

@@dfn_ntp.get_account_summary.proc.sql

SELECT 'gettradingaccountno' AS procedure_name FROM DUAL;

@@dfn_ntp.gettradingaccountno.proc.sql

SELECT 'getcashaccountno' AS procedure_name FROM DUAL;

@@dfn_ntp.getcashaccountno.proc.sql

SELECT 'generate_settl_calender' AS procedure_name FROM DUAL;

@@dfn_ntp.generate_settl_calender.proc.sql

SELECT 'generatenewmubasherno' AS procedure_name FROM DUAL;

@@dfn_ntp.generatenewmubasherno.proc.sql

SELECT 'calc_withdraw_od_interest' AS procedure_name FROM DUAL;

@@dfn_ntp.calc_withdraw_od_interest.proc.sql

SELECT 'sp_calculate_margin_interest' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_calculate_margin_interest.proc.sql

SELECT 'job_calculate_int_charges' AS procedure_name FROM DUAL;

@@dfn_ntp.job_calculate_int_charges.proc.sql

SELECT 'job_capitalize_int_charges' AS procedure_name FROM DUAL;

@@dfn_ntp.job_capitalize_int_charges.proc.sql

SELECT 'sp_capitalize_margin_interest' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_capitalize_margin_interest.proc.sql

SELECT 'get_ib_wise_commission' AS procedure_name FROM DUAL;

@@dfn_ntp.get_ib_wise_commission.proc.sql

SELECT 'get_channel_wise_commission' AS procedure_name FROM DUAL;

@@dfn_ntp.get_channel_wise_commission.proc.sql

SELECT 'sp_redist_prnt_dsk_ord_genete' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_redist_prnt_dsk_ord_genete.proc.sql

SELECT 'sp_calc_incident_with_interest' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_calc_incident_with_interest.proc.sql

SELECT 'sp_get_ca_eligible_customers' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_ca_eligible_customers.proc.sql

SELECT 'sp_populate_rpt_summary_tbls' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_populate_rpt_summary_tbls.proc.sql

SELECT 'job_populate_rpt_summary_tbls' AS procedure_name FROM DUAL;

@@dfn_ntp.job_populate_rpt_summary_tbls.proc.sql

SELECT 'sp_update_master_data' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_master_data.proc.sql

SELECT 'job_update_master_data' AS procedure_name FROM DUAL;

@@dfn_ntp.job_update_master_data.proc.sql

SELECT 'sp_update_cash_accounts' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_cash_accounts.proc.sql

SELECT 'job_update_cash_accounts' AS procedure_name FROM DUAL;

@@dfn_ntp.job_update_cash_accounts.proc.sql

SELECT 'sp_redist_algo_order_generate' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_redist_algo_order_generate.proc.sql

SELECT 'sp_h02_update_balance' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_h02_update_balance.proc.sql

SELECT 'sp_h01_update_balance' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_h01_update_balance.proc.sql

SELECT 'sp_get_trial_balance' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_trial_balance.proc.sql

SELECT 'sp_get_corporate_action_charge' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_corporate_action_charge.proc.sql

SELECT 'sp_coporate_act_hold_adjst' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_coporate_act_hold_adjst.proc.sql

SELECT 'sp_coporate_act_cash_adjst' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_coporate_act_cash_adjst.proc.sql

SELECT 'sp_coporate_action_distrb' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_coporate_action_distrb.proc.sql

SELECT 'sp_ca_calculate_impact' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_ca_calculate_impact.proc.sql

SELECT 'sp_brok_bank_ac_cash_statement' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_brok_bank_ac_cash_statement.proc.sql

SELECT 'sp_redist_prnt_algo_ord_genete' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_redist_prnt_algo_ord_genete.proc.sql

SELECT 'sp_reset_seq' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_reset_seq.proc.sql

SELECT 'sp_get_cross_orders' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_cross_orders.proc.sql

SELECT 'sp_update_hold_net_receivable' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_hold_net_receivable.proc.sql

SELECT 'sp_update_hold_net_receiv_old' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_hold_net_receiv_old.proc.sql

SELECT 'sp_most_active_companies' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_most_active_companies.proc.sql

SELECT 'sp_update_cust_poa_privileges' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_cust_poa_privileges.proc.sql

SELECT 'sp_get_ca_notify_customers' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_ca_notify_customers.proc.sql

SELECT 'sp_cma_int_brokerage_dtls_all' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_cma_int_brokerage_dtls_all.proc.sql

SELECT 'sp_cma_int_brokerage_dtls_rpt' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_cma_int_brokerage_dtls_rpt.proc.sql

SELECT 'sp_update_t02_settled_trades' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_t02_settled_trades.proc.sql

SELECT 'sp_calc_margexpired_od_interst' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_calc_margexpired_od_interst.proc.sql

SELECT 'sp_capitalize_other_interest' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_capitalize_other_interest.proc.sql

SELECT 'sp_bn_last_payment_date' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_bn_last_payment_date.proc.sql

SELECT 'sp_expire_poa' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_expire_poa.proc.sql

SELECT 'sp_populate_forex_history' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_populate_forex_history.proc.sql

SELECT 'job_update_symbol_data' AS procedure_name FROM DUAL;

@@dfn_ntp.job_update_symbol_data.proc.sql

SELECT 'sp_upload_eod_tdwl_file' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_upload_eod_tdwl_file.proc.sql

SELECT 'sp_idsr_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_idsr_report.proc.sql

SELECT 'sp_m151_set_as_default' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_m151_set_as_default.proc.sql

SELECT 'sp_update_bulk_share_master' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_bulk_share_master.proc.sql

SELECT 'sp_get_traded_customers' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_traded_customers.proc.sql

SELECT 'sp_get_lst_mnt_price_chg_ords' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_lst_mnt_price_chg_ords.proc.sql

SELECT 'sp_get_doubled_qty_orders' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_doubled_qty_orders.proc.sql

SELECT 'get_order_in_buy_sell_same_sym' AS procedure_name FROM DUAL;

@@dfn_ntp.get_order_in_buy_sell_same_sym.proc.sql

SELECT 'get_ft_shr_exceed_per_day_vol' AS procedure_name FROM DUAL;

@@dfn_ntp.get_ft_shr_exceed_per_day_vol.proc.sql

SELECT 'get_cli_shr_exceed_per_day_vol' AS procedure_name FROM DUAL;

@@dfn_ntp.get_cli_shr_exceed_per_day_vol.proc.sql

SELECT 'get_ent_canceled_order_preopen' AS procedure_name FROM DUAL;

@@dfn_ntp.get_ent_canceled_order_preopen.proc.sql

SELECT 'get_can_ord_buy_sell_same_sym' AS procedure_name FROM DUAL;

@@dfn_ntp.get_can_ord_buy_sell_same_sym.proc.sql

SELECT 'get_form_columns_all' AS procedure_name FROM DUAL;

@@dfn_ntp.get_form_columns_all.proc.sql

SELECT 'get_form_colors_all' AS procedure_name FROM DUAL;

@@dfn_ntp.get_form_colors_all.proc.sql

SELECT 'get_forms_menu_all' AS procedure_name FROM DUAL;

@@dfn_ntp.get_forms_menu_all.proc.sql

SELECT 'get_form_all' AS procedure_name FROM DUAL;

@@dfn_ntp.get_form_all.proc.sql

SELECT 'get_menu_all' AS procedure_name FROM DUAL;

@@dfn_ntp.get_menu_all.proc.sql

SELECT 'sp_get_institute_config' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_institute_config.proc.sql

SELECT 'sp_db_online_users' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_db_online_users.proc.sql

SELECT 'sp_db_margin_customer_status' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_db_margin_customer_status.proc.sql

SELECT 'sp_db_function_approvals' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_db_function_approvals.proc.sql

SELECT 'sp_db_customer_status_types' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_db_customer_status_types.proc.sql

SELECT 'sp_db_custodian_wise_orders' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_db_custodian_wise_orders.proc.sql

SELECT 'sp_db_cash_account_status' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_db_cash_account_status.proc.sql

SELECT 'sp_db_advanced_approvals' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_db_advanced_approvals.proc.sql

SELECT 'sp_populate_price_users' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_populate_price_users.proc.sql

SELECT 'sp_get_settlement_projection' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_settlement_projection.proc.sql

SELECT 'sp_client_settlement_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_client_settlement_report.proc.sql

SELECT 'job_eod_trade_confirm_activity' AS procedure_name FROM DUAL;

@@dfn_ntp.job_eod_trade_confirm_activity.proc.sql

SELECT 'sp_get_traded_customer_filter' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_traded_customer_filter.proc.sql

SELECT 'get_email_confirm_customers' AS procedure_name FROM DUAL;

@@dfn_ntp.get_email_confirm_customers.proc.sql

SELECT 'sp_trade_det_ca_rpt_confirm_no' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_trade_det_ca_rpt_confirm_no.proc.sql

SELECT 'sp_trade_sum_rpt_by_confirm_no' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_trade_sum_rpt_by_confirm_no.proc.sql

SELECT 'sp_tradedetsym_rpt_confirm_no' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_tradedetsym_rpt_confirm_no.proc.sql

SELECT 'sp_rollback_confirmation_no' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_rollback_confirmation_no.proc.sql

SELECT 'sp_rollback_confirm_no_trades' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_rollback_confirm_no_trades.proc.sql

SELECT 'sp_apply_stock_block' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_apply_stock_block.proc.sql

SELECT 'job_notify_order_limit_breach' AS procedure_name FROM DUAL;

@@dfn_ntp.job_notify_order_limit_breach.proc.sql

SELECT 'sp_inst_order_limit_breach' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_inst_order_limit_breach.proc.sql

SELECT 'sp_branch_order_limit_breach' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_branch_order_limit_breach.proc.sql

SELECT 'sp_dealer_order_limit_breach' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_dealer_order_limit_breach.proc.sql

SELECT 'sp_update_custody_txn_charges' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_custody_txn_charges.proc.sql

SELECT 'sp_update_custody_ord_charges' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_custody_ord_charges.proc.sql

SELECT 'sp_update_custody_hldg_charges' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_custody_hldg_charges.proc.sql

SELECT 'job_capitalize_custody_charges' AS procedure_name FROM DUAL;

@@dfn_ntp.job_capitalize_custody_charges.proc.sql

SELECT 'job_calculate_custody_charges' AS procedure_name FROM DUAL;

@@dfn_ntp.job_calculate_custody_charges.proc.sql

SELECT 'sp_capitalized_hldg_charge' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_capitalized_hldg_charge.proc.sql

SELECT 'sp_sumarized_order_master_view' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_sumarized_order_master_view.proc.sql

SELECT 'sp_detailed_order_master' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_detailed_order_master.proc.sql

SELECT 'sp_customer_wise_order_master' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_customer_wise_order_master.proc.sql

SELECT 'sp_reset_trade_confirmation_no' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_reset_trade_confirmation_no.proc.sql

SELECT 'sp_clear_transaction_limits' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_clear_transaction_limits.proc.sql

SELECT 'sp_arc_get_columns' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_arc_get_columns.proc.sql

SELECT 'sp_arc_set_h01_prepare_archive' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_arc_set_h01_prepare_archive.proc.sql

SELECT 'sp_arc_set_h02_prepare_archive' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_arc_set_h02_prepare_archive.proc.sql

SELECT 'sp_orders_for_dealers_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_orders_for_dealers_report.proc.sql

SELECT 'add_tila_agreement' AS procedure_name FROM DUAL;

@@dfn_ntp.add_tila_agreement.proc.sql

SELECT 'sp_arc_archive_data' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_arc_archive_data.proc.sql

SELECT 'sp_arc_set_archive_ready' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_arc_set_archive_ready.proc.sql

SELECT 'sp_arc_set_t01_prepare_archive' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_arc_set_t01_prepare_archive.proc.sql

SELECT 'sp_arc_set_t02_prepare_archive' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_arc_set_t02_prepare_archive.proc.sql

SELECT 'sp_arc_set_t06_prepare_archive' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_arc_set_t06_prepare_archive.proc.sql

SELECT 'sp_arc_set_t11_prepare_archive' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_arc_set_t11_prepare_archive.proc.sql

SELECT 'sp_arc_update_audit_log' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_arc_update_audit_log.proc.sql

SELECT 'sp_int_portfol_perform_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_int_portfol_perform_report.proc.sql

SELECT 'sp_get_minimum_commission' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_minimum_commission.proc.sql

SELECT 'sp_update_incentive_for_dealrs' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_incentive_for_dealrs.proc.sql

SELECT 'sp_update_incentive_for_ib' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_incentive_for_ib.proc.sql

SELECT 'sp_update_incentive_for_refcus' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_incentive_for_refcus.proc.sql

SELECT 'sp_update_incentive_for_rm' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_incentive_for_rm.proc.sql

SELECT 'job_update_incentive' AS procedure_name FROM DUAL;

@@dfn_ntp.job_update_incentive.proc.sql

SELECT 'sp_unouthorized_od_clients_rpt' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_unouthorized_od_clients_rpt.proc.sql

SELECT 'job_margin_trd_notification' AS procedure_name FROM DUAL;

@@dfn_ntp.job_margin_trd_notification.proc.sql

SELECT 'sp_margin_expiory_notification' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_margin_expiory_notification.proc.sql

SELECT 'sp_get_top_cust_assets_val' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_top_cust_assets_val.proc.sql

SELECT 'sp_validate_edaa_payment_file' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_validate_edaa_payment_file.proc.sql

SELECT 'sp_set_paying_agent_status' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_set_paying_agent_status.proc.sql

SELECT 'sp_corporate_action_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_corporate_action_report.proc.sql

SELECT 'sp_change_account_approve' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_change_account_approve.proc.sql

SELECT 'sp_change_account_request' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_change_account_request.proc.sql

SELECT 'sp_get_customers_by_nin' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_customers_by_nin.proc.sql

SELECT 'sp_trade_commission_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_trade_commission_report.proc.sql

SELECT 'sp_daily_settlement_advice_rpt' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_daily_settlement_advice_rpt.proc.sql

SELECT 'sp_get_top_cust_traded_value' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_top_cust_traded_value.proc.sql

SELECT 'sp_get_top_cust_traded_vol' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_top_cust_traded_vol.proc.sql

SELECT 'sp_get_top_customer_commission' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_top_customer_commission.proc.sql

SELECT 'sp_get_top_trade_sym_val' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_top_trade_sym_val.proc.sql

SELECT 'sp_get_top_trade_sym_vol' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_top_trade_sym_vol.proc.sql

SELECT 'sp_get_top_traded_sym_com' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_top_traded_sym_com.proc.sql

SELECT 'job_m2m_profit_calculation' AS procedure_name FROM DUAL;

@@dfn_ntp.job_m2m_profit_calculation.proc.sql

SELECT 'sp_m2m_profit_calculation' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_m2m_profit_calculation.proc.sql

SELECT 'dfn_ntp.job_derivative_symbol_expiry' AS procedure_name FROM DUAL;

@@dfn_ntp.job_derivative_symbol_expiry.proc.sql

SELECT 'dfn_ntp.sp_derivative_symbol_expiry' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_derivative_symbol_expiry.proc.sql

SELECT 'dfn_ntp.sp_get_customer_list_base' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_customer_list_base.proc.sql

SELECT 'dfn_ntp.sp_get_trading_acc_list_base' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_trading_acc_list_base.proc.sql

SELECT 'dfn_ntp.sp_get_cash_account_list_base' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_cash_account_list_base.proc.sql

SELECT 'dfn_ntp.sp_get_trading_account_list' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_trading_account_list.proc.sql

SELECT 'dfn_ntp.sp_gl_post_validation' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_gl_post_validation.proc.sql

SELECT 'dfn_ntp.sp_cma_monthly_margin_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_cma_monthly_margin_report.proc.sql

SELECT 'dfn_ntp.sp_commission_override_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_commission_override_report.proc.sql

SELECT 'dfn_ntp.sp_marginable_symbol_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_marginable_symbol_report.proc.sql

SELECT 'dfn_ntp.sp_derivatve_sym_expiry_notify' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_derivatve_sym_expiry_notify.proc.sql

SELECT 'dfn_ntp.sp_daily_symbol_trade_summary' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_daily_symbol_trade_summary.proc.sql

SELECT 'sp_get_allocation_transactions' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_allocation_transactions.proc.sql

SELECT 'sp_view_trade_allocation' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_view_trade_allocation.proc.sql

SELECT 'sp_get_order_list_base' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_order_list_base.proc.sql

SELECT 'sp_get_vat_collected_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_vat_collected_report.proc.sql

SELECT 'dfn_ntp.sp_trdacc_total_comm_vat' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_trdacc_total_comm_vat.proc.sql

SELECT 'sp_get_settle_tax_collection' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_settle_tax_collection.proc.sql

SELECT 'sp_get_stock_transfers' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_stock_transfers.proc.sql

SELECT 'dfn_ntp.sp_upload_customer_file' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_upload_customer_file.proc.sql

SELECT 'dfn_ntp.sp_process_customer_file' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_process_customer_file.proc.sql

SELECT 'dfn_ntp.sp_add_beneficiary_account' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_add_beneficiary_account.proc.sql

SELECT 'dfn_ntp.sp_add_customer_account' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_add_customer_account.proc.sql

SELECT 'dfn_ntp.sp_add_trading_account' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_add_trading_account.proc.sql

SELECT 'dfn_ntp.sp_add_cash_account' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_add_cash_account.proc.sql

SELECT 'dfn_ntp.sp_daily_trades_by_exchange' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_daily_trades_by_exchange.proc.sql

SELECT 'dfn_ntp.sp_get_monthly_transactions' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_monthly_transactions.proc.sql

SELECT 'dfn_ntp.sp_get_vat_uncollected_list' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_vat_uncollected_list.proc.sql

SELECT 'dfn_ntp.sp_sama_monthly_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_sama_monthly_report.proc.sql

SELECT 'dfn_ntp.sp_get_tax_invoice_details' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_tax_invoice_details.proc.sql

SELECT 'dfn_ntp.sp_populate_tax_details' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_populate_tax_details.proc.sql

SELECT 'dfn_ntp.sp_update_eom_tax_invoices' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_eom_tax_invoices.proc.sql

SELECT 'dfn_ntp.sp_get_tax_eom_data' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_tax_eom_data.proc.sql

SELECT 'dfn_ntp.sp_dc_daily_margin_utilization' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_dc_daily_margin_utilization.proc.sql

SELECT 'dfn_ntp.sp_dt_daily_symbol_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_dt_daily_symbol_report.proc.sql

SELECT 'dfn_ntp.sp_get_discounted_commission' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_discounted_commission.proc.sql

SELECT 'dfn_ntp.proc_fti_rsp' AS procedure_name FROM DUAL;

@@dfn_ntp.proc_fti_rsp.proc.sql

SELECT 'dfn_ntp.proc_fto_req' AS procedure_name FROM DUAL;

@@dfn_ntp.proc_fto_req.proc.sql


SELECT 'dfn_ntp.sp_pledge_all_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_pledge_all_report.proc.sql

SELECT 'dfn_ntp.sp_nostro_settlements_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_nostro_settlements_report.proc.sql

SELECT 'dfn_ntp.sp_get_om_questionnaire' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_om_questionnaire.proc.sql

SELECT 'dfn_ntp.sp_get_holdings_by_symbol' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_holdings_by_symbol.proc.sql

SELECT 'dfn_ntp.sp_unauth_od_clients_interest' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_unauth_od_clients_interest.proc.sql

SELECT 'dfn_ntp.sp_mtm_settlement_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_mtm_settlement_report.proc.sql

SELECT 'dfn_ntp.job_margin_funding_covering' AS procedure_name FROM DUAL;

@@dfn_ntp.job_margin_funding_covering.proc.sql

SELECT 'dfn_ntp.sp_margin_funding_covering' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_margin_funding_covering.proc.sql

SELECT 'dfn_ntp.sp_get_om_portfolio_details' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_om_portfolio_details.proc.sql

SELECT 'dfn_ntp.sp_get_bond_contracts_list' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_bond_contracts_list.proc.sql

SELECT 'dfn_ntp.sp_get_traded_symbol_list' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_traded_symbol_list.proc.sql

SELECT 'dfn_ntp.sp_get_full_vat_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_full_vat_report.proc.sql

SELECT 'dfn_ntp.sp_recalculate_margin_fee' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_recalculate_margin_fee.proc.sql

SELECT 'dfn_ntp.sp_get_corp_actions_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_corp_actions_report.proc.sql

SELECT 'dfn_ntp.sp_get_corp_act_cash_adj' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_corp_act_cash_adj.proc.sql

SELECT 'dfn_ntp.sp_get_corp_act_hold_adj' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_corp_act_hold_adj.proc.sql

SELECT 'dfn_ntp.sp_trade_notifications_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_trade_notifications_report.proc.sql

SELECT 'dfn_ntp.sp_interest_index_inquiry' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_interest_index_inquiry.proc.sql

SELECT 'dfn_ntp.sp_om_send_sms_email_approval' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_om_send_sms_email_approval.proc.sql

SELECT 'dfn_ntp.sp_get_customer_lvl_conc_rpt' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_customer_lvl_conc_rpt.proc.sql

SELECT 'dfn_ntp.sp_process_bond_maturity' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_process_bond_maturity.proc.sql

SELECT 'dfn_ntp.job_process_bond_maturity' AS procedure_name FROM DUAL;

@@dfn_ntp.job_process_bond_maturity.proc.sql

SELECT 'dfn_ntp.sp_get_cash_details_by_date' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_cash_details_by_date.proc.sql

SELECT 'dfn_ntp.sp_populate_int_ind_history' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_populate_int_ind_history.proc.sql

SELECT 'dfn_ntp.sp_cheuvrex_trade_confimation' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_cheuvrex_trade_confimation.proc.sql

SELECT 'dfn_ntp.sp_get_pending_margin_fee' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_pending_margin_fee.proc.sql

SELECT 'dfn_ntp.sp_re_calculate_margin_intrest' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_re_calculate_margin_intrest.proc.sql

SELECT 'dfn_ntp.sp_instant_capitalize_margnfee' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_instant_capitalize_margnfee.proc.sql

SELECT 'dfn_ntp.sp_get_uploaded_customer' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_uploaded_customer.proc.sql

SELECT 'dfn_ntp.sp_dt_dividend_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_dt_dividend_report.proc.sql

SELECT 'dfn_ntp.sp_customer_direct_dealing_rpt' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_customer_direct_dealing_rpt.proc.sql

SELECT 'dfn_ntp.sp_wv_off_user_service_fee_rpt' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_wv_off_user_service_fee_rpt.proc.sql

SELECT 'dfn_ntp.sp_update_bulk_share_n_account' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_bulk_share_n_account.proc.sql

SELECT 'dfn_ntp.sp_calculate_margin_interest_b' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_calculate_margin_interest_b.proc.sql

SELECT 'dfn_ntp.sp_margin_funding_covering_b' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_margin_funding_covering_b.proc.sql

SELECT 'dfn_ntp.sp_marginable_pf_valuation_rpt' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_marginable_pf_valuation_rpt.proc.sql

SELECT 'dfn_ntp.sp_margin_utilization_report' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_margin_utilization_report.proc.sql

SELECT 'dfn_ntp.sp_ca_bulk_l1_approve' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_ca_bulk_l1_approve.proc.sql

SELECT 'dfn_ntp.sp_get_outstand_pledg_position' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_outstand_pledg_position.proc.sql

SELECT 'dfn_ntp.sp_get_system_notification' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_system_notification.proc.sql

SELECT 'dfn_ntp.sp_wv_off_exchange_subcription' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_wv_off_exchange_subcription.proc.sql

SELECT 'dfn_ntp.sp_get_od_limit_accounts' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_od_limit_accounts.proc.sql

SELECT 'dfn_ntp.sp_gl_pre_validation' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_gl_pre_validation.proc.sql

SELECT 'dfn_ntp.sp_h24_gl_cash_acc_sum_list' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_h24_gl_cash_acc_sum_list.proc.sql

SELECT 'dfn_ntp.sp_cust_dealer_relation_list' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_cust_dealer_relation_list.proc.sql

SELECT 'dfn_ntp.sp_get_total_commiss_by_dealer' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_total_commiss_by_dealer.proc.sql

SELECT 'dfn_ntp.job_archive_table_data' AS procedure_name FROM DUAL;

@@dfn_ntp.job_archive_table_data.proc.sql

SELECT 'dfn_ntp.sp_job_schedular_action' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_job_schedular_action.proc.sql

SELECT 'sp_update_h26_daily_status' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_h26_daily_status.proc.sql

SELECT 'dfn_ntp.sp_cma_monthly_disclosures_rpt' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_cma_monthly_disclosures_rpt.proc.sql

SELECT 'dfn_ntp.sp_get_subscriptio_expire_list' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_subscriptio_expire_list.proc.sql

SELECT 'get_exchange_accounttypes' AS procedure_name FROM DUAL;
@@dfn_ntp.get_exchange_accounttypes.proc.sql

SELECT 'sp_update_custody_settlements' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_custody_settlements.proc.sql

SELECT 'sp_settle_custodian_approve' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_settle_custodian_approve.proc.sql

SELECT 'sp_settle_custody_and_accounts' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_settle_custody_and_accounts.proc.sql

SELECT 'sp_get_t78_settled_transaction' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_t78_settled_transaction.proc.sql

SELECT 'job_custody_execb_settlement' AS procedure_name FROM DUAL;

@@dfn_ntp.job_custody_execb_settlement.proc.sql

SELECT 'dfn_ntp.sp_update_exec_brok_settlemnt' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_exec_brok_settlemnt.proc.sql

SELECT 'dfn_ntp.sp_settle_exec_broker_accounts' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_settle_exec_broker_accounts.proc.sql

SELECT 'dfn_ntp.sp_settle_exec_broker_approve' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_settle_exec_broker_approve.proc.sql

SELECT 'dfn_ntp.sp_get_t83_settled_transaction' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_t83_settled_transaction.proc.sql

SELECT 'dfn_ntp.sp_get_chl_wise_comm_breakdown' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_chl_wise_comm_breakdown.proc.sql

SELECT 'dfn_ntp.sp_process_interest_indices' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_process_interest_indices.proc.sql

SELECT 'dfn_ntp.sp_corporate_action_process' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_corporate_action_process.proc.sql

SELECT 'dfn_ntp.sp_oms_txn_entry_persist_bulk' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_oms_txn_entry_persist_bulk.proc.sql

SELECT 'dfn_ntp.sp_cash_transaction_generate' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_cash_transaction_generate.proc.sql

SELECT 'dfn_ntp.sp_stock_transaction_generate' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_stock_transaction_generate.proc.sql

SELECT 'dfn_ntp.sp_pledge_transaction_generate' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_pledge_transaction_generate.proc.sql

SELECT 'dfn_ntp.sp_oms_log_entry_persist' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_oms_log_entry_persist.proc.sql

SELECT 'dfn_ntp.sp_bulk_status_update' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_bulk_status_update.proc.sql

SELECT 'dfn_ntp.sp_update_authentication' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_update_authentication.proc.sql

SELECT 'dfn_ntp.job_populate_portfolio_value_b' AS procedure_name FROM DUAL;

@@dfn_ntp.job_populate_portfolio_value_b.proc.sql

SELECT 'dfn_ntp.get_exchange_boardstatus' AS procedure_name FROM DUAL;

@@dfn_ntp.get_exchange_boardstatus.proc.sql

SELECT 'dfn_ntp.sp_get_file_processing_log' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_file_processing_log.proc.sql

SELECT 'dfn_ntp.sp_e100_process_deposit_txn_c' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_e100_process_deposit_txn_c.proc.sql

SELECT 'dfn_ntp.sp_verify_customer' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_verify_customer.proc.sql

SELECT 'dfn_ntp.sp_populate_murabaha_amortize' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_populate_murabaha_amortize.proc.sql

SELECT 'dfn_ntp.job_populate_murabaha_amortiz' AS procedure_name FROM DUAL;

@@dfn_ntp.job_populate_murabaha_amortiz.proc.sql

SELECT 'dfn_ntp.job_disable_transaction_local' AS procedure_name FROM DUAL;

@@dfn_ntp.job_disable_transaction_local.proc.sql

SELECT 'dfn_ntp.job_enable_transaction_local' AS procedure_name FROM DUAL;

@@dfn_ntp.job_enable_transaction_local.proc.sql

SELECT 'dfn_ntp.job_disable_transaction_intl' AS procedure_name FROM DUAL;

@@dfn_ntp.job_disable_transaction_intl.proc.sql

SELECT 'dfn_ntp.job_enable_transaction_intl' AS procedure_name FROM DUAL;

@@dfn_ntp.job_enable_transaction_intl.proc.sql

SELECT 'dfn_ntp.sp_file_processing_unique_keys' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_file_processing_unique_keys.proc.sql

SELECT 'dfn_ntp.sp_bulk_process_finalize' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_bulk_process_finalize.proc.sql

SELECT 'dfn_ntp.sp_cancel_file_proc_batch' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_cancel_file_proc_batch.proc.sql

SELECT 'dfn_ntp.sp_add_t80_batch' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_add_t80_batch.proc.sql

SELECT 'dfn_ntp.sp_add_t81_batch_logs' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_add_t81_batch_logs.proc.sql

SELECT 'dfn_ntp.sp_corp_hold_payments' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_corp_hold_payments.proc.sql

SELECT 'dfn_ntp.sp_corp_hold_payments' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_comm_override_all_report.proc.sql

SELECT 'dfn_ntp.job_oms_cache_update' AS procedure_name FROM DUAL;

@@dfn_ntp.job_oms_cache_update.proc.sql

SELECT 'dfn_ntp.job_calculate_int_charg_intl_b' AS procedure_name FROM DUAL;

@@dfn_ntp.job_calculate_int_charg_intl_b.proc.sql

SELECT 'dfn_ntp.job_calculate_int_charg_locl_b' AS procedure_name FROM DUAL;

@@dfn_ntp.job_calculate_int_charg_locl_b.proc.sql

SELECT 'dfn_ntp.job_capitalz_int_charge_intl_b' AS procedure_name FROM DUAL;

@@dfn_ntp.job_capitalz_int_charge_intl_b.proc.sql

SELECT 'dfn_ntp.job_capitalz_int_charge_locl_b' AS procedure_name FROM DUAL;

@@dfn_ntp.job_capitalz_int_charge_locl_b.proc.sql

SELECT 'dfn_ntp.job_lb_accounting_entries_b' AS procedure_name FROM DUAL;

@@dfn_ntp.job_lb_accounting_entries_b.proc.sql

SELECT 'dfn_ntp.job_lb_gl_pre_validation_b' AS procedure_name FROM DUAL;

@@dfn_ntp.job_lb_gl_pre_validation_b.proc.sql

SELECT 'dfn_ntp.job_margin_fund_cover_intl_b' AS procedure_name FROM DUAL;

@@dfn_ntp.job_margin_fund_cover_intl_b.proc.sql

SELECT 'dfn_ntp.job_margin_fund_cover_locl_b' AS procedure_name FROM DUAL;

@@dfn_ntp.job_margin_fund_cover_locl_b.proc.sql

SELECT 'dfn_ntp.job_populat_daily_owned_hold_b' AS procedure_name FROM DUAL;

@@dfn_ntp.job_populat_daily_owned_hold_b.proc.sql

SELECT 'dfn_ntp.sp_acc_pre_validation_b' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_acc_pre_validation_b.proc.sql

SELECT 'dfn_ntp.sp_calc_incident_od_interest_b' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_calc_incident_od_interest_b.proc.sql

SELECT 'dfn_ntp.sp_calc_incident_with_intrst_b' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_calc_incident_with_intrst_b.proc.sql

SELECT 'dfn_ntp.sp_capitalize_margin_interst_b' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_capitalize_margin_interst_b.proc.sql

SELECT 'dfn_ntp.sp_generate_acc_entries_b' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_generate_acc_entries_b.proc.sql

SELECT 'dfn_ntp.sp_re_calculate_margn_intrst_b' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_re_calculate_margn_intrst_b.proc.sql

SELECT 'dfn_ntp.sp_cust_portfoli_position_b' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_cust_portfoli_position_b.proc.sql

SELECT 'job_eod_csh_fee_blk_b2b_b' AS procedure_name FROM DUAL;

@@dfn_ntp.job_eod_csh_fee_blk_b2b_b.proc.sql

SELECT 'sp_capitalize_other_interest_b' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_capitalize_other_interest_b.proc.sql

SELECT 'sp_get_coupon_details_b' AS procedure_name FROM DUAL;

@@dfn_ntp.sp_get_coupon_details_b.proc.sql

SPOOL OFF