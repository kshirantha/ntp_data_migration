CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t02_daily_trade_sum_symbol
(
    t02_date,
    t02_symbol_code_m20,
    t02_exchange_code_m01,
    t02_txn_currency,
    m20_short_description,
    m20_long_description,
    m20_short_description_lang,
    m20_long_description_lang,
    m20_isincode,
    t02_inst_id_m02,
    total_buy,
    total_sell,
    total_buy_value,
    total_sell_value,
    total_value,
    tot_buy_net_settle,
    tot_sell_net_settle,
    tot_net_settle,
    total_sell_commission,
    total_buy_commission
)
AS
    (  SELECT TRUNC (t02.t02_create_date) AS t02_date,
              MAX (t02.t02_symbol_code_m20) AS t02_symbol_code_m20,
              MAX (t02.t02_exchange_code_m01) AS t02_exchange_code_m01,
              MAX (t02.t02_txn_currency) AS t02_txn_currency,
              MAX (t02.m20_short_description) AS m20_short_description,
              MAX (t02.m20_long_description) AS m20_long_description,
              MAX (t02.m20_short_description_lang)
                  AS m20_short_description_lang,
              MAX (t02.m20_long_description_lang) AS m20_long_description_lang,
              MAX (t02.m20_isincode) AS m20_isincode,
              MAX (t02.t02_inst_id_m02) AS t02_inst_id_m02,
              SUM (tot_buy) AS total_buy,
              SUM (tot_sell) AS total_sell,
              SUM (tot_buy_value) AS total_buy_value,
              SUM (tot_sell_value) AS total_sell_value,
              (SUM (tot_buy_value) + SUM (tot_sell_value)) AS total_value,
              SUM (tot_buy_value) + SUM (tot_buy_commission)
                  AS tot_buy_net_settle,
              SUM (tot_sell_value) - SUM (tot_sell_commission)
                  AS tot_sell_net_settle,
                SUM (tot_buy_value)
              + SUM (tot_buy_commission)
              - (SUM (tot_sell_value) - SUM (tot_sell_commission))
                  AS tot_net_settle,
              SUM (tot_sell_commission) AS total_sell_commission,
              SUM (tot_buy_commission) AS total_buy_commission
         FROM (SELECT t02.t02_create_date,
                      t02.t02_symbol_id_m20,
                      t02.t02_exchange_code_m01,
                      t02.t02_symbol_code_m20,
                      t02.t02_txn_currency,
                      t02.t02_inst_id_m02,
                      m20.m20_short_description,
                      m20.m20_short_description_lang,
                      m20.m20_long_description,
                      m20.m20_long_description_lang,
                      (CASE
                           WHEN t02.t02_side = 1 THEN ABS (t02.t02_last_shares)
                           ELSE 0
                       END)
                          tot_buy,
                      (CASE
                           WHEN t02.t02_side = 2 THEN ABS (t02.t02_last_shares)
                           ELSE 0
                       END)
                          tot_sell,
                      (CASE
                           WHEN t02.t02_side = 1
                           THEN
                               (  ABS (t02.t02_last_shares)
                                * ABS (t02.t02_last_price))
                           ELSE
                               0
                       END)
                          tot_buy_value,
                      (CASE
                           WHEN t02.t02_side = 2
                           THEN
                               (  ABS (t02.t02_last_shares)
                                * ABS (t02.t02_last_price))
                           ELSE
                               0
                       END)
                          tot_sell_value,
                      (CASE
                           WHEN t02.t02_side = 1
                           THEN
                               ABS (t02.t02_commission_adjst)
                           ELSE
                               0
                       END)
                          tot_buy_commission,
                      (CASE
                           WHEN t02.t02_side = 2
                           THEN
                               ABS (t02.t02_commission_adjst)
                           ELSE
                               0
                       END)
                          tot_sell_commission,
                      m20.m20_isincode
                 FROM     t02_transaction_log_order_all t02
                      LEFT JOIN
                          m20_symbol m20
                      ON (t02.t02_symbol_id_m20 = m20.m20_id)) t02
     GROUP BY TRUNC (t02.t02_create_date),
              t02.t02_symbol_id_m20,
              t02.t02_txn_currency);
/
