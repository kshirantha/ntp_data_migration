DECLARE
    l_sqlerrm   VARCHAR2 (4000);
    l_rec_cnt   NUMBER := 0;
BEGIN
    DELETE FROM error_log
          WHERE mig_table = 'H24_GL_CASH_ACCOUNT_SUMMARY';

    FOR i
        IN (SELECT h02.h02_date,
                   h02.h02_cash_account_id_u06,
                   h02.h02_opening_balance,
                   h02.h02_deposits,
                   h02.h02_withdrawals,
                   h02.h02_net_buy,
                   h02.h02_net_sell,
                   h02.h02_net_charges_refunds,
                   h02.h02_net_commission,
                   h02.h02_accrued_interest,
                   h02.h02_balance,
                   h02.h02_blocked,
                   h02.h02_open_buy_blocked,
                   h02.h02_pending_withdraw,
                   h02.h02_manual_trade_blocked,
                   h02.h02_manual_full_blocked,
                   h02.h02_manual_transfer_blocked,
                   h02.h02_payable_blocked,
                   h02.h02_receivable_amount,
                   h24.h24_date,
                   h24.h24_cash_account_id_u06
              FROM dfn_ntp.h02_cash_account_summary h02,
                   dfn_ntp.h24_gl_cash_account_summary h24
             WHERE     h02.h02_date = h24.h24_date(+)
                   AND h02.h02_cash_account_id_u06 =
                           h24.h24_cash_account_id_u06(+))
    LOOP
        BEGIN
            IF     i.h24_date IS NOT NULL
               AND i.h24_cash_account_id_u06 IS NOT NULL
            THEN
                UPDATE dfn_ntp.h24_gl_cash_account_summary
                   SET h24_opening_balance = i.h02_opening_balance, -- h24_opening_balance
                       h24_deposits = i.h02_deposits, -- h24_deposits
                       h24_withdrawals = i.h02_withdrawals, -- h24_withdrawals
                       h24_buy = i.h02_net_buy, -- h24_buy
                       h24_sell = i.h02_net_sell, -- h24_sell
                       h24_accrued_interest = i.h02_accrued_interest, -- h24_accrued_interest
                       h24_settled_balance = i.h02_balance, -- h24_settled_balance
                       h24_blocked = i.h02_blocked, -- h24_blocked
                       h24_open_buy_blocked = i.h02_open_buy_blocked, -- h24_open_buy_blocked
                       h24_pending_withdraw = i.h02_pending_withdraw, -- h24_pending_withdraw
                       h24_manual_trade_blocked = i.h02_manual_trade_blocked, -- h24_manual_trade_blocked
                       h24_manual_full_blocked = i.h02_manual_full_blocked, -- h24_manual_full_blocked
                       h24_manual_transfer_blocked =
                           i.h02_manual_transfer_blocked, -- h24_manual_transfer_blocked
                       h24_payable_blocked = i.h02_payable_blocked, -- h24_payable_blocked
                       h24_receivable_amount = i.h02_receivable_amount -- h24_receivable_amount
                 WHERE     h24_date = i.h24_date
                       AND h24_cash_account_id_u06 =
                               i.h24_cash_account_id_u06;
            ELSE
                INSERT
                  INTO dfn_ntp.h24_gl_cash_account_summary (
                           h24_date,
                           h24_cash_account_id_u06,
                           h24_opening_balance,
                           h24_deposits,
                           h24_withdrawals,
                           h24_buy,
                           h24_sell,
                           h24_charges,
                           h24_refunds,
                           h24_broker_commission,
                           h24_exg_commission,
                           h24_accrued_interest,
                           h24_settled_balance,
                           h24_blocked,
                           h24_open_buy_blocked,
                           h24_pending_withdraw,
                           h24_manual_trade_blocked,
                           h24_manual_full_blocked,
                           h24_manual_transfer_blocked,
                           h24_payable_blocked,
                           h24_receivable_amount)
                VALUES (i.h02_date, -- h24_date
                        i.h02_cash_account_id_u06, -- h24_cash_account_id_u06
                        i.h02_opening_balance, -- h24_opening_balance
                        i.h02_deposits, -- h24_deposits
                        i.h02_withdrawals, -- h24_withdrawals
                        i.h02_net_buy, -- h24_buy
                        i.h02_net_sell, -- h24_sell
                        NULL, -- h24_charges | Not Available
                        NULL, -- h24_refunds | Not Available
                        NULL, -- h24_broker_commission | Not Available
                        NULL, -- h24_exg_commission | Not Available
                        i.h02_accrued_interest, -- h24_accrued_interest
                        i.h02_balance, -- h24_settled_balance
                        i.h02_blocked, -- h24_blocked
                        i.h02_open_buy_blocked, -- h24_open_buy_blocked
                        i.h02_pending_withdraw, -- h24_pending_withdraw
                        i.h02_manual_trade_blocked, -- h24_manual_trade_blocked
                        i.h02_manual_full_blocked, -- h24_manual_full_blocked
                        i.h02_manual_transfer_blocked, -- h24_manual_transfer_blocked
                        i.h02_payable_blocked, -- h24_payable_blocked
                        i.h02_receivable_amount -- h24_receivable_amount
                                               );
            END IF;

            l_rec_cnt := l_rec_cnt + 1;

            IF MOD (l_rec_cnt, 25000) = 0
            THEN
                COMMIT;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'H24_GL_CASH_ACCOUNT_SUMMARY',
                                   'Date: '
                                || i.h02_date
                                || ' | Cash Acc: '
                                || i.h02_cash_account_id_u06,
                                CASE
                                    WHEN     i.h24_date IS NOT NULL
                                         AND i.h24_cash_account_id_u06
                                                 IS NOT NULL
                                    THEN
                                        NULL
                                    ELSE
                                           'Date: '
                                        || i.h02_date
                                        || ' | Cash Acc: '
                                        || i.h02_cash_account_id_u06
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN     i.h24_date IS NOT NULL
                                         AND i.h24_cash_account_id_u06
                                                 IS NOT NULL
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
