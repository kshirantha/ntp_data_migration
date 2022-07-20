CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_customer_holding_list
(
    h01_date,
    u01_id,
    u01_external_ref_no,
    u01_institute_id_m02,
    u06_external_ref_no,
    cust_name,
    u07_id,
    u07_display_name,
    instrument_type,
    instrument,
    v09_id,
    symbol_name,
    exchange_code,
    qty,
    nominal,
    buy_pending,
    sell_pending,
    symbol_currency,
    mkt_price_ltp,
    mkt_value,
    option_type,
    contact_size,
    opt_strike_price,
    exp_mat_date,
    coupon_rate,
    custodian_code_m26,
    m26_id,
    m26_sid,
    m26_name,
    m20_short_description,
    m20_long_description,
    m20_id,
    qty_nominal,
    short_holding,
    pledgedqty,
    mkt_value_usd,
    mkt_value_sar,
    m20_isincode,
    cash_transation_restrict,
    transfer_restriction
)
AS
    SELECT TRUNC (SYSDATE) AS h01_date,
           u01.u01_id,
           u01.u01_external_ref_no,
           u01.u01_institute_id_m02,
           u06.u06_external_ref_no,
           NVL (u01.u01_first_name || ' ', '') || NVL (u01.u01_last_name, '')
               AS cust_name,
           u07.u07_id,
           u07.u07_display_name,
           m20.m20_instrument_type_code_v09 AS instrument_type,
           v09.v09_description AS instrument,
           v09.v09_id,
           m20.m20_symbol_code AS symbol_name,
           m20.m20_exchange_code_m01 AS exchange_code,
           (  u24.u24_net_holding
            + u24.u24_payable_holding
            - u24.u24_receivable_holding
            - u24.u24_manual_block)
               AS qty,
           (  u24.u24_net_holding
            + u24.u24_payable_holding
            - u24.u24_receivable_holding
            - u24.u24_manual_block)
               AS nominal,
           u24.u24_buy_pending AS buy_pending,
           u24.u24_sell_pending AS sell_pending,
           m20.m20_currency_code_m03 AS symbol_currency,
           esp.market_price AS mkt_price_ltp,
             esp.market_price
           * (  u24.u24_net_holding
              + u24.u24_payable_holding
              - u24.u24_receivable_holding
              - u24.u24_manual_block)
           * m20.m20_lot_size
           * m20.m20_price_ratio
               mkt_value,
           CASE
               WHEN     m20.m20_instrument_type_code_v09 = 'OPT'
                    AND m20.m20_option_type = 0
               THEN
                   'Put'
               WHEN     m20.m20_instrument_type_code_v09 = 'OPT'
                    AND m20.m20_option_type = 1
               THEN
                   'Call'
           END
               AS option_type,
           CASE
               WHEN m20.m20_instrument_type_code_v09 = 'OPT'
               THEN
                   m20.m20_lot_size
           END
               AS contact_size,
           CASE
               WHEN m20.m20_instrument_type_code_v09 = 'OPT'
               THEN
                   m20.m20_strike_price
           END
               AS opt_strike_price,
           CASE
               WHEN    m20.m20_instrument_type_code_v09 = 'OPT'
                    OR m20.m20_instrument_type_code_v09 = 'BN'
               THEN
                   m20_ex.m20_maturity_date
           END
               AS exp_mat_date,
           CASE
               WHEN m20.m20_instrument_type_code_v09 = 'BN'
               THEN
                   m20_ex.m20_interest_rate
           END
               AS coupon_rate,
           u24.u24_custodian_code_m26 AS custodian_code_m26,
           m26.m26_id,
           m26.m26_sid,
           m26.m26_name,
           m20.m20_short_description AS m20_short_description,
           m20.m20_long_description AS m20_long_description,
           m20.m20_id,
           (  u24.u24_net_holding
            + u24.u24_payable_holding
            - u24.u24_receivable_holding
            - u24.u24_manual_block)
               AS qty_nominal,
           ABS (u24.u24_short_holdings) AS short_holding,
           u24.u24_pledge_qty AS pledgedqty,
           (  esp.market_price
            * (  u24.u24_net_holding
               + u24.u24_payable_holding
               - u24.u24_receivable_holding
               - u24.u24_manual_block)
            * m20.m20_lot_size
            * m20.m20_price_ratio
            * get_exchange_rate (u07.u07_institute_id_m02,
                                 m20.m20_currency_code_m03,
                                 'USD',
                                 'R'))
               AS mkt_value_usd,
           (  esp.market_price
            * (  u24.u24_net_holding
               + u24.u24_payable_holding
               - u24.u24_receivable_holding
               - u24.u24_manual_block)
            * m20.m20_lot_size
            * m20.m20_price_ratio
            * get_exchange_rate (u07.u07_institute_id_m02,
                                 m20.m20_currency_code_m03,
                                 'SAR',
                                 'R'))
               AS mkt_value_sar,
           m20.m20_isincode,
           NVL (u11a.restriction, 'None') AS cash_transation_restrict,
           NVL (u11b.restriction, 'None') AS transfer_restriction
      FROM u24_holdings u24
           JOIN u07_trading_account u07
               ON     u24.u24_trading_acnt_id_u07 = u07.u07_id
                  AND (   u24.u24_net_holding <> 0
                       OR u24.u24_payable_holding <> 0
                       OR u24.u24_receivable_holding <> 0
                       OR u24.u24_short_holdings <> 0
                       OR u24.u24_manual_block <> 0)
           JOIN u01_customer u01
               ON     u07.u07_customer_id_u01 = u01.u01_id
                  AND u01.u01_account_category_id_v01 <> 3
           JOIN u06_cash_account u06
               ON u07.u07_cash_account_id_u06 = u06.u06_id
           JOIN m20_symbol m20
               ON     u24.u24_symbol_id_m20 = m20.m20_id
                  AND u24.u24_exchange_code_m01 = m20.m20_exchange_code_m01
           LEFT JOIN m20_symbol_extended m20_ex
               ON u24.u24_symbol_id_m20 = m20_ex.m20_id
           LEFT JOIN vw_cash_restriction_summary u11a
               ON u06.u06_id = u11a.u11_cash_account_id_u06
           LEFT JOIN vw_transfer_restriction u11b
               ON u06.u06_id = u11b.u11_cash_account_id_u06
           JOIN m26_executing_broker m26
               ON u24.u24_custodian_id_m26 = m26.m26_id
           JOIN v09_instrument_types v09
               ON m20.m20_instrument_type_id_v09 = v09.v09_id
           LEFT JOIN vw_esp_market_price_today esp
               ON     m20.m20_exchange_code_m01 = esp.exchangecode
                  AND m20.m20_symbol_code = esp.symbol
    UNION ALL
    SELECT h01.h01_date AS h01_date,
           u01.u01_id,
           u01.u01_external_ref_no,
           u01.u01_institute_id_m02,
           u06.u06_external_ref_no,
           NVL (u01.u01_first_name || ' ', '') || NVL (u01.u01_last_name, '')
               AS cust_name,
           u07.u07_id,
           u07.u07_display_name,
           m20.m20_instrument_type_code_v09 AS instrument_type,
           v09.v09_description AS instrument,
           v09.v09_id,
           m20.m20_symbol_code AS symbol_name,
           m20.m20_exchange_code_m01 AS exchange_code,
           (  h01.h01_net_holding
            + h01.h01_payable_holding
            - h01.h01_receivable_holding
            - h01.h01_manual_block)
               AS qty,
           CASE
               WHEN m20.m20_instrument_type_code_v09 = 'BN'
               THEN
                   (  h01.h01_net_holding
                    + h01.h01_payable_holding
                    - h01.h01_receivable_holding
                    - h01.h01_manual_block)
           END
               AS nominal,
           h01.h01_buy_pending AS buy_pending,
           h01.h01_sell_pending AS sell_pending,
           m20.m20_currency_code_m03 AS symbol_currency,
           esp.market_price AS mkt_price_ltp,
             esp.market_price
           * (  h01.h01_net_holding
              + h01.h01_payable_holding
              - h01.h01_receivable_holding
              - h01.h01_manual_block)
               mkt_value,
           CASE
               WHEN     m20.m20_instrument_type_code_v09 = 'OPT'
                    AND m20.m20_option_type = 0
               THEN
                   'Put'
               WHEN     m20.m20_instrument_type_code_v09 = 'OPT'
                    AND m20.m20_option_type = 1
               THEN
                   'Call'
           END
               AS option_type,
           CASE
               WHEN m20.m20_instrument_type_code_v09 = 'OPT'
               THEN
                   m20.m20_lot_size
           END
               AS contact_size,
           CASE
               WHEN m20.m20_instrument_type_code_v09 = 'OPT'
               THEN
                   m20.m20_strike_price
           END
               AS opt_strike_price,
           CASE
               WHEN    m20.m20_instrument_type_code_v09 = 'OPT'
                    OR m20.m20_instrument_type_code_v09 = 'BN'
               THEN
                   m20_ex.m20_maturity_date
           END
               AS exp_mat_date,
           CASE
               WHEN m20.m20_instrument_type_code_v09 = 'BN'
               THEN
                   m20_ex.m20_interest_rate
           END
               AS coupon_rate,
           h01.h01_custodian_code_m26 AS custodian_code_m26,
           m26.m26_id,
           m26.m26_sid,
           m26.m26_name,
           m20.m20_short_description AS m20_short_description,
           m20.m20_long_description AS m20_long_description,
           m20.m20_id,
           (  h01.h01_net_holding
            + h01.h01_payable_holding
            - h01.h01_receivable_holding
            - h01.h01_manual_block)
               AS qty_nominal,
           ABS (h01.h01_short_holdings) AS short_holding,
           h01.h01_pledge_qty AS pledgedqty,
           (  esp.market_price
            * (  h01.h01_net_holding
               + h01.h01_payable_holding
               - h01.h01_receivable_holding
               - h01.h01_manual_block)
            * m20.m20_lot_size
            * m20.m20_price_ratio
            * get_exchange_rate (u07.u07_institute_id_m02,
                                 m20.m20_currency_code_m03,
                                 'USD',
                                 'R'))
               AS mkt_value_usd,
           (  esp.market_price
            * (  h01.h01_net_holding
               + h01.h01_payable_holding
               - h01.h01_receivable_holding
               - h01.h01_manual_block)
            * m20.m20_lot_size
            * m20.m20_price_ratio
            * get_exchange_rate (u07.u07_institute_id_m02,
                                 m20.m20_currency_code_m03,
                                 'SAR',
                                 'R'))
               AS mkt_value_sar,
           m20.m20_isincode,
           NVL (u11a.restriction, 'None') AS cash_transation_restrict,
           NVL (u11b.restriction, 'None') AS transfer_restriction
      FROM h01_holding_summary h01
           JOIN u07_trading_account u07
               ON     h01.h01_trading_acnt_id_u07 = u07.u07_id
                  AND (   h01.h01_net_holding <> 0
                       OR h01.h01_payable_holding <> 0
                       OR h01.h01_receivable_holding <> 0
                       OR h01.h01_short_holdings <> 0
                       OR h01.h01_manual_block <> 0)
           JOIN u01_customer u01
               ON     u07.u07_customer_id_u01 = u01.u01_id
                  AND u01.u01_account_category_id_v01 <> 3
           JOIN u06_cash_account u06
               ON u07.u07_cash_account_id_u06 = u06.u06_id
           LEFT JOIN vw_cash_restriction_summary u11a
               ON u06.u06_id = u11a.u11_cash_account_id_u06
           LEFT JOIN vw_transfer_restriction u11b
               ON u06.u06_id = u11b.u11_cash_account_id_u06
           JOIN m20_symbol m20
               ON     h01.h01_symbol_id_m20 = m20.m20_id
                  AND h01.h01_exchange_code_m01 = m20.m20_exchange_code_m01
           LEFT JOIN m20_symbol_extended m20_ex
               ON h01.h01_symbol_id_m20 = m20_ex.m20_id
           JOIN m26_executing_broker m26
               ON h01.h01_custodian_id_m26 = m26.m26_id
           JOIN v09_instrument_types v09
               ON m20.m20_instrument_type_id_v09 = v09.v09_id
           JOIN vw_esp_market_price_history esp
               ON     m20.m20_exchange_code_m01 = esp.exchangecode
                  AND m20.m20_symbol_code = esp.symbol
                  AND h01.h01_date = esp.transactiondate
/