CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_holding_for_exchange_symbol
(
    u24_exchange_code_m01,
    u24_symbol_id_m20,
    u24_symbol_code_m20,
    u24_net_holding
)
AS
    SELECT   u24_exchange_code_m01,
             u24_symbol_id_m20,
             u24_symbol_code_m20,
             SUM (
                   u24.u24_net_holding
                 + u24.u24_payable_holding
                 - u24.u24_receivable_holding)
                 u24_net_holding
        FROM u24_holdings u24
    GROUP BY u24.u24_exchange_code_m01,
             u24.u24_symbol_id_m20,
             u24_symbol_code_m20
      HAVING SUM (
                   u24.u24_net_holding
                 + u24.u24_payable_holding
                 - u24.u24_receivable_holding) > 0
/