CREATE OR REPLACE PROCEDURE dfn_ntp.validte_trad_acc_by_cash_acc (
    pu06_id IN NUMBER)
IS
    l_count           NUMBER;
    lholdings_count   NUMBER;
    lbuy_pending      NUMBER;
    lsell_pending     NUMBER;
BEGIN
    FOR i
        IN (  SELECT u24_trading_acnt_id_u07,
                     COUNT (u24.u24_trading_acnt_id_u07) AS trading_acc_count,
                     SUM (ABS (u24.u24_buy_pending)) AS tot_u24_buy_pending,
                     SUM (ABS (u24.u24_sell_pending)) AS tot_u24_sell_pending
                FROM     u24_holdings u24
                     JOIN
                         u07_trading_account u07
                     ON u24.u24_trading_acnt_id_u07 = u07.u07_id
               WHERE (   u24.u24_net_holding > 0
                      OR u24.u24_pledge_qty > 0
                      OR u24.u24_buy_pending > 0
                      OR u24.u24_sell_pending > 0
                      OR u24.u24_payable_holding > 0
                      OR u24.u24_receivable_holding > 0
                      OR u24.u24_manual_block > 0)
            GROUP BY u24.u24_trading_acnt_id_u07)
    LOOP
        NULL;
    END LOOP;
END;
/
/
