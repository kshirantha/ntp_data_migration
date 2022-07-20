CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t01_unsettled_trades
(
    u07_customer_id_u01,
    u07_customer_no_u01,
    u07_display_name_u01,
    u07_display_name,
    u07_institute_id_m02,
    t02_cash_settle_date,
    t02_order_no,
    m20_short_description,
    m20_short_description_lang,
    t01_date,
    t01_exchange_code_m01,
    t01_instrument_type_code,
    t01_symbol_code_m20,
    t02_last_price,
    t02_last_shares,
    ord_side,
    receivable_hold,
    payable_hold,
    t02_settle_currency,
    t02_amnt_in_stl_currency,
    payable_amt,
    receivable_amt
)
AS
    SELECT u07.u07_customer_id_u01,
           u07.u07_customer_no_u01,
           u07.u07_display_name_u01,
           u07.u07_display_name,
           u07.u07_institute_id_m02,
           t02.t02_cash_settle_date,
           t02.t02_order_no,
           m20.m20_short_description,
           m20.m20_short_description_lang,
           t01.t01_date,
           t01.t01_exchange_code_m01,
           t01.t01_instrument_type_code,
           t01.t01_symbol_code_m20,
           t02.t02_last_price,
           t02.t02_last_shares,
           CASE WHEN t01.t01_side = 1 THEN 'BUY' ELSE 'SELL' END AS ord_side,
           CASE WHEN t01.t01_side = 1 THEN t02.t02_last_shares ELSE 0 END
               AS receivable_hold,
           CASE WHEN t01.t01_side != 1 THEN t02.t02_last_shares ELSE 0 END
               AS payable_hold,
           t02.t02_settle_currency,
           ABS (t02.t02_amnt_in_stl_currency) AS t02_amnt_in_stl_currency,
           CASE
               WHEN t01.t01_side = 1 THEN ABS (t02.t02_amnt_in_stl_currency)
               ELSE 0
           END
               AS payable_amt,
           CASE
               WHEN t01.t01_side != 1 THEN ABS (t02.t02_amnt_in_stl_currency)
               ELSE 0
           END
               AS receivable_amt
      FROM t01_order t01
           INNER JOIN vw_t02_cash_txn_log_all t02
               ON     t01.t01_ord_no = t02.t02_order_no
                  AND (t01.t01_status_id_v30 IN ('1', '2', 'q', 'r', '5')
                  OR t02.t02_trade_process_stat_id_v01 NOT IN (25))
           INNER JOIN u07_trading_account u07
               ON t01.t01_trading_acc_id_u07 = u07.u07_id
           INNER JOIN m20_symbol m20
               ON t01.t01_symbol_id_m20 = m20.m20_id;
/
