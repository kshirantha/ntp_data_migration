CREATE OR REPLACE PROCEDURE dfn_ntp.sp_redist_prnt_algo_ord_genete (
    s t09_txn_single_entry_v3%ROWTYPE)
IS
BEGIN
    /* UPDATE t54_slice_orders t54
        SET t54.t54_last_block_status = s.t09_parent_status_v30,
            t54.t54_ord_qty_sent = s.t09_ord_qty_sent,
            t54.t54_ord_qty_filled = s.t09_algo_parent_cum_qty,
            t54.t54_ord_qty_part_filled = s.t09_last_shares,
            t54.t54_cum_ordnetvalue = s.t09_parent_net_value,
            t54.t54_queued_ord_count = s.t09_queued_ord_count
      WHERE t54.t54_ordid = s.t09_algo_order_ref_t54;
      */

    UPDATE t38_conditional_order t38
       SET t38.t38_condition_status = s.t09_parent_status_v30,
           t38.t38_cum_quantity = s.t09_algo_parent_cum_qty,
           t38.t38_cum_net_value = s.t09_parent_cumord_netvalue,
           t38.t38_cum_netstl = s.t09_parent_cumord_netsettle,
           t38.t38_trig_qty = s.t09_ord_qty_sent,
           t38.t38_trig_ord_count = s.t09_queued_ord_count
     WHERE t38_cond_order_id = s.t09_algo_order_ref_t54;
END; -- Procedure
/