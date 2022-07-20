CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_dc_invalid_holdings_and_log
(
    u07_id,
    u24_trading_acnt_id_u07,
    u07_customer_no_u01,
    u07_display_name_u01,
	u07_institute_id_m02,
    u24_symbol_code_m20,
    u24_exchange_code_m01,
    cash_log_bal,
    u24_net_holding,
    u24_sell_pending,
    u24_buy_pending,
    diff
)
AS
    SELECT u07_id,
           u24_trading_acnt_id_u07,
           u07_customer_no_u01,
           u07_display_name_u01,
		   u07_institute_id_m02,
           u24_symbol_code_m20,
           u24_exchange_code_m01,
           cash_log_bal,
           u24_net_holding,
           u24_sell_pending,
           u24_buy_pending,
           cash_log_bal - u24_net_holding AS diff
      FROM (  SELECT u07.u07_id,
                     u24.u24_trading_acnt_id_u07,
                     u07.u07_customer_no_u01,
                     u07.u07_display_name_u01,
					 u07.u07_institute_id_m02,
                     u24.u24_symbol_code_m20,
                     u24.u24_exchange_code_m01,
                     SUM (NVL (u24.u24_sell_pending, 0)) u24_sell_pending,
                     SUM (NVL (u24.u24_buy_pending, 0)) u24_buy_pending,
                     SUM (NVL (u24.u24_net_holding, 0)) u24_net_holding
                FROM     dfn_ntp.u24_holdings u24
                     JOIN
                         dfn_ntp.u07_trading_account u07
                     ON u24.u24_trading_acnt_id_u07 = u07.u07_id
            GROUP BY u07.u07_id,
                     u24.u24_trading_acnt_id_u07,
                     u07.u07_customer_no_u01,
                     u07.u07_display_name_u01,
					 u07.u07_institute_id_m02,
                     u24.u24_symbol_code_m20,
                     u24.u24_exchange_code_m01) snapsum,
           (  SELECT t02.t02_trd_acnt_id_u07,
                     t02.t02_symbol_code_m20,
                     t02.t02_exchange_code_m01,
                     SUM (NVL (t02.t02_holding_net_adjst, 0)) cash_log_bal
                FROM dfn_ntp.t02_transaction_log_hold_all t02
            GROUP BY t02.t02_trd_acnt_id_u07,
                     t02.t02_symbol_code_m20,
                     t02.t02_exchange_code_m01) logsum
     WHERE        logsum.t02_trd_acnt_id_u07 = snapsum.u07_id
              AND cash_log_bal - u24_net_holding <> 0
           OR u24_net_holding < 0
/
