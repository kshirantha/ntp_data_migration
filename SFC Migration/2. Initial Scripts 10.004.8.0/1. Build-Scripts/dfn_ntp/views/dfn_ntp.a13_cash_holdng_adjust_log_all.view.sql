CREATE OR REPLACE FORCE VIEW dfn_ntp.a13_cash_holdng_adjust_log_all
(
    a13_id,
    a13_adjust_status,
    a13_job_id_v07,
    a13_created_date,
    a13_cash_account_id_u06,
    a13_u06_balance,
    a13_u06_payable_blocked,
    a13_u06_receivable_amount,
    a13_u06_net_receivable,
    a13_u24_trading_acnt_id_u07,
    a13_u24_custodian_id_m26,
    a13_u24_symbol_id_m20,
    a13_u24_receivable_holding,
    a13_u24_payable_holding,
    a13_u24_net_receivable,
    a13_u24_symbol_code_m20,
    a13_u24_exchange_code_m01,
    a13_code_m97,
    a13_created_date_time,
    a13_impact_type,
    a13_t02_required,
    a13_u24_net_holding,
    a13_narration
)
AS
    SELECT a13_id,
           a13_adjust_status,
           a13_job_id_v07,
           a13_created_date,
           a13_cash_account_id_u06,
           a13_u06_balance,
           a13_u06_payable_blocked,
           a13_u06_receivable_amount,
           a13_u06_net_receivable,
           a13_u24_trading_acnt_id_u07,
           a13_u24_custodian_id_m26,
           a13_u24_symbol_id_m20,
           a13_u24_receivable_holding,
           a13_u24_payable_holding,
           a13_u24_net_receivable,
           a13_u24_symbol_code_m20,
           a13_u24_exchange_code_m01,
           a13_code_m97,
           a13_created_date_time,
           a13_impact_type,
           a13_t02_required,
           a13_u24_net_holding,
           a13_narration
      FROM dfn_ntp.a13_cash_holding_adjust_log
    UNION ALL
    SELECT a13_id,
           a13_adjust_status,
           a13_job_id_v07,
           a13_created_date,
           a13_cash_account_id_u06,
           a13_u06_balance,
           a13_u06_payable_blocked,
           a13_u06_receivable_amount,
           a13_u06_net_receivable,
           a13_u24_trading_acnt_id_u07,
           a13_u24_custodian_id_m26,
           a13_u24_symbol_id_m20,
           a13_u24_receivable_holding,
           a13_u24_payable_holding,
           a13_u24_net_receivable,
           a13_u24_symbol_code_m20,
           a13_u24_exchange_code_m01,
           a13_code_m97,
           a13_created_date_time,
           a13_impact_type,
           a13_t02_required,
           a13_u24_net_holding,
           a13_narration
      FROM dfn_arc.a13_cash_holding_adjust_log
/
