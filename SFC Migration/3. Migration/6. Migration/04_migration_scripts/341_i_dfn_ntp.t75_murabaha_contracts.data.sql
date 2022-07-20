DECLARE
    l_murabaha_id   NUMBER;
    l_sqlerrm       VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t75_id), 0)
      INTO l_murabaha_id
      FROM dfn_ntp.t75_murabaha_contracts;

    DELETE FROM error_log
          WHERE mig_table = 'T75_MURABAHA_CONTRACTS';

    FOR i
        IN (SELECT t85.t85_id,
                   t85.t85_contract_no,
                   t85.t85_loan_amount,
                   u07_map_cust.new_trading_account_id
                       AS customer_trading_acc_id,
                   u07_cust.u07_cash_account_id_u06 AS customer_cash_ac_id,
                   u07_cust.u07_institute_id_m02,
                   u07_cust.u07_customer_id_u01,
                   u06_cust.u06_currency_code_m03,
                   u07_map_agent.new_trading_account_id
                       AS agent_trading_acc_id,
                   m181_map.new_murabaha_basket_id,
                   t85.t85_auto_sell,
                   t85.t85_profit_percentage,
                   t85.t85_fund_by_client,
                   t85.t85_profit_amount,
                   t85.t85_loan_utilization,
                   NVL (u17_created.new_employee_id, 0) AS created_by,
                   t85.t85_created_date AS created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   u17_modified.new_employee_id AS modified_by,
                   t85.t85_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by,
                   t85.t85_status_changed_date AS status_changed_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   t85.t85_brokerage_agent_account,
                   t85.t85_expiry_date,
                   t85.t85_profit_as_percentage,
                   t85.t85_actual_profit_amount,
                   t85.t85_amortized_profit_amount,
                   t85.t85_close_status,
                   t75_map.new_murabaha_contract_id,
                   CASE
                       WHEN map01.map01_ntp_id = 101 THEN 1
                       WHEN map01.map01_ntp_id = 1 THEN 0
                       ELSE 2
                   END
                       AS current_approval_level,
                   CASE
                       WHEN map01.map01_ntp_id = 3 THEN 3
                       WHEN map01.map01_ntp_id = 5 THEN 5
                       WHEN map01.map01_ntp_id = 101 THEN 102
                       WHEN map01.map01_ntp_id = 1 THEN 101
                       ELSE 2
                   END
                       AS next_status,
                   CASE WHEN map01.map01_ntp_id IN (1, 101) THEN 0 ELSE 1 END
                       AS is_approval_completed
              FROM mubasher_oms.t85_murabaha_contracts@mubasher_db_link t85,
                   dfn_ntp.u07_trading_account u07_cust,
                   dfn_ntp.u06_cash_account u06_cust,
                   (SELECT *
                      FROM u07_trading_account_mappings
                     WHERE exchange_code = 'TDWL') u07_map_cust, -- Murabaha Contracts Does Not Have Exchange Details [Discussed]
                   (SELECT *
                      FROM u07_trading_account_mappings
                     WHERE exchange_code = 'TDWL') u07_map_agent, -- Murabaha Contracts Does Not Have Exchange Details [Discussed]
                   m181_murabaha_baskets_mappings m181_map,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   t75_murabaha_contract_mappings t75_map
             WHERE     t85.t85_customer_security_ac_id =
                           u07_map_cust.old_trading_account_id(+)
                   AND u07_map_cust.new_trading_account_id =
                           u07_cust.u07_id(+)
                   AND u07_cust.u07_cash_account_id_u06 = u06_cust.u06_id(+)
                   AND t85.t85_agent_security_ac_id =
                           u07_map_agent.old_trading_account_id(+)
                   AND t85.t85_basket_id = m181_map.old_murabaha_basket_id(+)
                   AND u07_cust.u07_institute_id_m02 =
                           m181_map.new_institute_id(+)
                   AND t85.t85_status_id = map01.map01_oms_id
                   AND t85.t85_created_by = u17_created.old_employee_id(+)
                   AND t85.t85_modified_by = u17_modified.old_employee_id(+)
                   AND t85.t85_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND t85.t85_id = t75_map.old_murabaha_contract_id(+))
    LOOP
        BEGIN
            IF i.agent_trading_acc_id IS NULL
            THEN
                raise_application_error (
                    -20001,
                    'Agent Trading Account Not Available',
                    TRUE);
            END IF;

            IF i.new_murabaha_basket_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Murabaha Basket Not Available',
                                         TRUE);
            END IF;

            IF i.new_murabaha_contract_id IS NULL
            THEN
                l_murabaha_id := l_murabaha_id + 1;

                INSERT
                  INTO dfn_ntp.t75_murabaha_contracts (
                           t75_id,
                           t75_contract_no,
                           t75_loan_amount,
                           t75_customer_cash_ac_id_u06,
                           t75_agent_trading_ac_id_u07,
                           t75_basket_id_m181,
                           t75_auto_sell,
                           t75_profit_percentage,
                           t75_fund_by_client,
                           t75_profit_amount,
                           t75_loan_utilization,
                           t75_created_by_id_u17,
                           t75_created_date,
                           t75_modified_by_id_u17,
                           t75_modified_date,
                           t75_status_id_v01,
                           t75_status_changed_by_id_u17,
                           t75_status_changed_date,
                           t75_brokerage_agent_account,
                           t75_expiry_date,
                           t75_profit_as_percentage,
                           t75_actual_profit_amount,
                           t75_amortized_profit_amount,
                           t75_close_status,
                           t75_customer_trdng_ac_id_u07,
                           t75_current_approval_level,
                           t75_next_status,
                           t75_no_of_approval,
                           t75_comment,
                           t75_is_approval_completed,
                           t75_custom_type,
                           t75_currency_code_m03,
                           t75_institution_id_m02,
                           t75_stp_exg_fee,
                           t75_stp_brk_fee,
                           t75_stp_exg_vat,
                           t75_stp_brk_vat,
                           t75_cshtrn_brk_fee,
                           t75_cshtrn_brk_vat,
                           t75_customer_id_u01,
                           t75_cust_mrgin_trdng_id_u23)
                VALUES (l_murabaha_id, -- t75_id
                        i.t85_contract_no, -- t75_contract_no
                        i.t85_loan_amount, -- t75_loan_amount
                        i.customer_cash_ac_id, -- t75_customer_cash_ac_id_u06
                        i.agent_trading_acc_id, -- t75_agent_trading_ac_id_u07
                        i.new_murabaha_basket_id, -- t75_basket_id_m181
                        i.t85_auto_sell, -- t75_auto_sell
                        i.t85_profit_percentage, -- t75_profit_percentage
                        i.t85_fund_by_client, -- t75_fund_by_client
                        i.t85_profit_amount, -- t75_profit_amount
                        i.t85_loan_utilization, -- t75_loan_utilization
                        i.created_by, -- t75_created_by_id_u17
                        i.created_date, -- t75_created_date
                        i.modified_by, -- t75_modified_by_id_u17
                        i.modified_date, -- t75_modified_date
                        i.map01_ntp_id, -- t75_status_id_v01
                        i.status_changed_by, -- t75_status_changed_by_id_u17
                        i.status_changed_date, -- t75_status_changed_date
                        i.t85_brokerage_agent_account, -- t75_brokerage_agent_account
                        i.t85_expiry_date, -- t75_expiry_date
                        i.t85_profit_as_percentage, -- t75_profit_as_percentage
                        i.t85_actual_profit_amount, -- t75_actual_profit_amount
                        i.t85_amortized_profit_amount, -- t75_amortized_profit_amount
                        i.t85_close_status, -- t75_close_status
                        i.customer_trading_acc_id, -- t75_customer_trdng_ac_id_u07
                        i.current_approval_level, -- t75_current_approval_level
                        i.next_status, -- t75_next_status
                        2, -- t75_no_of_approval
                        NULL, -- t75_comment | Not Available
                        i.is_approval_completed, -- t75_is_approval_completed
                        '1', -- t75_custom_type | Not Available
                        i.u06_currency_code_m03, -- t75_currency_code_m03
                        i.u07_institute_id_m02, -- t75_institution_id_m02
                        NULL, -- t75_stp_exg_fee | Not Available
                        NULL, -- t75_stp_brk_fee | Not Available
                        NULL, -- t75_stp_exg_vat | Not Available
                        NULL, -- t75_stp_brk_vat | Not Available
                        NULL, -- t75_cshtrn_brk_fee | Not Available
                        NULL, -- t75_cshtrn_brk_vat | Not Available
                        i.u07_customer_id_u01, -- t75_customer_id_u01
                        NULL -- t75_cust_mrgin_trdng_id_u23 | Not Available
                            );

                INSERT
                  INTO t75_murabaha_contract_mappings (
                           old_murabaha_contract_id,
                           new_murabaha_contract_id)
                VALUES (i.t85_id, l_murabaha_id);
            ELSE
                UPDATE dfn_ntp.t75_murabaha_contracts
                   SET t75_contract_no = i.t85_contract_no, -- t75_contract_no
                       t75_loan_amount = i.t85_loan_amount, -- t75_loan_amount
                       t75_customer_cash_ac_id_u06 = i.customer_cash_ac_id, -- t75_customer_cash_ac_id_u06
                       t75_agent_trading_ac_id_u07 = i.agent_trading_acc_id, -- t75_agent_trading_ac_id_u07
                       t75_basket_id_m181 = i.new_murabaha_basket_id, -- t75_basket_id_m181
                       t75_auto_sell = i.t85_auto_sell, -- t75_auto_sell
                       t75_profit_percentage = i.t85_profit_percentage, -- t75_profit_percentage
                       t75_fund_by_client = i.t85_fund_by_client, -- t75_fund_by_client
                       t75_profit_amount = i.t85_profit_amount, -- t75_profit_amount
                       t75_loan_utilization = i.t85_loan_utilization, -- t75_loan_utilization
                       t75_modified_by_id_u17 = NVL (i.modified_by, 0), -- t75_modified_by_id_u17
                       t75_modified_date = i.modified_date, -- t75_modified_date
                       t75_status_id_v01 = i.map01_ntp_id, -- t75_status_id_v01
                       t75_status_changed_by_id_u17 = i.status_changed_by, -- t75_status_changed_by_id_u17
                       t75_status_changed_date = i.status_changed_date, -- t75_status_changed_date
                       t75_brokerage_agent_account =
                           i.t85_brokerage_agent_account, -- t75_brokerage_agent_account
                       t75_expiry_date = i.t85_expiry_date, -- t75_expiry_date
                       t75_profit_as_percentage = i.t85_profit_as_percentage, -- t75_profit_as_percentage
                       t75_actual_profit_amount = i.t85_actual_profit_amount, -- t75_actual_profit_amount
                       t75_amortized_profit_amount =
                           i.t85_amortized_profit_amount, -- t75_amortized_profit_amount
                       t75_close_status = i.t85_close_status, -- t75_close_status
                       t75_customer_trdng_ac_id_u07 =
                           i.customer_trading_acc_id, -- t75_customer_trdng_ac_id_u07
                       t75_current_approval_level = i.current_approval_level, -- t75_current_approval_level
                       t75_next_status = i.next_status, -- t75_next_status
                       t75_is_approval_completed = i.is_approval_completed, -- t75_is_approval_completed
                       t75_currency_code_m03 = i.u06_currency_code_m03, -- t75_currency_code_m03
                       t75_institution_id_m02 = i.u07_institute_id_m02, -- t75_institution_id_m02
                       t75_customer_id_u01 = i.u07_customer_id_u01 -- t75_customer_id_u01
                 WHERE t75_id = i.new_murabaha_contract_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T75_MURABAHA_CONTRACTS',
                                i.t85_id,
                                CASE
                                    WHEN i.new_murabaha_contract_id IS NULL
                                    THEN
                                        l_murabaha_id
                                    ELSE
                                        i.new_murabaha_contract_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_murabaha_contract_id IS NULL
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

-- Generating Murabaha Contact Compositions Based on Contracts and Basket Compositions

DECLARE
    l_contracts_composition_id   NUMBER;
    l_sqlerrm                    VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t76_id), 0)
      INTO l_contracts_composition_id
      FROM dfn_ntp.t76_murabaha_contract_comp;

    DELETE FROM error_log
          WHERE mig_table = 'T76_MURABAHA_CONTRACT_COMP';

    FOR i
        IN (SELECT t75.t75_id,
                   m182.m182_id,
                   m182.m182_exchange_id_m01,
                   m182.m182_symbol_code_m20,
                   m182.m182_percentage,
                   m182.m182_allowed_change,
                   m182.m182_created_by_id_u17,
                   m182.m182_created_date,
                   m182.m182_modified_by_id_u17,
                   m182.m182_modified_date,
                   m182.m182_status_id_v01,
                   m182.m182_symbol_id_m20,
                   m01.m01_exchange_code,
                   t76.t76_id
              FROM dfn_ntp.t75_murabaha_contracts t75,
                   dfn_ntp.m182_murabaha_bskt_composition m182,
                   dfn_ntp.m01_exchanges m01,
                   dfn_ntp.t76_murabaha_contract_comp t76
             WHERE     t75.t75_basket_id_m181 = m182.m182_basket_id_m181
                   AND m182.m182_exchange_id_m01 = m01.m01_id
                   AND t75.t75_id = t76.t76_contract_id_t75(+)
                   AND m182.m182_exchange_id_m01 = t76.t76_exchange_id_m01(+)
                   AND m182.m182_symbol_id_m20 = t76.t76_symbol_id_m20(+))
    LOOP
        BEGIN
            IF i.t76_id IS NULL
            THEN
                l_contracts_composition_id := l_contracts_composition_id + 1;

                INSERT
                  INTO dfn_ntp.t76_murabaha_contract_comp (
                           t76_id,
                           t76_contract_id_t75,
                           t76_exchange_id_m01,
                           t76_symbol_code_m20,
                           t76_percentage,
                           t76_allowed_change,
                           t76_created_by_id_u17,
                           t76_created_date,
                           t76_modified_by_id_u17,
                           t76_modified_date,
                           t76_status_id_v01,
                           t76_custom_type,
                           t76_symbol_id_m20,
                           t76_exchange_code_m01,
                           t76_exp_buy_order_value,
                           t76_rem_buy_order_value,
                           t76_buy_order_status_v30,
                           t76_cum_buy_order_value,
                           t76_cum_buy_order_qty,
                           t76_buy_pending_qty,
                           t76_average_cost,
                           t76_cum_commission,
                           t76_total_charges,
                           t76_sell_order_status_v30,
                           t76_custodian_id_m26)
                VALUES (l_contracts_composition_id, -- t76_id
                        i.t75_id, -- t76_contract_id_t75
                        i.m182_exchange_id_m01, -- t76_exchange_id_m01
                        i.m182_symbol_code_m20, -- t76_symbol_code_m20
                        i.m182_percentage, -- t76_percentage
                        i.m182_allowed_change, -- t76_allowed_change
                        i.m182_created_by_id_u17, -- t76_created_by_id_u17
                        i.m182_created_date, -- t76_created_date
                        i.m182_modified_by_id_u17, -- t76_modified_by_id_u17
                        i.m182_modified_date, -- t76_modified_date
                        i.m182_status_id_v01, -- t76_status_id_v01
                        '1', -- t76_custom_type
                        i.m182_symbol_id_m20, -- t76_symbol_id_m20
                        i.m01_exchange_code, -- t76_exchange_code_m01
                        NULL, -- t76_exp_buy_order_value | Not Available
                        NULL, -- t76_rem_buy_order_value | Not Available
                        NULL, -- t76_buy_order_status_v30 | Not Available
                        NULL, -- t76_cum_buy_order_value | Not Available
                        NULL, -- t76_cum_buy_order_qty | Not Available
                        0, -- t76_buy_pending_qty | Not Available
                        0, -- t76_average_cost | Not Available
                        0, -- t76_cum_commission | Not Available
                        NULL, -- t76_total_charges | Not Available
                        'X', -- t76_sell_order_status_v30 | Not Available
                        NULL -- t76_custodian_id_m26 | Not Available
                            );
            ELSE
                UPDATE dfn_ntp.t76_murabaha_contract_comp
                   SET t76_symbol_code_m20 = i.m182_symbol_code_m20, -- t76_symbol_code_m20
                       t76_percentage = i.m182_percentage, -- t76_percentage
                       t76_allowed_change = i.m182_allowed_change, -- t76_allowed_change
                       t76_modified_by_id_u17 =
                           NVL (i.m182_modified_by_id_u17, 0), -- t76_modified_by_id_u17
                       t76_modified_date = i.m182_modified_date, -- t76_modified_date
                       t76_status_id_v01 = i.m182_status_id_v01, -- t76_status_id_v01
                       t76_exchange_code_m01 = i.m01_exchange_code -- t76_exchange_code_m01
                 WHERE t76_id = i.t76_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T76_MURABAHA_CONTRACT_COMP',
                                   'Contracts ID : '
                                || i.t75_id
                                || ' - Basket Composition ID : '
                                || i.m182_id,
                                CASE
                                    WHEN i.t76_id IS NULL
                                    THEN
                                        l_contracts_composition_id
                                    ELSE
                                        i.t76_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.t76_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
