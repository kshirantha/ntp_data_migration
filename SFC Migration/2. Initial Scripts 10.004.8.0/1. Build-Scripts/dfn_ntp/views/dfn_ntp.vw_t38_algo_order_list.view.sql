CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t38_algo_order_list
(
    t38_cond_order_id,
    t38_symbol_id_m20,
    t38_price,
    t38_quantity,
    t38_trig_qty,
    t38_block_size,
    t38_currency,
    t38_instrument_type_code,
    t38_created_date,
    t38_triggered_date,
    order_date,
    t01_exchange_code_m01,
    order_side,
    t01_institution_id_m02,
    m02_primary_institute_id_m02,
    t01_ord_no,
    u01_id,
    u01_display_name,
    u01_first_name_lang,
    u01_second_name_lang,
    u01_third_name_lang,
    u01_last_name_lang,
    u01_display_name_lang,
    u06_institute_id_m02,
    u07_id,
    trading_account,
    dealer_name,
    m20_id,
    m20_symbol_code,
    order_type,
    order_type_lang,
    good_till,
    channel,
    order_status,
    order_status_lang
)
AS
    SELECT t38.t38_cond_order_id,
           t38.t38_symbol_id_m20,
           t38.t38_price,
           t38.t38_quantity,
           t38.t38_trig_qty,
           t38.t38_block_size,
           t38.t38_currency,
           t38.t38_instrument_type_code,
           t38.t38_created_date,
           t38.t38_triggered_date,
           t01.t01_date AS order_date,
           t01.t01_exchange_code_m01,
           t01.order_side,
           t01.t01_institution_id_m02,
           t01.m02_primary_institute_id_m02,
           t01.t01_ord_no,
           u01.u01_id,
           u01.u01_display_name,
           u01.u01_first_name_lang,
           u01.u01_second_name_lang,
           u01.u01_third_name_lang,
           u01.u01_last_name_lang,
           u01.u01_display_name_lang,
           u06.u06_institute_id_m02,
           u07.u07_id,
           u07.u07_display_name AS trading_account,
           u17.u17_full_name AS dealer_name,
           m20.m20_id,
           m20_symbol_code,
           v06.v06_description_1 AS order_type,
           v06.v06_description_2 AS order_type_lang,
           v10.v10_description AS good_till,
           v29.v29_description AS channel,
           v30.v30_description AS order_status,
           v30.v30_description_lang AS order_status_lang
      FROM t38_conditional_order t38
           LEFT JOIN vw_t01_order_list_base t01
               ON t38.t38_cond_order_id = t01.t01_con_ord_ref_t38
           INNER JOIN u01_customer u01
               ON t01.t01_customer_id_u01 = u01.u01_id
           INNER JOIN u07_trading_account u07
               ON t38.t38_trading_acc_id_u07 = u07.u07_id
           LEFT JOIN u17_employee u17
               ON t01.t01_dealer_id_u17 = u17.u17_id
           LEFT JOIN v30_order_status v30
               ON t01.t01_status_id_v30 = v30.v30_status_id
           LEFT JOIN v29_order_channel v29
               ON t38.t38_ord_channel_id_v29 = v29.v29_id
           LEFT JOIN v06_order_type v06
               ON t38.t38_ord_type_id_v06 = v06.v06_id
           LEFT JOIN v10_tif v10
               ON t38.t38_tif_id_v10 = v10.v10_id
           LEFT JOIN m20_symbol m20
               ON t01.t01_symbol_id_m20 = m20.m20_id
           INNER JOIN u06_cash_account u06
               ON t38.t38_cash_acc_id_u06 = u06.u06_id
     WHERE t38.t38_ord_category IN (3, 4, 8)
/