CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_t02_settled_trades (
    tradingaccountid IN NUMBER)
IS
    l_t02_cash_acnt_id_u06   u06_cash_account.u06_id%TYPE;
    l_m01_settle_customer    m01_exchanges.m01_settle_customer%TYPE;
BEGIN
    SELECT u07.u07_cash_account_id_u06, m01.m01_settle_customer
      INTO l_t02_cash_acnt_id_u06, l_m01_settle_customer
      FROM u07_trading_account u07, m01_exchanges m01
     WHERE     u07.u07_exchange_id_m01 = m01.m01_id
           AND u07.u07_id = tradingaccountid;

    UPDATE t01_order
       SET t01_trade_process_stat_id_v01 = 25
     WHERE t01_cl_ord_id IN
               (SELECT DISTINCT t02_cliordid_t01
                  FROM t02_transaction_log
                 WHERE     t02_cash_acnt_id_u06 = l_t02_cash_acnt_id_u06
                       AND t02_trd_acnt_id_u07 = tradingaccountid
                       AND t02_trade_process_stat_id_v01 = 24
                       AND t02_holding_settle_date <=
                                 func_get_eod_date
                               + DECODE (l_m01_settle_customer, 1, 0, 1));

    UPDATE t02_transaction_log
       SET t02_trade_process_stat_id_v01 = 25
     WHERE     t02_cash_acnt_id_u06 = l_t02_cash_acnt_id_u06
           AND t02_trd_acnt_id_u07 = tradingaccountid
           AND t02_trade_process_stat_id_v01 = 24
           AND t02_holding_settle_date <=
                     func_get_eod_date
                   + DECODE (l_m01_settle_customer, 1, 0, 1);
END;
/