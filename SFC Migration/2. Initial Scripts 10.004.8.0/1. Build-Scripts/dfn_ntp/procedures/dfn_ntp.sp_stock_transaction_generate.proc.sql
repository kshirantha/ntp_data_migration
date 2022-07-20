CREATE OR REPLACE 
PROCEDURE dfn_ntp.sp_stock_transaction_generate (t09c t09_txn_single_entry_v3%ROWTYPE)
IS
BEGIN
    BEGIN
        MERGE INTO dfn_ntp.t12_share_transaction t
             USING (SELECT *
                      FROM (SELECT t09c.t09_exchange_m01, --t.t12_exchange_code_m01
                                   t09c.t09_symbol_code_m20, --t.t12_symbol_code_m20
                                   t09c.t09_quantity, --t.t12_quantity
                                   t09c.t09_holding_avg_cost, --t.t12_avgcost
                                   CASE
                                       WHEN (   t09c.t09_txn_code = 'HLDDEPOST'
                                             OR t09c.t09_txn_code = 'HLDWITHDR'
                                             OR (    t09c.t09_txn_code =
                                                         'HLDTRN'
                                                 AND t09c.t09_transfer_side =
                                                         0))
                                       THEN
                                           t09c.t09_trading_acc_id_u07
                                       ELSE
                                           0
                                   END AS trade_acc_id_u07, --t.t12_trading_acc_id_u07
                                   CASE
                                       WHEN  (    t09c.t09_txn_code =
                                                         'HLDTRN'
                                                 AND t09c.t09_transfer_side =
                                                         1)
                                       THEN
                                           t09c.t09_trading_acc_id_u07
                                       ELSE
                                           0
                                   END AS buyer_trade_acc_id_u07, --t.t12_trading_acc_id_u07
                                   null AS seller_exchange_acc, --t.t12_seller_exchange_ac
                                   t09c.t09_customer_id_u01, --t.t12_customer_id_u01
                                   t09c.t09_status_id AS status, --t.t12_status_id_v01
                                   SYSDATE AS txn_timestamp, --t.t12_timestamp
                                   t09c.t09_institution_id_m02, --t.t12_inst_id_m02
                                   t09c.t09_narration, --t.t12_narration
                                   (  t09c.t09_exchange_fee
                                    + t09c.t09_broker_fee)
                                       AS fee, --t.t12_fees
                                   t09c.t09_cash_txn_id, --t.t12_reference_id_t06
                                   SYSDATE AS txn_date, --t.t12_transfer_date
                                   t09c.t09_exchange_fee, --t.t12_exng_fee
                                   t09c.t09_broker_fee, --t.t12_brk_fee
                                   t09c.t09_custodian_id_m26, --t.t12_custodian_id_m26
                                   (  t09c.t09_exchange_fee
                                    + t09c.t09_broker_fee
                                    + t09c.t09_broker_tax
                                    + t09c.t09_exchange_tax)
                                       AS txn_fee, --t.t12_transaction_fee
                                   null AS txn_category, --t.t12_txn_category
                                   t09c.t09_reject_reason, --t.t12_reject_reason
                                   null AS txn_source, --t.t12_txn_source
                                   null AS seller_memebr_code, --t.t12_seller_memebr_code
                                   null AS seller_nin, --t.t12_seller_nin
                                   null AS buyer_member_code, --t.t12_buyer_member_code
                                   null AS buyer_nin, --t.t12_buyer_nin
                                   t09c.t09_channel_id_v29, --t.t12_channel_id_v29
                                   t09c.t09_approved_by_id_u17, --t.t12_last_changed_by_id_u17
                                   t09c.t09_last_updated_time, --t.t12_last_changed_date
                                   t09c.t09_no_of_approval AS no_of_approval, --t.t12_no_of_approval
                                   t09c.t09_current_approval_level
                                       AS current_approval_level, --t.t12_current_approval_level
                                   t09c.t09_function_id_m88 AS function_id, --t.t12_function_id_m88
                                   t09c.t09_final_approval AS final_approval, --t.t12_final_approval
                                   t09c.t09_exchange_tax, --t.t12_exg_vat
                                   t09c.t09_broker_tax, --t.t12_brk_vat
                                   0 AS b_file, --t.t12_is_b_file
                                   t09c.t09_symbol_id_m20, --t.t12_symbol_id_m20
                                   t09c.t09_exchange_id_m01, --t.t12_exchange_id_m01
                                   null AS bulk_master_id, --t.t12_bulk_master_id_t61
                                   0 AS exg_discount, --t.t12_exg_discount
                                   0 AS brk_discount, --t.t12_brk_discount
                                   t09c.t09_holding_txn_id, --t.t12_id
                                   t09c.t09_txn_code, --t.t12_code_m97
                                   t09c.t09_txn_type, --t.t12_txn_type
                                   t09c.t09_reference_type
                              FROM DUAL) ca) s
                ON (t.t12_id = s.t09_holding_txn_id)
        WHEN MATCHED
        THEN
            UPDATE SET
                t.t12_exchange_code_m01 = s.t09_exchange_m01,
                t.t12_symbol_code_m20 = s.t09_symbol_code_m20,
                t.t12_quantity = s.t09_quantity,
                t.t12_avgcost = s.t09_holding_avg_cost,
                t.t12_trading_acc_id_u07 =
                CASE WHEN s.trade_acc_id_u07 > 0 THEN s.trade_acc_id_u07 ELSE t.t12_trading_acc_id_u07 END,
                t.t12_buyer_trading_ac_id_u07 =
                CASE WHEN s.buyer_trade_acc_id_u07 > 0 THEN s.buyer_trade_acc_id_u07 ELSE t.t12_buyer_trading_ac_id_u07 END,
                t.t12_seller_exchange_ac = s.seller_exchange_acc,
                t.t12_customer_id_u01 = s.t09_customer_id_u01,
                t.t12_status_id_v01 = s.status,
                t.t12_timestamp = s.txn_timestamp,
                t.t12_inst_id_m02 = s.t09_institution_id_m02,
                t.t12_narration = s.t09_narration,
                t.t12_fees = s.fee,
                t.t12_reference_id_t06 = s.t09_cash_txn_id,
                t.t12_transfer_date = s.txn_date,
                t.t12_exng_fee = s.t09_exchange_fee,
                t.t12_brk_fee = s.t09_broker_fee,
                t.t12_custodian_id_m26 = s.t09_custodian_id_m26,
                t.t12_transaction_fee = s.txn_fee,
                t.t12_txn_category = s.txn_category,
                t.t12_reject_reason = s.t09_reject_reason,
                t.t12_txn_source = s.txn_source,
                t.t12_seller_memebr_code = s.seller_memebr_code,
                t.t12_seller_nin = s.seller_nin,
                t.t12_buyer_member_code = s.buyer_member_code,
                t.t12_buyer_nin = s.buyer_nin,
                t.t12_channel_id_v29 = s.t09_channel_id_v29,
                t.t12_last_changed_by_id_u17 = s.t09_approved_by_id_u17,
                t.t12_last_changed_date = s.t09_last_updated_time,
                t.t12_no_of_approval = s.no_of_approval,
                t.t12_current_approval_level = s.current_approval_level,
                t.t12_function_id_m88 = s.function_id,
                t.t12_final_approval = s.final_approval,
                t.t12_exg_vat = s.t09_exchange_tax,
                t.t12_brk_vat = s.t09_broker_tax,
                t.t12_is_b_file =
                    CASE WHEN s.t09_reference_type = 'T25' THEN 1 ELSE 0 END,
                t.t12_symbol_id_m20 = s.t09_symbol_id_m20,
                t.t12_exchange_id_m01 = s.t09_exchange_id_m01,
                t.t12_bulk_master_id_t61 = s.bulk_master_id,
                t.t12_exg_discount = s.exg_discount,
                t.t12_brk_discount = s.brk_discount,
                t.t12_code_m97 = s.t09_txn_code,
                t.t12_txn_type = s.t09_txn_type
        WHEN NOT MATCHED
        THEN
            INSERT     (t.t12_id,
                        t.t12_exchange_code_m01,
                        t.t12_symbol_code_m20,
                        t.t12_quantity,
                        t.t12_avgcost,
                        t.t12_trading_acc_id_u07,
                        t.t12_buyer_trading_ac_id_u07,
                        t.t12_seller_exchange_ac,
                        t.t12_customer_id_u01,
                        t.t12_status_id_v01,
                        t.t12_timestamp,
                        t.t12_inst_id_m02,
                        t.t12_narration,
                        t.t12_fees,
                        t.t12_reference_id_t06,
                        t.t12_transfer_date,
                        t.t12_exng_fee,
                        t.t12_brk_fee,
                        t.t12_custodian_id_m26,
                        t.t12_transaction_fee,
                        t.t12_txn_category,
                        t.t12_reject_reason,
                        t.t12_txn_source,
                        t.t12_seller_memebr_code,
                        t.t12_seller_nin,
                        t.t12_buyer_member_code,
                        t.t12_buyer_nin,
                        t.t12_channel_id_v29,
                        t.t12_last_changed_by_id_u17,
                        t.t12_last_changed_date,
                        t.t12_no_of_approval,
                        t.t12_current_approval_level,
                        t.t12_function_id_m88,
                        t.t12_final_approval,
                        t.t12_exg_vat,
                        t.t12_brk_vat,
                        t.t12_is_b_file,
                        t.t12_symbol_id_m20,
                        t.t12_exchange_id_m01,
                        t.t12_bulk_master_id_t61,
                        t.t12_exg_discount,
                        t.t12_brk_discount,
                        t.t12_code_m97,
                        t.t12_txn_type,
                        t.t12_pending_req_id,
                        t.t12_book_keeper_id)
                VALUES (
                           s.t09_holding_txn_id,
                           s.t09_exchange_m01, --t.t12_exchange_code_m01                                        ,
                           s.t09_symbol_code_m20, --t.t12_symbol_code_m20                                          ,
                           s.t09_quantity, --t.t12_quantity
                           s.t09_holding_avg_cost, --t.t12_avgcost
                           CASE WHEN s.trade_acc_id_u07 > 0 THEN s.trade_acc_id_u07 END, --t.t12_trading_acc_id_u07
                           CASE WHEN s.buyer_trade_acc_id_u07 > 0 THEN s.buyer_trade_acc_id_u07 END, --t.t12_buyer_trading_ac_id_u07,
                           s.seller_exchange_acc, --t.t12_seller_exchange_ac
                           s.t09_customer_id_u01, --t.t12_customer_id_u01
                           s.status, --t.t12_status_id_v01
                           s.txn_timestamp, --t.t12_timestamp
                           s.t09_institution_id_m02, --t.t12_inst_id_m02
                           s.t09_narration, --t.t12_narration
                           s.fee, --t.t12_fees
                           s.t09_cash_txn_id, --t.t12_reference_id_t06
                           SYSDATE, --t.t12_transfer_date
                           s.t09_exchange_fee, --t.t12_exng_fee
                           s.t09_broker_fee, --t.t12_brk_fee
                           s.t09_custodian_id_m26, --t.t12_custodian_id_m26
                           s.txn_fee, --t.t12_transaction_fee
                           s.txn_category, --t.t12_txn_category
                           s.t09_reject_reason, --t.t12_reject_reason
                           s.txn_source, --t.t12_txn_source
                           s.seller_memebr_code, --t.t12_seller_memebr_code
                           s.seller_nin, --t.t12_seller_nin
                           s.buyer_member_code, --t.t12_buyer_member_code
                           s.buyer_nin, --t.t12_buyer_nin
                           s.t09_channel_id_v29, --t.t12_channel_id_v29
                           s.t09_approved_by_id_u17, --t.t12_last_changed_by_id_u17
                           s.t09_last_updated_time, --t.t12_last_changed_date
                           s.no_of_approval, --t.t12_no_of_approval
                           s.current_approval_level, --t.t12_current_approval_level
                           s.function_id, --t.t12_function_id_m88
                           s.final_approval, --t.t12_final_approval
                           s.t09_exchange_tax, --t.t12_exg_vat
                           s.t09_broker_tax, --t.t12_brk_vat
                           CASE --t.t12_is_b_file,
                               WHEN s.t09_reference_type = 'T25' THEN 1
                               ELSE 0
                           END,
                           s.t09_symbol_id_m20, --t.t12_symbol_id_m20
                           s.t09_exchange_id_m01, --t.t12_exchange_id_m01
                           s.bulk_master_id, --t.t12_bulk_master_id_t61
                           s.exg_discount, --t.t12_exg_discount
                           s.brk_discount, --t.t12_brk_discount
                           s.t09_txn_code, --t.t12_code_m97
                           s.t09_txn_type, --t.t12_txn_type
                           0, --t.t12_pending_req_id
                           0 --t.t12_book_keeper_id
                           );
    END;
END;
/