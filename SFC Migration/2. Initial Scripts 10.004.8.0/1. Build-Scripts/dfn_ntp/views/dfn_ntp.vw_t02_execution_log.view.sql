CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t02_execution_log
(
    t02_customer_no,
    t02_customer_id_u01,
    t02_order_exec_id,
    t02_cliordid_t01,
    t02_ord_status_v30,
    t02_order_status,
    t02_exchange_code_m01,
    t02_symbol_code_m20,
    t02_side_desc,
    t02_side,
    t02_timestamp_display,
    t02_last_shares,
    t02_last_price,
    t02_amnt_in_txn_currency,
    t02_cum_commission,
    t02_create_datetime,
    t02_create_date,
    m20_short_description,
    t02_inst_id_m02,
    t02_trd_acnt_id_u07,
    t02_cum_qty,
    t02_leaves_qty,
    t02_ordqty,
    t01_expiry_date,
    t02_order_no,
    t02_cash_settle_date,
    t02_holding_settle_date,
    t02_broker_tax,
    t02_exchange_tax,
    t02_cumord_value,
    t02_cumord_netvalue,
    t02_cumord_netsettle,
    fail_management_status_desc,
    t02_trade_match_id,
    t02_commission_adjst,
    t02_last_db_seq_id,
    t02_txn_entry_status,
    t02_ord_value_adjst,
    t02_exg_commission,
    t02_trade_confirm_no,
    t01_last_updated_date_time,
    t02_fx_rate
)
AS
    SELECT t02.t02_customer_no,
           t02.t02_customer_id_u01,
           t02.t02_order_exec_id,
           t02.t02_cliordid_t01,
           t02.t02_ord_status_v30,
           v30.v30_description AS t02_order_status,
           t02.t02_exchange_code_m01,
           t02.t02_symbol_code_m20,
           DECODE (t02.t02_side,  1, 'Buy',  2, 'Sell') AS t02_side_desc,
           t02.t02_side,
           TO_CHAR (t02.t02_create_datetime, ' MM/DD/YYYY HH24:MI:SS')
               AS t02_timestamp_display,
           t02.t02_last_shares,
           t02.t02_last_price,
           t02.t02_amnt_in_txn_currency,
           t02.t02_cum_commission,
           t02.t02_create_datetime,
           t02.t02_create_date,
           m20.m20_short_description,
           t02.t02_inst_id_m02,
           t02.t02_trd_acnt_id_u07,
           t02.t02_cum_qty,
           t02.t02_leaves_qty,
           t02.t02_ordqty,
           t01.t01_expiry_date,
           t02.t02_order_no,
           t02.t02_cash_settle_date,
           t02.t02_holding_settle_date,
           t02.t02_broker_tax,
           t02.t02_exchange_tax,
           t02.t02_cumord_value,
           t02.t02_cumord_netvalue,
           t02.t02_cumord_netsettle,
           CASE
               WHEN t02.t02_fail_management_status = 1
               THEN
                   'ICM Reject'
               WHEN t02.t02_fail_management_status = 2
               THEN
                   'ICM Settle'
               WHEN t02.t02_fail_management_status = 3
               THEN
                   'Buy In'
               WHEN t02.t02_fail_management_status = 4
               THEN
                   'ICM Fail Chain'
               WHEN t02.t02_fail_management_status = 5
               THEN
                   'ICM Recapture'
               WHEN t02.t02_fail_management_status = 6
               THEN
                   'Partially Settled'
           END
               AS fail_management_status_desc,
           t02.t02_trade_match_id,
           t02.t02_commission_adjst,
           t02.t02_last_db_seq_id,
           t02.t02_txn_entry_status,
           ABS (t02.t02_ord_value_adjst),
           t02.t02_exg_commission,
           t02.t02_trade_confirm_no,
           TO_CHAR (t01.t01_last_updated_date_time, 'MM/DD/YYYY HH24:MI:SS')
               AS t01_last_updated_date_time,
           t02.t02_fx_rate
      FROM t02_transaction_log t02
           JOIN m20_symbol m20
               ON t02.t02_symbol_id_m20 = m20.m20_id
           JOIN t01_order t01
               ON t01_cl_ord_id = t02_cliordid_t01
           JOIN v30_order_status v30
               ON t02.t02_ord_status_v30 = v30.v30_status_id
     WHERE     t02.t02_update_type = 1
           AND t02.t02_last_shares > 0
           AND t02.t02_txn_entry_status = 0
/