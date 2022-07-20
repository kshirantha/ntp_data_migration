CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_csm_todays_executions_dtls
(
    t02_create_date,
    t02_order_exec_id,
    u07_customer_id_u01,
    u07_customer_no_u01,
    u07_display_name_u01,
    t02_exchange_code_m01,
    u07_exchange_account_no,
    m86_account_number,
    t02_symbol_code_m20,
    t02_side,
    t02_cash_settle_date,
    u07_id
)
AS
    SELECT t02.t02_create_date,
           t02.t02_order_exec_id,
           u07.u07_customer_id_u01,
           u07.u07_customer_no_u01,
           u07.u07_display_name_u01,
           t02.t02_exchange_code_m01,
           u07.u07_exchange_account_no,
           m86.m86_account_number,
           t02.t02_symbol_code_m20,
           t02.t02_side,
           t02.t02_cash_settle_date,
           u07.u07_id
      FROM t02_transaction_log_order_all t02
           LEFT JOIN u07_trading_account u07
               ON t02.t02_trd_acnt_id_u07 = u07.u07_id
           LEFT JOIN m86_ex_clearing_accounts m86
               ON u07.u07_clearing_acc_m86 = m86.m86_id
     WHERE     t02.t02_exchange_code_m01 = 'TDWL'
           AND t02_update_type IN (1)
           AND t02.t02_create_date BETWEEN TRUNC (SYSDATE - 10)
                                       AND TRUNC (SYSDATE) + 0.99999
/
