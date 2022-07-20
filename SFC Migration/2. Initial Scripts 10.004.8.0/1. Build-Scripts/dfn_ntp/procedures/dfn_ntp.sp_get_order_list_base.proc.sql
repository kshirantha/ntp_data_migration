CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_order_list_base (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    pfromdate             DATE DEFAULT NULL,
    ptodate               DATE DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    puserid               NUMBER DEFAULT NULL,
    puserfilter           NUMBER DEFAULT 1)
IS
    l_qry       VARCHAR2 (15000);
    s1          VARCHAR2 (15000);
    s2          VARCHAR2 (15000);
    userfiler   NUMBER := NULL;
BEGIN
    IF puserid IS NOT NULL AND puserfilter IS NOT NULL
    THEN
        userfiler := 1;
    END IF;

    prows := 0;
    l_qry :=
           'SELECT t01.t01_cl_ord_id,
       t01.t01_remote_cl_ord_id,
       t01.t01_ord_no,
       t01.t01_side,
       order_side,
       t01.t01_quantity,
       t01.t01_leaves_qty,
       t01.t01_price,
       t01.t01_cum_quantity,
       t01.t01_avg_price,
       t01.t01_cum_ord_value,
       t01.t01_cum_net_value,
       t01.t01_ord_type_id_v06,
       t01.t01_ord_value,
       t01.t01_commission,
       t01.t01_min_quantity,
       t01.t01_date,
       t01.t01_date_time,
       t01.t01_expiry_date,
       t01.t01_cash_settle_date,
       t01.t01_holding_settle_date,
       t01.t01_exchange_code_m01,
       t01.t01_tif_id_v10,
       t01.t01_status_id_v30,
       t01.t01_order_mode,
       CASE
            WHEN t01_order_mode = 1 THEN ''Offline''
            WHEN t01_order_mode = 0 THEN ''Online''
       END
          AS order_mode,
       t01.t01_disclose_qty,
       t01.t01_broker_tax,
       t01.t01_exchange_tax,
       t01.t01_cum_commission,
       t01.t01_instrument_type_code,
       t01.t01_cum_exec_brk_commission,
       t01.t01_exec_brk_commission,
       cum_broker_commission,
       t01.t01_ord_net_value,
       t01.t01_settle_currency,
       t01.t01_cum_exchange_tax,
       t01.t01_cum_broker_tax,
       cum_total_tax,
       t01.t01_settle_currency_rate,
       t01.t01_ord_net_settle,
       t01.t01_exec_broker_id_m26,
       v30.v30_description,
       v30.v30_description_lang,
       v10_description,
       u01.u01_preferred_lang_id_v01,
       u01.u01_id,
       u01.u01_customer_no,
       u01.u01_display_name,
       u01.u01_def_mobile AS u02_mobile,
       u01.u01_def_email AS u02_email,
       u01.u01_nationality_id_m05,
       u01.u01_external_ref_no,
       t01.t01_symbol_id_m20,
       m20_symbol_code,
       v06_description,
       v06_description_lang,
       m20_isincode,
       m20_short_description,
       m20_short_description_lang,
       m20_long_description,
       m20_long_description_lang,
       m20_currency_id_m03,
       m20_currency_code_m03,
       t01.t01_trading_acntno_u07,
       t01.t01_last_shares,
       t01.t01_last_price,
       t01.t01_ord_channel_id_v29,
       v29_description,
       t01.t01_custodian_id_m26,
       m26_custody.m26_sid,
       m26_custody.m26_sid || '' - ''|| m26_custody.m26_name as m26_name,
       t01.t01_reject_reason,
       t01.t01_accrued_interest,
       m20_expire_date,
       m20_option_type,
       DECODE (m20.m20_option_type,  0, ''Put'',  1, ''Call'')
           AS option_type_desc,
       m20_strike_price,
       t01.t01_position_effect,
       position_effect_desc,
       position_covered,
       t01.t01_orig_cl_ord_id,
       t01.t01_trading_acc_id_u07,
       t01.t01_cash_acc_id_u06,
       t01.t01_block_amount,
       t01.t01_cum_netstl,
       t01.t01_market_code_m29,
       t01.t01_board_code_m54,
       t01.t01_tenant_code,
       t01.t01_exchange_ord_id,
       t01.t01_price_inst_type,
       t01.t01_dealer_id_u17,
       t01.t01_last_updated_date_time,
       format_last_update_date_time,
       t01.t01_fail_mngmnt_status,
       t01.t01_fail_mngmnt_status_desc,
       t01.t01_institution_id_m02,
       u17_full_name,
       t01.t01_customer_id_u01,
       m26_broker.m26_sid AS exec_broker,
       m26_broker.m26_sid || '' - ''|| m26_broker.m26_name AS exec_broker_name,
       u07.u07_display_name,
       u07.u07_display_name_u06,
       custodian_type,
       t01.t01_desk_order_ref_t52,
       t01.t01_desk_order_no_t52,
       t01.t01_trade_process_stat_id_v01,
       v01.v01_description,
       v01.v01_description_lang,
       total_tax,
       t01.m02_primary_institute_id_m02,
       t01.m02_name,
       u07_trading_group_id_m08, -- no use
       t01.t01_original_exchange_ord_id,
       t01.t01_custodian_type_v01,
       t01.t01_remote_orig_cl_ord_id,
       t01.t01_algo_ord_ref_t54,
       t01.t01_con_ord_ref_t38,
       t01.t01_parent_ord_category_t38,
       t01.t01_orig_exg_tax,
       t01.t01_orig_brk_tax,
       t01.t01_cma_tax,
       t01.t01_cpp_tax,
       t01.t01_dcm_tax,
       t01.t01_cum_cma_tax,
       t01.t01_cum_cpp_tax,
       t01.t01_cum_dcm_tax,
       t01.t01_cma_commission,
       t01.t01_cpp_commission,
       t01.t01_dcm_commission,
       t01.t01_cma_cum_commission,
       t01.t01_cpp_cum_commission,
       t01.t01_dcm_cum_commission,
       t01.t01_initial_margin_amount,
       t01.t01_maintain_margin_amount,
       t01.t01_cum_initial_margin_amount,
       t01.t01_cum_maintain_margin_amount,
       CASE
           WHEN t01_instrument_type_code = ''FUT''
           THEN
               t01_cum_quantity * m20.m20_lot_size * t01_avg_price
       END
           AS notional_value,
       m02.m02_code,       
       t01.t01_other_commission,
       t01.t01_other_tax,
       t01_other_cum_commission,
       t01_other_cum_tax,
       t01.t01_bypass_rms_validation,
       t01.bypass_rms_validation
  FROM vw_t01_order_list_base t01
       LEFT JOIN u01_customer u01
           ON t01.t01_customer_id_u01 = u01.u01_id
       LEFT JOIN vw_status_list v01
           ON t01.t01_trade_process_stat_id_v01 = v01.v01_id
       LEFT JOIN v30_order_status v30
           ON t01.t01_status_id_v30 = v30.v30_status_id
       LEFT JOIN u07_trading_account u07
           ON t01.t01_trading_acc_id_u07 = u07.u07_id
       LEFT JOIN m26_executing_broker m26_custody
           ON t01.t01_custodian_id_m26 = m26_custody.m26_id -- LEFT JOIN : For OMS Order Search Custodian Could be -1 When Not Matched
       LEFT JOIN m26_executing_broker m26_broker
           ON t01.t01_exec_broker_id_m26 = m26_broker.m26_id -- LEFT JOIN : For OMS Order Search Custodian Could be -1 When Not Matched
       LEFT JOIN u17_employee u17
           ON t01.t01_dealer_id_u17 = u17.u17_id
       LEFT JOIN m20_symbol m20
           ON m20.m20_id = t01.t01_symbol_id_m20
       LEFT JOIN m02_institute m02
           ON t01.t01_institution_id_m02 = m02.m02_id'
        -- LEFT JOIN : For OMS Order Search Symbol Could be -1 When Not Matched
        || fn_get_trading_acc_filter (ptrading_column         => 'u07_id',
                                      ptab_alies              => 'u07',
                                      puser_id                => puserid,
                                      p_user_filter_enabled   => puserfilter)
        || ' WHERE t01.t01_side IN (1, 2) AND t01_last_updated_date_time BETWEEN TO_DATE ('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'') AND  TO_DATE ( '''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')+ .99999';


    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              NULL,
                              ptorownumber,
                              pfromrownumber);

    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/