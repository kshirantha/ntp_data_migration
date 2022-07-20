DECLARE
    l_corp_action_customer_id   NUMBER;
    l_sqlerrm                   VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t41_id), 0)
      INTO l_corp_action_customer_id
      FROM dfn_ntp.t41_cust_corp_act_distribution;

    DELETE FROM error_log
          WHERE mig_table = 'T41_CUST_CORP_ACT_DISTRIBUTION';

    FOR i
        IN (SELECT m273.m273_id,
                   m141_map.new_cust_corp_action_id,
                   u07_map.new_trading_account_id,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by,
                   m273.m273_status_changed_date AS status_changed_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   m273.m273_net_holdings,
                   m273.m273_avg_cost,
                   u07.u07_customer_id_u01,
                   u07.u07_cash_account_id_u06,
                   m273.m273_net_holding_diff,
                   m273.m273_cash_diff_approve,
                   m02_map.new_institute_id,
                   m273.m273_drop_down, -- [SAME IDs]
                   t41_map.new_cus_corp_act_dist_id,
                   m141.m141_symbol_id_m20
              FROM mubasher_oms.m273_corporate_action_customer@mubasher_db_link m273,
                   mubasher_oms.m272_corporate_actions@mubasher_db_link m272,
                   m02_institute_mappings m02_map,
                   dfn_ntp.m141_cust_corporate_action m141,
                   dfn_ntp.u07_trading_account u07,
                   m141_cust_corp_action_mappings m141_map,
                   u07_trading_account_mappings u07_map,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_status_changed,
                   t41_cus_corp_act_dist_mappings t41_map
             WHERE     m273.m273_corporate_action = m272.m272_id
                   AND m272.m272_inst_id = m02_map.old_institute_id
                   AND m273.m273_corporate_action =
                           m141_map.old_cust_corp_action_id(+)
                   AND m141_map.new_cust_corp_action_id = m141.m141_id(+)
                   AND m273.m273_security_account =
                           u07_map.old_trading_account_id(+)
                   AND m141.m141_exchange_code_m01 = u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id = u07.u07_id(+)
                   AND m273.m273_status = map01.map01_oms_id
                   AND m273.m273_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m273.m273_id = t41_map.old_cus_corp_act_dist_id(+))
    LOOP
        BEGIN
            IF i.new_cust_corp_action_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Corporate Action Not Available',
                                         TRUE);
            END IF;

            IF i.m141_symbol_id_m20 IS NULL
            THEN
                raise_application_error (-20001,
                                         'Symbol Not Available',
                                         TRUE);
            END IF;

            IF i.new_trading_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Trading Account Not Available',
                                         TRUE);
            END IF;

            IF i.new_cus_corp_act_dist_id IS NULL
            THEN
                l_corp_action_customer_id := l_corp_action_customer_id + 1;

                INSERT
                  INTO dfn_ntp.t41_cust_corp_act_distribution (
                           t41_id,
                           t41_cust_corp_act_id_m141,
                           t41_trading_acc_id_u07,
                           t41_status_id_v01,
                           t41_status_changed_by_id_u17,
                           t41_status_changed_date,
                           t41_hold_on_rec_date,
                           t41_avg_cost_on_ex_date,
                           t41_is_notified,
                           t41_reinvest,
                           t41_customer_id_u01,
                           t41_cash_acc_id_u06,
                           t41_created_by_id_u17,
                           t41_created_date,
                           t41_modified_by_id_u17,
                           t41_modified_date,
                           t41_pending_adjustment,
                           t41_custom_type,
                           t41_institute_id_m02)
                VALUES (l_corp_action_customer_id, -- t41_id
                        i.new_cust_corp_action_id, -- t41_cust_corp_act_id_m141
                        i.new_trading_account_id, -- t41_trading_acc_id_u07
                        i.map01_ntp_id, -- t41_status_id_v01
                        i.status_changed_by, -- t41_status_changed_by_id_u17
                        i.status_changed_date, -- t41_status_changed_date
                        i.m273_net_holdings, -- t41_hold_on_rec_date
                        i.m273_avg_cost, -- t41_avg_cost_on_ex_date
                        NULL, -- t41_is_notified | Not Available
                        i.m273_drop_down, -- t41_reinvest
                        i.u07_customer_id_u01, -- t41_customer_id_u01
                        i.u07_cash_account_id_u06, -- t41_cash_acc_id_u06
                        i.status_changed_by, -- t41_created_by_id_u17
                        i.status_changed_date, -- t41_created_date
                        NULL, -- t41_modified_by_id_u17
                        NULL, -- t41_modified_date
                        0, -- t41_pending_adjustment | Not Available
                        '1', -- t41_custom_type
                        i.new_institute_id -- t41_institute_id_m02
                                          );

                INSERT
                  INTO t41_cus_corp_act_dist_mappings (
                           old_cus_corp_act_dist_id,
                           new_cus_corp_act_dist_id)
                VALUES (i.m273_id, l_corp_action_customer_id);
            ELSE
                UPDATE dfn_ntp.t41_cust_corp_act_distribution
                   SET t41_cust_corp_act_id_m141 = i.new_cust_corp_action_id, -- t41_cust_corp_act_id_m141
                       t41_trading_acc_id_u07 = i.new_trading_account_id, -- t41_trading_acc_id_u07
                       t41_status_id_v01 = i.map01_ntp_id, -- t41_status_id_v01
                       t41_status_changed_by_id_u17 = i.status_changed_by, -- t41_status_changed_by_id_u17
                       t41_status_changed_date = i.status_changed_date, -- t41_status_changed_date
                       t41_hold_on_rec_date = i.m273_net_holdings, -- t41_hold_on_rec_date
                       t41_avg_cost_on_ex_date = i.m273_avg_cost, -- t41_avg_cost_on_ex_date
                       t41_reinvest = i.m273_drop_down, -- t41_reinvest
                       t41_customer_id_u01 = i.u07_customer_id_u01, -- t41_customer_id_u01
                       t41_cash_acc_id_u06 = i.u07_cash_account_id_u06, -- t41_cash_acc_id_u06
                       t41_institute_id_m02 = i.new_institute_id -- t41_institute_id_m02
                 WHERE t41_id = i.new_cus_corp_act_dist_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T41_CUST_CORP_ACT_DISTRIBUTION',
                                i.m273_id,
                                CASE
                                    WHEN i.new_cus_corp_act_dist_id IS NULL
                                    THEN
                                        l_corp_action_customer_id
                                    ELSE
                                        i.new_cus_corp_act_dist_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cus_corp_act_dist_id IS NULL
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
