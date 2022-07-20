DECLARE
    l_cust_ca_cash_adjust_id   NUMBER;
    l_sqlerrm                  VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t43_id), 0)
      INTO l_cust_ca_cash_adjust_id
      FROM dfn_ntp.t43_cust_corp_act_cash_adjust;

    DELETE FROM error_log
          WHERE mig_table = 'T43_CUST_CORP_ACT_CASH_ADJUST';

    FOR i
        IN (SELECT m273.m273_id,
                   t41_map.new_cus_corp_act_dist_id,
                   u07.u07_cash_account_id_u06,
                   m273.m273_cash_diff_approve,
                   m273.m273_fx_rate,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by,
                   m273.m273_status_changed_date AS status_changed_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   m141.m141_narration,
                   m141_map.new_cust_corp_action_id,
                   m02_map.new_institute_id,
                   t43_map.new_cust_ca_cash_adj_id,
                   m141.m141_symbol_id_m20
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
                   t43_cust_ca_cash_adj_mappings t43_map
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
                   AND m273.m273_id = t43_map.old_cust_ca_cash_adj_id(+))
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

            IF i.u07_cash_account_id_u06 IS NULL
            THEN
                raise_application_error (-20001,
                                         'Security Account Not Available',
                                         TRUE);
            END IF;

            IF i.new_cust_ca_cash_adj_id IS NULL
            THEN
                l_cust_ca_cash_adjust_id := l_cust_ca_cash_adjust_id + 1;

                INSERT
                  INTO dfn_ntp.t43_cust_corp_act_cash_adjust (
                           t43_id,
                           t43_cust_distr_id_t41,
                           t43_corp_act_adj_id_m143,
                           t43_cash_account_id_u06,
                           t43_adj_mode,
                           t43_amnt_in_txn_currency,
                           t43_fx_rate,
                           t43_amnt_in_stl_currency,
                           t43_status_id_v01,
                           t43_status_changed_by_id_u17,
                           t43_status_changed_date,
                           t43_narration,
                           t43_created_by_id_u17,
                           t43_created_date,
                           t43_modified_by_id_u17,
                           t43_modified_date,
                           t43_cust_corp_act_id_m141,
                           t43_tax_amount,
                           t43_custom_type,
                           t43_institute_id_m02,
                           t43_reject_reason)
                VALUES (l_cust_ca_cash_adjust_id, -- t43_id
                        i.new_cus_corp_act_dist_id, -- t43_cust_distr_id_t41
                        -1, -- t43_corp_act_adj_id_m143 | Not Available
                        i.u07_cash_account_id_u06, -- t43_cash_account_id_u06
                        NULL, -- t43_adj_mode | Not Available
                        i.m273_cash_diff_approve, -- t43_amnt_in_txn_currency
                        i.m273_fx_rate, -- t43_fx_rate
                        i.m273_cash_diff_approve, -- t43_amnt_in_stl_currency
                        i.map01_ntp_id, -- t43_status_id_v01
                        i.status_changed_by, -- t43_status_changed_by_id_u17
                        i.status_changed_date, -- t43_status_changed_date
                        i.m141_narration, -- t43_narration
                        i.status_changed_by, -- t43_created_by_id_u17
                        i.status_changed_date, -- t43_created_date
                        NULL, -- t43_modified_by_id_u17
                        NULL, -- t43_modified_date
                        i.new_cust_corp_action_id, -- t43_cust_corp_act_id_m141
                        NULL, -- t43_tax_amount | Not Available
                        '1', -- t43_custom_type
                        i.new_institute_id, -- t43_institute_id_m02
                        NULL -- t43_reject_reason | Not Available
                            );

                INSERT
                  INTO t43_cust_ca_cash_adj_mappings (old_cust_ca_cash_adj_id,
                                                      new_cust_ca_cash_adj_id)
                VALUES (i.m273_id, l_cust_ca_cash_adjust_id);
            ELSE
                UPDATE dfn_ntp.t43_cust_corp_act_cash_adjust
                   SET t43_cust_distr_id_t41 = i.new_cus_corp_act_dist_id, -- t43_cust_distr_id_t41
                       t43_cash_account_id_u06 = i.u07_cash_account_id_u06, -- t43_cash_account_id_u06
                       t43_amnt_in_txn_currency = i.m273_cash_diff_approve, -- t43_amnt_in_txn_currency
                       t43_fx_rate = i.m273_fx_rate, -- t43_fx_rate
                       t43_amnt_in_stl_currency = i.m273_cash_diff_approve, -- t43_amnt_in_stl_currency
                       t43_status_id_v01 = i.map01_ntp_id, -- t43_status_id_v01
                       t43_status_changed_by_id_u17 = i.status_changed_by, -- t43_status_changed_by_id_u17
                       t43_status_changed_date = i.status_changed_date, -- t43_status_changed_date
                       t43_narration = i.m141_narration, -- t43_narration
                       t43_created_by_id_u17 = i.status_changed_by, -- t43_created_by_id_u17
                       t43_created_date = i.status_changed_date, -- t43_created_date
                       t43_cust_corp_act_id_m141 = i.new_cust_corp_action_id, -- t43_cust_corp_act_id_m141
                       t43_institute_id_m02 = i.new_institute_id -- t43_institute_id_m02
                 WHERE t43_id = i.new_cust_ca_cash_adj_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T43_CUST_CORP_ACT_CASH_ADJUST',
                                i.m273_id,
                                CASE
                                    WHEN i.new_cust_ca_cash_adj_id IS NULL
                                    THEN
                                        l_cust_ca_cash_adjust_id
                                    ELSE
                                        i.new_cust_ca_cash_adj_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cust_ca_cash_adj_id IS NULL
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
