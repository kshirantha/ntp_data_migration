CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u24_futures_holdings
(
    customer_id,
    customer_no,
    customer_name,
    institution_id,
    u07_display_name,
    u24_exchange_code_m01,
    u24_symbol_code_m20,
    u24_symbol_id_m20,
    u24_trading_acnt_id_u07,
    u07_custodian_id_m26,
    custodian_name,
    future_name,
    no_of_contracts,
    market_price,
    average_price,
    initial_margin_value,
    maintenance_margin,
    maintenance_margin_blocked,
    notional_value,
    portfolio_valuation,
    margin_variation
)
AS
    (SELECT u07.u07_customer_id_u01 AS customer_id,
            u07.u07_customer_no_u01 AS customer_no,
            u07.u07_display_name_u01 AS customer_name,
            u07.u07_institute_id_m02 AS institution_id,
            u07_display_name,
            u24_exchange_code_m01,
            u24_symbol_code_m20,
            u24_symbol_id_m20,
            u24.u24_trading_acnt_id_u07,
            u07.u07_custodian_id_m26,
            m26.m26_name AS custodian_name,
            NVL (m20.m20_short_description, m20.m20_symbol_code)
                AS future_name,
            u24.u24_net_holding AS no_of_contracts,
            s_price.market_price AS market_price,
            u24.u24_avg_price AS average_price,
            u24.u24_net_holding * u24.u24_avg_price AS initial_margin_value,
            u24.u24_maintain_margin_charged AS maintenance_margin,
            u24.u24_maintain_margin_block AS maintenance_margin_blocked,
            u24.u24_net_holding * m20.m20_lot_size * s_price.market_price
                AS notional_value,
              u24.u24_maintain_margin_charged
            + u24.u24_net_holding * NVL (esp.settlement_price, 0)
                AS portfolio_valuation,
            u24_maintain_margin_charged AS margin_variation
       FROM u24_holdings u24
            JOIN u07_trading_account u07
                ON u24.u24_trading_acnt_id_u07 = u07.u07_id
            JOIN m20_symbol m20 ON u24.u24_symbol_id_m20 = m20.m20_id
            LEFT JOIN m125_exchange_instrument_type m125
                ON     m125.m125_instrument_type_id_v09 =
                           m20.m20_instrument_type_id_v09
                   AND m125.m125_exchange_id_m01 = m20.m20_exchange_id_m01
            LEFT JOIN m20_symbol_extended m20_ex
                ON u24.u24_symbol_id_m20 = m20_ex.m20_id
            LEFT JOIN vw_symbol_prices s_price
                ON u24.u24_symbol_id_m20 = s_price.symbol_id
            LEFT JOIN m26_executing_broker m26
                ON u24.u24_custodian_id_m26 = m26.m26_id
            LEFT JOIN dfn_price.esp_todays_snapshots esp
                ON     u24.u24_exchange_code_m01 = esp.exchangecode
                   AND u24.u24_symbol_code_m20 = esp.symbol
      WHERE m20.m20_instrument_type_code_v09 = 'FUT' /*     AND (   u24.u24_net_holding <> 0
                                                                     OR u24.u24_payable_holding <> 0
                                                                     OR u24.u24_receivable_holding <> 0
                                                                     OR u24.u24_buy_pending <> 0
                                                                     OR u24.u24_sell_pending <> 0)*/
                                                    )
/