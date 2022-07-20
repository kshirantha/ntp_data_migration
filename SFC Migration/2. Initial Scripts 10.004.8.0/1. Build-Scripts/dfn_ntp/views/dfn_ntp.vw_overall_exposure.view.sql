CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_overall_exposure
(
    expiry,
    expiry_year,
    aggregate_long,
    aggregate_short,
    net_aggregate
)
AS
    SELECT   expiry,
             expiry_year,
             aggregate_long,
             aggregate_short,
             aggregate_long + aggregate_short AS net_aggregate
        FROM (SELECT   CASE
                           WHEN SUM (
                                      (  u24.u24_net_holding
                                       + u24.u24_payable_holding
                                       - u24.u24_receivable_holding)
                                    * u24.u24_avg_price) > 0
                           THEN
                               SUM (
                                     (  u24.u24_net_holding
                                      + u24.u24_payable_holding
                                      - u24.u24_receivable_holding)
                                   * u24.u24_avg_price)
                           ELSE
                               0
                       END
                           AS aggregate_long,
                       CASE
                           WHEN SUM (
                                      (  u24.u24_net_holding
                                       + u24.u24_payable_holding
                                       - u24.u24_receivable_holding)
                                    * u24.u24_avg_price
                                    * 2) < 0
                           THEN
                               SUM (
                                     (  u24.u24_net_holding
                                      + u24.u24_payable_holding
                                      - u24.u24_receivable_holding)
                                   * u24.u24_avg_price
                                   * 2)
                           ELSE
                               0
                       END
                           AS aggregate_short,
                       expiry,
                       TO_CHAR (expiry, 'yyyy') AS expiry_year
                  FROM u24_holdings u24,
                       (SELECT m20.m20_exchange_code_m01,
                               m20.m20_symbol_code,
                               m20.m20_instrument_type_code_v09,
                               m20.m20_expire_date AS expiry
                          FROM m20_symbol m20) m20,
                       u07_trading_account u07,
                       dfn_price.esp_todays_snapshots c
                 WHERE     u24.u24_exchange_code_m01 = m20.m20_exchange_code_m01
                       AND u24.u24_symbol_code_m20 = m20.m20_symbol_code
                       AND u24.u24_exchange_code_m01 = c.exchangecode
                       AND u24.u24_symbol_code_m20 = c.symbol
                       AND u24.u24_trading_acnt_id_u07 = u07.u07_id
                       AND m20.m20_instrument_type_code_v09 = 'FUT'
                       AND expiry >= TRUNC (SYSDATE)
              GROUP BY expiry, TO_CHAR (expiry, 'yyyy'))
    ORDER BY expiry
/