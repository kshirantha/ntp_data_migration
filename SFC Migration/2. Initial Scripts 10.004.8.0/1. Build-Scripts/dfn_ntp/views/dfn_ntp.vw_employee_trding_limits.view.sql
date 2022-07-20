CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_employee_trding_limits
(
    m50_id,
    m50_status_id_v01,
    m50_employee_id_u17,
    m50_approvable_order_limit,
    m50_approvable_overdraw_limit,
    m50_bp_exceed_limit,
    m50_breach_coverage_ratio,
    m50_default_currency_code_m03,
    m50_last_updated_by_id_u17,
    m50_last_updated_date,
    m50_max_order_value,
    m50_price_tolerence,
    m50_default_currency_id_m03,
    m50_order_value_per_day,
    m50_order_volume_per_day
)
AS
    SELECT m50_id,
           m50_status_id_v01,
           m50_employee_id_u17,
           m50_approvable_order_limit,
           m50_approvable_overdraw_limit,
           m50_bp_exceed_limit,
           m50_breach_coverage_ratio,
           m50_default_currency_code_m03,
           m50_last_updated_by_id_u17,
           m50_last_updated_date,
           m50_max_order_value,
           m50_price_tolerence,
           m50_default_currency_id_m03,
           m50_order_value_per_day,
           m50_order_volume_per_day
      FROM m50_employee_trd_limits a
/
