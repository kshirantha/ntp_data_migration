CREATE OR REPLACE PROCEDURE dfn_ntp.sp_apply_cash_block
IS
    CURSOR blocked_cash_accounts
    IS
        SELECT *
          FROM u06_cash_account
         WHERE    u06_manual_transfer_blocked != 0
               OR u06_manual_trade_blocked != 0;

    CURSOR block_requests
    IS
        SELECT *
          FROM t10_cash_block_request
         WHERE     t10_from_date <= func_get_eod_date () + 1
               AND t10_to_date > func_get_eod_date ()
               AND t10_status = 2;
BEGIN
    FOR rec IN blocked_cash_accounts
    LOOP
        UPDATE u06_cash_account u06
           SET u06.u06_manual_transfer_blocked = 0,
               u06.u06_manual_trade_blocked = 0
         WHERE u06.u06_id = rec.u06_id;
    END LOOP;

    FOR rec IN block_requests
    LOOP
        IF (rec.t10_type = 1)
        THEN
            UPDATE u06_cash_account u06
               SET u06.u06_manual_transfer_blocked =
                         u06.u06_manual_transfer_blocked
                       + rec.t10_amount_blocked
             WHERE u06.u06_id = rec.t10_cash_account_id_u06;
        ELSE
            UPDATE u06_cash_account u06
               SET u06.u06_manual_trade_blocked =
                       u06.u06_manual_trade_blocked + rec.t10_amount_blocked
             WHERE u06.u06_id = rec.t10_cash_account_id_u06;
        END IF;
    END LOOP;
END;
/
