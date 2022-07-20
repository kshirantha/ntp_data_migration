CREATE OR REPLACE PROCEDURE dfn_ntp.sp_gl_pre_validation (
    pdate                   IN DATE,
    pm136_currency_filter   IN m136_gl_event_categories.m136_currency_filter%TYPE,
    pm136_exchange_filter   IN m136_gl_event_categories.m136_exchange_filter%TYPE)
IS
    l_date   DATE := TRUNC (pdate);
BEGIN
    EXECUTE IMMEDIATE
           'INSERT INTO h24_gl_cash_account_summary (h24_date,
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
            SELECT TO_DATE ('''
        || TO_CHAR (l_date, 'DD/MM/YYYY')
        || ''', ''DD/MM/YYYY''),                        --h24_date
                   u06_id,                                       --h24_cash_account_id_u06
                   h24_settled_balance,                              --h24_opening_balance
                   deposits,                                                --h24_deposits
                   withdrawals,                                          --h24_withdrawals
                   buy,                                                          --h24_buy
                   sell,                                                        --h24_sell
                   charges,                                                  --h24_charges
                   refunds,                                                 --h24__refunds
                   brk_commission,                                 --h24_broker_commission
                   exg_commission,                                    --h24_exg_commission
                   u06_accrued_interest,                            --h24_accrued_interest
                   u06_balance,                                      --h24_settled_balance
                   u06_blocked,                                              --h24_blocked
                   u06_open_buy_blocked,                            --h24_open_buy_blocked
                   u06_pending_withdraw,                            --h24_pending_withdraw
                   u06_manual_trade_blocked,                    --h24_manual_trade_blocked
                   u06_manual_full_blocked,                      --h24_manual_full_blocked
                   u06_manual_transfer_blocked,              --h24_manual_transfer_blocked
                   u06_payable_blocked,                              --h24_payable_blocked
                   u06_receivable_amount                           --h24_receivable_amount
              FROM (SELECT u06.u06_id,
                           open_balance.h24_settled_balance,
                           txn.deposits,
                           txn.withdrawals,
                           txn.buy,
                           txn.sell,
                           txn.charges,
                           txn.refunds,
                           txn.brk_commission,
                           txn.exg_commission,
                           u06.u06_accrued_interest,
                           u06.u06_balance,
                           u06.u06_blocked,
                           u06.u06_open_buy_blocked,
                           u06.u06_pending_withdraw,
                           u06.u06_manual_trade_blocked,
                           u06.u06_manual_full_blocked,
                           u06.u06_manual_transfer_blocked,
                           u06.u06_payable_blocked,
                           u06.u06_receivable_amount,
                           u06.u06_currency_code_m03 AS currency_code_m03
                      FROM u06_cash_account u06
                           JOIN (  SELECT t02_cash_acnt_id_u06,
                                          SUM (NVL (buy, 0)) AS buy,
                                          SUM (NVL (sell, 0)) AS sell,
                                          SUM (NVL (deposits, 0)) AS deposits,
                                          SUM (NVL (withdrawals, 0)) AS withdrawals,
                                          SUM (
                                              CASE
                                                  WHEN NVL (other, 0) < 0
                                                  THEN
                                                      NVL (other, 0)
                                                  ELSE
                                                      0
                                              END)
                                              AS charges,
                                          SUM (
                                              CASE
                                                  WHEN NVL (other, 0) > 0
                                                  THEN
                                                      NVL (other, 0)
                                                  ELSE
                                                      0
                                              END)
                                              AS refunds,
                                          SUM (NVL (brk_commission, 0)) AS brk_commission,
                                          SUM (NVL (exg_commission, 0)) AS exg_commission
                                     FROM (SELECT t02.t02_cash_acnt_id_u06,
                                                  t02.t02_fx_rate,
                                                  t02.t02_txn_code,
                                                  CASE t02.t02_txn_code
                                                      WHEN ''STLBUY''
                                                      THEN
                                                          t02.t02_amnt_in_stl_currency
                                                      ELSE
                                                          0
                                                  END
                                                      AS buy,
                                                  CASE t02.t02_txn_code
                                                      WHEN ''STLSEL''
                                                      THEN
                                                          t02.t02_amnt_in_stl_currency
                                                      ELSE
                                                          0
                                                  END
                                                      AS sell,
                                                  CASE t02.t02_txn_code
                                                      WHEN ''DEPOST''
                                                      THEN
                                                          t02.t02_amnt_in_stl_currency
                                                      ELSE
                                                          0
                                                  END
                                                      AS deposits,
                                                  CASE t02.t02_txn_code
                                                      WHEN ''WITHDR''
                                                      THEN
                                                          t02.t02_amnt_in_stl_currency
                                                      ELSE
                                                          0
                                                  END
                                                      AS withdrawals,
                                                  CASE
                                                      WHEN t02.t02_txn_code NOT IN
                                                               (''STLBUY'',
                                                                ''STLSEL'',
                                                                ''DEPOST'',
                                                                ''WITHDR'')
                                                      THEN
                                                          t02.t02_amnt_in_stl_currency
                                                      ELSE
                                                          0
                                                  END
                                                      AS other,
                                                    t02.t02_cum_commission
                                                  - t02_exg_commission
                                                      AS brk_commission,
                                                  t02.t02_exg_commission AS exg_commission
                                             FROM t02_transaction_log_cash t02
                                            WHERE     t02.t02_create_date BETWEEN   TO_DATE ('''
        || TO_CHAR (l_date, 'DD/MM/YYYY')
        || ''',
                                                                                        ''DD/MM/YYYY'')
                                                                                  - fn_get_max_txn_stl_date_diff
                                                                              AND   TO_DATE ('''
        || TO_CHAR (l_date, 'DD/MM/YYYY')
        || ''',
                                                                                        ''DD/MM/YYYY'')
                                                                                  + 0.99999
                                                  AND t02.t02_cash_settle_date BETWEEN TO_DATE ('''
        || TO_CHAR (l_date, 'DD/MM/YYYY')
        || ''',
                                                                                           ''DD/MM/YYYY'')
                                                                                   AND   TO_DATE ('''
        || TO_CHAR (l_date, 'DD/MM/YYYY')
        || ''',
                                                                                             ''DD/MM/YYYY'')
                                                                                       + 0.99999)
                                 GROUP BY t02_cash_acnt_id_u06) txn
                               ON u06.u06_id = txn.t02_cash_acnt_id_u06
                           LEFT JOIN vw_h24_gl_cash_account_summary open_balance
                               ON     open_balance.h24_date =
                                          TO_DATE ('''
        || TO_CHAR (l_date, 'DD/MM/YYYY')
        || ''', ''DD/MM/YYYY'') - 1
                                  AND open_balance.h24_cash_account_id_u06 = u06.u06_id)'
        || CASE
               WHEN pm136_currency_filter IS NOT NULL
               THEN
                   ' WHERE ' || pm136_currency_filter
               ELSE
                   ''
           END;
END;
/