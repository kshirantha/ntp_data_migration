-- Orders

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_cl_order_id            NUMBER;
    l_sqlerrm                VARCHAR2 (4000);

    l_rec_cnt                NUMBER := 0;
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

    SELECT NVL (MAX (TO_NUMBER (t01_cl_ord_id)), 0)
      INTO l_cl_order_id
      FROM dfn_ntp.t01_order;

    DELETE FROM error_log
          WHERE mig_table = 'T01_ORDER';

    l_use_new_key := fn_use_new_key ('T01_ORDER');

    FOR i
        IN (SELECT t01.t01_orderno,
                   t01.t01_createddate,
                   TRUNC (t01.t01_createddate) AS created_date,
                   t01.t01_clordid,
                   t01.t01_origclordid,
                   t01.t01_orderid,
                   t01.t01_remote_clorderid,
                   t01.t01_remote_origclorderid,
                   u07_map.new_trading_account_id,
                   m20.m20_id,
                   t01.t01_ordertype, -- [SAME IDs]
                   t01.t01_side, -- [SAME IDs]
                   t01.t01_orderqty,
                   t01.t01_price,
                   t01.t01_minqty,
                   m29.m29_market_code,
                   CASE
                       WHEN t01.t01_ordstatus = '$' THEN 'c'
                       ELSE t01.t01_ordstatus
                   END
                       AS t01_ordstatus,
                   CASE
                       WHEN t01.t01_channel = 4 THEN 4
                       ELSE t01.t01_channel
                   END
                       AS t01_channel,
                   t01.t01_order_mode, -- [SAME IDs]
                   t01.t01_commission,
                   t01.t01_original_commision,
                   t01.t01_exg_commission,
                   t01.t01_avgpx,
                   NVL (t01.t01_cash_block, 0) AS t01_cash_block,
                   t01.t01_issue_stl_rate,
                   t01.t01_expiretime,
                   NVL (u17_map_dealer.new_employee_id, -1) AS dealer_id,
                   t01.t01_cumqty,
                   t01.t01_cum_ordvalue,
                   t01.t01_cum_commission,
                   CASE
                       WHEN    t01.t01_cum_exec_brok_comm IS NULL
                            OR t01.t01_cum_exec_brok_comm = 0
                       THEN
                           t01.t01_exg_commission
                   END
                       AS t01_cum_exec_brok_comm, -- Old System Does Not Populate Value
                   t01.t01_cum_accrued_interest,
                   t01.t01_accrued_interest,
                   m26_map_broker.new_executing_broker_id AS executing_broker,
                   m26_map_custody.new_executing_broker_id AS custodian_id,
                   t01.t01_dealer_id,
                   t01.t01_position_effect,
                   t01.t01_last_updated,
                   t01.t01_remote_tag_22,
                   t01.t01_remote_tag_100,
                   m26.m26_sid,
                   t01.t01_netsettle,
                   u07.u07_cash_account_id_u06,
                   t01.t01_security_type,
                   t01.t01_fixmsgtype,
                   m20.m20_price_instrument_id_v34,
                   t01.t01_exec_seq,
                   NVL (map16.map16_ntp_code, t01.t01_exchange) AS exchange,
                   u01_map.new_customer_id,
                   t01.t01_timeinforce, -- [SAME IDs]
                   t01.t01_symbol,
                   t01.t01_broker_fix_id,
                   u07.u07_exchange_account_no,
                   t01.t01_ordvalue,
                   t01.t01_ordnetvalue,
                   t01.t01_ordnetvalue * t01.t01_issue_stl_rate
                       AS ord_net_settle,
                   t01.t01_settle_currency,
                   t01.t01_fail_management_status, -- [SAME IDs]
                   t01.t01_fail_management_clordid,
                   CASE
                       WHEN (    t01.t01_ordstatus = '8'
                             AND INSTR (t01.t01_text, '|') <> 0)
                       THEN
                           SUBSTR (t01.t01_text,
                                   0,
                                   INSTR (t01.t01_text, '|') - 1)
                       WHEN t01.t01_ordstatus = '8'
                       THEN
                           t01.t01_text
                       ELSE -- In the AT code text is assigned to reject reason for all other cases
                           t01.t01_text
                   END
                       AS reject_reason,
                   t01.t01_currency,
                   t01.t01_profit_loss,
                   t01.t01_broker_vat,
                   t01.t01_exchange_vat,
                   t01.t01_cum_broker_vat,
                   t01.t01_cum_exchange_vat,
                   t01.t01_leavesqty,
                   t01.t01_lastshares,
                   t01.t01_lastpx,
                   t01.t01_act_broker_vat,
                   t01.t01_act_exchange_vat,
                   t01.t01_cum_ordnetvalue,
                   m02_map.new_institute_id,
                   u07.u07_custodian_type_v01,
                   t01.t01_settle_date,
                   t01.t01_unsettled_qty,
                   t01.t01_desk_order_ref,
                   t01.t01_desk_order_number,
                   t01.t01_tag_50,
                   t01.t01_cum_discount_comm,
                   CASE
                       WHEN t01.t01_settle_date <= TRUNC (SYSDATE) THEN 25
                       ELSE 24
                   END
                       AS trade_processing_status,
                   u47_map.new_power_of_attorney_id,
                   CASE WHEN t01.t01_desk_order_ref > 0 THEN 5 END
                       AS parent_ord_category,
                   t01.t01_initial_margin_amount,
                   t01.t01_maintain_margin_amount,
                   t01.t01_cum_initial_margin_amount,
                   t01.t01_cum_maintain_margin_amount,
                   t01.t01_cma_exchange_vat,
                   t01.t01_cma_exchange_comm,
                   t01.t01_cpp_exchange_vat,
                   t01.t01_cpp_exchange_comm,
                   t01.t01_dcm_gcm_exchange_vat,
                   t01.t01_dcm_gcm_exchange_comm,
                   t01.t01_act_cma_exchange_vat,
                   t01.t01_act_cpp_exchange_vat,
                   t01.t01_act_dcm_gcm_exchange_vat,
                   t01.t01_avgcost,
                   CASE WHEN t01.t01_ordstatus = '$' THEN 1 ELSE NULL END
                       AS t01_wfa_level,
                   CASE
                       WHEN t01.t01_ordstatus = '$' THEN 'Murabaha Order'
                       ELSE NULL
                   END
                       AS t01_wfa_reason,
                   t01_map.new_cl_order_id,
                   t75_map.new_murabaha_contract_id,
                   u07.u07_exchange_id_m01,
                   t01.t01_routingac,
                   t01.t01_algo_comm,
                   t01.t01_algo_vat,
                   t01.t01_cum_algo_comm,
                   t01.t01_cum_algo_vat
              FROM mubasher_oms.t01_order_summary_intraday@mubasher_db_link t01,
                   mubasher_oms.m06_employees@mubasher_db_link m06,
                   map16_optional_exchanges_m01 map16,
                   u07_trading_account_mappings u07_map,
                   dfn_ntp.u07_trading_account u07,
                   (SELECT m20_id,
                           m20_symbol_code,
                           m20_exchange_code_m01,
                           m20_price_instrument_id_v34
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20,
                   (SELECT m29_market_code, m29_exchange_code_m01
                      FROM dfn_ntp.m29_markets
                     WHERE m29_primary_institution_id_m02 =
                               l_primary_institute_id) m29,
                   (SELECT m26_id, m26_sid
                      FROM dfn_ntp.m26_executing_broker
                     WHERE m26_institution_id_m02 = l_primary_institute_id) m26,
                   m26_executing_broker_mappings m26_map_broker,
                   m26_executing_broker_mappings m26_map_custody,
                   u17_employee_mappings u17_map_dealer,
                   u01_customer_mappings u01_map,
                   m02_institute_mappings m02_map,
                   mubasher_oms.m137_customer_poa@mubasher_db_link m137,
                   u47_power_of_attorney_mappings u47_map,
                   t75_murabaha_contract_mappings t75_map,
                   t01_order_mappings t01_map
             WHERE     t01.t01_m01_customer_id > 0 -- Filter Out Orders Under Customer ID = 0
                   AND t01.t01_security_ac_id =
                           u07_map.old_trading_account_id(+)
                   AND t01.t01_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, t01.t01_exchange) =
                           u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id = u07.u07_id(+)
                   AND t01.t01_symbol = m20.m20_symbol_code(+)
                   AND NVL (map16.map16_ntp_code, t01.t01_exchange) =
                           m20.m20_exchange_code_m01(+)
                   AND t01.t01_market_code = m29.m29_market_code(+)
                   AND NVL (map16.map16_ntp_code, t01.t01_exchange) =
                           m29.m29_exchange_code_m01(+)
                   AND t01.t01_exec_broker_inst =
                           m26_map_broker.old_executing_broker_id(+)
                   AND m26_map_broker.new_executing_broker_id = m26.m26_id(+)
                   AND t01.t01_custodian_inst_id =
                           m26_map_custody.old_executing_broker_id(+)
                   AND t01.t01_userid = m06.m06_login_id(+)
                   AND m06.m06_id = u17_map_dealer.old_employee_id(+)
                   AND t01.t01_m01_customer_id = u01_map.old_customer_id(+)
                   AND t01.t01_inst_id = m02_map.old_institute_id
                   AND t01.t01_poa_id = m137.m137_id(+)
                   AND m137.m137_customer_id = u47_map.old_customer_id(+)
                   AND m137.m137_poa = u47_map.old_poa_id(+)
                   AND t01.t01_clordid = t01_map.old_cl_order_id(+)
                   AND t01.t01_contract_id =
                           t75_map.old_murabaha_contract_id(+)
            UNION ALL
            SELECT t01.t01_orderno,
                   t01.t01_createddate,
                   TRUNC (t01.t01_createddate) AS created_date,
                   t01.t01_clordid,
                   t01.t01_origclordid,
                   t01.t01_orderid,
                   t01.t01_remote_clorderid,
                   t01.t01_remote_origclorderid,
                   u07_map.new_trading_account_id,
                   m20.m20_id,
                   t01.t01_ordertype, -- [SAME IDs]
                   t01.t01_side, -- [SAME IDs]
                   t01.t01_orderqty,
                   t01.t01_price,
                   t01.t01_minqty,
                   m29.m29_market_code,
                   CASE
                       WHEN t01.t01_ordstatus = '$' THEN 'c'
                       ELSE t01.t01_ordstatus
                   END
                       AS t01_ordstatus,
                   CASE
                       WHEN t01.t01_channel = 4 THEN 4
                       ELSE t01.t01_channel
                   END
                       AS t01_channel,
                   t01.t01_order_mode, -- [SAME IDs]
                   t01.t01_commission,
                   t01.t01_original_commision,
                   t01.t01_exg_commission,
                   t01.t01_avgpx,
                   NVL (t01.t01_cash_block, 0) AS t01_cash_block,
                   t01.t01_issue_stl_rate,
                   t01.t01_expiretime,
                   NVL (u17_map_dealer.new_employee_id, -1) AS dealer_id,
                   t01.t01_cumqty,
                   t01.t01_cum_ordvalue,
                   t01.t01_cum_commission,
                   CASE
                       WHEN    t01.t01_cum_exec_brok_comm IS NULL
                            OR t01.t01_cum_exec_brok_comm = 0
                       THEN
                           t01.t01_exg_commission
                   END
                       AS t01_cum_exec_brok_comm, -- Old System Does Not Populate Value
                   t01.t01_cum_accrued_interest,
                   t01.t01_accrued_interest,
                   m26_map_broker.new_executing_broker_id AS executing_broker,
                   m26_map_custody.new_executing_broker_id AS custodian_id,
                   t01.t01_dealer_id,
                   t01.t01_position_effect,
                   t01.t01_last_updated,
                   t01.t01_remote_tag_22,
                   t01.t01_remote_tag_100,
                   m26.m26_sid,
                   t01.t01_netsettle,
                   u07.u07_cash_account_id_u06,
                   t01.t01_security_type,
                   t01.t01_fixmsgtype,
                   m20.m20_price_instrument_id_v34,
                   t01.t01_exec_seq,
                   NVL (map16.map16_ntp_code, t01.t01_exchange) AS exchange,
                   u01_map.new_customer_id,
                   t01.t01_timeinforce, -- [SAME IDs]
                   t01.t01_symbol,
                   t01.t01_broker_fix_id,
                   u07.u07_exchange_account_no,
                   t01.t01_ordvalue,
                   t01.t01_ordnetvalue,
                   t01.t01_ordnetvalue * t01.t01_issue_stl_rate
                       AS ord_net_settle,
                   t01.t01_settle_currency,
                   t01.t01_fail_management_status, -- [SAME IDs]
                   t01.t01_fail_management_clordid,
                   CASE
                       WHEN (    t01.t01_ordstatus = '8'
                             AND INSTR (t01.t01_text, '|') <> 0)
                       THEN
                           SUBSTR (t01.t01_text,
                                   0,
                                   INSTR (t01.t01_text, '|') - 1)
                       WHEN t01.t01_ordstatus = '8'
                       THEN
                           t01.t01_text
                       ELSE -- In the AT code text is assigned to reject reason for all other cases
                           t01.t01_text
                   END
                       AS reject_reason,
                   t01.t01_currency,
                   t01.t01_profit_loss,
                   t01.t01_broker_vat,
                   t01.t01_exchange_vat,
                   t01.t01_cum_broker_vat,
                   t01.t01_cum_exchange_vat,
                   t01.t01_leavesqty,
                   t01.t01_lastshares,
                   t01.t01_lastpx,
                   0 AS t01_act_broker_vat,
                   0 AS t01_act_exchange_vat,
                   t01.t01_cum_ordnetvalue,
                   m02_map.new_institute_id,
                   u07.u07_custodian_type_v01,
                   t01.t01_settle_date,
                   t01.t01_unsettled_qty,
                   t01.t01_desk_order_ref,
                   t01.t01_desk_order_number,
                   t01.t01_tag_50,
                   t01.t01_cum_discount_comm,
                   CASE
                       WHEN t01.t01_settle_date <= TRUNC (SYSDATE) THEN 25
                       ELSE 24
                   END
                       AS trade_processing_status,
                   u47_map.new_power_of_attorney_id,
                   CASE WHEN t01.t01_desk_order_ref > 0 THEN 5 END
                       AS parent_ord_category,
                   t01.t01_initial_margin_amount,
                   t01.t01_maintain_margin_amount,
                   t01.t01_cum_initial_margin_amount,
                   t01.t01_cum_maintain_margin_amount,
                   t01.t01_cma_exchange_vat,
                   t01.t01_cma_exchange_comm,
                   t01.t01_cpp_exchange_vat,
                   t01.t01_cpp_exchange_comm,
                   t01.t01_dcm_gcm_exchange_vat,
                   t01.t01_dcm_gcm_exchange_comm,
                   t01.t01_act_cma_exchange_vat,
                   t01.t01_act_cpp_exchange_vat,
                   t01.t01_act_dcm_gcm_exchange_vat,
                   t01.t01_avgcost,
                   CASE WHEN t01.t01_ordstatus = '$' THEN 1 ELSE NULL END
                       AS t01_wfa_level,
                   CASE
                       WHEN t01.t01_ordstatus = '$' THEN 'Murabaha Order'
                       ELSE NULL
                   END
                       AS t01_wfa_reason,
                   t01_map.new_cl_order_id,
                   t75_map.new_murabaha_contract_id,
                   u07.u07_exchange_id_m01,
                   t01.t01_routingac,
                   t01.t01_algo_comm,
                   t01.t01_algo_vat,
                   t01.t01_cum_algo_comm,
                   t01.t01_cum_algo_vat
              FROM mubasher_oms.t01_order_summary_intraday_arc@mubasher_db_link t01,
                   mubasher_oms.m06_employees@mubasher_db_link m06,
                   map16_optional_exchanges_m01 map16,
                   u07_trading_account_mappings u07_map,
                   dfn_ntp.u07_trading_account u07,
                   (SELECT m20_id,
                           m20_symbol_code,
                           m20_exchange_code_m01,
                           m20_price_instrument_id_v34
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20,
                   (SELECT m29_market_code, m29_exchange_code_m01
                      FROM dfn_ntp.m29_markets
                     WHERE m29_primary_institution_id_m02 =
                               l_primary_institute_id) m29,
                   (SELECT m26_id, m26_sid
                      FROM dfn_ntp.m26_executing_broker
                     WHERE m26_institution_id_m02 = l_primary_institute_id) m26,
                   m26_executing_broker_mappings m26_map_broker,
                   m26_executing_broker_mappings m26_map_custody,
                   u17_employee_mappings u17_map_dealer,
                   u01_customer_mappings u01_map,
                   m02_institute_mappings m02_map,
                   mubasher_oms.m137_customer_poa@mubasher_db_link m137,
                   u47_power_of_attorney_mappings u47_map,
                   t75_murabaha_contract_mappings t75_map,
                   t01_order_mappings t01_map
             WHERE     t01.t01_m01_customer_id > 0 -- Filter Out Orders Under Customer ID = 0
                   AND t01.t01_security_ac_id =
                           u07_map.old_trading_account_id(+)
                   AND t01.t01_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, t01.t01_exchange) =
                           u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id = u07.u07_id(+)
                   AND t01.t01_symbol = m20.m20_symbol_code(+)
                   AND NVL (map16.map16_ntp_code, t01.t01_exchange) =
                           m20.m20_exchange_code_m01(+)
                   AND t01.t01_market_code = m29.m29_market_code(+)
                   AND NVL (map16.map16_ntp_code, t01.t01_exchange) =
                           m29.m29_exchange_code_m01(+)
                   AND t01.t01_exec_broker_inst =
                           m26_map_broker.old_executing_broker_id(+)
                   AND m26_map_broker.new_executing_broker_id = m26.m26_id(+)
                   AND t01.t01_custodian_inst_id =
                           m26_map_custody.old_executing_broker_id(+)
                   AND t01.t01_userid = m06.m06_login_id(+)
                   AND m06.m06_id = u17_map_dealer.old_employee_id(+)
                   AND t01.t01_m01_customer_id = u01_map.old_customer_id(+)
                   AND t01.t01_inst_id = m02_map.old_institute_id
                   AND t01.t01_poa_id = m137.m137_id(+)
                   AND m137.m137_customer_id = u47_map.old_customer_id(+)
                   AND m137.m137_poa = u47_map.old_poa_id(+)
                   AND t01.t01_clordid = t01_map.old_cl_order_id(+)
                   AND t01.t01_contract_id =
                           t75_map.old_murabaha_contract_id(+))
    LOOP
        BEGIN
            IF i.new_institute_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Institute Not Available',
                                         TRUE);
            END IF;

            IF i.new_customer_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Customer Not Available',
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
                                         'Symbol Not Available',
                                         TRUE);
            END IF;

            IF i.new_cl_order_id IS NULL
            THEN
                l_cl_order_id :=
                    CASE
                        WHEN l_use_new_key = 0 THEN i.t01_clordid
                        ELSE l_cl_order_id + 1
                    END;

                INSERT
                  INTO dfn_ntp.t01_order (t01_ord_no,
                                          t01_date_time,
                                          t01_date,
                                          t01_cl_ord_id,
                                          t01_orig_cl_ord_id,
                                          t01_exchange_ord_id,
                                          t01_remote_cl_ord_id,
                                          t01_remote_orig_cl_ord_id,
                                          t01_trading_acc_id_u07,
                                          t01_symbol_id_m20,
                                          t01_ord_type_id_v06,
                                          t01_side,
                                          t01_quantity,
                                          t01_price,
                                          t01_min_quantity,
                                          t01_market_code_m29,
                                          t01_status_id_v30,
                                          t01_ord_channel_id_v29,
                                          t01_instruction_type,
                                          t01_commission,
                                          t01_orig_commission,
                                          t01_discount,
                                          t01_exec_brk_commission,
                                          t01_avg_price,
                                          t01_block_amount,
                                          t01_settle_currency_rate,
                                          t01_expiry_date,
                                          t01_dealer_id_u17,
                                          t01_customer_login_id_u09,
                                          t01_cum_quantity,
                                          t01_cum_ord_value,
                                          t01_cum_commission,
                                          t01_cum_exec_brk_commission,
                                          t01_cum_accrued_interest,
                                          t01_accrued_interest,
                                          t01_exec_broker_id_m26,
                                          t01_custodian_id_m26,
                                          t01_emp_trading_id_u19,
                                          t01_position_effect,
                                          t01_remarks,
                                          t01_last_updated_date_time,
                                          t01_tag_remote_sub_comp_id,
                                          t01_remote_tag_22,
                                          t01_remote_tag_100,
                                          t01_remote_sid,
                                          t01_cum_netstl,
                                          t01_tenant_code,
                                          t01_cash_acc_id_u06,
                                          t01_instrument_type_code,
                                          t01_order_mode,
                                          t01_fix_msg_type,
                                          t01_disclose_qty,
                                          t01_price_inst_type,
                                          t01_ord_exec_seq,
                                          t01_db_created_date,
                                          t01_last_updated_by,
                                          t01_db_last_updated_date,
                                          t01_last_db_seq_id,
                                          t01_exchange_code_m01,
                                          t01_customer_id_u01,
                                          t01_tif_id_v10,
                                          t01_symbol_code_m20,
                                          t01_exec_instruction,
                                          t01_brker_fix_id,
                                          t01_trading_acntno_u07,
                                          t01_ord_value,
                                          t01_ord_net_value,
                                          t01_ord_net_settle,
                                          t01_settle_currency,
                                          t01_gainloss,
                                          t01_is_active_order,
                                          t01_fail_mngmnt_status,
                                          t01_fail_mngmnt_clord_id,
                                          t01_fail_mngmnt_exec_id,
                                          t01_reject_reason,
                                          t01_symbol_currency_code_m03,
                                          t01_profit_loss_for_this_exec,
                                          t01_profit_loss,
                                          t01_broker_tax,
                                          t01_exchange_tax,
                                          t01_cum_broker_tax,
                                          t01_cum_exchange_tax,
                                          t01_leaves_qty,
                                          t01_server_id,
                                          t01_last_shares,
                                          t01_last_price,
                                          t01_act_broker_tax,
                                          t01_act_exchange_tax,
                                          t01_cum_net_value,
                                          t01_cum_act_broker_tax,
                                          t01_cum_act_exchange_tax,
                                          t01_wfa_level,
                                          t01_institution_id_m02,
                                          t01_ib_commission,
                                          t01_cum_ib_commission,
                                          t01_custodian_type_v01,
                                          t01_cash_settle_date,
                                          t01_holding_settle_date,
                                          t01_unsettle_qty,
                                          t01_desk_order_ref_t52,
                                          t01_desk_order_no_t52,
                                          t01_trade_process_stat_id_v01,
                                          t01_approved_by_id_u17,
                                          t01_algo_ord_ref_t54,
                                          t01_wfa_current_value,
                                          t01_wfa_expected_value,
                                          t01_remote_sec_source_id,
                                          t01_tag50,
                                          t01_orig_exg_commission,
                                          t01_cum_discount,
                                          t01_original_exchange_ord_id,
                                          t01_poa_id_u47,
                                          t01_wfa_reason,
                                          t01_con_ord_ref_t38,
                                          t01_parent_ord_category_t38,
                                          t01_is_archive_ready,
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
                                          t01_orig_exg_tax,
                                          t01_orig_brk_tax,
                                          t01_initial_margin_amount,
                                          t01_maintain_margin_amount,
                                          t01_cum_initial_margin_amount,
                                          t01_cum_maintain_margin_amount,
                                          t01_maintain_margin_block,
                                          t01_cum_maintain_margin_block,
                                          t01_holding_avg_price,
                                          t01_contract_id_t75,
                                          t01_holding_avg_cost,
                                          t01_avg_cost,
                                          t01_exchange_id_m01,
                                          t01_negotiated_request_id_t85,
                                          t01_board_code_m54,
                                          t01_short_sell_enable,
                                          t01_bypass_rms_validation,
                                          t01_integration_ext_ref_no,
                                          t01_other_commission,
                                          t01_other_tax,
                                          t01_other_cum_commission,
                                          t01_other_cum_tax)
                VALUES (i.t01_orderno, -- t01_ord_no | Update Later in this Script if New ID Is Generated
                        i.t01_createddate, -- t01_date_time
                        i.created_date, -- t01_date
                        l_cl_order_id, -- t01_cl_ord_id
                        i.t01_origclordid, -- t01_orig_cl_ord_id | Update Later in this Script if New ID Is Generated
                        i.t01_orderid, -- t01_exchange_ord_id
                        i.t01_remote_clorderid, -- t01_remote_cl_ord_id
                        i.t01_remote_origclorderid, -- t01_remote_orig_cl_ord_id
                        i.new_trading_account_id, -- t01_trading_acc_id_u07
                        i.m20_id, -- t01_symbol_id_m20
                        i.t01_ordertype, -- t01_ord_type_id_v06
                        i.t01_side, -- t01_side
                        i.t01_orderqty, -- t01_quantity
                        i.t01_price, -- t01_price
                        i.t01_minqty, -- t01_min_quantity
                        i.m29_market_code, -- t01_market_code_m29
                        i.t01_ordstatus, -- t01_status_id_v30
                        i.t01_channel, -- t01_ord_channel_id_v29
                        i.t01_order_mode, -- t01_instruction_type
                        i.t01_commission, -- t01_commission
                        i.t01_original_commision, -- t01_orig_commission
                        i.t01_cum_discount_comm, -- t01_discount | Same Amount of T01_CUM_DISCOUNT Used Here Also
                        i.t01_exg_commission, -- t01_exec_brk_commission
                        i.t01_avgpx, -- t01_avg_price
                        i.t01_cash_block, -- t01_block_amount
                        i.t01_issue_stl_rate, -- t01_settle_currency_rate
                        i.t01_expiretime, -- t01_expiry_date
                        i.dealer_id, -- t01_dealer_id_u17
                        NULL, -- t01_customer_login_id_u09
                        i.t01_cumqty, -- t01_cum_quantity
                        i.t01_cum_ordvalue, -- t01_cum_ord_value
                        i.t01_cum_commission, -- t01_cum_commission
                        i.t01_cum_exec_brok_comm, -- t01_cum_exec_brk_commission
                        i.t01_cum_accrued_interest, -- t01_cum_accrued_interest
                        i.t01_accrued_interest, -- t01_accrued_interest
                        i.executing_broker, -- t01_exec_broker_id_m26
                        i.custodian_id, -- t01_custodian_id_m26
                        i.t01_dealer_id, -- t01_emp_trading_id_u19
                        i.t01_position_effect, -- t01_position_effect
                        NULL, -- t01_remarks | Not Available
                        i.t01_last_updated, -- t01_last_updated_date_time
                        NULL, -- t01_tag_remote_sub_comp_id
                        i.t01_remote_tag_22, -- t01_remote_tag_22
                        i.t01_remote_tag_100, -- t01_remote_tag_100
                        i.m26_sid, -- t01_remote_sid
                        i.t01_netsettle, -- t01_cum_netstl
                        'DEFAULT', -- t01_tenant_code
                        i.u07_cash_account_id_u06, -- t01_cash_acc_id_u06
                        i.t01_security_type, -- t01_instrument_type_code
                        i.t01_order_mode, -- t01_order_mode
                        i.t01_fixmsgtype, -- t01_fix_msg_type
                        0, -- t01_disclose_qty
                        i.m20_price_instrument_id_v34, -- t01_price_inst_type
                        i.t01_exec_seq, -- t01_ord_exec_seq
                        i.t01_createddate, -- t01_db_created_date
                        NULL, -- t01_last_updated_by | Not Available
                        i.t01_last_updated, -- t01_db_last_updated_date
                        NULL, -- t01_last_db_seq_id
                        i.exchange, -- t01_exchange_code_m01
                        i.new_customer_id, -- t01_customer_id_u01
                        i.t01_timeinforce, -- t01_tif_id_v10
                        i.t01_symbol, -- t01_symbol_code_m20
                        NULL, -- t01_exec_instruction
                        i.t01_broker_fix_id, -- t01_brker_fix_id
                        i.t01_routingac, -- t01_trading_acntno_u07 -- Keeping T01_ROUTING_ACC which was used at the time of placing order as it is
                        i.t01_ordvalue, -- t01_ord_value
                        i.t01_ordnetvalue, -- t01_ord_net_value
                        i.ord_net_settle, -- t01_ord_net_settle
                        i.t01_settle_currency, -- t01_settle_currency
                        0, -- t01_gainloss
                        0, -- t01_is_active_order
                        i.t01_fail_management_status, -- t01_fail_mngmnt_status
                        i.t01_fail_management_clordid, -- t01_fail_mngmnt_clord_id | Update Later in this Script if New ID Is Generated
                        NULL, -- t01_fail_mngmnt_exec_id
                        i.reject_reason, -- t01_reject_reason
                        i.t01_currency, -- t01_symbol_currency_code_m03
                        0, -- t01_profit_loss_for_this_exec
                        i.t01_profit_loss, -- t01_profit_loss
                        i.t01_broker_vat, -- t01_broker_tax
                        i.t01_exchange_vat, -- t01_exchange_tax
                        i.t01_cum_broker_vat, -- t01_cum_broker_tax
                        i.t01_cum_exchange_vat, -- t01_cum_exchange_tax
                        i.t01_leavesqty, -- t01_leaves_qty
                        NULL, -- t01_server_id
                        i.t01_lastshares, -- t01_last_shares
                        i.t01_lastpx, -- t01_last_price
                        i.t01_act_broker_vat, -- t01_act_broker_tax
                        i.t01_act_exchange_vat, -- t01_act_exchange_tax
                        i.t01_cum_ordnetvalue, -- t01_cum_net_value
                        0, -- t01_cum_act_broker_tax
                        0, -- t01_cum_act_exchange_tax
                        i.t01_wfa_level, -- t01_wfa_level
                        i.new_institute_id, -- t01_institution_id_m02
                        0, -- t01_ib_commission
                        0, -- t01_cum_ib_commission
                        i.u07_custodian_type_v01, -- t01_custodian_type_v01
                        i.t01_settle_date, -- t01_cash_settle_date
                        i.t01_settle_date, -- t01_holding_settle_date
                        i.t01_unsettled_qty, -- t01_unsettle_qty
                        i.t01_desk_order_ref, -- t01_desk_order_ref_t52 | Updating Later in the Post Migration Script if New ID Is Generated
                        i.t01_desk_order_number, -- t01_desk_order_no_t52 | Updating Later in the Post Migration Script if New ID Is Generated
                        25, -- t01_trade_process_stat_id_v01 | 25 - Settled
                        -1, -- t01_approved_by_id_u17
                        NULL, -- t01_algo_ord_ref_t54
                        NULL, -- t01_wfa_current_value
                        NULL, -- t01_wfa_expected_value
                        NULL, -- t01_remote_sec_source_id
                        i.t01_tag_50, -- t01_tag50
                        NULL, -- t01_orig_exg_commission
                        i.t01_cum_discount_comm, -- t01_cum_discount
                        NULL, -- t01_original_exchange_ord_id
                        i.new_power_of_attorney_id, -- t01_poa_id_u47
                        i.t01_wfa_reason, -- t01_wfa_reason
                        NULL, -- t01_con_ord_ref_t38 | Not Available
                        i.parent_ord_category, -- t01_parent_ord_category_t38
                        0, -- t01_is_archive_ready
                        i.t01_cma_exchange_vat, -- t01_cma_tax
                        i.t01_cpp_exchange_vat, -- t01_cpp_tax
                        i.t01_dcm_gcm_exchange_vat, -- t01_dcm_tax
                        i.t01_cma_exchange_vat, -- t01_cum_cma_tax | Not Available
                        i.t01_cpp_exchange_vat, -- t01_cum_cpp_tax | Not Available
                        i.t01_dcm_gcm_exchange_vat, -- t01_cum_dcm_tax | Not Available
                        i.t01_act_cma_exchange_vat, -- t01_act_cma_tax
                        i.t01_act_cpp_exchange_vat, -- t01_act_cpp_tax
                        i.t01_act_dcm_gcm_exchange_vat, -- t01_act_dcm_tax
                        i.t01_act_cma_exchange_vat, -- t01_cum_act_cma_tax | Not Available
                        i.t01_act_cpp_exchange_vat, -- t01_cum_act_cpp_tax | Not Available
                        i.t01_act_dcm_gcm_exchange_vat, -- t01_cum_act_dcm_tax | Not Available
                        i.t01_cma_exchange_comm, -- t01_cma_commission
                        i.t01_cpp_exchange_comm, -- t01_cpp_commission
                        i.t01_dcm_gcm_exchange_comm, -- t01_dcm_commission
                        i.t01_cma_exchange_comm, -- t01_cma_cum_commission | Not Available
                        i.t01_cpp_exchange_comm, -- t01_cpp_cum_commission | Not Available
                        i.t01_dcm_gcm_exchange_comm, -- t01_dcm_cum_commission | Not Available
                        NULL, -- t01_orig_exg_tax | Not Available
                        NULL, -- t01_orig_brk_tax | Not Available
                        i.t01_initial_margin_amount, -- t01_initial_margin_amount
                        i.t01_maintain_margin_amount, -- t01_maintain_margin_amount
                        i.t01_cum_initial_margin_amount, -- t01_cum_initial_margin_amount
                        i.t01_cum_maintain_margin_amount, -- t01_cum_maintain_margin_amount
                        0, -- t01_maintain_margin_block | Not Available
                        0, -- t01_cum_maintain_margin_block | Not Available
                        NULL, -- t01_holding_avg_price | Not Available
                        i.new_murabaha_contract_id, -- t01_contract_id_t75
                        NULL, -- t01_holding_avg_cost | Not Available
                        i.t01_avgcost, -- t01_avg_cost
                        i.u07_exchange_id_m01, -- t01_exchange_id_m01
                        NULL, -- t01_negotiated_request_id_t85 | Not Available
                        NULL, -- t01_board_code_m54 | Not Available
                        0, -- t01_short_sell_enable | Not Available
                        0, -- t01_bypass_rms_validation | 0 (No) - Default
                        NULL, -- t01_integration_ext_ref_no | Not Available
                        i.t01_algo_comm, -- t01_other_commission
                        i.t01_algo_vat, -- t01_other_tax
                        i.t01_cum_algo_comm, -- t01_other_cum_commission
                        i.t01_cum_algo_vat -- t01_other_cum_tax
                                          );

                INSERT INTO t01_order_mappings
                     VALUES (i.t01_clordid, l_cl_order_id);
            ELSE
                NULL; -- No need to update t02 as during parallel run tranactions are auto integrtaed
            /*UPDATE dfn_ntp.t01_order
               SET t01_ord_no = i.t01_orderno, -- t01_ord_no | Update Later in this Script if New ID Is Generated
                   t01_date_time = i.t01_createddate, -- t01_date_time
                   t01_date = i.created_date, -- t01_date
                   t01_orig_cl_ord_id = i.t01_origclordid, -- t01_orig_cl_ord_id | Update Later in this Script if New ID Is Generated
                   t01_exchange_ord_id = i.t01_orderid, -- t01_exchange_ord_id
                   t01_remote_cl_ord_id = i.t01_remote_clorderid, -- t01_remote_cl_ord_id
                   t01_remote_orig_cl_ord_id = i.t01_remote_origclorderid, -- t01_remote_orig_cl_ord_id
                   t01_trading_acc_id_u07 = i.new_trading_account_id, -- t01_trading_acc_id_u07
                   t01_symbol_id_m20 = i.m20_id, -- t01_symbol_id_m20
                   t01_ord_type_id_v06 = i.t01_ordertype, -- t01_ord_type_id_v06
                   t01_side = i.t01_side, -- t01_side
                   t01_quantity = i.t01_orderqty, -- t01_quantity
                   t01_price = i.t01_price, -- t01_price
                   t01_min_quantity = i.t01_minqty, -- t01_min_quantity
                   t01_market_code_m29 = i.m29_market_code, -- t01_market_code_m29
                   t01_status_id_v30 = i.t01_ordstatus, -- t01_status_id_v30
                   t01_ord_channel_id_v29 = i.t01_channel, -- t01_ord_channel_id_v29
                   t01_instruction_type = i.t01_order_mode, -- t01_instruction_type
                   t01_commission = i.t01_commission, -- t01_commission
                   t01_orig_commission = i.t01_original_commision, -- t01_orig_commission
                   t01_discount  = i.t01_cum_discount_comm, -- Same Amount of T01_CUM_DISCOUNT Used Here Also
                   t01_exec_brk_commission = i.t01_exg_commission, -- t01_exec_brk_commission
                   t01_avg_price = i.t01_avgpx, -- t01_avg_price
                   t01_block_amount = i.t01_cash_block, -- t01_block_amount
                   t01_settle_currency_rate = i.t01_issue_stl_rate, -- t01_settle_currency_rate
                   t01_expiry_date = i.t01_expiretime, -- t01_expiry_date
                   t01_dealer_id_u17 = i.dealer_id, -- t01_dealer_id_u17
                   t01_cum_quantity = i.t01_cumqty, -- t01_cum_quantity
                   t01_cum_ord_value = i.t01_cum_ordvalue, -- t01_cum_ord_value
                   t01_cum_commission = i.t01_cum_commission, -- t01_cum_commission
                   t01_cum_exec_brk_commission = i.t01_cum_exec_brok_comm, -- t01_cum_exec_brk_commission
                   t01_cum_accrued_interest = i.t01_cum_accrued_interest, -- t01_cum_accrued_interest
                   t01_accrued_interest = i.t01_accrued_interest, -- t01_accrued_interest
                   t01_exec_broker_id_m26 = i.executing_broker, -- t01_exec_broker_id_m26
                   t01_custodian_id_m26 = i.custodian_id, -- t01_custodian_id_m26
                   t01_emp_trading_id_u19 = i.t01_dealer_id, -- t01_emp_trading_id_u19
                   t01_position_effect = i.t01_position_effect, -- t01_position_effect
                   t01_last_updated_date_time = i.t01_last_updated, -- t01_last_updated_date_time
                   t01_remote_tag_22 = i.t01_remote_tag_22, -- t01_remote_tag_22
                   t01_remote_tag_100 = i.t01_remote_tag_100, -- t01_remote_tag_100
                   t01_remote_sid = i.m26_sid, -- t01_remote_sid
                   t01_cum_netstl = i.t01_netsettle, -- t01_cum_netstl
                   t01_cash_acc_id_u06 = i.u07_cash_account_id_u06, -- t01_cash_acc_id_u06
                   t01_instrument_type_code = i.t01_security_type, -- t01_instrument_type_code
                   t01_order_mode = i.t01_order_mode, -- t01_order_mode
                   t01_fix_msg_type = i.t01_fixmsgtype, -- t01_fix_msg_type
                   t01_price_inst_type = i.m20_price_instrument_id_v34, -- t01_price_inst_type
                   t01_ord_exec_seq = i.t01_exec_seq, -- t01_ord_exec_seq
                   t01_db_created_date = i.t01_createddate, -- t01_db_created_date
                   t01_db_last_updated_date = i.t01_last_updated, -- t01_db_last_updated_date
                   t01_exchange_code_m01 = i.exchange, -- t01_exchange_code_m01
                   t01_customer_id_u01 = i.new_customer_id, -- t01_customer_id_u01
                   t01_tif_id_v10 = i.t01_timeinforce, -- t01_tif_id_v10
                   t01_symbol_code_m20 = i.t01_symbol, -- t01_symbol_code_m20
                   t01_brker_fix_id = i.t01_broker_fix_id, -- t01_brker_fix_id
                   t01_trading_acntno_u07 = i.t01_routingac, -- t01_trading_acntno_u07 -- Keeping T01_ROUTING_ACC which was used at the time of placing order as it is
                   t01_ord_value = i.t01_ordvalue, -- t01_ord_value
                   t01_ord_net_value = i.t01_ordnetvalue, -- t01_ord_net_value
                   t01_ord_net_settle = i.ord_net_settle, -- t01_ord_net_settle
                   t01_settle_currency = i.t01_settle_currency, -- t01_settle_currency
                   t01_fail_mngmnt_status = i.t01_fail_management_status, -- t01_fail_mngmnt_status
                   t01_fail_mngmnt_clord_id =
                       i.t01_fail_management_clordid, -- t01_fail_mngmnt_clord_id | Update Later in this Script if New ID Is Generated
                   t01_reject_reason = i.reject_reason, -- t01_reject_reason
                   t01_symbol_currency_code_m03 = i.t01_currency, -- t01_symbol_currency_code_m03
                   t01_profit_loss = i.t01_profit_loss, -- t01_profit_loss
                   t01_broker_tax = i.t01_broker_vat, -- t01_broker_tax
                   t01_exchange_tax = i.t01_exchange_vat, -- t01_exchange_tax
                   t01_cum_broker_tax = i.t01_cum_broker_vat, -- t01_cum_broker_tax
                   t01_cum_exchange_tax = i.t01_cum_exchange_vat, -- t01_cum_exchange_tax
                   t01_leaves_qty = i.t01_leavesqty, -- t01_leaves_qty
                   t01_last_shares = i.t01_lastshares, -- t01_last_shares
                   t01_last_price = i.t01_lastpx, -- t01_last_price
                   t01_act_broker_tax = i.t01_act_broker_vat, -- t01_act_broker_tax
                   t01_act_exchange_tax = i.t01_act_exchange_vat, -- t01_act_exchange_tax
                   t01_cum_net_value = i.t01_cum_ordnetvalue, -- t01_cum_net_value
                   t01_wfa_level = i.t01_wfa_level, -- t01_wfa_level
                   t01_institution_id_m02 = i.new_institute_id, -- t01_institution_id_m02
                   t01_custodian_type_v01 = i.u07_custodian_type_v01, -- t01_custodian_type_v01
                   t01_cash_settle_date = i.t01_settle_date, -- t01_cash_settle_date
                   t01_holding_settle_date = i.t01_settle_date, -- t01_holding_settle_date
                   t01_unsettle_qty = i.t01_unsettled_qty, -- t01_unsettle_qty
                   t01_desk_order_ref_t52 = i.t01_desk_order_ref, -- t01_desk_order_ref_t52 | Updating Later in the Post Migration Script if New ID Is Generated
                   t01_desk_order_no_t52 = i.t01_desk_order_number, -- t01_desk_order_no_t52 | Updating Later in the Post Migration Script if New ID Is Generated
                   t01_tag50 = i.t01_tag_50, -- t01_tag50
                   t01_cum_discount = i.t01_cum_discount_comm, -- t01_cum_discount
                   t01_poa_id_u47 = i.new_power_of_attorney_id, -- t01_poa_id_u47
                   t01_wfa_reason = i.t01_wfa_reason, -- t01_wfa_reason
                   t01_parent_ord_category_t38 = i.parent_ord_category, -- t01_parent_ord_category_t38
                   t01_cma_tax = i.t01_cma_exchange_vat, -- t01_cma_tax
                   t01_cpp_tax = i.t01_cpp_exchange_vat, -- t01_cpp_tax
                   t01_dcm_tax = i.t01_dcm_gcm_exchange_vat, -- t01_dcm_tax
                   t01_cum_cma_tax = i.t01_cma_exchange_vat, -- t01_cum_cma_tax | Not Available
                   t01_cum_cpp_tax = i.t01_cpp_exchange_vat, -- t01_cum_cpp_tax | Not Available
                   t01_cum_dcm_tax = i.t01_dcm_gcm_exchange_vat, -- t01_cum_dcm_tax | Not Available
                   t01_act_cma_tax = i.t01_act_cma_exchange_vat, -- t01_act_cma_tax
                   t01_act_cpp_tax = i.t01_act_cpp_exchange_vat, -- t01_act_cpp_tax
                   t01_act_dcm_tax = i.t01_act_dcm_gcm_exchange_vat, -- t01_act_dcm_tax
                   t01_cum_act_cma_tax = i.t01_act_cma_exchange_vat, -- t01_cum_act_cma_tax | Not Available
                   t01_cum_act_cpp_tax = i.t01_act_cpp_exchange_vat, -- t01_cum_act_cpp_tax | Not Available
                   t01_cum_act_dcm_tax = i.t01_act_dcm_gcm_exchange_vat, -- t01_cum_act_dcm_tax | Not Available
                   t01_cma_commission = i.t01_cma_exchange_comm, -- t01_cma_commission
                   t01_cpp_commission = i.t01_cpp_exchange_comm, -- t01_cpp_commission
                   t01_dcm_commission = i.t01_dcm_gcm_exchange_comm, -- t01_dcm_commission
                   t01_cma_cum_commission = i.t01_cma_exchange_comm, -- t01_cma_cum_commission | Not Available
                   t01_cpp_cum_commission = i.t01_cpp_exchange_comm, -- t01_cpp_cum_commission | Not Available
                   t01_dcm_cum_commission = i.t01_dcm_gcm_exchange_comm, -- t01_dcm_cum_commission | Not Available
                   t01_initial_margin_amount = i.t01_initial_margin_amount, -- t01_initial_margin_amount
                   t01_maintain_margin_amount =
                       i.t01_maintain_margin_amount, -- t01_maintain_margin_amount
                   t01_cum_initial_margin_amount =
                       i.t01_cum_initial_margin_amount, -- t01_cum_initial_margin_amount
                   t01_cum_maintain_margin_amount =
                       i.t01_cum_maintain_margin_amount, -- t01_cum_maintain_margin_amount
                   t01_contract_id_t75 = i.new_murabaha_contract_id, -- t01_contract_id_t75
                   t01_avg_cost = i.t01_avgcost, -- t01_avg_cost
                   t01_exchange_id_m01 = i.u07_exchange_id_m01, -- t01_exchange_id_m01
                   t01_other_commission = i.t01_algo_comm, -- t01_other_commission
                   t01_other_tax = i.t01_algo_vat, -- t01_other_tax
                   t01_other_cum_commission = i.t01_cum_algo_comm, -- t01_other_cum_commission
                   t01_other_cum_tax = i.t01_cum_algo_vat -- t01_other_cum_tax
             WHERE t01_cl_ord_id = i.new_cl_order_id;*/
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
                                'T01_ORDER',
                                i.t01_clordid,
                                CASE
                                    WHEN i.new_cl_order_id IS NULL
                                    THEN
                                        l_cl_order_id
                                    ELSE
                                        i.new_cl_order_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cl_order_id IS NULL
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

-- Updating Original Client Order ID and Fail Management Client Order ID if New ID Is Generated

BEGIN
    IF fn_use_new_key ('T01_ORDER') = 1
    THEN
        FOR i
            IN (SELECT t01.t01_cl_ord_id AS cl_ord_id,
                       order_no.new_cl_order_id AS order_no,
                       orig_cl_ord_id.new_cl_order_id AS orig_cl_ord_id,
                       fail_mngnt_cl_ord_id.new_cl_order_id
                           AS fail_mgnt_cl_ord_id
                  FROM dfn_ntp.t01_order t01,
                       t01_order_mappings order_no,
                       t01_order_mappings orig_cl_ord_id,
                       t01_order_mappings fail_mngnt_cl_ord_id
                 WHERE     t01.t01_ord_no = order_no.old_cl_order_id
                       AND t01.t01_orig_cl_ord_id =
                               orig_cl_ord_id.old_cl_order_id(+)
                       AND t01.t01_fail_mngmnt_clord_id =
                               fail_mngnt_cl_ord_id.old_cl_order_id(+))
        LOOP
            UPDATE dfn_ntp.t01_order t01
               SET t01.t01_ord_no = i.order_no,
                   t01.t01_orig_cl_ord_id = NVL (i.orig_cl_ord_id, -1),
                   t01.t01_fail_mngmnt_clord_id = i.fail_mgnt_cl_ord_id
             WHERE t01.t01_cl_ord_id = i.cl_ord_id;
        END LOOP;
    END IF;
END;
/

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('T01_ORDER');
END;
/

-- Subscriptions & Reversals are Captured as Orders

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_subs_order_id          NUMBER;
    l_market_code            VARCHAR2 (10);
    l_sqlerrm                VARCHAR2 (4000);
    l_rec_cnt                NUMBER := 0;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (m29.m29_market_code), 'ALL')
      INTO l_market_code
      FROM dfn_ntp.m29_markets m29
     WHERE     m29.m29_primary_institution_id_m02 = l_primary_institute_id
           AND m29.m29_exchange_code_m01 = 'TDWL'
           AND m29.m29_is_default = 1;

    SELECT NVL (MAX (TO_NUMBER (t01_cl_ord_id)), 0)
      INTO l_subs_order_id
      FROM dfn_ntp.t01_order;

    DELETE FROM error_log
          WHERE mig_table = 'T01_ORDER - SUBSCRIPTION';

    FOR i
        IN (SELECT t24.t24_id,
                   t24.t24_timestamp,
                   TRUNC (t24.t24_timestamp) AS subs_date,
                   u07_map.new_trading_account_id,
                   m20.m20_id,
                   t24.t24_quantity,
                   t24.t24_status,
                   t24.t24_avgcost,
                   CASE
                       WHEN t24.t24_status IN (1, 2, 3) THEN 'O' -- OMS ACCEPTED
                       WHEN t24.t24_status IN (4, 7) THEN '2' -- FILLED
                       WHEN t24.t24_status IN (5) THEN '4' -- CANCELLED
                       WHEN t24.t24_status IN (0, 6) THEN '8' -- REJECTED
                       WHEN t24.t24_status IN (8) THEN 'M' -- SEND TO OMS NEW
                       WHEN t24.t24_status IN (9) THEN 'c' -- WAITING FOR APPROVAL
                       WHEN t24.t24_status IN (10) THEN 'h' -- REVERSED
                       ELSE 'C'
                   END
                       AS status_id,
                     NVL (t24.t24_quantity, 0) * NVL (t24.t24_avgcost, 0)
                   + NVL (t24.t24_fees, 0)
                       AS block_amount,
                   NVL (u17.new_employee_id, -1) AS entered_by_id,
                   CASE
                       WHEN t24.t24_status IN (4, 7)
                       THEN
                           NVL (t24.t24_quantity, 0)
                       ELSE
                           0
                   END
                       AS cum_quantity,
                   CASE
                       WHEN t24.t24_status IN (4, 7)
                       THEN
                             NVL (t24.t24_quantity, 0)
                           * NVL (t24.t24_avgcost, 0)
                       ELSE
                           0
                   END
                       AS cum_ord_value,
                   CASE
                       WHEN t24.t24_status IN (4, 7)
                       THEN
                           NVL (t24.t24_fees, 0)
                       ELSE
                           0
                   END
                       AS cum_commission,
                   NVL (map16.map16_ntp_code, t24.t24_exchange) AS exchange,
                   m26_broker.m26_id AS executing_broker_id,
                   m26_broker.m26_sid AS executing_broker_sid,
                   m26_custody.m26_id AS custodian_id,
                   m26_custody.m26_sid AS custodian_sid,
                   CASE
                       WHEN t24.t24_status IN (4, 7)
                       THEN
                               NVL (t24.t24_quantity, 0)
                             * NVL (t24.t24_avgcost, 0)
                           + NVL (t24.t24_fees, 0)
                       ELSE
                           0
                   END
                       AS cum_netstl,
                   u07.u07_cash_account_id_u06,
                   m20.m20_instrument_type_code_v09,
                   m20.m20_price_instrument_id_v34,
                   u07.u07_customer_id_u01,
                   m20.m20_symbol_code,
                   u07.u07_exchange_account_no,
                   NVL (t24.t24_quantity, 0) * NVL (t24.t24_avgcost, 0)
                       AS ord_value,
                     NVL (t24.t24_quantity, 0) * NVL (t24.t24_avgcost, 0)
                   + NVL (t24.t24_fees, 0)
                       AS ord_net_value,
                   m20.m20_currency_code_m03,
                   t24.t24_reject_reason,
                   t24.t24_broker_vat,
                   t24.t24_exchange_vat,
                   CASE
                       WHEN t24.t24_status IN (4, 7)
                       THEN
                           NVL (t24.t24_broker_vat, 0)
                       ELSE
                           0
                   END
                       AS cum_broker_tax,
                   CASE
                       WHEN t24.t24_status IN (4, 7)
                       THEN
                           NVL (t24.t24_exchange_vat, 0)
                       ELSE
                           0
                   END
                       AS cum_exchange_tax,
                   u07.u07_institute_id_m02,
                   u07.u07_custodian_type_v01,
                   u07.u07_exchange_id_m01,
                   t24.t24_fees,
                   t01_subs_map.new_subs_cl_order_id
              FROM mubasher_oms.t24_pending_stocks@mubasher_db_link t24,
                   map16_optional_exchanges_m01 map16,
                   u07_trading_account_mappings u07_map,
                   dfn_ntp.u07_trading_account u07,
                   (SELECT m20_id,
                           m20_symbol_code,
                           m20_exchange_code_m01,
                           m20_price_instrument_id_v34,
                           m20_instrument_type_code_v09,
                           m20_currency_code_m03
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20,
                   dfn_ntp.m43_institute_exchanges m43,
                   dfn_ntp.m26_executing_broker m26_broker,
                   dfn_ntp.m26_executing_broker m26_custody,
                   u17_employee_mappings u17,
                   t01_subs_order_mappings t01_subs_map
             WHERE     t24.t24_txn_type IN (13, 15) -- 13 (Right Subscriptions) & 15 (Right Reversals)
                   AND t24.t24_inst_id <> 0 -- [Corrective Actions Discussed]
                   AND t24.t24_portfolio_id =
                           u07_map.old_trading_account_id(+)
                   AND t24.t24_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, t24.t24_exchange) =
                           u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id = u07.u07_id(+)
                   AND NVL (map16.map16_ntp_code, t24.t24_exchange) =
                           m20.m20_exchange_code_m01(+)
                   AND t24.t24_symbol = m20.m20_symbol_code(+)
                   AND u07.u07_institute_id_m02 = m43.m43_institute_id_m02(+)
                   AND NVL (map16.map16_ntp_code, t24.t24_exchange) =
                           m43.m43_exchange_code_m01(+)
                   AND m43.m43_custodian_id_m26 = m26_custody.m26_id(+)
                   AND m43.m43_executing_broker_id_m26 = m26_broker.m26_id(+)
                   AND t24.t24_entered_by = u17.old_employee_id(+)
                   AND t24.t24_id = t01_subs_map.old_stock_txn_id(+))
    LOOP
        BEGIN
            IF i.u07_institute_id_m02 IS NULL
            THEN
                raise_application_error (-20001,
                                         'Institute Not Available',
                                         TRUE);
            END IF;

            IF i.u07_customer_id_u01 IS NULL
            THEN
                raise_application_error (-20001,
                                         'Customer Not Available',
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
                                         'Symbol Not Available',
                                         TRUE);
            END IF;

            IF i.new_subs_cl_order_id IS NULL
            THEN
                l_subs_order_id := l_subs_order_id + 1;

                INSERT
                  INTO dfn_ntp.t01_order (t01_ord_no,
                                          t01_date_time,
                                          t01_date,
                                          t01_cl_ord_id,
                                          t01_orig_cl_ord_id,
                                          t01_exchange_ord_id,
                                          t01_remote_cl_ord_id,
                                          t01_remote_orig_cl_ord_id,
                                          t01_trading_acc_id_u07,
                                          t01_symbol_id_m20,
                                          t01_ord_type_id_v06,
                                          t01_side,
                                          t01_quantity,
                                          t01_price,
                                          t01_min_quantity,
                                          t01_market_code_m29,
                                          t01_status_id_v30,
                                          t01_ord_channel_id_v29,
                                          t01_instruction_type,
                                          t01_commission,
                                          t01_orig_commission,
                                          t01_discount,
                                          t01_exec_brk_commission,
                                          t01_avg_price,
                                          t01_block_amount,
                                          t01_settle_currency_rate,
                                          t01_expiry_date,
                                          t01_dealer_id_u17,
                                          t01_customer_login_id_u09,
                                          t01_cum_quantity,
                                          t01_cum_ord_value,
                                          t01_cum_commission,
                                          t01_cum_exec_brk_commission,
                                          t01_cum_accrued_interest,
                                          t01_accrued_interest,
                                          t01_exec_broker_id_m26,
                                          t01_custodian_id_m26,
                                          t01_emp_trading_id_u19,
                                          t01_position_effect,
                                          t01_remarks,
                                          t01_last_updated_date_time,
                                          t01_tag_remote_sub_comp_id,
                                          t01_remote_tag_22,
                                          t01_remote_tag_100,
                                          t01_remote_sid,
                                          t01_cum_netstl,
                                          t01_tenant_code,
                                          t01_cash_acc_id_u06,
                                          t01_instrument_type_code,
                                          t01_order_mode,
                                          t01_fix_msg_type,
                                          t01_disclose_qty,
                                          t01_price_inst_type,
                                          t01_ord_exec_seq,
                                          t01_db_created_date,
                                          t01_last_updated_by,
                                          t01_db_last_updated_date,
                                          t01_last_db_seq_id,
                                          t01_exchange_code_m01,
                                          t01_customer_id_u01,
                                          t01_tif_id_v10,
                                          t01_symbol_code_m20,
                                          t01_exec_instruction,
                                          t01_brker_fix_id,
                                          t01_trading_acntno_u07,
                                          t01_ord_value,
                                          t01_ord_net_value,
                                          t01_ord_net_settle,
                                          t01_settle_currency,
                                          t01_gainloss,
                                          t01_is_active_order,
                                          t01_fail_mngmnt_status,
                                          t01_fail_mngmnt_clord_id,
                                          t01_fail_mngmnt_exec_id,
                                          t01_reject_reason,
                                          t01_symbol_currency_code_m03,
                                          t01_profit_loss_for_this_exec,
                                          t01_profit_loss,
                                          t01_broker_tax,
                                          t01_exchange_tax,
                                          t01_cum_broker_tax,
                                          t01_cum_exchange_tax,
                                          t01_leaves_qty,
                                          t01_server_id,
                                          t01_last_shares,
                                          t01_last_price,
                                          t01_act_broker_tax,
                                          t01_act_exchange_tax,
                                          t01_cum_net_value,
                                          t01_cum_act_broker_tax,
                                          t01_cum_act_exchange_tax,
                                          t01_wfa_level,
                                          t01_institution_id_m02,
                                          t01_ib_commission,
                                          t01_cum_ib_commission,
                                          t01_custodian_type_v01,
                                          t01_cash_settle_date,
                                          t01_holding_settle_date,
                                          t01_unsettle_qty,
                                          t01_desk_order_ref_t52,
                                          t01_desk_order_no_t52,
                                          t01_trade_process_stat_id_v01,
                                          t01_approved_by_id_u17,
                                          t01_algo_ord_ref_t54,
                                          t01_wfa_current_value,
                                          t01_wfa_expected_value,
                                          t01_remote_sec_source_id,
                                          t01_tag50,
                                          t01_orig_exg_commission,
                                          t01_cum_discount,
                                          t01_original_exchange_ord_id,
                                          t01_poa_id_u47,
                                          t01_wfa_reason,
                                          t01_con_ord_ref_t38,
                                          t01_parent_ord_category_t38,
                                          t01_is_archive_ready,
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
                                          t01_orig_exg_tax,
                                          t01_orig_brk_tax,
                                          t01_initial_margin_amount,
                                          t01_maintain_margin_amount,
                                          t01_cum_initial_margin_amount,
                                          t01_cum_maintain_margin_amount,
                                          t01_maintain_margin_block,
                                          t01_cum_maintain_margin_block,
                                          t01_holding_avg_price,
                                          t01_contract_id_t75,
                                          t01_holding_avg_cost,
                                          t01_avg_cost,
                                          t01_exchange_id_m01,
                                          t01_negotiated_request_id_t85,
                                          t01_board_code_m54,
                                          t01_short_sell_enable,
                                          t01_bypass_rms_validation,
                                          t01_integration_ext_ref_no,
                                          t01_other_commission,
                                          t01_other_tax,
                                          t01_other_cum_commission,
                                          t01_other_cum_tax)
                VALUES (l_subs_order_id, -- t01_ord_no
                        i.t24_timestamp, -- t01_date_time
                        i.subs_date, -- t01_date
                        l_subs_order_id, -- t01_cl_ord_id
                        NULL, -- t01_orig_cl_ord_id | Not Available
                        i.t24_id, -- t01_exchange_ord_id
                        NULL, -- t01_remote_cl_ord_id | Not Available
                        NULL, -- t01_remote_orig_cl_ord_id | Not Available
                        i.new_trading_account_id, -- t01_trading_acc_id_u07
                        i.m20_id, -- t01_symbol_id_m20
                        2, -- t01_ord_type_id_v06 | 2 : Limit
                        3, -- t01_side | 3 : Subscription
                        i.t24_quantity, -- t01_quantity
                        i.t24_avgcost, -- t01_price | Used Average Cost
                        NULL, -- t01_min_quantity | Not Available
                        l_market_code, -- t01_market_code_m29
                        i.status_id, -- t01_status_id_v30
                        7, -- t01_ord_channel_id_v29 | 7 : AT
                        0, -- t01_instruction_type | 0 : Online
                        i.t24_fees, -- t01_commission
                        i.t24_fees, -- t01_orig_commission
                        0, -- t01_discount | Same as T01_CUM_DISCOUNT
                        i.t24_fees, -- t01_exec_brk_commission
                        i.t24_avgcost, -- t01_avg_price
                        i.block_amount, -- t01_block_amount
                        1, -- t01_settle_currency_rate
                        i.t24_timestamp, -- t01_expiry_date
                        i.entered_by_id, -- t01_dealer_id_u17
                        NULL, -- t01_customer_login_id_u09
                        i.cum_quantity, -- t01_cum_quantity
                        i.cum_ord_value, -- t01_cum_ord_value
                        i.cum_commission, -- t01_cum_commission
                        i.cum_commission, -- t01_cum_exec_brk_commission
                        0, -- t01_cum_accrued_interest | Not Available
                        0, -- t01_accrued_interest | Not Available
                        i.executing_broker_id, -- t01_exec_broker_id_m26
                        i.custodian_id, -- t01_custodian_id_m26
                        i.entered_by_id, -- t01_emp_trading_id_u19
                        NULL, -- t01_position_effect | Not Available
                        NULL, -- t01_remarks | Not Available
                        i.t24_timestamp, -- t01_last_updated_date_time
                        NULL, -- t01_tag_remote_sub_comp_id | Not Available
                        NULL, -- t01_remote_tag_22 | Not Available
                        NULL, -- t01_remote_tag_100 | Not Available
                        NULL, -- t01_remote_sid | Not Available
                        i.cum_netstl, -- t01_cum_netstl
                        'DEFAULT', -- t01_tenant_code
                        i.u07_cash_account_id_u06, -- t01_cash_acc_id_u06
                        i.m20_instrument_type_code_v09, -- t01_instrument_type_code
                        0, -- t01_order_mode | 0 : Online
                        NULL, -- t01_fix_msg_type | Not Available
                        0, -- t01_disclose_qty | Not Available
                        i.m20_price_instrument_id_v34, -- t01_price_inst_type
                        NULL, -- t01_ord_exec_seq | Not Available
                        i.t24_timestamp, -- t01_db_created_date
                        NULL, -- t01_last_updated_by | Not Available
                        i.t24_timestamp, -- t01_db_last_updated_date
                        NULL, -- t01_last_db_seq_id | Not Available
                        i.exchange, -- t01_exchange_code_m01
                        i.u07_customer_id_u01, -- t01_customer_id_u01
                        0, -- t01_tif_id_v10 | 0 : Day
                        i.m20_symbol_code, -- t01_symbol_code_m20
                        NULL, -- t01_exec_instruction | Not Available
                        NULL, -- t01_brker_fix_id | Not Available
                        i.u07_exchange_account_no, -- t01_trading_acntno_u07
                        i.ord_value, -- t01_ord_value
                        i.ord_net_value, -- t01_ord_net_value
                        i.ord_net_value, -- t01_ord_net_settle
                        i.m20_currency_code_m03, -- t01_settle_currency
                        0, -- t01_gainloss | Not Available
                        0, -- t01_is_active_order | Not Available
                        NULL, -- t01_fail_mngmnt_status | Not Available
                        NULL, -- t01_fail_mngmnt_clord_id | Update Later in this Script if New ID Is Generated
                        NULL, -- t01_fail_mngmnt_exec_id | Not Available
                        i.t24_reject_reason, -- t01_reject_reason
                        i.m20_currency_code_m03, -- t01_symbol_currency_code_m03
                        0, -- t01_profit_loss_for_this_exec | Not Available
                        0, -- t01_profit_loss | Not Available
                        i.t24_broker_vat, -- t01_broker_tax
                        i.t24_exchange_vat, -- t01_exchange_tax
                        i.cum_broker_tax, -- t01_cum_broker_tax
                        i.cum_exchange_tax, -- t01_cum_exchange_tax
                        0, -- t01_leaves_qty | Not Available
                        NULL, -- t01_server_id
                        i.t24_quantity, -- t01_last_shares
                        i.t24_avgcost, -- t01_last_price
                        i.t24_broker_vat, -- t01_act_broker_tax
                        i.t24_exchange_vat, -- t01_act_exchange_tax
                        i.cum_netstl, -- t01_cum_net_value
                        0, -- t01_cum_act_broker_tax | Not Available
                        0, -- t01_cum_act_exchange_tax | Not Available
                        NULL, -- t01_wfa_level | Not Available
                        i.u07_institute_id_m02, -- t01_institution_id_m02
                        0, -- t01_ib_commission | Not Available
                        0, -- t01_cum_ib_commission | Not Available
                        i.u07_custodian_type_v01, -- t01_custodian_type_v01
                        i.subs_date, -- t01_cash_settle_date
                        i.subs_date, -- t01_holding_settle_date
                        0, -- t01_unsettle_qty | Not Available
                        NULL, -- t01_desk_order_ref_t52 | Not Available
                        NULL, -- t01_desk_order_no_t52 | Not Available
                        25, -- t01_trade_process_stat_id_v01 | 25 - Settled
                        -1, -- t01_approved_by_id_u17 | Not Available
                        NULL, -- t01_algo_ord_ref_t54 | Not Available
                        NULL, -- t01_wfa_current_value | Not Available
                        NULL, -- t01_wfa_expected_value | Not Available
                        NULL, -- t01_remote_sec_source_id | Not Available
                        NULL, -- t01_tag50 | Not Available
                        NULL, -- t01_orig_exg_commission | Not Available
                        0, -- t01_cum_discount | Not Available
                        NULL, -- t01_original_exchange_ord_id | Not Available
                        NULL, -- t01_poa_id_u47 | Not Available
                        NULL, -- t01_wfa_reason | Not Available
                        NULL, -- t01_con_ord_ref_t38 | Not Available
                        NULL, -- t01_parent_ord_category_t38 | Not Available
                        0, -- t01_is_archive_ready | Not Available
                        0, -- t01_cma_tax | Not Available
                        0, -- t01_cpp_tax | Not Available
                        0, -- t01_dcm_tax | Not Available
                        0, -- t01_cum_cma_tax | Not Available
                        0, -- t01_cum_cpp_tax | Not Available
                        0, -- t01_cum_dcm_tax | Not Available
                        0, -- t01_act_cma_tax | Not Available
                        0, -- t01_act_cpp_tax | Not Available
                        0, -- t01_act_dcm_tax | Not Available
                        0, -- t01_cum_act_cma_tax | Not Available
                        0, -- t01_cum_act_cpp_tax | Not Available
                        0, -- t01_cum_act_dcm_tax | Not Available
                        0, -- t01_cma_commission | Not Available
                        0, -- t01_cpp_commission | Not Available
                        0, -- t01_dcm_commission | Not Available
                        0, -- t01_cma_cum_commission | Not Available
                        0, -- t01_cpp_cum_commission | Not Available
                        0, -- t01_dcm_cum_commission | Not Available
                        NULL, -- t01_orig_exg_tax | Not Available
                        NULL, -- t01_orig_brk_tax | Not Available
                        0, -- t01_initial_margin_amount | Not Available
                        0, -- t01_maintain_margin_amount | Not Available
                        0, -- t01_cum_initial_margin_amount | Not Available
                        0, -- t01_cum_maintain_margin_amount | Not Available
                        0, -- t01_maintain_margin_block | Not Available
                        0, -- t01_cum_maintain_margin_block | Not Available
                        NULL, -- t01_holding_avg_price | Not Available
                        NULL, -- t01_contract_id_t75 | Not Available
                        NULL, -- t01_holding_avg_cost | Not Available
                        i.t24_avgcost, -- t01_avg_cost
                        i.u07_exchange_id_m01, -- t01_exchange_id_m01
                        NULL, -- t01_negotiated_request_id_t85 | Not Available
                        NULL, -- t01_board_code_m54 | Not Available
                        0, -- t01_short_sell_enable | Not Available
                        0, -- t01_bypass_rms_validation | 0 (No) - Default
                        NULL, -- t01_integration_ext_ref_no | Not Available
                        NULL, -- t01_other_commission | Not Available
                        NULL, -- t01_other_tax | Not Available
                        NULL, -- t01_other_cum_commission | Not Available
                        NULL -- t01_other_cum_tax | Not Available
                            );

                INSERT INTO t01_subs_order_mappings
                     VALUES (i.t24_id, l_subs_order_id);
            ELSE
                -- Eventhough orders are not updated during parallel run these orders generated for subscription and reversals need to be updated
                UPDATE dfn_ntp.t01_order
                   SET t01_ord_no = l_subs_order_id, -- t01_ord_no
                       t01_date_time = i.t24_timestamp, -- t01_date_time
                       t01_date = i.subs_date, -- t01_date
                       t01_exchange_ord_id = i.t24_id, -- t01_exchange_ord_id
                       t01_trading_acc_id_u07 = i.new_trading_account_id, -- t01_trading_acc_id_u07
                       t01_symbol_id_m20 = i.m20_id, -- t01_symbol_id_m20
                       t01_quantity = i.t24_quantity, -- t01_quantity
                       t01_price = i.t24_avgcost, -- t01_price | Used Average Cost
                       t01_status_id_v30 = i.status_id, -- t01_status_id_v30
                       t01_commission = i.t24_fees, -- t01_commission
                       t01_orig_commission = i.t24_fees, -- t01_orig_commission
                       t01_exec_brk_commission = i.t24_fees, -- t01_exec_brk_commission
                       t01_avg_price = i.t24_avgcost, -- t01_avg_price
                       t01_block_amount = i.block_amount, -- t01_block_amount
                       t01_expiry_date = i.t24_timestamp, -- t01_expiry_date
                       t01_dealer_id_u17 = i.entered_by_id, -- t01_dealer_id_u17
                       t01_cum_quantity = i.cum_quantity, -- t01_cum_quantity
                       t01_cum_ord_value = i.cum_ord_value, -- t01_cum_ord_value
                       t01_cum_commission = i.cum_commission, -- t01_cum_commission
                       t01_cum_exec_brk_commission = i.cum_commission, -- t01_cum_exec_brk_commission
                       t01_exec_broker_id_m26 = i.executing_broker_id, -- t01_exec_broker_id_m26
                       t01_custodian_id_m26 = i.custodian_id, -- t01_custodian_id_m26
                       t01_emp_trading_id_u19 = i.entered_by_id, -- t01_emp_trading_id_u19
                       t01_last_updated_date_time = i.t24_timestamp, -- t01_last_updated_date_time
                       t01_cum_netstl = i.cum_netstl, -- t01_cum_netstl
                       t01_cash_acc_id_u06 = i.u07_cash_account_id_u06, -- t01_cash_acc_id_u06
                       t01_instrument_type_code =
                           i.m20_instrument_type_code_v09, -- t01_instrument_type_code
                       t01_price_inst_type = i.m20_price_instrument_id_v34, -- t01_price_inst_type
                       t01_db_created_date = i.t24_timestamp, -- t01_db_created_date
                       t01_db_last_updated_date = i.t24_timestamp, -- t01_db_last_updated_date
                       t01_exchange_code_m01 = i.exchange, -- t01_exchange_code_m01
                       t01_customer_id_u01 = i.u07_customer_id_u01, -- t01_customer_id_u01
                       t01_symbol_code_m20 = i.m20_symbol_code, -- t01_symbol_code_m20
                       t01_trading_acntno_u07 = i.u07_exchange_account_no, -- t01_trading_acntno_u07
                       t01_ord_value = i.ord_value, -- t01_ord_value
                       t01_ord_net_value = i.ord_net_value, -- t01_ord_net_value
                       t01_ord_net_settle = i.ord_net_value, -- t01_ord_net_settle
                       t01_settle_currency = i.m20_currency_code_m03, -- t01_settle_currency
                       t01_reject_reason = i.t24_reject_reason, -- t01_reject_reason
                       t01_symbol_currency_code_m03 = i.m20_currency_code_m03, -- t01_symbol_currency_code_m03
                       t01_broker_tax = i.t24_broker_vat, -- t01_broker_tax
                       t01_exchange_tax = i.t24_exchange_vat, -- t01_exchange_tax
                       t01_cum_broker_tax = i.cum_broker_tax, -- t01_cum_broker_tax
                       t01_cum_exchange_tax = i.cum_exchange_tax, -- t01_cum_exchange_tax
                       t01_last_shares = i.t24_quantity, -- t01_last_shares
                       t01_last_price = i.t24_avgcost, -- t01_last_price
                       t01_act_broker_tax = i.t24_broker_vat, -- t01_act_broker_tax
                       t01_act_exchange_tax = i.t24_exchange_vat, -- t01_act_exchange_tax
                       t01_cum_net_value = i.cum_netstl, -- t01_cum_net_value
                       t01_institution_id_m02 = i.u07_institute_id_m02, -- t01_institution_id_m02
                       t01_custodian_type_v01 = i.u07_custodian_type_v01, -- t01_custodian_type_v01
                       t01_cash_settle_date = i.subs_date, -- t01_cash_settle_date
                       t01_holding_settle_date = i.subs_date, -- t01_holding_settle_date
                       t01_avg_cost = i.t24_avgcost, -- t01_avg_cost
                       t01_exchange_id_m01 = i.u07_exchange_id_m01 -- t01_exchange_id_m01
                 WHERE t01_cl_ord_id = i.new_subs_cl_order_id;
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
                                'T01_ORDER - SUBSCRIPTION',
                                i.t24_id,
                                CASE
                                    WHEN i.new_subs_cl_order_id IS NULL
                                    THEN
                                        l_subs_order_id
                                    ELSE
                                        i.new_subs_cl_order_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_subs_cl_order_id IS NULL
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

BEGIN
    dfn_ntp.sp_stat_gather ('T01_ORDER');
END;
/