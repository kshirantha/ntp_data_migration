CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u24_open_opt_contracts
(
    m20_id,
    u07_id,
    u01_id,
    institution,
    customername,
    u24_trading_acnt_id_u07,
    u24_exchange_code_m01,
    u24_symbol_code_m20,
    tot_holdings_with_unsettle,
    u24_avg_cost,
    market_price,
    m20_expire_date,
    m20_short_description,
    m20_short_description_lang,
    m20_long_description,
    m20_long_description_lang,
    u24_custodian_code_m26
)
AS
    SELECT m20.m20_id,
           u07.u07_id,
           u01.u01_id,
           u07.u07_institute_id_m02 AS institution,
           NVL (u01.u01_first_name || ' ', '') || NVL (u01.u01_last_name, '')
               AS customername,
           u24.u24_trading_acnt_id_u07,
           u24.u24_exchange_code_m01,
           u24.u24_symbol_code_m20,
           (  u24.u24_net_holding
            + u24.u24_payable_holding
            - u24.u24_receivable_holding
            - u24.u24_holding_block)
               AS tot_holdings_with_unsettle,
           u24.u24_avg_cost,
           esp.market_price AS market_price,
           m20.m20_expire_date,
           m20.m20_short_description AS m20_short_description,
           m20.m20_short_description_lang AS m20_short_description_lang,
           m20.m20_long_description AS m20_long_description,
           m20.m20_long_description_lang AS m20_long_description_lang,
           u24.u24_custodian_code_m26
      FROM u24_holdings u24
           JOIN m20_symbol m20
               ON     (   ABS (u24_net_holding) > 0
                       OR ABS (u24_payable_holding) > 0
                       OR ABS (u24_receivable_holding) > 0
                       OR ABS (u24_pledge_qty) > 0
                       OR ABS (u24_buy_pending) > 0
                       OR ABS (u24_sell_pending) > 0
                       OR ABS (u24.u24_manual_block) > 0)
                  AND m20_instrument_type_code_v09 = 'OPT'
                  -- AND m20_expire_date >= TRUNC (SYSDATE)
                  --AND u24.u24_exchange_code_m01 = m20.m20_exchange_code_m01
                  --AND u24.u24_symbol_code_m20 = m20.m20_symbol_code
                  AND u24.u24_symbol_id_m20 = m20.m20_id
           JOIN u07_trading_account u07
               ON u24.u24_trading_acnt_id_u07 = u07.u07_id
           JOIN u01_customer u01
               ON     u07.u07_customer_id_u01 = u01.u01_id
                  AND u01_account_category_id_v01 != 3
           LEFT JOIN vw_esp_market_price_today esp
               ON     u24.u24_exchange_code_m01 = esp.exchangecode
                  AND u24.u24_symbol_code_m20 = esp.symbol
/