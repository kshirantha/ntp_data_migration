CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m69_inst_trading_limits
(
    m69_id,
    m69_institution_id_m02,
    m69_od_limit,
    m69_avail_od_limit,
    m69_margin_limit,
    m69_avail_margin_limit,
    m69_last_updated_date,
    m69_last_updated_by_id_u17,
    last_updated_by_full_name,
    m69_order_value_per_day,
    m69_order_volume_per_day,
    m69_default_currency_code_m03,
    m69_default_currency_id_m03,
    m69_derivative_limit,
    m69_derivative_limit_utilized
)
AS
    SELECT m69.m69_id,
           m69.m69_institution_id_m02,
           m69.m69_od_limit,
           m69.m69_avail_od_limit,
           m69.m69_margin_limit,
           m69.m69_avail_margin_limit,
           m69.m69_last_updated_date,
           m69.m69_last_updated_by_id_u17,
           u17.u17_full_name AS last_updated_by_full_name,
           m69.m69_order_value_per_day,
           m69.m69_order_volume_per_day,
           m69.m69_default_currency_code_m03,
           m69.m69_default_currency_id_m03,
           m69.m69_derivative_limit,
           m69.m69_derivative_limit_utilized
      FROM m69_institute_trading_limits m69
           LEFT JOIN u17_employee u17
               ON m69.m69_last_updated_by_id_u17 = u17.u17_id
/