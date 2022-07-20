CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_offline_symbol_with_holding
(
    isin_code,
    currency_code,
    reuters_code,
    exchange_code,
    symbol_code
)
AS
    SELECT NVL (m20.m20_isincode, 'N/A') AS isin_code,
           NVL (m20.m20_currency_code_m03, 'N/A') AS currency_code,
           NVL (m20.m20_reuters_code, 'N/A') AS reuters_code,
           NVL (m20.m20_exchange_code_m01, 'N/A') AS exchange_code,
           NVL (m20.m20_symbol_code, 'N/A') AS symbol_code
      FROM m20_symbol m20, u24_holdings u24, m01_exchanges m01
     WHERE     m20.m20_exchange_code_m01 = u24.u24_exchange_code_m01
           AND m20.m20_id = u24.u24_symbol_id_m20
           AND (  u24.u24_net_holding
                + u24.u24_payable_holding
                - u24.u24_receivable_holding
                - u24.u24_holding_block
                - u24.u24_manual_block
                - u24.u24_pledge_qty) != 0
           AND m01.m01_offline_feed = 1
           AND m20.m20_exchange_id_m01 = m01.m01_id
    GROUP BY m20.m20_symbol_code,
             m20.m20_exchange_code_m01,
             m20.m20_reuters_code,
             m20.m20_isincode,
             m20.m20_currency_code_m03
/