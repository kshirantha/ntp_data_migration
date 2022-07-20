DECLARE
    l_broker_id              NUMBER;
    l_broker_name            VARCHAR2 (10);
    l_primary_institute_id   NUMBER;
    l_txn_id                 NUMBER;
    l_sqlerrm                VARCHAR2 (4000);

    l_rec_cnt                NUMBER := 0;
    l_err_cnt                NUMBER := 0;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT VALUE
      INTO l_broker_name
      FROM migration_params
     WHERE code = 'BROKERAGE_NAME';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    DELETE FROM error_log
          WHERE mig_table = 'T02_TRANSACTION_LOG';

    SELECT NVL (dfn_ntp.order_audit_seq.NEXTVAL - 1, 0)
      INTO l_txn_id
      FROM DUAL;

    -- T05 Related Transactions (Orders and Cash Transactions)

    FOR i
        IN (  SELECT txn.t05_id,
                     CASE
                         WHEN txn.t05_code = 'ICMR' -- Single ICMR Generates Two Entries from Mapping
                         THEN
                             CASE
                                 WHEN txn.m97_code = 'CUDYORDFEE'
                                 THEN
                                     txn.t05_exchange_settle_amount
                                 WHEN txn.m97_code = 'CUDYHLDFEE'
                                 THEN
                                       txn.t05_amt_in_trans_currency -- T05_AMOUNT & T05_AMT_IN_TRANS_CURRENCY gets Same Value in This Scenario
                                     - txn.t05_exchange_settle_amount
                             END
                         ELSE
                             txn.t05_amt_in_trans_currency
                     END
                         AS t05_amt_in_trans_currency,
                     CASE
                         WHEN txn.t05_code = 'ICMR' -- Single ICMR Generates Two Entries from Mapping
                         THEN
                             CASE
                                 WHEN txn.m97_code = 'CUDYORDFEE'
                                 THEN
                                     txn.t05_exchange_settle_amount
                                 WHEN txn.m97_code = 'CUDYHLDFEE'
                                 THEN
                                       txn.t05_amt_in_settle_currency -- T05_AMOUNT & T05_AMT_IN_SETTLE_CURRENCY gets Same Value in This Scenario
                                     - txn.t05_exchange_settle_amount
                             END
                         ELSE
                             txn.t05_amt_in_settle_currency
                     END
                         AS t05_amt_in_settle_currency,
                     txn.new_cash_account_id,
                     txn.new_trading_account_id,
                     CASE
                         WHEN txn.u07_custodian_type_v01 <> 0 -- Custodian Related Transations
                         THEN
                             0
                         WHEN txn.t05_code IN ('STLBUY', 'REVSEL', 'STKSUB')
                         THEN
                             txn.t11_filled_volume
                         WHEN txn.t05_code IN ('STLSEL', 'REVBUY', 'REVSUB')
                         THEN
                             txn.t11_filled_volume * -1
                         ELSE
                             txn.t11_filled_volume
                     END
                         AS holding_net_adjst,
                     txn.m20_symbol_code,
                     txn.m20_exchange_code_m01,
                     CASE WHEN txn.m26_id IS NULL THEN -1 -- Updating Later in this Script
                                                         ELSE txn.m26_id END
                         AS custodian_id,
                     txn.t01_avgcost,
                     txn.u06_institute_id_m02,
                     CASE
                         WHEN txn.t05_code IN ('REVSEL', 'REVBUY', 'REVSUB')
                         THEN
                             1
                         ELSE
                             0
                     END
                         AS txn_entry_status,
                     txn.t05_last_shares,
                     txn.t05_timestamp,
                     txn.t05_date,
                     txn.new_cl_order_id,
                     txn.t05_lastpx,
                     txn.t01_avg_price,
                     txn.t05_commission,
                     txn.t01_ord_no,
                     NVL (txn.t11_exec_id, txn.t05_id) AS exec_id, -- [Onsite]
                     txn.t05_transaction_currency,
                     txn.t05_settle_currency,
                     txn.t05_exg_commission,
                     CASE
                         WHEN txn.t05_code = 'TRNFEE'
                         THEN
                             CASE
                                 WHEN txn.m264_type IS NOT NULL
                                 THEN
                                     CASE
                                         WHEN txn.m264_type = 2
                                         THEN
                                             'CTRFEE_BNK'
                                         WHEN txn.m264_type = 3
                                         THEN
                                             'CTRFEE_OTR'
                                         ELSE
                                             'CTRFEE_INT'
                                     END
                                 ELSE
                                     CASE
                                         WHEN txn.t05_reference_doc_narration LIKE
                                                  '%: SA%'
                                         THEN
                                             'CTRFEE_BNK'
                                         ELSE
                                             'CTRFEE_INT'
                                     END
                             END
                         ELSE
                             txn.m97_code
                     END
                         AS m97_code,
                     txn.t05_issue_stl_rate,
                     txn.t05_gl_post_date,
                     txn.t05_gl_posted_status,
                     txn.t05_commission_discount,
                     txn.t05_cash_txn_ref,
                     txn.u06_customer_id_u01,
                     txn.u06_customer_no_u01,
                     NVL (txn.t11_total_volume, txn.t05_orderqty)
                         AS total_volume, -- [Onsite]
                     txn.t05_payment_method,
                     txn.t05_reference_doc_narration,
                     txn.t05_settlement_date,
                     txn.m20_instrument_type_code_v09,
                     NVL (txn.t11_filled_volume, 0) AS filled_volume,
                     txn.m26_sid,
                     NVL (txn.t11_remaining_volume, 0) AS remaining_volume,
                     ROUND (
                           NVL (txn.t11_netsettle, 0)
                         / CASE
                               WHEN txn.t11_issue_stl_rate = 0 THEN 1
                               ELSE txn.t11_issue_stl_rate
                           END,
                         5)
                         AS cum_net_ord_value,
                     NVL (txn.t11_netsettle,
                          ABS (txn.t05_amt_in_settle_currency))
                         AS netsettle, -- [Onsite]
                     NVL (
                         txn.t11_side,
                         CASE
                             WHEN txn.t05_code = 'STLBUY' THEN 1
                             WHEN txn.t05_code = 'STLSEL' THEN 2
                         END)
                         AS order_side,
                     txn.m20_id,
                     txn.t05_profitloss,
                     txn.t05_broker_vat,
                     txn.t05_exchange_vat,
                     CASE
                         WHEN txn.t05_code IN
                                  ('STLBUY',
                                   'STLSEL',
                                   'STKSUB',
                                   'REVBUY',
                                   'REVSEL',
                                   'REVSUB')
                         THEN
                             1
                         ELSE
                             2
                     END
                         AS update_type,
                     NVL (txn.t11_ordstatus, 1) AS ordstatus, -- [SAME IDs] | If NULL Set as Partially Filled [Onsite]
                     txn.t05_fail_management_status, -- [SAME IDs]
                     CASE
                         WHEN txn.t05_code = 'ICMR' -- Single ICMR Two Generates Two Entries from Mapping
                         THEN
                             CASE
                                 WHEN txn.m97_code = 'CUDYORDFEE'
                                 THEN
                                     txn.t05_exchange_settle_amount
                                 WHEN txn.m97_code = 'CUDYHLDFEE'
                                 THEN
                                       txn.t05_amount
                                     - txn.t05_exchange_settle_amount
                             END
                         ELSE
                             CASE
                                 WHEN txn.u07_custodian_type_v01 <> 0
                                 THEN
                                     txn.t05_exchange_settle_amount
                                 ELSE
                                     txn.t05_amount
                             END
                     END
                         AS ord_value_adjst,
                     txn.t11_trd_match_id,
                     txn.t01_exchange_ord_id,
                     txn.t05_act_broker_vat,
                     txn.t05_act_exchange_vat,
                     txn.u07_custodian_type_v01,
                     NVL (txn.t11_unsettled_qty, 0) AS unsettled_qty,
                     CASE
                         WHEN NVL (txn.map16_ntp_code, txn.t05_exchange) =
                                  'TDWL'
                         THEN
                             CASE
                                 WHEN txn.t05_settlement_date <=
                                          TRUNC (SYSDATE)
                                 THEN
                                     25
                                 ELSE
                                     24
                             END
                         ELSE
                             CASE
                                 WHEN txn.t11_internal_status = 0 THEN 1
                                 WHEN txn.t11_internal_status = 1 THEN 24
                                 WHEN txn.t11_internal_status = 2 THEN 2
                                 WHEN txn.t11_internal_status = 3 THEN 3
                                 WHEN txn.t11_internal_status = 4 THEN 25
                             END
                     END
                         AS trade_processing_status, -- SFC Specific Logic
                     txn.new_bank_accounts_id,
                     CASE
                         WHEN txn.new_executing_broker_id IS NULL THEN -1 -- Updating Later in this Script
                         ELSE txn.new_executing_broker_id
                     END
                         AS exe_broker_id,
                     txn.t01_cma_exchange_vat,
                     txn.t01_cma_exchange_comm,
                     txn.t01_cpp_exchange_vat,
                     txn.t01_cpp_exchange_comm,
                     txn.t01_dcm_gcm_exchange_vat,
                     txn.t01_dcm_gcm_exchange_comm,
                     txn.t01_act_cma_exchange_vat,
                     txn.t01_act_cpp_exchange_vat,
                     txn.t01_act_dcm_gcm_exchange_vat,
                     txn.t01_initial_margin_amount,
                     txn.t01_maintain_margin_amount,
                     txn.u06_loan_amount,
                     txn.u06_withdr_overdrawn_amt,
                     txn.u06_incident_overdrawn_amt,
                     txn.u07_exchange_id_m01,
                     txn.t01_ord_channel_id_v29,
                     txn.t01_dealer_id_u17,
                     NVL (txn.t11_accrued_interest, 0) AS t11_accrued_interest,
                     txn.t01_other_commission,
                     txn.t01_other_tax,
                     txn.t01_other_cum_commission,
                     txn.t01_other_cum_tax,
                     txn.t05_algo_commission,
                     txn.t05_algo_commission_vat,
                     txn.new_cash_txn_log_id
                FROM ( -- None INDCH Transactions
                      SELECT t05.t05_id,
                             t05.t05_code,
                             m97.m97_code,
                             t05.t05_exchange_settle_amount,
                             t05.t05_amt_in_trans_currency,
                             t05.t05_amt_in_settle_currency,
                             u06_map.new_cash_account_id,
                             u07_map.new_trading_account_id,
                             t11.t11_filled_volume,
                             m20.m20_symbol_code,
                             m20.m20_exchange_code_m01,
                             m26.m26_id,
                             t01_oms.t01_avgcost,
                             u06.u06_institute_id_m02,
                             t05.t05_last_shares,
                             t05.t05_timestamp,
                             t05.t05_date,
                             t01_map.new_cl_order_id,
                             t05.t05_lastpx,
                             t01.t01_avg_price,
                             t05.t05_commission,
                             t01.t01_ord_no,
                             t11.t11_exec_id,
                             t05.t05_transaction_currency,
                             t05.t05_settle_currency,
                             t05.t05_exg_commission,
                             m264.m264_type,
                             t05.t05_issue_stl_rate,
                             t05.t05_gl_post_date,
                             t05.t05_gl_posted_status,
                             t05.t05_commission_discount,
                             t05.t05_cash_txn_ref,
                             u06.u06_customer_id_u01,
                             u06.u06_customer_no_u01,
                             t11.t11_total_volume,
                             t05.t05_orderqty,
                             t05.t05_payment_method,
                             t05.t05_reference_doc_narration,
                             t05.t05_settlement_date,
                             t11.t11_internal_status,
                             m20.m20_instrument_type_code_v09,
                             m26.m26_sid,
                             t11.t11_remaining_volume,
                             t11.t11_netsettle,
                             t11.t11_side,
                             t11.t11_issue_stl_rate,
                             m20.m20_id,
                             t05.t05_profitloss,
                             t05.t05_broker_vat,
                             t05.t05_exchange_vat,
                             t05.t05_amount,
                             t11.t11_ordstatus,
                             t05.t05_fail_management_status, -- [SAME IDs]
                             t11.t11_trd_match_id,
                             t01.t01_exchange_ord_id,
                             t05.t05_act_broker_vat,
                             t05.t05_act_exchange_vat,
                             u07.u07_custodian_type_v01,
                             t11.t11_unsettled_qty,
                             t05.t05_exchange,
                             map16.map16_ntp_code,
                             m93_map.new_bank_accounts_id,
                             m26_map_broker.new_executing_broker_id,
                             t01_oms.t01_cma_exchange_vat,
                             t01_oms.t01_cma_exchange_comm,
                             t01_oms.t01_cpp_exchange_vat,
                             t01_oms.t01_cpp_exchange_comm,
                             t01_oms.t01_dcm_gcm_exchange_vat,
                             t01_oms.t01_dcm_gcm_exchange_comm,
                             t01_oms.t01_act_cma_exchange_vat,
                             t01_oms.t01_act_cpp_exchange_vat,
                             t01_oms.t01_act_dcm_gcm_exchange_vat,
                             t01_oms.t01_initial_margin_amount,
                             t01_oms.t01_maintain_margin_amount,
                             u06.u06_loan_amount,
                             u06.u06_withdr_overdrawn_amt,
                             u06.u06_incident_overdrawn_amt,
                             u07.u07_exchange_id_m01,
                             t01.t01_ord_channel_id_v29,
                             t01.t01_dealer_id_u17,
                             t11.t11_accrued_interest,
                             t01.t01_other_commission,
                             t01.t01_other_tax,
                             t01.t01_other_cum_commission,
                             t01.t01_other_cum_tax,
                             t05.t05_algo_commission,
                             t05.t05_algo_commission_vat,
                             t02_map.new_cash_txn_log_id
                        FROM mubasher_oms.t05_cash_account_log@mubasher_db_link t05,
                             (  SELECT t05_orderno
                                  FROM mubasher_oms.t05_cash_account_log@mubasher_db_link
                                 WHERE t05_code = 'INDCH'
                              GROUP BY t05_orderno) t05_indch,
                             mubasher_oms.t12_pending_cash@mubasher_db_link t12,
                             mubasher_oms.m264_beneficiary_accounts@mubasher_db_link m264,
                             m02_institute_mappings m02_map,
                             u06_cash_account_mappings u06_map,
                             dfn_ntp.u06_cash_account u06,
                             map15_transaction_codes_m97 map15,
                             dfn_ntp.m97_transaction_codes m97,
                             u07_trading_account_mappings u07_map,
                             map16_optional_exchanges_m01 map16,
                             dfn_ntp.u07_trading_account u07,
                             mubasher_oms.t11_executed_orders@mubasher_db_link t11,
                             (SELECT m20_id,
                                     m20_symbol_code,
                                     m20_exchange_code_m01,
                                     m20_instrument_type_code_v09,
                                     m20_currency_code_m03
                                FROM dfn_ntp.m20_symbol
                               WHERE m20_institute_id_m02 =
                                         l_primary_institute_id) m20,
                             m26_executing_broker_mappings m26_map,
                             dfn_ntp.m26_executing_broker m26,
                             m26_executing_broker_mappings m26_map_broker,
                             t01_order_mappings t01_map,
                             dfn_ntp.t01_order t01,
                             mubasher_oms.t01_order_summary_intraday@mubasher_db_link t01_oms,
                             m93_bank_accounts_mappings m93_map,
                             dfn_mig.t02_transaction_log_mappings t02_map
                       WHERE     t05.t05_orderno = t05_indch.t05_orderno(+)
                             AND t05_indch.t05_orderno IS NULL
                             AND t05.t05_cash_txn_ref = t12.t12_id(+)
                             AND t12.t12_benificiary_id = m264.m264_id(+)
                             AND t05.t05_inst_id = m02_map.old_institute_id
                             AND t05.t05_cash_account_id =
                                     u06_map.old_cash_account_id(+)
                             AND u06_map.new_cash_account_id = u06.u06_id(+)
                             AND t05.t05_code = map15.map15_oms_code(+)
                             AND map15.map15_ntp_code = m97.m97_code(+)
                             AND t05.t05_security_ac_id =
                                     u07_map.old_trading_account_id(+)
                             AND t05.t05_exchange = map16.map16_oms_code(+)
                             AND NVL (map16.map16_ntp_code, t05.t05_exchange) =
                                     u07_map.exchange_code(+)
                             AND u07_map.new_trading_account_id = u07.u07_id(+)
                             AND t05.t05_id = t11.t11_t05_exec_id(+)
                             AND NVL (map16.map16_ntp_code, t05.t05_exchange) =
                                     m20.m20_exchange_code_m01(+)
                             AND t05.t05_symbol = m20.m20_symbol_code(+)
                             AND t05.t05_custodian_inst_id =
                                     m26_map.old_executing_broker_id(+)
                             AND m26_map.new_executing_broker_id =
                                     m26.m26_id(+)
                             AND t05.t05_exec_broker_id =
                                     m26_map_broker.old_executing_broker_id(+)
                             AND t11.t11_clordid = t01_map.old_cl_order_id(+)
                             AND t01_map.new_cl_order_id = t01.t01_cl_ord_id(+)
                             AND t11.t11_clordid = t01_oms.t01_clordid(+)
                             AND t05.t05_bank_id =
                                     m93_map.old_bank_accounts_id(+)
                             AND t05.t05_id = t02_map.old_cash_txn_log_id(+)
                             AND CASE
                                     WHEN t05.t05_code = 'TRNFEE'
                                     THEN
                                         CASE
                                             WHEN m264.m264_type IS NOT NULL
                                             THEN
                                                 CASE
                                                     WHEN m264.m264_type = 2
                                                     THEN
                                                         'CTRFEE_BNK'
                                                     WHEN m264.m264_type = 3
                                                     THEN
                                                         'CTRFEE_OTR'
                                                     ELSE
                                                         'CTRFEE_INT'
                                                 END
                                             ELSE
                                                 CASE
                                                     WHEN t05_reference_doc_narration LIKE
                                                              '%: SA%'
                                                     THEN
                                                         'CTRFEE_BNK'
                                                     ELSE
                                                         'CTRFEE_INT'
                                                 END
                                         END
                                     ELSE
                                         m97.m97_code
                                 END = t02_map.new_txn_code(+)
                      UNION ALL
                      -- Capturing INDCH Transactions as Single Transaction
                      SELECT t05.t05_id,
                             t05.t05_code,
                             m97.m97_code,
                             t05.t05_exchange_settle_amount,
                             t05.t05_amt_in_trans_currency,
                             t05.t05_amt_in_settle_currency,
                             u06_map.new_cash_account_id,
                             u07_map.new_trading_account_id,
                             t11.t11_filled_volume,
                             m20.m20_symbol_code,
                             m20.m20_exchange_code_m01,
                             m26.m26_id,
                             t01_oms.t01_avgcost,
                             u06.u06_institute_id_m02,
                             t05.t05_last_shares,
                             t05.t05_timestamp,
                             t05.t05_date,
                             t01_map.new_cl_order_id,
                             t05.t05_lastpx,
                             t01.t01_avg_price,
                             t05.t05_commission,
                             t01.t01_ord_no,
                             t11.t11_exec_id,
                             t05.t05_transaction_currency,
                             t05.t05_settle_currency,
                             t05.t05_exg_commission,
                             m264.m264_type,
                             t05.t05_issue_stl_rate,
                             t05.t05_gl_post_date,
                             t05.t05_gl_posted_status,
                             t05.t05_commission_discount,
                             t05.t05_cash_txn_ref,
                             u06.u06_customer_id_u01,
                             u06.u06_customer_no_u01,
                             t11.t11_total_volume,
                             t05.t05_orderqty,
                             t05.t05_payment_method,
                             t05.t05_reference_doc_narration,
                             t05.t05_settlement_date,
                             t11.t11_internal_status,
                             m20.m20_instrument_type_code_v09,
                             m26.m26_sid,
                             t11.t11_remaining_volume,
                             t11.t11_netsettle,
                             t11.t11_side,
                             t11.t11_issue_stl_rate,
                             m20.m20_id,
                             t05.t05_profitloss,
                             t05.t05_broker_vat,
                             t05.t05_exchange_vat,
                             t05.t05_amount,
                             t11.t11_ordstatus,
                             t05.t05_fail_management_status, -- [SAME IDs]
                             t11.t11_trd_match_id,
                             t01.t01_exchange_ord_id,
                             t05.t05_act_broker_vat,
                             t05.t05_act_exchange_vat,
                             u07.u07_custodian_type_v01,
                             t11.t11_unsettled_qty,
                             t05.t05_exchange,
                             map16.map16_ntp_code,
                             m93_map.new_bank_accounts_id,
                             m26_map_broker.new_executing_broker_id,
                             t01_oms.t01_cma_exchange_vat,
                             t01_oms.t01_cma_exchange_comm,
                             t01_oms.t01_cpp_exchange_vat,
                             t01_oms.t01_cpp_exchange_comm,
                             t01_oms.t01_dcm_gcm_exchange_vat,
                             t01_oms.t01_dcm_gcm_exchange_comm,
                             t01_oms.t01_act_cma_exchange_vat,
                             t01_oms.t01_act_cpp_exchange_vat,
                             t01_oms.t01_act_dcm_gcm_exchange_vat,
                             t01_oms.t01_initial_margin_amount,
                             t01_oms.t01_maintain_margin_amount,
                             u06.u06_loan_amount,
                             u06.u06_withdr_overdrawn_amt,
                             u06.u06_incident_overdrawn_amt,
                             u07.u07_exchange_id_m01,
                             t01.t01_ord_channel_id_v29,
                             t01.t01_dealer_id_u17,
                             t11.t11_accrued_interest,
                             t01.t01_other_commission,
                             t01.t01_other_tax,
                             t01.t01_other_cum_commission,
                             t01.t01_other_cum_tax,
                             t05.t05_algo_commission,
                             t05.t05_algo_commission_vat,
                             t02_map.new_cash_txn_log_id
                        FROM (  SELECT MIN (t05_id) AS t05_id,
                                       t05_orderno AS t05_orderno,
                                       MIN (t05_code) AS t05_code,
                                       SUM (t05_amount) AS t05_amount,
                                       MIN (t05_reference_doc_narration)
                                           AS t05_reference_doc_narration,
                                       SUM (t05_commission) AS t05_commission,
                                       SUM (t05_amt_in_trans_currency)
                                           AS t05_amt_in_trans_currency,
                                       0 AS t05_lastpx,
                                       SUM (t05_exg_commission)
                                           AS t05_exg_commission,
                                       0 AS t05_last_shares,
                                       SUM (t05_exchange_settle_amount)
                                           AS t05_exchange_settle_amount,
                                       SUM (t05_amt_in_settle_currency)
                                           AS t05_amt_in_settle_currency,
                                       0 AS t05_orderqty,
                                       SUM (t05_profitloss) AS t05_profitloss,
                                       0 AS t05_exchange_vat,
                                       0 AS t05_act_exchange_vat,
                                       MIN (t05_timestamp) AS t05_timestamp,
                                       MIN (t05_date) AS t05_date,
                                       MIN (t05_transaction_currency)
                                           AS t05_transaction_currency,
                                       MIN (t05_settle_currency)
                                           AS t05_settle_currency,
                                       MIN (t05_issue_stl_rate)
                                           AS t05_issue_stl_rate,
                                       MIN (t05_gl_post_date) AS t05_gl_post_date,
                                       MIN (t05_gl_posted_status)
                                           AS t05_gl_posted_status,
                                       0 AS t05_commission_discount,
                                       MIN (t05_cash_txn_ref) AS t05_cash_txn_ref,
                                       MIN (t05_payment_method)
                                           AS t05_payment_method,
                                       MIN (t05_settlement_date)
                                           AS t05_settlement_date,
                                       0 AS t05_broker_vat,
                                       MIN (t05_fail_management_status)
                                           AS t05_fail_management_status,
                                       0 AS t05_act_broker_vat,
                                       MIN (t05_exchange) AS t05_exchange,
                                       MIN (t05_bank_id) AS t05_bank_id,
                                       MIN (t05_exec_broker_id)
                                           AS t05_exec_broker_id,
                                       MIN (t05_custodian_inst_id)
                                           AS t05_custodian_inst_id,
                                       MIN (t05_symbol) AS t05_symbol,
                                       MIN (t05_security_ac_id)
                                           AS t05_security_ac_id,
                                       MIN (t05_cash_account_id)
                                           AS t05_cash_account_id,
                                       MIN (t05_inst_id) AS t05_inst_id,
                                       SUM (t05_algo_commission)
                                           AS t05_algo_commission,
                                       SUM (t05_algo_commission_vat)
                                           AS t05_algo_commission_vat
                                  FROM (SELECT t05.t05_id,
                                               t05.t05_orderno,
                                               MIN (
                                                   t05.t05_code_min)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_code,
                                               t05_amount,
                                               MIN (
                                                   t05.t05_reference_doc_narration)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_reference_doc_narration,
                                               t05_commission,
                                               t05_amt_in_trans_currency,
                                               t05_exg_commission,
                                               t05_exchange_settle_amount,
                                               t05_amt_in_settle_currency,
                                               t05_profitloss,
                                               MIN (
                                                   t05.t05_timestamp)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_timestamp,
                                               MIN (
                                                   t05.t05_date)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_date,
                                               MIN (
                                                   t05.t05_transaction_currency)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_transaction_currency,
                                               MIN (
                                                   t05.t05_settle_currency)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_settle_currency,
                                               MIN (
                                                   t05.t05_issue_stl_rate)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_issue_stl_rate,
                                               MIN (
                                                   t05.t05_gl_post_date)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_gl_post_date,
                                               MIN (
                                                   t05.t05_gl_posted_status)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_gl_posted_status,
                                               MIN (
                                                   t05.t05_cash_txn_ref)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_cash_txn_ref,
                                               MIN (
                                                   t05.t05_payment_method)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_payment_method,
                                               MIN (
                                                   t05.t05_settlement_date)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_settlement_date,
                                               MIN (
                                                   t05.t05_fail_management_status)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_fail_management_status,
                                               MIN (
                                                   t05.t05_exchange)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_exchange,
                                               MIN (
                                                   t05.t05_bank_id)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_bank_id,
                                               MIN (
                                                   t05.t05_exec_broker_id)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_exec_broker_id,
                                               MIN (
                                                   t05.t05_custodian_inst_id)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_custodian_inst_id,
                                               MIN (
                                                   t05.t05_symbol)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_symbol,
                                               MIN (
                                                   t05.t05_security_ac_id)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_security_ac_id,
                                               MIN (
                                                   t05.t05_cash_account_id)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_cash_account_id,
                                               MIN (
                                                   t05.t05_inst_id)
                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                          t05.t05_id)
                                               OVER (
                                                   PARTITION BY t05.t05_orderno)
                                                   AS t05_inst_id,
                                               t05.t05_algo_commission,
                                               t05.t05_algo_commission_vat
                                          FROM (SELECT t05.*,
                                                       CASE
                                                           WHEN MIN (
                                                                    t05_code)
                                                                KEEP (DENSE_RANK FIRST ORDER BY
                                                                                           t05_id)
                                                                OVER (
                                                                    PARTITION BY t05_orderno) IN
                                                                    ('STLBUY',
                                                                     'STLSEL')
                                                           THEN
                                                               MIN (
                                                                   t05_code)
                                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                                          t05_id)
                                                               OVER (
                                                                   PARTITION BY t05_orderno)
                                                           ELSE
                                                               MAX (
                                                                   t05_code)
                                                               KEEP (DENSE_RANK FIRST ORDER BY
                                                                                          t05_id DESC)
                                                               OVER (
                                                                   PARTITION BY t05_orderno)
                                                       END
                                                           AS t05_code_min
                                                  FROM mubasher_oms.t05_cash_account_log@mubasher_db_link t05) t05,
                                               (  SELECT t05_orderno
                                                    FROM mubasher_oms.t05_cash_account_log@mubasher_db_link
                                                   WHERE t05_code = 'INDCH'
                                                GROUP BY t05_orderno) t05_indch
                                         WHERE t05.t05_orderno =
                                                   t05_indch.t05_orderno)
                              GROUP BY t05_orderno) t05,
                             mubasher_oms.t12_pending_cash@mubasher_db_link t12,
                             mubasher_oms.m264_beneficiary_accounts@mubasher_db_link m264,
                             m02_institute_mappings m02_map,
                             u06_cash_account_mappings u06_map,
                             dfn_ntp.u06_cash_account u06,
                             map15_transaction_codes_m97 map15,
                             dfn_ntp.m97_transaction_codes m97,
                             u07_trading_account_mappings u07_map,
                             map16_optional_exchanges_m01 map16,
                             dfn_ntp.u07_trading_account u07,
                             mubasher_oms.t11_executed_orders@mubasher_db_link t11,
                             (SELECT m20_id,
                                     m20_symbol_code,
                                     m20_exchange_code_m01,
                                     m20_instrument_type_code_v09,
                                     m20_currency_code_m03
                                FROM dfn_ntp.m20_symbol
                               WHERE m20_institute_id_m02 =
                                         l_primary_institute_id) m20,
                             m26_executing_broker_mappings m26_map,
                             dfn_ntp.m26_executing_broker m26,
                             m26_executing_broker_mappings m26_map_broker,
                             t01_order_mappings t01_map,
                             dfn_ntp.t01_order t01,
                             mubasher_oms.t01_order_summary_intraday@mubasher_db_link t01_oms,
                             m93_bank_accounts_mappings m93_map,
                             dfn_mig.t02_transaction_log_mappings t02_map
                       WHERE     t05.t05_cash_txn_ref = t12.t12_id(+)
                             AND t12.t12_benificiary_id = m264.m264_id(+)
                             AND t05.t05_inst_id = m02_map.old_institute_id
                             AND t05.t05_cash_account_id =
                                     u06_map.old_cash_account_id(+)
                             AND u06_map.new_cash_account_id = u06.u06_id(+)
                             AND t05.t05_code = map15.map15_oms_code(+)
                             AND map15.map15_ntp_code = m97.m97_code(+)
                             AND t05.t05_security_ac_id =
                                     u07_map.old_trading_account_id(+)
                             AND t05.t05_exchange = map16.map16_oms_code(+)
                             AND NVL (map16.map16_ntp_code, t05.t05_exchange) =
                                     u07_map.exchange_code(+)
                             AND u07_map.new_trading_account_id = u07.u07_id(+)
                             AND t05.t05_id = t11.t11_t05_exec_id(+)
                             AND NVL (map16.map16_ntp_code, t05.t05_exchange) =
                                     m20.m20_exchange_code_m01(+)
                             AND t05.t05_symbol = m20.m20_symbol_code(+)
                             AND t05.t05_custodian_inst_id =
                                     m26_map.old_executing_broker_id(+)
                             AND m26_map.new_executing_broker_id =
                                     m26.m26_id(+)
                             AND t05.t05_exec_broker_id =
                                     m26_map_broker.old_executing_broker_id(+)
                             AND t11.t11_clordid = t01_map.old_cl_order_id(+)
                             AND t01_map.new_cl_order_id = t01.t01_cl_ord_id(+)
                             AND t11.t11_clordid = t01_oms.t01_clordid(+)
                             AND t05.t05_bank_id =
                                     m93_map.old_bank_accounts_id(+)
                             AND t05.t05_id = t02_map.old_cash_txn_log_id(+)
                             AND CASE
                                     WHEN t05.t05_code = 'TRNFEE'
                                     THEN
                                         CASE
                                             WHEN m264.m264_type IS NOT NULL
                                             THEN
                                                 CASE
                                                     WHEN m264.m264_type = 2
                                                     THEN
                                                         'CTRFEE_BNK'
                                                     WHEN m264.m264_type = 3
                                                     THEN
                                                         'CTRFEE_OTR'
                                                     ELSE
                                                         'CTRFEE_INT'
                                                 END
                                             ELSE
                                                 CASE
                                                     WHEN t05_reference_doc_narration LIKE
                                                              '%: SA%'
                                                     THEN
                                                         'CTRFEE_BNK'
                                                     ELSE
                                                         'CTRFEE_INT'
                                                 END
                                         END
                                     ELSE
                                         m97.m97_code
                                 END = t02_map.new_txn_code(+)) txn
            ORDER BY txn.t05_id)
    LOOP
        BEGIN
            IF i.m97_code IS NULL
            THEN
                raise_application_error (-20001,
                                         'Transaction Code Not Available',
                                         TRUE);
            END IF;

            /*  Discussed to Skip the Validation

            IF i.update_type = 1 AND i.t11_exec_id IS NULL
              THEN
                  raise_application_error (-20001,
                                           'Order Execution Not Available',
                                           TRUE);
              END IF;
            */

            IF i.new_cash_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Cash Account Not Available',
                                         TRUE);
            END IF;

            IF i.u06_customer_id_u01 IS NULL
            THEN
                raise_application_error (-20001,
                                         'Customer Not Available',
                                         TRUE);
            END IF;

            IF i.new_cash_txn_log_id IS NULL
            THEN
                l_txn_id := l_txn_id + 1;

                INSERT
                  INTO dfn_ntp.t02_transaction_log (
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
                           t02_origin_txn_id,
                           t02_txn_refrence_id,
                           t02_trade_confirm_no,
                           t02_master_ref,
                           t02_exec_broker_id_m26,
                           t02_option_base_holding_block,
                           t02_option_base_cash_block,
                           t02_reference_type,
                           t02_short_holding_block,
                           t02_is_archive_ready,
                           t02_allocated_qty,
                           t02_exec_cma_tax,
                           t02_exec_cpp_tax,
                           t02_exec_dcm_tax,
                           t02_exec_act_cma_tax,
                           t02_exec_act_cpp_tax,
                           t02_exec_act_dcm_tax,
                           t02_exec_cma_comission,
                           t02_exec_cpp_comission,
                           t02_exec_dcm_comission,
                           t02_orig_exg_tax,
                           t02_orig_brk_tax,
                           t02_fixing_price,
                           t02_m2m_gain,
                           t02_initial_margin_charge,
                           t02_notional_value,
                           t02_exec_initial_margin_value,
                           t02_exec_maintain_margin_value,
                           t02_loan_amount,
                           t02_withdr_overdrawn_amt,
                           t02_incident_overdrawn_amt,
                           t02_exchange_id_m01,
                           t02_ord_channel_id_v29,
                           t02_dealer_id_u17,
                           t02_narration_lang,
                           t02_other_commission,
                           t02_other_tax,
                           t02_other_cum_commission,
                           t02_other_cum_tax,
                           t02_exec_other_commission,
                           t02_exec_other_tax,
                           t02_eod_bulk_post_b)
                VALUES (i.t05_amt_in_trans_currency, -- t02_amnt_in_txn_currency
                        i.t05_amt_in_settle_currency, -- t02_amnt_in_stl_currency
                        i.new_cash_account_id, -- t02_cash_acnt_id_u06
                        0, -- t02_cash_block | Not Available and Not Necessary to Calculate
                        0, -- t02_cash_block_orig | Not Available and Not Necessary to Calculate
                        0, -- t02_cash_block_adjst | Not Available and Not Necessary to Calculate
                        0, -- t02_cash_balance | Not Available and Not Necessary to Calculate
                        NULL, -- t02_cash_acnt_seq_id
                        i.new_trading_account_id, -- t02_trd_acnt_id_u07
                        0, -- t02_holding_net | Not Available and Not Necessary to Calculate
                        0, -- t02_holding_block
                        0, -- t02_holding_block_adjst
                        i.holding_net_adjst, -- t02_holding_net_adjst
                        i.m20_symbol_code, -- t02_symbol_code_m20
                        i.m20_exchange_code_m01, -- t02_exchange_code_m01
                        i.custodian_id, -- t02_custodian_id_m26
                        i.t01_avgcost, -- t02_holding_avg_cost
                        i.u06_institute_id_m02, -- t02_inst_id_m02
                        i.txn_entry_status, -- t02_txn_entry_status | Update Later in this Script
                        i.t05_last_shares, -- t02_last_shares
                        i.t05_timestamp, -- t02_create_datetime
                        i.t05_date, -- t02_create_date
                        i.new_cl_order_id, -- t02_cliordid_t01
                        i.t05_lastpx, -- t02_last_price
                        i.t01_avg_price, -- t02_avgprice
                        0, -- t02_cum_commission | Update Later in this Script
                        i.t05_commission, -- t02_commission_adjst
                        i.t01_ord_no, -- t02_order_no
                        i.exec_id, -- t02_order_exec_id
                        i.t05_transaction_currency, -- t02_txn_currency
                        i.t05_settle_currency, -- t02_settle_currency
                        i.t05_exg_commission, -- t02_exg_commission
                        i.m97_code, -- t02_txn_code
                        i.t05_issue_stl_rate, -- t02_fx_rate
                        i.t05_gl_post_date, -- t02_gl_posted_date
                        i.t05_gl_posted_status, -- t02_gl_posted_status
                        i.t05_commission_discount, -- t02_discount
                        i.t05_cash_txn_ref, -- t02_cashtxn_id | Updating Later in the Post Migration Script
                        NULL, -- t02_holdingtxn_id
                        i.u06_customer_id_u01, -- t02_customer_id_u01
                        i.u06_customer_no_u01, -- t02_customer_no
                        i.total_volume, -- t02_ordqty
                        i.t05_payment_method, -- t02_pay_method
                        i.t05_reference_doc_narration, -- t02_narration
                        i.t05_settlement_date, -- t02_cash_settle_date
                        i.t05_settlement_date, -- t02_holding_settle_date
                        0, -- t02_buy_pending
                        0, -- t02_sell_pending
                        i.m20_instrument_type_code_v09, -- t02_instrument_type
                        i.filled_volume, -- t02_cum_qty
                        0, -- t02_holding_manual_block
                        0, -- t02_possision_type
                        0, -- t02_accrude_interest
                        i.t11_accrued_interest, -- t02_accrude_interest_adjst
                        i.m26_sid, -- t02_counter_broker
                        i.t05_timestamp, -- t02_txn_time
                        i.remaining_volume, -- t02_leaves_qty
                        l_broker_name || l_txn_id, -- t02_text
                        0, -- t02_cumord_value | Updating Later in this Script
                        i.cum_net_ord_value, -- t02_cumord_netvalue
                        i.netsettle, -- t02_cumord_netsettle
                        l_txn_id, -- t02_audit_key
                        NULL, -- t02_pledge_qty
                        i.order_side, -- t02_side
                        i.m20_id, -- t02_symbol_id_m20
                        i.t05_profitloss, -- t02_gainloss
                        i.t05_broker_vat, -- t02_broker_tax
                        i.t05_exchange_vat, -- t02_exchange_tax
                        i.update_type, -- t02_update_type
                        i.t05_date, -- t02_db_create_date
                        i.ordstatus, -- t02_ord_status_v30
                        i.t05_fail_management_status, -- t02_fail_management_status
                        i.ord_value_adjst, -- t02_ord_value_adjst
                        i.t11_trd_match_id, -- t02_trade_match_id
                        i.t01_exchange_ord_id, -- t02_exg_ord_id
                        i.t05_act_broker_vat, -- t02_act_broker_tax
                        i.t05_act_exchange_vat, -- t02_act_exchange_tax
                        i.t05_settlement_date, -- t02_cash_settle_date_orig
                        i.t05_settlement_date, -- t02_holding_settle_date_orig
                        0, -- t02_ib_commission
                        i.u07_custodian_type_v01, -- t02_custodian_type_v01
                        NULL, -- t02_base_symbol_code_m20
                        NULL, -- t02_base_sym_exchange_m01
                        0, -- t02_base_holding_block
                        i.unsettled_qty, -- t02_unsettle_qty
                        0, -- t02_cash_balance_orig
                        i.trade_processing_status, -- t02_trade_process_stat_id_v01
                        l_txn_id, -- t02_last_db_seq_id
                        i.new_bank_accounts_id, -- 02_bank_id_m93
                        NULL, -- t02_settle_cal_conf_id_m95
                        NULL, -- t02_original_exchange_ord_id | Updating Later in this Script
                        NULL, -- t02_origin_txn_id | Execution Reversal Not Available [AUDI]
                        NULL, -- t02_txn_refrence_id
                        NULL, -- t02_trade_confirm_no | Not Available
                        NULL, --  t02_master_ref | Not Available
                        i.exe_broker_id, -- t02_exec_broker_id_m26
                        NULL, --  t02_option_base_holding_block | Not Available
                        NULL, --  t02_option_base_cash_block | Not Available
                        NULL, --  t02_reference_type | Not Available
                        NULL, -- t02_short_holding_block | Not Available
                        0, -- t02_is_archive_ready
                        0, -- t02_allocated_qty | Not Available
                        i.t01_cma_exchange_vat, -- t02_exec_cma_tax
                        i.t01_cpp_exchange_vat, -- t02_exec_cpp_tax
                        i.t01_dcm_gcm_exchange_vat, -- t02_exec_dcm_tax
                        i.t01_act_cma_exchange_vat, -- t02_exec_act_cma_tax
                        i.t01_act_cpp_exchange_vat, -- t02_exec_act_cpp_tax
                        i.t01_act_dcm_gcm_exchange_vat, -- t02_exec_act_dcm_tax
                        i.t01_cma_exchange_comm, -- t02_exec_cma_comission
                        i.t01_cpp_exchange_comm, -- t02_exec_cpp_comission
                        i.t01_dcm_gcm_exchange_comm, -- t02_exec_dcm_comission
                        NULL, -- t02_orig_exg_tax | Not Available
                        NULL, -- t02_orig_brk_tax | Not Available
                        NULL, -- t02_fixing_price | Not Available
                        NULL, -- t02_m2m_gain | Not Available
                        NULL, -- t02_initial_margin_charge | Not Available
                        NULL, -- t02_notional_value | Not Available
                        i.t01_initial_margin_amount, -- t02_exec_initial_margin_value
                        i.t01_maintain_margin_amount, -- t02_exec_maintain_margin_value
                        i.u06_loan_amount, -- t02_loan_amount
                        i.u06_withdr_overdrawn_amt, -- t02_withdr_overdrawn_amt
                        i.u06_incident_overdrawn_amt, -- t02_incident_overdrawn_amt
                        i.u07_exchange_id_m01, -- t02_exchange_id_m01
                        i.t01_ord_channel_id_v29, -- t02_ord_channel_id_v29
                        i.t01_dealer_id_u17, -- t02_dealer_id_u17
                        i.t05_reference_doc_narration, -- t02_narration_lang
                        i.t01_other_commission, -- t02_other_commission
                        i.t01_other_tax, -- t02_other_tax
                        i.t01_other_cum_commission, -- t02_other_cum_commission
                        i.t01_other_cum_tax, -- t02_other_cum_tax
                        i.t05_algo_commission, -- t02_exec_other_commission
                        i.t05_algo_commission_vat, -- t02_exec_other_tax
                        0 -- t02_eod_bulk_post_b | Not Available
                         );

                INSERT INTO t02_transaction_log_mappings
                     VALUES (i.t05_id,
                             NULL,
                             l_txn_id,
                             NULL,
                             i.m97_code);
            ELSE
                NULL; -- No need to update t02 as during parallel run tranactions are auto integrtaed
            /* UPDATE dfn_ntp.t02_transaction_log
                SET t02_amnt_in_txn_currency = i.t05_amt_in_trans_currency, -- t02_amnt_in_txn_currency
                    t02_amnt_in_stl_currency = i.t05_amt_in_settle_currency, -- t02_amnt_in_stl_currency
                    t02_cash_acnt_id_u06 = i.new_cash_account_id, -- t02_cash_acnt_id_u06
                    t02_trd_acnt_id_u07 = i.new_trading_account_id, -- t02_trd_acnt_id_u07
                    t02_holding_net_adjst = i.holding_net_adjst, -- t02_holding_net_adjst
                    t02_symbol_code_m20 = i.m20_symbol_code, -- t02_symbol_code_m20
                    t02_exchange_code_m01 = i.m20_exchange_code_m01, -- t02_exchange_code_m01
                    t02_custodian_id_m26 = i.custodian_id, -- t02_custodian_id_m26
                    t02_holding_avg_cost = i.t01_avgcost, -- t02_holding_avg_cost
                    t02_inst_id_m02 = i.u06_institute_id_m02, -- t02_inst_id_m02
                    t02_txn_entry_status = i.txn_entry_status, -- t02_txn_entry_status | Update Later in this Script
                    t02_last_shares = i.t05_last_shares, -- t02_last_shares
                    t02_cliordid_t01 = i.new_cl_order_id, -- t02_cliordid_t01
                    t02_last_price = i.t05_lastpx, -- t02_last_price
                    t02_avgprice = i.t01_avg_price, -- t02_avgprice
                    t02_commission_adjst = i.t05_commission, -- t02_commission_adjst
                    t02_order_no = i.t01_ord_no, -- t02_order_no
                    t02_order_exec_id = i.exec_id, -- t02_order_exec_id
                    t02_txn_currency = i.t05_transaction_currency, -- t02_txn_currency
                    t02_settle_currency = i.t05_settle_currency, -- t02_settle_currency
                    t02_exg_commission = i.t05_exg_commission, -- t02_exg_commission
                    t02_txn_code = i.m97_code, -- t02_txn_code
                    t02_fx_rate = i.t05_issue_stl_rate, -- t02_fx_rate
                    t02_gl_posted_date = i.t05_gl_post_date, -- t02_gl_posted_date
                    t02_gl_posted_status = i.t05_gl_posted_status, -- t02_gl_posted_status
                    t02_discount = i.t05_commission_discount, -- t02_discount
                    t02_cashtxn_id = i.t05_cash_txn_ref, -- t02_cashtxn_id | Updating Later in the Post Migration Script
                    t02_customer_id_u01 = i.u06_customer_id_u01, -- t02_customer_id_u01
                    t02_customer_no = i.u06_customer_no_u01, -- t02_customer_no
                    t02_ordqty = i.total_volume, -- t02_ordqty
                    t02_pay_method = i.t05_payment_method, -- t02_pay_method
                    t02_narration = i.t05_reference_doc_narration, -- t02_narration
                    t02_cash_settle_date = i.t05_settlement_date, -- t02_cash_settle_date
                    t02_holding_settle_date = i.t05_settlement_date, -- t02_holding_settle_date
                    t02_instrument_type = i.m20_instrument_type_code_v09, -- t02_instrument_type
                    t02_cum_qty = i.filled_volume, -- t02_cum_qty
                    t02_accrude_interest_adjst = i.t11_accrued_interest, -- t02_accrude_interest_adjst
                    t02_counter_broker = i.m26_sid, -- t02_counter_broker
                    t02_txn_time = i.t05_timestamp, -- t02_txn_time
                    t02_leaves_qty = i.remaining_volume, -- t02_leaves_qty
                    t02_cumord_netvalue = i.cum_net_ord_value, -- t02_cumord_netvalue
                    t02_cumord_netsettle = i.netsettle, -- t02_cumord_netsettle
                    t02_audit_key = l_txn_id, -- t02_audit_key
                    t02_side = i.order_side, -- t02_side
                    t02_symbol_id_m20 = i.m20_id, -- t02_symbol_id_m20
                    t02_gainloss = i.t05_profitloss, -- t02_gainloss
                    t02_broker_tax = i.t05_broker_vat, -- t02_broker_tax
                    t02_exchange_tax = i.t05_exchange_vat, -- t02_exchange_tax
                    t02_update_type = i.update_type, -- t02_update_type
                    t02_db_create_date = i.t05_date, -- t02_db_create_date
                    t02_ord_status_v30 = i.ordstatus, -- t02_ord_status_v30
                    t02_fail_management_status =
                        i.t05_fail_management_status, -- t02_fail_management_status
                    t02_ord_value_adjst = i.ord_value_adjst, -- t02_ord_value_adjst
                    t02_trade_match_id = i.t11_trd_match_id, -- t02_trade_match_id
                    t02_exg_ord_id = i.t01_exchange_ord_id, -- t02_exg_ord_id
                    t02_act_broker_tax = i.t05_act_broker_vat, -- t02_act_broker_tax
                    t02_act_exchange_tax = i.t05_act_exchange_vat, -- t02_act_exchange_tax
                    t02_cash_settle_date_orig = i.t05_settlement_date, -- t02_cash_settle_date_orig
                    t02_holding_settle_date_orig = i.t05_settlement_date, -- t02_holding_settle_date_orig
                    t02_custodian_type_v01 = i.u07_custodian_type_v01, -- t02_custodian_type_v01
                    t02_unsettle_qty = i.unsettled_qty, -- t02_unsettle_qty
                    t02_trade_process_stat_id_v01 =
                        i.trade_processing_status, -- t02_trade_process_stat_id_v01
                    t02_last_db_seq_id = l_txn_id, -- t02_last_db_seq_id
                    t02_bank_id_m93 = i.new_bank_accounts_id, -- 02_bank_id_m93
                    t02_exec_broker_id_m26 = i.exe_broker_id, -- t02_exec_broker_id_m26
                    t02_exec_cma_tax = i.t01_cma_exchange_vat, -- t02_exec_cma_tax
                    t02_exec_cpp_tax = i.t01_cpp_exchange_vat, -- t02_exec_cpp_tax
                    t02_exec_dcm_tax = i.t01_dcm_gcm_exchange_vat, -- t02_exec_dcm_tax
                    t02_exec_act_cma_tax = i.t01_act_cma_exchange_vat, -- t02_exec_act_cma_tax
                    t02_exec_act_cpp_tax = i.t01_act_cpp_exchange_vat, -- t02_exec_act_cpp_tax
                    t02_exec_act_dcm_tax = i.t01_act_dcm_gcm_exchange_vat, -- t02_exec_act_dcm_tax
                    t02_exec_cma_comission = i.t01_cma_exchange_comm, -- t02_exec_cma_comission
                    t02_exec_cpp_comission = i.t01_cpp_exchange_comm, -- t02_exec_cpp_comission
                    t02_exec_dcm_comission = i.t01_dcm_gcm_exchange_comm, -- t02_exec_dcm_comission
                    t02_exec_initial_margin_value =
                        i.t01_initial_margin_amount, -- t02_exec_initial_margin_value
                    t02_exec_maintain_margin_value =
                        i.t01_maintain_margin_amount, -- t02_exec_maintain_margin_value
                    t02_loan_amount = i.u06_loan_amount, -- t02_loan_amount
                    t02_withdr_overdrawn_amt = i.u06_withdr_overdrawn_amt, -- t02_withdr_overdrawn_amt
                    t02_incident_overdrawn_amt =
                        i.u06_incident_overdrawn_amt, -- t02_incident_overdrawn_amt
                    t02_exchange_id_m01 = i.u07_exchange_id_m01, -- t02_exchange_id_m01
                    t02_ord_channel_id_v29 =  i.t01_ord_channel_id_v29, -- t02_ord_channel_id_v29
                    t02_dealer_id_u17 = i.t01_dealer_id_u17, -- t02_dealer_id_u17
                    t02_narration_lang = i.t05_reference_doc_narration, -- t02_narration_lang
                    t02_other_commission = i.t01_other_commission, -- t02_other_commission
                    t02_other_tax = i.t01_other_tax, -- t02_other_tax
                    t02_other_cum_commission = i.t01_other_cum_commission, -- t02_other_cum_commission
                    t02_other_cum_tax = i.t01_other_cum_tax, -- t02_other_cum_tax
                    t02_exec_other_commission = i.t05_algo_commission, -- t02_exec_other_commission
                    t02_exec_other_tax = i.t05_algo_commission_vat -- t02_exec_other_tax
              WHERE t02_audit_key = i.new_cash_txn_log_id;*/
            END IF;

            l_rec_cnt := l_rec_cnt + 1;

            IF MOD (l_rec_cnt, 25000) = 0
            THEN
                COMMIT;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T02_TRANSACTION_LOG',
                                'T05 - ' || i.t05_id,
                                CASE
                                    WHEN i.new_cash_txn_log_id IS NULL
                                    THEN
                                        l_txn_id
                                    ELSE
                                        i.new_cash_txn_log_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cash_txn_log_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);

                l_err_cnt := l_err_cnt + 1;

                IF MOD (l_err_cnt, 25000) = 0
                THEN
                    COMMIT;
                END IF;
        END;
    END LOOP;

    COMMIT;

    -- T06 Related Transactions (Stock Transactions)

    l_rec_cnt := 0;

    FOR i
        IN (  SELECT t06_hld_log.*, t02_map.new_holding_txn_log_id
                FROM (SELECT u07.u07_cash_account_id_u06,
                             u07_map.new_trading_account_id,
                             t06.t06_total_holdings,
                             CASE
                                 WHEN u07.u07_custodian_type_v01 <> 0 -- Custodian Related Transations
                                                                     THEN 0
                                 ELSE t06.t06_net_holdings
                             END
                                 AS net_holdings_adjust,
                             m20.m20_symbol_code,
                             m20.m20_exchange_code_m01,
                             CASE
                                 WHEN m26.m26_id IS NULL THEN -1 -- Updating Later in the Post Migration Script
                                 ELSE m26.m26_id
                             END
                                 AS custodian_id,
                             t06.t06_avg_cost,
                             u07.u07_institute_id_m02,
                             t06.t06_lastshares,
                             t06.t06_timestamp,
                             TRUNC (t06.t06_timestamp) AS create_date,
                             NVL (t06.t06_price, 0) AS price,
                             m20.m20_currency_code_m03,
                             CASE
                                 WHEN t06.t06_txn_type = 3
                                 THEN
                                     'HLDDEPOST'
                                 WHEN t06.t06_txn_type = 4
                                 THEN
                                     'HLDWITHDR'
                                 WHEN t06.t06_txn_type = 5
                                 THEN
                                     'HLDBONUSI'
                                 WHEN t06.t06_txn_type = 6
                                 THEN
                                     'HLDADJUST'
                                 WHEN t06.t06_txn_type = 7
                                 THEN
                                     'HLDSPLIT'
                                 WHEN t06.t06_txn_type = 8
                                 THEN
                                     'HLDREVSPT'
                                 WHEN t06.t06_txn_type = 9
                                 THEN
                                     'HLDRIGHTI'
                                 WHEN t06.t06_txn_type = 10
                                 THEN
                                     'HLDRHTSUBS'
                                 WHEN t06.t06_txn_type = 11
                                 THEN
                                     'HLDIPO'
                                 WHEN t06.t06_txn_type = 12
                                 THEN
                                     'HLDDIVDNT'
                                 WHEN t06.t06_txn_type = 13
                                 THEN
                                     'HLDSYMEXP'
                                 WHEN     t06.t06_txn_type = 0
                                      AND t06.t06_net_holdings >= 0
                                 THEN
                                     'HLDDEPOST'
                                 WHEN     t06.t06_txn_type = 0
                                      AND t06.t06_net_holdings < 0
                                 THEN
                                     'HLDWITHDR'
                             END
                                 AS txn_code,
                             t06.t06_sequenceno,
                             u07.u07_customer_id_u01,
                             u07.u07_customer_no_u01,
                             t06.t06_narration,
                             NVL (t06.t06_settle_date,
                                  TRUNC (t06.t06_timestamp))
                                 AS settle_date,
                             m20.m20_instrument_type_code_v09,
                             t06.t06_ord_cum_holdings,
                             m26.m26_sid,
                             t06.t06_pledgedqty,
                             m20.m20_id,
                             t06.t06_fail_management_status, -- [SAME IDs]
                             u07.u07_custodian_type_v01,
                             t06.t06_symbol,
                             u07.u07_exe_broker_id_m26,
                             u07.u07_exchange_id_m01
                        FROM mubasher_oms.t06_holdings_log@mubasher_db_link t06,
                             -- m02_institute_mappings m02_map -- [Corrective Actions Discussed]
                             map16_optional_exchanges_m01 map16,
                             u07_trading_account_mappings u07_map,
                             dfn_ntp.u07_trading_account u07,
                             (SELECT m20_id,
                                     m20_symbol_code,
                                     m20_exchange_code_m01,
                                     m20_instrument_type_code_v09,
                                     m20_currency_code_m03
                                FROM dfn_ntp.m20_symbol
                               WHERE m20_institute_id_m02 =
                                         l_primary_institute_id) m20,
                             m26_executing_broker_mappings m26_map_custody,
                             dfn_ntp.m26_executing_broker m26
                       WHERE     t06.t06_inst_id <> 0 -- [Corrective Actions Discussed]
                             -- t06.t06_inst_id = m02_map.old_institute_id -- [Corrective Actions Discussed]
                             AND t06.t06_security_ac_id =
                                     u07_map.old_trading_account_id(+)
                             AND t06.t06_exchange = map16.map16_oms_code(+)
                             AND NVL (map16.map16_ntp_code, t06.t06_exchange) =
                                     u07_map.exchange_code(+)
                             AND u07_map.new_trading_account_id = u07.u07_id(+)
                             AND NVL (map16.map16_ntp_code, t06.t06_exchange) =
                                     m20.m20_exchange_code_m01(+)
                             AND t06.t06_symbol = m20.m20_symbol_code(+)
                             AND t06.t06_custodian_inst_id =
                                     m26_map_custody.old_executing_broker_id(+)
                             AND m26_map_custody.new_executing_broker_id =
                                     m26.m26_id(+)
                             AND t06.t06_side NOT IN (1, 2)) t06_hld_log,
                     dfn_mig.t02_transaction_log_mappings t02_map
               WHERE     t06_hld_log.t06_sequenceno =
                             t02_map.old_holding_txn_log_id(+)
                     AND t06_hld_log.txn_code = t02_map.new_txn_code(+)
            ORDER BY t06_hld_log.t06_sequenceno)
    LOOP
        BEGIN
            IF i.txn_code IS NULL
            THEN
                raise_application_error (-20001,
                                         'Transaction Code Not Available',
                                         TRUE);
            END IF;

            IF i.new_trading_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Trading Account Not Available',
                                         TRUE);
            END IF;

            IF i.u07_customer_id_u01 IS NULL
            THEN
                raise_application_error (-20001,
                                         'Customer Not Available',
                                         TRUE);
            END IF;

            IF i.m20_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Symbol Not Available',
                                         TRUE);
            END IF;

            IF i.new_holding_txn_log_id IS NULL
            THEN
                l_txn_id := l_txn_id + 1;

                INSERT
                  INTO dfn_ntp.t02_transaction_log (
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
                           t02_origin_txn_id,
                           t02_txn_refrence_id,
                           t02_trade_confirm_no,
                           t02_master_ref,
                           t02_exec_broker_id_m26,
                           t02_option_base_holding_block,
                           t02_option_base_cash_block,
                           t02_reference_type,
                           t02_short_holding_block,
                           t02_is_archive_ready,
                           t02_allocated_qty,
                           t02_exec_cma_tax,
                           t02_exec_cpp_tax,
                           t02_exec_dcm_tax,
                           t02_exec_act_cma_tax,
                           t02_exec_act_cpp_tax,
                           t02_exec_act_dcm_tax,
                           t02_exec_cma_comission,
                           t02_exec_cpp_comission,
                           t02_exec_dcm_comission,
                           t02_orig_exg_tax,
                           t02_orig_brk_tax,
                           t02_fixing_price,
                           t02_m2m_gain,
                           t02_initial_margin_charge,
                           t02_notional_value,
                           t02_exec_initial_margin_value,
                           t02_exec_maintain_margin_value,
                           t02_loan_amount,
                           t02_withdr_overdrawn_amt,
                           t02_incident_overdrawn_amt,
                           t02_exchange_id_m01,
                           t02_ord_channel_id_v29,
                           t02_dealer_id_u17,
                           t02_narration_lang,
                           t02_other_commission,
                           t02_other_tax,
                           t02_other_cum_commission,
                           t02_other_cum_tax,
                           t02_exec_other_commission,
                           t02_exec_other_tax,
                           t02_eod_bulk_post_b)
                VALUES (NULL, -- t02_amnt_in_txn_currency
                        NULL, -- t02_amnt_in_stl_currency
                        i.u07_cash_account_id_u06, -- t02_cash_acnt_id_u06
                        NULL, -- t02_cash_block
                        NULL, -- t02_cash_block_orig
                        NULL, -- t02_cash_block_adjst
                        NULL, -- t02_cash_balance
                        NULL, -- t02_cash_acnt_seq_id
                        i.new_trading_account_id, -- t02_trd_acnt_id_u07
                        i.t06_total_holdings, -- t02_holding_net
                        0, -- t02_holding_block
                        0, -- t02_holding_block_adjst
                        i.net_holdings_adjust, -- t02_holding_net_adjst
                        i.m20_symbol_code, -- t02_symbol_code_m20
                        i.m20_exchange_code_m01, -- t02_exchange_code_m01
                        i.custodian_id, -- t02_custodian_id_m26
                        i.t06_avg_cost, -- t02_holding_avg_cost
                        i.u07_institute_id_m02, -- t02_inst_id_m02 -- [Corrective Actions Discussed]
                        0, -- t02_txn_entry_status
                        i.t06_lastshares, -- t02_last_shares
                        i.t06_timestamp, -- t02_create_datetime
                        i.create_date, -- t02_create_date
                        NULL, -- t02_cliordid_t01
                        i.price, -- t02_last_price
                        i.price, -- t02_avgprice
                        NULL, -- t02_cum_commission
                        NULL, -- t02_commission_adjst
                        NULL, -- t02_order_no
                        NULL, -- t02_order_exec_id
                        i.m20_currency_code_m03, -- t02_txn_currency
                        i.m20_currency_code_m03, -- t02_settle_currency
                        NULL, -- t02_exg_commission
                        i.txn_code, -- t02_txn_code
                        NULL, -- t02_fx_rate
                        NULL, -- t02_gl_posted_date
                        NULL, -- t02_gl_posted_status
                        NULL, -- t02_discount
                        NULL, -- t02_cashtxn_id
                        i.t06_sequenceno, -- t02_holdingtxn_id
                        i.u07_customer_id_u01, -- t02_customer_id_u01
                        i.u07_customer_no_u01, -- t02_customer_no
                        NULL, -- t02_ordqty
                        NULL, -- t02_pay_method
                        i.t06_narration, -- t02_narration
                        i.settle_date, -- t02_cash_settle_date
                        i.settle_date, -- t02_holding_settle_date
                        NULL, -- t02_buy_pending
                        NULL, -- t02_sell_pending
                        i.m20_instrument_type_code_v09, -- t02_instrument_type
                        i.t06_ord_cum_holdings, -- t02_cum_qty
                        NULL, -- t02_holding_manual_block
                        0, -- t02_possision_type
                        NULL, -- t02_accrude_interest
                        NULL, -- t02_accrude_interest_adjst
                        i.m26_sid, -- t02_counter_broker
                        i.t06_timestamp, -- t02_txn_time
                        NULL, -- t02_leaves_qty
                        l_broker_name || l_txn_id, -- t02_text
                        NULL, -- t02_cumord_value
                        NULL, -- t02_cumord_netvalue
                        NULL, -- t02_cumord_netsettle
                        l_txn_id, -- t02_audit_key
                        i.t06_pledgedqty, -- t02_pledge_qty
                        NULL, -- t02_side
                        i.m20_id, -- t02_symbol_id_m20
                        NULL, -- t02_gainloss
                        NULL, -- t02_broker_tax
                        NULL, -- t02_exchange_tax
                        3, -- t02_update_type
                        i.create_date, -- t02_db_create_date
                        NULL, -- t02_ord_status_v30
                        i.t06_fail_management_status, -- t02_fail_management_status
                        NULL, -- t02_ord_value_adjst
                        NULL, -- t02_trade_match_id
                        NULL, -- t02_exg_ord_id
                        NULL, -- t02_act_broker_tax
                        NULL, -- t02_act_exchange_tax
                        i.settle_date, -- t02_cash_settle_date_orig
                        i.settle_date, -- t02_holding_settle_date_orig
                        NULL, -- t02_ib_commission
                        i.u07_custodian_type_v01, -- t02_custodian_type_v01
                        NULL, -- t02_base_symbol_code_m20
                        NULL, -- t02_base_sym_exchange_m01
                        0, -- t02_base_holding_block
                        NULL, -- t02_unsettle_qty
                        NULL, -- t02_cash_balance_orig
                        25, -- t02_trade_process_stat_id_v01
                        l_txn_id, -- t02_last_db_seq_id
                        NULL, -- t02_bank_id_m93
                        NULL, -- t02_settle_cal_conf_id_m95
                        NULL, -- t02_original_exchange_ord_id | Update Later in this Script
                        NULL, -- t02_origin_txn_id | Used in Trade Reversals not Order Reversals
                        NULL, -- t02_txn_refrence_id
                        NULL, -- t02_trade_confirm_no | Not Available
                        NULL, --  t02_master_ref | Not Available
                        i.u07_exe_broker_id_m26, -- t02_exec_broker_id_m26
                        NULL, --  t02_option_base_holding_block | Not Available
                        NULL, --  t02_option_base_cash_block | Not Available
                        NULL, --  t02_reference_type | Not Available
                        NULL, -- t02_short_holding_block | Not Available
                        0, -- t02_is_archive_ready
                        0, -- t02_allocated_qty | Not Available
                        NULL, -- t02_exec_cma_tax | Not Available
                        NULL, -- t02_exec_cpp_tax | Not Available
                        NULL, -- t02_exec_dcm_tax | Not Available
                        NULL, -- t02_exec_act_cma_tax | Not Available
                        NULL, -- t02_exec_act_cpp_tax | Not Available
                        NULL, -- t02_exec_act_dcm_tax | Not Available
                        NULL, -- t02_exec_cma_comission | Not Available
                        NULL, -- t02_exec_cpp_comission | Not Available
                        NULL, -- t02_exec_dcm_comission | Not Available
                        NULL, -- t02_orig_exg_tax | Not Available
                        NULL, -- t02_orig_brk_tax | Not Available
                        NULL, -- t02_fixing_price | Not Available
                        NULL, -- t02_m2m_gain | Not Available
                        NULL, -- t02_initial_margin_charge | Not Available
                        NULL, -- t02_notional_value | Not Available
                        NULL, -- t02_exec_initial_margin_value | Not Available
                        NULL, -- t02_exec_maintain_margin_value | Not Available
                        NULL, -- t02_loan_amount | Not Available
                        NULL, -- t02_withdr_overdrawn_amt | Not Available
                        NULL, --  t02_incident_overdrawn_amt | Not Available
                        i.u07_exchange_id_m01, -- t02_exchange_id_m01
                        NULL, -- t02_ord_channel_id_v29 | Orders are Captured from T05
                        NULL, -- t02_dealer_id_u17 | Orders are Captured from T05
                        i.t06_narration, -- t02_narration_lang
                        NULL, -- t02_other_commission | Not Available
                        NULL, -- t02_other_tax | Not Available
                        NULL, -- t02_other_cum_commission | Not Available
                        NULL, -- t02_other_cum_tax | Not Available
                        NULL, -- t02_exec_other_commission | Not Available
                        NULL, -- t02_exec_other_tax | Not Available
                        0 -- t02_eod_bulk_post_b | Not Available
                         );

                INSERT INTO t02_transaction_log_mappings
                     VALUES (NULL,
                             i.t06_sequenceno,
                             NULL,
                             l_txn_id,
                             i.txn_code);
            ELSE
                NULL; -- No need to update t02 as during parallel run tranactions are auto integrtaed
            /*UPDATE dfn_ntp.t02_transaction_log
               SET t02_cash_acnt_id_u06 = i.u07_cash_account_id_u06, -- t02_cash_acnt_id_u06
                   t02_trd_acnt_id_u07 = i.new_trading_account_id, -- t02_trd_acnt_id_u07
                   t02_holding_net = i.t06_total_holdings, -- t02_holding_net
                   t02_holding_net_adjst = i.net_holdings_adjust, -- t02_holding_net_adjst
                   t02_symbol_code_m20 = i.m20_symbol_code, -- t02_symbol_code_m20
                   t02_exchange_code_m01 = i.m20_exchange_code_m01, -- t02_exchange_code_m01
                   t02_custodian_id_m26 = i.custodian_id, -- t02_custodian_id_m26
                   t02_holding_avg_cost = i.t06_avg_cost, -- t02_holding_avg_cost
                   t02_inst_id_m02 = i.u07_institute_id_m02, -- t02_inst_id_m02 -- [Corrective Actions Discussed]
                   t02_last_shares = i.t06_lastshares, -- t02_last_shares
                   t02_last_price = i.price, -- t02_last_price
                   t02_avgprice = i.price, -- t02_avgprice
                   t02_txn_currency = i.m20_currency_code_m03, -- t02_txn_currency
                   t02_settle_currency = i.m20_currency_code_m03, -- t02_settle_currency
                   t02_txn_code = i.txn_code, -- t02_txn_code
                   t02_holdingtxn_id = i.t06_sequenceno, -- t02_holdingtxn_id
                   t02_customer_id_u01 = i.u07_customer_id_u01, -- t02_customer_id_u01
                   t02_customer_no = i.u07_customer_no_u01, -- t02_customer_no
                   t02_narration = i.t06_narration, -- t02_narration
                   t02_cash_settle_date = i.settle_date, -- t02_cash_settle_date
                   t02_holding_settle_date = i.settle_date, -- t02_holding_settle_date
                   t02_instrument_type = i.m20_instrument_type_code_v09, -- t02_instrument_type
                   t02_cum_qty = i.t06_ord_cum_holdings, -- t02_cum_qty
                   t02_counter_broker = i.m26_sid, -- t02_counter_broker
                   t02_txn_time = i.t06_timestamp, -- t02_txn_time
                   t02_audit_key = l_txn_id, -- t02_audit_key
                   t02_pledge_qty = i.t06_pledgedqty, -- t02_pledge_qty
                   t02_symbol_id_m20 = i.m20_id, -- t02_symbol_id_m20
                   t02_db_create_date = i.create_date, -- t02_db_create_date
                   t02_fail_management_status =
                       i.t06_fail_management_status, -- t02_fail_management_status
                   t02_cash_settle_date_orig = i.settle_date, -- t02_cash_settle_date_orig
                   t02_holding_settle_date_orig = i.settle_date, -- t02_holding_settle_date_orig
                   t02_custodian_type_v01 = i.u07_custodian_type_v01, -- t02_custodian_type_v01
                   t02_last_db_seq_id = l_txn_id, -- t02_last_db_seq_id
                   t02_exec_broker_id_m26 = i.u07_exe_broker_id_m26, -- t02_exec_broker_id_m26
                   t02_exchange_id_m01 = i.u07_exchange_id_m01, -- t02_exchange_id_m01
                   t02_narration_lang = i.t06_narration -- t02_narration_lang
             WHERE t02_audit_key = i.new_holding_txn_log_id;
             */
            END IF;

            l_rec_cnt := l_rec_cnt + 1;

            IF MOD (l_rec_cnt, 25000) = 0
            THEN
                COMMIT;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T02_TRANSACTION_LOG',
                                'T06 - ' || i.t06_sequenceno,
                                CASE
                                    WHEN i.new_holding_txn_log_id IS NULL
                                    THEN
                                        l_txn_id
                                    ELSE
                                        i.new_holding_txn_log_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_holding_txn_log_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);

                l_err_cnt := l_err_cnt + 1;

                IF MOD (l_err_cnt, 25000) = 0
                THEN
                    COMMIT;
                END IF;
        END;
    END LOOP;
END;
/

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('T02_TRANSACTION_LOG');
END;
/

-- Updatinmg Cumuliative Commissions of Buy and Sell Orders

DECLARE
    l_rec_cnt   NUMBER := 0;
BEGIN
    FOR i
        IN (SELECT t02.t02_audit_key,
                   t02_order_no,
                   SUM (
                       NVL (t02.t02_commission_adjst, 0))
                   OVER (PARTITION BY t02_order_no
                         ORDER BY t02.t02_audit_key)
                       cum_commission
              FROM dfn_ntp.t02_transaction_log t02
             WHERE     t02.t02_update_type = 1
                   AND t02.t02_txn_code IN ('STLBUY', 'STLSEL'))
    LOOP
        UPDATE dfn_ntp.t02_transaction_log t02
           SET t02.t02_cum_commission = i.cum_commission
         WHERE     t02.t02_audit_key = i.t02_audit_key
               AND t02.t02_order_no = i.t02_order_no;

        l_rec_cnt := l_rec_cnt + 1;

        IF MOD (l_rec_cnt, 25000) = 0
        THEN
            COMMIT;
        END IF;
    END LOOP;
END;
/

COMMIT;

-- Updatinmg Cumuliative Commissions of Buy and Sell Reversal Orders

MERGE INTO dfn_ntp.t02_transaction_log t02
     USING (SELECT t02.t02_audit_key,
                   SUM (
                       NVL (t02.t02_commission_adjst, 0))
                   OVER (PARTITION BY t02_order_no
                         ORDER BY t02.t02_audit_key)
                       cum_commission
              FROM dfn_ntp.t02_transaction_log t02
             WHERE     t02.t02_update_type = 1
                   AND t02.t02_txn_code IN ('REVBUY', 'REVSEL')) t02_commission
        ON (t02.t02_audit_key = t02_commission.t02_audit_key)
WHEN MATCHED
THEN
    UPDATE SET t02.t02_cum_commission = t02_commission.cum_commission;

COMMIT;

-- Updating Cumulative Order Value for Executions

MERGE INTO dfn_ntp.t02_transaction_log t02
     USING (SELECT t02.t02_audit_key,
                   SUM (
                       NVL (ABS (t02.t02_ord_value_adjst), 0))
                   OVER (PARTITION BY t02_order_no
                         ORDER BY t02.t02_audit_key)
                       cum_ord_value
              FROM dfn_ntp.t02_transaction_log t02
             WHERE t02.t02_update_type = 1) t02_cum_ord_value
        ON (t02.t02_audit_key = t02_cum_ord_value.t02_audit_key)
WHEN MATCHED
THEN
    UPDATE SET t02.t02_cumord_value = t02_cum_ord_value.cum_ord_value;

COMMIT;

-- Updating Original Exchange Order Id for All Orders having Same CL Order Id and Order No

UPDATE dfn_ntp.t02_transaction_log t02
   SET t02.t02_original_exchange_ord_id = t02.t02_exg_ord_id
 WHERE t02.t02_cliordid_t01 = t02.t02_order_no;

COMMIT;

-- Updating Original Exchange Order Id for Amended Orders

BEGIN
    FOR i IN (SELECT t02.t02_order_no
                FROM dfn_ntp.t02_transaction_log t02
               WHERE t02.t02_cliordid_t01 <> t02.t02_order_no)
    LOOP
        FOR j
            IN (SELECT t02.t02_original_exchange_ord_id
                  FROM dfn_ntp.t02_transaction_log t02
                 WHERE     t02.t02_cliordid_t01 = i.t02_order_no
                       AND t02.t02_original_exchange_ord_id IS NOT NULL)
        LOOP
            UPDATE dfn_ntp.t02_transaction_log t02
               SET t02.t02_original_exchange_ord_id =
                       j.t02_original_exchange_ord_id
             WHERE t02.t02_order_no = i.t02_order_no;
        END LOOP;
    END LOOP;
END;
/

COMMIT;

-- Updating Entry Status by Considering All Reversals as Order Reversals Not Trade Reversal

MERGE INTO dfn_ntp.t02_transaction_log t02
     USING (SELECT t02.t02_order_no
              FROM dfn_ntp.t02_transaction_log t02
             WHERE t02.t02_txn_code IN ('REVBUY', 'REVSEL')) t02_reverse
        ON (t02.t02_order_no = t02_reverse.t02_order_no)
WHEN MATCHED
THEN
    UPDATE SET t02.t02_txn_entry_status = 1;

COMMIT;

-- Updating with Default Custodian & Executing Broker

DECLARE
    l_rec_cnt   NUMBER := 0;
BEGIN
    FOR i
        IN (SELECT t02.t02_cliordid_t01,
                   m43.m43_executing_broker_id_m26,
                   m43.m43_custodian_id_m26
              FROM dfn_ntp.t02_transaction_log t02,
                   dfn_ntp.m43_institute_exchanges m43
             WHERE     t02.t02_exchange_code_m01 = m43.m43_exchange_code_m01
                   AND t02.t02_inst_id_m02 = m43.m43_institute_id_m02)
    LOOP
        UPDATE dfn_ntp.t02_transaction_log t02
           SET t02.t02_custodian_id_m26 = i.m43_custodian_id_m26
         WHERE     t02.t02_custodian_id_m26 = -1
               AND t02.t02_cliordid_t01 = i.t02_cliordid_t01;

        UPDATE dfn_ntp.t02_transaction_log t02
           SET t02.t02_exec_broker_id_m26 = i.m43_executing_broker_id_m26
         WHERE     t02.t02_exec_broker_id_m26 = -1
               AND t02.t02_cliordid_t01 = i.t02_cliordid_t01;

        l_rec_cnt := l_rec_cnt + 1;

        IF MOD (l_rec_cnt, 25000) = 0
        THEN
            COMMIT;
        END IF;
    END LOOP;
END;
/

BEGIN
    dfn_ntp.sp_stat_gather ('T02_TRANSACTION_LOG');
END;
/