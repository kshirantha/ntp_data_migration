CREATE OR REPLACE PROCEDURE dfn_ntp.sp_clear_transaction_limits
IS
    CURSOR cash_accounts IS
        SELECT *
        FROM u06_cash_account
        WHERE    u06_cum_sell_order_value != 0
              OR u06_cum_buy_order_value != 0
              OR u06_cum_transfer_value != 0;
BEGIN
    FOR rec IN cash_accounts
    LOOP
        UPDATE u06_cash_account u06
        SET u06.u06_cum_sell_order_value = 0,
            u06.u06_cum_buy_order_value = 0,
            u06.u06_cum_transfer_value = 0
        WHERE u06.u06_id = rec.u06_id;
    END LOOP;
-- handled in full cache clear in OMS  V00_KEY= 'EOD_OMS_CACHE_CLEAR_SCHEDULE_TIME' 
/*    INSERT INTO dfn_ntp.t58_cache_clear_request (t58_id,
                                                 t58_table_id,
                                                 t58_store_keys_json,
                                                 t58_clear_all,
                                                 t58_custom_type,
                                                 t58_status,
                                                 t58_created_date)
    VALUES ( (SELECT MAX (t58_id) + 1
                FROM t58_cache_clear_request),
            'U06_CASH_ACCOUNT',
            '',
            1,
            DEFAULT,
            DEFAULT,
            DEFAULT);*/
END;
/