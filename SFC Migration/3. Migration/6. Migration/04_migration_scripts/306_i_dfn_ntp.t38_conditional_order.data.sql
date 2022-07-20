DECLARE
    l_conditional_order_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t38_cond_order_id), 0)
      INTO l_conditional_order_id
      FROM dfn_ntp.t38_conditional_order;

    DELETE FROM error_log
          WHERE mig_table = 'T38_CONDITIONAL_ORDER';

    FOR i
        IN (SELECT t32.t32_cond_orderid,
                   t01.t01_trading_acc_id_u07,
                   t01.t01_customer_id_u01,
                   t01.t01_cash_acc_id_u06,
                   t01.t01_symbol_id_m20,
                   t32.t32_condition,
                   CASE WHEN t32.t32_condition_type = 1 THEN 8 ELSE 3 END
                       AS category,
                   CASE
                       WHEN t32.t32_condition_status = 1 THEN 'A'
                       WHEN t32.t32_condition_status = 2 THEN '8'
                       WHEN t32.t32_condition_status = 3 THEN ']'
                       WHEN t32.t32_condition_status = 4 THEN 'C'
                       WHEN t32.t32_condition_status = 5 THEN '4'
                       WHEN t32.t32_condition_status = 6 THEN 'W'
                   END
                       AS condition_status,
                   t32.t32_condition_class_name,
                   t32.t32_expire_date,
                   t32.t32_created_date,
                   t32.t32_triggered_date,
                   t01.t01_dealer_id_u17,
                   t32.t32_ord_reject_reason,
                   t01.t01_instrument_type_code,
                   t01.t01_orig_cl_ord_id,
                   t01.t01_symbol_code_m20,
                   t01.t01_quantity,
                   t01.t01_price,
                   t01.t01_side,
                   t01.t01_ord_type_id_v06,
                   t01.t01_tif_id_v10,
                   t01.t01_exchange_code_m01,
                   t32.t32_start_date,
                   t01.t01_cum_quantity,
                   t01.t01_ord_channel_id_v29,
                   t01.t01_desk_order_ref_t52,
                   t01.t01_institution_id_m02,
                   t01.t01_cum_net_value,
                   t01.t01_cum_netstl,
                   t01.t01_server_id,
                   t01.t01_ord_no,
                   t01.t01_last_updated_date_time,
                   u01.u01_customer_no,
                   t01.t01_settle_currency,
                   t01.t01_exchange_id_m01,
                   t38_map.new_conditional_order_id
              FROM mubasher_oms.t32_conditional_orders@mubasher_db_link t32,
                   t01_order_mappings t01_map,
                   dfn_ntp.t01_order t01,
                   dfn_ntp.u01_customer u01,
                   t38_conditional_order_mappings t38_map
             WHERE     t32.t32_t01_clordid = t01_map.old_cl_order_id
                   AND t01_map.new_cl_order_id = t01.t01_cl_ord_id
                   AND t01.t01_customer_id_u01 = u01.u01_id
                   AND t32.t32_cond_orderid =
                           t38_map.new_conditional_order_id(+))
    LOOP
        BEGIN
            IF i.new_conditional_order_id IS NULL
            THEN
                l_conditional_order_id := l_conditional_order_id + 1;

                INSERT
                  INTO dfn_ntp.t38_conditional_order (
                           t38_cond_order_id,
                           t38_trading_acc_id_u07,
                           t38_customer_id_u01,
                           t38_cash_acc_id_u06,
                           t38_symbol_id_m20,
                           t38_condition,
                           t38_condition_status,
                           t38_expiry_date,
                           t38_created_date,
                           t38_triggered_date,
                           t38_dealer_id_u17,
                           t38_reject_reason,
                           t38_instrument_type_code,
                           t38_strategy_name,
                           t38_orig_cl_ord_id,
                           t38_symbol_code_m20,
                           t38_quantity,
                           t38_price,
                           t38_side,
                           t38_ord_type_id_v06,
                           t38_tif_id_v10,
                           t38_exchange_code_m01,
                           t38_start_time,
                           t38_cum_quantity,
                           t38_trig_qty,
                           t38_ord_channel_id_v29,
                           t38_desk_order_ref_t52,
                           t38_institution_id_m02,
                           t38_exec_type,
                           t38_trig_interval,
                           t38_block_size,
                           t38_cum_net_value,
                           t38_cum_netstl,
                           t38_trig_ord_count,
                           t38_server_id,
                           t38_ord_no,
                           t38_last_updated_date_time,
                           t38_ord_category,
                           t38_customer_no,
                           t38_stop_px,
                           t38_takeprofit_px,
                           t38_currency,
                           t38_triggered_time,
                           t38_triggered_price,
                           t38_exchange_id_m01,
                           t38_cond_exp_time)
                VALUES (l_conditional_order_id, --t38_cond_order_id
                        i.t01_trading_acc_id_u07, -- t38_trading_acc_id_u07
                        i.t01_customer_id_u01, -- t38_customer_id_u01
                        i.t01_cash_acc_id_u06, -- t38_cash_acc_id_u06
                        i.t01_symbol_id_m20, -- t38_symbol_id_m20
                        i.t32_condition, -- t38_condition
                        i.condition_status, -- t38_condition_status
                        i.t32_expire_date, -- t38_expiry_date
                        i.t32_created_date, -- t38_created_date
                        i.t32_triggered_date, -- t38_triggered_date
                        i.t01_dealer_id_u17, -- t38_dealer_id_u17
                        i.t32_ord_reject_reason, -- t38_reject_reason
                        i.t01_instrument_type_code, -- t38_instrument_type_code
                        i.t32_condition_class_name, -- t38_strategy_name
                        i.t01_orig_cl_ord_id, -- t38_orig_cl_ord_id
                        i.t01_symbol_code_m20, -- t38_symbol_code_m20
                        i.t01_quantity, -- t38_quantity
                        i.t01_price, -- t38_price
                        i.t01_side, -- t38_side
                        i.t01_ord_type_id_v06, -- t38_ord_type_id_v06
                        i.t01_tif_id_v10, -- t38_tif_id_v10
                        i.t01_exchange_code_m01, -- t38_exchange_code_m01
                        i.t32_start_date, -- t38_start_time
                        i.t01_cum_quantity, -- t38_cum_quantity
                        NULL, -- t38_trig_qty | Not Available
                        i.t01_ord_channel_id_v29, -- t38_ord_channel_id_v29
                        i.t01_desk_order_ref_t52, -- t38_desk_order_ref_t52
                        i.t01_institution_id_m02, -- t38_institution_id_m02
                        NULL, -- t38_exec_type | Not Available
                        NULL, -- t38_trig_interval | Not Available
                        NULL, -- t38_block_size | Not Available
                        i.t01_cum_net_value, -- t38_cum_net_value
                        i.t01_cum_netstl, -- t38_cum_netstl
                        NULL, -- t38_trig_ord_count | Not Available
                        i.t01_server_id, -- t38_server_id
                        i.t01_ord_no, -- t38_ord_no
                        i.t01_last_updated_date_time, -- t38_last_updated_date_time
                        i.category, -- t38_ord_category
                        i.u01_customer_no, -- t38_customer_no
                        NULL, -- t38_stop_px  | Not Available
                        NULL, -- t38_takeprofit_px | Not Available
                        i.t01_settle_currency, -- t38_currency
                        NULL, -- t38_triggered_time | Not Available - Can be Derived from T32_TRIGGERED_DATE If Time Portion Available
                        NULL, -- t38_triggered_price | Not Available
                        i.t01_exchange_id_m01, -- t38_exchange_id_m01
                        NULL --  t38_cond_exp_time | Not Available - Can be Derived from T32_EXPIRE_DATE If Time Portion Available
                            );

                INSERT
                  INTO t38_conditional_order_mappings (
                           old_conditional_order_id,
                           new_conditional_order_id)
                VALUES (i.t32_cond_orderid, l_conditional_order_id);
            ELSE
                UPDATE dfn_ntp.t38_conditional_order
                   SET t38_trading_acc_id_u07 = i.t01_trading_acc_id_u07, -- t38_trading_acc_id_u07
                       t38_customer_id_u01 = i.t01_customer_id_u01, -- t38_customer_id_u01
                       t38_cash_acc_id_u06 = i.t01_cash_acc_id_u06, -- t38_cash_acc_id_u06
                       t38_symbol_id_m20 = i.t01_symbol_id_m20, -- t38_symbol_id_m20
                       t38_condition = i.t32_condition, -- t38_condition
                       t38_condition_status = i.condition_status, -- t38_condition_status
                       t38_expiry_date = i.t32_expire_date, -- t38_expiry_date
                       t38_triggered_date = i.t32_triggered_date, -- t38_triggered_date
                       t38_dealer_id_u17 = i.t01_dealer_id_u17, -- t38_dealer_id_u17
                       t38_reject_reason = i.t32_ord_reject_reason, -- t38_reject_reason
                       t38_instrument_type_code = i.t01_instrument_type_code, -- t38_instrument_type_code
                       t38_strategy_name = i.t32_condition_class_name, -- t38_strategy_name
                       t38_orig_cl_ord_id = i.t01_orig_cl_ord_id, -- t38_orig_cl_ord_id
                       t38_symbol_code_m20 = i.t01_symbol_code_m20, -- t38_symbol_code_m20
                       t38_quantity = i.t01_quantity, -- t38_quantity
                       t38_price = i.t01_price, -- t38_price
                       t38_side = i.t01_side, -- t38_side
                       t38_ord_type_id_v06 = i.t01_ord_type_id_v06, -- t38_ord_type_id_v06
                       t38_tif_id_v10 = i.t01_tif_id_v10, -- t38_tif_id_v10
                       t38_exchange_code_m01 = i.t01_exchange_code_m01, -- t38_exchange_code_m01
                       t38_start_time = i.t32_start_date, -- t38_start_time
                       t38_cum_quantity = i.t01_cum_quantity, -- t38_cum_quantity
                       t38_ord_channel_id_v29 = i.t01_ord_channel_id_v29, -- t38_ord_channel_id_v29
                       t38_desk_order_ref_t52 = i.t01_desk_order_ref_t52, -- t38_desk_order_ref_t52
                       t38_institution_id_m02 = i.t01_institution_id_m02, -- t38_institution_id_m02
                       t38_cum_net_value = i.t01_cum_net_value, -- t38_cum_net_value
                       t38_cum_netstl = i.t01_cum_netstl, -- t38_cum_netstl
                       t38_server_id = i.t01_server_id, -- t38_server_id
                       t38_ord_no = i.t01_ord_no, -- t38_ord_no
                       t38_last_updated_date_time =
                           i.t01_last_updated_date_time, -- t38_last_updated_date_time
                       t38_ord_category = i.category, -- t38_ord_category
                       t38_customer_no = i.u01_customer_no, -- t38_customer_no
                       t38_currency = i.t01_settle_currency, -- t38_currency
                       t38_exchange_id_m01 = i.t01_exchange_id_m01 -- t38_exchange_id_m01
                 WHERE t38_cond_order_id = i.new_conditional_order_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T38_CONDITIONAL_ORDER',
                                i.t32_cond_orderid,
                                CASE
                                    WHEN i.new_conditional_order_id IS NULL
                                    THEN
                                        l_conditional_order_id
                                    ELSE
                                        i.new_conditional_order_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_conditional_order_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
