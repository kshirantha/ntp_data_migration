CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u24_holdings_all
(
    customer_id,
    customer_no,
    customer_name,
    institution_id,
    u07_display_name,
    u07_custodian_id_m26,
    u24_trading_acnt_id_u07,
    u24_exchange_code_m01,
    u24_symbol_code_m20,
    u24_symbol_id_m20,
    tot_holdings_with_unsettles,
    avg_cost,
    u24_sell_pending,
    u24_buy_pending,
    u24_weighted_avg_price,
    tot_hld_val_with_unsettles,
    vwap,
    short_description,
    long_description,
    short_description_lang,
    long_description_lang,
    expiry_date,
    avg_price,
    currency,
    last_trade_price,
    previous_closed,
    market_price,
    profitpercentage,
    profit,
    u07_exchange_account_no,
    m20_instrument_type_code_v09,
    strike_price,
    option_expiry_date,
    option_type,
    m20_cusip_no,
    m20_isincode,
    m20_reuters_code,
    u24_payable_holding,
    u24_receivable_holding,
    availableqty,
    transfer_availableqty,
    total_cost,
    m20_id,
    u24_custodian_id_m26,
    custodian_name,
    u24_manual_block,
    u24_net_holding,
    u24_pledge_qty,
    pledge_qty,
    market_value,
    market_value_with_unsettles,
    m20_lot_size,
    u24_holding_block,
    m125_allow_sell_unsettle_hold,
    u06_investment_account_no,
    u24_short_holdings,
    u07_exchange_id_m01,
    transferqty,
    settlement_price,
    u24_maintain_margin_charged,
    u24_pending_subscribe_qty,
    u24_subscribed_qty,
    u24_weighted_avg_cost,
    margin_valuation
)
AS
    SELECT u07.u07_customer_id_u01 AS customer_id,
           u07.u07_customer_no_u01 AS customer_no,
           u07.u07_display_name_u01 AS customer_name,
           u07.u07_institute_id_m02 AS institution_id,
           u07_display_name,
           u07.u07_custodian_id_m26,
           u24.u24_trading_acnt_id_u07,
           u24.u24_exchange_code_m01,
           u24.u24_symbol_code_m20,
           u24.u24_symbol_id_m20,
           (  u24.u24_net_holding
            + u24.u24_payable_holding
            - u24.u24_receivable_holding)
               AS tot_holdings_with_unsettles,
           ROUND (u24.u24_avg_cost, 8) avg_cost,
           u24.u24_sell_pending,
           u24.u24_buy_pending,
           u24.u24_weighted_avg_price,
             (  u24.u24_net_holding
              + u24.u24_payable_holding
              - u24.u24_receivable_holding)
           * u24.u24_weighted_avg_price
           * m20.m20_lot_size
               AS tot_hld_val_with_unsettles,
           s_price.vwap AS vwap,
           NVL (m20.m20_short_description, m20.m20_symbol_code)
               AS short_description,
           m20.m20_long_description AS long_description,
           NVL (m20.m20_short_description_lang, m20.m20_symbol_code)
               AS short_description_lang,
           m20.m20_long_description_lang AS long_description_lang,
           m20.m20_expire_date AS expiry_date,
           ROUND (u24.u24_avg_price, 2) avg_price,
           u06.u06_currency_code_m03 AS currency,
           ROUND (
               DECODE (NVL (esp.lasttradeprice, 0),
                       0, esp.previousclosed,
                       esp.lasttradeprice),
               2)
               last_trade_price,
           ROUND (s_price.previous_closed, 2) previous_closed,
           ROUND (s_price.market_price, 2) AS market_price,
           CASE
               WHEN (u24.u24_avg_cost <> 0)
               THEN
                   TRUNC (
                       (  (  (s_price.market_price - u24.u24_avg_cost)
                           / u24.u24_avg_cost)
                        * 100),
                       8)
               ELSE
                   0
           END
               AS profitpercentage,
             (s_price.market_price - u24.u24_avg_cost)
           * (  u24.u24_net_holding
              - DECODE (m125.m125_allow_sell_unsettle_hold,
                        1, 0,
                        u24.u24_receivable_holding)
              - u24.u24_manual_block
              - u24.u24_pledge_qty)
           * m20.m20_lot_size
               AS profit,
           u07.u07_exchange_account_no,
           m20.m20_instrument_type_code_v09,
           CASE
               WHEN m20.m20_instrument_type_code_v09 = 'OPT'
               THEN
                   m20.m20_strike_price
           END
               AS strike_price,
           CASE
               WHEN    m20.m20_instrument_type_code_v09 = 'OPT'
                    OR m20.m20_instrument_type_code_v09 = 'BN'
               THEN
                   TO_DATE (
                       m20_ex.m20_maturity_myear || m20_ex.m20_maturity_day,
                       'yyyymmdd')
               WHEN m20.m20_instrument_type_code_v09 = 'RHT'
               THEN
                   m20.m20_expire_date
           END
               AS option_expiry_date,
           CASE WHEN m20.m20_option_type = 0 THEN 'Put' ELSE 'Call' END
               AS option_type,
           m20.m20_cusip_no,
           m20.m20_isincode,
           m20.m20_reuters_code,
           u24.u24_payable_holding,
           u24.u24_receivable_holding,
           (  (  u24.u24_net_holding
               - DECODE (m125.m125_allow_sell_unsettle_hold,
                         1, 0,
                         u24.u24_receivable_holding)
               - u24.u24_manual_block)
            - u24.u24_holding_block
            - u24.u24_pledge_qty)
               AS availableqty,
           (  (  u24.u24_net_holding
               - u24.u24_receivable_holding
               - u24.u24_manual_block)
            - u24.u24_holding_block
            - u24.u24_pledge_qty)
               AS transfer_availableqty,
           (  (  (  u24.u24_net_holding
                  - DECODE (m125.m125_allow_sell_unsettle_hold,
                            1, 0,
                            u24.u24_receivable_holding)
                  - u24.u24_manual_block)
               - u24.u24_pledge_qty)
            * ROUND (u24.u24_avg_cost, 8)
            * m20.m20_lot_size)
               AS total_cost,
           m20.m20_id,
           u24.u24_custodian_id_m26,
           CASE
               WHEN m26.m26_sid IS NOT NULL
               THEN
                   m26.m26_sid || '-' || m26.m26_name
               ELSE
                   m26.m26_name
           END
               AS custodian_name,
           u24.u24_manual_block,
           u24.u24_net_holding,
           u24.u24_pledge_qty,
           CASE
               WHEN m20.m20_instrument_type_code_v09 != 'BN'
               THEN
                   u24.u24_pledge_qty
               ELSE
                   0
           END
               AS pledge_qty,
             s_price.market_price
           * (  (  u24.u24_net_holding
                 - DECODE (m125.m125_allow_sell_unsettle_hold,
                           1, 0,
                           u24.u24_receivable_holding)
                 - u24.u24_manual_block)
              - u24.u24_pledge_qty)
           * m20.m20_lot_size
               AS market_value,
             (  u24.u24_net_holding
              + u24.u24_payable_holding
              - u24.u24_receivable_holding)
           * s_price.market_price
           * m20.m20_lot_size
               AS market_value_with_unsettles,
           m20.m20_lot_size,
           u24.u24_holding_block,
           m125.m125_allow_sell_unsettle_hold,
           u06.u06_investment_account_no,
           u24.u24_short_holdings,
           u07_exchange_id_m01,
           (  (  u24.u24_net_holding
               - DECODE (m125.m125_allow_sell_unsettle_hold,
                         1, 0,
                         u24.u24_receivable_holding)
               - u24.u24_manual_block)
            - u24.u24_holding_block
            - u24.u24_pledge_qty)
               AS transferqty,
           NVL (esp.settlement_price, 0) AS settlement_price,
           u24.u24_maintain_margin_charged,
           u24.u24_pending_subscribe_qty,
           u24.u24_subscribed_qty,
           u24.u24_weighted_avg_cost,
           NVL (
               get_pfolio_val_by_cash_ac (
                   p_cash_ac_id           => u06.u06_id,
                   p_institution          => u06.u06_institute_id_m02,
                   p_computation_method   => m02.m02_price_type_for_margin,
                   p_check_buy_pending    => m02.m02_add_buy_pending_for_margin,
                   p_check_pledgedqty     => m02.m02_add_pledge_for_bp,
                   p_check_sym_margin     => 0),
               0)
               AS margin_valuation
      FROM u24_holdings u24
           JOIN u07_trading_account u07
               ON u24.u24_trading_acnt_id_u07 = u07.u07_id
           JOIN m20_symbol m20
               ON u24.u24_symbol_id_m20 = m20.m20_id
           LEFT JOIN m125_exchange_instrument_type m125
               ON     m125.m125_instrument_type_id_v09 =
                          m20.m20_instrument_type_id_v09
                  --  AND m125.m125_exchange_code_m01 = m20.m20_exchange_code_m01
                  AND m125.m125_exchange_id_m01 = m20.m20_exchange_id_m01
           LEFT JOIN m20_symbol_extended m20_ex
               ON u24.u24_symbol_id_m20 = m20_ex.m20_id
           JOIN u06_cash_account u06
               ON u07.u07_cash_account_id_u06 = u06.u06_id
           LEFT JOIN vw_symbol_prices s_price
               ON u24.u24_symbol_id_m20 = s_price.symbol_id
           LEFT JOIN m26_executing_broker m26
               ON u24.u24_custodian_id_m26 = m26.m26_id
           LEFT JOIN dfn_price.esp_todays_snapshots esp
               ON     u24.u24_exchange_code_m01 = esp.exchangecode
                  AND u24.u24_symbol_code_m20 = esp.symbol
           JOIN m02_institute m02
               ON u06.u06_institute_id_m02 = m02.m02_id
     WHERE (   u24.u24_net_holding <> 0
            OR u24.u24_payable_holding <> 0
            OR u24.u24_receivable_holding <> 0
            OR u24.u24_buy_pending <> 0
            OR u24.u24_sell_pending <> 0
            OR u24.u24_short_holdings <> 0)
/