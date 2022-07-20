CREATE OR REPLACE 
PROCEDURE dfn_ntp.sp_corporate_action_process (txn_type        IN NUMBER,
                                       position_date   IN VARCHAR,
                                       catype          IN NUMBER,
                                       exchange_id     IN VARCHAR,
                                       instituteid     IN NUMBER,
                                       tenat_code      IN VARCHAR,
                                       app_server_id   IN VARCHAR,
                                       action_type     IN NUMBER,
                                       channel         IN NUMBER)
IS
    l_posteddate              DATE;
    l_stock_insert_t09        NUMBER (1) := 0;
    l_pledge_insert_t09       NUMBER (1) := 0;
    l_trn_type                NUMBER (2) := 0;
    l_record_count            NUMBER (10) := 0;
    l_commit_blk_size         NUMBER (10) := 5000;
    l_counter                 NUMBER (10) := 0;
    l_tranid                  VARCHAR (50);
    l_auditkey                VARCHAR2 (200);
    l_referncenumber          VARCHAR2 (20);
    l_master_ref_id           VARCHAR (50);
    l_t25_custodian_id_m26    t25_stock_transfer.t25_custodian_id_m26%TYPE
                                  := -1;
    l_t25_account             t25_stock_transfer.t25_account%TYPE := '-1';
    l_t25_exchange            t25_stock_transfer.t25_exchange%TYPE := '-1';
    l_t25_symbol              t25_stock_transfer.t25_symbol%TYPE := '-1';
    l_t25_owned_quantity      t25_stock_transfer.t25_owned_quantity%TYPE := 0;
    l_t25_pledged_quantity    t25_stock_transfer.t25_pledged_quantity%TYPE
                                  := 0;

    l_u24_pledge_qty          u24_holdings.u24_pledge_qty%TYPE := 0;
    l_u24_net_holding         u24_holdings.u24_net_holding%TYPE := 0;
    l_u24_holding_avg_cost    u24_holdings.u24_avg_cost%TYPE := 0;
    l_u24_holding_avg_price   u24_holdings.u24_avg_price%TYPE := 0;
    l_u24_weighted_avgprice   u24_holdings.u24_weighted_avg_price%TYPE := 0;
    l_u24_weighted_avgcost    u24_holdings.u24_weighted_avg_cost%TYPE := 0;
    l_u24_subscribe_qty       u24_holdings.u24_subscribed_qty%TYPE := 0;
    l_u24_lock_seq            u24_holdings.u24_ordexecseq%TYPE := 0;
BEGIN
    l_posteddate := TO_DATE (position_date, 'YYYYMMDD');

    SELECT    TRUNC ( (SYSDATE - TO_DATE ('1-Jan-1970')) * 86400)
           || LPAD (TO_CHAR (SYSTIMESTAMP, 'FF3'), 3, '0')
      INTO l_tranid
      FROM DUAL;


    --------------------- PROCESS CORPORATE ACTION - GET TABLE DATA TO CURSOR ---------------------------------------------------
    --------------------- (T23 / T42/ T43 / T25 TRANSACTION TABLES) -------------------------------------------------------------
    DECLARE
        CURSOR c_corporate_action_entries
        IS
            SELECT ca.*
              ------------------------ FOR CORPORATE ACTION AND WEEKLY CORPORATE ACTION HOLDINGS --------------------------------
              FROM (SELECT l_tranid + ROWNUM AS transid,
                           t23.t23_id AS id,
                           t23.t23_current_balance_difference
                               AS holding_balance,
                           NULL AS pledged_quantity,
                           t23.t23_trading_acc_id_u07 AS trading_acc_id_u07,
                           NULL AS exchange_acc_no_u07,
                           t23.t23_custodian_id_m26 AS custodian_id_m26,
                           t23.t23_file_symbol AS symbol_code_m20,
                           vw_symbol.m20_id AS symbol_id_m20,
                           NULL AS exchange_m01,
                           TO_CHAR (t23.t23_status_changed_by_id_u17)
                               AS status_changed_by_id_u17,
                           t23.t23_status_changed_date AS status_change_date,
                           t23.t23_primary_institute_id_m02 AS institute_id,
                           1 AS avg_price,
                           0 AS transaction_fee,
                           0 AS transaction_type,
                           NULL AS trans_code,
                           NULL AS trans_sub_code,
                           t23.t23_no_of_approval AS no_of_approval,
                           NULL AS amnt_in_stl_currency,
                           NULL AS amnt_in_txn_currency,
                           NULL AS adj_mode,
                           NULL AS cash_account_id_u066,
                           NULL AS fx_rate,
                           NULL AS customer_id_u011,
                           NULL AS narration,
                           m01.m01_id AS exchange_id_m01,
                           m01.m01_exchange_code AS exchange_code_m01,
                           u07.u07_cash_account_id_u06 AS cash_account_id_u06,
                           u07.u07_institute_id_m02 AS institute_id_m02,
                           u07.u07_customer_no_u01 AS customer_no_u01,
                           u06.u06_currency_code_m03 AS currency_code_m03,
                           NULL AS cash_block_u06,
                           NULL AS cash_balance_u06,
                           NULL AS payable_blocked_u06,
                           NULL AS receivable_amount_u06,
                           NULL AS open_buy_blocked_u06,
                           NULL AS pending_deposit_u06,
                           NULL AS pending_withdraw_u06,
                           NULL AS settle_currency_code_m03,
                           NULL AS cum_transfer_value_u06,
                           NULL AS incident_overdrawn_amt_u06,
                           NULL AS withdr_overdrawn_amt_u06,
                           NULL AS initial_margin_u06,
                           NULL AS maintain_margin_charged_u06,
                           NULL AS maintain_margin_block_u06,
                           NULL AS cum_buy_order_value_u06,
                           NULL AS cum_sell_order_value_u06,
                           0 AS loan_amount_u06,
                           TO_NUMBER ( (NVL (u24.u24_ordexecseq, 0)) + 1)
                               AS lockseq,
                           u24.u24_trading_acnt_id_u07 AS trading_acnt_id_u07,
                           u24.u24_net_holding AS net_holding_u24,
                           u24.u24_holding_block AS holding_block_u24,
                           u24.u24_sell_pending AS sell_pending_u24,
                           u24.u24_buy_pending AS buy_pending_u24,
                           u24.u24_payable_holding AS payable_holding_u24,
                           u24.u24_receivable_holding
                               AS receivable_holding_u24,
                           u24.u24_pledge_qty AS pledge_qty_u24,
                           u24.u24_weighted_avg_price
                               AS weighted_avg_price_u24,
                           u24.u24_avg_price AS avg_price_u24,
                           u24.u24_weighted_avg_cost AS weighted_avg_cost_u24,
                           u24.u24_avg_cost AS avg_cost_u24,
                           u24.u24_realized_gain_lost AS gain_lost_u24,
                           u24.u24_subscribed_qty AS subscribed_qty_u24,
                           u24.u24_pending_subscribe_qty
                               AS pending_subscribe_qty_u24,
                           m88.m88_id AS functional_approval_id_m88,
                           m88.m88_approval_levels AS number_of_approval,
                           m88_default.m88_id AS approval_default_m88,
                           m88_default.m88_approval_levels
                               AS number_of_default_approval,
                           m97.m97_id,
                           m97.m97_code AS txn_code,
                           m97.m97_category,
                           NVL (m98.m98_b2b_enabled, 0) is_b2b_enabled,
                           m97.m97_txn_impact_type AS txn_impact_type,
                           'T23' AS ref_type,
                           CASE
                               WHEN t23.t23_current_balance_difference > 0
                               THEN
                                   +1
                               ELSE
                                   -1
                           END
                               AS sign_factor
                      FROM t23_share_txn_requests t23
                           LEFT JOIN u07_trading_account u07
                               ON u07.u07_id = t23.t23_trading_acc_id_u07
                           LEFT JOIN u06_cash_account u06
                               ON u06.u06_id = u07.u07_cash_account_id_u06
                           LEFT JOIN m01_exchanges m01
                               ON t23.t23_exchange_id_m01 = m01.m01_id
                           LEFT JOIN u24_holdings u24
                               ON     t23.t23_trading_acc_id_u07 =
                                          u24.u24_trading_acnt_id_u07
                                  AND t23.t23_custodian_id_m26 =
                                          u24.u24_custodian_id_m26
                                  AND m01.m01_exchange_code =
                                          u24.u24_exchange_code_m01
                                  AND t23.t23_file_symbol =
                                          u24.u24_symbol_code_m20
                           LEFT JOIN m97_transaction_codes m97
                               ON m97.m97_code =
                                      CASE
                                          WHEN t23.t23_current_balance_difference >
                                                   0
                                          THEN
                                              'HLDDEPOST'
                                          ELSE
                                              'HLDWITHDR'
                                      END
                           LEFT JOIN (SELECT *
                                        FROM m98_institution_txn_codes m98
                                       WHERE m98.m98_institution_id_m02 = instituteid) m98
                               ON m98.m98_transaction_code_id_m97 =
                                      m97.m97_id
                           LEFT JOIN m88_function_approval m88
                               ON     m88.m88_txn_code = m97.m97_code
                                  AND m88.m88_channel_id_v29 = channel
                           LEFT JOIN m88_function_approval m88_default
                               ON     m88_default.m88_function = 'CHRREF'
                                  AND m88_default.m88_channel_id_v29 = -1
                           LEFT JOIN vw_symbol_data vw_symbol
                               ON     m20_symbol_code = t23.t23_file_symbol
                                  AND m20_exchange_code_m01 =
                                          m01.m01_exchange_code
                                  AND m20_institute_id_m02 = instituteid
                     WHERE     t23_type = txn_type
                           AND t23_position_date = l_posteddate
                           AND t23_reference = catype
                           AND t23.t23_primary_institute_id_m02 = instituteid
                           AND t23_current_approval_level =
                                   t23_no_of_approval - 1
                           AND t23_status_id_v01 NOT IN (2, 3, 17)
                           AND action_type = 1 -- FOR CA RECONCILATION HOLDINGS ACTION TYPE = 1
                    UNION ALL
                    SELECT l_tranid + ROWNUM AS transid,
                           t23.t23_id AS id,
                           t23.t23_current_balance_difference
                               AS holding_balance,
                           NULL AS pledged_quantity,
                           t23.t23_trading_acc_id_u07 AS trading_acc_id_u07,
                           NULL AS exchange_acc_no_u07,
                           t23.t23_custodian_id_m26 AS custodian_id_m26,
                           t23.t23_file_symbol AS symbol_code_m20,
                           vw_symbol.m20_id AS symbol_id_m20,
                           NULL AS exchange_m01,
                           TO_CHAR (t23.t23_status_changed_by_id_u17)
                               AS status_changed_by_id_u17,
                           t23.t23_status_changed_date AS status_change_date,
                           t23.t23_primary_institute_id_m02 AS institute_id,
                           1 AS avg_price,
                           0 AS transaction_fee,
                           0 AS transaction_type,
                           NULL AS trans_code,
                           NULL AS trans_sub_code,
                           t23.t23_no_of_approval AS no_of_approval,
                           NULL AS amnt_in_stl_currency,
                           NULL AS amnt_in_txn_currency,
                           NULL AS adj_mode,
                           NULL AS cash_account_id_u066,
                           NULL AS fx_rate,
                           NULL AS customer_id_u011,
                           NULL AS narration,
                           m01.m01_id AS exchange_id_m01,
                           m01.m01_exchange_code AS exchange_code_m01,
                           u07.u07_cash_account_id_u06 AS cash_account_id_u06,
                           u07.u07_institute_id_m02 AS institute_id_m02,
                           u07.u07_customer_no_u01 AS customer_no_u01,
                           u06.u06_currency_code_m03 AS currency_code_m03,
                           NULL AS cash_block_u06,
                           NULL AS cash_balance_u06,
                           NULL AS payable_blocked_u06,
                           NULL AS receivable_amount_u06,
                           NULL AS open_buy_blocked_u06,
                           NULL AS pending_deposit_u06,
                           NULL AS pending_withdraw_u06,
                           NULL AS settle_currency_code_m03,
                           NULL AS cum_transfer_value_u06,
                           NULL AS incident_overdrawn_amt_u06,
                           NULL AS withdr_overdrawn_amt_u06,
                           NULL AS initial_margin_u06,
                           NULL AS maintain_margin_charged_u06,
                           NULL AS maintain_margin_block_u06,
                           NULL AS cum_buy_order_value_u06,
                           NULL AS cum_sell_order_value_u06,
                           0 AS loan_amount_u06,
                           TO_NUMBER ( (NVL (u24.u24_ordexecseq, 0)) + 1)
                               AS lockseq,
                           u24.u24_trading_acnt_id_u07 AS trading_acnt_id_u07,
                           u24.u24_net_holding AS net_holding_u24,
                           u24.u24_holding_block AS holding_block_u24,
                           u24.u24_sell_pending AS sell_pending_u24,
                           u24.u24_buy_pending AS buy_pending_u24,
                           u24.u24_payable_holding AS payable_holding_u24,
                           u24.u24_receivable_holding
                               AS receivable_holding_u24,
                           u24.u24_pledge_qty AS pledge_qty_u24,
                           u24.u24_weighted_avg_price
                               AS weighted_avg_price_u24,
                           u24.u24_avg_price AS avg_price_u24,
                           u24.u24_weighted_avg_cost AS weighted_avg_cost_u24,
                           u24.u24_avg_cost AS avg_cost_u24,
                           u24.u24_realized_gain_lost AS gain_lost_u24,
                           u24.u24_subscribed_qty AS subscribed_qty_u24,
                           u24.u24_pending_subscribe_qty
                               AS pending_subscribe_qty_u24,
                           m88.m88_id AS functional_approval_id_m88,
                           m88.m88_approval_levels AS number_of_approval,
                           m88_default.m88_id AS approval_default_m88,
                           m88_default.m88_approval_levels
                               AS number_of_default_approval,
                           m97.m97_id,
                           m97.m97_code AS txn_code,
                           m97.m97_category,
                           NVL (m98.m98_b2b_enabled, 0) is_b2b_enabled,
                           m97.m97_txn_impact_type AS txn_impact_type,
                           'T23' AS ref_type,
                           CASE
                               WHEN t23.t23_current_balance_difference > 0
                               THEN
                                   +1
                               ELSE
                                   -1
                           END
                               AS sign_factor
                      FROM t23_share_txn_requests t23
                           JOIN u07_trading_account u07
                               ON u07.u07_id = t23.t23_trading_acc_id_u07
                           JOIN u06_cash_account u06
                               ON u06.u06_id = u07.u07_cash_account_id_u06
                           JOIN m01_exchanges m01
                               ON t23.t23_exchange_id_m01 = m01.m01_id
                           LEFT OUTER JOIN u24_holdings u24
                               ON     t23.t23_trading_acc_id_u07 =
                                          u24.u24_trading_acnt_id_u07
                                  AND t23.t23_custodian_id_m26 =
                                          u24.u24_custodian_id_m26
                                  AND m01.m01_exchange_code =
                                          u24.u24_exchange_code_m01
                                  AND t23.t23_file_symbol =
                                          u24.u24_symbol_code_m20
                           LEFT JOIN m97_transaction_codes m97
                               ON m97.m97_code =
                                      CASE
                                          WHEN t23.t23_current_balance_difference >
                                                   0
                                          THEN
                                              'HLDDEPOST'
                                          ELSE
                                              'HLDWITHDR'
                                      END
                           LEFT JOIN (SELECT *
                                        FROM m98_institution_txn_codes m98
                                       WHERE m98.m98_institution_id_m02 = instituteid) m98
                               ON m98.m98_transaction_code_id_m97 =
                                      m97.m97_id
                           LEFT JOIN m88_function_approval m88
                               ON     m88.m88_txn_code = m97.m97_code
                                  AND m88.m88_channel_id_v29 = channel
                           LEFT JOIN m88_function_approval m88_default
                               ON     m88_default.m88_function = 'CHRREF'
                                  AND m88_default.m88_channel_id_v29 = -1
                           LEFT JOIN vw_symbol_data vw_symbol
                               ON     m20_symbol_code = t23.t23_file_symbol
                                  AND m20_exchange_code_m01 =
                                          m01.m01_exchange_code
                                  AND m20_institute_id_m02 = instituteid
                     WHERE     t23.t23_exchange_id_m01 = m01.m01_id
                           AND t23_type = txn_type
                           AND t23_position_date = l_posteddate
                           AND m01.m01_id = exchange_id
                           AND t23.t23_primary_institute_id_m02 = instituteid
                           AND t23_current_approval_level =
                                   t23_no_of_approval - 1
                           AND t23_status_id_v01 NOT IN (2, 3)
                           AND action_type = 1 -- FOR WEEKLY RECONCILATION HOLDINGS ACTION TYPE = 1
                    UNION ALL
                    ------------------------ FOR INTERNATIONAL CORPORATE ACTION HOLDINGS --------------------------------------
                    SELECT l_tranid + ROWNUM AS transid,
                           t42.t42_id AS id,
                           CASE
                               WHEN t42_adj_mode = 1
                               THEN
                                   t42.t42_approved_quantity
                               ELSE
                                   t42.t42_approved_quantity * -1
                           END
                               AS holding_balance,
                           NULL AS pledged_quantity,
                           t42.t42_trading_acc_id_u07 AS trading_acc_id_u07,
                           NULL AS exchange_acc_no_u07,
                           t42.t42_custodian_id_m26 AS custodian_id_m26,
                           t42.t42_symbol_code_m20 AS symbol_code_m20,
                           vw_symbol.m20_id AS symbol_id_m20,
                           NULL AS exchange_m01,
                           TO_CHAR (t41.t41_modified_by_id_u17)
                               AS status_changed_by_id_u17,
                           t41.t41_created_date AS status_change_date,
                           t42.t42_institute_id_m02 AS institute_id,
                           t42.t42_avg_cost AS avg_price,
                           0 AS transaction_fee,
                           0 AS transaction_type,
                           NULL AS trans_code,
                           NULL AS trans_sub_code,
                           NULL AS no_of_approval,
                           NULL AS amnt_in_stl_currency,
                           NULL AS amnt_in_txn_currency,
                           t42.t42_adj_mode AS adj_mode,
                           NULL AS cash_account_id_u066,
                           NULL AS fx_rate,
                           NULL AS customer_id_u011,
                           NULL AS narration,
                           m01.m01_id AS exchange_id_m01,
                           m01.m01_exchange_code AS exchange_code_m01,
                           u07.u07_cash_account_id_u06 AS cash_account_id_u06,
                           u07.u07_institute_id_m02 AS institute_id_m02,
                           u07.u07_customer_no_u01 AS customer_no_u01,
                           u06.u06_currency_code_m03 AS currency_code_m03,
                           NULL AS cash_block_u06,
                           NULL AS cash_balance_u06,
                           NULL AS payable_blocked_u06,
                           NULL AS receivable_amount_u06,
                           NULL AS open_buy_blocked_u06,
                           NULL AS pending_deposit_u06,
                           NULL AS pending_withdraw_u06,
                           NULL AS settle_currency_code_m03,
                           NULL AS cum_transfer_value_u06,
                           NULL AS incident_overdrawn_amt_u06,
                           NULL AS withdr_overdrawn_amt_u06,
                           NULL AS initial_margin_u06,
                           NULL AS maintain_margin_charged_u06,
                           NULL AS maintain_margin_block_u06,
                           NULL AS cum_buy_order_value_u06,
                           NULL AS cum_sell_order_value_u06,
                           0 AS loan_amount_u06,
                           TO_NUMBER ( (NVL (u24.u24_ordexecseq, 0)) + 1)
                               AS lockseq,
                           u24.u24_trading_acnt_id_u07 AS trading_acnt_id_u07,
                           u24.u24_net_holding AS net_holding_u24,
                           u24.u24_holding_block AS holding_block_u24,
                           u24.u24_sell_pending AS sell_pending_u24,
                           u24.u24_buy_pending AS buy_pending_u24,
                           u24.u24_payable_holding AS payable_holding_u24,
                           u24.u24_receivable_holding
                               AS receivable_holding_u24,
                           u24.u24_pledge_qty AS pledge_qty_u24,
                           u24.u24_weighted_avg_price
                               AS weighted_avg_price_u24,
                           u24.u24_avg_price AS avg_price_u24,
                           u24.u24_weighted_avg_cost AS weighted_avg_cost_u24,
                           u24.u24_avg_cost AS avg_cost_u24,
                           u24.u24_realized_gain_lost AS gain_lost_u24,
                           u24.u24_subscribed_qty AS subscribed_qty_u24,
                           u24.u24_pending_subscribe_qty
                               AS pending_subscribe_qty_u24,
                           m88.m88_id AS functional_approval_id_m88,
                           m88.m88_approval_levels AS number_of_approval,
                           m88_default.m88_id AS approval_default_m88,
                           m88_default.m88_approval_levels
                               AS number_of_default_approval,
                           m97.m97_id,
                           m97.m97_code AS txn_code,
                           m97.m97_category,
                           NVL (m98.m98_b2b_enabled, 0) is_b2b_enabled,
                           m97.m97_txn_impact_type AS txn_impact_type,
                           'T42' AS ref_type,
                           CASE
                               WHEN t42.t42_adj_mode = 1 THEN +1
                               ELSE -1
                           END
                               AS sign_factor
                      FROM t42_cust_corp_act_hold_adjust t42
                           JOIN t41_cust_corp_act_distribution t41
                               ON t42.t42_cust_distr_id_t41 = t41.t41_id
                           JOIN u07_trading_account u07
                               ON u07.u07_id = t41.t41_trading_acc_id_u07
                           JOIN u06_cash_account u06
                               ON u06.u06_id = t41.t41_cash_acc_id_u06
                           JOIN m01_exchanges m01
                               ON m01.m01_id = t42.t42_exchange_id_m01
                           LEFT OUTER JOIN u24_holdings u24
                               ON     t42.t42_trading_acc_id_u07 =
                                          u24.u24_trading_acnt_id_u07
                                  AND t42.t42_custodian_id_m26 =
                                          u24.u24_custodian_id_m26
                                  AND m01.m01_exchange_code =
                                          u24.u24_exchange_code_m01
                                  AND t42.t42_symbol_code_m20 =
                                          u24.u24_symbol_code_m20
                           LEFT JOIN m97_transaction_codes m97
                               ON m97.m97_code =
                                      CASE
                                          WHEN t42.t42_adj_mode = 1
                                          THEN
                                              'HLDDEPOST'
                                          ELSE
                                              'HLDWITHDR'
                                      END
                           LEFT JOIN (SELECT *
                                        FROM m98_institution_txn_codes m98
                                       WHERE m98.m98_institution_id_m02 = instituteid) m98
                               ON m98.m98_transaction_code_id_m97 =
                                      m97.m97_id
                           LEFT JOIN m88_function_approval m88
                               ON     m88.m88_txn_code = m97.m97_code
                                  AND m88.m88_channel_id_v29 = channel
                           LEFT JOIN m88_function_approval m88_default
                               ON     m88_default.m88_function = 'CHRREF'
                                  AND m88_default.m88_channel_id_v29 = -1
                           LEFT JOIN vw_symbol_data vw_symbol
                               ON     m20_symbol_code =
                                          t42.t42_symbol_code_m20
                                  AND m20_exchange_code_m01 =
                                          m01.m01_exchange_code
                                  AND m20_institute_id_m02 = instituteid
                     WHERE     t41.t41_cust_corp_act_id_m141 = catype
                           AND t42.t42_institute_id_m02 = instituteid
                           AND t42.t42_status_id_v01 = 2
                           AND action_type = 2 -- FOR INTERNATIONAL RECONCILATION HOLDINGS ACTION TYPE = 2
                    UNION ALL
                    ------------------------ FOR INTERNATIONAL CORPORATE ACTION CASH -------------------------------------------
                    SELECT l_tranid + ROWNUM AS transid,
                           t43.t43_id AS id,
                           NULL AS holding_balance,
                           NULL AS pledged_quantity,
                           NULL AS trading_acc_id_u07,
                           NULL AS exchange_acc_no_u07,
                           NULL AS custodian_id_m26,
                           NULL AS symbol_code_m20,
                           NULL AS symbol_id_m20,
                           NULL AS exchange_m01,
                           TO_CHAR (t41.t41_created_by_id_u17)
                               AS status_changed_by_id_u17,
                           t41.t41_created_date AS status_change_date,
                           t43.t43_institute_id_m02 AS institute_id,
                           NULL AS avg_price,
                           0 AS transaction_fee,
                           0 AS transaction_type,
                           NULL AS trans_code,
                           NULL AS trans_sub_code,
                           NULL AS no_of_approval,
                           CASE
                               WHEN t43_adj_mode = 1
                               THEN
                                   t43.t43_amnt_in_stl_currency * -1
                               ELSE
                                   t43.t43_amnt_in_stl_currency
                           END
                               AS amnt_in_stl_currency,
                           CASE
                               WHEN t43_adj_mode = 1
                               THEN
                                   t43.t43_amnt_in_txn_currency * -1
                               ELSE
                                   t43.t43_amnt_in_txn_currency
                           END
                               AS amnt_in_txn_currency,
                           t43.t43_adj_mode AS adj_mode,
                           t43.t43_cash_account_id_u06
                               AS cash_account_id_u066,
                           t43.t43_fx_rate AS fx_rate,
                           t41.t41_customer_id_u01 AS customer_id_u011,
                           t43_narration AS narration,
                           NULL AS exchange_id_m01,
                           NULL AS exchange_code_m01,
                           u07.u07_cash_account_id_u06 AS cash_account_id_u06,
                           u07.u07_institute_id_m02 AS institute_id_m02,
                           u07.u07_customer_no_u01 AS customer_no_u01,
                           u06.u06_currency_code_m03 AS currency_code_m03,
                           u06.u06_blocked AS cash_block_u06,
                           u06.u06_balance AS cash_balance_u06,
                           u06.u06_payable_blocked AS payable_blocked_u06,
                           u06.u06_receivable_amount AS receivable_amount_u06,
                           u06.u06_open_buy_blocked AS open_buy_blocked_u06,
                           u06.u06_pending_deposit AS pending_deposit_u06,
                           u06.u06_pending_withdraw AS pending_withdraw_u06,
                           u06.u06_currency_code_m03
                               AS settle_currency_code_m03,
                           u06.u06_cum_transfer_value
                               AS cum_transfer_value_u06,
                           u06_incident_overdrawn_amt
                               AS incident_overdrawn_amt_u06,
                           u06_withdr_overdrawn_amt
                               AS withdr_overdrawn_amt_u06,
                           u06_initial_margin AS initial_margin_u06,
                           u06_maintain_margin_charged
                               AS maintain_margin_charged_u06,
                           u06_maintain_margin_block
                               AS maintain_margin_block_u06,
                           u06_cum_buy_order_value AS cum_buy_order_value_u06,
                           u06_cum_sell_order_value
                               AS cum_sell_order_value_u06,
                           u06_loan_amount AS loan_amount_u06,
                           TO_NUMBER ( (NVL (u06.u06_ordexecseq, 0)) + 1)
                               AS lockseq,
                           NULL AS trading_acnt_id_u07,
                           NULL AS net_holding_u24,
                           NULL AS holding_block_u24,
                           NULL AS sell_pending_u24,
                           NULL AS buy_pending_u24,
                           NULL AS payable_holding_u24,
                           NULL AS receivable_holding_u24,
                           NULL AS pledge_qty_u24,
                           NULL AS weighted_avg_price_u24,
                           NULL AS avg_price_u24,
                           NULL AS weighted_avg_cost_u24,
                           NULL AS avg_cost_u24,
                           NULL AS gain_lost_u24,
                           NULL AS subscribed_qty_u24,
                           NULL AS pending_subscribe_qty_u24,
                           m88.m88_id AS functional_approval_id_m88,
                           m88.m88_approval_levels AS number_of_approval,
                           m88_default.m88_id AS approval_default_m88,
                           m88_default.m88_approval_levels
                               AS number_of_default_approval,
                           m97.m97_id,
                           m97.m97_code AS txn_code,
                           m97.m97_category,
                           NVL (m98.m98_b2b_enabled, 0) is_b2b_enabled,
                           m97.m97_txn_impact_type AS txn_impact_type,
                           'T43' AS ref_type,
                           NULL AS sign_factor
                      FROM t43_cust_corp_act_cash_adjust t43
                           LEFT JOIN t41_cust_corp_act_distribution t41
                               ON t43.t43_cust_distr_id_t41 = t41.t41_id
                           LEFT JOIN u07_trading_account u07
                               ON u07.u07_id = t41.t41_trading_acc_id_u07
                           LEFT JOIN u06_cash_account u06
                               ON u06.u06_id = t41.t41_cash_acc_id_u06
                           LEFT JOIN m97_transaction_codes m97
                               ON m97.m97_code =
                                      CASE
                                          WHEN t43.t43_adj_mode = 1
                                          THEN
                                              'CHARGE'
                                          ELSE
                                              'REFUND'
                                      END
                           LEFT JOIN (SELECT *
                                        FROM m98_institution_txn_codes m98
                                       WHERE m98.m98_institution_id_m02 = instituteid) m98
                               ON m98.m98_transaction_code_id_m97 =
                                      m97.m97_id
                           LEFT JOIN m88_function_approval m88
                               ON     m88.m88_txn_code = m97.m97_code
                                  AND m88.m88_channel_id_v29 = channel
                           LEFT JOIN m88_function_approval m88_default
                               ON     m88_default.m88_function = 'CHRREF'
                                  AND m88_default.m88_channel_id_v29 = -1
                     WHERE     t41.t41_cust_corp_act_id_m141 = catype
                           AND t43.t43_institute_id_m02 = instituteid
                           AND t43.t43_status_id_v01 = 2
                           AND action_type = 3 -- FOR INTERNATIONAL RECONCILATION CASH ACTION TYPE = 3
                    UNION ALL
                    ------------------------ FOR DAILLY FTTP FILE (B-FILE) ------------------------------------------------------------
                    SELECT l_tranid + ROWNUM AS transid,
                           t25.t25_id AS id,
                           t25.t25_owned_quantity AS holding_balance,
                           t25.t25_pledged_quantity AS pledged_quantity,
                           u07.u07_id AS trading_acc_id_u07,
                           t25.t25_account AS exchange_acc_no_u07,
                           t25.t25_custodian_id_m26 AS custodian_id_m26,
                           t25.t25_symbol AS symbol_code_m20,
                           vw_symbol.m20_id AS symbol_id_m20,
                           t25.t25_exchange AS exchange_m01,
                           t25.t25_approved_by AS status_changed_by_id_u17,
                           t25.t25_last_updated AS status_change_date,
                           t25.t25_institute_id_m02 AS institute_id,
                           t25.t25_price AS avg_price,
                           0 AS transaction_fee,
                           0 AS transaction_type, -----------> ALTER IF ADDED IN T25 TABLE CURRENTLY SET TO 0 (HOLDING TRASACTION TYPE)
                           t25.t25_trans_code AS trans_code,
                           t25.t25_trans_sub_code AS trans_sub_code,
                           NULL AS no_of_approval,
                           NULL AS amnt_in_stl_currency,
                           NULL AS amnt_in_txn_currency,
                           NULL AS adj_mode,
                           NULL AS cash_account_id_u066,
                           NULL AS fx_rate,
                           NULL AS customer_id_u011,
                           NULL AS narration,
                           m01.m01_id AS exchange_id_m01,
                           m01.m01_exchange_code AS exchange_code_m01,
                           u07.u07_cash_account_id_u06 AS cash_account_id_u06,
                           u07.u07_institute_id_m02 AS institute_id_m02,
                           u07.u07_customer_no_u01 AS customer_no_u01,
                           u06.u06_currency_code_m03 AS currency_code_m03,
                           NULL AS cash_block_u06,
                           NULL AS cash_balance_u06,
                           NULL AS payable_blocked_u06,
                           NULL AS receivable_amount_u06,
                           NULL AS open_buy_blocked_u06,
                           NULL AS pending_deposit_u06,
                           NULL AS pending_withdraw_u06,
                           NULL AS settle_currency_code_m03,
                           NULL AS cum_transfer_value_u06,
                           NULL AS incident_overdrawn_amt_u06,
                           NULL AS withdr_overdrawn_amt_u06,
                           NULL AS initial_margin_u06,
                           NULL AS maintain_margin_charged_u06,
                           NULL AS maintain_margin_block_u06,
                           NULL AS cum_buy_order_value_u06,
                           NULL AS cum_sell_order_value_u06,
                           0 AS loan_amount_u06,
                           TO_NUMBER ( (NVL (u24.u24_ordexecseq, 0))) + 1
                               AS lockseq,
                           u24.u24_trading_acnt_id_u07 AS trading_acnt_id_u07,
                           u24.u24_net_holding AS net_holding_u24,
                           u24.u24_holding_block AS holding_block_u24,
                           u24.u24_sell_pending AS sell_pending_u24,
                           u24.u24_buy_pending AS buy_pending_u24,
                           u24.u24_payable_holding AS payable_holding_u24,
                           u24.u24_receivable_holding
                               AS receivable_holding_u24,
                           u24.u24_pledge_qty AS pledge_qty_u24,
                           u24.u24_weighted_avg_price
                               AS weighted_avg_price_u24,
                           u24.u24_avg_price AS avg_price_u24,
                           u24.u24_weighted_avg_cost AS weighted_avg_cost_u24,
                           u24.u24_avg_cost AS avg_cost_u24,
                           u24.u24_realized_gain_lost AS gain_lost_u24,
                           u24.u24_subscribed_qty AS subscribed_qty_u24,
                           u24.u24_pending_subscribe_qty
                               AS pending_subscribe_qty_u24,
                           m88.m88_id AS functional_approval_id_m88,
                           m88.m88_approval_levels AS number_of_approval,
                           m88_default.m88_id AS approval_default_m88,
                           m88_default.m88_approval_levels
                               AS number_of_default_approval,
                           m97.m97_id,
                           m97.m97_code AS txn_code,
                           m97.m97_category,
                           NVL (m98.m98_b2b_enabled, 0) is_b2b_enabled,
                           m97.m97_txn_impact_type AS txn_impact_type,
                           'T25' AS ref_type,
                           CASE
                               WHEN t25.t25_owned_quantity > 0 THEN +1
                               ELSE -1
                           END
                               AS sign_factor
                      FROM t25_stock_transfer t25
                           LEFT JOIN u07_trading_account u07
                               ON u07.u07_exchange_account_no =
                                      t25.t25_account
                           LEFT JOIN u06_cash_account u06
                               ON u06.u06_id = u07.u07_cash_account_id_u06
                           LEFT JOIN m01_exchanges m01
                               ON m01.m01_id = t25.t25_institute_id_m02
                           LEFT JOIN u24_holdings u24
                               ON     t25.t25_account =
                                          u24.u24_trading_acnt_id_u07
                                  AND t25.t25_custodian_id_m26 = u24.u24_custodian_id_m26
                                  AND m01.m01_exchange_code =
                                          u24.u24_exchange_code_m01
                                  AND t25.t25_symbol =
                                          u24.u24_symbol_code_m20
                           LEFT JOIN m97_transaction_codes m97
                               ON m97.m97_code =
                                      CASE
                                          WHEN t25.t25_trans_code = 350
                                          THEN
                                              CASE
                                                  WHEN t25.t25_owned_quantity >
                                                           0
                                                  THEN
                                                      'PLGIN'
                                                  ELSE
                                                      'PLGOUT'
                                              END
                                          ELSE
                                              CASE
                                                  WHEN t25.t25_pledged_quantity >
                                                           0
                                                  THEN
                                                      'HLDDEPOST'
                                                  ELSE
                                                      'HLDWITHDR'
                                              END
                                      END
                           LEFT JOIN (SELECT *
                                        FROM m98_institution_txn_codes m98
                                       WHERE m98.m98_institution_id_m02 = instituteid) m98
                               ON m98.m98_transaction_code_id_m97 =
                                      m97.m97_id
                           LEFT JOIN m88_function_approval m88
                               ON     m88.m88_txn_code = m97.m97_code
                                  AND m88.m88_channel_id_v29 = channel
                           LEFT JOIN m88_function_approval m88_default
                               ON     m88_default.m88_function = 'CHRREF'
                                  AND m88_default.m88_channel_id_v29 = -1
                           LEFT JOIN vw_symbol_data vw_symbol
                               ON     m20_symbol_code = t25.t25_symbol
                                  AND m20_exchange_code_m01 =
                                          m01.m01_exchange_code
                                  AND m20_institute_id_m02 = instituteid
                     WHERE     t25.t25_status = 0
                           AND t25.t25_institute_id_m02 = instituteid
                           AND action_type = 4 -- FOR B-FILE ACTION TYPE = 4
                    ORDER BY custodian_id_m26,
                             exchange_acc_no_u07,
                             symbol_code_m20) ca;
    BEGIN
        FOR i IN c_corporate_action_entries
        LOOP
            ------------------------------------------------  GENERATE BULK MASTER ID FOR EACH CHUNK OPERATION ------------------------
            IF MOD (l_record_count, l_commit_blk_size) = 0
            THEN
                l_master_ref_id :=
                    TO_CHAR (l_counter) || '_' || TO_CHAR (i.transid);
                l_counter := l_counter + 1;
            END IF;

            ------------------------------------------------  END GENERATING BULK MASTER ID ------------------------------------------

            ------------------------------------------------  IF ACTION TYPE = 4 PROCESS FTTP (B-FILE) OPERATIONS ---------------------
            IF action_type = 4
            THEN
                l_stock_insert_t09 := 0;
                l_pledge_insert_t09 := 0;
                l_trn_type := 0;

                IF (i.transaction_type = 700 AND i.trans_sub_code = 10)
                THEN
                    NULL;
                ELSIF (i.transaction_type = 700 AND i.trans_sub_code = 101)
                THEN
                    NULL;
                ELSIF (i.transaction_type = 700 AND i.trans_sub_code = 47)
                THEN
                    NULL;
                ELSE
                    IF (i.trans_code = 500 AND i.trans_sub_code = 19)
                    THEN
                        l_trn_type := 14;
                    END IF;

                    IF (   (i.trans_code = 930 AND i.trans_sub_code = 4)
                        OR (i.trans_code = 500 AND i.trans_sub_code = 172))
                    THEN
                        l_trn_type := 15;
                    END IF;

                    IF (    i.trans_code IS NOT NULL
                        AND (   i.trans_code = 100
                             OR i.trans_code = 930
                             OR i.trans_code = 500))
                    THEN
                        IF (l_trn_type = 15)
                        THEN
                            NULL; --Symbol/Inst. Validations
                        END IF;

                        ----------- SET T09 SHARE TXN INSERT FLAG TO TRUE AND PREPARE AUDIT KEY FOR SHARE TRANSFER --------------------
                        l_stock_insert_t09 := 1;
                        l_auditkey :=
                               'CORSHT'
                            || '_'
                            || TO_CHAR (i.transid)
                            || '-'
                            || TO_CHAR (l_referncenumber)
                            || '-'
                            || TO_CHAR (i.cash_account_id_u06)
                            || '-'
                            || TO_CHAR (i.trading_acc_id_u07);
                    ELSIF (i.trans_code IS NOT NULL AND i.trans_code = 350)
                    THEN
                        ----------- SET T09 PLEDGE TXN INSERT FLAG TO TRUE AND PREPARE AUDIT KEY FOR PLEDGE TRANSFER -------------------
                        l_pledge_insert_t09 := 1;
                        l_auditkey :=
                               'CORPLE'
                            || '_'
                            || TO_CHAR (i.transid)
                            || '-'
                            || TO_CHAR (l_referncenumber)
                            || '-'
                            || TO_CHAR (i.cash_account_id_u06)
                            || '-'
                            || TO_CHAR (i.trading_acc_id_u07);
                    END IF;
                END IF;

                IF l_stock_insert_t09 = 1 OR l_pledge_insert_t09 = 1
                THEN
                    ------------------------------------PREPARE SHARE AND PLEDGE TRASACTION VALUES -------------------------------------
                    IF    i.custodian_id_m26 != l_t25_custodian_id_m26
                       OR i.exchange_acc_no_u07 != l_t25_account
                       OR i.symbol_code_m20 != l_t25_symbol
                       OR i.exchange_m01 != l_t25_exchange
                    THEN
                        l_t25_custodian_id_m26 := i.custodian_id_m26;
                        l_t25_account := i.exchange_acc_no_u07;
                        l_t25_exchange := i.exchange_m01;
                        l_t25_symbol := i.symbol_code_m20;
                        l_u24_lock_seq := TO_NUMBER (NVL (i.lockseq, 0)) + 1;
                        l_u24_net_holding :=
                            TO_NUMBER (NVL (i.net_holding_u24, 0));
                        l_u24_pledge_qty :=
                            TO_NUMBER (NVL (i.pledge_qty_u24, 0));
                        l_u24_holding_avg_cost :=
                            TO_NUMBER (NVL (i.avg_cost_u24, 0));
                        l_u24_holding_avg_price :=
                            TO_NUMBER (NVL (i.avg_price_u24, 0));
                        l_u24_weighted_avgprice :=
                            TO_NUMBER (NVL (i.weighted_avg_price_u24, 0));
                        l_u24_weighted_avgcost :=
                            TO_NUMBER (NVL (i.weighted_avg_cost_u24, 0));
                        l_u24_subscribe_qty :=
                            TO_NUMBER (NVL (i.subscribed_qty_u24, 0));
                        l_t25_owned_quantity := i.holding_balance;
                        l_t25_pledged_quantity := i.pledged_quantity;

                        IF (l_u24_net_holding + l_t25_owned_quantity) != 0
                        THEN
                            l_u24_weighted_avgcost :=
                                TO_NUMBER (
                                      (  (  NVL (l_u24_net_holding, 0)
                                          * NVL (l_u24_weighted_avgcost, 0))
                                       + (  (  (  (  l_t25_owned_quantity
                                                   * i.sign_factor)
                                                * i.avg_price)
                                             + i.transaction_fee)
                                          * i.sign_factor))
                                    / (  NVL (l_u24_net_holding, 0)
                                       + l_t25_owned_quantity));


                            l_u24_holding_avg_cost :=
                                TO_NUMBER (
                                      (  (  NVL (l_u24_net_holding, 0)
                                          * NVL (l_u24_holding_avg_cost, 0))
                                       + (  (  (  (  l_t25_owned_quantity
                                                   * i.sign_factor)
                                                * i.avg_price)
                                             + i.transaction_fee)
                                          * i.sign_factor))
                                    / (  NVL (l_u24_net_holding, 0)
                                       + l_t25_owned_quantity));


                            l_u24_holding_avg_price :=
                                TO_NUMBER (
                                      (  (  NVL (l_u24_net_holding, 0)
                                          * NVL (l_u24_holding_avg_price, 0))
                                       + (  (  (  (  l_t25_owned_quantity
                                                   * i.sign_factor)
                                                * i.avg_price)
                                             + i.transaction_fee)
                                          * i.sign_factor))
                                    / (  NVL (l_u24_net_holding, 0)
                                       + l_t25_owned_quantity));


                            l_u24_weighted_avgprice :=
                                TO_NUMBER (
                                      (  (  NVL (l_u24_net_holding, 0)
                                          * NVL (l_u24_weighted_avgprice, 0))
                                       + (  (  (  (  l_t25_owned_quantity
                                                   * i.sign_factor)
                                                * i.avg_price)
                                             + i.transaction_fee)
                                          * i.sign_factor))
                                    / (  NVL (l_u24_net_holding, 0)
                                       + l_t25_owned_quantity));
                        END IF;

                        l_u24_net_holding :=
                            l_u24_net_holding + l_t25_owned_quantity;
                        l_u24_pledge_qty :=
                            l_u24_pledge_qty + l_t25_pledged_quantity;
                        l_u24_subscribe_qty :=
                            l_u24_subscribe_qty + l_t25_owned_quantity;
                    ELSE
                        l_u24_lock_seq := l_u24_lock_seq + 1;
                        l_t25_owned_quantity := i.holding_balance;
                        l_t25_pledged_quantity := i.pledged_quantity;

                        IF (l_u24_net_holding + l_t25_owned_quantity) != 0
                        THEN
                            l_u24_weighted_avgcost :=
                                TO_NUMBER (
                                      (  (  NVL (l_u24_net_holding, 0)
                                          * NVL (l_u24_weighted_avgcost, 0))
                                       + (  (  (  (  l_t25_owned_quantity
                                                   * i.sign_factor)
                                                * i.avg_price)
                                             + i.transaction_fee)
                                          * i.sign_factor))
                                    / (  NVL (l_u24_net_holding, 0)
                                       + l_t25_owned_quantity));


                            l_u24_holding_avg_cost :=
                                TO_NUMBER (
                                      (  (  NVL (l_u24_net_holding, 0)
                                          * NVL (l_u24_holding_avg_cost, 0))
                                       + (  (  (  (  l_t25_owned_quantity
                                                   * i.sign_factor)
                                                * i.avg_price)
                                             + i.transaction_fee)
                                          * i.sign_factor))
                                    / (  NVL (l_u24_net_holding, 0)
                                       + l_t25_owned_quantity));


                            l_u24_holding_avg_price :=
                                TO_NUMBER (
                                      (  (  NVL (l_u24_net_holding, 0)
                                          * NVL (l_u24_holding_avg_price, 0))
                                       + (  (  (  (  l_t25_owned_quantity
                                                   * i.sign_factor)
                                                * i.avg_price)
                                             + i.transaction_fee)
                                          * i.sign_factor))
                                    / (  NVL (l_u24_net_holding, 0)
                                       + l_t25_owned_quantity));


                            l_u24_weighted_avgprice :=
                                TO_NUMBER (
                                      (  (  NVL (l_u24_net_holding, 0)
                                          * NVL (l_u24_weighted_avgprice, 0))
                                       + (  (  (  (  l_t25_owned_quantity
                                                   * i.sign_factor)
                                                * i.avg_price)
                                             + i.transaction_fee)
                                          * i.sign_factor))
                                    / (  NVL (l_u24_net_holding, 0)
                                       + l_t25_owned_quantity));
                        END IF;

                        l_u24_pledge_qty :=
                            l_u24_pledge_qty + l_t25_pledged_quantity;
                        l_u24_net_holding :=
                            l_u24_net_holding + l_t25_owned_quantity;
                        l_u24_subscribe_qty :=
                            l_u24_subscribe_qty + l_t25_owned_quantity;
                    END IF;



                    ------------------------------------------ INSERT T09 SHARE OR PLEDGE TRANSACTION VALUES -------------------------
                    INSERT
                      INTO t09_txn_single_entry_v3 (t09_db_seq_id,
                                                    t09_audit_key,
                                                    t09_trading_acc_id_u07,
                                                    t09_pledge_qty,
                                                    t09_holding_net,
                                                    t09_holding_blk,
                                                    t09_sell_pending,
                                                    t09_holding_paybale,
                                                    t09_buy_pending,
                                                    t09_holding_receivable,
                                                    t09_weighted_avgcost,
                                                    t09_holding_avg_cost,
                                                    t09_symbol_code_m20,
                                                    t09_holding_avg_price,
                                                    t09_gain_loss,
                                                    t09_subscribed_qty,
                                                    t09_weighted_avgprice,
                                                    t09_holding_txn_id,
                                                    t09_txn_code,
                                                    t09_tenant_code,
                                                    t09_cashacnt_id_u06,
                                                    t09_app_server_id,
                                                    t09_exchange_m01,
                                                    t09_txn_currency_m03,
                                                    t09_settle_currency_m03,
                                                    t09_update_impact_code,
                                                    t09_institution_id_m02,
                                                    t09_customer_id_u01,
                                                    t09_symbol_id_m20,
                                                    t09_custodian_id_m26,
                                                    t09_lockseq,
                                                    t09_holding_net_diff,
                                                    t09_narration,
                                                    t09_function_id_m88,
                                                    t09_no_of_approval,
                                                    t09_bulk_id,
                                                    t09_txn_refrence_id,
                                                    t09_txn_type,
                                                    t09_quantity,
                                                    t09_channel_id_v29,
                                                    t09_reference_type)
                    VALUES (
                               order_audit_seq.NEXTVAL,
                               l_auditkey, --t09_audit_key
                               i.trading_acc_id_u07, --t09_trading_acc_id_u07
                               CASE
                                   WHEN l_u24_pledge_qty > 0
                                   THEN
                                       l_u24_pledge_qty
                                   ELSE
                                       0
                               END, --t09_pledge_qty
                               CASE
                                   WHEN l_u24_net_holding > 0
                                   THEN
                                       l_u24_net_holding
                                   ELSE
                                       0
                               END, --t09_holding_net
                               TO_NUMBER (NVL (i.holding_block_u24, 0)), --t09_holding_blk
                               TO_NUMBER (NVL (i.sell_pending_u24, 0)), --t09_sell_pending
                               TO_NUMBER (NVL (i.payable_holding_u24, 0)), --t09_holding_paybale
                               TO_NUMBER (NVL (i.buy_pending_u24, 0)), --t09_buy_pending
                               TO_NUMBER (NVL (i.receivable_holding_u24, 0)), --t09_holding_receivable
                               CASE
                                   WHEN l_u24_weighted_avgcost > 0
                                   THEN
                                       l_u24_weighted_avgcost
                                   ELSE
                                       0
                               END, --t09_weighted_avgcost
                               CASE
                                   WHEN l_u24_holding_avg_cost > 0
                                   THEN
                                       l_u24_holding_avg_cost
                                   ELSE
                                       0
                               END, --t09_holding_avg_cost
                               i.symbol_code_m20, --t09_symbol_code_m20
                               CASE
                                   WHEN l_u24_holding_avg_price > 0
                                   THEN
                                       l_u24_holding_avg_price
                                   ELSE
                                       0
                               END, --t09_holding_avg_price
                               TO_NUMBER (NVL (i.gain_lost_u24, 0)), --t09_gain_loss
                               CASE
                                   WHEN l_u24_subscribe_qty > 0
                                   THEN
                                       l_u24_subscribe_qty
                                   ELSE
                                       0
                               END, --t09_subscribed_qty
                               CASE
                                   WHEN l_u24_weighted_avgprice > 0
                                   THEN
                                       l_u24_weighted_avgprice
                                   ELSE
                                       0
                               END, --t09_weighted_avgprice
                               i.transid, --t09_holding_txn_id
                               i.txn_code, --t09_txn_code
                               tenat_code, --t09_tenant_code
                               i.cash_account_id_u06, --t09_cashacnt_id_u06
                               app_server_id, --t09_app_server_id
                               i.exchange_code_m01, --t09_exchange_m01
                               i.currency_code_m03, --t09_txn_currency_m03
                               i.currency_code_m03, --t09_settle_currency_m03
                               i.txn_impact_type, --t09_update_impact_code (Holding Only)
                               i.institute_id_m02, --t09_institution_id_m02
                               i.customer_no_u01, --t09_customer_id_u01
                               i.symbol_id_m20, --t09_symbol_id_m20
                               i.custodian_id_m26, --t09_custodian_id_m26
                               l_u24_lock_seq, --t09_lockseq
                               0, --t09_holding_net_diff
                               'Corporate Action Process Too', --t09_narration
                               CASE -- t09_function_id_m88
                                   WHEN i.functional_approval_id_m88 > 0
                                   THEN
                                       i.functional_approval_id_m88
                                   ELSE
                                       i.approval_default_m88
                               END,
                               CASE -- t09_no_of_approval
                                   WHEN i.number_of_approval > 0
                                   THEN
                                       i.number_of_approval
                                   ELSE
                                       i.number_of_default_approval
                               END,
                               l_master_ref_id, --t09_bulk_id
                               i.id, --t09_txn_refrence_id
                               action_type, -- t09_txn_type
                               CASE
                                   WHEN l_pledge_insert_t09 = 1
                                   THEN
                                       i.pledged_quantity
                                   WHEN l_stock_insert_t09 = 1
                                   THEN
                                       i.holding_balance
                               END, --t09_quantity
                               channel, --t09_channel_id_v29
                               i.ref_type --t09_reference_type
                                         );
                END IF;



                UPDATE u06_cash_account u06
                   SET u06.u06_ordexecseq = i.lockseq
                 WHERE u06.u06_id = i.cash_account_id_u06;


                l_pledge_insert_t09 := 0;
                l_stock_insert_t09 := 0;
            -------------------------------  IF ACTION TYPE = 1/2 PROCESS CA / WEEKLY / INTERNATIONAL RECONCILLATION HOLDINGS  ---------------

            ELSIF action_type = 1 OR action_type = 2
            THEN
                l_auditkey :=
                       'CORSHT'
                    || '_'
                    || TO_CHAR (i.transid)
                    || '-'
                    || TO_CHAR (l_referncenumber)
                    || '-'
                    || TO_CHAR (i.cash_account_id_u06)
                    || '-'
                    || TO_CHAR (i.trading_acc_id_u07);

                INSERT INTO t09_txn_single_entry_v3 (t09_db_seq_id,
                                                     t09_audit_key,
                                                     t09_trading_acc_id_u07,
                                                     t09_pledge_qty,
                                                     t09_holding_net,
                                                     t09_holding_blk,
                                                     t09_sell_pending,
                                                     t09_holding_paybale,
                                                     t09_buy_pending,
                                                     t09_holding_receivable,
                                                     t09_weighted_avgcost,
                                                     t09_holding_avg_cost,
                                                     t09_symbol_code_m20,
                                                     t09_holding_avg_price,
                                                     t09_gain_loss,
                                                     t09_subscribed_qty,
                                                     t09_weighted_avgprice,
                                                     t09_holding_txn_id,
                                                     t09_txn_code,
                                                     t09_tenant_code,
                                                     t09_cashacnt_id_u06,
                                                     t09_app_server_id,
                                                     t09_exchange_m01,
                                                     t09_txn_currency_m03,
                                                     t09_settle_currency_m03,
                                                     t09_update_impact_code,
                                                     t09_institution_id_m02,
                                                     t09_customer_id_u01,
                                                     t09_symbol_id_m20,
                                                     t09_custodian_id_m26,
                                                     t09_lockseq,
                                                     t09_holding_net_diff,
                                                     t09_narration,
                                                     t09_function_id_m88,
                                                     t09_no_of_approval,
                                                     t09_bulk_id,
                                                     t09_txn_refrence_id,
                                                     t09_txn_type,
                                                     t09_quantity,
                                                     t09_channel_id_v29,
                                                     t09_reference_type)
                     VALUES (
                                order_audit_seq.NEXTVAL,
                                l_auditkey, --t09_audit_key
                                i.trading_acc_id_u07, --t09_trading_acc_id_u07
                                TO_NUMBER (NVL (i.pledge_qty_u24, 0)), --t09_pledge_qty
                                TO_NUMBER (
                                      NVL (i.net_holding_u24, 0)
                                    + i.holding_balance), --t09_holding_net
                                TO_NUMBER (NVL (i.holding_block_u24, 0)), --t09_holding_blk
                                TO_NUMBER (NVL (i.sell_pending_u24, 0)), --t09_sell_pending
                                TO_NUMBER (NVL (i.payable_holding_u24, 0)), --t09_holding_paybale
                                TO_NUMBER (NVL (i.buy_pending_u24, 0)), --t09_buy_pending
                                TO_NUMBER (NVL (i.receivable_holding_u24, 0)), --t09_holding_receivable
                                CASE
                                    WHEN (NVL (i.net_holding_u24, 0) + i.holding_balance) !=
                                             0
                                    THEN
                                        TO_NUMBER (
                                              (  (  NVL (i.net_holding_u24,
                                                         0)
                                                  * NVL (
                                                        i.weighted_avg_cost_u24,
                                                        0))
                                               + (  (  (  (  i.holding_balance
                                                           * i.sign_factor)
                                                        * i.avg_price)
                                                     + i.transaction_fee)
                                                  * i.sign_factor))
                                            / (  NVL (i.net_holding_u24, 0)
                                               + i.holding_balance))
                                    ELSE
                                        0
                                END, --t09_weighted_avgcost
                                CASE
                                    WHEN (NVL (i.net_holding_u24, 0) + i.holding_balance) !=
                                             0
                                    THEN
                                        TO_NUMBER (
                                              (  (  NVL (i.net_holding_u24,
                                                         0)
                                                  * NVL (i.avg_cost_u24, 0))
                                               + (  (  (  (  i.holding_balance
                                                           * i.sign_factor)
                                                        * i.avg_price)
                                                     + i.transaction_fee)
                                                  * i.sign_factor))
                                            / (  NVL (i.net_holding_u24, 0)
                                               + i.holding_balance))
                                    ELSE
                                        0
                                END, --t09_holding_avg_cost
                                i.symbol_code_m20, --t09_symbol_code_m20
                                CASE
                                    WHEN (NVL (i.net_holding_u24, 0) + i.holding_balance) !=
                                             0
                                    THEN
                                        TO_NUMBER (
                                              (  (  NVL (i.net_holding_u24,
                                                         0)
                                                  * NVL (i.avg_price_u24, 0))
                                               + (  (  (  (  i.holding_balance
                                                           * i.sign_factor)
                                                        * i.avg_price)
                                                     + i.transaction_fee)
                                                  * i.sign_factor))
                                            / (  NVL (i.net_holding_u24, 0)
                                               + i.holding_balance))
                                    ELSE
                                        0
                                END, --t09_holding_avg_price
                                TO_NUMBER (NVL (i.gain_lost_u24, 0)), --t09_gain_loss
                                TO_NUMBER ( NVL (i.subscribed_qty_u24, 0)), --t09_subscribed_qty
                                CASE
                                    WHEN (NVL (i.net_holding_u24, 0) + i.holding_balance) !=
                                             0
                                    THEN
                                        TO_NUMBER (
                                              (  (  NVL (i.net_holding_u24,
                                                         0)
                                                  * NVL (
                                                        i.weighted_avg_price_u24,
                                                        0))
                                               + (  (  (  (  i.holding_balance
                                                           * i.sign_factor)
                                                        * i.avg_price)
                                                     + i.transaction_fee)
                                                  * i.sign_factor))
                                            / (  NVL (i.net_holding_u24, 0)
                                               + i.holding_balance))
                                    ELSE
                                        0
                                END, --t09_weighted_avgprice
                                i.transid, --t09_holding_txn_id
                                i.txn_code, --t09_txn_code
                                tenat_code, --t09_tenant_code
                                i.cash_account_id_u06, --t09_cashacnt_id_u06
                                app_server_id, --t09_app_server_id
                                i.exchange_code_m01, --t09_exchange_m01
                                i.currency_code_m03, --t09_txn_currency_m03
                                i.currency_code_m03, --t09_settle_currency_m03
                                i.txn_impact_type, --t09_update_impact_code (Holding Only)
                                i.institute_id_m02, --t09_institution_id_m02
                                i.customer_no_u01, --t09_customer_id_u01
                                i.symbol_id_m20, --t09_symbol_id_m20
                                i.custodian_id_m26, --t09_custodian_id_m26
                                TO_NUMBER (NVL (i.lockseq, 0)) + 1, --t09_lockseq
                                0, --t09_holding_net_diff
                                'Corporate Action Process', --t09_narration
                                CASE -- t09_function_id_m88
                                    WHEN i.functional_approval_id_m88 > 0
                                    THEN
                                        i.functional_approval_id_m88
                                    ELSE
                                        i.approval_default_m88
                                END,
                                CASE -- t09_no_of_approval
                                    WHEN i.number_of_approval > 0
                                    THEN
                                        i.number_of_approval
                                    ELSE
                                        i.number_of_default_approval
                                END,
                                l_master_ref_id, --t09_bulk_id
                                i.id, --t09_txn_refrence_id
                                action_type, --t09_txn_type
                                i.holding_balance, --t09_quantity
                                channel, --t09_channel_id_v29
                                i.ref_type --t09_reference_type
                                          );

                UPDATE u06_cash_account u06
                   SET u06.u06_ordexecseq = i.lockseq
                 WHERE u06.u06_id = i.cash_account_id_u06;
            ----------------------------------  IF ACTION TYPE = 3 PROCESS INTERNATIONAL RECONCILLATION CASH  ---------------------------
            ELSIF action_type = 3
            THEN
                l_auditkey :=
                       'CORCASH'
                    || '_'
                    || TO_CHAR (i.transid)
                    || '-'
                    || TO_CHAR (l_referncenumber)
                    || '-'
                    || TO_CHAR (i.cash_account_id_u06);

                INSERT
                  INTO t09_txn_single_entry_v3 (
                           t09_db_seq_id,
                           t09_audit_key,
                           t09_cash_blk,
                           t09_update_impact_code,
                           t09_tnsfer_paymethod,
                           t09_institution_id_m02,
                           t09_fxrate,
                           t09_settle_currency_m03,
                           t09_customer_id_u01,
                           t09_cashacnt_id_u06,
                           t09_tenant_code,
                           t09_cash_balance_orig,
                           t09_cash_balance,
                           t09_cash_blk_orig,
                           t09_cash_payable_orig,
                           t09_cash_receivable_orig,
                           t09_cash_open_buy_blk,
                           t09_cash_open_buy_blk_orig,
                           t09_cash_payable_blk,
                           t09_cash_receivable_amnt,
                           t09_customer_no_u01,
                           t09_channel_id_v29,
                           t09_app_server_id,
                           t09_pending_deposit,
                           t09_pending_deposit_orig,
                           t09_pending_withdraw,
                           t09_pending_withdraw_orig,
                           t09_txn_code,
                           t09_cash_txn_id,
                           t09_cash_settle_date,
                           t09_amnt_in_txn_curr,
                           t09_amnt_in_stl_curr,
                           t09_cash_blk_diff,
                           t09_exchange_tax,
                           t09_broker_tax,
                           t09_txn_currency_m03,
                           t09_exchange_fee,
                           t09_broker_fee,
                           t09_exec_exchange_tax,
                           t09_exec_brk_tax,
                           t09_narration,
                           t09_txn_refrence_id,
                           t09_bulk_id,
                           t09_cum_transfer_value,
                           t09_incident_overdrawn_amt,
                           t09_withdr_overdrawn_amt,
                           t09_cash_initial_margin_charge,
                           t09_cash_maintain_margin_charg,
                           t09_cash_maintain_margin_block,
                           t09_cum_buy_order_value,
                           t09_cum_sell_order_value,
                           t09_loan_amount,
                           t09_function_id_m88,
                           t09_no_of_approval,
                           t09_lockseq,
                           t09_txn_type,
                           t09_reference_type)
                VALUES (
                           order_audit_seq.NEXTVAL, --t09_db_seq_id
                           l_auditkey, --t09_audit_key
                           TO_NUMBER (NVL (i.cash_block_u06, 0)), --t09_cash_blk
                           i.txn_impact_type, --t09_update_impact_code
                           1, --t09_tnsfer_paymethod (Cash)
                           i.institute_id_m02, --t09_institution_id_m02
                           i.fx_rate, --t09_fxrate
                           i.settle_currency_code_m03, --t09_settle_currency_m03
                           i.customer_no_u01, --t09_customer_id_u01
                           i.cash_account_id_u066, --t09_cashacnt_id_u06
                           tenat_code, --t09_tenant_code
                           i.cash_balance_u06, --t09_cash_balance_orig
                           TO_NUMBER (
                                 NVL (i.cash_balance_u06, 0)
                               + i.amnt_in_stl_currency), --t09_cash_balance
                           TO_NUMBER (NVL (i.cash_block_u06, 0)), --t09_cash_blk_orig
                           TO_NUMBER (NVL (i.payable_blocked_u06, 0)), --t09_cash_payable_orig
                           TO_NUMBER (NVL (i.receivable_amount_u06, 0)), --t09_cash_receivable_orig
                           TO_NUMBER (NVL (i.open_buy_blocked_u06, 0)), --t09_cash_open_buy_blk
                           TO_NUMBER (NVL (i.open_buy_blocked_u06, 0)), --t09_cash_open_buy_blk_orig
                           TO_NUMBER (NVL (i.payable_blocked_u06, 0)), --t09_cash_payable_blk
                           TO_NUMBER (NVL (i.receivable_amount_u06, 0)), --t09_cash_receivable_amnt
                           i.customer_no_u01, --t09_customer_no_u01
                           channel, --t09_channel_id_v29
                           app_server_id, --t09_app_server_id
                           TO_NUMBER (NVL (i.pending_deposit_u06, 0)), --t09_pending_deposit
                           TO_NUMBER (NVL (i.pending_deposit_u06, 0)), --t09_pending_deposit_orig
                           TO_NUMBER (NVL (i.pending_withdraw_u06, 0)), --t09_pending_withdraw
                           TO_NUMBER (NVL (i.pending_withdraw_u06, 0)), --t09_pending_withdraw_orig
                           i.txn_code, --t09_txn_code
                           i.transid, --t09_cash_txn_id
                           '', --t09_cash_settle_date
                           i.amnt_in_txn_currency, --t09_amnt_in_txn_curr
                           i.amnt_in_stl_currency, --t09_amnt_in_stl_curr
                           0, --t09_cash_blk_diff
                           0, --t09_exchange_tax
                           0, --t09_broker_tax
                           '', --t09_txn_currency_m03
                           0, --t09_exchange_fee
                           0, --t09_broker_fee
                           0, --t09_exec_exchange_tax
                           0, --t09_exec_brk_tax
                           i.narration, --t09_narration
                           i.id, --t09_txn_refrence_id
                           l_master_ref_id, --t09_bulk_id
                           TO_NUMBER (
                                 NVL (i.cum_transfer_value_u06, 0)
                               + i.cash_balance_u06), --t09_cum_transfer_value
                           TO_NUMBER (NVL (i.incident_overdrawn_amt_u06, 0)), --t09_incident_overdrawn_amt
                           TO_NUMBER (NVL (i.withdr_overdrawn_amt_u06, 0)), --t09_withdr_overdrawn_amt
                           TO_NUMBER (NVL (i.initial_margin_u06, 0)), --t09_cash_initial_margin_charge
                           TO_NUMBER (NVL (i.maintain_margin_charged_u06, 0)), --t09_cash_maintain_margin_charg
                           TO_NUMBER (NVL (i.maintain_margin_block_u06, 0)), --t09_cash_maintain_margin_block
                           TO_NUMBER (NVL (i.cum_buy_order_value_u06, 0)), --t09_cum_buy_order_value
                           TO_NUMBER (NVL (i.cum_sell_order_value_u06, 0)), --t09_cum_sell_order_value
                           TO_NUMBER (NVL (i.loan_amount_u06, 0)), --t09_loan_amount
                           CASE -- t09_function_id_m88
                               WHEN i.functional_approval_id_m88 > 0
                               THEN
                                   i.functional_approval_id_m88
                               ELSE
                                   i.approval_default_m88
                           END,
                           CASE -- t09_no_of_approval
                               WHEN i.number_of_approval > 0
                               THEN
                                   i.number_of_approval
                               ELSE
                                   i.number_of_default_approval
                           END,
                           TO_NUMBER (NVL (i.lockseq, 0)) + 1, --t09_lockseq
                           action_type, --t09_txn_type
                           i.ref_type --t09_reference_type
                                     );

                UPDATE u06_cash_account u06
                   SET u06.u06_ordexecseq = i.lockseq
                 WHERE u06.u06_id = i.cash_account_id_u06;
            END IF;

            l_record_count := l_record_count + 1;

            ---------------------------------------- COMMIT BULK T09 ENTRIES WHEN CHUNK SIZE EQUALS EXPECTED ---------------------------
            IF MOD (l_record_count, l_commit_blk_size) = 0
            THEN
                sp_oms_txn_entry_persist_bulk (l_master_ref_id, '1');
            END IF;
        END LOOP;

        ---------------------------------------- COMMIT REST T09 ENTRIES ---------------------------------------------------------------
        sp_oms_txn_entry_persist_bulk (l_master_ref_id, '1');
    END;
END;
/

