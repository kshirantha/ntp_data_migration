CREATE OR REPLACE 
PROCEDURE dfn_ntp.sp_cash_transaction_generate (t09c t09_txn_single_entry_v3%ROWTYPE)
IS
BEGIN
    BEGIN
        MERGE INTO dfn_ntp.t06_cash_transaction t
             USING (SELECT *
                      FROM (SELECT t09c.t09_cash_txn_id,              --t06_id
                                   CASE
                                       WHEN (   t09c.t09_txn_code = 'DEPOST'
                                             OR t09c.t09_txn_code = 'REFUND'
                                             OR t09c.t09_txn_code = 'WITHDR'
                                             OR t09c.t09_txn_code = 'CHARGE'
                                             OR (    t09c.t09_txn_code =
                                                         'CSHTRN'
                                                 AND t09c.t09_transfer_side =
                                                         1))
                                       THEN
                                           t09c.t09_cashacnt_id_u06 --t06_cash_acc_id_u06
                                       ELSE
                                           0
                                   END
                                       AS cash_acc_id,
                                   CASE
                                       WHEN (    t09c.t09_txn_code = 'CSHTRN'
                                             AND t09c.t09_transfer_side = 0)
                                       THEN
                                           t09c.t09_cashacnt_id_u06 --t06_cash_acc_id_u06 (Value For To Cash Account Only Exists In Cash Transfer Deposit Account ID)
                                       ELSE
                                           0
                                   END
                                       AS to_cash_acc_id,
                                   t09c.t09_cashacnt_id_u06, --t06_cash_acc_id_u06
                                   t09c.t09_txn_code,               --t06_code
                                   t09c.t09_customer_id_u01, --t06_from_cust_id_u01
                                   t09c.t09_narration,         --t06_narration
                                   t09c.t09_tnsfer_paymethod, --t06_payment_method (set paymethod to cash)
                                   CASE
                                       WHEN (t09c.t09_final_approval = '1')
                                       THEN
                                           t09c.t09_amnt_in_stl_curr --t06_cash_acc_id_u06
                                       ELSE
                                           CASE
                                               WHEN (   t09c.t09_txn_code =
                                                            'WITHDR'
                                                     OR t09c.t09_txn_code =
                                                            'CHARGE'
                                                     OR (    t09c.t09_txn_code =
                                                                 'CSHTRN'
                                                         AND t09c.t09_transfer_side =
                                                                 1))
                                               THEN
                                                   (  t09c.t09_pending_withdraw
                                                    - t09c.t09_pending_withdraw_orig)
                                               ELSE
                                                   (  t09c.t09_pending_deposit
                                                    - t09c.t09_pending_deposit_orig)
                                           END
                                   END
                                       AS t09_amnt_in_stl_curr, --t06_amt_in_txn_currency
                                   1 AS settle_currency_rate_m04, --t06_settle_currency_rate_m04
                                   NULL AS cheque_no,          --t06_cheque_no
                                   t09c.t09_cash_settle_date, --t06_settlement_date
                                   t09c.t09_cust_beneficiary_acc_u08, --t06_beneficiary_id_u08
                                   NULL AS cust_bank_acc_id, --t06_cust_bank_acc_id
                                   t09c.t09_approved_by_id_u17, --t06_entered_by_id_u17
                                   t09c.t09_last_updated_by, --t06_last_changed_by_id_u17
                                   t09c.t09_last_updated_time, --t06_last_changed_date
                                   t09c.t09_status_id AS status_id, --t06_status_id
                                   t09c.t09_bank_id_m93 AS bank_id, --t06_bank_id_m93
                                   NULL AS req_media,          --t06_req_media
                                   NULL AS stp_status,        --t06_stp_status
                                   NULL AS stp_narration,  --t06_stp_narration
                                   SYSDATE AS initiated_time, --t06_payment_initiated_time
                                   t09c.t09_settle_currency_m03, --t06_settle_currency_code_m03
                                   t09c.t09_poa_id_u47,       --t06_poa_id_u47
                                   t09c.t09_channel_id_v29, --t06_client_channel_id_v29
                                   t09c.t09_online_login_id_u09, --t06_sub_login_id_u09
                                   t09c.t09_no_of_approval AS no_of_approval, --t06_no_of_approval
                                   t09c.t09_current_approval_level
                                       AS current_approval_level, --t06_current_approval_level
                                   t09c.t09_function_id_m88 AS function_id, --t06_function_id_m88
                                   NULL AS deposit_bank_id, --t06_deposit_bank_id_m16
                                   NULL AS deposit_bank_no, --t06_deposit_bank_no
                                   t09c.t09_withdr_overdrawn_amt, --t06_overdrawn_amt
                                   NULL AS acc_name,            --t06_acc_name
                                   NULL AS branch,                --t06_branch
                                   NULL AS type_id,              --t06_type_id
                                   t09c.t09_institution_id_m02, --t06_institute_id_m02
                                   t09c.t09_exchange_tax,        --t06_exg_vat
                                   t09c.t09_broker_tax,          --t06_brk_vat
                                   t09c.t09_exchange_fee,   --t06_exchange_fee
                                   t09c.t09_broker_fee,       --t06_broker_fee
                                   t09c.t09_symbol_code_m20, --t06_symbol_code_m20
                                   t09c.t09_symbol_id_m20, --t06_symbol_id_m20
                                   NULL AS ref_id,                --t06_ref_id
                                   NULL AS ref_master_id,  --t06_ref_master_id
                                   NULL AS ref_type,            --t06_ref_type
                                   1 AS is_allow_overdraw, --t06_is_allow_overdraw
                                   0 AS exg_discount,       --t06_exg_discount
                                   0 AS brk_discount,       --t06_brk_discount
                                   0 AS system_approval, --t06_system_approval (only approve through AT)
                                   NULL AS parent_ref_id,  --t06_parent_ref_id
                                   t09c.t09_fxrate
                              FROM DUAL) ca) s
                ON (t.t06_id = s.t09_cash_txn_id)
        WHEN MATCHED
        THEN
            UPDATE SET
                t.t06_cash_acc_id_u06 =
                    CASE
                        WHEN s.cash_acc_id > 0 THEN s.cash_acc_id
                        ELSE t.t06_cash_acc_id_u06
                    END,
                t.t06_to_cash_acc_id =
                    CASE
                        WHEN s.to_cash_acc_id > 0 THEN s.to_cash_acc_id
                        ELSE t.t06_to_cash_acc_id
                    END,
                t.t06_code = s.t09_txn_code,
                t.t06_date = initiated_time,
                t.t06_from_cust_id_u01 = s.t09_customer_id_u01,
                t.t06_narration = s.t09_narration,
                t.t06_payment_method = s.t09_tnsfer_paymethod,
                t.t06_txn_code_m03 = s.t09_settle_currency_m03,
                t.t06_settle_currency_rate_m04 = s.settle_currency_rate_m04,
                t.t06_cheque_no = s.cheque_no,
                t.t06_settlement_date =
                    TO_DATE (s.t09_cash_settle_date, 'YYYYMMDD'),
                t.t06_beneficiary_id_u08 =
                    CASE
                        WHEN s.t09_cust_beneficiary_acc_u08 > 0
                        THEN
                            s.t09_cust_beneficiary_acc_u08
                    END,
                t.t06_cust_bank_acc_id = s.cust_bank_acc_id,
                --  t.t06_entered_date = s.initiated_time,
                --  t.t06_last_changed_date = s.initiated_time,
                t.t06_bank_id_m93 = s.bank_id,
                t.t06_req_media = s.req_media,
                t.t06_stp_status = s.stp_status,
                t.t06_stp_narration = s.stp_narration,
                t.t06_txn_type = s.t09_tnsfer_paymethod,
                t.t06_payment_initiated_time = s.initiated_time,
                t.t06_settle_currency_code_m03 = s.t09_settle_currency_m03,
                t.t06_poa_id_u47 = s.t09_poa_id_u47,
                t.t06_client_channel_id_v29 = s.t09_channel_id_v29,
                t.t06_sub_login_id_u09 = s.t09_online_login_id_u09,
                t.t06_no_of_approval = s.no_of_approval,
                t.t06_current_approval_level = s.current_approval_level,
                t.t06_function_id_m88 = s.function_id,
                t.t06_deposit_bank_id_m16 = s.deposit_bank_id,
                t.t06_deposit_bank_no = s.deposit_bank_no,
                t.t06_overdrawn_amt = s.t09_withdr_overdrawn_amt,
                t.t06_acc_name = s.acc_name,
                t.t06_branch = s.branch,
                t.t06_type_id = s.type_id,
                t.t06_exg_vat = s.t09_exchange_tax,
                t.t06_brk_vat = s.t09_broker_tax,
                t.t06_exchange_fee = s.t09_exchange_fee,
                t.t06_broker_fee = s.t09_broker_fee,
                t.t06_symbol_code_m20 = s.t09_symbol_code_m20,
                t.t06_symbol_id_m20 = s.t09_symbol_id_m20,
                t.t06_ref_id = s.ref_id,
                t.t06_ref_master_id = s.ref_master_id,
                t.t06_ref_type = s.ref_type,
                t.t06_is_allow_overdraw = s.is_allow_overdraw,
                t.t06_exg_discount = s.exg_discount,
                t.t06_brk_discount = s.brk_discount,
                t.t06_system_approval = s.system_approval,
                t.t06_parent_ref_id = s.parent_ref_id
        WHEN NOT MATCHED
        THEN
            INSERT     (t06_id,
                        t06_cash_acc_id_u06,
                        t06_to_cash_acc_id,
                        t06_code,
                        t06_date,
                        t06_from_cust_id_u01,
                        t06_narration,
                        t06_payment_method,
                        t06_txn_code_m03,
                        t06_amt_in_txn_currency,
                        t06_settle_currency_rate_m04,
                        t06_cheque_no,
                        t06_cheque_date,
                        t06_settlement_date,
                        t06_beneficiary_id_u08,
                        t06_cust_bank_acc_id,
                        t06_entered_by_id_u17,
                        t06_entered_date,
                        t06_last_changed_by_id_u17,
                        t06_last_changed_date,
                        t06_status_id,
                        t06_bank_id_m93,
                        t06_req_media,
                        t06_stp_status,
                        t06_stp_narration,
                        t06_txn_type,
                        t06_payment_initiated_time,
                        t06_settle_currency_code_m03,
                        t06_amt_in_settle_currency,
                        t06_poa_id_u47,
                        t06_client_channel_id_v29,
                        t06_sub_login_id_u09,
                        t06_no_of_approval,
                        t06_current_approval_level,
                        t06_function_id_m88,
                        t06_deposit_bank_id_m16,
                        t06_deposit_bank_no,
                        t06_overdrawn_amt,
                        t06_acc_name,
                        t06_branch,
                        t06_type_id,
                        t06_institute_id_m02,
                        t06_exg_vat,
                        t06_brk_vat,
                        t06_exchange_fee,
                        t06_broker_fee,
                        t06_symbol_code_m20,
                        t06_symbol_id_m20,
                        t06_ref_id,
                        t06_ref_master_id,
                        t06_ref_type,
                        t06_is_allow_overdraw,
                        t06_exg_discount,
                        t06_brk_discount,
                        t06_system_approval,
                        t06_parent_ref_id)
                VALUES (
                           s.t09_cash_txn_id,                         --t06_id
                           CASE WHEN s.cash_acc_id > 0 THEN s.cash_acc_id END, --t06_cash_acc_id_u06
                           CASE
                               WHEN s.to_cash_acc_id > 0
                               THEN
                                   s.to_cash_acc_id
                           END,                           --t06_to_cash_acc_id
                           s.t09_txn_code,                          --t06_code
                           initiated_time,                          --t06_date
                           s.t09_customer_id_u01,            --t06_from_cust_id_u01
                           s.t09_narration,                    --t06_narration
                           s.t09_tnsfer_paymethod, --t06_payment_method (set paymethod to cash)
                           s.t09_settle_currency_m03,       --t06_txn_code_m03
                           s.t09_amnt_in_stl_curr / s.t09_fxrate, --t06_amt_in_txn_currency
                           s.settle_currency_rate_m04, --t06_settle_currency_rate_m04
                           s.cheque_no,                        --t06_cheque_no
                           TO_DATE (TO_CHAR(s.initiated_time, 'YYYYMMDD'), 'YYYYMMDD'), --t06_cheque_date
                           TO_DATE (s.t09_cash_settle_date, 'YYYYMMDD'), --t06_settlement_date
                           CASE
                               WHEN s.t09_cust_beneficiary_acc_u08 > 0
                               THEN
                                   s.t09_cust_beneficiary_acc_u08
                           END,                       --t06_beneficiary_id_u08
                           s.cust_bank_acc_id,          --t06_cust_bank_acc_id
                           s.t09_approved_by_id_u17,   --t06_entered_by_id_u17
                           s.initiated_time,                --t06_entered_date
                           s.t09_approved_by_id_u17, --t06_last_changed_by_id_u17
                           s.initiated_time,           --t06_last_changed_date
                           s.status_id,                        --t06_status_id
                           s.bank_id,                        --t06_bank_id_m93
                           s.req_media,                        --t06_req_media
                           s.stp_status,                      --t06_stp_status
                           s.stp_narration,                --t06_stp_narration
                           s.t09_tnsfer_paymethod, --t06_txn_type (set paymethod to cash)
                           s.initiated_time,      --t06_payment_initiated_time
                           s.t09_settle_currency_m03, --t06_settle_currency_code_m03
                           s.t09_amnt_in_stl_curr, --t06_amt_in_settle_currency
                           s.t09_poa_id_u47,                  --t06_poa_id_u47
                           s.t09_channel_id_v29,   --t06_client_channel_id_v29
                           s.t09_online_login_id_u09,   --t06_sub_login_id_u09
                           s.no_of_approval,              --t06_no_of_approval
                           s.current_approval_level, --t06_current_approval_level
                           s.function_id,                --t06_function_id_m88
                           s.deposit_bank_id,        --t06_deposit_bank_id_m16
                           s.deposit_bank_no,            --t06_deposit_bank_no
                           s.t09_withdr_overdrawn_amt,     --t06_overdrawn_amt
                           s.acc_name,                          --t06_acc_name
                           s.branch,                              --t06_branch
                           s.type_id,                            --t06_type_id
                           s.t09_institution_id_m02,    --t06_institute_id_m02
                           s.t09_exchange_tax,                   --t06_exg_vat
                           s.t09_broker_tax,                     --t06_brk_vat
                           s.t09_exchange_fee,              --t06_exchange_fee
                           s.t09_broker_fee,                  --t06_broker_fee
                           s.t09_symbol_code_m20,        --t06_symbol_code_m20
                           s.t09_symbol_id_m20,            --t06_symbol_id_m20
                           s.ref_id,                              --t06_ref_id
                           s.ref_master_id,                --t06_ref_master_id
                           s.ref_type,                          --t06_ref_type
                           s.is_allow_overdraw,        --t06_is_allow_overdraw
                           s.exg_discount,                  --t06_exg_discount
                           s.brk_discount,                  --t06_brk_discount
                           s.system_approval,            --t06_system_approval
                           s.parent_ref_id                 --t06_parent_ref_id
                                          );
    END;
END;
/