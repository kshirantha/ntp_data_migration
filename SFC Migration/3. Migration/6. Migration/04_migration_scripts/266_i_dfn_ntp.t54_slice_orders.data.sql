DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_slice_order_id         NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (t54_ordid), 0)
      INTO l_slice_order_id
      FROM dfn_ntp.t54_slice_orders;

    DELETE FROM error_log
          WHERE mig_table = 'T54_SLICE_ORDERS';

    FOR i
        IN (SELECT t36.t36_ordid,
                   t36.t36_order,
                   t36.t36_condition,
                   t36.t36_order_status, -- [SAME IDs]
                   t36.t36_exec_type, -- [SAME IDs]
                   t36.t36_create_date AS created_date,
                   t36.t36_triggered_date AS triggered_date,
                   t36.t36_expired_date AS expired_date,
                   t36.t36_ord_qty,
                   t36.t36_ord_qty_sent,
                   t36.t36_portfoliono,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   t36.t36_block_size,
                   t36.t36_trig_interval, -- [SAME IDs]
                   t36.t36_last_block_status,
                   t36.t36_ord_reject_reason,
                   NVL (map16.map16_ntp_code, t36.t36_exchange) AS exchange,
                   t36.t36_interval_type, -- [SAME IDs]
                   t36.t36_start_time,
                   t36.t36_ord_qty_filled,
                   t36.t36_ord_qty_part_filled,
                   t36.t36_max_percentage_vol,
                   t36.t36_min_percentage_vol,
                   t36.t36_would_level,
                   t36.t36_limit_price,
                   t36.t36_max_orders,
                   t36.t36_renewal_percentage,
                   t36.t36_queued_ord_count,
                   t36.t36_limit_condition,
                   t36.t36_would_condition,
                   t36.t36_symbol,
                   t36.t36_renew_quantity,
                   t36.t36_inst_service_id,
                   m20.m20_instrument_type_code_v09,
                   u07.u07_customer_id_u01,
                   u07.u07_customer_no_u01,
                   u07.u07_exchange_account_no,
                   u07.u07_institute_id_m02,
                   m20.m20_id,
                   t54_map.new_slice_order_id
              FROM mubasher_oms.t36_slice_orders@mubasher_db_link t36,
                   mubasher_oms.u05_security_accounts@mubasher_db_link u05_oms,
                   u07_trading_account_mappings u07_map,
                   u17_employee_mappings u17_created,
                   map16_optional_exchanges_m01 map16,
                   dfn_ntp.u07_trading_account u07,
                   (SELECT m20_id,
                           m20_symbol_code,
                           m20_exchange_code_m01,
                           m20_instrument_type_code_v09
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20,
                   t54_slice_orders_mappings t54_map
             WHERE     t36.t36_portfoliono = u05_oms.u05_accountno
                   AND u05_oms.u05_id = u07_map.old_trading_account_id
                   AND t36.t36_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, t36.t36_exchange) =
                           u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id = u07.u07_id
                   AND t36.t36_symbol = m20.m20_symbol_code
                   AND t36.t36_exchange = m20.m20_exchange_code_m01
                   AND t36.t36_user_id = u17_created.old_employee_id(+)
                   AND t36.t36_ordid = t54_map.old_slice_order_id(+))
    LOOP
        BEGIN
            IF i.exchange IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.new_slice_order_id IS NULL
            THEN
                l_slice_order_id := l_slice_order_id + 1;

                INSERT
                  INTO dfn_ntp.t54_slice_orders (t54_ordid,
                                                 t54_order,
                                                 t54_condition,
                                                 t54_order_status,
                                                 t54_exec_type,
                                                 t54_create_date,
                                                 t54_triggered_date,
                                                 t54_expired_date,
                                                 t54_ord_qty,
                                                 t54_ord_qty_sent,
                                                 t54_portfoliono,
                                                 t54_user_id,
                                                 t54_block_size,
                                                 t54_trig_interval,
                                                 t54_last_block_status,
                                                 t54_ord_reject_reason,
                                                 t54_exchange,
                                                 t54_interval_type,
                                                 t54_start_time,
                                                 t54_ord_qty_filled,
                                                 t54_ord_qty_part_filled,
                                                 t54_max_percentage_vol,
                                                 t54_min_percentage_vol,
                                                 t54_would_level,
                                                 t54_limit_price,
                                                 t54_max_orders,
                                                 t54_renewal_percentage,
                                                 t54_queued_ord_count,
                                                 t54_limit_condition,
                                                 t54_would_condition,
                                                 t54_symbol,
                                                 t54_renew_quantity,
                                                 t54_inst_service_id,
                                                 t54_instrument_type,
                                                 t54_customer_id,
                                                 t54_mubasher_no,
                                                 t54_routingac,
                                                 t54_algorithm_id,
                                                 t54_thirdparty_mre,
                                                 t54_algo_start_time,
                                                 t54_algo_end_time,
                                                 t54_participation_perc,
                                                 t54_min_order_amount,
                                                 t54_behind_perc,
                                                 t54_kickoff_perc,
                                                 t54_aggressive_chase,
                                                 t54_shadowing_depth,
                                                 t54_opening,
                                                 t54_closing,
                                                 t54_waves,
                                                 t54_would_price,
                                                 t54_perc_at_open,
                                                 t54_perc_at_close,
                                                 t54_style,
                                                 t54_slices,
                                                 t54_strategy_status,
                                                 t54_orig_ord_id,
                                                 t54_order_no,
                                                 t54_accumulate_volume,
                                                 t54_close_simulation,
                                                 t54_orderid,
                                                 t54_execid,
                                                 t54_cum_ordnetvalue,
                                                 t54_channel,
                                                 t54_ordertype,
                                                 t54_exec_broker_inst,
                                                 t54_custodian_inst_id,
                                                 t54_timeinforce,
                                                 t54_desk_order_ref,
                                                 t54_desk_order_number,
                                                 t54_price,
                                                 t54_side,
                                                 t54_ord_type_id_v06,
                                                 t54_currency,
                                                 t54_cond_type,
                                                 t54_institution_id_m02,
                                                 t54_symbol_id_m20)
                VALUES (l_slice_order_id, -- t54_ordid
                        i.t36_order, -- t54_order
                        i.t36_condition, -- t54_condition
                        i.t36_order_status, -- t54_order_status
                        i.t36_exec_type, -- t54_exec_type
                        i.created_date, -- t54_create_date
                        i.triggered_date, -- t54_triggered_date
                        i.expired_date, -- t54_expired_date
                        i.t36_ord_qty, -- t54_ord_qty
                        i.t36_ord_qty_sent, -- t54_ord_qty_sent
                        i.t36_portfoliono, -- t54_portfoliono
                        i.created_by_new_id, -- t54_user_id
                        i.t36_block_size, -- t54_block_size
                        i.t36_trig_interval, -- t54_trig_interval
                        i.t36_last_block_status, -- t54_last_block_status
                        i.t36_ord_reject_reason, -- t54_ord_reject_reason
                        i.exchange, -- t54_exchange
                        i.t36_interval_type, -- t54_interval_type
                        i.t36_start_time, -- t54_start_time
                        i.t36_ord_qty_filled, -- t54_ord_qty_filled
                        i.t36_ord_qty_part_filled, -- t54_ord_qty_part_filled
                        i.t36_max_percentage_vol, -- t54_max_percentage_vol
                        i.t36_min_percentage_vol, -- t54_min_percentage_vol
                        i.t36_would_level, -- t54_would_level
                        i.t36_limit_price, -- t54_limit_price
                        i.t36_max_orders, -- t54_max_orders
                        i.t36_renewal_percentage, -- t54_renewal_percentage
                        i.t36_queued_ord_count, -- t54_queued_ord_count
                        i.t36_limit_condition, -- t54_limit_condition
                        i.t36_would_condition, -- t54_would_condition
                        i.t36_symbol, -- t54_symbol
                        i.t36_renew_quantity, -- t54_renew_quantity
                        i.t36_inst_service_id, -- t54_inst_service_id
                        i.m20_instrument_type_code_v09, -- t54_instrument_type
                        i.u07_customer_id_u01, -- t54_customer_id
                        i.u07_customer_no_u01, -- t54_mubasher_no
                        i.u07_exchange_account_no, -- t54_routingac
                        NULL, -- t54_algorithm_id  | Not Available
                        0, -- t54_thirdparty_mre | Not Available
                        NULL, -- t54_algo_start_time | Not Available
                        NULL, -- t54_algo_end_time | Not Available
                        0, -- t54_participation_perc | Not Available
                        -1, -- t54_min_order_amount | Not Available
                        0, -- t54_behind_perc | Not Available
                        0, -- t54_kickoff_perc | Not Available
                        0, -- t54_aggressive_chase | Not Available
                        -1, -- t54_shadowing_depth | Not Available
                        0, -- t54_opening | Not Available
                        0, -- t54_closing | Not Available
                        -1, -- t54_waves | Not Available
                        -1, -- t54_would_price | Not Available
                        0, -- t54_perc_at_open | Not Available
                        0, -- t54_perc_at_close | Not Available
                        0, -- t54_style | Not Available
                        -1, -- t54_slices | Not Available
                        -1, -- t54_strategy_status | Not Available
                        -1, -- t54_orig_ord_id | Not Available
                        NULL, -- t54_order_no | Not Available
                        0, -- t54_accumulate_volume | Not Available
                        0, -- t54_close_simulation | Not Available
                        NULL, -- t54_orderid | Not Available
                        NULL, -- t54_execid | Not Available
                        NULL, -- t54_cum_ordnetvalue | Not Available
                        NULL, -- t54_channel | Not Available
                        NULL, -- t54_ordertype | Not Available
                        NULL, -- t54_exec_broker_inst | Not Available
                        NULL, -- t54_custodian_inst_id | Not Available
                        NULL, -- t54_timeinforce | Not Available
                        NULL, -- t54_desk_order_ref | Not Available
                        NULL, -- t54_desk_order_number | Not Available
                        0, -- t54_price | Not Available
                        NULL, -- t54_side | Not Available
                        NULL, -- t54_ord_type_id_v06 | Not Available
                        NULL, -- t54_currency | Not Available
                        NULL, -- t54_cond_type | Not Available
                        i.u07_institute_id_m02, -- t54_institution_id_m02
                        i.m20_id -- t54_symbol_id_m20
                                );

                INSERT
                  INTO t54_slice_orders_mappings (old_slice_order_id,
                                                  new_slice_order_id)
                VALUES (i.t36_ordid, l_slice_order_id);
            ELSE
                UPDATE dfn_ntp.t54_slice_orders
                   SET t54_order = i.t36_order, -- t54_order
                       t54_condition = i.t36_condition, -- t54_condition
                       t54_order_status = i.t36_order_status, -- t54_order_status
                       t54_exec_type = i.t36_exec_type, -- t54_exec_type
                       t54_triggered_date = i.triggered_date, -- t54_triggered_date
                       t54_expired_date = i.expired_date, -- t54_expired_date
                       t54_ord_qty = i.t36_ord_qty, -- t54_ord_qty
                       t54_ord_qty_sent = i.t36_ord_qty_sent, -- t54_ord_qty_sent
                       t54_portfoliono = i.t36_portfoliono, -- t54_portfoliono
                       t54_user_id = i.created_by_new_id, -- t54_user_id
                       t54_block_size = i.t36_block_size, -- t54_block_size
                       t54_trig_interval = i.t36_trig_interval, -- t54_trig_interval
                       t54_last_block_status = i.t36_last_block_status, -- t54_last_block_status
                       t54_ord_reject_reason = i.t36_ord_reject_reason, -- t54_ord_reject_reason
                       t54_exchange = i.exchange, -- t54_exchange
                       t54_interval_type = i.t36_interval_type, -- t54_interval_type
                       t54_start_time = i.t36_start_time, -- t54_start_time
                       t54_ord_qty_filled = i.t36_ord_qty_filled, -- t54_ord_qty_filled
                       t54_ord_qty_part_filled = i.t36_ord_qty_part_filled, -- t54_ord_qty_part_filled
                       t54_max_percentage_vol = i.t36_max_percentage_vol, -- t54_max_percentage_vol
                       t54_min_percentage_vol = i.t36_min_percentage_vol, -- t54_min_percentage_vol
                       t54_would_level = i.t36_would_level, -- t54_would_level
                       t54_limit_price = i.t36_limit_price, -- t54_limit_price
                       t54_max_orders = i.t36_max_orders, -- t54_max_orders
                       t54_renewal_percentage = i.t36_renewal_percentage, -- t54_renewal_percentage
                       t54_queued_ord_count = i.t36_queued_ord_count, -- t54_queued_ord_count
                       t54_limit_condition = i.t36_limit_condition, -- t54_limit_condition
                       t54_would_condition = i.t36_would_condition, -- t54_would_condition
                       t54_symbol = i.t36_symbol, -- t54_symbol
                       t54_renew_quantity = i.t36_renew_quantity, -- t54_renew_quantity
                       t54_inst_service_id = i.t36_inst_service_id, -- t54_inst_service_id
                       t54_instrument_type = i.m20_instrument_type_code_v09, -- t54_instrument_type
                       t54_customer_id = i.u07_customer_id_u01, -- t54_customer_id
                       t54_mubasher_no = i.u07_customer_no_u01, -- t54_mubasher_no
                       t54_routingac = i.u07_exchange_account_no, -- t54_routingac
                       t54_institution_id_m02 = i.u07_institute_id_m02, -- t54_institution_id_m02
                       t54_symbol_id_m20 = i.m20_id -- t54_symbol_id_m20
                 WHERE t54_ordid = i.new_slice_order_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T54_SLICE_ORDERS',
                                i.t36_ordid,
                                CASE
                                    WHEN i.new_slice_order_id IS NULL
                                    THEN
                                        l_slice_order_id
                                    ELSE
                                        i.new_slice_order_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_slice_order_id IS NULL
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