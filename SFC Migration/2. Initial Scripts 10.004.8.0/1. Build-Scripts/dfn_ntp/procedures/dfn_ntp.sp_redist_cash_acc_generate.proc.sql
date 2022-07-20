CREATE OR REPLACE PROCEDURE dfn_ntp.sp_redist_cash_acc_generate (
    t09c t09_txn_single_entry_v3%ROWTYPE)
IS
BEGIN
    BEGIN
        --- Update Order Path Fields
        IF (t09c.t09_update_impact_code = '1')
        THEN
            MERGE INTO dfn_ntp.u06_cash_account t
                 USING (SELECT *
                          FROM (SELECT t09c.t09_cashacnt_id_u06,
                                       TO_NUMBER (
                                           NVL (t09c.t09_cash_balance, 0))
                                           AS t09_cash_balance,
                                       TO_NUMBER (NVL (t09c.t09_cash_blk, 0))
                                           AS t09_cash_blk,
                                       TO_NUMBER (
                                           NVL (t09c.t09_cash_open_buy_blk,
                                                0))
                                           AS t09_cash_open_buy_blk,
                                       TO_NUMBER (
                                           NVL (t09c.t09_cash_payable_blk, 0))
                                           AS t09_cash_payable_blk,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_cash_receivable_amnt,
                                               0))
                                           AS t09_cash_receivable_amnt,
                                       TO_NUMBER (
                                           NVL (t09c.t09_net_receivable, 0))
                                           AS t09_net_receivable,
                                       TO_NUMBER (
                                           NVL (t09c.t09_pending_deposit, 0))
                                           AS t09_pending_deposit,
                                       TO_NUMBER (
                                           NVL (t09c.t09_pending_withdraw, 0))
                                           AS t09_pending_withdraw,
                                       TO_NUMBER (
                                           NVL (t09c.t09_cum_transfer_value,
                                                0))
                                           AS t09_cum_transfer_value,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_cum_sell_order_value,
                                               0))
                                           AS t09_cum_sell_order_value,
                                       TO_NUMBER (
                                           NVL (t09c.t09_cum_buy_order_value,
                                                0))
                                           AS t09_cum_buy_order_value,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_cash_maintain_margin_block,
                                               0))
                                           AS t09_cash_maintain_margin_block,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_cash_maintain_margin_charg,
                                               0))
                                           AS t09_cash_maintain_margin_charg,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_cash_initial_margin_charge,
                                               0))
                                           AS t09_cash_initial_margin_charge,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_withdr_overdrawn_amt,
                                               0))
                                           AS t09_withdr_overdrawn_amt,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_incident_overdrawn_amt,
                                               0))
                                           AS t09_incident_overdrawn_amt,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_cum_online_sel_order_value,
                                               0))
                                           AS t09_cum_online_sel_order_value,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_cum_online_buy_order_value,
                                               0))
                                           AS t09_cum_online_buy_order_value,
                                       NVL (
                                           TO_TIMESTAMP (
                                               t09c.t09_last_updated_time,
                                               'YYYYMMDDHH24MISS'),
                                           SYSDATE)
                                           AS t09_last_updated_time,
                                       --  TO_DATE(
                                       --       '19700101',
                                       --       'yyyymmdd'
                                       --  )
                                       -- + ((T09C.T09_LAST_UPDATED_TIME / 1000) / 24 / 60 / 60)
                                       --     AS T09_LAST_UPDATED_TIME,
                                       t09c.t09_db_seq_id AS t09_db_seq_id,
                                       t09c.t09_lockseq
                                  FROM DUAL) ca) s
                    ON (t.u06_id = s.t09_cashacnt_id_u06)
            WHEN MATCHED
            THEN
                UPDATE SET
                    t.u06_balance = s.t09_cash_balance,
                    t.u06_blocked = s.t09_cash_blk,
                    t.u06_open_buy_blocked = s.t09_cash_open_buy_blk,
                    t.u06_payable_blocked = s.t09_cash_payable_blk,
                    t.u06_receivable_amount = s.t09_cash_receivable_amnt,
                    t.u06_net_receivable = s.t09_net_receivable,
                    t.u06_pending_deposit = s.t09_pending_deposit,
                    t.u06_pending_withdraw = s.t09_pending_withdraw,
                    t.u06_cum_transfer_value = s.t09_cum_transfer_value,
                    t.u06_cum_sell_order_value = s.t09_cum_sell_order_value,
                    t.u06_cum_buy_order_value = s.t09_cum_buy_order_value,
                    t.u06_last_activity_date = s.t09_last_updated_time,
                    t.u06_dbseqid = s.t09_db_seq_id,
                    t.u06_ordexecseq = s.t09_lockseq,
                    t.u06_initial_margin = s.t09_cash_initial_margin_charge,
                    t.u06_maintain_margin_charged =
                        s.t09_cash_maintain_margin_charg,
                    t.u06_maintain_margin_block =
                        s.t09_cash_maintain_margin_block,
                    t.u06_withdr_overdrawn_amt = s.t09_withdr_overdrawn_amt,
                    t.u06_incident_overdrawn_amt =
                        s.t09_incident_overdrawn_amt,
                    t.u06_cum_online_sel_order_value =
                        s.t09_cum_online_sel_order_value,
                    t.u06_cum_online_buy_order_value =
                        s.t09_cum_online_buy_order_value
                         WHERE NVL (t.u06_ordexecseq, 0) < s.t09_lockseq;
        --- Update Cash Adjustment and (Holding + Cash) Adjustment Fields
        ELSIF (   t09c.t09_update_impact_code = '2'
               OR t09c.t09_update_impact_code = '6')
        THEN
            MERGE INTO dfn_ntp.u06_cash_account t
                 USING (SELECT *
                          FROM (SELECT t09c.t09_cashacnt_id_u06,
                                       TO_NUMBER (
                                           NVL (t09c.t09_cash_balance, 0))
                                           AS t09_cash_balance,
                                       TO_NUMBER (NVL (t09c.t09_cash_blk, 0))
                                           AS t09_cash_blk,
                                       TO_NUMBER (
                                           NVL (t09c.t09_cash_open_buy_blk,
                                                0))
                                           AS t09_cash_open_buy_blk,
                                       TO_NUMBER (
                                           NVL (t09c.t09_cash_payable_blk, 0))
                                           AS t09_cash_payable_blk,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_cash_receivable_amnt,
                                               0))
                                           AS t09_cash_receivable_amnt,
                                       TO_NUMBER (
                                           NVL (t09c.t09_net_receivable, 0))
                                           AS t09_net_receivable,
                                       TO_NUMBER (
                                           NVL (t09c.t09_pending_deposit, 0))
                                           AS t09_pending_deposit,
                                       TO_NUMBER (
                                           NVL (t09c.t09_pending_withdraw, 0))
                                           AS t09_pending_withdraw,
                                       TO_NUMBER (
                                           NVL (t09c.t09_cum_transfer_value,
                                                0))
                                           AS t09_cum_transfer_value,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_cum_sell_order_value,
                                               0))
                                           AS t09_cum_sell_order_value,
                                       TO_NUMBER (
                                           NVL (t09c.t09_cum_buy_order_value,
                                                0))
                                           AS t09_cum_buy_order_value,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_cash_maintain_margin_block,
                                               0))
                                           AS t09_cash_maintain_margin_block,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_cash_maintain_margin_charg,
                                               0))
                                           AS t09_cash_maintain_margin_charg,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_cash_initial_margin_charge,
                                               0))
                                           AS t09_cash_initial_margin_charge,
                                       TO_NUMBER (
                                           NVL (t09c.t09_loan_amount, 0))
                                           AS t09_loan_amount,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_withdr_overdrawn_amt,
                                               0))
                                           AS t09_withdr_overdrawn_amt,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_incident_overdrawn_amt,
                                               0))
                                           AS t09_incident_overdrawn_amt,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_cum_online_sel_order_value,
                                               0))
                                           AS t09_cum_online_sel_order_value,
                                       TO_NUMBER (
                                           NVL (
                                               t09c.t09_cum_online_buy_order_value,
                                               0))
                                           AS t09_cum_online_buy_order_value,
                                       NVL (
                                           TO_TIMESTAMP (
                                               t09c.t09_last_updated_time,
                                               'YYYYMMDDHH24MISS'),
                                           SYSDATE)
                                           AS t09_last_updated_time,
                                       --  TO_DATE(
                                       --       '19700101',
                                       --       'yyyymmdd'
                                       --  )
                                       -- + ((T09C.T09_LAST_UPDATED_TIME / 1000) / 24 / 60 / 60)
                                       --     AS T09_LAST_UPDATED_TIME,
                                       t09c.t09_db_seq_id AS t09_db_seq_id,
                                       t09c.t09_lockseq
                                  FROM DUAL) ca) s
                    ON (t.u06_id = s.t09_cashacnt_id_u06)
            WHEN MATCHED
            THEN
                UPDATE SET
                    t.u06_balance = s.t09_cash_balance,
                    t.u06_blocked = s.t09_cash_blk,
                    t.u06_open_buy_blocked = s.t09_cash_open_buy_blk,
                    t.u06_payable_blocked = s.t09_cash_payable_blk,
                    t.u06_receivable_amount = s.t09_cash_receivable_amnt,
                    t.u06_net_receivable = s.t09_net_receivable,
                    t.u06_pending_deposit = s.t09_pending_deposit,
                    t.u06_pending_withdraw = s.t09_pending_withdraw,
                    t.u06_cum_transfer_value = s.t09_cum_transfer_value,
                    t.u06_cum_sell_order_value = s.t09_cum_sell_order_value,
                    t.u06_cum_buy_order_value = s.t09_cum_buy_order_value,
                    t.u06_loan_amount = s.t09_loan_amount,
                    t.u06_withdr_overdrawn_amt = s.t09_withdr_overdrawn_amt,
                    t.u06_incident_overdrawn_amt =
                        s.t09_incident_overdrawn_amt,
                    t.u06_cum_online_sel_order_value =
                        s.t09_cum_online_sel_order_value,
                    t.u06_cum_online_buy_order_value =
                        s.t09_cum_online_buy_order_value,
                    t.u06_last_activity_date = s.t09_last_updated_time,
                    t.u06_dbseqid = s.t09_db_seq_id,
                    t.u06_ordexecseq = s.t09_lockseq
                         WHERE NVL (t.u06_ordexecseq, 0) < s.t09_lockseq;
        END IF;
    END;
END;
/