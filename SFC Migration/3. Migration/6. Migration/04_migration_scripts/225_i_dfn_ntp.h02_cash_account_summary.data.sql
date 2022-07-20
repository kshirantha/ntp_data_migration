/*
    The logic used to avoid record which do not differ from the previous date gets wrong
    when executed several times as the variable take NULL values and can not compare with
    the one that is already existing. If variables could be populated with its mapped and
    existing one then we could run without deleting the full table.
    Eventhough update path is written it would not take it as the table is deleted first.
    Also we will not populate any intermediate table as it could be really costly to make
    copy of old table when actually a fraction of original table is migrated.
*/

BEGIN
    dfn_ntp.truncate_table ('H02_CASH_ACCOUNT_SUMMARY');
END;
/

COMMIT;

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);

    l_s02_account_id         NUMBER := 0;
    l_s02_balance            NUMBER := 0;
    l_s02_blocked_amount     NUMBER := 0;
    l_s02_pending_settle     NUMBER := 0;
    l_s02_payable_amount     NUMBER := 0;

    l_do_insert              NUMBER := 0;
    l_rec_cnt                NUMBER := 0;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    DELETE FROM error_log
          WHERE mig_table = 'H02_CASH_ACCOUNT_SUMMARY';

    FOR i
        IN (  SELECT s02.s02_account_id,
                     u06_map.new_cash_account_id,
                     s02.s02_trimdate,
                     u01_map.new_customer_id,
                     m03.m03_code,
                     NVL (s02.s02_balance, 0) AS s02_balance,
                     NVL (s02.s02_blocked_amount, 0) AS s02_blocked_amount,
                     NVL (ABS (s02.s02_blocked_amount), 0)
                         AS abs_blocked_amount,
                     NVL (ABS (s02.s02_trading_block_amount), 0)
                         AS s02_trading_block_amount,
                     NVL (s02.s02_payable_amount, 0) AS s02_payable_amount,
                     NVL (s02.s02_pending_settle, 0) AS s02_pending_settle,
                     m03.m03_id,
                     u06.u06_margin_enabled,
                     s02.s02_lmt_primary_expiry,
                     s02.s02_trd_lmt_secondary,
                     s02.s02_lmt_secondary_expiry,
                     u06.u06_investment_account_no,
                     NVL (ABS (s02.s02_margin_due), 0) AS abs_mergin_due,
                     NVL (ABS (s02.s02_margin_block), 0) AS abs_margin_block,
                     u06.u06_margin_product_id_u23,
                     NVL (s02.s02_net_receivable, 0) AS s02_net_receivable,
                     NVL (s02.s02_opening_balance, 0) AS s02_opening_balance,
                     NVL (s02.s02_deposit, 0) AS s02_deposit,
                     NVL (s02.s02_withdrawals, 0) AS s02_withdrawals,
                     NVL (s02.s02_buy, 0) AS s02_buy,
                     NVL (s02.s02_sell, 0) AS s02_sell,
                     NVL (s02.s02_charges, 0) AS s02_charges,
                     NVL (s02.s02_commission, 0) AS s02_commission,
                     CASE
                         WHEN s02.s02_trimdate <= TRUNC (SYSDATE) THEN 25
                         ELSE 24
                     END
                         AS trade_processing_status,
                     u06_map.old_cash_account_id,
                     NVL (s02.s02_margin_utilized, 0) AS s02_margin_utilized,
                     NVL (s02.s02_accrual_interest, 0) AS s02_accrual_interest,
                     NVL (s02.s02_loan_amount, 0) AS s02_loan_amount,
                     h02.h02_cash_account_id_u06,
                     h02.h02_date
                FROM mubasher_oms.s02_cash_account_summary@mubasher_db_link s02,
                     dfn_ntp.m03_currency m03,
                     u06_cash_account_mappings u06_map,
                     dfn_ntp.u06_cash_account u06,
                     u01_customer_mappings u01_map,
                     (SELECT *
                        FROM dfn_ntp.h02_cash_account_summary
                       WHERE h02_primary_institute_id_m02 =
                                 l_primary_institute_id) h02
               WHERE     s02.s02_currency = m03.m03_code
                     AND s02.s02_account_id = u06_map.old_cash_account_id
                     AND u06_map.new_cash_account_id = u06.u06_id
                     AND s02.s02_profile_id = u01_map.old_customer_id
                     AND u06_map.new_cash_account_id =
                             h02.h02_cash_account_id_u06(+)
                     AND s02.s02_trimdate = h02.h02_date(+)
            ORDER BY s02.s02_account_id, s02.s02_trimdate)
    LOOP
        BEGIN
            IF    i.s02_account_id <> l_s02_account_id
               OR i.s02_balance <> l_s02_balance
               OR i.s02_blocked_amount <> l_s02_blocked_amount
               OR i.s02_pending_settle <> l_s02_pending_settle
               OR i.s02_payable_amount <> l_s02_payable_amount
            THEN
                l_do_insert := 1;
            END IF;

            IF l_do_insert = 1
            THEN
                IF     i.h02_cash_account_id_u06 IS NOT NULL
                   AND i.h02_date IS NOT NULL
                THEN
                    UPDATE dfn_ntp.h02_cash_account_summary
                       SET h02_date = i.s02_trimdate, -- h02_date
                           h02_currency_code_m03 = i.m03_code, -- h02_currency_code_m03
                           h02_balance = i.s02_balance, -- h02_balance
                           h02_blocked = i.abs_blocked_amount, -- h02_blocked
                           h02_manual_trade_blocked =
                               i.s02_trading_block_amount, -- h02_manual_trade_blocked
                           h02_payable_blocked = i.s02_payable_amount, -- h02_payable_blocked
                           h02_receivable_amount = i.s02_pending_settle, -- h02_receivable_amount
                           h02_currency_id_m03 = i.m03_id, -- h02_currency_id_m03
                           h02_margin_enabled = i.u06_margin_enabled, -- h02_margin_enabled
                           h02_primary_expiry = i.s02_lmt_primary_expiry, -- h02_primary_expiry
                           h02_secondary_od_limit = i.s02_trd_lmt_secondary, -- h02_secondary_od_limit
                           h02_secondary_expiry = i.s02_lmt_secondary_expiry, -- h02_secondary_expiry
                           h02_investment_account_no =
                               i.u06_investment_account_no, -- h02_investment_account_no
                           h02_margin_due = i.abs_mergin_due, -- h02_margin_due
                           h02_margin_block = i.abs_margin_block, -- h02_margin_block
                           h02_margin_product_id_u23 =
                               i.u06_margin_product_id_u23, -- h02_margin_product_id_u23
                           h02_net_receivable = i.s02_net_receivable, -- h02_net_receivable
                           h02_opening_balance = i.s02_opening_balance, -- h02_opening_balance
                           h02_deposits = i.s02_deposit, -- h02_deposits
                           h02_withdrawals = i.s02_withdrawals, -- h02_withdrawals
                           h02_net_buy = i.s02_buy, -- h02_net_buy
                           h02_net_sell = i.s02_sell, -- h02_net_sell
                           h02_net_charges_refunds = i.s02_charges, -- h02_net_charges_refunds
                           h02_net_commission = i.s02_commission, -- h02_net_commission
                           h02_accrued_interest = i.s02_accrual_interest, -- h02_accrued_interest
                           h02_trade_processing_id_t17 =
                               i.trade_processing_status, -- h02_trade_processing_id_t17
                           h02_margin_utilized = i.s02_margin_utilized, -- h02_margin_utilized
                           h02_loan_amount = i.s02_loan_amount -- h02_loan_amount
                     WHERE     h02_cash_account_id_u06 =
                                   i.h02_cash_account_id_u06
                           AND h02_date = i.h02_date;
                ELSE
                    INSERT
                      INTO dfn_ntp.h02_cash_account_summary (
                               h02_cash_account_id_u06,
                               h02_date,
                               h02_customer_id_u01,
                               h02_currency_code_m03,
                               h02_balance,
                               h02_blocked,
                               h02_open_buy_blocked,
                               h02_payable_blocked,
                               h02_manual_trade_blocked,
                               h02_manual_full_blocked,
                               h02_manual_transfer_blocked,
                               h02_receivable_amount,
                               h02_currency_id_m03,
                               h02_margin_enabled,
                               h02_pending_deposit,
                               h02_pending_withdraw,
                               h02_primary_od_limit,
                               h02_primary_start,
                               h02_primary_expiry,
                               h02_secondary_od_limit,
                               h02_secondary_start,
                               h02_secondary_expiry,
                               h02_investment_account_no,
                               h02_margin_due,
                               h02_margin_block,
                               h02_margin_product_id_u23,
                               h02_net_receivable,
                               h02_opening_balance,
                               h02_deposits,
                               h02_withdrawals,
                               h02_net_buy,
                               h02_net_sell,
                               h02_net_charges_refunds,
                               h02_net_commission,
                               h02_accrued_interest,
                               h02_trade_processing_id_t17,
                               h02_is_history_adjusted,
                               h02_primary_institute_id_m02,
                               h02_is_archive_ready,
                               h02_margin_utilized,
                               h02_gainloss,
                               h02_loan_amount)
                    VALUES (i.new_cash_account_id, -- h02_cash_account_id_u06
                            i.s02_trimdate, -- h02_date
                            i.new_customer_id, -- h02_customer_id_u01
                            i.m03_code, -- h02_currency_code_m03
                            i.s02_balance, -- h02_balance
                            i.abs_blocked_amount, -- h02_blocked
                            0, -- h02_open_buy_blocked | Not Available
                            i.s02_payable_amount, -- h02_payable_blocked
                            i.s02_trading_block_amount, -- h02_manual_trade_blocked
                            0, -- h02_manual_full_blocked
                            0, -- h02_manual_transfer_blocked
                            i.s02_pending_settle, -- h02_receivable_amount
                            i.m03_id, -- h02_currency_id_m03
                            i.u06_margin_enabled, -- h02_margin_enabled
                            0, -- h02_pending_deposit
                            0, -- h02_pending_withdraw
                            NULL, -- h02_primary_od_limit | Not Available
                            NULL, -- h02_primary_start | Not Available
                            i.s02_lmt_primary_expiry, -- h02_primary_expiry
                            i.s02_trd_lmt_secondary, -- h02_secondary_od_limit
                            NULL, -- h02_secondary_start | Not Available
                            i.s02_lmt_secondary_expiry, -- h02_secondary_expiry
                            i.u06_investment_account_no, -- h02_investment_account_no
                            i.abs_mergin_due, -- h02_margin_due
                            i.abs_margin_block, -- h02_margin_block
                            i.u06_margin_product_id_u23, -- h02_margin_product_id_u23
                            i.s02_net_receivable, -- h02_net_receivable
                            i.s02_opening_balance, -- h02_opening_balance
                            i.s02_deposit, -- h02_deposits
                            i.s02_withdrawals, -- h02_withdrawals
                            i.s02_buy, -- h02_net_buy
                            i.s02_sell, -- h02_net_sell
                            i.s02_charges, -- h02_net_charges_refunds
                            i.s02_commission, -- h02_net_commission
                            i.s02_accrual_interest, -- h02_accrued_interest
                            i.trade_processing_status, -- h02_trade_processing_id_t17
                            0, -- h02_is_history_adjusted
                            1, -- h02_primary_institute_id_m02
                            0, -- h02_is_archive_ready
                            i.s02_margin_utilized, -- h02_margin_utilized
                            0, -- h02_gainloss | Not Available
                            i.s02_loan_amount -- h02_loan_amount
                                             );

                    l_s02_account_id := i.s02_account_id;
                    l_s02_balance := i.s02_balance;
                    l_s02_blocked_amount := i.s02_blocked_amount;
                    l_s02_pending_settle := i.s02_pending_settle;
                    l_s02_payable_amount := i.s02_payable_amount;

                    l_do_insert := 0;
                    l_rec_cnt := l_rec_cnt + 1;
                END IF;

                IF MOD (l_rec_cnt, 25000) = 0
                THEN
                    COMMIT;
                END IF;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'H02_CASH_ACCOUNT_SUMMARY',
                                   'Date - '
                                || i.s02_trimdate
                                || ' | '
                                || 'Cash Acc - '
                                || i.old_cash_account_id,
                                CASE
                                    WHEN     i.h02_cash_account_id_u06
                                                 IS NOT NULL
                                         AND i.h02_date IS NOT NULL
                                    THEN
                                           'Date - '
                                        || i.h02_date
                                        || ' | '
                                        || 'Cash Acc - '
                                        || i.h02_cash_account_id_u06
                                    ELSE
                                           'Date - '
                                        || i.s02_trimdate
                                        || ' | '
                                        || 'Cash Acc - '
                                        || i.new_cash_account_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN     i.h02_cash_account_id_u06
                                                 IS NOT NULL
                                         AND i.h02_date IS NOT NULL
                                    THEN
                                        'UPDATE'
                                    ELSE
                                        'INSERT'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('H02_CASH_ACCOUNT_SUMMARY');
END;
/

-- Adding an Entry as EOD Job does not Add a Record to S02 for 0 Cash Balance

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_count                  NUMBER (10);
    l_sqlerrm                VARCHAR2 (4000);
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
        IN (SELECT t05.t05_cash_account_id,
                   u06_map.new_cash_account_id,
                   t05.t05_timestamp,
                   t03.t03_accountno,
                   u06.u06_customer_id_u01,
                   m03.m03_code,
                   m03.m03_id,
                   u06.u06_margin_enabled,
                   u06.u06_investment_account_no,
                   u06.u06_margin_product_id_u23,
                   CASE
                       WHEN t05.t05_timestamp <= TRUNC (SYSDATE) THEN 25
                       ELSE 24
                   END
                       AS trade_processing_status,
                   u06_map.old_cash_account_id,
                   h02.h02_cash_account_id_u06,
                   h02.h02_date,
                   t05.t05_realized_gainloss,
                   t05_loan_account
              FROM (  SELECT t05_cash_account_id,
                             MAX (TRUNC (t05_timestamp)) AS t05_timestamp,
                             SUM (t05_amt_in_settle_currency)
                                 AS t05_amt_in_settle_currency,
                             SUM (t05_realized_gainloss)
                                 AS t05_realized_gainloss,
                             SUM (t05_loan_account) AS t05_loan_account
                        FROM mubasher_oms.t05_cash_account_log@mubasher_db_link
                    GROUP BY t05_cash_account_id) t05,
                   mubasher_oms.t03_cash_account@mubasher_db_link t03,
                   u06_cash_account_mappings u06_map,
                   dfn_ntp.u06_cash_account u06,
                   dfn_ntp.m03_currency m03,
                   (SELECT *
                      FROM dfn_ntp.h02_cash_account_summary
                     WHERE     h02_primary_institute_id_m02 =
                                   l_primary_institute_id
                           AND h02_balance = 0) h02
             WHERE     t05.t05_cash_account_id = t03.t03_account_id
                   AND t03.t03_account_id = u06_map.old_cash_account_id
                   AND u06_map.new_cash_account_id = u06.u06_id
                   AND t03.t03_currency = m03.m03_code
                   AND t05.t05_amt_in_settle_currency = 0
                   AND u06_map.new_cash_account_id =
                           h02.h02_cash_account_id_u06(+)
                   AND t05.t05_timestamp = h02.h02_date(+))
    LOOP
        BEGIN
            IF     i.h02_cash_account_id_u06 IS NOT NULL
               AND i.h02_date IS NOT NULL
            THEN
                UPDATE dfn_ntp.h02_cash_account_summary
                   SET h02_customer_id_u01 = i.u06_customer_id_u01, -- h02_customer_id_u01
                       h02_currency_code_m03 = i.m03_code, -- h02_currency_code_m03
                       h02_currency_id_m03 = i.m03_id, -- h02_currency_id_m03
                       h02_margin_enabled = i.u06_margin_enabled, -- h02_margin_enabled
                       h02_investment_account_no = i.u06_investment_account_no, -- h02_investment_account_no
                       h02_margin_product_id_u23 = i.u06_margin_product_id_u23, -- h02_margin_product_id_u23
                       h02_trade_processing_id_t17 = i.trade_processing_status, -- h02_trade_processing_id_t17
                       h02_gainloss = i.t05_realized_gainloss, -- h02_gainloss
                       h02_loan_amount = i.t05_loan_account -- h02_loan_amount
                 WHERE     h02_cash_account_id_u06 =
                               i.h02_cash_account_id_u06
                       AND h02_date = i.h02_date;
            ELSE
                INSERT
                  INTO dfn_ntp.h02_cash_account_summary (
                           h02_cash_account_id_u06,
                           h02_date,
                           h02_customer_id_u01,
                           h02_currency_code_m03,
                           h02_balance,
                           h02_blocked,
                           h02_open_buy_blocked,
                           h02_payable_blocked,
                           h02_manual_trade_blocked,
                           h02_manual_full_blocked,
                           h02_manual_transfer_blocked,
                           h02_receivable_amount,
                           h02_currency_id_m03,
                           h02_margin_enabled,
                           h02_pending_deposit,
                           h02_pending_withdraw,
                           h02_primary_od_limit,
                           h02_primary_start,
                           h02_primary_expiry,
                           h02_secondary_od_limit,
                           h02_secondary_start,
                           h02_secondary_expiry,
                           h02_investment_account_no,
                           h02_margin_due,
                           h02_margin_block,
                           h02_margin_product_id_u23,
                           h02_net_receivable,
                           h02_opening_balance,
                           h02_deposits,
                           h02_withdrawals,
                           h02_net_buy,
                           h02_net_sell,
                           h02_net_charges_refunds,
                           h02_net_commission,
                           h02_accrued_interest,
                           h02_trade_processing_id_t17,
                           h02_is_history_adjusted,
                           h02_primary_institute_id_m02,
                           h02_is_archive_ready,
                           h02_margin_utilized,
                           h02_gainloss,
                           h02_loan_amount)
                VALUES (i.new_cash_account_id, -- h02_cash_account_id_u06
                        i.t05_timestamp, -- h02_date
                        i.u06_customer_id_u01, -- h02_customer_id_u01
                        i.m03_code, -- h02_currency_code_m03
                        0, -- h02_balance
                        0, -- h02_blocked
                        0, -- h02_open_buy_blocked
                        0, -- h02_payable_blocked
                        0, -- h02_manual_trade_blocked
                        0, -- h02_manual_full_blocked
                        0, -- h02_manual_transfer_blocked
                        0, -- h02_receivable_amount
                        i.m03_id, -- h02_currency_id_m03
                        i.u06_margin_enabled, -- h02_margin_enabled
                        0, -- h02_pending_deposit
                        0, -- h02_pending_withdraw
                        NULL, -- h02_primary_od_limit
                        NULL, -- h02_primary_start
                        NULL, -- h02_primary_expiry
                        NULL, -- h02_secondary_od_limit
                        NULL, -- h02_secondary_start
                        NULL, -- h02_secondary_expiry
                        i.u06_investment_account_no, -- h02_investment_account_no
                        0, -- h02_margin_due
                        0, -- h02_margin_block
                        i.u06_margin_product_id_u23, -- h02_margin_product_id_u23
                        0, -- h02_net_receivable
                        0, -- h02_opening_balance
                        0, -- h02_deposits
                        0, -- h02_withdrawals
                        0, -- h02_net_buy
                        0, -- h02_net_sell
                        0, -- h02_net_charges_refunds
                        0, -- h02_net_commission
                        0, -- h02_accrued_interest
                        i.trade_processing_status, -- h02_trade_processing_id_t17
                        0, -- h02_is_history_adjusted
                        1, -- h02_primary_institute_id_m02
                        0, -- h02_is_archive_ready
                        0, -- h02_margin_utilized
                        i.t05_realized_gainloss, -- h02_gainloss
                        i.t05_loan_account -- h02_loan_amount
                                          );
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'H02_CASH_ACCOUNT_SUMMARY',
                                   '0 Balance  : Date - '
                                || i.t05_timestamp
                                || ' | '
                                || 'Cash Acc - '
                                || i.old_cash_account_id,
                                CASE
                                    WHEN     i.h02_cash_account_id_u06
                                                 IS NOT NULL
                                         AND i.h02_date IS NOT NULL
                                    THEN
                                        NULL
                                    ELSE
                                           '0 Balance : Date - '
                                        || i.t05_timestamp
                                        || ' | '
                                        || 'Cash Acc - '
                                        || i.new_cash_account_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN     i.h02_cash_account_id_u06
                                                 IS NOT NULL
                                         AND i.h02_date IS NOT NULL
                                    THEN
                                        'UPDATE'
                                    ELSE
                                        'INSERT'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/

COMMIT;

-- Old System Following Columns are Not Accurate & Hence Generated from Live Table as Per Reports Requirement

BEGIN
    MERGE INTO dfn_ntp.h02_cash_account_summary h02
         USING (  SELECT t02.t02_cash_acnt_id_u06,
                         TRUNC (t02.t02_create_date) AS t02_create_date,
                         SUM (
                             NVL (
                                   NVL (t02.t02_commission_adjst, 0)
                                 * t02.t02_fx_rate,
                                 0))
                             AS commission,
                         SUM (
                             NVL (
                                 CASE t02.t02_txn_code
                                     WHEN 'STLBUY'
                                     THEN
                                         t02.t02_amnt_in_stl_currency
                                     ELSE
                                         0
                                 END,
                                 0))
                             AS buy,
                         SUM (
                             NVL (
                                 CASE t02.t02_txn_code
                                     WHEN 'STLSEL'
                                     THEN
                                         t02.t02_amnt_in_stl_currency
                                     ELSE
                                         0
                                 END,
                                 0))
                             AS sell,
                         SUM (
                             NVL (
                                 CASE t02.t02_txn_code
                                     WHEN 'DEPOST'
                                     THEN
                                         t02.t02_amnt_in_stl_currency
                                     ELSE
                                         0
                                 END,
                                 0))
                             AS deposits,
                         SUM (
                             NVL (
                                 CASE t02.t02_txn_code
                                     WHEN 'WITHDR'
                                     THEN
                                         t02.t02_amnt_in_stl_currency
                                     ELSE
                                         0
                                 END,
                                 0))
                             AS withdrawals,
                         SUM (
                             NVL (
                                 CASE
                                     WHEN t02.t02_txn_code NOT IN
                                              ('STLBUY',
                                               'STLSEL',
                                               'DEPOST',
                                               'WITHDR')
                                     THEN
                                         t02.t02_amnt_in_stl_currency
                                     ELSE
                                         0
                                 END,
                                 0))
                             AS charges,
                         SUM (
                             NVL (
                                 CASE
                                     WHEN t02.t02_txn_code NOT IN ('STLBUY')
                                     THEN
                                         t02.t02_gainloss
                                     ELSE
                                         0
                                 END,
                                 0))
                             AS gainloss
                    FROM dfn_ntp.t02_transaction_log t02
                GROUP BY t02.t02_cash_acnt_id_u06,
                         TRUNC (t02.t02_create_date)) txn
            ON (    h02.h02_cash_account_id_u06 = txn.t02_cash_acnt_id_u06
                AND h02.h02_date = txn.t02_create_date)
    WHEN MATCHED
    THEN
        UPDATE SET h02.h02_net_commission = txn.commission,
                   h02.h02_deposits = txn.deposits,
                   h02.h02_withdrawals = txn.withdrawals,
                   h02.h02_net_buy = txn.buy,
                   h02.h02_net_sell = txn.sell,
                   h02.h02_net_charges_refunds = txn.charges,
                   h02.h02_gainloss = txn.gainloss;
END;
/

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('H02_CASH_ACCOUNT_SUMMARY');
END;
/