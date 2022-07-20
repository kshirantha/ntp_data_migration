CREATE OR REPLACE FORCE VIEW dfn_ntp.holding_symbols_v
(
    exchange,
    symbol,
    price_instrument_type,
    subscription_type
)
AS
    SELECT DISTINCT m20.m20_exchange_code_m01 AS exchange,
                    m20.m20_symbol_code AS symbol,
                    v34.v34_price_inst_type_id AS price_instrument_type,
                    0 AS subscription_type
      FROM u24_holdings u24
           JOIN m20_symbol m20
               ON     u24.u24_exchange_code_m01 = m20.m20_exchange_code_m01
                  AND u24.u24_symbol_code_m20 = m20.m20_symbol_code
           JOIN v34_price_instrument_type v34
               ON m20.m20_price_instrument_id_v34 = v34.v34_id
     WHERE (   u24.u24_net_holding <> 0
            OR u24.u24_payable_holding <> 0
            OR u24.u24_receivable_holding <> 0
            OR u24.u24_holding_block <> 0)
/
