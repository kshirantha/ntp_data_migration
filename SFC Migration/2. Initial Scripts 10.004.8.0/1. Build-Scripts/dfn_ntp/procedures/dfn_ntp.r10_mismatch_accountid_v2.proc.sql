CREATE OR REPLACE PROCEDURE dfn_ntp.r10_mismatch_accountid_v2 (
    account_list OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN account_list FOR
        SELECT a.cash_acntid || '_' || a.tenant_code AS cash_acnt_id,
               b.h02_balance - a.net_settle AS current_balance,
               b.h02_blocked + a.cash_block AS current_block,
               b.h02_payable_blocked + a.payable AS current_payable,
               b.h02_receivable_amount + a.receivable AS current_receivable,
               b.h02_open_buy_blocked + a.cash_block
                   AS current_open_buy_block
          --b.h02_balance AS current_balance,
          --b.h02_blocked as current_block,
          --b.h02_payable_blocked AS current_payable,
          --b.h02_receivable_amount AS current_receivable,
          --b.h02_open_buy_blocked AS current_open_buy_block
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
                                      AND audit_side = -1               --?? 2
                                 THEN
                                     audit_net_settle
                                 ELSE
                                     0
                             END)
                             AS receivable,
                         SUM (audit_net_settle) AS net_settle,
                         SUM (audit_cash_block) AS cash_block
                    --SUM(audit_payable) AS payable,
                    --SUM(audit_receivable) AS receivable,
                    --SUM(audit_open_buy_block) AS open_buy_block
                    FROM (  SELECT MAX (a.execid) AS execid,
                                   a.cl_ordid,
                                   MAX (b.cash_acntid) AS cash_acntid,
                                   MAX (b.tenant_code) AS tenant_code,
                                     --SUM(order_net_settle_diff) AS audit_net_settle,
                                     SUM (
                                             a.last_shares
                                           * a.last_price
                                           * b.fx_rate
                                         + b.commission_diff * b.fx_rate
                                         + c.t02_amnt_in_txn_currency)
                                   * (CASE
                                          WHEN MAX (a.side) = 1 THEN 1
                                          ELSE -1
                                      END)
                                       AS audit_net_settle, --move the condition near comm
                                   MIN (cash_block) AS audit_cash_block, --order blockAmount
                                   --SUM(payable_diff) AS audit_payable,
                                   --SUM(receivable_diff) AS audit_receivable,
                                   --MIN(open_buy_block) AS audit_open_buy_block,
                                   --MAX(b.fx_rate) AS audit_fx_rate,
                                   MAX (b.side) AS audit_side,
                                   MAX (b.cash_settlement_date)
                                       AS audit_settle_date
                              FROM r07_fix_log a,
                                   r08_order_audit b,
                                   t02_transaction_log_order_all c
                             WHERE     a.execid = b.execid
                                   AND a.cl_ordid = b.cl_ordid
                                   AND c.t02_cash_acnt_id_u06 = b.cash_acntid
                          GROUP BY a.cl_ordid)
                GROUP BY cash_acntid) a,
               h02_cash_account_summary b
         WHERE a.cash_acntid = b.h02_cash_account_id_u06;
END;
/
/
