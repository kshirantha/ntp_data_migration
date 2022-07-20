CREATE OR REPLACE PROCEDURE dfn_ntp.sp_h02_update_balance (
    p_current_date          IN h02_cash_account_summary.h02_date%TYPE,
    p_new_date              IN h02_cash_account_summary.h02_date%TYPE,
    p_cash_account_id       IN h02_cash_account_summary.h02_cash_account_id_u06%TYPE,
    p_side                  IN NUMBER,
    p_original_value        IN h02_cash_account_summary.h02_balance%TYPE,
    p_new_value             IN h02_cash_account_summary.h02_balance%TYPE,
    p_original_commission   IN h02_cash_account_summary.h02_net_commission%TYPE DEFAULT 0,
    p_new_commission        IN h02_cash_account_summary.h02_net_commission%TYPE DEFAULT 0,
    p_trade_process_id      IN h02_cash_account_summary.h02_trade_processing_id_t17%TYPE DEFAULT 0)
IS
    l_h02_payable_amount      NUMBER;
    l_h02_receivable_amount   NUMBER;
    p_diff_act                NUMBER;
    l_diff                    NUMBER;
    l_count                   NUMBER;
    l_customer_id             NUMBER;
    l_currency_code           CHAR (3);
    l_currency_id             NUMBER;
    l_diff_from_date          DATE;
    l_new_date                DATE := TRUNC (p_new_date);
    l_comm_diff               NUMBER;
    l_institute_id            NUMBER;
    l_primary_institute_id    NUMBER;
BEGIN
    SELECT COUNT (h02_date)
      INTO l_count
      FROM h02_cash_account_summary
     WHERE     h02_date = p_new_date
           AND h02_cash_account_id_u06 = p_cash_account_id;

    DELETE FROM dfn_ntp.h00_dates
          WHERE h00_date = l_new_date;

    INSERT INTO dfn_ntp.h00_dates (h00_date)
         VALUES (l_new_date);

    l_diff := p_new_value - p_original_value;
    l_comm_diff := p_new_commission - p_original_commission;

    SELECT a.u06_customer_id_u01,
           a.u06_currency_code_m03,
           a.u06_currency_id_m03,
           a.u06_institute_id_m02
      INTO l_customer_id,
           l_currency_code,
           l_currency_id,
           l_institute_id
      FROM u06_cash_account a
     WHERE a.u06_id = p_cash_account_id;

    SELECT m02_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM m02_institute
     WHERE m02_id = l_institute_id;

    IF (l_count = 0)
    THEN
        INSERT INTO h02_cash_account_summary (h02_cash_account_id_u06,
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
                                              h02_daily_withdraw_limit,
                                              h02_daily_cum_withdraw_amt,
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
                                              h02_margin_utilized)
            SELECT h02_cash_account_id_u06,
                   p_new_date AS h02_date,
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
                   h02_daily_withdraw_limit,
                   h02_daily_cum_withdraw_amt,
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
                   p_trade_process_id AS h02_trade_processing_id_t17,
                   1 AS h02_is_history_adjusted,
                   h02_primary_institute_id_m02,
                   h02_is_archive_ready,
                   h02_margin_utilized
              FROM (  SELECT h02_cash_account_id_u06,
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
                             h02_daily_withdraw_limit,
                             h02_daily_cum_withdraw_amt,
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
                             h02_margin_utilized
                        FROM (SELECT h02_cash_account_id_u06,
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
                                     h02_daily_withdraw_limit,
                                     h02_daily_cum_withdraw_amt,
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
                                     h02_margin_utilized
                                FROM h02_cash_account_summary
                              UNION ALL
                              SELECT p_cash_account_id
                                         AS h02_cash_account_id_u06,
                                     TO_DATE ('1970/01/01', 'YYYY/MM/DD')
                                         AS h02_date,
                                     l_customer_id AS h02_customer_id_u01,
                                     l_currency_code AS h02_currency_code_m03,
                                     0 AS h02_balance,
                                     0 AS h02_blocked,
                                     0 AS h02_open_buy_blocked,
                                     0 AS h02_payable_blocked,
                                     0 AS h02_manual_trade_blocked,
                                     0 AS h02_manual_full_blocked,
                                     0 AS h02_manual_transfer_blocked,
                                     0 AS h02_receivable_amount,
                                     l_currency_id AS h02_currency_id_m03,
                                     0 AS h02_margin_enabled,
                                     0 AS h02_pending_deposit,
                                     0 AS h02_pending_withdraw,
                                     0 AS h02_primary_od_limit,
                                     NULL AS h02_primary_start,
                                     NULL AS h02_primary_expiry,
                                     0 AS h02_secondary_od_limit,
                                     NULL AS h02_secondary_start,
                                     NULL AS h02_secondary_expiry,
                                     '' AS h02_investment_account_no,
                                     0 AS h02_daily_withdraw_limit,
                                     0 AS h02_daily_cum_withdraw_amt,
                                     0 AS h02_margin_due,
                                     0 AS h02_margin_block,
                                     -1 AS h02_margin_product_id_u23,
                                     0 AS h02_net_receivable,
                                     0 AS h02_opening_balance,
                                     0 AS h02_deposits,
                                     0 AS h02_withdrawals,
                                     0 AS h02_net_buy,
                                     0 AS h02_net_sell,
                                     0 AS h02_net_charges_refunds,
                                     0 AS h02_net_commission,
                                     0 AS h02_accrued_interest,
                                     '0',
                                     1,
                                     l_primary_institute_id,
                                     0 AS h02_is_archive_ready,
                                     0 AS h02_margin_utilized
                                FROM DUAL) a
                       WHERE     h02_date < p_new_date
                             AND h02_cash_account_id_u06 = p_cash_account_id
                    ORDER BY h02_date DESC)
             WHERE ROWNUM = 1;
    END IF;

    IF (p_current_date > p_new_date)
    THEN
        l_diff_from_date := p_current_date;

        FOR i
            IN (SELECT h02_payable_blocked, h02_receivable_amount, h02_date
                  FROM h02_cash_account_summary
                 WHERE     h02_date >= p_new_date
                       AND h02_date < p_current_date
                       AND h02_cash_account_id_u06 = p_cash_account_id)
        LOOP
            IF (p_side = 1)                                              --Buy
            THEN
                p_diff_act := i.h02_payable_blocked + p_new_value;

                IF (p_diff_act <= 0)
                THEN
                    p_diff_act := 0;
                END IF;

                UPDATE h02_cash_account_summary
                   SET h02_balance = h02_balance - p_new_value,
                       h02_payable_blocked = p_diff_act,
                       h02_is_history_adjusted = 1,
                       h02_trade_processing_id_t17 = p_trade_process_id
                 WHERE     h02_date = i.h02_date
                       AND h02_cash_account_id_u06 = p_cash_account_id;
            END IF;

            IF (p_side = 2)                                             --Sell
            THEN
                p_diff_act := i.h02_receivable_amount + p_new_value;

                IF (p_diff_act <= 0)
                THEN
                    p_diff_act := 0;
                END IF;

                UPDATE h02_cash_account_summary
                   SET h02_balance = h02_balance + p_new_value,
                       h02_receivable_amount = p_diff_act,
                       h02_is_history_adjusted = 1,
                       h02_trade_processing_id_t17 = p_trade_process_id
                 WHERE     h02_date = i.h02_date
                       AND h02_cash_account_id_u06 = p_cash_account_id;
            END IF;
        END LOOP;

        -- updateing opening balance
        FOR i
            IN (SELECT h02_payable_blocked, h02_receivable_amount, h02_date
                  FROM h02_cash_account_summary
                 WHERE     h02_date > p_new_date
                       AND h02_date <= p_current_date
                       AND h02_cash_account_id_u06 = p_cash_account_id)
        LOOP
            IF (p_side = 1)                                              --Buy
            THEN
                UPDATE h02_cash_account_summary
                   SET h02_opening_balance = h02_opening_balance - p_new_value,
                       h02_is_history_adjusted = 1,
                       h02_trade_processing_id_t17 = p_trade_process_id
                 WHERE     h02_date = i.h02_date
                       AND h02_cash_account_id_u06 = p_cash_account_id;
            END IF;

            IF (p_side = 2)                                             --Sell
            THEN
                UPDATE h02_cash_account_summary
                   SET h02_opening_balance = h02_opening_balance + p_new_value,
                       h02_is_history_adjusted = 1,
                       h02_trade_processing_id_t17 = p_trade_process_id
                 WHERE     h02_date = i.h02_date
                       AND h02_cash_account_id_u06 = p_cash_account_id;
            END IF;
        END LOOP;
    -- updateing opening balance
    END IF;

    IF (p_new_date > p_current_date)
    THEN
        l_diff_from_date := p_new_date;

        FOR i
            IN (SELECT h02_payable_blocked, h02_receivable_amount, h02_date
                  FROM h02_cash_account_summary
                 WHERE     h02_date >= p_current_date
                       AND h02_date < p_new_date
                       AND h02_cash_account_id_u06 = p_cash_account_id)
        LOOP
            IF (p_side = 1)                                              --Buy
            THEN
                p_diff_act := i.h02_payable_blocked - p_original_value;

                IF (p_diff_act <= 0)
                THEN
                    p_diff_act := 0;
                END IF;

                UPDATE h02_cash_account_summary
                   SET h02_balance = h02_balance + p_original_value,
                       h02_payable_blocked = p_diff_act,
                       h02_is_history_adjusted = 1,
                       h02_trade_processing_id_t17 = p_trade_process_id
                 WHERE     h02_date = i.h02_date
                       AND h02_cash_account_id_u06 = p_cash_account_id;
            END IF;

            IF (p_side = 2)                                             --Sell
            THEN
                p_diff_act := i.h02_receivable_amount - p_original_value;

                IF (p_diff_act <= 0)
                THEN
                    p_diff_act := 0;
                END IF;

                UPDATE h02_cash_account_summary
                   SET h02_balance = h02_balance - p_original_value,
                       h02_receivable_amount = p_diff_act,
                       h02_is_history_adjusted = 1,
                       h02_trade_processing_id_t17 = p_trade_process_id
                 WHERE     h02_date = i.h02_date
                       AND h02_cash_account_id_u06 = p_cash_account_id;
            END IF;
        END LOOP;

        -- updateing opening balance
        FOR i
            IN (SELECT h02_payable_blocked, h02_receivable_amount, h02_date
                  FROM h02_cash_account_summary
                 WHERE     h02_date > p_current_date
                       AND h02_date <= p_new_date
                       AND h02_cash_account_id_u06 = p_cash_account_id)
        LOOP
            IF (p_side = 1)                                              --Buy
            THEN
                UPDATE h02_cash_account_summary
                   SET h02_opening_balance =
                           h02_opening_balance + p_original_value,
                       h02_is_history_adjusted = 1,
                       h02_trade_processing_id_t17 = p_trade_process_id
                 WHERE     h02_date = i.h02_date
                       AND h02_cash_account_id_u06 = p_cash_account_id;
            END IF;

            IF (p_side = 2)                                             --Sell
            THEN
                UPDATE h02_cash_account_summary
                   SET h02_opening_balance =
                           h02_opening_balance - p_original_value,
                       h02_is_history_adjusted = 1,
                       h02_trade_processing_id_t17 = p_trade_process_id
                 WHERE     h02_date = i.h02_date
                       AND h02_cash_account_id_u06 = p_cash_account_id;
            END IF;
        END LOOP;
    -- updateing opening balance

    END IF;

    IF (p_current_date = p_new_date)
    THEN
        l_diff_from_date := p_current_date;
    END IF;

    FOR i
        IN (SELECT h02_payable_blocked, h02_receivable_amount, h02_date -- INTO l_h02_payable_amount, l_H02_RECEIVABLE_AMOUNT
              FROM h02_cash_account_summary
             WHERE     h02_date >= l_diff_from_date
                   AND h02_cash_account_id_u06 = p_cash_account_id)
    LOOP
        IF (p_side = 1)                                                  --Buy
        THEN
            p_diff_act := i.h02_payable_blocked + l_diff;

            IF (p_diff_act <= 0)
            THEN
                p_diff_act := 0;
            END IF;

            UPDATE h02_cash_account_summary
               SET h02_balance = h02_balance - l_diff,
                   h02_payable_blocked = p_diff_act,
                   h02_is_history_adjusted = 1,
                   h02_trade_processing_id_t17 = p_trade_process_id
             WHERE     h02_date = i.h02_date
                   AND h02_cash_account_id_u06 = p_cash_account_id;
        END IF;

        IF (p_side = 2)                                                 --Sell
        THEN
            p_diff_act := i.h02_receivable_amount + l_diff;

            IF (p_diff_act <= 0)
            THEN
                p_diff_act := 0;
            END IF;

            UPDATE h02_cash_account_summary
               SET h02_balance = h02_balance + l_diff,
                   h02_receivable_amount = p_diff_act,
                   h02_is_history_adjusted = 1,
                   h02_trade_processing_id_t17 = p_trade_process_id
             WHERE     h02_date = i.h02_date
                   AND h02_cash_account_id_u06 = p_cash_account_id;
        END IF;
    END LOOP;

    -- updateing opening balance
    FOR i
        IN (SELECT h02_payable_blocked, h02_receivable_amount, h02_date
              FROM h02_cash_account_summary
             WHERE     h02_date > l_diff_from_date
                   AND h02_cash_account_id_u06 = p_cash_account_id)
    LOOP
        IF (p_side = 1)                                                  --Buy
        THEN
            UPDATE h02_cash_account_summary
               SET h02_opening_balance = h02_opening_balance - l_diff,
                   h02_is_history_adjusted = 1,
                   h02_trade_processing_id_t17 = p_trade_process_id
             WHERE     h02_date = i.h02_date
                   AND h02_cash_account_id_u06 = p_cash_account_id;
        END IF;

        IF (p_side = 2)                                                 --Sell
        THEN
            UPDATE h02_cash_account_summary
               SET h02_opening_balance = h02_opening_balance + l_diff,
                   h02_is_history_adjusted = 1,
                   h02_trade_processing_id_t17 = p_trade_process_id
             WHERE     h02_date = i.h02_date
                   AND h02_cash_account_id_u06 = p_cash_account_id;
        END IF;
    END LOOP;

    -- updateing opening balance

    IF (l_comm_diff <> 0)
    THEN
        UPDATE h02_cash_account_summary
           SET h02_net_commission = h02_net_commission - p_original_commission,
               h02_is_history_adjusted = 1,
               h02_trade_processing_id_t17 = p_trade_process_id
         WHERE     h02_date = p_current_date
               AND h02_cash_account_id_u06 = p_cash_account_id;

        UPDATE h02_cash_account_summary
           SET h02_net_commission = h02_net_commission + p_new_commission,
               h02_is_history_adjusted = 1,
               h02_trade_processing_id_t17 = p_trade_process_id
         WHERE     h02_date = p_new_date
               AND h02_cash_account_id_u06 = p_cash_account_id;
    END IF;

    IF (l_diff <> 0)
    THEN
        IF (p_side = 1)                                                  --Buy
        THEN
            UPDATE h02_cash_account_summary
               SET h02_net_buy = h02_net_buy - p_original_value,
                   h02_is_history_adjusted = 1,
                   h02_trade_processing_id_t17 = p_trade_process_id
             WHERE     h02_date = p_current_date
                   AND h02_cash_account_id_u06 = p_cash_account_id;

            UPDATE h02_cash_account_summary
               SET h02_net_buy = h02_net_buy - p_new_value,
                   h02_is_history_adjusted = 1,
                   h02_trade_processing_id_t17 = p_trade_process_id
             WHERE     h02_date = p_new_date
                   AND h02_cash_account_id_u06 = p_cash_account_id;
        END IF;

        IF (p_side = 2)                                                 --Sell
        THEN
            UPDATE h02_cash_account_summary
               SET h02_net_sell = h02_net_sell - p_original_value,
                   h02_is_history_adjusted = 1,
                   h02_trade_processing_id_t17 = p_trade_process_id
             WHERE     h02_date = p_current_date
                   AND h02_cash_account_id_u06 = p_cash_account_id;

            UPDATE h02_cash_account_summary
               SET h02_net_sell = h02_net_sell - p_new_value,
                   h02_is_history_adjusted = 1,
                   h02_trade_processing_id_t17 = p_trade_process_id
             WHERE     h02_date = p_new_date
                   AND h02_cash_account_id_u06 = p_cash_account_id;
        END IF;
    END IF;
END;
/