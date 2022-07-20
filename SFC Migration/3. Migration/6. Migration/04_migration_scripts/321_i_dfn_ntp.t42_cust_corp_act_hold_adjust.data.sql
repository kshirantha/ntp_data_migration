DECLARE
    l_cust_ca_hold_adjust_id   NUMBER;
    l_sqlerrm                  VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t42_id), 0)
      INTO l_cust_ca_hold_adjust_id
      FROM dfn_ntp.t42_cust_corp_act_hold_adjust;

    DELETE FROM error_log
          WHERE mig_table = 'T42_CUST_CORP_ACT_HOLD_ADJUST';

    FOR i
        IN (SELECT m273.m273_id,
                   t41_map.new_cus_corp_act_dist_id,
                   u07_map.new_trading_account_id,
                   m141.m141_exchange_id_m01,
                   m141.m141_exchange_code_m01,
                   m141.m141_symbol_id_m20,
                   m141.m141_symbol_code_m20,
                   m141.m141_narration,
                   m273.m273_net_holdings,
                   m273.m273_avg_cost,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by,
                   m273.m273_status_changed_date AS status_changed_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   u07.u07_custodian_id_m26,
                   m141_map.new_cust_corp_action_id,
                   m02_map.new_institute_id,
                   t42_map.new_cust_ca_hold_adj_id
              FROM mubasher_oms.m273_corporate_action_customer@mubasher_db_link m273,
                   mubasher_oms.m272_corporate_actions@mubasher_db_link m272,
                   m02_institute_mappings m02_map,
                   dfn_ntp.u07_trading_account u07,
                   m141_cust_corp_action_mappings m141_map,
                   dfn_ntp.m141_cust_corporate_action m141,
                   u07_trading_account_mappings u07_map,
                   t41_cus_corp_act_dist_mappings t41_map,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_status_changed,
                   t42_cust_ca_hold_adj_mappings t42_map
             WHERE     m273.m273_corporate_action = m272.m272_id
                   AND m272.m272_inst_id = m02_map.old_institute_id
                   AND m273.m273_corporate_action =
                           m141_map.old_cust_corp_action_id(+)
                   AND m141_map.new_cust_corp_action_id = m141.m141_id(+)
                   AND m273.m273_security_account =
                           u07_map.old_trading_account_id(+)
                   AND m141.m141_exchange_code_m01 = u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id = u07.u07_id(+)
                   AND m273.m273_id = t41_map.old_cus_corp_act_dist_id(+)
                   AND m273.m273_status = map01.map01_oms_id
                   AND m273.m273_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m273.m273_id = t42_map.old_cust_ca_hold_adj_id(+))
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
                                         'Security Account Not Available',
                                         TRUE);
            END IF;

            IF i.new_cust_ca_hold_adj_id IS NULL
            THEN
                l_cust_ca_hold_adjust_id := l_cust_ca_hold_adjust_id + 1;

                INSERT
                  INTO dfn_ntp.t42_cust_corp_act_hold_adjust (
                           t42_id,
                           t42_cust_distr_id_t41,
                           t42_corp_act_adj_id_m142,
                           t42_trading_acc_id_u07,
                           t42_adj_mode,
                           t42_exchange_id_m01,
                           t42_exchange_code_m01,
                           t42_symbol_id_m20,
                           t42_symbol_code_m20,
                           t42_from_ratio,
                           t42_to_ratio,
                           t42_eligible_quantity,
                           t42_approved_quantity,
                           t42_avg_cost,
                           t42_narration,
                           t42_status_id_v01,
                           t42_status_changed_by_id_u17,
                           t42_status_changed_date,
                           t42_custodian_id_m26,
                           t42_created_by_id_u17,
                           t42_created_date,
                           t42_modified_by_id_u17,
                           t42_modified_date,
                           t42_cust_corp_act_id_m141,
                           t42_custom_type,
                           t42_institute_id_m02,
                           t42_reject_reason)
                VALUES (l_cust_ca_hold_adjust_id, -- t42_id
                        i.new_cus_corp_act_dist_id, -- t42_cust_distr_id_t41
                        -1, -- t42_corp_act_adj_id_m142 | Not Available
                        i.new_trading_account_id, -- t42_trading_acc_id_u07
                        NULL, -- t42_adj_mode | Not Available
                        i.m141_exchange_id_m01, -- t42_exchange_id_m01
                        i.m141_exchange_code_m01, -- t42_exchange_code_m01
                        i.m141_symbol_id_m20, -- t42_symbol_id_m20
                        i.m141_symbol_code_m20, -- t42_symbol_code_m20
                        NULL, -- t42_from_ratio | Not Available
                        NULL, -- t42_to_ratio | Not Available
                        i.m273_net_holdings, -- t42_eligible_quantity
                        i.m273_net_holdings, -- t42_approved_quantity | Not Availble
                        i.m273_avg_cost, -- t42_avg_cost
                        i.m141_narration, -- t42_narration
                        i.map01_ntp_id, -- t42_status_id_v01
                        i.status_changed_by, -- t42_status_changed_by_id_u17
                        i.status_changed_date, -- t42_status_changed_date
                        i.u07_custodian_id_m26, -- t42_custodian_id_m26
                        i.status_changed_by, -- t42_created_by_id_u17 | Not Available
                        i.status_changed_date, -- t42_created_date | Not Available
                        NULL, -- t42_modified_by_id_u17
                        NULL, -- t42_modified_date
                        i.new_cust_corp_action_id, -- t42_cust_corp_act_id_m141
                        '1', -- t42_custom_type
                        i.new_institute_id, -- t42_institute_id_m02
                        NULL -- t42_reject_reason | Not Available
                            );

                INSERT
                  INTO t42_cust_ca_hold_adj_mappings (old_cust_ca_hold_adj_id,
                                                      new_cust_ca_hold_adj_id)
                VALUES (i.m273_id, l_cust_ca_hold_adjust_id);
            ELSE
                UPDATE dfn_ntp.t42_cust_corp_act_hold_adjust
                   SET t42_cust_distr_id_t41 = i.new_cus_corp_act_dist_id, -- t42_cust_distr_id_t41
                       t42_trading_acc_id_u07 = i.new_trading_account_id, -- t42_trading_acc_id_u07
                       t42_exchange_id_m01 = i.m141_exchange_id_m01, -- t42_exchange_id_m01
                       t42_exchange_code_m01 = i.m141_exchange_code_m01, -- t42_exchange_code_m01
                       t42_symbol_id_m20 = i.m141_symbol_id_m20, -- t42_symbol_id_m20
                       t42_symbol_code_m20 = i.m141_symbol_code_m20, -- t42_symbol_code_m20
                       t42_eligible_quantity = i.m273_net_holdings, -- t42_eligible_quantity
                       t42_approved_quantity = i.m273_net_holdings, -- t42_approved_quantity | Not Availble
                       t42_avg_cost = i.m273_avg_cost, -- t42_avg_cost
                       t42_narration = i.m141_narration, -- t42_narration
                       t42_status_id_v01 = i.map01_ntp_id, -- t42_status_id_v01
                       t42_status_changed_by_id_u17 = i.status_changed_by, -- t42_status_changed_by_id_u17
                       t42_status_changed_date = i.status_changed_date, -- t42_status_changed_date
                       t42_custodian_id_m26 = i.u07_custodian_id_m26, -- t42_custodian_id_m26
                       t42_cust_corp_act_id_m141 = i.new_cust_corp_action_id, -- t42_cust_corp_act_id_m141
                       t42_institute_id_m02 = i.new_institute_id -- t42_institute_id_m02
                 WHERE t42_id = i.new_cust_ca_hold_adj_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T42_CUST_CORP_ACT_HOLD_ADJUST',
                                i.m273_id,
                                CASE
                                    WHEN i.new_cust_ca_hold_adj_id IS NULL
                                    THEN
                                        l_cust_ca_hold_adjust_id
                                    ELSE
                                        i.new_cust_ca_hold_adj_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cust_ca_hold_adj_id IS NULL
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
