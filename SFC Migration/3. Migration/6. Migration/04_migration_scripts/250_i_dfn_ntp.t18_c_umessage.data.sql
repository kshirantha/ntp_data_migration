DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_u_message_id           NUMBER;
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

    SELECT NVL (MAX (t18_id), 0)
      INTO l_u_message_id
      FROM dfn_ntp.t18_c_umessage;

    DELETE FROM error_log
          WHERE mig_table = 'T18_C_UMESSAGE';

    FOR i
        IN (SELECT t83.t83_id,
                   t83.t83_member_code_9700,
                   t83.t83_reference_no_9701, -- Vary on Occasions
                   t83.t83_account_type_9702, -- [SAME IDs]
                   CASE
                       WHEN t83.t83_client_type_9703 = 0 THEN 1 -- Individual
                       WHEN t83.t83_client_type_9703 = 1 THEN 3 -- Both
                       WHEN t83.t83_client_type_9703 = 2 THEN 2 -- Corporate
                   END
                       AS client_type,
                   t83.t83_from_nin_9704,
                   t83.t83_bank_acc_type_9705, -- ??
                   t83.t83_bank_acc_no_9706,
                   t83.t83_acc_owner_name_9707,
                   t83.t83_acc_number_9708,
                   t83.t83_acc_create_rspn_9709,
                   t83.t83_address_9711,
                   m06.m06_name,
                   t83.t83_postal_code_9713,
                   m05.m05_code,
                   UPPER (t83.t83_gender_9715) AS gender,
                   t83.t83_name_9716,
                   t83.t83_acc_delete_rspn_9717,
                   t83.t83_acc_change_rspn_9718,
                   CASE
                       WHEN t83.t83_pledge_type_9722 = 'I' THEN 8
                       WHEN t83.t83_pledge_type_9722 = 'O' THEN 9
                   END
                       AS pledge_type,
                   t83.t83_pledgor_member_code_9723,
                   t83.t83_pledgor_acct_no_9724,
                   t83.t83_pledge_total_value_9725,
                   t83.t83_pledge_member_code_9726,
                   t83.t83_pledgecall_mem_code_9727,
                   t83.t83_pledgecall_acc_no_9728,
                   t83.t83_pledge_src_trans_no_9729,
                   t83.t83_trans_rspn_9730,
                   t83.t83_movement_type_9731, -- [SAME IDs]
                   t83.t83_seller_member_code_9732,
                   t83.t83_seller_acct_no_9733,
                   t83.t83_seller_nin_9734,
                   t83.t83_buyer_member_code_9735,
                   t83.t83_buyer_acct_no_9736,
                   t83.t83_buyer_nin_9737,
                   u01_map.new_customer_id,
                   u07_map.new_trading_account_id,
                   t83.t83_effective_date_9744,
                   t83.t83_return_date_9745,
                   t83.t83_transact_time_60,
                   t83.t83_created_date,
                   t83.t83_rspn_date,
                   t83.t83_u_message_type, -- [SAME IDs]
                   t83.t83_u_message_status, -- [SAME IDs]
                   t83.t83_u_message_reject_reason,
                   u17_map.new_employee_id,
                   t83.t83_symbol,
                   t01_map.new_cl_order_id,
                   t83.t83_price,
                   t83.t83_t11_exec_id,
                   t83.t83_shares,
                   t83.t83_trade_date_75,
                   t83.t83_settlement_date_9746,
                   t83.t83_trade_value_900,
                   t83.t83_currency,
                   t83.t83_cash_comp_date,
                   u07.u07_exchange_account_no,
                   t83.t83_foreign_bank_acc_no,
                   t83.t83_foreign_bank_acc_name,
                   t83.t83_foreign_bank_acc_iban,
                   t83.t83_foreign_bank_name,
                   t83.t83_foreign_bank_address,
                   t83.t83_foreign_bank_swift,
                   t83.t83_foreign_bank_aba,
                   m20.m20_id,
                   u07.u07_institute_id_m02,
                   t18_map.new_umessage_id
              FROM mubasher_oms.t83_u_message@mubasher_db_link t83,
                   mubasher_oms.u06_routing_accounts@mubasher_db_link u06_oms,
                   u01_customer_mappings u01_map,
                   dfn_ntp.m05_country m05,
                   (SELECT UPPER (m06_name) AS m06_name FROM dfn_ntp.m06_city) m06,
                   map16_optional_exchanges_m01 map16,
                   u07_trading_account_mappings u07_map,
                   dfn_ntp.u07_trading_account u07,
                   u17_employee_mappings u17_map,
                   t01_order_mappings t01_map,
                   t18_c_umessage_mappings t18_map,
                   (SELECT m20_id, m20_symbol_code, m20_exchange_code_m01
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20
             WHERE     t83.t83_u06_id = u06_oms.u06_id(+)
                   AND t83.t83_m01_customer_id = u01_map.old_customer_id(+)
                   AND UPPER (t83.t83_country_9714) = m05.m05_code(+)
                   AND UPPER (t83.t83_city_9712) = m06.m06_name(+)
                   AND u06_oms.u06_security_ac_id =
                           u07_map.old_trading_account_id(+)
                   AND u06_oms.u06_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, u06_oms.u06_exchange) =
                           u07_map.exchange_code(+)
                   AND u07_map.new_trading_account_id = u07.u07_id(+)
                   AND TO_NUMBER (t83.t83_t01_clordid) =
                           t01_map.old_cl_order_id(+)
                   AND t83.t83_u01_user_id = u17_map.old_employee_id(+)
                   AND t83.t83_symbol = m20.m20_symbol_code(+)
                   AND NVL (map16.map16_ntp_code, u06_oms.u06_exchange) =
                           m20.m20_exchange_code_m01(+)
                   AND t83.t83_id = t18_map.old_umessage_id(+))
    LOOP
        BEGIN
            IF i.new_umessage_id IS NULL
            THEN
                l_u_message_id := l_u_message_id + 1;

                INSERT
                  INTO dfn_ntp.t18_c_umessage (t18_id,
                                               t18_member_code_9700,
                                               t18_reference_no_9701,
                                               t18_account_type_9702,
                                               t18_client_type_9703,
                                               t18_from_nin_9704,
                                               t18_bank_acc_type_9705,
                                               t18_bank_acc_no_9706,
                                               t18_acc_owner_name_9707,
                                               t18_acc_number_9708,
                                               t18_acc_create_rspn_9709,
                                               t18_address_9711,
                                               t18_city_9712,
                                               t18_postal_code_9713,
                                               t18_country_9714,
                                               t18_gender_9715,
                                               t18_name_9716,
                                               t18_acc_delete_rspn_9717,
                                               t18_acc_change_rspn_9718,
                                               t18_pledge_type_9722,
                                               t18_pledgor_member_code_9723,
                                               t18_pledgor_acct_no_9724,
                                               t18_pledge_total_value_9725,
                                               t18_pledge_member_code_9726,
                                               t18_pledgecall_mem_code_9727,
                                               t18_pledgecall_acc_no_9728,
                                               t18_pledge_src_trans_no_9729,
                                               t18_trans_rspn_9730,
                                               t18_movement_type_9731,
                                               t18_seller_member_code_9732,
                                               t18_seller_acct_no_9733,
                                               t18_seller_nin_9734,
                                               t18_buyer_member_code_9735,
                                               t18_buyer_acct_no_9736,
                                               t18_buyer_nin_9737,
                                               t18_customer_id_u01,
                                               t18_trading_account_id_u07,
                                               t18_effective_date_9744,
                                               t18_return_date_9745,
                                               t18_transact_time_60,
                                               t18_created_date,
                                               t18_rspn_date,
                                               t18_u_message_type,
                                               t18_u_message_status,
                                               t18_u_message_reject_reason,
                                               t18_symbol,
                                               t18_clordid_t01,
                                               t18_price,
                                               t18_order_exec_id_t02,
                                               t18_shares,
                                               t18_trade_date_75,
                                               t18_settlement_date_9746,
                                               t18_trade_value_900,
                                               t18_currency,
                                               t18_cash_comp_date,
                                               t18_exchange_account_no_u07,
                                               t18_search_key,
                                               t18_employee_id_u17,
                                               t18_foreign_acc_no_9770,
                                               t18_foreign_acc_name_9771,
                                               t18_foreign_acc_iban_9772,
                                               t18_foreign_bank_name_9773,
                                               t18_foreign_bank_add_9774,
                                               t18_foreign_bank_swift_9775,
                                               t18_foreign_bank_aba_9776,
                                               t18_institute_id_m02,
                                               t18_symbol_id_m20,
                                               t18_req_reference)
                VALUES (l_u_message_id, -- t18_id
                        i.t83_member_code_9700, -- t18_member_code_9700
                        i.t83_reference_no_9701, -- t18_reference_no_9701
                        i.t83_account_type_9702, -- t18_account_type_9702
                        i.client_type, -- t18_client_type_9703
                        i.t83_from_nin_9704, -- t18_from_nin_9704
                        i.t83_bank_acc_type_9705, -- t18_bank_acc_type_9705
                        i.t83_bank_acc_no_9706, -- t18_bank_acc_no_9706
                        i.t83_acc_owner_name_9707, -- t18_acc_owner_name_9707
                        i.t83_acc_number_9708, -- t18_acc_number_9708
                        i.t83_acc_create_rspn_9709, -- t18_acc_create_rspn_9709
                        i.t83_address_9711, -- t18_address_9711
                        i.m06_name, -- t18_city_9712
                        i.t83_postal_code_9713, -- t18_postal_code_9713
                        i.m05_code, -- t18_country_9714
                        i.gender, -- t18_gender_9715
                        i.t83_name_9716, -- t18_name_9716
                        i.t83_acc_delete_rspn_9717, -- t18_acc_delete_rspn_9717
                        i.t83_acc_change_rspn_9718, -- t18_acc_change_rspn_9718
                        i.pledge_type, -- t18_pledge_type_9722
                        i.t83_pledgor_member_code_9723, -- t18_pledgor_member_code_9723
                        i.t83_pledgor_acct_no_9724, -- t18_pledgor_acct_no_9724
                        i.t83_pledge_total_value_9725, -- t18_pledge_total_value_9725
                        i.t83_pledge_member_code_9726, -- t18_pledge_member_code_9726
                        i.t83_pledgecall_mem_code_9727, -- t18_pledgecall_mem_code_9727
                        i.t83_pledgecall_acc_no_9728, -- t18_pledgecall_acc_no_9728
                        i.t83_pledge_src_trans_no_9729, -- t18_pledge_src_trans_no_9729
                        i.t83_trans_rspn_9730, -- t18_trans_rspn_9730
                        i.t83_movement_type_9731, -- t18_movement_type_9731
                        i.t83_seller_member_code_9732, -- t18_seller_member_code_9732
                        i.t83_seller_acct_no_9733, -- t18_seller_acct_no_9733
                        i.t83_seller_nin_9734, -- t18_seller_nin_9734
                        i.t83_buyer_member_code_9735, -- t18_buyer_member_code_9735
                        i.t83_buyer_acct_no_9736, -- t18_buyer_acct_no_9736
                        i.t83_buyer_nin_9737, -- t18_buyer_nin_9737
                        i.new_customer_id, -- t18_customer_id_u01
                        i.new_trading_account_id, -- t18_trading_account_id_u07
                        i.t83_effective_date_9744, -- t18_effective_date_9744
                        i.t83_return_date_9745, -- t18_return_date_9745
                        i.t83_transact_time_60, -- t18_transact_time_60
                        i.t83_created_date, -- t18_created_date
                        i.t83_rspn_date, -- t18_rspn_date
                        i.t83_u_message_type, -- t18_u_message_type
                        i.t83_u_message_status, -- t18_u_message_status
                        i.t83_u_message_reject_reason, -- t18_u_message_reject_reason
                        i.t83_symbol, -- t18_symbol
                        i.new_cl_order_id, -- t18_clordid_t01
                        i.t83_price, -- t18_price
                        i.t83_t11_exec_id, -- t18_order_exec_id_t02
                        i.t83_shares, -- t18_shares
                        i.t83_trade_date_75, -- t18_trade_date_75
                        i.t83_settlement_date_9746, -- t18_settlement_date_9746
                        i.t83_trade_value_900, -- t18_trade_value_900
                        i.t83_currency, -- t18_currency
                        i.t83_cash_comp_date, -- t18_cash_comp_date
                        i.u07_exchange_account_no, -- t18_exchange_account_no_u07
                        NULL, -- t18_search_key | Not Available
                        i.new_employee_id, -- t18_employee_id_u17
                        i.t83_foreign_bank_acc_no, -- t18_foreign_acc_no_9770
                        i.t83_foreign_bank_acc_name, -- t18_foreign_acc_name_9771
                        i.t83_foreign_bank_acc_iban, -- t18_foreign_acc_iban_9772
                        i.t83_foreign_bank_name, -- t18_foreign_bank_name_9773
                        i.t83_foreign_bank_address, -- t18_foreign_bank_add_9774
                        i.t83_foreign_bank_swift, -- t18_foreign_bank_swift_9775
                        i.t83_foreign_bank_aba, -- t18_foreign_bank_aba_9776 -- There is a Data Type Mismatch
                        i.u07_institute_id_m02, -- t18_institute_id_m02
                        i.m20_id, -- t18_symbol_id_m20
                        NULL -- t18_req_reference | Not Avaialble
                            );

                INSERT
                  INTO t18_c_umessage_mappings (old_umessage_id,
                                                new_umessage_id)
                VALUES (i.t83_id, l_u_message_id);
            ELSE
                UPDATE dfn_ntp.t18_c_umessage
                   SET t18_member_code_9700 = i.t83_member_code_9700, -- t18_member_code_9700
                       t18_reference_no_9701 = i.t83_reference_no_9701, -- t18_reference_no_9701
                       t18_account_type_9702 = i.t83_account_type_9702, -- t18_account_type_9702
                       t18_client_type_9703 = i.client_type, -- t18_client_type_9703
                       t18_from_nin_9704 = i.t83_from_nin_9704, -- t18_from_nin_9704
                       t18_bank_acc_type_9705 = i.t83_bank_acc_type_9705, -- t18_bank_acc_type_9705
                       t18_bank_acc_no_9706 = i.t83_bank_acc_no_9706, -- t18_bank_acc_no_9706
                       t18_acc_owner_name_9707 = i.t83_acc_owner_name_9707, -- t18_acc_owner_name_9707
                       t18_acc_number_9708 = i.t83_acc_number_9708, -- t18_acc_number_9708
                       t18_acc_create_rspn_9709 = i.t83_acc_create_rspn_9709, -- t18_acc_create_rspn_9709
                       t18_address_9711 = i.t83_address_9711, -- t18_address_9711
                       t18_city_9712 = i.m06_name, -- t18_city_9712
                       t18_postal_code_9713 = i.t83_postal_code_9713, -- t18_postal_code_9713
                       t18_country_9714 = i.m05_code, -- t18_country_9714
                       t18_gender_9715 = i.gender, -- t18_gender_9715
                       t18_name_9716 = i.t83_name_9716, -- t18_name_9716
                       t18_acc_delete_rspn_9717 = i.t83_acc_delete_rspn_9717, -- t18_acc_delete_rspn_9717
                       t18_acc_change_rspn_9718 = i.t83_acc_change_rspn_9718, -- t18_acc_change_rspn_9718
                       t18_pledge_type_9722 = i.pledge_type, -- t18_pledge_type_9722
                       t18_pledgor_member_code_9723 =
                           i.t83_pledgor_member_code_9723, -- t18_pledgor_member_code_9723
                       t18_pledgor_acct_no_9724 = i.t83_pledgor_acct_no_9724, -- t18_pledgor_acct_no_9724
                       t18_pledge_total_value_9725 =
                           i.t83_pledge_total_value_9725, -- t18_pledge_total_value_9725
                       t18_pledge_member_code_9726 =
                           i.t83_pledge_member_code_9726, -- t18_pledge_member_code_9726
                       t18_pledgecall_mem_code_9727 =
                           i.t83_pledgecall_mem_code_9727, -- t18_pledgecall_mem_code_9727
                       t18_pledgecall_acc_no_9728 =
                           i.t83_pledgecall_acc_no_9728, -- t18_pledgecall_acc_no_9728
                       t18_pledge_src_trans_no_9729 =
                           i.t83_pledge_src_trans_no_9729, -- t18_pledge_src_trans_no_9729
                       t18_trans_rspn_9730 = i.t83_trans_rspn_9730, -- t18_trans_rspn_9730
                       t18_movement_type_9731 = i.t83_movement_type_9731, -- t18_movement_type_9731
                       t18_seller_member_code_9732 =
                           i.t83_seller_member_code_9732, -- t18_seller_member_code_9732
                       t18_seller_acct_no_9733 = i.t83_seller_acct_no_9733, -- t18_seller_acct_no_9733
                       t18_seller_nin_9734 = i.t83_seller_nin_9734, -- t18_seller_nin_9734
                       t18_buyer_member_code_9735 =
                           i.t83_buyer_member_code_9735, -- t18_buyer_member_code_9735
                       t18_buyer_acct_no_9736 = i.t83_buyer_acct_no_9736, -- t18_buyer_acct_no_9736
                       t18_buyer_nin_9737 = i.t83_buyer_nin_9737, -- t18_buyer_nin_9737
                       t18_customer_id_u01 = i.new_customer_id, -- t18_customer_id_u01
                       t18_trading_account_id_u07 = i.new_trading_account_id, -- t18_trading_account_id_u07
                       t18_effective_date_9744 = i.t83_effective_date_9744, -- t18_effective_date_9744
                       t18_return_date_9745 = i.t83_return_date_9745, -- t18_return_date_9745
                       t18_transact_time_60 = i.t83_transact_time_60, -- t18_transact_time_60
                       t18_rspn_date = i.t83_rspn_date, -- t18_rspn_date
                       t18_u_message_type = i.t83_u_message_type, -- t18_u_message_type
                       t18_u_message_status = i.t83_u_message_status, -- t18_u_message_status
                       t18_u_message_reject_reason =
                           i.t83_u_message_reject_reason, -- t18_u_message_reject_reason
                       t18_symbol = i.t83_symbol, -- t18_symbol
                       t18_clordid_t01 = i.new_cl_order_id, -- t18_clordid_t01
                       t18_price = i.t83_price, -- t18_price
                       t18_order_exec_id_t02 = i.t83_t11_exec_id, -- t18_order_exec_id_t02
                       t18_shares = i.t83_shares, -- t18_shares
                       t18_trade_date_75 = i.t83_trade_date_75, -- t18_trade_date_75
                       t18_settlement_date_9746 = i.t83_settlement_date_9746, -- t18_settlement_date_9746
                       t18_trade_value_900 = i.t83_trade_value_900, -- t18_trade_value_900
                       t18_currency = i.t83_currency, -- t18_currency
                       t18_cash_comp_date = i.t83_cash_comp_date, -- t18_cash_comp_date
                       t18_exchange_account_no_u07 = i.u07_exchange_account_no, -- t18_exchange_account_no_u07
                       t18_employee_id_u17 = i.new_employee_id, -- t18_employee_id_u17
                       t18_foreign_acc_no_9770 = i.t83_foreign_bank_acc_no, -- t18_foreign_acc_no_9770
                       t18_foreign_acc_name_9771 = i.t83_foreign_bank_acc_name, -- t18_foreign_acc_name_9771
                       t18_foreign_acc_iban_9772 = i.t83_foreign_bank_acc_iban, -- t18_foreign_acc_iban_9772
                       t18_foreign_bank_name_9773 = i.t83_foreign_bank_name, -- t18_foreign_bank_name_9773
                       t18_foreign_bank_add_9774 = i.t83_foreign_bank_address, -- t18_foreign_bank_add_9774
                       t18_foreign_bank_swift_9775 = i.t83_foreign_bank_swift, -- t18_foreign_bank_swift_9775
                       t18_foreign_bank_aba_9776 = i.t83_foreign_bank_aba, -- t18_foreign_bank_aba_9776 -- There is a Data Type Mismatch
                       t18_institute_id_m02 = i.u07_institute_id_m02, -- t18_institute_id_m02
                       t18_symbol_id_m20 = i.m20_id -- t18_symbol_id_m20
                 WHERE t18_id = i.new_umessage_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T18_C_UMESSAGE',
                                i.t83_id,
                                CASE
                                    WHEN i.new_umessage_id IS NULL
                                    THEN
                                        l_u_message_id
                                    ELSE
                                        i.new_umessage_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_umessage_id IS NULL
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