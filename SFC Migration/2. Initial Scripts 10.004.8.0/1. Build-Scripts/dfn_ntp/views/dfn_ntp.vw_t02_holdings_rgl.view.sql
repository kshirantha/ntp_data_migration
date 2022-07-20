CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t02_holdings_rgl
(
   trading_account_id,
   create_date,
   symbol_code,
   exchange_code,
   last_shares,
   avg_cost,
   weighted_avg_cost,
   net_settle,
   gain_loss,
   gain_loss_percent,
   currency,
   cash_account_name,
   symbol_des,
   symbol_des_lang,
   sold_price,
   instrument_type,
   buy_value
)
AS
     SELECT u07.u07_id AS trading_account_id,
            TRUNC (t02.t02_create_date) AS create_date,
            MAX (t02.t02_symbol_code_m20) AS symbol_code,
            MAX (t02.t02_exchange_code_m01) AS exchange_code,
            SUM (t02.t02_last_shares) AS last_shares,
            CASE
               WHEN SUM (t02.t02_last_shares) > 0
               THEN
                  ROUND (
                       SUM (t02.t02_amnt_in_txn_currency - t02.t02_gainloss)
                     / SUM (t02.t02_last_shares),
                     2)
               ELSE
                  ROUND (SUM (t02.t02_last_price), 2)             --t05_lastpx
            END
               AS avg_cost,
            SUM (t02.t02_amnt_in_txn_currency) AS weighted_avg_cost,
            SUM (t02.t02_amnt_in_stl_currency) AS net_settle,
            SUM (t02.t02_gainloss) AS gain_loss,              --t05_profitloss
            CASE
               WHEN SUM ( (t02.t02_amnt_in_txn_currency - t02.t02_gainloss)) <>
                       0
               THEN
                  ROUND (
                       (  SUM (t02.t02_gainloss)
                        / SUM (
                             (t02.t02_amnt_in_txn_currency - t02.t02_gainloss)))
                     * 100,
                     2)
            END
               AS gain_loss_percent,
            MAX (u06.u06_currency_code_m03) AS currency,
            MAX (u06.u06_display_name) AS cash_account_name,
            MAX (m20.m20_short_description) AS symbol_des,
            MAX (m20.m20_short_description_lang) AS symbol_des_lang,
            CASE
               WHEN SUM (t02.t02_last_shares) <> 0
               THEN
                  ROUND (
                       SUM (t02.t02_amnt_in_txn_currency)
                     / SUM (t02.t02_last_shares),
                     2)
            END
               AS sold_price,
            MAX (m20.m20_instrument_type_code_v09) AS instrument_type,
            SUM (t02.t02_amnt_in_txn_currency - t02.t02_gainloss) AS buy_value
       FROM t02_transaction_log_order_all t02,
            u06_cash_account u06,
            u07_trading_account u07,
            m20_symbol m20
      WHERE     t02.t02_cash_acnt_id_u06 = u06.u06_id
            AND u06.u06_id = u07.u07_cash_account_id_u06
            AND t02.t02_symbol_id_m20 = m20.m20_id
            AND t02.t02_txn_code IN ('STLSEL')
   --AND t02.T02_SIDE = 2
   GROUP BY u07.u07_id, t02.t02_create_date, t02.t02_order_no
   ORDER BY t02.t02_create_date
/