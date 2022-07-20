CREATE OR REPLACE PROCEDURE dfn_ntp.sp_h02_populate_cash
IS
    l_sysdate   DATE := TRUNC (func_get_eod_date ());
BEGIN
    DELETE FROM dfn_ntp.h00_dates
          WHERE h00_date = l_sysdate;

    INSERT INTO dfn_ntp.h00_dates (h00_date)
         VALUES (l_sysdate);

    DELETE FROM dfn_ntp.h02_cash_account_summary
          WHERE h02_date = l_sysdate;

    INSERT INTO dfn_ntp.h02_cash_account_summary (
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
                    h02_daily_withdraw_limit,
                    h02_daily_cum_withdraw_amt,
                    h02_margin_due,
                    h02_margin_block,
                    h02_margin_product_id_u23,
                    h02_net_receivable,
                    h02_accrued_interest,
                    h02_opening_balance,
                    h02_deposits,
                    h02_withdrawals,
                    h02_net_buy,
                    h02_net_sell,
                    h02_net_charges_refunds,
                    h02_net_commission,
                    h02_primary_institute_id_m02,
                    h02_margin_utilized,
                    h02_gainloss,
                    h02_loan_amount)
        SELECT u06.u06_id,                           --h02_cash_account_id_u06
               l_sysdate,                                           --h02_date
               u06.u06_customer_id_u01,                  --h02_customer_id_u01
               u06.u06_currency_code_m03,              --h02_currency_code_m03
               u06.u06_balance,                                  --h02_balance
               u06.u06_blocked,                                  --h02_blocked
               u06.u06_open_buy_blocked,                --h02_open_buy_blocked
               u06.u06_payable_blocked,                  --h02_payable_blocked
               u06.u06_manual_trade_blocked,        --h02_manual_trade_blocked
               u06.u06_manual_full_blocked,          --h02_manual_full_blocked
               u06.u06_manual_transfer_blocked,  --h02_manual_transfer_blocked
               u06.u06_receivable_amount,              --h02_receivable_amount
               u06.u06_currency_id_m03,                  --h02_currency_id_m03
               u06.u06_margin_enabled,                    --h02_margin_enabled
               u06.u06_pending_deposit,                  --h02_pending_deposit
               u06.u06_pending_withdraw,                --h02_pending_withdraw
               u06.u06_primary_od_limit,                --h02_primary_od_limit
               u06.u06_primary_start,                      --h02_primary_start
               u06.u06_primary_expiry,                    --h02_primary_expiry
               u06.u06_secondary_od_limit,            --h02_secondary_od_limit
               u06.u06_secondary_start,                  --h02_secondary_start
               u06.u06_secondary_expiry,                --h02_secondary_expiry
               u06.u06_investment_account_no,      --h02_investment_account_no
               m177.m177_cash_transfer_limit,       --h02_daily_withdraw_limit
               u06.u06_cum_transfer_value,        --h02_daily_cum_withdraw_amt
               u06.u06_margin_due,                            --h02_margin_due
               u06.u06_margin_block,                        --h02_margin_block
               u06.u06_margin_product_id_u23,      --h02_margin_product_id_u23
               u06.u06_net_receivable,                    --h02_net_receivable
               u06.u06_accrued_interest,                --h02_accrued_interest
               NVL (open_balance.h02_balance, 0),        --h02_opening_balance
               NVL (txn.deposits, 0),                           --h02_deposits
               NVL (txn.withdrawals, 0),                     --h02_withdrawals
               NVL (txn.buy, 0),                                 --h02_net_buy
               NVL (txn.sell, 0),                               --h02_net_sell
               NVL (txn.other, 0),                   --h02_net_charges_refunds
               NVL (txn.commission, 0),                   --h02_net_commission
               m02.m02_primary_institute_id_m02, --h02_primary_institute_id_m02
               CASE
                   WHEN     u06.u06_margin_enabled > 0
                        AND (  u06.u06_balance
                             + u06.u06_payable_blocked
                             - u06.u06_receivable_amount
                             - u06.u06_loan_amount) < 0
                        AND (  u06.u06_balance
                             + u06.u06_payable_blocked
                             - u06.u06_receivable_amount
                             - u06.u06_loan_amount) >
                                open_balance.h02_margin_utilized
                   THEN
                         (  u06.u06_balance
                          + u06.u06_payable_blocked
                          - u06.u06_receivable_amount
                          - u06.u06_loan_amount)
                       - open_balance.h02_margin_utilized
                   ELSE
                       0
               END,                                      --h02_margin_utilized
               NVL (txn.t02_gainloss, 0),                       --h02_gainloss
               u06.u06_loan_amount                           --h02_loan_amount
          FROM u06_cash_account u06
               LEFT JOIN (  SELECT t02_cash_acnt_id_u06,
                                   SUM (NVL (commission, 0)) commission,
                                   SUM (NVL (buy, 0)) buy,
                                   SUM (NVL (sell, 0)) sell,
                                   SUM (NVL (deposits, 0)) deposits,
                                   SUM (NVL (withdrawals, 0)) withdrawals,
                                   SUM (NVL (other, 0)) other,
                                   SUM (NVL (t02_gainloss, 0)) AS t02_gainloss
                              FROM (SELECT t02.t02_cash_acnt_id_u06,
                                             NVL (t02.t02_commission_adjst, 0)
                                           * t02.t02_fx_rate
                                               AS commission,
                                           t02.t02_fx_rate,
                                           t02.t02_txn_code,
                                           CASE t02.t02_txn_code
                                               WHEN 'STLBUY'
                                               THEN
                                                   t02.t02_amnt_in_stl_currency
                                               ELSE
                                                   0
                                           END
                                               AS buy,
                                           CASE t02.t02_txn_code
                                               WHEN 'STLSEL'
                                               THEN
                                                   t02.t02_amnt_in_stl_currency
                                               ELSE
                                                   0
                                           END
                                               AS sell,
                                           CASE t02.t02_txn_code
                                               WHEN 'DEPOST'
                                               THEN
                                                   t02.t02_amnt_in_stl_currency
                                               ELSE
                                                   0
                                           END
                                               AS deposits,
                                           CASE t02.t02_txn_code
                                               WHEN 'WITHDR'
                                               THEN
                                                   t02.t02_amnt_in_stl_currency
                                               ELSE
                                                   0
                                           END
                                               AS withdrawals,
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
                                           END
                                               AS other,
                                           CASE
                                               WHEN t02.t02_txn_code NOT IN
                                                        ('STLBUY')
                                               THEN
                                                   t02.t02_gainloss
                                               ELSE
                                                   0
                                           END
                                               AS t02_gainloss
                                      FROM t02_transaction_log_cash_all t02
                                     WHERE t02.t02_create_date BETWEEN l_sysdate
                                                                   AND   l_sysdate
                                                                       + 0.99999)
                          GROUP BY t02_cash_acnt_id_u06) txn
                   ON u06.u06_id = txn.t02_cash_acnt_id_u06
               LEFT JOIN (SELECT h02.h02_cash_account_id_u06,
                                 h02.h02_balance,
                                 h02.h02_margin_utilized
                            FROM vw_h02_cash_account_summary h02
                           WHERE h02.h02_date = l_sysdate - 1) open_balance
                   ON u06.u06_id = open_balance.h02_cash_account_id_u06
               LEFT JOIN m02_institute m02
                   ON u06.u06_institute_id_m02 = m02.m02_id
               LEFT JOIN m177_cash_transfer_limit_group m177
                   ON u06.u06_transfer_limit_grp_id_m177 = m177.m177_id
         WHERE u06.u06_last_activity_date >= l_sysdate;
END;
/