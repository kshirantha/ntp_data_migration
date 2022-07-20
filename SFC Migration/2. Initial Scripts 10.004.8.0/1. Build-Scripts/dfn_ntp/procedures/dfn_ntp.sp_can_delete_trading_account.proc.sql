CREATE OR REPLACE PROCEDURE dfn_ntp.sp_can_delete_trading_account (
    pkey         OUT VARCHAR,
    pu06_id   IN     NUMBER)
IS
    l_count           NUMBER;
    lholdings_count   NUMBER;
    lbuy_pending      NUMBER;
    lsell_pending     NUMBER;
BEGIN
    FOR i IN (SELECT u07.u07_id
                FROM u07_trading_account u07
               WHERE u07.u07_cash_account_id_u06 = pu06_id)
    LOOP
        SELECT COUNT (u24.u24_trading_acnt_id_u07) AS trading_acc_count,
               SUM (ABS (u24.u24_buy_pending)) AS tot_u24_buy_pending,
               SUM (ABS (u24.u24_sell_pending)) AS tot_u24_sell_pending
          INTO lholdings_count, lbuy_pending, lsell_pending
          FROM u24_holdings u24
         WHERE     (   u24.u24_net_holding > 0
                    OR u24.u24_pledge_qty > 0
                    OR u24.u24_buy_pending > 0
                    OR u24.u24_sell_pending > 0
                    OR u24.u24_payable_holding > 0
                    OR u24.u24_receivable_holding > 0
                    OR u24.u24_manual_block > 0)
               AND u24.u24_trading_acnt_id_u07 = i.u07_id;

        IF lholdings_count > 0
        THEN
            pkey := '1';
            RETURN;
        ELSIF lbuy_pending > 0 OR lsell_pending > 0
        THEN
            pkey := '2';
            RETURN;
        ELSE
            pkey := '0';
        END IF;
    END LOOP;
END;
/
/
