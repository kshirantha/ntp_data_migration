CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t52_desk_order_list
(
    t52_orderno,
    t52_dealer_id_u17,
    t52_order_id,
    t52_instrument_type,
    t52_created_date,
    t52_last_updated_date,
    t52_symbol_code_m20,
    t52_trading_acc_id_u07,
    t52_trading_acntno_u07,
    t52_exchange_code_m01,
    u06_currency_code_m03,
    t52_price,
    t52_expiry_date,
    t52_avgpx,
    t52_quantity,
    t52_min_quantity,
    t52_maxfloor,
    t52_cumnetsettle,
    t52_commission,
    t52_value,
    t52_netvalue,
    t52_cum_quantity,
    estvalue,
    t52_ord_type_id_v06,
    t52_side,
    t52_tif_id_v10,
    v30_description,
    v06_description_1,
    order_side,
    u07_id,
    t52_customer_id_u01,
    u01_id,
    u01_customer_no,
    custname,
    u06_accountno,
    u06_institute_id_m02,
    t52_leavesqty,
    m02_code,
    m02_name,
    t52_channel_id_v29,
    v29_description,
    t52_internall_order_status,
    t52_created_by,
    dealername,
    u05_id_no,
    u06_external_ref_no,
    u01_external_ref_no,
    t52_remote_clorderid,
    t52_remote_origclorderid,
    t52_transacttime,
    u07_exchange_account_no,
    gtd,
    createdtime,
    t52_remarks,
    t52_orig_order_id,
    t52_cum_child_qty,
    leavesqty,
    t52_status_id_v30,
    order_status,
    m20_short_description,
    m20_long_description,
    t52_desk_order_type,
    t52_text,
    t52_institution_id_m02,
    t52_cum_value,
    t52_netsettle,
    u07_trading_group_id_m08,
	m01_offline_feed 
)
AS
    SELECT t52.t52_orderno,
           t52.t52_dealer_id_u17,
           t52.t52_order_id,
           t52.t52_instrument_type,
           t52.t52_created_date,
           t52.t52_last_updated_date,
           t52.t52_symbol_code_m20,
           t52.t52_trading_acc_id_u07,
           t52_trading_acntno_u07,
           t52.t52_exchange_code_m01,
           u06.u06_currency_code_m03,
           (t52.t52_price * m20.m20_price_ratio) t52_price,
           t52.t52_expiry_date,
           (t52.t52_avgpx * m20.m20_price_ratio) t52_avgpx,
           t52.t52_quantity,
           t52.t52_min_quantity,
           t52.t52_maxfloor,
           t52.t52_netsettle AS t52_cumnetsettle,
           t52.t52_commission,
           t52.t52_value,
           t52.t52_netvalue,
           CASE
               WHEN t52.t52_cum_quantity > 0 THEN t52.t52_cum_quantity
               ELSE 0
           END
               AS t52_cum_quantity,
           CASE
               WHEN t52.t52_price > 0 THEN (t52.t52_price * t52.t52_quantity)
           END
               AS estvalue,
           t52.t52_ord_type_id_v06,
           t52.t52_side,
           t52.t52_tif_id_v10,
           v30_in.v30_description,
           v06.v06_description_1,
           CASE t52.t52_side WHEN 1 THEN 'Buy' ELSE 'Sell' END AS order_side,
           u07.u07_id,
           t52.t52_customer_id_u01,
           u01.u01_id,
           u01.u01_customer_no,
           u01.u01_display_name AS custname,
           NULL AS u06_accountno,
           u06.u06_institute_id_m02,
           t52.t52_leavesqty,
           m02_code,
           NULL AS m02_name,
           t52.t52_channel_id_v29,
           v29_description,
           t52.t52_internall_order_status,
           t52.t52_created_by,
           u17_full_name AS dealername,
           u05.u05_id_no,
           u06.u06_external_ref_no,
           u01.u01_external_ref_no,
           t52.t52_remote_clorderid,
           t52.t52_remote_origclorderid,
           t52.t52_transacttime,
           u07_exchange_account_no,
           v10.v10_description AS gtd,
           TO_CHAR (t52.t52_created_date, 'HH:MI:SS AM') AS createdtime,
           t52.t52_remarks,
           CASE WHEN t52.t52_orig_order_id > 0 THEN t52.t52_orig_order_id END
               AS t52_orig_order_id,
           t52.t52_cum_child_qty,
           t52.t52_quantity - t52.t52_cum_quantity AS leavesqty,
           t52.t52_status_id_v30,
           v30.v30_description AS order_status,
           m20.m20_short_description,
           m20.m20_long_description,
           t52.t52_desk_order_type,
           t52.t52_text,
           t52_institution_id_m02,
           t52.t52_cum_value,
           t52.t52_netsettle,
           u07.u07_trading_group_id_m08,
		   m01.m01_offline_feed
      FROM t52_desk_orders t52
           LEFT JOIN v30_order_status v30_in
               ON t52.t52_internall_order_status = v30_in.v30_status_id
           LEFT JOIN v30_order_status v30
               ON t52.t52_status_id_v30 = v30.v30_status_id
           JOIN u01_customer u01
               ON t52.t52_customer_id_u01 = u01.u01_id
           JOIN u06_cash_account u06
               ON t52.t52_cash_acc_id_u06 = u06.u06_id
           JOIN u07_trading_account u07
               ON t52.t52_trading_acc_id_u07 = u07.u07_id
           JOIN u05_customer_identification u05
               ON u01.u01_id = u05.u05_customer_id_u01 AND u05_is_default = 1
           JOIN m02_institute m02
               ON u06.u06_institute_id_m02 = m02.m02_id
           LEFT JOIN u17_employee u17
               ON t52.t52_dealer_id_u17 = u17.u17_id
           LEFT JOIN m20_symbol m20
               ON t52.t52_symbol_id_m20 = m20.m20_id
           LEFT JOIN v29_order_channel v29
               ON t52.t52_channel_id_v29 = v29.v29_id
           LEFT JOIN v06_order_type v06
               ON t52.t52_ord_type_id_v06 = v06.v06_type_id
           LEFT JOIN v10_tif v10
               ON t52.t52_tif_id_v10 = v10.v10_id
		   JOIN m01_exchanges m01
               ON m02.m02_primary_institute_id_m02 = m01.m01_institute_id_m02 AND t52.t52_exchange_code_m01 = m01.m01_exchange_code
/