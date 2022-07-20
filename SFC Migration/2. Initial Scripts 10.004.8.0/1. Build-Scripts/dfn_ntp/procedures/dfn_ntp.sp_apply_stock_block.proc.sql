CREATE OR REPLACE PROCEDURE dfn_ntp.sp_apply_stock_block
IS
    CURSOR blocked_trading_accounts
    IS
        SELECT *
          FROM u24_holdings
         WHERE u24_manual_block != 0;

    CURSOR block_requests
    IS
        SELECT *
          FROM t67_stock_block_request
         WHERE     t67_from_date <= func_get_eod_date () + 1
               AND t67_to_date > func_get_eod_date ()
               AND t67_status_id_v01 = 2;

    CURSOR blocked_requests
    IS
        SELECT *
          FROM t67_stock_block_request
         WHERE     t67_from_date IS NULL
               AND t67_to_date IS NULL
               AND t67_status_id_v01 = 2;
BEGIN
    --     remove manual blocked holdings
    FOR rec IN blocked_trading_accounts
    LOOP
        UPDATE u24_holdings
           SET u24_manual_block = 0
         WHERE     u24_trading_acnt_id_u07 = rec.u24_trading_acnt_id_u07
               AND u24_symbol_id_m20 = rec.u24_symbol_id_m20;
    END LOOP;

    FOR rec IN blocked_requests
    LOOP
        UPDATE u24_holdings
           SET u24_manual_block = u24_manual_block + rec.t67_qty_blocked
         WHERE     u24_trading_acnt_id_u07 = rec.t67_trading_account_id_u07
               AND u24_symbol_id_m20 = rec.t67_symbol_id_m20;

        --  select max(T58_ID)  from T58_CACHE_CLEAR_REQUEST;

        INSERT INTO dfn_ntp.t58_cache_clear_request (t58_id,
                                                     t58_table_id,
                                                     t58_store_keys_json,
                                                     t58_clear_all,
                                                     t58_custom_type,
                                                     t58_status,
                                                     t58_created_date)
            VALUES (
                       (SELECT MAX (t58_id) + 1
                          FROM t58_cache_clear_request),
                       'U24_HOLDINGS',
                          '{"u24_trading_acnt_id_u07":"'
                       || rec.t67_trading_account_id_u07
                       || '","u24_custodian_id_m26":"'
                       || rec.t67_custodian_id_m26
                       || '",'
                       || '"u24_exchange_code_m01":"'
                       || rec.t67_exchange_code_m01
                       || '",'
                       || '"u24_symbol_code_m20":"'
                       || rec.t67_symbol_code_m20
                       || '"}',
                       DEFAULT,
                       DEFAULT,
                       DEFAULT,
                       DEFAULT);
    END LOOP;

    --     add new blocks starting from today
    FOR rec IN block_requests
    LOOP
        UPDATE u24_holdings
           SET u24_manual_block = u24_manual_block + rec.t67_qty_blocked
         WHERE     u24_trading_acnt_id_u07 = rec.t67_trading_account_id_u07
               AND u24_symbol_id_m20 = rec.t67_symbol_id_m20;

        INSERT INTO dfn_ntp.t58_cache_clear_request (t58_id,
                                                     t58_table_id,
                                                     t58_store_keys_json,
                                                     t58_clear_all,
                                                     t58_custom_type,
                                                     t58_status,
                                                     t58_created_date)
            VALUES (
                       (SELECT MAX (t58_id) + 1
                          FROM t58_cache_clear_request),
                       'U24_HOLDINGS',
                          '{"u24_trading_acnt_id_u07":"'
                       || rec.t67_trading_account_id_u07
                       || '","u24_custodian_id_m26":"'
                       || rec.t67_custodian_id_m26
                       || '",'
                       || '"u24_exchange_code_m01":"'
                       || rec.t67_exchange_code_m01
                       || '",'
                       || '"u24_symbol_code_m20":"'
                       || rec.t67_symbol_code_m20
                       || '"}',
                       DEFAULT,
                       DEFAULT,
                       DEFAULT,
                       DEFAULT);
    END LOOP;

    UPDATE t67_stock_block_request
       SET t67_status_id_v01 = 9
     WHERE t67_to_date <= func_get_eod_date () AND t67_status_id_v01 = 2;
END;
/
