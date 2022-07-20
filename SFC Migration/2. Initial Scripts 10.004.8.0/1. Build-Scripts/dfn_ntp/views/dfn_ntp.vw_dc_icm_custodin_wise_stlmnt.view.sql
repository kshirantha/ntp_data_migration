CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_dc_icm_custodin_wise_stlmnt
(
    inst_id,
    custodian_name,
    net_order_value,
    t02_settle_currency,
    tot_commission,
    exchange_commission,
    other_commission,
    broker_commission,
    settlment_date,
    buy_settle,
    sel_settle,
    buy_trades,
    sel_trades,
    gross_commission,
    receivable_from_custodian,
    t02_exchange,
    trimdate,
    net_settle,
    no_of_trades,
    turnover,
    net_position,
    no_of_orders,
    exchange_settlement,
    broker_vat,
    exchange_vat,
    t02_custodian_id_m26
)
AS
      SELECT t02.t02_inst_id_m02 AS inst_id,
             MAX (m26.m26_name) AS custodian_name,
             SUM (ABS (t02.t02_ord_value_adjst)) AS net_order_value,
             t02.t02_settle_currency,
             SUM (t02.t02_commission_adjst) AS tot_commission,
             SUM (t02.t02_exg_commission) AS exchange_commission,
             0 AS other_commission,
             (SUM (t02.t02_commission_adjst) - SUM (t02.t02_exg_commission))
                 AS broker_commission,
             TRUNC (
                 MAX (NVL (t02.t02_cash_settle_date, t02.t02_create_datetime)))
                 AS settlment_date,
             SUM (
                 (CASE
                      WHEN t02.t02_txn_code IN ('STLBUY')
                      THEN
                          ABS (t02.t02_ord_value_adjst)
                      ELSE
                          0
                  END))
                 AS buy_settle,
             SUM (
                 (CASE
                      WHEN t02.t02_txn_code IN ('STLSEL')
                      THEN
                          t02.t02_ord_value_adjst
                      ELSE
                          0
                  END))
                 AS sel_settle,
             SUM (
                 (CASE WHEN t02.t02_txn_code IN ('STLBUY') THEN 1 ELSE 0 END))
                 AS buy_trades,
             SUM (
                 (CASE WHEN t02.t02_txn_code IN ('STLSEL') THEN 1 ELSE 0 END))
                 AS sel_trades,
             (SUM (t02.t02_commission_adjst) - SUM (t02.t02_discount))
                 AS gross_commission,
             SUM (t02.t02_commission_adjst) AS receivable_from_custodian,
             t02.t02_exchange_code_m01 AS t02_exchange,
             TRUNC (t02.t02_create_date) AS trimdate,
             SUM (t02.t02_ord_value_adjst) AS net_settle,
             COUNT (t02.t02_cliordid_t01) AS no_of_trades,
             SUM (ABS (t02.t02_ord_value_adjst)) AS turnover,
             SUM (t02.t02_amnt_in_txn_currency + t02.t02_commission_adjst)
                 AS net_position,
             COUNT (DISTINCT t02.t02_cliordid_t01) AS no_of_orders,
             SUM (t02.t02_amnt_in_txn_currency) - SUM (t02.t02_exg_commission)
                 AS exchange_settlement,
             SUM (t02.t02_broker_tax) AS broker_vat,
             SUM (t02.t02_exchange_tax) AS exchange_vat,
             t02.t02_custodian_id_m26
        FROM t02_transaction_log t02, m26_executing_broker m26
       WHERE     t02.t02_custodian_type_v01 = 1
             AND t02_last_shares > 0
             AND t02.t02_txn_code IN ('STLBUY', 'STLSEL')
             AND t02_custodian_id_m26 = m26.m26_id
             AND t02_txn_entry_status = 0
    GROUP BY TRUNC (t02.t02_create_date),
             t02.t02_exchange_code_m01,
             t02.t02_inst_id_m02,
             t02_settle_currency,
             t02_custodian_id_m26
/
