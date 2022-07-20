CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t20_pledge_all_report
(
    t20_id,
    t20_trading_acc_id_u07,
    t20_exchange,
    t20_symbol,
    t20_instrument_type,
    t20_reject_reason,
    t20_last_changed_by_id_u17,
    t20_last_changed_date,
    t20_status_id_v01,
    status,
    t20_entered_by_id_u17,
    t20_entered_date,
    t20_send_to_exchange,
    t20_transaction_number,
    t20_send_to_exchange_result,
    t20_pledge_type,
    u01_customer_no,
    u01_external_ref_no,
    cust_name,
    in_pledge_qty,
    in_entered_date,
    in_pledge_value,
    out_pledge_qty,
    out_entered_date,
    out_pledge_value,
    pledge_value,
    market_value,
    currency,
    m02_code,
    cust_id_no,
    m20_short_description,
    m20_long_description,
    region,
    m07_location_code,
    m07_institute_id_m02,
    t20_exchange_fee,
    t20_broker_fee,
    m20_instrument_type_code_v09,
    sent_to_exchange,
    cust_name_ar,
    pledge_restriction,
    stock_transfer_disabled,
    u07_exchange_account_no,
    t20_narration
)
AS
    SELECT t20.t20_id,
           t20.t20_trading_acc_id_u07,
           t20.t20_exchange,
           t20.t20_symbol,
           t20.t20_instrument_type,
           t20.t20_reject_reason,
           t20.t20_last_changed_by_id_u17,
           t20.t20_last_changed_date,
           t20.t20_status_id_v01,
           sts.v01_description AS status,
           t20.t20_entered_by_id_u17,
           t20.t20_entered_date,
           t20.t20_send_to_exchange,
           t20.t20_transaction_number,
           t20.t20_send_to_exchange_result,
           t20.t20_pledge_type,
           u01.u01_customer_no,
           u01.u01_external_ref_no,
           u01.u01_full_name AS cust_name,
           CASE WHEN t20.t20_pledge_type = '8' THEN t20.t20_qty END
               AS in_pledge_qty,
           CASE WHEN t20.t20_pledge_type = '8' THEN t20.t20_entered_date END
               AS in_entered_date,
           CASE
               WHEN t20.t20_pledge_type = '8'
               THEN
                   (t20.t20_qty * u24.u24_avg_cost)
           END
               AS in_pledge_value,
           CASE WHEN t20.t20_pledge_type = '9' THEN ABS (t20.t20_qty) END
               AS out_pledge_qty,
           CASE WHEN t20.t20_pledge_type = '9' THEN t20.t20_entered_date END
               AS out_entered_date,
           CASE
               WHEN t20.t20_pledge_type = '9'
               THEN
                   (ABS (t20.t20_qty) * u24.u24_avg_cost)
           END
               AS out_pledge_value,
           (ABS (t20.t20_qty) * u24.u24_avg_cost) AS pledge_value,
           CASE
               WHEN (price.lasttradedprice > 0)
               THEN
                   ABS (t20.t20_qty) * price.lasttradedprice
               ELSE
                   price.previousclosed * ABS (t20.t20_qty)
           END
               AS market_value,
           u06.u06_currency_code_m03 AS currency,
           m02.m02_code,
           u01.u01_default_id_no AS cust_id_no,
           m20.m20_short_description,
           m20.m20_long_description,
           m90.m90_name AS region,
           m07.m07_location_code,
           m07.m07_institute_id_m02,
           t20.t20_exchange_fee,
           t20.t20_broker_fee,
           m20.m20_instrument_type_code_v09,
           CASE
               WHEN t20.t20_send_to_exchange = 0 THEN 'Internal'
               WHEN t20.t20_send_to_exchange = 1 THEN 'Exchange'
           END
               AS sent_to_exchange,
           u01.u01_full_name AS cust_name_ar,
           CASE
               WHEN INSTR (u12_restriction_type_id_v31, '18') > 0 THEN 'Both'
               ELSE 'No'
           END
               AS pledge_restriction,
           CASE
               WHEN INSTR (u12_restriction_type_id_v31, '8') > 0 THEN 'Yes'
               ELSE 'No'
           END
               AS stock_transfer_disabled,
           u07.u07_exchange_account_no,
           t20.t20_narration
      FROM t20_pending_pledge t20
           JOIN u07_trading_account u07
               ON t20.t20_trading_acc_id_u07 = u07.u07_id
           JOIN u01_customer u01
               ON u07.u07_customer_id_u01 = u01.u01_id
           JOIN m02_institute m02
               ON u01.u01_institute_id_m02 = m02.m02_id
           LEFT JOIN m90_region m90
               ON u01.u01_corp_region_id_m90 = m90.m90_id
           JOIN m20_symbol m20
               ON t20.t20_symbol_id_m20 = m20.m20_id
           JOIN m07_location m07
               ON u01.u01_service_location_id_m07 = m07.m07_id
           JOIN u06_cash_account u06
               ON u07.u07_cash_account_id_u06 = u06.u06_id
           JOIN u24_holdings u24
               ON     u24.u24_symbol_id_m20 = t20.t20_symbol_id_m20
                  AND u24.u24_trading_acnt_id_u07 =
                          t20.t20_trading_acc_id_u07
                  AND u24.u24_custodian_id_m26 = t20_custodian_id
           LEFT OUTER JOIN (  SELECT u12_trading_account_id_u07,
                                     fn_aggregate_list (
                                         p_input => u12_restriction_type_id_v31)
                                         AS u12_restriction_type_id_v31
                                FROM u12_trading_restriction
                            GROUP BY u12_trading_account_id_u07) u12
               ON t20.t20_trading_acc_id_u07 = u12.u12_trading_account_id_u07
           JOIN vw_esp_market_price_today price
               ON     t20.t20_symbol = price.symbol
                  AND t20.t20_exchange = price.exchangecode
           JOIN vw_status_list sts
               ON t20.t20_status_id_v01 = sts.v01_id
/