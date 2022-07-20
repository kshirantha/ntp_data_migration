CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_order_list_bp_exceeded
(
    t01_cl_ord_id,
    t01_ord_no,
    t01_orig_cl_ord_id,
    t01_exchange_ord_id,
    v30_description,
    v30_description_lang,
    t01_symbol_id_m20,
    m20_symbol_code,
    order_side,
    t01_ord_type_id_v06,
    v06_description,
    v06_description_lang,
    t01_ord_channel_id_v29,
    v29_description,
    t01_quantity,
    t01_cum_quantity,
    t01_price,
    t01_exchange_code_m01,
    t01_avg_price,
    t01_last_price,
    t01_ord_net_settle,
    u01_customer_no,
    u01_external_ref_no,
    u01_display_name,
    t01_date_time,
    t01_expiry_date,
    t01_settle_currency,
    t01_settle_currency_rate,
    t01_last_updated_date_time,
    t01_dealer_id_u17,
    m26_type,
    custodian_type,
    exec_broker,
    u17_full_name,
    t01_ord_value,
    t01_remote_cl_ord_id,
    t01_remote_orig_cl_ord_id,
    t01_tif_id_v10,
    v10_description,
    t01_institution_id_m02,
    t01_cash_acc_id_u06,
    t01_commission,
    u07_exchange_account_no,
    t01_exec_broker_id_m26,
    u07_external_ref_no,
    u07_id,
    t01_wfa_level,
    t01_date,
    t01_wfa_current_value,
    t01_wfa_expected_value,
    exceeded_value,
    wfa_approved_time,
    wfa_approved_by,
    wfa_reject_reason,
    t01_instrument_type_code
)
AS
    SELECT t01.t01_cl_ord_id,
           t01.t01_ord_no,
           t01.t01_orig_cl_ord_id,
           t01.t01_exchange_ord_id,
           v30.v30_description,
           v30.v30_description_lang,
           t01.t01_symbol_id_m20,
           m20.m20_symbol_code,
           CASE t01.t01_side
               WHEN 1 THEN 'Buy'
               WHEN 2 THEN 'Sell'
               WHEN 3 THEN 'Subscription'
           END
               AS order_side,
           t01.t01_ord_type_id_v06,
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
           t01.t01_ord_channel_id_v29,
           CASE t01_ord_channel_id_v29
               WHEN 0 THEN 'External'
               WHEN 1 THEN 'Web'
               WHEN 4 THEN 'System'
               WHEN 5 THEN 'FIX'
               WHEN 6 THEN 'TWS'
               WHEN 7 THEN 'AT'
               WHEN 9 THEN 'Mobile'
               WHEN 10 THEN 'IVR'
               WHEN 11 THEN 'Applet'
               WHEN 12 THEN 'DT'
               WHEN 14 THEN 'PRO'
               WHEN 15 THEN 'BB'
               WHEN 16 THEN 'iPhone'
               WHEN 17 THEN 'iPad'
               WHEN 18 THEN 'Android'
               WHEN 19 THEN 'ATM'
               WHEN 20 THEN 'LOS'
               WHEN 21 THEN 'Bank IVR'
               WHEN 22 THEN 'Internet'
               WHEN 23 THEN 'PB'
               WHEN 24 THEN 'SELF TRADE'
               WHEN 25 THEN 'Surface'
               WHEN 26 THEN 'RIA NET'
               WHEN 27 THEN 'Android Tab'
               WHEN 28 THEN 'DFN-LSF'
               WHEN 29 THEN 'PRO 10'
               WHEN 30 THEN 'HTML 5 Web'
               WHEN 31 THEN 'HTML5 Android'
               WHEN 32 THEN 'HTML5 iPhone'
               WHEN 33 THEN 'HTML5 iPad'
               WHEN 76 THEN 'AMS'
           END
               AS v29_description,
           t01.t01_quantity,
           t01.t01_cum_quantity,
           t01.t01_price,
           t01.t01_exchange_code_m01,
           t01.t01_avg_price,
           t01.t01_last_price,
           t01.t01_ord_net_settle,
           u01.u01_customer_no,
           u01.u01_external_ref_no,
           u01.u01_display_name,
           t01.t01_date_time,
           t01.t01_expiry_date,
           t01.t01_settle_currency,
           t01.t01_settle_currency_rate,
           t01.t01_last_updated_date_time,
           t01.t01_dealer_id_u17,
           m26.m26_type,
           CASE m26.m26_type
               WHEN 1 THEN 'Broker'
               WHEN 2 THEN 'Custody'
               WHEN 3 THEN 'Broker-Custody'
           END
               AS custodian_type,
           m26.m26_sid AS exec_broker,
           u17.u17_full_name,
           t01.t01_ord_value,
           t01.t01_remote_cl_ord_id,
           t01.t01_remote_orig_cl_ord_id,
           t01.t01_tif_id_v10,
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
           t01.t01_institution_id_m02,
           t01.t01_cash_acc_id_u06,
           t01.t01_commission,
           u07.u07_exchange_account_no,                   --trading account no
           t01.t01_exec_broker_id_m26,
           u07.u07_external_ref_no,                          --security acc no
           u07.u07_id,
           t01.t01_wfa_level,
           t01.t01_date,
           t01.t01_wfa_current_value,
           t01.t01_wfa_expected_value,
           (t01.t01_wfa_expected_value - t01.t01_wfa_current_value)
               AS exceeded_value,
           t22.t22_date_time AS wfa_approved_time,
           emp.u17_full_name AS wfa_approved_by,
           t01.t01_reject_reason AS wfa_reject_reason,
           t01.t01_instrument_type_code
      FROM t01_order_all t01
           LEFT JOIN v30_order_status v30
               ON t01.t01_status_id_v30 = v30.v30_status_id
           LEFT JOIN m20_symbol m20
               ON m20.m20_id = t01.t01_symbol_id_m20 -- LEFT JOIN : For OMS Order Search Symbol Could be -1 When Not Matched
           LEFT JOIN u01_customer u01
               ON t01.t01_customer_id_u01 = u01.u01_id
           LEFT JOIN u17_employee u17
               ON t01.t01_dealer_id_u17 = u17.u17_id
           LEFT JOIN u07_trading_account u07
               ON t01.t01_trading_acc_id_u07 = u07.u07_id
           LEFT JOIN m26_executing_broker m26
               ON t01.t01_custodian_id_m26 = m26.m26_id
           LEFT JOIN t22_order_audit_all t22
               ON t01.t01_cl_ord_id = t22.t22_cl_ord_id_t01
           LEFT JOIN u17_employee emp
               ON t22.t22_performed_by_id_u17 = u17.u17_id
/
