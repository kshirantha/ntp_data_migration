CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t01_order_summary_daily
(
    t01_ord_no,
    t01_cl_ord_id,
    t02_txn_time,
    t01_ord_type_id_v06,
    v06_description_1,
    t01_side,
    t01_side_description,
    t01_ord_channel_id_v29,
    t01_expiry_date,
    t02_last_shares,
    t02_last_price,
    t01_tif_id_v10,
    v10_description,
    t01_min_quantity,
    t02_ord_value_adjst,
    t02_amnt_in_stl_currency,
    t01_status_id_v30,
    v30_description,
    t01_reject_reason,
    t01_db_created_date,
    t01_institution_id_m02,
    t01_dealer_id_u17,
    t02_exg_commission,
    t02_commission_adjst,
    t02_cash_settle_date,
    u06_external_ref_no,
    u01_external_ref_no,
    t01_symbol_code_m20,
    u07_display_name,
    t01_avgcost,
    t02_custodian_id_m26,
    t01_remote_cl_ord_id
)
AS
    SELECT t01.t01_ord_no,
           t01.t01_cl_ord_id,
           t02.t02_txn_time,
           t01.t01_ord_type_id_v06,
           v06.v06_description_1,
           t01.t01_side,
           CASE WHEN t01_side = 1 THEN 'Buy' ELSE 'Sell' END
               AS t01_side_description,
           t01.t01_ord_channel_id_v29,
           t01.t01_expiry_date,
           t02.t02_last_shares,
           t02.t02_last_price,
           t01.t01_tif_id_v10,
           v10.v10_description,
           t01.t01_min_quantity,
           t02.t02_ord_value_adjst,
           t02.t02_amnt_in_stl_currency,
           t01.t01_status_id_v30,
           v30.v30_description,
           t01.t01_reject_reason,
           t01_db_created_date,
           t01.t01_institution_id_m02,
           t01_dealer_id_u17,
           t02.t02_exg_commission,
           t02.t02_commission_adjst,
           t02.t02_cash_settle_date,
           u06_external_ref_no,
           u01.u01_external_ref_no,
           t01.t01_symbol_code_m20,
           u07.u07_display_name,
           ABS (t01.t01_cum_net_value) / t01.t01_cum_quantity AS t01_avgcost,
           t02.t02_custodian_id_m26,
           t01.t01_remote_cl_ord_id
      FROM (  SELECT t02.t02_order_no,
                     MAX (t02.t02_txn_time) AS t02_txn_time,
                     SUM (t02.t02_last_shares) AS t02_last_shares,
                       ABS (SUM (t02.t02_ord_value_adjst))
                     / SUM (t02.t02_last_shares)
                         AS t02_last_price,
                     SUM (t02.t02_ord_value_adjst) AS t02_ord_value_adjst,
                     SUM (t02.t02_amnt_in_stl_currency)
                         AS t02_amnt_in_stl_currency,
                     SUM (t02.t02_exg_commission) AS t02_exg_commission,
                     SUM (t02.t02_commission_adjst) AS t02_commission_adjst,
                     MIN (t02.t02_cash_settle_date) AS t02_cash_settle_date,
                     t02.t02_custodian_id_m26
                FROM t02_transaction_log t02
               WHERE     t02.t02_txn_code IN ('STLBUY', 'STLSEL')
                     AND t02_last_shares > 0
                     AND t02_txn_entry_status = 0
            GROUP BY t02.t02_order_no,
                     TRUNC (t02.t02_txn_time),
                     t02.t02_custodian_id_m26) t02
           JOIN t01_order t01
               ON t02.t02_order_no = t01.t01_ord_no
           JOIN u07_trading_account u07
               ON t01.t01_trading_acc_id_u07 = u07.u07_id
           JOIN u06_cash_account u06
               ON u06.u06_id = u07.u07_cash_account_id_u06
           JOIN u01_customer u01
               ON u01.u01_id = u06.u06_customer_id_u01
           JOIN v06_order_type v06
               ON t01.t01_ord_type_id_v06 = v06.v06_type_id
           JOIN v10_tif v10
               ON t01.t01_tif_id_v10 = v10.v10_id
           JOIN v30_order_status v30
               ON     t01.t01_status_id_v30 = v30.v30_status_id
                  AND t01.t01_status_id_v30 IN ('1', '2', 'q', 'r', '5')
/