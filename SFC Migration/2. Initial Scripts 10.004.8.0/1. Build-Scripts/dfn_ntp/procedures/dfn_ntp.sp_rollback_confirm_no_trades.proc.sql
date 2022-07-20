CREATE OR REPLACE PROCEDURE dfn_ntp.sp_rollback_confirm_no_trades(p_confirm_no IN NUMBER) IS
BEGIN
  UPDATE t02_transaction_log
     SET t02_trade_confirm_no = NULL
   WHERE t02_trade_confirm_no = p_confirm_no;
END;
/
