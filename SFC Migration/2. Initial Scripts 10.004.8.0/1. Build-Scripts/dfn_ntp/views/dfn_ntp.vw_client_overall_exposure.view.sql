CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_client_overall_exposure
(
    t03_external_reference,
    m01_external_ref_no,
    aggregate_long,
    aggregate_short,
    net_aggregate,
    expiry,
    marginenabled,
    u01_id
)
AS
    (SELECT t03_external_reference,
            m01_external_ref_no,
            aggregate_long,
            aggregate_short,
            aggregate_long + aggregate_short AS net_aggregate,
            expiry,
            marginenabled,
            u01_id
       FROM (  SELECT NVL (u06.u06_external_ref_no,
                           u06.u06_investment_account_no)
                          AS t03_external_reference,
                      u01.u01_external_ref_no AS m01_external_ref_no,
                      CASE
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
                      CASE
                          WHEN (u06.u06_margin_enabled = 1) THEN 'Yes'
                          ELSE 'No'
                      END
                          AS marginenabled,
                      MAX (u01_id) AS u01_id
                 FROM u24_holdings u24,
                      (SELECT m20.m20_exchange_code_m01,
                              m20.m20_symbol_code,
                              m20.m20_instrument_type_code_v09,
                              m20.m20_expire_date AS expiry
                         FROM m20_symbol m20) m20,
                      u07_trading_account u07,
                      dfn_price.esp_todays_snapshots c,
                      u01_customer u01,
                      u06_cash_account u06
                WHERE     u24.u24_exchange_code_m01 = m20.m20_exchange_code_m01
                      AND u24.u24_symbol_code_m20 = m20.m20_symbol_code
                      AND u24.u24_exchange_code_m01 = c.exchangecode
                      AND u24.u24_symbol_code_m20 = c.symbol
                      AND u24.u24_trading_acnt_id_u07 = u07.u07_id
                      AND u07.u07_customer_id_u01 = u01.u01_id
                      AND u07.u07_cash_account_id_u06 = u06.u06_id
                      AND m20.m20_instrument_type_code_v09 = 'FUT'
                      AND expiry >= TRUNC (SYSDATE)
             GROUP BY NVL (u06.u06_external_ref_no,
                           u06.u06_investment_account_no),
                      u01_external_ref_no,
                      u06_margin_enabled,
                      expiry))
/