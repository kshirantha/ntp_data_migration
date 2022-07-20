---------- Payable Amount DIFFERENCE -----------

BEGIN
    FOR i IN (SELECT *
                FROM (SELECT t03_account_id,
                             t03_payable_amount,
                             NVL (t05_total_payable, 0) AS t05_total_payable,
                             t03_payable_amount - NVL (t05_total_payable, 0)
                                 AS difference
                        FROM     (SELECT t03.t03_account_id,
                                         NVL (t03.t03_payable_amount, 0)
                                             AS t03_payable_amount
                                    FROM mubasher_oms.t03_cash_account@mubasher_db_link t03
                                   WHERE t03.t03_branch_id > 0) t03
                             LEFT JOIN
                                 (  SELECT t05.t05_cash_account_id,
                                           SUM (NVL (t05.t05_amount, 0))
                                               AS t05_total_payable
                                      FROM mubasher_oms.t05_cash_account_log@mubasher_db_link t05
                                     WHERE     t05.t05_inst_id > 0
                                           AND t05.t05_code = 'STLBUY'
                                           AND t05.t05_settlement_date >
                                                   TRUNC (SYSDATE)
                                  GROUP BY t05.t05_cash_account_id) t05
                             ON t03.t03_account_id = t05.t05_cash_account_id)
               WHERE difference <> 0)
    LOOP
        INSERT INTO pre_check_table_data_level (target_table,
                                                source_table,
                                                verify_condition,
                                                entity_key,
                                                source_value,
                                                target_value,
                                                difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'T05_CASH_ACCOUNT_LOG',
                     'Payable Amount',
                     i.t03_account_id,
                     i.t03_payable_amount,
                     i.t05_total_payable,
                     i.difference);
    END LOOP;
END;
/

---------- Pending Settle DIFFERENCE -----------

BEGIN
    FOR i IN (SELECT *
                FROM (SELECT t03_account_id,
                             t03_pending_settle,
                             NVL (t05_total_receivable, 0)
                                 AS t05_total_receivable,
                               t03_pending_settle
                             - NVL (t05_total_receivable, 0)
                                 AS difference
                        FROM     (SELECT t03.t03_account_id,
                                         NVL (t03.t03_pending_settle, 0)
                                             AS t03_pending_settle
                                    FROM mubasher_oms.t03_cash_account@mubasher_db_link t03
                                   WHERE t03.t03_branch_id > 0) t03
                             LEFT JOIN
                                 (  SELECT t05.t05_cash_account_id,
                                           SUM (NVL (t05.t05_amount, 0))
                                               AS t05_total_receivable
                                      FROM mubasher_oms.t05_cash_account_log@mubasher_db_link t05
                                     WHERE     t05.t05_inst_id > 0
                                           AND t05.t05_code = 'STLSELL'
                                           AND t05.t05_settlement_date >
                                                   TRUNC (SYSDATE)
                                  GROUP BY t05.t05_cash_account_id) t05
                             ON t03.t03_account_id = t05.t05_cash_account_id)
               WHERE difference <> 0)
    LOOP
        INSERT INTO pre_check_table_data_level (target_table,
                                                source_table,
                                                verify_condition,
                                                entity_key,
                                                source_value,
                                                target_value,
                                                difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'T05_CASH_ACCOUNT_LOG',
                     'Receivable Amount',
                     i.t03_account_id,
                     i.t03_pending_settle,
                     i.t05_total_receivable,
                     i.difference);
    END LOOP;
END;
/

---------- Blocked Amount DIFFERENCE -----------

BEGIN
    FOR i IN (SELECT t03_account_id,
                     t03_blocked_amount,
                     total_blocked_amount,
                     difference
                FROM (SELECT t03.t03_account_id,
                             (  ABS(t03.t03_blocked_amount)
                              + ABS (t03.t03_margin_block))
                                 AS t03_blocked_amount,
                             NVL (txn_blk.pending_withdraw, 0)
                                 AS pending_withdraw,
                             NVL (txn_blk.open_buy_order, 0)
                                 AS open_buy_order,
                             NVL (txn_blk.blocked_amount, 0)
                                 AS total_blocked_amount,
                               (  ABS(t03.t03_blocked_amount)
                                + ABS (t03.t03_margin_block))
                             - NVL (txn_blk.blocked_amount, 0)
                                 AS difference
                        FROM (  SELECT cash_account_id,
                                       SUM (pending_withdraw)
                                           AS pending_withdraw,
                                       SUM (open_buy_order) AS open_buy_order,
                                       SUM (pending_withdraw + open_buy_order)
                                           AS blocked_amount
                                  FROM (  SELECT t12_cash_account_id
                                                     AS cash_account_id,
                                                 SUM (t12_amt_in_settle_currency)
                                                     AS pending_withdraw,
                                                 0 AS open_buy_order
                                            FROM mubasher_oms.t12_pending_cash@mubasher_db_link
                                           WHERE     t12_status IN
                                                         (0, 1, 6, 7, 8, 9)
                                                 AND t12_code IN
                                                         ('WITHDR', 'TRNSFR') -- Considered Only These Two and may Consider Others Depending on the Difference Count after the Migration
                                        GROUP BY t12_cash_account_id
                                        UNION ALL
                                          SELECT t03.t03_account_id
                                                     AS cash_account_id,
                                                 0 AS pending_withdraw,
                                                   SUM (
                                                         t01_ordvalue
                                                       + t01.t01_commission
                                                       + t01.t01_broker_vat
                                                       + t01.t01_exchange_vat
                                                       - t01.t01_cum_ordnetvalue)
                                                 * -1
                                                     AS open_buy_order
                                            FROM (SELECT t01_ordvalue,
                                                         t01_commission,
                                                         t01_broker_vat,
                                                         t01_exchange_vat,
                                                         t01_cum_ordnetvalue,
                                                         t01_ordstatus,
                                                         t01_side,
                                                         t01_portfoliono
                                                    FROM mubasher_oms.t01_order_summary_intraday@mubasher_db_link
                                                  UNION ALL
                                                  SELECT t01_ordvalue,
                                                         t01_commission,
                                                         t01_broker_vat,
                                                         t01_exchange_vat,
                                                         t01_cum_ordnetvalue,
                                                         t01_ordstatus,
                                                         t01_side,
                                                         t01_portfoliono
                                                    FROM mubasher_oms.t01_order_summary_intraday_arc@mubasher_db_link) t01,
                                                 mubasher_oms.u05_security_accounts@mubasher_db_link u05,
                                                 mubasher_oms.t03_cash_account@mubasher_db_link t03
                                           WHERE     t01.t01_ordstatus IN
                                                         ('0',
                                                          '1',
                                                          '5',
                                                          '6',
                                                          'A',
                                                          'a',
                                                          'c',
                                                          'E',
                                                          'K',
                                                          'M',
                                                          'O',
                                                          'P',
                                                          'Q',
                                                          'T',
                                                          'Z',
                                                          '%',
                                                          '^',
                                                          '*')
                                                 AND t01.t01_side = 1
                                                 AND u05.u05_accountno =
                                                         t01_portfoliono
                                                 AND u05.u05_cash_account_id =
                                                         t03.t03_account_id
                                        GROUP BY t03.t03_account_id)
                              GROUP BY cash_account_id) txn_blk,
                             mubasher_oms.t03_cash_account@mubasher_db_link t03
                       WHERE t03.t03_account_id = txn_blk.cash_account_id(+))
               WHERE difference <> 0)
    LOOP
        INSERT INTO pre_check_table_data_level (target_table,
                                                source_table,
                                                verify_condition,
                                                entity_key,
                                                source_value,
                                                target_value,
                                                difference)
             VALUES (
                        'T03_CASH_ACCOUNT',
                        'T12_PENDING_CASH, T01_ORDER_SUMMARY_INTRADAY, T01_ORDER_SUMMARY_INTRADAY_ARC',
                        'Block Amount',
                        i.t03_account_id,
                        i.t03_blocked_amount,
                        i.total_blocked_amount,
                        i.difference);
    END LOOP;
END;
/
