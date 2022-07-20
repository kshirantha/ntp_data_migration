CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_custodian_holding_list
(
    txn_date,
    m26_id,
    m26_name,
    m20_reuters_code,
    m20_symbol_code,
    m20_id,
    country,
    m20_currency_code_m03,
    m20_short_description,
    m20_long_description,
    exchange_code,
    m20_isincode,
    m20_cusip_no,
    qty_nominal,
    mkt_price_ltp,
    buy_pending,
    sell_pending,
    instrument,
    m20_instrument_type_code_v09,
    m26_sid,
    executing_broker_name,
    short_holding,
    pledge_qty,
    holding_value_usd,
    mkt_price_ltp_usd,
    mkt_price_ltp_sar,
    holding_value_sar,
    holding_value,
    institute_id,
    u01_id
)
AS
    SELECT u24.txn_date,
           u24.m26_id,
           u24.m26_name,
           u24.m20_reuters_code,
           u24.m20_symbol_code,
           u24.m20_id,
           u24.country,
           u24.m20_currency_code_m03,
           u24.m20_short_description,
           u24.m20_long_description,
           u24.m20_exchange_code_m01 AS exchange_code,
           u24.m20_isincode,
           u24.m20_cusip_no,
           u24.qty_nominal,
           u24.mkt_price_ltp,
           u24.buy_pending,
           u24.sell_pending,
           u24.instrument,
           u24.m20_instrument_type_code_v09,
           u24.m26_sid,
           u24.executing_broker_name,
           u24.short_holding,
           u24.pledge_qty,
             u24.mkt_price_ltp_usd
           * u24.qty_nominal
           * u24.m20_lot_size
           * u24.m20_price_ratio
               AS holding_value_usd,
           u24.mkt_price_ltp_usd,
           u24.mkt_price_ltp_sar,
             u24.mkt_price_ltp_sar
           * u24.qty_nominal
           * u24.m20_lot_size
           * u24.m20_price_ratio
               AS holding_value_sar,
           u24.qty_nominal * mkt_price_ltp AS holding_value,
           u24.institute_id,
           u01_id
      FROM (  SELECT TRUNC (SYSDATE) AS txn_date,
                     m26.m26_id,
                     m26.m26_name,
                     MAX (m20.m20_reuters_code) AS m20_reuters_code,
                     MAX (u01_id) AS u01_id,
                     m20.m20_symbol_code,
                     MAX (m20_id) AS m20_id,
                     MAX (m05.m05_name) AS country,
                     MAX (m20.m20_currency_code_m03) AS m20_currency_code_m03,
                     MAX (m20.m20_short_description) AS m20_short_description,
                     MAX (m20.m20_long_description) AS m20_long_description,
                     m20.m20_exchange_code_m01,
                     MAX (m20.m20_isincode) AS m20_isincode,
                     MAX (m20.m20_cusip_no) AS m20_cusip_no,
                     SUM (
                           u24.u24_net_holding
                         + u24.u24_payable_holding
                         - u24.u24_receivable_holding)
                         AS qty_nominal,
                     AVG (
                         CASE
                             WHEN     m20.m20_instrument_type_code_v09 = 'BN'
                                  AND esp.lasttradedprice = 0
                             THEN
                                 esp.previousclosed
                             ELSE
                                 esp.lasttradedprice
                         END)
                         AS mkt_price_ltp,
                     (  AVG (
                            CASE
                                WHEN     m20.m20_instrument_type_code_v09 =
                                             'BN'
                                     AND esp.lasttradedprice = 0
                                THEN
                                    esp.previousclosed
                                ELSE
                                    esp.lasttradedprice
                            END)
                      * get_exchange_rate (MAX (u07.u07_institute_id_m02),
                                           MAX (m20.m20_currency_code_m03),
                                           'USD',
                                           'R'))
                         AS mkt_price_ltp_usd,
                     (  AVG (
                            CASE
                                WHEN     m20.m20_instrument_type_code_v09 =
                                             'BN'
                                     AND esp.lasttradedprice = 0
                                THEN
                                    esp.previousclosed
                                ELSE
                                    esp.lasttradedprice
                            END)
                      * get_exchange_rate (MAX (u07.u07_institute_id_m02),
                                           MAX (m20.m20_currency_code_m03),
                                           'SAR',
                                           'R'))
                         AS mkt_price_ltp_sar,
                     SUM (u24.u24_buy_pending) AS buy_pending,
                     SUM (u24.u24_sell_pending) AS sell_pending,
                     v09.v09_description AS instrument,
                     m20.m20_instrument_type_code_v09,
                     m26.m26_sid,
                     MAX ( (m26.m26_sid || '-' || m26.m26_name))
                         AS executing_broker_name,
                     ABS (SUM (u24.u24_short_holdings)) AS short_holding,
                     SUM (u24.u24_pledge_qty) AS pledge_qty,
                     MAX (m20.m20_lot_size) AS m20_lot_size,
                     MAX (m20.m20_price_ratio) AS m20_price_ratio,
                     u01.u01_institute_id_m02 AS institute_id
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
                     JOIN m20_symbol m20
                         ON     u24.u24_symbol_id_m20 = m20.m20_id
                            AND u24.u24_exchange_code_m01 =
                                    m20.m20_exchange_code_m01
                     JOIN m26_executing_broker m26
                         ON u24.u24_custodian_id_m26 = m26.m26_id
                     JOIN v09_instrument_types v09
                         ON m20.m20_instrument_type_id_v09 = v09.v09_id
                     JOIN m01_exchanges m01
                         ON m20.m20_exchange_id_m01 = m01.m01_id
                     LEFT JOIN m05_country m05
                         ON m01.m01_country_id_m05 = m05.m05_id
                     LEFT JOIN vw_esp_market_price_today esp
                         ON     m20.m20_exchange_code_m01 = esp.exchangecode
                            AND m20.m20_symbol_code = esp.symbol
            GROUP BY m26.m26_id,
                     m26.m26_name,
                     m26.m26_sid,
                     m20.m20_symbol_code,
                     m20.m20_exchange_code_m01,
                     m20.m20_instrument_type_code_v09,
                     v09.v09_description,
                     u01.u01_institute_id_m02) u24
    UNION
    SELECT h01.txn_date,
           h01.m26_id,
           h01.m26_name,
           h01.m20_reuters_code,
           h01.m20_symbol_code,
           h01.m20_id,
           h01.country,
           h01.m20_currency_code_m03,
           h01.m20_short_description,
           h01.m20_long_description,
           h01.m20_exchange_code_m01 AS exchange_code,
           h01.m20_isincode,
           h01.m20_cusip_no,
           h01.qty_nominal,
           h01.mkt_price_ltp,
           h01.buy_pending,
           h01.sell_pending,
           h01.instrument,
           h01.m20_instrument_type_code_v09,
           h01.m26_sid,
           h01.executing_broker_name,
           h01.short_holding,
           h01.pledge_qty,
             h01.mkt_price_ltp_usd
           * h01.qty_nominal
           * h01.m20_lot_size
           * h01.m20_price_ratio
               AS holding_value_usd,
           h01.mkt_price_ltp_usd,
           h01.mkt_price_ltp_sar,
             h01.mkt_price_ltp_sar
           * h01.qty_nominal
           * h01.m20_lot_size
           * h01.m20_price_ratio
               AS holding_value_sar,
           h01.qty_nominal * mkt_price_ltp AS holding_value,
           h01.institute_id,
           u01_id
      FROM (  SELECT h01.h01_date AS txn_date,
                     m26.m26_id,
                     m26.m26_name,
                     MAX (m20.m20_reuters_code) AS m20_reuters_code,
                     m20.m20_symbol_code,
                     MAX (m20_id) AS m20_id,
                     MAX (m05.m05_name) AS country,
                     MAX (m20.m20_currency_code_m03) AS m20_currency_code_m03,
                     MAX (m20.m20_short_description) AS m20_short_description,
                     MAX (m20.m20_long_description) AS m20_long_description,
                     m20.m20_exchange_code_m01,
                     MAX (m20.m20_isincode) AS m20_isincode,
                     MAX (m20.m20_cusip_no) AS m20_cusip_no,
                     SUM (
                           h01.h01_net_holding
                         + h01.h01_payable_holding
                         - h01.h01_receivable_holding
                         - h01.h01_manual_block)
                         AS qty_nominal,
                     AVG (esp.market_price) AS mkt_price_ltp,
                     (  AVG (esp.market_price)
                      * get_exchange_rate (MAX (u07.u07_institute_id_m02),
                                           MAX (m20.m20_currency_code_m03),
                                           'USD',
                                           'R'))
                         AS mkt_price_ltp_usd,
                     (  AVG (esp.market_price)
                      * get_exchange_rate (MAX (u07.u07_institute_id_m02),
                                           MAX (m20.m20_currency_code_m03),
                                           'SAR',
                                           'R'))
                         AS mkt_price_ltp_sar,
                     SUM (h01.h01_buy_pending) AS buy_pending,
                     SUM (h01.h01_sell_pending) AS sell_pending,
                     v09.v09_description AS instrument,
                     m20.m20_instrument_type_code_v09,
                     m26.m26_sid,
                     MAX ( (m26.m26_sid || '-' || m26.m26_name))
                         AS executing_broker_name,
                     ABS (SUM (h01.h01_short_holdings)) AS short_holding,
                     SUM (h01.h01_pledge_qty) AS pledge_qty,
                     MAX (m20.m20_lot_size) AS m20_lot_size,
                     MAX (m20.m20_price_ratio) AS m20_price_ratio,
                     u01.u01_institute_id_m02 AS institute_id,
                     MAX (u01_id) AS u01_id
                FROM vw_h01_holding_summary h01
                     JOIN u07_trading_account u07
                         ON     h01.h01_trading_acnt_id_u07 = u07.u07_id
                            AND h01.h01_date != TRUNC (SYSDATE)
                            AND (   h01.h01_net_holding <> 0
                                 OR h01.h01_payable_holding <> 0
                                 OR h01.h01_receivable_holding <> 0
                                 OR h01.h01_manual_block <> 0
                                 OR h01.h01_short_holdings <> 0)
                     JOIN u01_customer u01
                         ON     u07.u07_customer_id_u01 = u01.u01_id
                            AND u01.u01_account_category_id_v01 <> 3
                     JOIN m20_symbol m20
                         ON     h01.h01_symbol_id_m20 = m20.m20_id
                            AND h01.h01_exchange_code_m01 =
                                    m20.m20_exchange_code_m01
                     JOIN m26_executing_broker m26
                         ON h01.h01_custodian_id_m26 = m26.m26_id
                     JOIN m01_exchanges m01
                         ON m20.m20_exchange_id_m01 = m01.m01_id
                     JOIN v09_instrument_types v09
                         ON m20.m20_instrument_type_id_v09 = v09.v09_id
                     LEFT JOIN m05_country m05
                         ON m01.m01_country_id_m05 = m05.m05_id
                     JOIN vw_esp_market_price_history esp
                         ON     m20.m20_exchange_code_m01 = esp.exchangecode
                            AND m20.m20_symbol_code = esp.symbol
                            AND h01.h01_date = esp.transactiondate
            GROUP BY m26.m26_id,
                     m26.m26_name,
                     m26.m26_sid,
                     m20.m20_symbol_code,
                     m20.m20_exchange_code_m01,
                     m20.m20_instrument_type_code_v09,
                     v09.v09_description,
                     h01.h01_date,
                     u01.u01_institute_id_m02) h01
/
