DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_desk_order_id          NUMBER;
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

    SELECT NVL (MAX (t52_order_id), 0)
      INTO l_desk_order_id
      FROM dfn_ntp.t52_desk_orders;

    DELETE FROM error_log
          WHERE mig_table = 'T52_DESK_ORDERS';

    FOR i
        IN (SELECT t52_order_id,
                   t52_orig_order_id,
                   t52_orderno,
                   u01_map.new_customer_id,
                   u07_map.new_trading_account_id,
                   u07.u07_exchange_account_no,
                   u07.u07_cash_account_id_u06,
                   t52_channel, -- [SAME IDs]
                   m20.m20_exchange_code_m01,
                   m20.m20_symbol_code,
                   t52_ordertype, -- [SAME IDs]
                   t52_side,
                   t52_orderqty,
                   t52_price,
                   t52_avgpx,
                   t52_timeinforce, -- [SAME IDs]
                   t52_expiretime,
                   t52_minqty,
                   t52_maxfloor,
                   t52_ordstatus, -- [SAME IDs]
                   t52_remarks,
                   t52_ordvalue,
                   t52_ordnetvalue,
                   t52_netsettle,
                   t52_issue_stl_rate,
                   t52_cumqty,
                   t52_leavesqty,
                   t52_lastshares,
                   t52_lastpx,
                   TO_DATE (t52_transacttime, 'YYYYMMDD HH24:MI:SS')
                       AS transaction_time,
                   t52_commission,
                   t52_avgcost,
                   t52_exg_commission,
                   v34.v34_inst_code_v09,
                   t52_remote_clorderid,
                   t52_remote_origclorderid,
                   t52_remote_symbol,
                   t52_remote_tag_22,
                   t52_remote_accountno,
                   t52_fixmsgtype,
                   t52_fix_ver,
                   t52_tag_56,
                   t52_tag_50,
                   t52_tag_57,
                   t52_tag_18,
                   t52_tag_115,
                   m26_map.new_executing_broker_id,
                   t52_reject_reason,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   t52_created_date AS created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   u17_updated.new_employee_id AS last_updated_by_new_id,
                   t52_last_updated_date AS last_updated_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   t52_cum_child_qty,
                   t52_internall_order_status, -- [SAME IDs]
                   m02_map.new_institute_id,
                   m20.m20_id,
                   m20.m20_exchange_id_m01,
                   t52.t52_market_code,
                   t52_map.new_desk_orders_id
              FROM mubasher_oms.t52_desk_orders@mubasher_db_link t52,
                   u01_customer_mappings u01_map,
                   map16_optional_exchanges_m01 map16,
                   u07_trading_account_mappings u07_map,
                   dfn_ntp.u07_trading_account u07,
                   (SELECT m20_id,
                           m20_symbol_code,
                           m20_exchange_id_m01,
                           m20_exchange_code_m01
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20,
                   dfn_ntp.v34_price_instrument_type v34,
                   m02_institute_mappings m02_map,
                   m26_executing_broker_mappings m26_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_updated,
                   t52_desk_orders_mappings t52_map
             WHERE     t52.t52_customer_id = u01_map.old_customer_id
                   AND t52.t52_security_ac_id =
                           u07_map.old_trading_account_id
                   AND t52.t52_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, t52.t52_exchange) =
                           u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id = u07.u07_id
                   AND t52.t52_symbol = m20.m20_symbol_code
                   AND NVL (map16.map16_ntp_code, t52.t52_exchange) =
                           m20.m20_exchange_code_m01
                   AND t52.t52_instrument_type = v34.v34_price_inst_type_id
                   AND t52.t52_institution_id = m02_map.old_institute_id
                   AND t52.t52_exec_broker_inst =
                           m26_map.old_executing_broker_id(+)
                   AND t52.t52_created_by = u17_created.old_employee_id(+)
                   AND t52.t52_last_updated_by =
                           u17_updated.old_employee_id(+)
                   AND t52.t52_order_id = t52_map.old_desk_orders_id(+))
    LOOP
        BEGIN
            IF i.m20_exchange_id_m01 IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.new_desk_orders_id IS NULL
            THEN
                l_desk_order_id := l_desk_order_id + 1;

                INSERT
                  INTO dfn_ntp.t52_desk_orders (t52_order_id,
                                                t52_orig_order_id,
                                                t52_orderno,
                                                t52_customer_id_u01,
                                                t52_trading_acc_id_u07,
                                                t52_trading_acntno_u07,
                                                t52_tenant_code,
                                                t52_cash_acc_id_u06,
                                                t52_channel_id_v29,
                                                t52_exchange_code_m01,
                                                t52_symbol_code_m20,
                                                t52_ord_type_id_v06,
                                                t52_side,
                                                t52_quantity,
                                                t52_price,
                                                t52_avgpx,
                                                t52_tif_id_v10,
                                                t52_expiry_date,
                                                t52_min_quantity,
                                                t52_maxfloor,
                                                t52_status_id_v30,
                                                t52_remarks,
                                                t52_value,
                                                t52_netvalue,
                                                t52_netsettle,
                                                t52_cum_value,
                                                t52_cum_netvalue,
                                                t52_cum_netsettle,
                                                t52_issue_stl_rate,
                                                t52_cum_quantity,
                                                t52_leavesqty,
                                                t52_transacttime,
                                                t52_commission,
                                                t52_cum_commission,
                                                t52_avgcost,
                                                t52_exg_commission,
                                                t52_cum_exg_commission,
                                                t52_tax,
                                                t52_cum_tax,
                                                t52_instrument_type,
                                                t52_remote_clorderid,
                                                t52_remote_origclorderid,
                                                t52_remote_symbol,
                                                t52_remote_tag_22,
                                                t52_remote_accountno,
                                                t52_remote_tag_11001,
                                                t52_remote_tag_48,
                                                t52_remote_tag_100,
                                                t52_remote_tag_207,
                                                t52_fixmsgtype,
                                                t52_fix_ver,
                                                t52_tag_56,
                                                t52_tag_50,
                                                t52_tag_57,
                                                t52_tag_18,
                                                t52_tag_115,
                                                t52_exec_broker_id_m26,
                                                t52_custodian_id_m26,
                                                t52_text,
                                                t52_created_by,
                                                t52_created_date,
                                                t52_last_updated_by,
                                                t52_last_updated_date,
                                                t52_cum_child_qty,
                                                t52_internall_order_status,
                                                t52_auto_release_status,
                                                t52_desk_order_type,
                                                t52_bucket_pro_rata_per,
                                                t52_bucket_order_ref,
                                                t52_bucket_id,
                                                t52_swap_tag,
                                                t52_approved_by,
                                                t52_discount,
                                                t52_cum_discount,
                                                t52_dealer_id_u17,
                                                t52_app_server_id,
                                                t52_institution_id_m02,
                                                t52_symbol_id_m20,
                                                t52_exchange_id_m01,
                                                t52_market_code_m29,
                                                t52_board_code_m54)
                VALUES (l_desk_order_id, -- t52_order_id
                        i.t52_orig_order_id, -- t52_orig_order_id | Update Later in this Script
                        i.t52_orderno, --t52_orderno | Update Later in this Script
                        i.new_customer_id, -- t52_customer_id_u01
                        i.new_trading_account_id, -- t52_trading_acc_id_u07
                        i.u07_exchange_account_no, -- t52_trading_acntno_u07
                        'DEFAULT_TENANT', -- t52_tenant_code
                        i.u07_cash_account_id_u06, -- t52_cash_acc_id_u06
                        i.t52_channel, -- t52_channel_id_v29
                        i.m20_exchange_code_m01, -- t52_exchange_code_m01
                        i.m20_symbol_code, -- t52_symbol_code_m20
                        i.t52_ordertype, -- t52_ord_type_id_v06
                        i.t52_side, -- t52_side
                        i.t52_orderqty, -- t52_quantity
                        i.t52_price, -- t52_price
                        i.t52_avgpx, -- t52_avgpx
                        i.t52_timeinforce, -- t52_tif_id_v10
                        i.t52_expiretime, -- t52_expiry_date
                        i.t52_minqty, -- t52_min_quantity
                        i.t52_maxfloor, -- t52_maxfloor
                        i.t52_ordstatus, -- t52_status_id_v30
                        i.t52_remarks, -- t52_remarks
                        i.t52_ordvalue, -- t52_value
                        i.t52_ordnetvalue, -- t52_netvalue
                        i.t52_netsettle, -- t52_netsettle
                        NULL, -- t52_cum_value | Not Available
                        NULL, -- t52_cum_netvalue | Not Available
                        NULL, -- t52_cum_netsettle | Not Available
                        i.t52_issue_stl_rate, -- t52_issue_stl_rate
                        i.t52_cumqty, -- t52_cum_quantity
                        i.t52_leavesqty, -- t52_leavesqty
                        i.transaction_time, -- t52_transacttime
                        i.t52_commission, -- t52_commission
                        NULL, -- t52_cum_commission
                        i.t52_avgcost, -- t52_avgcost
                        i.t52_exg_commission, -- t52_exg_commission
                        NULL, -- t52_cum_exg_commission
                        NULL, -- t52_tax
                        NULL, -- t52_cum_tax
                        i.v34_inst_code_v09, -- t52_instrument_type
                        i.t52_remote_clorderid, -- t52_remote_clorderid
                        i.t52_remote_origclorderid, -- t52_remote_origclorderid
                        i.t52_remote_symbol, -- t52_remote_symbol
                        i.t52_remote_tag_22, -- t52_remote_tag_22
                        i.t52_remote_accountno, -- t52_remote_accountno
                        NULL, -- t52_remote_tag_11001
                        NULL, -- t52_remote_tag_48
                        NULL, -- t52_remote_tag_100 | Not Available
                        NULL, -- t52_remote_tag_207 | Not Available
                        i.t52_fixmsgtype, -- t52_fixmsgtype
                        i.t52_fix_ver, -- t52_fix_ver
                        i.t52_tag_56, -- t52_tag_56
                        i.t52_tag_50, -- t52_tag_50
                        i.t52_tag_57, -- t52_tag_57
                        i.t52_tag_18, -- t52_tag_18
                        i.t52_tag_115, -- t52_tag_115
                        i.new_executing_broker_id, -- t52_exec_broker_id_m26
                        i.new_executing_broker_id, -- t52_custodian_id_m26
                        i.t52_reject_reason, -- t52_text
                        i.created_by_new_id, -- t52_created_by
                        i.created_date, --  t52_created_date
                        i.last_updated_by_new_id, -- t52_last_updated_by
                        i.last_updated_date, -- t52_last_updated_date
                        i.t52_cum_child_qty, -- t52_cum_child_qty
                        i.t52_internall_order_status, -- t52_internall_order_status
                        -1, -- t52_auto_release_status | Not Available
                        i.t52_ordertype, -- t52_desk_order_type
                        NULL, -- t52_bucket_pro_rata_per
                        NULL, -- t52_bucket_order_ref
                        NULL, -- t52_bucket_id
                        NULL, -- t52_swap_tag
                        i.last_updated_by_new_id, -- t52_approved_by
                        NULL, -- t52_discount
                        NULL, -- t52_cum_discount
                        i.created_by_new_id, -- t52_dealer_id_u17
                        NULL, -- t52_app_server_id
                        i.new_institute_id, -- t52_institution_id_m02
                        i.m20_id, -- t52_symbol_id_m20
                        i.m20_exchange_id_m01, -- t52_exchange_id_m01
                        i.t52_market_code, -- t52_market_code_m29
                        NULL -- t52_board_code_m54 | Not Available
                            );

                INSERT INTO t52_desk_orders_mappings
                     VALUES (i.t52_order_id, l_desk_order_id);
            ELSE
                UPDATE dfn_ntp.t52_desk_orders
                   SET t52_orig_order_id = i.t52_orig_order_id, -- t52_orig_order_id | Update Later in this Script
                       t52_orderno = i.t52_orderno, --t52_orderno | Update Later in this Script
                       t52_customer_id_u01 = i.new_customer_id, -- t52_customer_id_u01
                       t52_trading_acc_id_u07 = i.new_trading_account_id, -- t52_trading_acc_id_u07
                       t52_trading_acntno_u07 = i.u07_exchange_account_no, -- t52_trading_acntno_u07
                       t52_cash_acc_id_u06 = i.u07_cash_account_id_u06, -- t52_cash_acc_id_u06
                       t52_channel_id_v29 = i.t52_channel, -- t52_channel_id_v29
                       t52_exchange_code_m01 = i.m20_exchange_code_m01, -- t52_exchange_code_m01
                       t52_symbol_code_m20 = i.m20_symbol_code, -- t52_symbol_code_m20
                       t52_ord_type_id_v06 = i.t52_ordertype, -- t52_ord_type_id_v06
                       t52_side = i.t52_side, -- t52_side
                       t52_quantity = i.t52_orderqty, -- t52_quantity
                       t52_price = i.t52_price, -- t52_price
                       t52_avgpx = i.t52_avgpx, -- t52_avgpx
                       t52_tif_id_v10 = i.t52_timeinforce, -- t52_tif_id_v10
                       t52_expiry_date = i.t52_expiretime, -- t52_expiry_date
                       t52_min_quantity = i.t52_minqty, -- t52_min_quantity
                       t52_maxfloor = i.t52_maxfloor, -- t52_maxfloor
                       t52_status_id_v30 = i.t52_ordstatus, -- t52_status_id_v30
                       t52_remarks = i.t52_remarks, -- t52_remarks
                       t52_value = i.t52_ordvalue, -- t52_value
                       t52_netvalue = i.t52_ordnetvalue, -- t52_netvalue
                       t52_netsettle = i.t52_netsettle, -- t52_netsettle
                       t52_issue_stl_rate = i.t52_issue_stl_rate, -- t52_issue_stl_rate
                       t52_cum_quantity = i.t52_cumqty, -- t52_cum_quantity
                       t52_leavesqty = i.t52_leavesqty, -- t52_leavesqty
                       t52_transacttime = i.transaction_time, -- t52_transacttime
                       t52_commission = i.t52_commission, -- t52_commission
                       t52_avgcost = i.t52_avgcost, -- t52_avgcost
                       t52_exg_commission = i.t52_exg_commission, -- t52_exg_commission
                       t52_instrument_type = i.v34_inst_code_v09, -- t52_instrument_type
                       t52_remote_clorderid = i.t52_remote_clorderid, -- t52_remote_clorderid
                       t52_remote_origclorderid = i.t52_remote_origclorderid, -- t52_remote_origclorderid
                       t52_remote_symbol = i.t52_remote_symbol, -- t52_remote_symbol
                       t52_remote_tag_22 = i.t52_remote_tag_22, -- t52_remote_tag_22
                       t52_remote_accountno = i.t52_remote_accountno, -- t52_remote_accountno
                       t52_fixmsgtype = i.t52_fixmsgtype, -- t52_fixmsgtype
                       t52_fix_ver = i.t52_fix_ver, -- t52_fix_ver
                       t52_tag_56 = i.t52_tag_56, -- t52_tag_56
                       t52_tag_50 = i.t52_tag_50, -- t52_tag_50
                       t52_tag_57 = i.t52_tag_57, -- t52_tag_57
                       t52_tag_18 = i.t52_tag_18, -- t52_tag_18
                       t52_tag_115 = i.t52_tag_115, -- t52_tag_115
                       t52_exec_broker_id_m26 = i.new_executing_broker_id, -- t52_exec_broker_id_m26
                       t52_custodian_id_m26 = i.new_executing_broker_id, -- t52_custodian_id_m26
                       t52_text = i.t52_reject_reason, -- t52_text
                       t52_last_updated_by = i.last_updated_by_new_id, -- t52_last_updated_by
                       t52_last_updated_date = i.last_updated_date, -- t52_last_updated_date
                       t52_cum_child_qty = i.t52_cum_child_qty, -- t52_cum_child_qty
                       t52_internall_order_status =
                           i.t52_internall_order_status, -- t52_internall_order_status
                       t52_desk_order_type = i.t52_ordertype, -- t52_desk_order_type
                       t52_approved_by = i.last_updated_by_new_id, -- t52_approved_by
                       t52_dealer_id_u17 = i.created_by_new_id, -- t52_dealer_id_u17
                       t52_institution_id_m02 = i.new_institute_id, -- t52_institution_id_m02
                       t52_symbol_id_m20 = i.m20_id, -- t52_symbol_id_m20
                       t52_exchange_id_m01 = i.m20_exchange_id_m01, -- t52_exchange_id_m01
                       t52_market_code_m29 = i.t52_market_code -- t52_market_code_m29
                 WHERE t52_order_id = i.new_desk_orders_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T52_DESK_ORDERS',
                                i.t52_order_id,
                                CASE
                                    WHEN i.new_desk_orders_id IS NULL
                                    THEN
                                        l_desk_order_id
                                    ELSE
                                        i.new_desk_orders_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_desk_orders_id IS NULL
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

COMMIT;

--  Updating Order No and  Orginal Order Id

MERGE INTO dfn_ntp.t52_desk_orders t52
     USING (SELECT t52.t52_order_id,
                   order_no.new_desk_orders_id AS desk_order_no,
                   orig_cl_ord_id.new_desk_orders_id AS orig_desk_order_id
              FROM dfn_ntp.t52_desk_orders t52,
                   t52_desk_orders_mappings order_no,
                   t52_desk_orders_mappings orig_cl_ord_id
             WHERE     t52.t52_orderno = order_no.old_desk_orders_id
                   AND t52.t52_orig_order_id =
                           orig_cl_ord_id.old_desk_orders_id(+)) t52_desk
        ON (t52.t52_order_id = t52_desk.t52_order_id)
WHEN MATCHED
THEN
    UPDATE SET
        t52.t52_orderno = t52_desk.desk_order_no,
        t52.t52_orig_order_id = NVL (t52_desk.orig_desk_order_id, -1);
/

COMMIT;