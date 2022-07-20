DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_ord_cancel_req_id      NUMBER;
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

    SELECT NVL (MAX (t53_id), 0)
      INTO l_ord_cancel_req_id
      FROM dfn_ntp.t53_order_canceled_requests;

    DELETE FROM error_log
          WHERE mig_table = 'T53_ORDER_CANCELED_REQUESTS';

    FOR i
        IN (SELECT t07_id,
                   u07_map.new_trading_account_id,
                   m20.m20_exchange_code_m01,
                   m20.m20_symbol_code,
                   t07_side, -- [SAME IDs]
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   t07.t07_created_date AS created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   map01.map01_ntp_id,
                   NVL (u17_approved.new_employee_id, 0)
                       AS approved_by_new_id,
                   t07_approved_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   NVL (u17_rejected.new_employee_id, 0)
                       AS rejected_by_new_id,
                   t07_rejected_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   m20_id,
                   t53_map.new_order_cancel_req_id
              FROM mubasher_oms.t07_order_canceled_requests@mubasher_db_link t07,
                   u07_trading_account_mappings u07_map,
                   map01_approval_status_v01 map01,
                   dfn_ntp.m20_symbol m20,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_approved,
                   u17_employee_mappings u17_rejected,
                   t53_order_cancel_req_mappings t53_map
             WHERE     TO_NUMBER (
                           REGEXP_REPLACE (t07.t07_security_acc_no,
                                           'S0{0,8}',
                                           '')) =
                           u07_map.old_trading_account_id
                   AND t07.t07_status_id = map01.map01_oms_id
                   AND t07.t07_symbol = m20.m20_symbol_code -- Need to Join with Exchange and Use Map16 Table in GBL Solution
                   AND m20.m20_institute_id_m02 = l_primary_institute_id
                   AND t07.t07_created_by = u17_created.old_employee_id(+)
                   AND t07.t07_approved_by = u17_approved.old_employee_id(+)
                   AND t07.t07_rejected_by = u17_rejected.old_employee_id(+)
                   AND t07.t07_id = t53_map.old_order_cancel_req_id(+))
    LOOP
        BEGIN
            IF i.new_order_cancel_req_id IS NULL
            THEN
                l_ord_cancel_req_id := l_ord_cancel_req_id + 1;

                INSERT INTO t53_order_cancel_req_mappings
                     VALUES (i.t07_id, l_ord_cancel_req_id);

                INSERT
                  INTO dfn_ntp.t53_order_canceled_requests (
                           t53_id,
                           t53_security_acc_no,
                           t53_exchange,
                           t53_symbol,
                           t53_side,
                           t53_created_by,
                           t53_created_date,
                           t53_status_id,
                           t53_approved_by,
                           t53_approved_date,
                           t53_rejected_by,
                           t53_rejected_date,
                           t53_symbol_id_m20)
                VALUES (l_ord_cancel_req_id, --t05_id
                        i.new_trading_account_id, -- t53_security_acc_no
                        i.m20_exchange_code_m01, -- t53_exchange
                        i.m20_symbol_code, -- t53_symbol
                        i.t07_side, -- t53_side
                        i.created_by_new_id, -- t53_created_by
                        i.created_date, -- t53_created_date
                        i.map01_ntp_id, -- t53_status_id
                        i.approved_by_new_id, -- t53_approved_by
                        i.t07_approved_date, -- t53_approved_date
                        i.rejected_by_new_id, -- t53_rejected_by
                        i.t07_rejected_date, -- t53_rejected_date
                        i.m20_id -- t53_symbol_id_m20
                                );
            ELSE
                UPDATE dfn_ntp.t53_order_canceled_requests
                   SET t53_security_acc_no = i.new_trading_account_id, -- t53_security_acc_no
                       t53_exchange = i.m20_exchange_code_m01, -- t53_exchange
                       t53_symbol = i.m20_symbol_code, -- t53_symbol
                       t53_side = i.t07_side, -- t53_side
                       t53_status_id = i.map01_ntp_id, -- t53_status_id
                       t53_approved_by = i.approved_by_new_id, -- t53_approved_by
                       t53_approved_date = i.t07_approved_date, -- t53_approved_date
                       t53_rejected_by = i.rejected_by_new_id, -- t53_rejected_by
                       t53_rejected_date = i.t07_rejected_date, -- t53_rejected_date
                       t53_symbol_id_m20 = i.m20_id -- t53_symbol_id_m20
                 WHERE t53_id = i.new_order_cancel_req_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T53_ORDER_CANCELED_REQUESTS',
                                i.t07_id,
                                CASE
                                    WHEN i.new_order_cancel_req_id IS NULL
                                    THEN
                                        l_ord_cancel_req_id
                                    ELSE
                                        i.new_order_cancel_req_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_order_cancel_req_id IS NULL
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
