---------- TDWL Payable Holding DIFFERENCE -----------

BEGIN
    FOR i IN (SELECT *
                FROM (SELECT t04.t04_security_ac_id,
                             t04.t04_symbol,
                             t04.t04_payable_holding,
                             NVL (payable, 0) AS t11_total_payable,
                             t04.t04_payable_holding - NVL (payable, 0)
                                 AS difference
                        FROM     (SELECT t04.t04_security_ac_id,
                                         t04.t04_symbol,
                                         NVL (t04.t04_payable_holding, 0)
                                             AS t04_payable_holding
                                    FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04
                                   WHERE     t04.t04_inst_id > 0
                                         AND t04.t04_exchange = 'TDWL') t04
                             LEFT JOIN
                                 (  SELECT t11_all.t11_security_ac_id,
                                           t11_all.t11_symbol,
                                           SUM (payable) AS payable
                                      FROM (SELECT t11.t11_security_ac_id,
                                                   t11.t11_symbol,
                                                   NVL (t11.t11_filled_volume,
                                                        0)
                                                       AS payable
                                              FROM mubasher_oms.t11_executed_orders@mubasher_db_link t11
                                             WHERE     t11.t11_inst_id > 0
                                                   AND t11.t11_side = 1
                                                   AND t11.t11_exchange =
                                                           'TDWL'
                                                   AND t11.t11_settlement_date >
                                                           TRUNC (SYSDATE)
                                            UNION ALL
                                            SELECT t11.t11_security_ac_id,
                                                   t11.t11_symbol,
                                                   NVL (t11.t11_filled_volume,
                                                        0)
                                                       AS payable
                                              FROM mubasher_oms.t11_executed_orders@mubasher_db_link t11
                                             WHERE     t11.t11_inst_id > 0
                                                   AND t11.t11_side = 1
                                                   AND t11.t11_exchange =
                                                           'TDWL'
                                                   AND t11.t11_settlement_date <=
                                                           TRUNC (SYSDATE)
                                                   AND t11.t11_fail_management_status =
                                                           4 --1 - ICM Reject | 2 - ICM Settle | 3 - Buy In | 4 - ICM Fail Chain | 5 - ICM Recapture
                                                            ) t11_all
                                  GROUP BY t11_security_ac_id, t11_symbol) t11_total
                             ON     t04.t04_security_ac_id =
                                        t11_total.t11_security_ac_id
                                AND t04.t04_symbol = t11_total.t11_symbol)
               WHERE difference <> 0)
    LOOP
        INSERT INTO pre_check_table_data_level (target_table,
                                                source_table,
                                                verify_condition,
                                                entity_key,
                                                source_value,
                                                target_value,
                                                difference)
             VALUES ('T04_HOLDINGS_INTRADAY',
                     'T11_EXECUTED_ORDERS',
                     'Payable Holding',
                     i.t04_security_ac_id || ' - ' || i.t04_symbol,
                     i.t04_payable_holding,
                     i.t11_total_payable,
                     i.difference);
    END LOOP;
END;
/

---------- None TDWL Payable Holding DIFFERENCE -----------

BEGIN
    FOR i IN (SELECT *
                FROM (SELECT t04_dtl.t04_security_ac_id,
                             t04_dtl.t04_symbol,
                             t04_dtl.t04_custodian,
                             t04_dtl.t04_payable_holding,
                             NVL (payable, 0) AS t06_total_payable,
                             t04_dtl.t04_payable_holding - NVL (payable, 0)
                                 AS difference
                        FROM     (SELECT t04_dtl.t04_security_ac_id,
                                         t04_dtl.t04_symbol,
                                         t04_dtl.t04_custodian,
                                         NVL (t04_dtl.t04_payable_holding, 0)
                                             AS t04_payable_holding
                                    FROM mubasher_oms.t04_holdings_intraday_dtl@mubasher_db_link t04_dtl
                                   WHERE     t04_dtl.t04_inst_id > 0
                                         AND t04_dtl.t04_exchange <> 'TDWL') t04_dtl
                             LEFT JOIN
                                 (SELECT t06.t06_security_ac_id,
                                         t06.t06_symbol,
                                         t06.t06_custodian_inst_id,
                                         ABS (NVL (t06.t06_net_holdings, 0))
                                             AS payable
                                    FROM mubasher_oms.t06_holdings_log@mubasher_db_link t06
                                   WHERE     t06.t06_inst_id > 0
                                         AND t06.t06_side = 1
                                         AND t06.t06_exchange <> 'TDWL'
                                         AND t06.t06_settle_date >
                                                 TRUNC (SYSDATE)) t06
                             ON     t04_dtl.t04_security_ac_id =
                                        t06.t06_security_ac_id
                                AND t04_dtl.t04_symbol = t06.t06_symbol
                                AND t04_dtl.t04_custodian =
                                        t06.t06_custodian_inst_id)
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
                        'T04_HOLDINGS_INTRADAY_DTL',
                        'T06_HOLDINGS_LOG',
                        'Payable Holding',
                           i.t04_security_ac_id
                        || ' - '
                        || i.t04_symbol
                        || ' - '
                        || i.t04_custodian,
                        i.t04_payable_holding,
                        i.t06_total_payable,
                        i.difference);
    END LOOP;
END;
/

---------- TDWL Receivable Holding DIFFERENCE -----------

BEGIN
    FOR i IN (SELECT *
                FROM (SELECT t04.t04_security_ac_id,
                             t04.t04_symbol,
                             t04.t04_pending_settle,
                             NVL (receivable, 0) AS t11_total_receivable,
                             t04.t04_pending_settle - NVL (receivable, 0)
                                 AS difference
                        FROM     (SELECT t04.t04_security_ac_id,
                                         t04.t04_symbol,
                                         NVL (t04.t04_pending_settle, 0)
                                             AS t04_pending_settle
                                    FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04
                                   WHERE     t04.t04_inst_id > 0
                                         AND t04.t04_exchange = 'TDWL') t04
                             LEFT JOIN
                                 (  SELECT t11_all.t11_security_ac_id,
                                           t11_all.t11_symbol,
                                           SUM (payable) AS receivable
                                      FROM (SELECT t11.t11_security_ac_id,
                                                   t11.t11_symbol,
                                                   NVL (t11.t11_filled_volume,
                                                        0)
                                                       AS payable
                                              FROM mubasher_oms.t11_executed_orders@mubasher_db_link t11
                                             WHERE     t11.t11_inst_id > 0
                                                   AND t11.t11_side = 2
                                                   AND t11.t11_exchange =
                                                           'TDWL'
                                                   AND t11.t11_settlement_date >
                                                           TRUNC (SYSDATE)
                                            UNION ALL
                                            SELECT t11.t11_security_ac_id,
                                                   t11.t11_symbol,
                                                   NVL (t11.t11_filled_volume,
                                                        0)
                                                       AS receivable
                                              FROM mubasher_oms.t11_executed_orders@mubasher_db_link t11
                                             WHERE     t11.t11_inst_id > 0
                                                   AND t11.t11_side = 2
                                                   AND t11.t11_exchange =
                                                           'TDWL'
                                                   AND t11.t11_settlement_date <=
                                                           TRUNC (SYSDATE)
                                                   AND t11.t11_fail_management_status =
                                                           4 --1 - ICM Reject | 2 - ICM Settle | 3 - Buy In | 4 - ICM Fail Chain | 5 - ICM Recapture
                                                            ) t11_all
                                  GROUP BY t11_security_ac_id, t11_symbol) t11_total
                             ON     t04.t04_security_ac_id =
                                        t11_total.t11_security_ac_id
                                AND t04.t04_symbol = t11_total.t11_symbol)
               WHERE difference <> 0)
    LOOP
        INSERT INTO pre_check_table_data_level (target_table,
                                                source_table,
                                                verify_condition,
                                                entity_key,
                                                source_value,
                                                target_value,
                                                difference)
             VALUES ('T04_HOLDINGS_INTRADAY',
                     'T11_EXECUTED_ORDERS',
                     'Receivable Holding',
                     i.t04_security_ac_id || ' - ' || i.t04_symbol,
                     i.t04_pending_settle,
                     i.t11_total_receivable,
                     i.difference);
    END LOOP;
END;
/

---------- None TDWL Receivable Holding DIFFERENCE -----------

BEGIN
    FOR i IN (SELECT *
                FROM (SELECT t04_dtl.t04_security_ac_id,
                             t04_dtl.t04_symbol,
                             t04_dtl.t04_custodian,
                             t04_dtl.t04_pending_settle,
                             NVL (receivable, 0) AS t06_total_receivable,
                             t04_dtl.t04_pending_settle - NVL (receivable, 0)
                                 AS difference
                        FROM     (SELECT t04_dtl.t04_security_ac_id,
                                         t04_dtl.t04_symbol,
                                         t04_dtl.t04_custodian,
                                         NVL (t04_dtl.t04_pending_settle, 0)
                                             AS t04_pending_settle
                                    FROM mubasher_oms.t04_holdings_intraday_dtl@mubasher_db_link t04_dtl
                                   WHERE     t04_dtl.t04_inst_id > 0
                                         AND t04_dtl.t04_exchange <> 'TDWL') t04_dtl
                             LEFT JOIN
                                 (SELECT t06.t06_security_ac_id,
                                         t06.t06_symbol,
                                         t06.t06_custodian_inst_id,
                                         ABS (NVL (t06.t06_net_holdings, 0))
                                             AS receivable
                                    FROM mubasher_oms.t06_holdings_log@mubasher_db_link t06
                                   WHERE     t06.t06_inst_id > 0
                                         AND t06.t06_side = 2
                                         AND t06.t06_exchange <> 'TDWL'
                                         AND t06.t06_settle_date >
                                                 TRUNC (SYSDATE)) t06
                             ON     t04_dtl.t04_security_ac_id =
                                        t06.t06_security_ac_id
                                AND t04_dtl.t04_symbol = t06.t06_symbol
                                AND t04_dtl.t04_custodian =
                                        t06.t06_custodian_inst_id)
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
                        'T04_HOLDINGS_INTRADAY_DTL',
                        'T06_HOLDINGS_LOG',
                        'Receivable Holding',
                           i.t04_security_ac_id
                        || ' - '
                        || i.t04_symbol
                        || ' - '
                        || i.t04_custodian,
                        i.t04_pending_settle,
                        i.t06_total_receivable,
                        i.difference);
    END LOOP;
END;
/

---------- TDWL Pledged Quantity DIFFERENCE -----------

BEGIN
    FOR i IN (SELECT *
                FROM (SELECT t04.t04_security_ac_id,
                             t04.t04_symbol,
                             t04.t04_pledgedqty,
                             NVL (pledge_qty, 0) AS t17_pledge_qty,
                             t04.t04_pledgedqty - NVL (pledge_qty, 0)
                                 AS difference
                        FROM     (SELECT t04.t04_security_ac_id,
                                         t04.t04_symbol,
                                         NVL (t04.t04_pledgedqty, 0)
                                             AS t04_pledgedqty
                                    FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04
                                   WHERE     t04.t04_inst_id > 0
                                         AND t04.t04_exchange = 'TDWL') t04
                             LEFT JOIN
                                 (  SELECT t17.t17_security_ac_id,
                                           t17.t17_symbol,
                                           SUM (NVL (t17.t17_remaining_qty, 0))
                                               AS pledge_qty
                                      FROM (SELECT t17.t17_security_ac_id,
                                                   t17.t17_symbol,
                                                   t17.t17_remaining_qty
                                              FROM mubasher_oms.t17_pending_pledge@mubasher_db_link t17,
                                                   mubasher_oms.u05_security_accounts@mubasher_db_link u05
                                             WHERE     t17.t17_security_ac_id =
                                                           u05.u05_id
                                                   AND u05.u05_branch_id > 0
                                                   AND t17.t17_status = 2
                                                   AND t17.t17_exchange =
                                                           'TDWL'
                                                   AND t17.t17_pledge_type =
                                                           'I') t17
                                  GROUP BY t17.t17_security_ac_id,
                                           t17.t17_symbol) t17
                             ON     t04.t04_security_ac_id =
                                        t17.t17_security_ac_id
                                AND t04.t04_symbol = t17.t17_symbol)
               WHERE difference <> 0)
    LOOP
        INSERT INTO pre_check_table_data_level (target_table,
                                                source_table,
                                                verify_condition,
                                                entity_key,
                                                source_value,
                                                target_value,
                                                difference)
             VALUES ('T04_HOLDINGS_INTRADAY',
                     'T17_PENDING_PLEDGE',
                     'Pledged Quantity Holding',
                     i.t04_security_ac_id || ' - ' || i.t04_symbol,
                     i.t04_pledgedqty,
                     i.t17_pledge_qty,
                     i.difference);
    END LOOP;
END;
/


---------- None TDWL Pledged Quantity DIFFERENCE -----------

BEGIN
    FOR i IN (SELECT *
                FROM (SELECT t04_dtl.t04_security_ac_id,
                             t04_dtl.t04_symbol,
                             t04_dtl.t04_pledgedqty,
                             NVL (pledge_qty, 0) AS t17_pledge_qty,
                             t04_dtl.t04_pledgedqty - NVL (pledge_qty, 0)
                                 AS difference
                        FROM     (  SELECT t04_dtl.t04_security_ac_id,
                                           t04_dtl.t04_symbol,
                                           SUM (
                                               NVL (t04_dtl.t04_pledgedqty, 0))
                                               AS t04_pledgedqty
                                      FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04_dtl
                                     WHERE     t04_dtl.t04_inst_id > 0
                                           AND t04_dtl.t04_exchange <> 'TDWL'
                                  GROUP BY t04_dtl.t04_security_ac_id,
                                           t04_dtl.t04_symbol) t04_dtl
                             LEFT JOIN
                                 (  SELECT t17.t17_security_ac_id,
                                           t17.t17_symbol,
                                           SUM (NVL (t17.t17_remaining_qty, 0))
                                               AS pledge_qty
                                      FROM (SELECT t17.t17_security_ac_id,
                                                   t17.t17_symbol,
                                                   t17.t17_remaining_qty
                                              FROM mubasher_oms.t17_pending_pledge@mubasher_db_link t17,
                                                   mubasher_oms.u05_security_accounts@mubasher_db_link u05
                                             WHERE     t17.t17_security_ac_id =
                                                           u05.u05_id
                                                   AND u05.u05_branch_id > 0
                                                   AND t17.t17_status = 2
                                                   AND t17.t17_exchange <>
                                                           'TDWL'
                                                   AND t17.t17_pledge_type =
                                                           'I') t17
                                  GROUP BY t17.t17_security_ac_id,
                                           t17.t17_symbol) t17
                             ON     t04_dtl.t04_security_ac_id =
                                        t17.t17_security_ac_id
                                AND t04_dtl.t04_symbol = t17.t17_symbol)
               WHERE difference <> 0)
    LOOP
        INSERT INTO pre_check_table_data_level (target_table,
                                                source_table,
                                                verify_condition,
                                                entity_key,
                                                source_value,
                                                target_value,
                                                difference)
             VALUES ('T04_HOLDINGS_INTRADAY_DTL',
                     'T17_PENDING_PLEDGE',
                     'Pledged Quantity Holding',
                     i.t04_security_ac_id || ' - ' || i.t04_symbol,
                     i.t04_pledgedqty,
                     i.t17_pledge_qty,
                     i.difference);
    END LOOP;
END;
/

---------- TDWL Blocked Holding (Sell Pending) DIFFERENCE -----------

BEGIN
    FOR i IN (SELECT t04_security_ac_id,
                     t04_symbol,
                     t04_sell_pending,
                     total_blocked_quantity,
                     difference
                FROM (SELECT t04.t04_security_ac_id,
                             t04.t04_symbol,
                             t04.t04_sell_pending,
                             NVL (txn_blk.pending_withdraw, 0)
                                 AS pending_withdraw,
                             NVL (txn_blk.open_sell_order, 0)
                                 AS open_buy_order,
                             NVL (txn_blk.blocked_quantity, 0)
                                 AS total_blocked_quantity,
                               t04.t04_sell_pending
                             - NVL (txn_blk.blocked_quantity, 0)
                                 AS difference
                        FROM (  SELECT security_account_id,
                                       symbol,
                                       SUM (pending_withdraw)
                                           AS pending_withdraw,
                                       SUM (open_sell_order) AS open_sell_order,
                                       SUM (pending_withdraw + open_sell_order)
                                           AS blocked_quantity
                                  FROM ( /* T04 Other Block Qty column includes manual blocks and hence ignored this check
                                          * U24_Holding_Block also gets Sell Pending Only
                                         SELECT t24.t24_portfolio_id
                                                      AS security_account_id,
                                                  t24.t24_symbol AS symbol,
                                                  SUM (t24.t24_quantity)
                                                      AS pending_withdraw,
                                                  0 AS open_sell_order
                                             FROM mubasher_oms.t24_pending_stocks@mubasher_db_link t24
                                            WHERE     t24.t24_exchange = 'TDWL'
                                                  AND t24.t24_status IN
                                                          (0, 1, 6, 7, 8, 9)
                                                  AND t24_txn_type IN (2, 7) -- Considered Only These Two and may Consider Others Depending on the Difference Count after the Migration
                                         GROUP BY t24.t24_portfolio_id,
                                                  t24.t24_symbol
                                         UNION ALL*/
                                        SELECT   t01.t01_security_ac_id
                                                     AS security_account_id,
                                                 t01.t01_symbol AS symbol,
                                                 0 AS pending_withdraw,
                                                 SUM (t01.t01_leavesqty) * -1
                                                     AS open_sell_order
                                            FROM (SELECT t01_security_ac_id,
                                                         t01_symbol,
                                                         t01_leavesqty,
                                                         t01_ordstatus,
                                                         t01_side,
                                                         t01_portfoliono,
                                                         t01_exchange
                                                    FROM mubasher_oms.t01_order_summary_intraday@mubasher_db_link
                                                  UNION ALL
                                                  SELECT t01_security_ac_id,
                                                         t01_symbol,
                                                         t01_leavesqty,
                                                         t01_ordstatus,
                                                         t01_side,
                                                         t01_portfoliono,
                                                         t01_exchange
                                                    FROM mubasher_oms.t01_order_summary_intraday_arc@mubasher_db_link) t01,
                                                 mubasher_oms.u05_security_accounts@mubasher_db_link u05
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
                                                 AND t01.t01_side = 2
                                                 AND u05.u05_accountno =
                                                         t01_portfoliono
                                                 AND t01.t01_exchange = 'TDWL'
                                        GROUP BY t01.t01_security_ac_id,
                                                 t01.t01_symbol)
                              GROUP BY security_account_id, symbol) txn_blk,
                             mubasher_oms.t04_holdings_intraday@mubasher_db_link t04
                       WHERE     t04.t04_security_ac_id =
                                     txn_blk.security_account_id(+)
                             AND t04.t04_symbol = txn_blk.symbol(+))
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
                        'T04_HOLDINGS_INTRADAY',
                        'T01_ORDER_SUMMARY_INTRADAY, T01_ORDER_SUMMARY_INTRADAY_ARC',
                        'Sell Pending Quantity',
                        i.t04_security_ac_id || ' - ' || i.t04_symbol,
                        i.t04_sell_pending,
                        i.total_blocked_quantity,
                        i.difference);
    END LOOP;
END;
/

---------- None TDWL Blocked Holding (Sell Pending) DIFFERENCE -----------

BEGIN
    FOR i IN (SELECT t04_security_ac_id,
                     t04_symbol,
                     t04_custodian,
                     t04_sell_pending,
                     total_blocked_quantity,
                     difference
                FROM (SELECT t04.t04_security_ac_id,
                             t04.t04_symbol,
                             t04.t04_custodian,
                             t04.t04_sell_pending,
                             NVL (txn_blk.pending_withdraw, 0)
                                 AS pending_withdraw,
                             NVL (txn_blk.open_sell_order, 0)
                                 AS open_buy_order,
                             NVL (txn_blk.blocked_quantity, 0)
                                 AS total_blocked_quantity,
                               t04.t04_sell_pending
                             - NVL (txn_blk.blocked_quantity, 0)
                                 AS difference
                        FROM (  SELECT security_account_id,
                                       symbol,
                                       custodian_id,
                                       SUM (pending_withdraw)
                                           AS pending_withdraw,
                                       SUM (open_sell_order) AS open_sell_order,
                                       SUM (pending_withdraw + open_sell_order)
                                           AS blocked_quantity
                                  FROM ( /* T04 Other Block Qty column includes manual blocks and hence ignored this check
                                          * U24_Holding_Block also gets Sell Pending Only
                                          SELECT t24.t24_portfolio_id
                                                     AS security_account_id,
                                                 t24.t24_symbol AS symbol,
                                                 t24.t24_custodian_id
                                                     AS custodian_id,
                                                 SUM (t24.t24_quantity)
                                                     AS pending_withdraw,
                                                 0 AS open_sell_order
                                            FROM mubasher_oms.t24_pending_stocks@mubasher_db_link t24
                                           WHERE     t24.t24_exchange <> 'TDWL'
                                                 AND t24.t24_status IN
                                                         (0, 1, 6, 7, 8, 9)
                                                 AND t24_txn_type IN (2, 7) -- Considered Only These Two and may Consider Others Depending on the Difference Count after the Migration
                                        GROUP BY t24.t24_portfolio_id,
                                                 t24.t24_symbol,
                                                 t24.t24_custodian_id
                                        UNION ALL */
                                        SELECT   t01.t01_security_ac_id
                                                     AS security_account_id,
                                                 t01.t01_symbol AS symbol,
                                                 t01.t01_custodian_inst_id
                                                     AS custodian_id,
                                                 0 AS pending_withdraw,
                                                 SUM (t01.t01_leavesqty) * -1
                                                     AS open_sell_order
                                            FROM (SELECT t01_security_ac_id,
                                                         t01_symbol,
                                                         t01_custodian_inst_id,
                                                         t01_leavesqty,
                                                         t01_ordstatus,
                                                         t01_side,
                                                         t01_portfoliono,
                                                         t01_exchange
                                                    FROM mubasher_oms.t01_order_summary_intraday@mubasher_db_link
                                                  UNION ALL
                                                  SELECT t01_security_ac_id,
                                                         t01_symbol,
                                                         t01_custodian_inst_id,
                                                         t01_leavesqty,
                                                         t01_ordstatus,
                                                         t01_side,
                                                         t01_portfoliono,
                                                         t01_exchange
                                                    FROM mubasher_oms.t01_order_summary_intraday_arc@mubasher_db_link) t01,
                                                 mubasher_oms.u05_security_accounts@mubasher_db_link u05
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
                                                 AND t01.t01_side = 2
                                                 AND u05.u05_accountno =
                                                         t01_portfoliono
                                                 AND t01.t01_exchange <> 'TDWL'
                                        GROUP BY t01.t01_security_ac_id,
                                                 t01.t01_symbol,
                                                 t01.t01_custodian_inst_id)
                              GROUP BY security_account_id,
                                       symbol,
                                       custodian_id) txn_blk,
                             mubasher_oms.t04_holdings_intraday_dtl@mubasher_db_link t04
                       WHERE     t04.t04_security_ac_id =
                                     txn_blk.security_account_id(+)
                             AND t04.t04_symbol = txn_blk.symbol(+)
                             AND t04.t04_custodian = txn_blk.custodian_id(+))
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
                        'T04_HOLDINGS_INTRADAY_DTL',
                        'T01_ORDER_SUMMARY_INTRADAY, T01_ORDER_SUMMARY_INTRADAY_ARC',
                        'Sell Pending Quantity',
                           i.t04_security_ac_id
                        || ' - '
                        || i.t04_symbol
                        || ' - '
                        || i.t04_custodian,
                        i.t04_sell_pending,
                        i.total_blocked_quantity,
                        i.difference);
    END LOOP;
END;
/