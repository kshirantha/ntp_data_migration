CREATE OR REPLACE PROCEDURE dfn_ntp.r12_mismatch_orderid (
    orderid_list OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN orderid_list FOR
          SELECT cl_ordid
            FROM (  SELECT MAX (a.execid) AS execid,
                           a.cl_ordid,
                           SUM (a.last_shares) AS fix_cum_qty,
                           MAX (b.cum_qty) AS audit_cum_qty,
                           SUM (a.last_shares * a.last_price)
                               AS fix_cum_order_value,
                           MAX (b.cum_order_value) AS audit_cum_order_value,
                             SUM (
                                 a.last_shares * a.last_price + b.commission_diff)
                           * (CASE WHEN MAX (a.side) = 1 THEN 1 ELSE -1 END)
                               AS fix_cum_order_net_value,
                           MAX (b.cum_order_net_value)
                               AS audit_cum_order_net_value,
                             SUM (
                                 ROUND (
                                     (  a.last_shares * a.last_price * b.fx_rate
                                      + b.commission_diff * b.fx_rate),
                                     8))
                           * (CASE WHEN MAX (a.side) = 1 THEN 1 ELSE -1 END)
                               AS fix_cum_order_net_settle,
                           MAX (b.cum_order_net_settle)
                               AS audit_cum_order_net_settle,
                           MIN (a.leaves_qty) AS fix_leaves_qty,
                           MAX (a.transact_time) AS fix_transact_time,
                           MIN (b.leaves_qty) AS audit_leaves_qty,
                           MAX (b.cum_commission) AS audit_cum_commission,
                           MAX (b.fx_rate) AS audit_fx_rate
                      FROM r07_fix_log a, r08_order_audit b
                     WHERE a.execid = b.execid AND a.cl_ordid = b.cl_ordid
                  GROUP BY a.cl_ordid)
           WHERE    fix_cum_qty != audit_cum_qty
                 OR fix_leaves_qty != audit_leaves_qty
                 OR ROUND (fix_cum_order_value, 8) !=
                        ROUND (audit_cum_order_value, 8)
                 OR ROUND (fix_cum_order_net_value, 8) !=
                        ROUND (audit_cum_order_net_value, 8)
                 OR ROUND (fix_cum_order_net_settle, 8) !=
                        ROUND (audit_cum_order_net_settle, 8)
        ORDER BY cl_ordid;
END;
/