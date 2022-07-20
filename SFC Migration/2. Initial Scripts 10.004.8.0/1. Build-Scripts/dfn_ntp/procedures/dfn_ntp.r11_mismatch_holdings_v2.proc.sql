CREATE OR REPLACE PROCEDURE dfn_ntp.r11_mismatch_holdings_v2 (
    account_list OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN account_list FOR
        SELECT    a.trading_acntid
               || '~'
               || custodian_id
               || '~'
               || b.exchange_code_m01
               || '~'
               || b.symbol_code_m20
               || '~'
               || tenant_code
                   AS tenant_code,
               --SELECT a.trading_acntid || '~' || custodian_code || '~' || symbol_id || '~' || tenant_code  AS trading_acnt_id,
               b.net_holding + a.net_holding AS current_holding,
               b.holding_block AS current_block,
               b.payable_holding + a.payable AS current_payable,
               b.receivable_holding + a.receivable AS current_receivable,
               b.custodian_id_m26 AS custodian,
               b.symbol_id_m20 AS symbolid,
               b.trading_acnt_id_u07 AS tradingid
          -- b.u24_net_holding AS current_holding,
          -- b.u24_holding_block as current_block,
          -- b.u24_payable_holding AS current_payable,
          -- b.u24_receivable_holding AS current_receivable
          FROM (  SELECT trading_acntid,
                         custodian_id,
                         symbol_id,
                         MAX (tenant_code) AS tenant_code,
                         exchange_code,
                         symbol_code,
                         SUM (
                             CASE
                                 WHEN     (  TRUNC (audit_settle_date)
                                           - TRUNC (CURRENT_TIMESTAMP)) < 1
                                      AND audit_side = -1
                                 THEN
                                     audit_net_holding
                                 ELSE
                                     0
                             END)
                             AS payable,
                         SUM (
                             CASE
                                 WHEN     (  TRUNC (audit_settle_date)
                                           - TRUNC (CURRENT_TIMESTAMP)) >= 1
                                      AND audit_side = 1
                                 THEN
                                     audit_net_holding
                                 ELSE
                                     0
                             END)
                             AS receivable,
                         SUM (audit_net_holding) AS net_holding,
                         SUM (audit_holding_block) AS holding_block,
                         SUM (audit_qty) AS cum_qty
                    FROM (  SELECT MAX (a.execid) AS execid,
                                   a.cl_ordid,
                                   MAX (b.trading_account) AS trading_acntid,
                                   MAX (b.custodian_id) AS custodian_id,
                                   MAX (b.symbol_id) AS symbol_id,
                                   MAX (b.tenant_code) AS tenant_code,
                                     SUM (a.last_shares)
                                   * (CASE
                                          WHEN MAX (a.side) = 1 THEN 1
                                          ELSE -1
                                      END)
                                       AS audit_net_holding,
                                   MIN (b.holding_block) AS audit_holding_block,
                                   MAX (b.side) AS audit_side,
                                   MAX (b.cash_settlement_date)
                                       AS audit_settle_date,
                                   MAX (b.cum_qty) AS audit_qty,
                                   MAX (b.exchange_code) AS exchange_code,
                                   MAX (b.symbol_code) AS symbol_code
                              FROM r07_fix_log a, r08_order_audit b
                             WHERE     a.execid = b.execid
                                   AND a.cl_ordid = b.cl_ordid
                          GROUP BY a.cl_ordid)
                GROUP BY trading_acntid,
                         custodian_id,
                         symbol_id,
                         exchange_code,
                         symbol_code) a,
               r24_holding_account b
         WHERE     a.trading_acntid = b.trading_acnt_id_u07
               AND b.exchange_code_m01 = a.exchange_code
               AND b.symbol_code_m20 = a.symbol_code
               AND b.custodian_id_m26 = a.custodian_id;
END;
/
/
