CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t02_cash_txn_log (
   transaction_id,
   t02_create_date,
   t02_create_datetime,
   t02_txn_time,
   t02_cash_acnt_id_u06,
   t02_cash_settle_date,
   t02_trd_acnt_id_u07,
   t02_inst_id_m02,
   t02_customer_id_u01,
   t02_customer_no,
   t02_exchange_code_m01,
   t02_symbol_code_m20,
   m20_short_description,
   m20_short_description_lang,
   m20_isincode,
   t02_txn_code,
   action,
   action_lang,
   t02_pay_method,
   t02_amnt_in_txn_currency,
   t02_amnt_in_stl_currency,
   t02_broker_vat,
   t02_exchange_vat,
   cr,
   dr,
   t02_fx_rate,
   t02_txn_currency,
   t02_settle_currency,
   t02_order_no,
   t02_ordqty,
   t02_last_shares,
   t02_last_price,
   t02_commission_adjst,
   t02_broker_commission,
   t02_exg_commission,
   commission,
   order_value,
   fill_qtty,
   t02_narration,
   m97_statement,
   m97_category,
   exchange_id )
AS

  SELECT MAX (t02.t02_order_no) AS transaction_id,
         MAX (t02.t02_create_date) AS t02_create_date,
         MAX (t02.t02_create_datetime) AS t02_create_datetime,
         MIN (t02.t02_txn_time) AS t02_txn_time,
         t02.t02_cash_acnt_id_u06,
         t02.t02_cash_settle_date,
         MAX (t02.t02_trd_acnt_id_u07) AS t02_trd_acnt_id_u07,
         MAX (t02.t02_inst_id_m02) AS t02_inst_id_m02,
         MAX (t02.t02_customer_id_u01) AS t02_customer_id_u01,
         MAX (t02.t02_customer_no) AS t02_customer_no,
         MAX (t02.t02_exchange_code_m01) AS t02_exchange_code_m01,
         MAX (t02.t02_symbol_code_m20) AS t02_symbol_code_m20,
         MAX (m20.m20_short_description) AS m20_short_description,
         MAX (m20.m20_short_description_lang) AS m20_short_description_lang,
         MAX (m20.m20_isincode) AS m20_isincode,
         t02.t02_txn_code,
         MAX (m97.m97_description) AS action,
         MAX (m97.m97_description_lang) AS action_lang,
         MAX (t02.t02_pay_method) AS t02_pay_method,
         SUM (t02.t02_amnt_in_txn_currency) AS t02_amnt_in_txn_currency,
         SUM (t02.t02_amnt_in_stl_currency) AS t02_amnt_in_stl_currency,
         SUM (t02.t02_broker_tax) AS t02_broker_vat,
         SUM (t02.t02_exchange_tax) AS t02_exchange_vat,
         CASE
             WHEN SUM (t02.t02_amnt_in_stl_currency) >= 0
             THEN
                 SUM (t02.t02_amnt_in_stl_currency)
             ELSE
                 0
         END
             AS cr,
         CASE
             WHEN SUM (t02.t02_amnt_in_stl_currency) < 0
             THEN
                 ABS (SUM (t02.t02_amnt_in_stl_currency))
             ELSE
                 0
         END
             AS dr,
         MAX (t02.t02_fx_rate) AS t02_fx_rate,
         MAX (t02.t02_txn_currency) AS t02_txn_currency,
         MAX (t02.t02_settle_currency) AS t02_settle_currency,
         t02.t02_order_no,
         MAX (t02.t02_ordqty) AS t02_ordqty,
         SUM (t02.t02_last_shares) AS t02_last_shares,
         ROUND (AVG (t02.t02_last_price), MAX (m03.m03_decimal_places))
             AS t02_last_price,
         SUM (t02.t02_commission_adjst) AS t02_commission_adjst,
         SUM (t02.t02_commission_adjst - t02_exg_commission)
             AS t02_broker_commission,
         SUM (t02.t02_exg_commission) AS t02_exg_commission,
         MAX (t02.t02_cum_commission) AS commission,
         MAX (t02.t02_cumord_value) AS order_value,
         MAX (t02.t02_cum_qty) AS fill_qtty,
         NULL AS t02_narration,
         MAX (m97_statement) m97_statement,
         MAX (m97_category) AS m97_category,
         MAX (m20.m20_exchange_id_m01) AS exchange_id
    FROM t02_transaction_log_cash_arc t02
         JOIN m20_symbol m20
             ON t02.t02_symbol_id_m20 = m20.m20_id
         JOIN m03_currency m03
             ON t02.t02_txn_currency = m03.m03_code
         JOIN vw_m97_cash_txn_codes_base m97
             ON t02.t02_txn_code = m97.m97_code
   WHERE t02.t02_update_type = 1
GROUP BY t02.t02_cash_acnt_id_u06,
         t02.t02_order_no,
         t02.t02_txn_code,
         t02.t02_cash_settle_date,
         t02.t02_symbol_id_m20
UNION ALL
SELECT NVL (t02.t02_cashtxn_id, t02.t02_txn_refrence_id) || ''
           AS transaction_id,
       t02.t02_create_date,
       t02.t02_create_datetime,
       t02.t02_txn_time,
       t02.t02_cash_acnt_id_u06,
       t02.t02_cash_settle_date,
       t02_trd_acnt_id_u07,
       t02.t02_inst_id_m02,
       t02.t02_customer_id_u01,
       t02.t02_customer_no,
       t02.t02_exchange_code_m01,
       t02.t02_symbol_code_m20 AS t02_symbol_code_m20,
       m20.m20_short_description,
       m20.m20_short_description_lang,
       m20.m20_isincode,
       t02.t02_txn_code,
       m97.m97_description,
       m97.m97_description_lang,
       t02.t02_pay_method,
       t02.t02_amnt_in_txn_currency,
       t02.t02_amnt_in_stl_currency,
       t02.t02_broker_tax,
       t02.t02_exchange_tax,
       CASE
           WHEN t02.t02_amnt_in_stl_currency >= 0
           THEN
               t02.t02_amnt_in_stl_currency
           ELSE
               0
       END
           AS dr,
       CASE
           WHEN t02.t02_amnt_in_stl_currency < 0
           THEN
               ABS (t02.t02_amnt_in_stl_currency)
           ELSE
               0
       END
           AS cr,
       t02.t02_fx_rate,
       t02.t02_txn_currency,
       t02.t02_settle_currency,
       NULL AS t02_order_no,
       NULL AS t02_ordqty,
       NULL AS t02_last_shares,
       NULL AS t02_last_price,
       NULL AS t02_commission_adjst,
       NULL AS t02_broker_commission,
       NULL AS t02_exg_commission,
       NULL AS t02_cum_commission,
       NULL AS t02_cumord_value,
       NULL AS fill_qtty,
       NULL AS t02_narration,
       m97_statement,
       m97_category,
       m20.m20_exchange_id_m01 AS exchange_id
  FROM t02_transaction_log_cash_arc t02
       JOIN vw_m97_cash_txn_codes_base m97
           ON t02.t02_txn_code = m97.m97_code
       LEFT JOIN m20_symbol m20
           ON t02.t02_symbol_id_m20 = m20.m20_id
 WHERE t02.t02_update_type IN (2, 6)
/
