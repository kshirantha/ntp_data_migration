DECLARE
    l_count   NUMBER := 0;
    l_table   VARCHAR2 (50) := 'general_verification';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 1)
    THEN
        EXECUTE IMMEDIATE 'DROP TABLE ' || l_table || '';
    END IF;

    EXECUTE IMMEDIATE
           'CREATE TABLE '
        || l_table
        || ' (
    
    source_table   VARCHAR2 (100 BYTE),
    target_table   VARCHAR2 (100 BYTE),    
    difference     VARCHAR2 (1000 BYTE)    
    )';
END;
/

-- T05_CASH_ACCOUNT_LOG Verification

BEGIN
    FOR i
        IN (SELECT *
              FROM (SELECT map15_ntp_code,
                           t02_txn_code,
                           sfc.t05_amount,
                           ntp.t02_ord_value_adjst,
                           ntp.t02_ord_value_adjst - sfc.t05_amount
                               AS amount_diff,
                           sfc.t05_amt_in_trans_currency,
                           ntp.t02_amnt_in_txn_currency,
                             ntp.t02_amnt_in_txn_currency
                           - sfc.t05_amt_in_trans_currency
                               AS txn_amount_diff,
                           sfc.t05_amt_in_settle_currency,
                           ntp.t02_amnt_in_stl_currency,
                             ntp.t02_amnt_in_stl_currency
                           - sfc.t05_amt_in_settle_currency
                               AS stl_amount_diff,
                           sfc.t05_commission,
                           ntp.t02_commission_adjst,
                           ntp.t02_commission_adjst - sfc.t05_commission
                               AS commission_diff,
                           sfc.t05_exg_commission,
                           ntp.t02_exg_commission,
                           ntp.t02_exg_commission - sfc.t05_exg_commission
                               AS exg_commission_diff,
                           sfc.t05_commission_discount,
                           ntp.t02_discount,
                           ntp.t02_discount - sfc.t05_commission_discount
                               AS disc_commission_diff,
                           sfc.t05_broker_vat,
                           ntp.t02_broker_tax,
                           ntp.t02_broker_tax - sfc.t05_broker_vat
                               AS broker_tax_diff,
                           sfc.t05_exchange_vat,
                           ntp.t02_exchange_tax,
                           ntp.t02_exchange_tax - sfc.t05_exchange_vat
                               AS exg_tax_diff,
                           sfc.t05_profitloss,
                           ntp.t02_gainloss,
                           ntp.t02_gainloss - sfc.t05_profitloss
                               AS gain_loss_diff,
                           sfc.sfc_total,
                           ntp.ntp_total,
                           ntp.ntp_total - sfc.sfc_total AS count_diff
                      FROM     (  SELECT map15.map15_ntp_code,
                                         SUM (
                                             CASE
                                                 WHEN t05.t05_code = 'ICMR'
                                                 THEN
                                                     CASE
                                                         WHEN map15.map15_ntp_code =
                                                                  'CUDYORDFEE'
                                                         THEN
                                                             t05.t05_exchange_settle_amount
                                                         WHEN map15.map15_ntp_code =
                                                                  'CUDYHLDFEE'
                                                         THEN
                                                               t05.t05_amount -- Segregating as T05_AMOUNT & T05_AMT_IN_TRANS_CURRENCY gets Same Value in This Scenario
                                                             - t05.t05_exchange_settle_amount
                                                     END
                                                 ELSE
                                                     CASE
                                                         WHEN     t05.u06_is_custodian_account
                                                                      IS NOT NULL
                                                              AND t05.u06_is_custodian_account <>
                                                                      0
                                                         THEN
                                                             t05.t05_exchange_settle_amount
                                                         ELSE
                                                             t05.t05_amount
                                                     END
                                             END)
                                             AS t05_amount,
                                         SUM (
                                             CASE
                                                 WHEN map15.map15_ntp_code =
                                                          'CUDYORDFEE'
                                                 THEN
                                                     t05.t05_exchange_settle_amount
                                                 WHEN map15.map15_ntp_code =
                                                          'CUDYHLDFEE'
                                                 THEN
                                                       t05.t05_amt_in_trans_currency -- Segregating as T05_AMOUNT & T05_AMT_IN_TRANS_CURRENCY gets Same Value in This Scenario
                                                     - t05.t05_exchange_settle_amount
                                                 ELSE
                                                     t05.t05_amt_in_trans_currency
                                             END)
                                             AS t05_amt_in_trans_currency,
                                         SUM (
                                             CASE
                                                 WHEN map15.map15_ntp_code =
                                                          'CUDYORDFEE'
                                                 THEN
                                                     t05.t05_exchange_settle_amount
                                                 WHEN map15.map15_ntp_code =
                                                          'CUDYHLDFEE'
                                                 THEN
                                                       t05.t05_amt_in_settle_currency -- Segregating as T05_AMOUNT & T05_AMT_IN_SETTLE_CURRENCY gets Same Value in This Scenario
                                                     - t05.t05_exchange_settle_amount
                                                 ELSE
                                                     t05.t05_amt_in_settle_currency
                                             END)
                                             AS t05_amt_in_settle_currency,
                                         SUM (t05.t05_commission)
                                             AS t05_commission,
                                         SUM (t05.t05_exg_commission)
                                             AS t05_exg_commission,
                                         SUM (t05.t05_commission_discount)
                                             AS t05_commission_discount,
                                         SUM (t05.t05_broker_vat)
                                             AS t05_broker_vat,
                                         SUM (t05.t05_exchange_vat)
                                             AS t05_exchange_vat,
                                         SUM (t05.t05_profitloss)
                                             AS t05_profitloss,
                                         COUNT (*) AS sfc_total
                                    FROM (SELECT txn.t05_id,
                                                 txn.t05_inst_id,
                                                 txn.t05_cash_account_id,
                                                 txn.t05_amount,
                                                 txn.t05_exchange_settle_amount,
                                                 txn.t05_amt_in_trans_currency,
                                                 txn.t05_amt_in_settle_currency,
                                                 txn.t05_commission,
                                                 txn.t05_exg_commission,
                                                 txn.t05_commission_discount,
                                                 txn.t05_broker_vat,
                                                 txn.t05_exchange_vat,
                                                 txn.t05_profitloss,
                                                 txn.u06_is_custodian_account,
                                                 CASE
                                                     WHEN txn.t05_code =
                                                              'TRNFEE'
                                                     THEN
                                                         CASE
                                                             WHEN txn.m264_type
                                                                      IS NOT NULL
                                                             THEN
                                                                 CASE
                                                                     WHEN txn.m264_type =
                                                                              2
                                                                     THEN
                                                                         'CTRFEE_BNK'
                                                                     WHEN txn.m264_type =
                                                                              3
                                                                     THEN
                                                                         'CTRFEE_OTR'
                                                                     ELSE
                                                                         'CTRFEE_INT'
                                                                 END
                                                             ELSE
                                                                 CASE
                                                                     WHEN txn.t05_reference_doc_narration LIKE
                                                                              '%: SA%'
                                                                     THEN
                                                                         'CTRFEE_BNK'
                                                                     ELSE
                                                                         'CTRFEE_INT'
                                                                 END
                                                         END
                                                     ELSE
                                                         txn.t05_code
                                                 END
                                                     AS t05_code,
                                                 CASE
                                                     WHEN txn.t05_code IN
                                                              ('STLBUY',
                                                               'STLSEL',
                                                               'STKSUB',
                                                               'REVBUY',
                                                               'REVSEL',
                                                               'REVSUB')
                                                     THEN
                                                         1
                                                     ELSE
                                                         2
                                                 END
                                                     AS update_type
                                            FROM ( -- None INDCH Transactions
                                                  SELECT t05.t05_id,
                                                         t05.t05_inst_id,
                                                         t05.t05_cash_account_id,
                                                         t05.t05_amount,
                                                         t05.t05_exchange_settle_amount,
                                                         t05.t05_amt_in_trans_currency,
                                                         t05.t05_amt_in_settle_currency,
                                                         t05.t05_commission,
                                                         t05.t05_exg_commission,
                                                         t05.t05_commission_discount,
                                                         t05.t05_broker_vat,
                                                         t05.t05_exchange_vat,
                                                         t05.t05_profitloss,
                                                         u06.u06_is_custodian_account,
                                                         t05.t05_code,
                                                         m264.m264_type,
                                                         t05.t05_reference_doc_narration
                                                    FROM mubasher_oms.t05_cash_account_log@mubasher_db_link t05,
                                                         (  SELECT t05_orderno
                                                              FROM mubasher_oms.t05_cash_account_log@mubasher_db_link
                                                             WHERE t05_code =
                                                                       'INDCH'
                                                          GROUP BY t05_orderno) t05_indch,
                                                         mubasher_oms.u06_routing_accounts@mubasher_db_link u06,
                                                         mubasher_oms.t12_pending_cash@mubasher_db_link t12,
                                                         mubasher_oms.m264_beneficiary_accounts@mubasher_db_link m264
                                                   WHERE     t05.t05_orderno =
                                                                 t05_indch.t05_orderno(+)
                                                         AND t05_indch.t05_orderno
                                                                 IS NULL
                                                         AND t05.t05_exchange =
                                                                 u06.u06_exchange(+)
                                                         AND t05.t05_security_ac_id =
                                                                 u06.u06_security_ac_id(+)
                                                         AND t05.t05_cash_txn_ref =
                                                                 t12.t12_id(+)
                                                         AND t12.t12_benificiary_id =
                                                                 m264.m264_id(+)
                                                  UNION ALL
                                                  -- Capturing INDCH Transactions as Single Transaction
                                                  SELECT t05.t05_id,
                                                         t05.t05_inst_id,
                                                         t05.t05_cash_account_id,
                                                         t05.t05_amount,
                                                         t05.t05_exchange_settle_amount,
                                                         t05.t05_amt_in_trans_currency,
                                                         t05.t05_amt_in_settle_currency,
                                                         t05.t05_commission,
                                                         t05.t05_exg_commission,
                                                         t05.t05_commission_discount,
                                                         t05.t05_broker_vat,
                                                         t05.t05_exchange_vat,
                                                         t05.t05_profitloss,
                                                         u06.u06_is_custodian_account,
                                                         t05.t05_code,
                                                         m264.m264_type,
                                                         t05.t05_reference_doc_narration
                                                    FROM (  SELECT MIN (t05_id)
                                                                       AS t05_id,
                                                                   MIN (
                                                                       t05_inst_id)
                                                                       AS t05_inst_id,
                                                                   MIN (
                                                                       t05_cash_account_id)
                                                                       AS t05_cash_account_id,
                                                                   SUM (
                                                                       t05_amount)
                                                                       AS t05_amount,
                                                                   SUM (
                                                                       t05_exchange_settle_amount)
                                                                       AS t05_exchange_settle_amount,
                                                                   SUM (
                                                                       t05_amt_in_trans_currency)
                                                                       AS t05_amt_in_trans_currency,
                                                                   SUM (
                                                                       t05_amt_in_settle_currency)
                                                                       AS t05_amt_in_settle_currency,
                                                                   SUM (
                                                                       t05_commission)
                                                                       AS t05_commission,
                                                                   SUM (
                                                                       t05_exg_commission)
                                                                       AS t05_exg_commission,
                                                                   0
                                                                       AS t05_commission_discount,
                                                                   0
                                                                       AS t05_broker_vat,
                                                                   0
                                                                       AS t05_exchange_vat,
                                                                   SUM (
                                                                       t05_profitloss)
                                                                       AS t05_profitloss,
                                                                   MIN (
                                                                       t05_code)
                                                                       AS t05_code,
                                                                   MIN (
                                                                       t05_reference_doc_narration)
                                                                       AS t05_reference_doc_narration,
                                                                   MIN (
                                                                       t05_cash_txn_ref)
                                                                       AS t05_cash_txn_ref,
                                                                   MIN (
                                                                       t05_security_ac_id)
                                                                       AS t05_security_ac_id,
                                                                   MIN (
                                                                       t05_exchange)
                                                                       AS t05_exchange
                                                              FROM (SELECT t05.t05_id,
                                                                           MIN (
                                                                               t05.t05_inst_id)
                                                                           KEEP (DENSE_RANK FIRST ORDER BY
                                                                                                      t05.t05_id)
                                                                           OVER (
                                                                               PARTITION BY t05.t05_orderno)
                                                                               AS t05_inst_id,
                                                                           MIN (
                                                                               t05.t05_cash_account_id)
                                                                           KEEP (DENSE_RANK FIRST ORDER BY
                                                                                                      t05.t05_id)
                                                                           OVER (
                                                                               PARTITION BY t05.t05_orderno)
                                                                               AS t05_cash_account_id,
                                                                           t05_amount,
                                                                           t05_exchange_settle_amount,
                                                                           t05_amt_in_trans_currency,
                                                                           t05_amt_in_settle_currency,
                                                                           t05_commission,
                                                                           t05_exg_commission,
                                                                           t05_profitloss,
                                                                           MIN (
                                                                               t05.t05_code_min)
                                                                           KEEP (DENSE_RANK FIRST ORDER BY
                                                                                                      t05.t05_code_min)
                                                                           OVER (
                                                                               PARTITION BY t05.t05_orderno)
                                                                               AS t05_code,
                                                                           MIN (
                                                                               t05.t05_reference_doc_narration)
                                                                           KEEP (DENSE_RANK FIRST ORDER BY
                                                                                                      t05.t05_id)
                                                                           OVER (
                                                                               PARTITION BY t05.t05_orderno)
                                                                               AS t05_reference_doc_narration,
                                                                           t05.t05_orderno,
                                                                           MIN (
                                                                               t05.t05_cash_txn_ref)
                                                                           KEEP (DENSE_RANK FIRST ORDER BY
                                                                                                      t05.t05_id)
                                                                           OVER (
                                                                               PARTITION BY t05.t05_orderno)
                                                                               AS t05_cash_txn_ref,
                                                                           MIN (
                                                                               t05.t05_security_ac_id)
                                                                           KEEP (DENSE_RANK FIRST ORDER BY
                                                                                                      t05.t05_id)
                                                                           OVER (
                                                                               PARTITION BY t05.t05_orderno)
                                                                               AS t05_security_ac_id,
                                                                           MIN (
                                                                               t05.t05_exchange)
                                                                           KEEP (DENSE_RANK FIRST ORDER BY
                                                                                                      t05.t05_id)
                                                                           OVER (
                                                                               PARTITION BY t05.t05_orderno)
                                                                               AS t05_exchange
                                                                      FROM (SELECT t05.*,
                                                                                   CASE
                                                                                       WHEN MIN (
                                                                                                t05_code)
                                                                                            KEEP (DENSE_RANK FIRST ORDER BY
                                                                                                                       t05_id)
                                                                                            OVER (
                                                                                                PARTITION BY t05_orderno) IN
                                                                                                ('STLBUY',
                                                                                                 'STLSEL')
                                                                                       THEN
                                                                                           MIN (
                                                                                               t05_code)
                                                                                           KEEP (DENSE_RANK FIRST ORDER BY
                                                                                                                      t05_id)
                                                                                           OVER (
                                                                                               PARTITION BY t05_orderno)
                                                                                       ELSE
                                                                                           MAX (
                                                                                               t05_code)
                                                                                           KEEP (DENSE_RANK FIRST ORDER BY
                                                                                                                      t05_id DESC)
                                                                                           OVER (
                                                                                               PARTITION BY t05_orderno)
                                                                                   END
                                                                                       AS t05_code_min
                                                                              FROM mubasher_oms.t05_cash_account_log@mubasher_db_link t05) t05,
                                                                           (  SELECT t05_orderno
                                                                                FROM mubasher_oms.t05_cash_account_log@mubasher_db_link
                                                                               WHERE t05_code =
                                                                                         'INDCH'
                                                                            GROUP BY t05_orderno) t05_indch
                                                                     WHERE t05.t05_orderno =
                                                                               t05_indch.t05_orderno)
                                                          GROUP BY t05_orderno) t05,
                                                         mubasher_oms.u06_routing_accounts@mubasher_db_link u06,
                                                         mubasher_oms.t12_pending_cash@mubasher_db_link t12,
                                                         mubasher_oms.m264_beneficiary_accounts@mubasher_db_link m264
                                                   WHERE     t05.t05_exchange =
                                                                 u06.u06_exchange(+)
                                                         AND t05.t05_security_ac_id =
                                                                 u06.u06_security_ac_id(+)
                                                         AND t05.t05_cash_txn_ref =
                                                                 t12.t12_id(+)
                                                         AND t12.t12_benificiary_id =
                                                                 m264.m264_id(+)) txn) t05,
                                         mubasher_oms.t03_cash_account@mubasher_db_link t03,
                                         mubasher_oms.t11_executed_orders@mubasher_db_link t11,
                                         u06_cash_account_mappings u06_map,
                                         u01_customer_mappings u01_map,
                                         (SELECT *
                                            FROM (SELECT map15_oms_code,
                                                         map15_ntp_code
                                                    FROM map15_transaction_codes_m97
                                                  UNION
                                                  SELECT 'CTRFEE_INT',
                                                         'CTRFEE_INT'
                                                    FROM DUAL
                                                  UNION
                                                  SELECT 'CTRFEE_BNK',
                                                         'CTRFEE_BNK'
                                                    FROM DUAL
                                                  UNION
                                                  SELECT 'CTRFEE_OTR',
                                                         'CTRFEE_OTR'
                                                    FROM DUAL)) map15
                                   WHERE     t05.t05_inst_id IN
                                                 (SELECT m05_branch_id
                                                    FROM mubasher_oms.m05_branches@mubasher_db_link
                                                   WHERE m05_branch_id > 0)
                                         AND t05.t05_id =
                                                 t11.t11_t05_exec_id(+)
                                         /* Discussed to Skip the Validation
                                         AND (     t05.update_type = 1
                                                  AND t11.t11_exec_id
                                                          IS NOT NULL)
                                              OR t05.update_type = 2)
                                          */
                                         AND t05.update_type IN (1, 2)
                                         AND t05.t05_cash_account_id =
                                                 t03.t03_account_id
                                         AND t05.t05_cash_account_id =
                                                 u06_map.old_cash_account_id
                                         AND t03.t03_profile_id =
                                                 u01_map.old_customer_id
                                         AND t05_code = map15.map15_oms_code
                                -- Validations Added to Skip Not Migrated Records
                                GROUP BY map15.map15_ntp_code) sfc
                           LEFT JOIN
                               (  SELECT t02.t02_txn_code,
                                         SUM (t02.t02_ord_value_adjst)
                                             AS t02_ord_value_adjst,
                                         SUM (t02.t02_amnt_in_txn_currency)
                                             AS t02_amnt_in_txn_currency,
                                         SUM (t02.t02_amnt_in_stl_currency)
                                             AS t02_amnt_in_stl_currency,
                                         SUM (t02.t02_commission_adjst)
                                             AS t02_commission_adjst,
                                         SUM (t02.t02_exg_commission)
                                             AS t02_exg_commission,
                                         SUM (t02.t02_discount)
                                             AS t02_discount,
                                         SUM (t02.t02_broker_tax)
                                             AS t02_broker_tax,
                                         SUM (t02.t02_exchange_tax)
                                             AS t02_exchange_tax,
                                         SUM (t02.t02_gainloss)
                                             AS t02_gainloss,
                                         COUNT (*) AS ntp_total
                                    FROM dfn_ntp.t02_transaction_log t02
                                   WHERE t02.t02_update_type IN (1, 2)
                                GROUP BY t02.t02_txn_code) ntp
                           ON sfc.map15_ntp_code = ntp.t02_txn_code)
             WHERE    amount_diff <> 0
                   OR txn_amount_diff <> 0
                   OR stl_amount_diff <> 0
                   OR commission_diff <> 0
                   OR exg_commission_diff <> 0
                   OR disc_commission_diff <> 0
                   OR broker_tax_diff <> 0
                   OR exg_tax_diff <> 0
                   OR gain_loss_diff <> 0
                   OR count_diff <> 0)
    LOOP
        INSERT
          INTO general_verification (source_table, target_table, difference)
        VALUES (
                   'T05_CASH_ACCOUNT_LOG',
                   'T02_TRANSACTION_LOG',
                      'Txn Code : '
                   || i.map15_ntp_code
                   || ' | '
                   || 'Amount Diff : '
                   || i.amount_diff
                   || ' | '
                   || 'Amt in Txn Ccy. Diff : '
                   || i.txn_amount_diff
                   || ' | '
                   || 'Amt in Stl Ccy. Diff : '
                   || i.stl_amount_diff
                   || ' | '
                   || 'Comm. Diff : '
                   || i.commission_diff
                   || ' | '
                   || 'Exg. Comm. Diff : '
                   || i.exg_commission_diff
                   || ' | '
                   || 'Disc. Comm. Diff : '
                   || i.disc_commission_diff
                   || ' | '
                   || 'Broker Tax Diff : '
                   || i.broker_tax_diff
                   || ' | '
                   || 'Exg. Tax Diff : '
                   || i.exg_tax_diff
                   || ' | '
                   || 'Gain Loss Diff : '
                   || i.gain_loss_diff
                   || ' | '
                   || 'Count Difference : '
                   || i.count_diff);
    END LOOP;
END;
/

-- T06_HOLDINGS_LOG Verification

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    FOR i
        IN (SELECT *
              FROM (SELECT sfc.txn_code,
                           ntp.t02_txn_code,
                           sfc.t06_total_holdings,
                           ntp.t02_holding_net,
                           ntp.t02_holding_net - sfc.t06_total_holdings
                               AS net_holding_diff,
                           sfc.net_holdings_adjust,
                           ntp.t02_holding_net_adjst,
                             ntp.t02_holding_net_adjst
                           - sfc.net_holdings_adjust
                               AS holding_adjust_diff,
                           sfc.t06_pledgedqty,
                           ntp.t02_pledge_qty,
                           ntp.t02_pledge_qty - sfc.t06_pledgedqty
                               AS pledge_qty_diff,
                           sfc.t06_ord_cum_holdings,
                           ntp.t02_cum_qty,
                           ntp.t02_cum_qty - sfc.t06_ord_cum_holdings
                               AS cum_qty_diff,
                           sfc.t06_lastshares,
                           ntp.t02_last_shares,
                           ntp.t02_last_shares - sfc.t06_lastshares
                               AS last_shares_diff,
                           sfc.sfc_total,
                           ntp.ntp_total,
                           ntp.ntp_total - sfc.sfc_total AS count_diff
                      FROM     (  SELECT txn_code,
                                         SUM (t06.t06_total_holdings)
                                             AS t06_total_holdings,
                                         SUM (
                                             CASE
                                                 WHEN     u06.u06_is_custodian_account
                                                              IS NOT NULL
                                                      AND u06.u06_is_custodian_account <>
                                                              0
                                                 THEN
                                                     0
                                                 ELSE
                                                     t06.t06_net_holdings
                                             END)
                                             AS net_holdings_adjust,
                                         SUM (t06.t06_pledgedqty)
                                             AS t06_pledgedqty,
                                         SUM (t06.t06_ord_cum_holdings)
                                             AS t06_ord_cum_holdings,
                                         SUM (t06.t06_lastshares)
                                             AS t06_lastshares,
                                         COUNT (*) AS sfc_total
                                    FROM (SELECT t06_exchange,
                                                 t06_symbol,
                                                 t06_security_ac_id,
                                                 t06_inst_id,
                                                 t06_side,
                                                 t06_total_holdings,
                                                 t06_net_holdings,
                                                 t06_pledgedqty,
                                                 t06_ord_cum_holdings,
                                                 t06_lastshares,
                                                 CASE
                                                     WHEN t06_txn_type = 3
                                                     THEN
                                                         'HLDDEPOST'
                                                     WHEN t06_txn_type = 4
                                                     THEN
                                                         'HLDWITHDR'
                                                     WHEN t06_txn_type = 5
                                                     THEN
                                                         'HLDBONUSI'
                                                     WHEN t06_txn_type = 6
                                                     THEN
                                                         'HLDADJUST'
                                                     WHEN t06_txn_type = 7
                                                     THEN
                                                         'HLDSPLIT'
                                                     WHEN t06_txn_type = 8
                                                     THEN
                                                         'HLDREVSPT'
                                                     WHEN t06_txn_type = 9
                                                     THEN
                                                         'HLDRIGHTI'
                                                     WHEN t06_txn_type = 10
                                                     THEN
                                                         'HLDRHTSUBS'
                                                     WHEN t06_txn_type = 11
                                                     THEN
                                                         'HLDIPO'
                                                     WHEN t06_txn_type = 12
                                                     THEN
                                                         'HLDDIVDNT'
                                                     WHEN t06_txn_type = 13
                                                     THEN
                                                         'HLDSYMEXP'
                                                     WHEN     t06_txn_type =
                                                                  0
                                                          AND t06_net_holdings >=
                                                                  0
                                                     THEN
                                                         'HLDDEPOST'
                                                     WHEN     t06_txn_type =
                                                                  0
                                                          AND t06_net_holdings <
                                                                  0
                                                     THEN
                                                         'HLDWITHDR'
                                                 END
                                                     AS txn_code
                                            FROM mubasher_oms.t06_holdings_log@mubasher_db_link) t06,
                                         mubasher_oms.u06_routing_accounts@mubasher_db_link u06,
                                         map16_optional_exchanges_m01 map16,
                                         u07_trading_account_mappings u07_map,
                                         dfn_ntp.m20_symbol m20
                                   WHERE     t06.t06_exchange =
                                                 u06.u06_exchange
                                         AND t06.t06_security_ac_id =
                                                 u06.u06_security_ac_id
                                         AND t06.t06_inst_id <> 0
                                         AND t06.t06_side NOT IN (1, 2)
                                         AND t06.txn_code IS NOT NULL
                                         AND t06.t06_exchange =
                                                 map16.map16_oms_code(+)
                                         AND NVL (map16.map16_ntp_code,
                                                  t06.t06_exchange) =
                                                 u07_map.exchange_code
                                         AND t06.t06_security_ac_id =
                                                 u07_map.old_trading_account_id
                                         AND m20.m20_institute_id_m02 =
                                                 l_primary_institute_id
                                         AND m20.m20_exchange_code_m01 =
                                                 NVL (map16.map16_ntp_code,
                                                      t06.t06_exchange)
                                         AND m20.m20_symbol_code =
                                                 t06.t06_symbol
                                -- Validations Added to Skip Not Migrated Records
                                GROUP BY txn_code) sfc
                           LEFT JOIN
                               (  SELECT t02.t02_txn_code,
                                         SUM (t02.t02_holding_net)
                                             AS t02_holding_net,
                                         SUM (t02.t02_holding_net_adjst)
                                             AS t02_holding_net_adjst,
                                         SUM (t02.t02_pledge_qty)
                                             AS t02_pledge_qty,
                                         SUM (t02.t02_cum_qty) AS t02_cum_qty,
                                         SUM (t02.t02_last_shares)
                                             AS t02_last_shares,
                                         COUNT (*) AS ntp_total
                                    FROM dfn_ntp.t02_transaction_log t02
                                   WHERE t02.t02_update_type = 3
                                GROUP BY t02.t02_txn_code) ntp
                           ON sfc.txn_code = ntp.t02_txn_code)
             WHERE    net_holding_diff <> 0
                   OR holding_adjust_diff <> 0
                   OR pledge_qty_diff <> 0
                   OR cum_qty_diff <> 0
                   OR last_shares_diff <> 0
                   OR count_diff <> 0)
    LOOP
        INSERT
          INTO general_verification (source_table, target_table, difference)
        VALUES (
                   'T06_HOLDINGS_LOG',
                   'T02_TRANSACTION_LOG',
                      'Txn Code : '
                   || i.txn_code
                   || ' | '
                   || 'Net Holding Diff : '
                   || i.net_holding_diff
                   || ' | '
                   || 'Net Holding Adj. Diff : '
                   || i.holding_adjust_diff
                   || ' | '
                   || 'Pledge Qty. Diff : '
                   || i.pledge_qty_diff
                   || ' | '
                   || 'Cum. Order Qty. Diff : '
                   || i.cum_qty_diff
                   || ' | '
                   || 'Last Shares Diff : '
                   || i.last_shares_diff
                   || ' | '
                   || 'Count Diff : '
                   || i.count_diff);
    END LOOP;
END;
/

-- T11_EXECUTED_ORDERS Verification

BEGIN
    FOR i
        IN (SELECT *
              FROM (SELECT order_side,
                           txn_side,
                           sfc.holding_net_adjst,
                           NVL (ntp.t02_holding_net_adjst, 0)
                               AS t02_holding_net_adjst,
                             NVL (ntp.t02_holding_net_adjst, 0)
                           - sfc.holding_net_adjst
                               AS net_holding_adj_diff,
                           sfc.total_volume,
                           NVL (ntp.t02_ordqty, 0) AS t02_ordqty,
                           NVL (ntp.t02_ordqty, 0) - sfc.total_volume
                               AS order_qty_diff,
                           sfc.filled_volume,
                           NVL (ntp.t02_cum_qty, 0) AS t02_cum_qty,
                           NVL (ntp.t02_cum_qty, 0) - sfc.filled_volume
                               AS filled_qty_diff,
                           sfc.remaining_volume,
                           NVL (ntp.t02_leaves_qty, 0) AS t02_leaves_qty,
                             NVL (ntp.t02_leaves_qty, 0)
                           - sfc.remaining_volume
                               AS leaves_qty_diff,
                           sfc.cum_net_ord_value,
                           NVL (ntp.t02_cumord_netvalue, 0)
                               AS t02_cumord_netvalue,
                             NVL (ntp.t02_cumord_netvalue, 0)
                           - sfc.cum_net_ord_value
                               AS cum_net_ord_value_diff,
                           sfc.netsettle,
                           NVL (ntp.t02_cumord_netsettle, 0)
                               AS t02_cumord_netsettle,
                             NVL (ntp.t02_cumord_netsettle, 0)
                           - sfc.netsettle
                               AS cum_net_ord_settle_diff,
                           sfc.unsettled_qty,
                           NVL (ntp.t02_unsettle_qty, 0)
                               AS t02_unsettle_qty,
                             NVL (ntp.t02_unsettle_qty, 0)
                           - sfc.unsettled_qty
                               AS unsettle_qty_diff,
                           sfc.sfc_total,
                           NVL (ntp.ntp_total, 0) AS ntp_total,
                           NVL (ntp.ntp_total, 0) - sfc.sfc_total
                               AS count_diff
                      FROM     (  SELECT NVL (
                                             t11.t11_side,
                                             CASE
                                                 WHEN t05.t05_code = 'STLBUY'
                                                 THEN
                                                     1
                                                 WHEN t05.t05_code = 'STLSEL'
                                                 THEN
                                                     2
                                             END)
                                             AS order_side,
                                         SUM (
                                             CASE
                                                 WHEN     u07.u07_custodian_type_v01
                                                              IS NOT NULL
                                                      AND u07.u07_custodian_type_v01 <>
                                                              0
                                                 THEN
                                                     0
                                                 WHEN (t05.t05_code IN
                                                           ('STLBUY',
                                                            'REVSEL',
                                                            'STKSUB'))
                                                 THEN
                                                     t11.t11_filled_volume
                                                 WHEN (t05.t05_code IN
                                                           ('STLSEL',
                                                            'REVBUY',
                                                            'REVSUB'))
                                                 THEN
                                                       t11.t11_filled_volume
                                                     * -1
                                                 ELSE
                                                     t11.t11_filled_volume
                                             END)
                                             AS holding_net_adjst,
                                         SUM (
                                             NVL (t11.t11_total_volume,
                                                  t05.t05_orderqty))
                                             AS total_volume,
                                         SUM (NVL (t11.t11_filled_volume, 0))
                                             AS filled_volume,
                                         SUM (
                                             NVL (t11.t11_remaining_volume,
                                                  0))
                                             AS remaining_volume,
                                         SUM (
                                             ROUND (
                                                   NVL (t11.t11_netsettle, 0)
                                                 / CASE
                                                       WHEN t11.t11_issue_stl_rate =
                                                                0
                                                       THEN
                                                           1
                                                       ELSE
                                                           t11.t11_issue_stl_rate
                                                   END,
                                                 5))
                                             AS cum_net_ord_value,
                                         SUM (
                                             NVL (
                                                 t11.t11_netsettle,
                                                 ABS (
                                                     t05.t05_amt_in_settle_currency)))
                                             AS netsettle,
                                         SUM (NVL (t11.t11_unsettled_qty, 0))
                                             AS unsettled_qty,
                                         COUNT (*) AS sfc_total
                                    FROM mubasher_oms.t11_executed_orders@mubasher_db_link t11,
                                         ( -- None INDCH Transactions
                                          SELECT t05.t05_id,
                                                 t05.t05_code,
                                                 t05.t05_orderqty,
                                                 t05.t05_amt_in_settle_currency,
                                                 t05.t05_exchange,
                                                 t05.t05_security_ac_id
                                            FROM mubasher_oms.t05_cash_account_log@mubasher_db_link t05,
                                                 (  SELECT t05_orderno
                                                      FROM mubasher_oms.t05_cash_account_log@mubasher_db_link
                                                     WHERE t05_code = 'INDCH'
                                                  GROUP BY t05_orderno) t05_indch
                                           WHERE     t05.t05_orderno =
                                                         t05_indch.t05_orderno(+)
                                                 AND t05_indch.t05_orderno
                                                         IS NULL
                                          UNION ALL
                                          -- Capturing INDCH Transactions as Single Transaction
                                          SELECT t05.t05_id,
                                                 t05.t05_code,
                                                 t05.t05_orderqty,
                                                 t05.t05_amt_in_settle_currency,
                                                 t05.t05_exchange,
                                                 t05.t05_security_ac_id
                                            FROM (  SELECT MIN (t05_id)
                                                               AS t05_id,
                                                           MIN (t05_code)
                                                               AS t05_code,
                                                           0 AS t05_orderqty,
                                                           SUM (
                                                               t05_amt_in_settle_currency)
                                                               AS t05_amt_in_settle_currency,
                                                           t05_orderno,
                                                           MIN (t05_exchange)
                                                               AS t05_exchange,
                                                           MIN (
                                                               t05_security_ac_id)
                                                               AS t05_security_ac_id
                                                      FROM (SELECT t05.t05_id,
                                                                   MIN (
                                                                       t05.t05_code_min)
                                                                   KEEP (DENSE_RANK FIRST ORDER BY
                                                                                              t05.t05_code_min)
                                                                   OVER (
                                                                       PARTITION BY t05.t05_orderno)
                                                                       AS t05_code,
                                                                   t05.t05_amt_in_settle_currency,
                                                                   t05.t05_orderno,
                                                                   MIN (
                                                                       t05.t05_exchange)
                                                                   KEEP (DENSE_RANK FIRST ORDER BY
                                                                                              t05.t05_id)
                                                                   OVER (
                                                                       PARTITION BY t05.t05_orderno)
                                                                       AS t05_exchange,
                                                                   MIN (
                                                                       t05.t05_security_ac_id)
                                                                   KEEP (DENSE_RANK FIRST ORDER BY
                                                                                              t05.t05_id)
                                                                   OVER (
                                                                       PARTITION BY t05.t05_orderno)
                                                                       AS t05_security_ac_id
                                                              FROM (SELECT t05.*,
                                                                           CASE
                                                                               WHEN MIN (
                                                                                        t05_code)
                                                                                    KEEP (DENSE_RANK FIRST ORDER BY
                                                                                                               t05_id)
                                                                                    OVER (
                                                                                        PARTITION BY t05_orderno) IN
                                                                                        ('STLBUY',
                                                                                         'STLSEL')
                                                                               THEN
                                                                                   MIN (
                                                                                       t05_code)
                                                                                   KEEP (DENSE_RANK FIRST ORDER BY
                                                                                                              t05_id)
                                                                                   OVER (
                                                                                       PARTITION BY t05_orderno)
                                                                               ELSE
                                                                                   MAX (
                                                                                       t05_code)
                                                                                   KEEP (DENSE_RANK FIRST ORDER BY
                                                                                                              t05_id DESC)
                                                                                   OVER (
                                                                                       PARTITION BY t05_orderno)
                                                                           END
                                                                               AS t05_code_min
                                                                      FROM mubasher_oms.t05_cash_account_log@mubasher_db_link t05) t05,
                                                                   (  SELECT t05_orderno
                                                                        FROM mubasher_oms.t05_cash_account_log@mubasher_db_link
                                                                       WHERE t05_code =
                                                                                 'INDCH'
                                                                    GROUP BY t05_orderno) t05_indch
                                                             WHERE t05.t05_orderno =
                                                                       t05_indch.t05_orderno)
                                                  GROUP BY t05_orderno) t05) t05,
                                         map16_optional_exchanges_m01 map16,
                                         u07_trading_account_mappings u07_map,
                                         dfn_ntp.u07_trading_account u07
                                   WHERE     t05.t05_security_ac_id =
                                                 u07_map.old_trading_account_id(+)
                                         AND t05.t05_exchange =
                                                 map16.map16_oms_code(+)
                                         AND NVL (map16.map16_ntp_code,
                                                  t05.t05_exchange) =
                                                 u07_map.exchange_code(+)
                                         AND u07_map.new_trading_account_id =
                                                 u07.u07_id(+)
                                         AND t05.t05_id =
                                                 t11.t11_t05_exec_id(+) -- Discussed to Skip the Validation
                                         AND t05.t05_code IN
                                                 ('STLBUY',
                                                  'STLSEL',
                                                  'STKSUB',
                                                  'REVBUY',
                                                  'REVSEL',
                                                  'REVSUB')
                                -- Validations Added to Skip Not Migrated Records
                                GROUP BY NVL (
                                             t11.t11_side,
                                             CASE
                                                 WHEN t05.t05_code =
                                                          'STLBUY'
                                                 THEN
                                                     1
                                                 WHEN t05.t05_code =
                                                          'STLSEL'
                                                 THEN
                                                     2
                                             END)) sfc
                           FULL JOIN
                               (  SELECT txn_side,
                                         SUM (t02.t02_holding_net_adjst)
                                             AS t02_holding_net_adjst,
                                         SUM (t02.t02_ordqty) AS t02_ordqty,
                                         SUM (t02.t02_cum_qty) AS t02_cum_qty,
                                         SUM (t02.t02_leaves_qty)
                                             AS t02_leaves_qty,
                                         SUM (t02.t02_cumord_netvalue)
                                             AS t02_cumord_netvalue,
                                         SUM (t02.t02_cumord_netsettle)
                                             AS t02_cumord_netsettle,
                                         SUM (t02.t02_unsettle_qty)
                                             AS t02_unsettle_qty,
                                         COUNT (*) AS ntp_total
                                    FROM (SELECT CASE
                                                     WHEN (t02_txn_code IN
                                                               ('STLBUY',
                                                                'REVSEL',
                                                                'STKSUB'))
                                                     THEN
                                                         1
                                                     WHEN (t02_txn_code IN
                                                               ('STLSEL',
                                                                'REVBUY',
                                                                'REVSUB'))
                                                     THEN
                                                         2
                                                 END
                                                     AS txn_side,
                                                 t02_holding_net_adjst,
                                                 t02_ordqty,
                                                 t02_cum_qty,
                                                 t02_leaves_qty,
                                                 t02_cumord_netvalue,
                                                 t02_cumord_netsettle,
                                                 t02_unsettle_qty,
                                                 t02_update_type
                                            FROM dfn_ntp.t02_transaction_log
                                           WHERE t02_update_type = 1) t02
                                GROUP BY t02.txn_side) ntp
                           ON sfc.order_side = ntp.txn_side)
             WHERE    net_holding_adj_diff <> 0
                   OR order_qty_diff <> 0
                   OR filled_qty_diff <> 0
                   OR leaves_qty_diff <> 0
                   OR cum_net_ord_value_diff <> 0
                   OR cum_net_ord_settle_diff <> 0
                   OR unsettle_qty_diff <> 0
                   OR count_diff <> 0)
    LOOP
        INSERT
          INTO general_verification (source_table, target_table, difference)
        VALUES (
                   'T11_EXECUTED_ORDERS',
                   'T02_TRANSACTION_LOG',
                      'Order Side : '
                   || i.order_side
                   || ' | '
                   || 'Net Holding Adj. Diff : '
                   || i.net_holding_adj_diff
                   || ' | '
                   || 'Order Qty. Diff : '
                   || i.order_qty_diff
                   || ' | '
                   || 'Filled Qty. Diff : '
                   || i.filled_qty_diff
                   || ' | '
                   || 'Leaves Qty. Diff : '
                   || i.leaves_qty_diff
                   || ' | '
                   || 'Cum. Net Ord. Value Diff : '
                   || i.cum_net_ord_value_diff
                   || ' | '
                   || 'Cum. Net Ord. Settle Diff : '
                   || i.cum_net_ord_settle_diff
                   || ' | '
                   || 'Unsettle Qty. Diff : '
                   || i.unsettle_qty_diff
                   || ' | '
                   || 'Count Difference : '
                   || i.count_diff);
    END LOOP;
END;
/