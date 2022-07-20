CREATE OR REPLACE PROCEDURE dfn_ntp.r10_mismatch_accountid (
    account_list OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN account_list FOR
        SELECT a.cash_acntid || '_' || a.tenant_code AS cash_acnt_id,
               b.balance - a.net_settle AS current_balance,
               b.blocked + a.cash_block AS current_block,
               b.payable_blocked + a.payable AS current_payable,
               b.receivable_amount + a.receivable AS current_receivable,
               b.open_buy_blocked + a.cash_block AS current_open_buy_block
          FROM (  SELECT cash_acntid,
                         MAX (tenant_code) AS tenant_code,
                         SUM (
                               audit_net_settle
                             * CASE WHEN audit_side = 1 THEN 1 ELSE -1 END)
                             AS net_settle_wrong,
                         SUM (
                             CASE
                                 WHEN     (  TRUNC (audit_settle_date)
                                           - TRUNC (CURRENT_TIMESTAMP)) >= 1
                                      AND audit_side = 1
                                 THEN
                                     audit_net_settle
                                 ELSE
                                     0
                             END)
                             AS payable,
                         SUM (
                             CASE
                                 WHEN     (  TRUNC (audit_settle_date)
                                           - TRUNC (CURRENT_TIMESTAMP)) >= 1
                                      AND audit_side = -1
                                 THEN
                                     audit_net_settle
                                 ELSE
                                     0
                             END)
                             AS receivable,
                         SUM (audit_net_settle) AS net_settle,
                         SUM (audit_cash_block) AS cash_block
                    FROM (  SELECT MAX (a.execid) AS execid,
                                   a.cl_ordid,
                                   MAX (b.cash_acntid) AS cash_acntid,
                                   MAX (b.tenant_code) AS tenant_code,
                                     SUM (
                                             b.last_shares
                                           * b.last_price
                                           * b.fx_rate
                                         + b.commission_diff * b.fx_rate
                                         + b.broker_tax
                                         + b.exchange_tax)
                                   * (CASE
                                          WHEN MAX (a.side) = 1 THEN 1
                                          ELSE -1
                                      END)
                                       AS audit_net_settle,
                                   MIN (cash_block) AS audit_cash_block,
                                   MAX (b.side) AS audit_side,
                                   MAX (b.cash_settlement_date)
                                       AS audit_settle_date
                              FROM r07_fix_log a, r08_order_audit b
                             WHERE     a.execid = b.execid
                                   AND a.cl_ordid = b.cl_ordid
                          GROUP BY a.cl_ordid)
                GROUP BY cash_acntid) a,
               r06_cash_account b
         WHERE a.cash_acntid = b.cash_account_id_u06;
END;
/
/
