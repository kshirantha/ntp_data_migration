CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_settlement_calendar
(
    m36_buy_cash_settle_date,
    m36_buy_holdings_settle_date,
    m36_sell_cash_settle_date,
    m36_sell_holdings_settle_date,
    m36_month_end,
    m36_week_end,
    m36_date,
    m36_exchange_code_m01,
    m36_instrument_type_code_v09,
    m36_symbol_settle_category_v11,
    m36_cust_settle_group_id_m35,
    m36_description,
    m36_holiday,
    is_holiday,
    is_weekend,
    m36_working_day,
    m36_institution_id_m02,
    day_name,
    m36_year,
    m36_settle_cal_conf_id_m95
)
AS
    SELECT m36_buy_cash_settle_date,
           m36_buy_holdings_settle_date,
           m36_sell_cash_settle_date,
           m36_sell_holdings_settle_date,
           m36_month_end,
           m36_week_end,
           m36_date,
           m36_exchange_code_m01,
           m36_instrument_type_code_v09,
           m36_symbol_settle_category_v11,
           m36_cust_settle_group_id_m35,
           m36_description,
           m36_holiday,
           CASE m36_holiday WHEN 2 THEN 'YES' END AS is_holiday,
           CASE m36_holiday WHEN 1 THEN 'YES' END AS is_weekend,
           m36_working_day,
           m36_institution_id_m02,
           TO_CHAR (m36_date, 'DAY') AS day_name,
           m36_year,
           m36_settle_cal_conf_id_m95
      FROM m36_settlement_calendar
    UNION ALL
    SELECT m36_buy_cash_settle_date,
           m36_buy_holdings_settle_date,
           m36_sell_cash_settle_date,
           m36_sell_holdings_settle_date,
           m36_month_end,
           m36_week_end,
           m36_date,
           m36_exchange_code_m01,
           m36_instrument_type_code_v09,
           m36_symbol_settle_category_v11,
           m36_cust_settle_group_id_m35,
           m36_description,
           m36_holiday,
           CASE m36_holiday WHEN 2 THEN 'YES' END AS is_holiday,
           CASE m36_holiday WHEN 1 THEN 'YES' END AS is_weekend,
           m36_working_day,
           m36_institution_id_m02,
           TO_CHAR (m36_date, 'DAY') AS day_name,
           m36_year,
           m36_settle_cal_conf_id_m95
      FROM dfn_arc.m36_settlement_calendar
/
