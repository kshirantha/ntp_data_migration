CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u24_holdings_master
(
    u24_exchange_code_m01,
    u24_symbol_code_m20,
    u24_symbol_id_m20,
    net_holding,
    vwap,
    total_value,
    description,
    external_reference,
    symbol_code,
    last_trade_price,
    previous_closed,
    cusip_no,
    isin_code,
    reuters_code,
    instrument_type,
    u07_institute_id_m02
)
AS
    SELECT a.u24_exchange_code_m01,
           a.u24_symbol_code_m20,
           a.u24_symbol_id_m20,
           a.tot AS net_holding,
           b.vwap,
           (a.tot * NVL (b.market_price, 0)) AS total_value,
           NVL (m20.m20_short_description, m20.m20_symbol_code)
               AS description,
           NULL AS external_reference,
           m20.m20_symbol_code AS symbol_code,
           b.last_trade_price,
           b.previous_closed,
           m20.m20_cusip_no AS cusip_no,
           m20.m20_isincode AS isin_code,
           m20.m20_reuters_code AS reuters_code,
           m20.m20_instrument_type_code_v09 AS instrument_type,
           m20.m20_institute_id_m02 AS u07_institute_id_m02
      FROM (  SELECT u24_symbol_id_m20,
                     MAX (u24.u24_exchange_code_m01) AS u24_exchange_code_m01,
                     MAX (u24.u24_symbol_code_m20) AS u24_symbol_code_m20,
                     SUM (
                           u24.u24_net_holding
                         + u24.u24_payable_holding
                         - u24.u24_receivable_holding
                         - u24.u24_manual_block)
                         tot
                FROM u24_holdings u24
            GROUP BY u24.u24_symbol_id_m20
              HAVING SUM (
                           u24.u24_net_holding
                         + u24.u24_payable_holding
                         - u24.u24_receivable_holding
                         - u24.u24_manual_block) > 0) a,
           vw_symbol_prices b,
           m20_symbol m20
     WHERE     a.u24_symbol_id_m20 = m20.m20_id
           AND a.u24_symbol_id_m20 = b.symbol_id
/