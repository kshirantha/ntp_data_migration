/* Formatted on 8/5/2020 3:12:25 PM (QP5 v5.206) */
CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_b2b_history_holding
(
    instrument_type,
    exchange,
    m20_currency_code_m03,
    symbol,
    m20_short_description,
    m20_short_description_lang,
    cusip_no,
    isin_code,
    ric,
    h01_net_holding,
    h01_manual_block,
    h01_pledge_qty,
    h01_sell_pending,
    m20_lot_size,
    ownedqty,
    availableqty,
    avg_cost,
    pledgedqty,
    avg_price,
    nominal,
    strike_price,
    expiry_date,
    block_qty,
    market_price,
    cost_basis,
    sell_pending,
    buy_pending,
    covered_call_option,
    receivable_qty,
    payable_qty,
    pending_subcribed_qty,
    subscribed_quantity,
    wanc,
    u07_institute_id_m02,
    u07_customer_id_u01,
    h01_date,
    u07_exchange_account_no,
    h01_avg_cost,
    u07_cash_account_id_u06,
    u24_symbol_id_m20
)
AS
    ( ( (SELECT m20.m20_instrument_type_code_v09 AS instrument_type,
                u24.h01_exchange_code_m01 AS exchange,
                m20.m20_currency_code_m03,
                u24.h01_symbol_code_m20 AS symbol,
                m20.m20_short_description,
                m20.m20_short_description_lang,
                m20.m20_cusip_no AS cusip_no,
                m20.m20_isincode AS isin_code,
                m20.m20_reuters_code AS ric,
                u24.h01_net_holding,
                u24.h01_manual_block,
                u24.h01_pledge_qty,
                u24.h01_sell_pending,
                m20_lot_size,
                  u24.h01_net_holding
                + u24.h01_payable_holding
                - u24.h01_receivable_holding
                    AS ownedqty,
                  u24.h01_net_holding
                - u24.h01_manual_block
                - u24.h01_sell_pending
                - u24.h01_pledge_qty
                    AS availableqty,
                ROUND (u24.h01_avg_cost, 2) AS avg_cost,
                CASE
                    WHEN m20.m20_instrument_type_code_v09 != 'BN'
                    THEN
                        u24.h01_pledge_qty
                END
                    AS pledgedqty,
                ROUND (u24.h01_avg_price, 2) AS avg_price,
                CASE
                    WHEN m20.m20_instrument_type_code_v09 = 'BN'
                    THEN
                        u24.h01_net_holding
                END
                    AS nominal,
                CASE
                    WHEN m20.m20_instrument_type_code_v09 = 'OPT'
                    THEN
                        ROUND (m20.m20_strike_price, 2)
                END
                    AS strike_price,
                m20.m20_expire_date AS expiry_date,
                u24.h01_manual_block AS block_qty,
                CASE
                    WHEN m02.m02_price_type_for_margin = 1       -- Last Trade
                    THEN
                        esp.lasttradedprice
                    WHEN m02.m02_price_type_for_margin = 2             -- VWAP
                    THEN
                        NVL (esp.vwap, 0)
                    WHEN m02.m02_price_type_for_margin = 3  -- Previous Closed
                    THEN
                        NVL (esp.previousclosed, 0)
                    WHEN m02.m02_price_type_for_margin = 4    -- Closing Price
                    THEN
                        CASE
                            WHEN NVL (esp.todaysclosed, 0) = 0
                            THEN
                                NVL (esp.previousclosed, 0)
                            ELSE
                                NVL (esp.todaysclosed, 0)
                        END
                    ELSE                                            -- Default
                        esp.lasttradedprice
                END
                    AS market_price,
                CASE
                    WHEN m20.m20_instrument_type_code_v09 = 'BN'
                    THEN
                        ROUND (
                              (  u24.h01_net_holding
                               - u24.h01_manual_block
                               - u24.h01_pledge_qty)
                            * m20.m20_lot_size
                            * u24.h01_avg_cost
                            / 100,
                            2)
                    ELSE
                        ROUND (
                              (  u24.h01_net_holding
                               - u24.h01_manual_block
                               - u24.h01_pledge_qty)
                            * m20.m20_lot_size
                            * u24.h01_avg_cost,
                            2)
                END
                    AS cost_basis,
                u24.h01_sell_pending AS sell_pending,
                u24.h01_buy_pending AS buy_pending,
                ABS (u24.h01_short_holdings) AS covered_call_option,
                u24.h01_receivable_holding AS receivable_qty,
                u24.h01_payable_holding AS payable_qty,
                NULL AS pending_subcribed_qty,
                NULL AS subscribed_quantity,
                ROUND (u24.h01_weighted_avg_cost, 2) AS wanc,
                u07_institute_id_m02,
                u07.u07_customer_id_u01,
                u24.h01_date,
                u07.u07_exchange_account_no,
                h01_avg_cost,
                u07.u07_cash_account_id_u06,
                u24.h01_symbol_id_m20
           FROM vw_h01_holding_summary u24
                INNER JOIN u07_trading_account u07
                    ON u07.u07_id = u24.h01_trading_acnt_id_u07
                INNER JOIN m20_symbol m20
                    ON m20.m20_id = u24.h01_symbol_id_m20
                INNER JOIN dfn_price.esp_todays_snapshots esp
                    ON     esp.symbol = u24.h01_symbol_code_m20
                       AND u24.h01_exchange_code_m01 = exchangecode
                INNER JOIN m02_institute m02
                    ON m02.m02_id = u07.u07_institute_id_m02)))
/
