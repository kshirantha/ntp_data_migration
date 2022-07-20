CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_b2b_trade_confirmation
(
    m20_short_description,
    m20_short_description_lang,
    m20_reuters_code,
    m20_isincode,
    t02_create_date,
    t02_cash_settle_date,
    t02_side,
    t02_last_price,
    t02_last_shares,
    t02_order_value,
    t02_commission_adjst,
    total_vat,
    other_charges,
    t02_amnt_in_txn_currency,
    t02_fx_rate,
    t02_amnt_in_stl_currency,
    u06_investment_account_no,
    u07_exchange_account_no,
    u01_customer_no,
    t02_discount,
    t02_exg_commission,
    t02_symbol_code_m20,
    t02_exchange_code_m01
)
AS
    ( (  SELECT MAX (m20.m20_short_description) m20_short_description,
                MAX (m20.m20_short_description_lang) m20_short_description_lang,
                MAX (m20.m20_reuters_code) m20_reuters_code,
                MAX (m20.m20_isincode) m20_isincode,
                t02.t02_create_date,
                t02.t02_cash_settle_date,
                MAX (t02.t02_side) t02_side,
                ROUND (AVG (t02.t02_last_price), 2) t02_last_price,
                SUM (t02.t02_last_shares) t02_last_shares,
                SUM (t02.t02_last_price * t02.t02_last_shares)
                    AS t02_order_value,
                SUM (t02.t02_commission_adjst) t02_commission_adjst,
                SUM (t02.t02_broker_tax + t02.t02_exchange_tax) AS total_vat,
                0 AS other_charges,
                SUM (ABS (t02.t02_amnt_in_txn_currency))
                    t02_amnt_in_txn_currency,
                MAX (t02.t02_fx_rate) t02_fx_rate,
                SUM (t02.t02_amnt_in_stl_currency) t02_amnt_in_stl_currency,
                MAX (u06.u06_investment_account_no) u06_investment_account_no,
                MAX (u07.u07_exchange_account_no) u07_exchange_account_no,
                MAX (u01.u01_customer_no) u01_customer_no,
                SUM (t02.t02_discount) t02_discount,
                SUM (t02.t02_exg_commission) t02_exg_commission,
                t02_symbol_code_m20 t02_symbol_code_m20,
                t02_exchange_code_m01
           FROM dfn_ntp.t02_transaction_log t02
                INNER JOIN m20_symbol m20
                    ON m20.m20_id = t02.t02_symbol_id_m20
                INNER JOIN u07_trading_account u07
                    ON u07.u07_id = t02.t02_trd_acnt_id_u07
                INNER JOIN u06_cash_account u06
                    ON     u06.u06_id = t02.t02_cash_acnt_id_u06
                       AND t02.t02_cash_acnt_id_u06 =
                               u07.u07_cash_account_id_u06
                INNER JOIN u01_customer u01
                    ON u01.u01_id = u06.u06_customer_id_u01
          WHERE t02.t02_txn_code IN ('STLBUY', 'STLSEL')
       GROUP BY t02.t02_txn_code,
                t02.t02_create_date,
                t02.t02_symbol_code_m20,
                t02.t02_cash_settle_date,
                t02.t02_exchange_code_m01))
/
