DECLARE
    l_bulk_share_txn_id   NUMBER;
    l_sqlerrm             VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t61_id), 0)
      INTO l_bulk_share_txn_id
      FROM dfn_ntp.t61_bulk_share_transactions;

    DELETE FROM error_log
          WHERE mig_table = 'T61_BULK_SHARE_TRANSACTIONS';

    FOR i
        IN (SELECT t110.t110_id,
                   t109.t109_transaction_type, -- [SAME IDs]
                   u07_buyer.u07_institute_id_m02,
                   t109.t109_movement_type, -- [SAME TYPEs]
                   u07_map_seller.new_trading_account_id AS seller_trading_ac,
                   u07_map_buyer.new_trading_account_id AS buyer_trading_ac,
                   t109.t109_seller_member_code,
                   t109.t109_seller_exchange_ac,
                   t109.t109_buyer_member_code,
                   t109.t109_buyer_exchange_ac,
                   NVL (u17_created.new_employee_id, 0) AS created_by,
                   t109.t109_created_date AS created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   CASE
                       WHEN map01.map01_ntp_id = 1
                       THEN
                           NVL (l1_by.new_employee_id, 0)
                       WHEN map01.map01_ntp_id = 2
                       THEN
                           NVL (l2_by.new_employee_id, 0)
                       ELSE
                           NVL (cancelled_by.new_employee_id, 0)
                   END
                       status_changed_by,
                   CASE
                       WHEN map01.map01_ntp_id = 1
                       THEN
                           t109.t109_l1_approved_date
                       WHEN map01.map01_ntp_id = 2
                       THEN
                           t109.t109_l2_approved_date
                       ELSE
                           t109.t109_cancled_date
                   END
                       status_changed_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   t109.t109_narration,
                   map01.map01_ntp_id,
                   t61_map.new_bulk_share_txn_id
              FROM mubasher_oms.t109_stock_bulk_transactions@mubasher_db_link t109,
                   mubasher_oms.t110_stock_bulk_trans_details@mubasher_db_link t110,
                   map16_optional_exchanges_m01 map16_buyer,
                   u07_trading_account_mappings u07_map_buyer,
                   dfn_ntp.u07_trading_account u07_buyer,
                   map16_optional_exchanges_m01 map16_seller,
                   u07_trading_account_mappings u07_map_seller,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings l1_by,
                   u17_employee_mappings l2_by,
                   u17_employee_mappings cancelled_by,
                   map01_approval_status_v01 map01,
                   t61_bulk_share_txn_mappings t61_map
             WHERE     t110.t110_bulk_id = t109.t109_id(+)
                   AND t109.t109_from_sec_id =
                           u07_map_buyer.old_trading_account_id(+)
                   AND t110.t110_exchange = map16_buyer.map16_oms_code(+)
                   AND NVL (map16_buyer.map16_ntp_code, t110.t110_exchange) =
                           u07_map_buyer.exchange_code(+)
                   AND u07_map_buyer.new_trading_account_id =
                           u07_buyer.u07_id(+)
                   AND t109.t109_to_sec_id =
                           u07_map_seller.old_trading_account_id(+)
                   AND t110.t110_exchange = map16_seller.map16_oms_code(+)
                   AND NVL (map16_seller.map16_ntp_code, t110.t110_exchange) =
                           u07_map_seller.exchange_code(+)
                   AND t109.t109_status = map01.map01_oms_id(+)
                   AND t109.t109_created_by = u17_created.old_employee_id(+)
                   AND t109.t109_l1_approved_by = l1_by.old_employee_id(+)
                   AND t109.t109_l2_approved_by = l2_by.old_employee_id(+)
                   AND t109.t109_cancled_by = cancelled_by.old_employee_id(+)
                   AND t110.t110_id = t61_map.old_bulk_share_txn_id(+))
    LOOP
        BEGIN
            IF i.buyer_trading_ac IS NULL OR i.seller_trading_ac IS NULL
            THEN
                raise_application_error (
                    -20001,
                    'Buyer Or Seller Trading Account Not Available',
                    TRUE);
            END IF;

            IF i.t109_transaction_type IS NULL
            THEN
                raise_application_error (-20001,
                                         'Transaction Type Not Available',
                                         TRUE);
            END IF;

            IF i.new_bulk_share_txn_id IS NULL
            THEN
                l_bulk_share_txn_id := l_bulk_share_txn_id + 1;

                INSERT
                  INTO dfn_ntp.t61_bulk_share_transactions (
                           t61_id,
                           t61_transaction_type,
                           t61_institute_id_m02,
                           t61_movement_type,
                           t61_seller_trading_ac_id_u07,
                           t61_buyer_trading_ac_id_u07,
                           t61_seller_member_code,
                           t61_seller_exchange_ac,
                           t61_buyer_member_code,
                           t61_buyer_exchange_ac,
                           t61_created_by_id_u17,
                           t61_created_date,
                           t61_narration,
                           t61_status_id_v01,
                           t61_status_changed_date,
                           t61_status_changed_by_id_u17,
                           t61_custom_type,
                           t61_allow_cash_overdraw,
                           t61_send_to_exchange)
                VALUES (l_bulk_share_txn_id, -- t61_id
                        i.t109_transaction_type, -- t61_transaction_type
                        i.u07_institute_id_m02, -- t61_institute_id_m02
                        i.t109_movement_type, -- t61_movement_type
                        i.seller_trading_ac, -- t61_seller_trading_ac_id_u07
                        i.buyer_trading_ac, -- t61_buyer_trading_ac_id_u07
                        i.t109_seller_member_code, -- t61_seller_member_code
                        i.t109_seller_exchange_ac, -- t61_seller_exchange_ac
                        i.t109_buyer_member_code, -- t61_buyer_member_code
                        i.t109_buyer_exchange_ac, -- t61_buyer_exchange_ac
                        i.created_by, -- t61_created_by_id_u17
                        i.created_date, -- t61_created_date
                        i.t109_narration, -- t61_narration
                        i.map01_ntp_id, -- t61_status_id_v01
                        i.status_changed_date, -- t61_status_changed_date
                        i.status_changed_by, -- t61_status_changed_by_id_u17
                        '1', -- t61_custom_type
                        0, -- t61_allow_cash_overdraw | Not Available
                        0 -- t61_send_to_exchange | Not Available
                         );

                INSERT
                  INTO t61_bulk_share_txn_mappings (old_bulk_share_txn_id,
                                                    new_bulk_share_txn_id)
                VALUES (i.t110_id, l_bulk_share_txn_id);
            ELSE
                UPDATE dfn_ntp.t61_bulk_share_transactions
                   SET t61_transaction_type = i.t109_transaction_type, -- t61_transaction_type
                       t61_institute_id_m02 = i.u07_institute_id_m02, -- t61_institute_id_m02
                       t61_movement_type = i.t109_movement_type, -- t61_movement_type
                       t61_seller_trading_ac_id_u07 = i.seller_trading_ac, -- t61_seller_trading_ac_id_u07
                       t61_buyer_trading_ac_id_u07 = i.buyer_trading_ac, -- t61_buyer_trading_ac_id_u07
                       t61_seller_member_code = i.t109_seller_member_code, -- t61_seller_member_code
                       t61_seller_exchange_ac = i.t109_seller_exchange_ac, -- t61_seller_exchange_ac
                       t61_buyer_member_code = i.t109_buyer_member_code, -- t61_buyer_member_code
                       t61_buyer_exchange_ac = i.t109_buyer_exchange_ac, -- t61_buyer_exchange_ac
                       t61_narration = i.t109_narration, -- t61_narration
                       t61_status_id_v01 = i.map01_ntp_id, -- t61_status_id_v01
                       t61_status_changed_date = i.status_changed_date, -- t61_status_changed_date
                       t61_status_changed_by_id_u17 = i.status_changed_by -- t61_status_changed_by_id_u17
                 WHERE t61_id = i.new_bulk_share_txn_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T61_BULK_SHARE_TRANSACTIONS',
                                i.t110_id,
                                CASE
                                    WHEN i.new_bulk_share_txn_id IS NULL
                                    THEN
                                        l_bulk_share_txn_id
                                    ELSE
                                        i.new_bulk_share_txn_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_bulk_share_txn_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/

COMMIT;

-- Updating Bulk Master ID for Share Transactions

MERGE INTO dfn_ntp.t12_share_transaction t12
     USING (SELECT t12_map.new_share_transaction_id,
                   t61_map.new_bulk_share_txn_id
              FROM mubasher_oms.t24_pending_stocks@mubasher_db_link t24,
                   t61_bulk_share_txn_mappings t61_map,
                   t12_share_transaction_mappings t12_map
             WHERE     t24.t24_bulk_request_id =
                           t61_map.old_bulk_share_txn_id
                   AND t24.t24_id = t12_map.old_share_transaction_id) t24_bulk_master
        ON (t12.t12_id = t24_bulk_master.new_share_transaction_id)
WHEN MATCHED
THEN
    UPDATE SET
        t12.t12_bulk_master_id_t61 = t24_bulk_master.new_bulk_share_txn_id;

COMMIT;