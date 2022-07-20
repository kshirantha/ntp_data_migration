CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u24_unsettled_holdings
(
    u01_id,
    u01_customer_no,
    u01_display_name,
    u01_display_name_lang,
    u01_external_ref_no,
    u01_institute_id_m02,
    u06_investment_account_no,
    u07_display_name,
    u06_display_name,
    u24_symbol_code_m20,
    u24_exchange_code_m01,
    u24_net_holding,
    u24_payable_holding,
    u24_receivable_holding,
    m20_short_description,
    m20_short_description_lang
)
AS
    SELECT u01.u01_id,
           u01.u01_customer_no,
           u01.u01_display_name,
           u01.u01_display_name_lang,
           u01.u01_external_ref_no,
           u01.u01_institute_id_m02,
           u06.u06_investment_account_no,
           u07.u07_display_name,
           u06.u06_display_name,
           u24.u24_symbol_code_m20,
           u24.u24_exchange_code_m01,
           u24.u24_net_holding,
           u24.u24_payable_holding,
           u24.u24_receivable_holding,
           m20.m20_short_description,
           m20.m20_short_description_lang
      FROM u24_holdings u24,
           u07_trading_account u07,
           m20_symbol m20,
           u06_cash_account u06,
           u01_customer u01
     WHERE     u24.u24_trading_acnt_id_u07 = u07.u07_id
           AND u07.u07_cash_account_id_u06 = u06.u06_id
           AND u07.u07_customer_id_u01 = u01.u01_id
           AND u24.u24_symbol_id_m20 = m20.m20_id
           AND (u24.u24_payable_holding <> 0 OR u24_receivable_holding <> 0);
/
