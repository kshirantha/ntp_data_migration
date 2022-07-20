CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t85_negotiated_deal
(
    t85_id,
    t85_type,
    t_type,
    t85_report_id,
    t85_remote_report_id,
    t85_buyer_customer_no_u01,
    t85_buyer_trading_acc_id_u07,
    t85_seller_customer_no_u01,
    t85_seller_trading_acc_id_u07,
    t85_report_txn_type,
    t85_report_type,
    report_type,
    t85_symbol,
    t85_exchange,
    t85_price,
    t85_quantity,
    gross_trade_amount,
    t85_transaction_time,
    t85_settlement_date,
    t85_trader_id,
    t85_created_date,
    t85_ord_side,
    t85_direction,
    t85_trade_match_id,
    t85_text,
    t85_txn_reference,
    t85_user_id_u17,
    t85_other_broker_id_m105,
    t85_confirmation_period,
    t85_contra_trader_id,
    t85_contra_trading_acc_no,
    b_display_name,
    s_display_name,
    u01_institute_id_m02,
    u17_full_name
)
AS
    SELECT t85_id,
           t85_type,
           CASE
               WHEN t85_type = 1 THEN 'Two Side'
               WHEN t85_type = 2 THEN 'Crossing'
           END
               AS t_type,
           t85_report_id,
           t85_remote_report_id,
           t85_buyer_customer_no_u01,
           t85_buyer_trading_acc_id_u07,
           t85_seller_customer_no_u01,
           t85_seller_trading_acc_id_u07,
           t85_report_txn_type,
           t85_report_type,
           CASE
               WHEN t85_report_type = 0 THEN 'Submit'
               WHEN t85_report_type = 1 THEN 'Alleged'
               WHEN t85_report_type = 3 THEN 'Decline'
               WHEN t85_report_type = 6 THEN 'Trade Report Cancel'
               WHEN t85_report_type = 8 THEN 'Defaulted'
               WHEN t85_report_type = 10 THEN 'Pended'
           END
               AS report_type,
           t85_symbol,
           t85_exchange,
           t85_price,
           t85_quantity,
           t85_price * t85_quantity AS gross_trade_amount,
           t85_transaction_time,
           t85_settlement_date,
           t85_trader_id,
           t85_created_date,
           t85_ord_side,
           t85_direction,
           t85_trade_match_id,
           t85_text,
           t85_txn_reference,
           t85_user_id_u17,
           t85_other_broker_id_m105,
           t85_confirmation_period,
           t85_contra_trader_id,
           t85_contra_trading_acc_no,
           b_u01.u01_display_name b_display_name,
           s_u01.u01_display_name s_display_name,
           b_u01.u01_institute_id_m02,
           u17.u17_full_name
      FROM t85_negotiated_deal t85
           LEFT OUTER JOIN u01_customer b_u01
               ON b_u01.u01_customer_no = t85.t85_buyer_customer_no_u01
           LEFT OUTER JOIN u01_customer s_u01
               ON s_u01.u01_customer_no = t85.t85_seller_customer_no_u01
           LEFT OUTER JOIN u17_employee u17 ON u17.u17_id = t85_user_id_u17
/