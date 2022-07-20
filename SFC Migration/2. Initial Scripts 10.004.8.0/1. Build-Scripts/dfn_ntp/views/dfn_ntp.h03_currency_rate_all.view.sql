CREATE OR REPLACE FORCE VIEW dfn_ntp.h03_currency_rate_all
(
    h03_from_currency_code_m03,
    h03_to_currency_code_m03,
    h03_rate,
    h03_buy_rate,
    h03_sell_rate,
    h03_spread,
    h03_institute_id_m02,
    h03_status_id_v01,
    h03_id,
    h03_from_currency_id_m03,
    h03_to_currency_id_m03,
    h03_date,
    h03_category_v01
)
AS
    SELECT h03_from_currency_code_m03,
           h03_to_currency_code_m03,
           h03_rate,
           h03_buy_rate,
           h03_sell_rate,
           h03_spread,
           h03_institute_id_m02,
           h03_status_id_v01,
           h03_id,
           h03_from_currency_id_m03,
           h03_to_currency_id_m03,
           h03_date,
           h03_category_v01
      FROM dfn_ntp.h03_currency_rate
    UNION ALL
    SELECT h03_from_currency_code_m03,
           h03_to_currency_code_m03,
           h03_rate,
           h03_buy_rate,
           h03_sell_rate,
           h03_spread,
           h03_institute_id_m02,
           h03_status_id_v01,
           h03_id,
           h03_from_currency_id_m03,
           h03_to_currency_id_m03,
           h03_date,
           h03_category_v01
      FROM dfn_arc.h03_currency_rate
/
