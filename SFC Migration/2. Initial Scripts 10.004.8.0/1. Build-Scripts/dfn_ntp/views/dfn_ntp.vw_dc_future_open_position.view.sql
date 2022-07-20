CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_dc_future_open_position
(
    m20_symbol_code,
    future_name,
    quantity,
    m20_expire_date,
    initial_margin,
    variation_margin,
    margin_limit,
    customer_name,
    margin_utilized,
    u06_margin_block,
    u24_avg_price,
    t01_side,
    u01_customer_no,
    u01_external_ref_no,
    u01_institute_id_m02,
    u01_id
)
AS
    SELECT m20.m20_symbol_code,
           m20.m20_short_description AS future_name,
           u24.u24_net_holding * m20.m20_lot_size AS quantity,
           m20_expire_date,
           t01_initial_margin_amount AS initial_margin,
           u24.u24_m2m_profit AS variation_margin,
           u23.u23_max_margin_limit AS margin_limit,
           u01.u01_display_name AS customer_name,
           u23.u23_max_margin_limit AS margin_utilized,
           u06.u06_margin_block,
           u24.u24_avg_price,
           t01_side,
           u01.u01_customer_no,
           u01.u01_external_ref_no,
           u01.u01_institute_id_m02,
           u01.u01_id
      FROM m20_symbol m20,
           (SELECT DISTINCT
                   (t01.t01_trading_acc_id_u07) AS t01_trading_acc_id_u07,
                   t01.t01_side,
                   t01.t01_initial_margin_amount
              FROM t01_order t01
             WHERE     t01.t01_status_id_v30 IN ('1', '2', 'q', 'r', '5')
                   AND t01.t01_position_effect = 'O'
                   AND t01.t01_instrument_type_code = 'FUT') t01,
           u24_holdings u24,
           u06_cash_account u06,
           u07_trading_account u07,
           u23_customer_margin_product u23,
           u01_customer u01
     WHERE     m20.m20_exchange_code_m01 = u24.u24_exchange_code_m01
           AND m20.m20_symbol_code = u24.u24_symbol_code_m20
           AND m20.m20_instrument_type_code_v09 = 'FUT'
           AND u24.u24_trading_acnt_id_u07 = t01.t01_trading_acc_id_u07
           AND u24.u24_trading_acnt_id_u07 = u07.u07_id
           AND u07.u07_cash_account_id_u06 = u06.u06_id
           AND u06.u06_margin_product_id_u23 = u23.u23_id
           AND u07.u07_customer_id_u01 = u01.u01_id
           AND u24.u24_net_holding <> 0
/