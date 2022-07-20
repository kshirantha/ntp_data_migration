DECLARE
    l_payment_detail_id   NUMBER;
    l_sqlerrm             VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t501_id), 0)
      INTO l_payment_detail_id
      FROM dfn_ntp.t501_payment_detail_c;

    DELETE FROM error_log
          WHERE mig_table = 'T501_PAYMENT_DETAIL_C';

    FOR i
        IN (SELECT t123.t123_id,
                   t06_map.new_cash_transaction_id,
                   t123.t123_symbol_code,
                   t123.t123_record_date,
                   t123.t123_nin_number,
                   t123.t123_nationality,
                   t123.t123_investor_type,
                   t123.t123_account_code,
                   t123.t123_iban,
                   t123.t123_broker_code,
                   t123.t123_broker_name,
                   t123.t123_current_balance,
                   t123.t123_ownership_percentage,
                   t123.t123_event_type,
                   t123.t123_entitlement_type,
                   t123.t123_payment_amount,
                   t123.t123_tax_amount,
                   t123.t123_currency,
                   t123.t123_pyment_status,
                   t123.t123_payment_date,
                   t123.t123_payment_confirm,
                   t500_map.new_paymnt_session_id,
                   t123.t123_created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   map01.map01_ntp_id,
                   u06.u06_id,
                   u06.u06_institute_id_m02,
                   u06.u06_customer_id_u01,
                   t501_map.new_payment_detail_id,
                   CASE WHEN map01.map01_ntp_id IN (3, 7) THEN 1 ELSE 0 END
                       AS approval_completed,
                   CASE
                       WHEN map01.map01_ntp_id IN (3, 7) THEN 2
                       WHEN map01.map01_ntp_id = 6 THEN 1
                       ELSE 0
                   END
                       AS current_approval_level,
                   CASE
                       WHEN map01.map01_ntp_id = 3 THEN 3
                       WHEN map01.map01_ntp_id = 6 THEN 102
                       WHEN map01.map01_ntp_id = 1 THEN 101
                       ELSE 101
                   END
                       AS next_status
              FROM mubasher_oms.t123_payment_log@mubasher_db_link t123,
                   dfn_ntp.u06_cash_account u06,
                   t500_paymnt_session_c_mappings t500_map,
                   u06_cash_account_mappings u06_map,
                   map01_approval_status_v01 map01,
                   t06_cash_transaction_mappings t06_map,
                   t501_payment_detail_c_mappings t501_map
             WHERE     t123.t123_t122_id = t500_map.old_paymnt_session_id(+)
                   AND u06.u06_institute_id_m02 =
                           t500_map.new_institute_id(+)
                   AND t123.t123_t03_account_id =
                           u06_map.old_cash_account_id(+)
                   AND u06_map.new_cash_account_id = u06.u06_id(+)
                   AND t123.t123_status_id = map01.map01_oms_id
                   AND t123.t123_t12_id = t06_map.old_cash_transaction_id(+)
                   AND t123.t123_id = t501_map.old_payment_detail_id(+))
    LOOP
        BEGIN
            IF i.new_paymnt_session_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Payment Session Not Available',
                                         TRUE);
            END IF;

            IF i.u06_id IS NULL
            THEN
                raise_application_error (
                    -20001,
                    'Mapping Cash Account Not Available',
                    TRUE);
            END IF;

            IF i.new_payment_detail_id IS NULL
            THEN
                l_payment_detail_id := l_payment_detail_id + 1;

                INSERT
                  INTO dfn_ntp.t501_payment_detail_c (
                           t501_id,
                           t501_cash_transaction_id_t06,
                           t501_symbol_code_m20,
                           t501_record_date,
                           t501_nin_number,
                           t501_investor_name,
                           t501_nationality,
                           t501_investor_type,
                           t501_account_code,
                           t501_iban,
                           t501_broker_code_m150,
                           t501_broker_name,
                           t501_current_balance,
                           t501_ownership_percentage,
                           t501_event_type,
                           t501_entitlement_type,
                           t501_payment_amount,
                           t501_tax_amount,
                           t501_currency_code_m03,
                           t501_payment_status,
                           t501_payment_date,
                           t501_payment_confirm,
                           t501_payment_session_id_t500,
                           t501_cash_account_id_u06,
                           t501_no_of_approval,
                           t501_is_approval_completed,
                           t501_current_approval_level,
                           t501_next_status,
                           t501_created_date,
                           t501_last_updated_date,
                           t501_status_id_v01,
                           t501_comment,
                           t501_created_by_id_u17,
                           t501_last_updated_by_id_u17,
                           t501_custom_type,
                           t501_institute_id_m02,
                           t501_customer_id_u01,
                           t501_current_status,
                           t501_code_m97,
                           t501_exchange_code_m01)
                VALUES (l_payment_detail_id, -- t501_id
                        i.new_cash_transaction_id, -- t501_cash_transaction_id_t06
                        i.t123_symbol_code, -- t501_symbol_code_m20
                        i.t123_record_date, -- t501_record_date
                        i.t123_nin_number, -- t501_nin_number
                        NULL, -- t501_investor_name | Update Later in this Script as Loop Does Not Support with Special Characters
                        i.t123_nationality, -- t501_nationality
                        i.t123_investor_type, -- t501_investor_type
                        i.t123_account_code, -- t501_account_code
                        i.t123_iban, -- t501_iban
                        i.t123_broker_code, -- t501_broker_code_m150
                        i.t123_broker_name, -- t501_broker_name
                        i.t123_current_balance, -- t501_current_balance
                        i.t123_ownership_percentage, -- t501_ownership_percentage
                        i.t123_event_type, -- t501_event_type
                        i.t123_entitlement_type, -- t501_entitlement_type
                        i.t123_payment_amount, -- t501_payment_amount
                        i.t123_tax_amount, -- t501_tax_amount
                        i.t123_currency, -- t501_currency_code_m03
                        i.t123_pyment_status, -- t501_payment_status
                        i.t123_payment_date, -- t501_payment_date
                        i.t123_payment_confirm, -- t501_payment_confirm
                        i.new_paymnt_session_id, -- t501_payment_session_id_t500
                        i.u06_id, -- t501_cash_account_id_u06
                        2, -- t501_no_of_approval
                        i.approval_completed, -- t501_is_approval_completed
                        i.current_approval_level, -- t501_current_approval_level
                        i.next_status, -- t501_next_status
                        i.t123_created_date, -- t501_created_date
                        i.t123_created_date, -- t501_last_updated_date
                        i.map01_ntp_id, -- t501_status_id_v01
                        NULL, -- t501_comment | Not Available
                        0, -- t501_created_by_id_u17 | Not Available
                        0, -- t501_last_updated_by_id_u17 | Not Available
                        '1', -- t501_custom_type
                        i.u06_institute_id_m02, -- t501_institute_id_m02
                        i.u06_customer_id_u01, -- t501_customer_id_u01
                        i.map01_ntp_id, -- t501_current_status
                        'DIVDND', -- t501_code_m97 | 'Default Value (DIVDND)'
                        'TDWL' -- t501_exchange_code_m01 | Default Value (TDWL)
                              );

                INSERT
                  INTO t501_payment_detail_c_mappings (old_payment_detail_id,
                                                       new_payment_detail_id)
                VALUES (i.t123_id, l_payment_detail_id);
            ELSE
                UPDATE dfn_ntp.t501_payment_detail_c
                   SET t501_cash_transaction_id_t06 =
                           i.new_cash_transaction_id, -- t501_cash_transaction_id_t06
                       t501_symbol_code_m20 = i.t123_symbol_code, -- t501_symbol_code_m20
                       t501_record_date = i.t123_record_date, -- t501_record_date
                       t501_nin_number = i.t123_nin_number, -- t501_nin_number
                       t501_investor_name = NULL, -- t501_investor_name | Update Later in this Script as Loop Does Not Support with Special Characters
                       t501_nationality = i.t123_nationality, -- t501_nationality
                       t501_investor_type = i.t123_investor_type, -- t501_investor_type
                       t501_account_code = i.t123_account_code, -- t501_account_code
                       t501_iban = i.t123_iban, -- t501_iban
                       t501_broker_code_m150 = i.t123_broker_code, -- t501_broker_code_m150
                       t501_broker_name = i.t123_broker_name, -- t501_broker_name
                       t501_current_balance = i.t123_current_balance, -- t501_current_balance
                       t501_ownership_percentage = i.t123_ownership_percentage, -- t501_ownership_percentage
                       t501_event_type = i.t123_event_type, -- t501_event_type
                       t501_entitlement_type = i.t123_entitlement_type, -- t501_entitlement_type
                       t501_payment_amount = i.t123_payment_amount, -- t501_payment_amount
                       t501_tax_amount = i.t123_tax_amount, -- t501_tax_amount
                       t501_currency_code_m03 = i.t123_currency, -- t501_currency_code_m03
                       t501_payment_status = i.t123_pyment_status, -- t501_payment_status
                       t501_payment_date = i.t123_payment_date, -- t501_payment_date
                       t501_payment_confirm = i.t123_payment_confirm, -- t501_payment_confirm
                       t501_payment_session_id_t500 = i.new_paymnt_session_id, -- t501_payment_session_id_t500
                       t501_cash_account_id_u06 = i.u06_id, -- t501_cash_account_id_u06
                       t501_is_approval_completed = i.approval_completed, -- t501_is_approval_completed
                       t501_current_approval_level = i.current_approval_level, -- t501_current_approval_level
                       t501_next_status = i.next_status, -- t501_next_status
                       t501_created_date = i.t123_created_date, -- t501_created_date
                       t501_last_updated_date = i.t123_created_date, -- t501_last_updated_date
                       t501_status_id_v01 = i.map01_ntp_id, -- t501_status_id_v01
                       t501_institute_id_m02 = i.u06_institute_id_m02, -- t501_institute_id_m02
                       t501_customer_id_u01 = i.u06_customer_id_u01, -- t501_customer_id_u01
                       t501_current_status = i.map01_ntp_id -- t501_current_status
                 WHERE t501_id = i.new_payment_detail_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T501_PAYMENT_DETAIL_C',
                                i.t123_id,
                                CASE
                                    WHEN i.new_payment_detail_id IS NULL
                                    THEN
                                        l_payment_detail_id
                                    ELSE
                                        i.new_payment_detail_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_payment_detail_id IS NULL
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

-- Merging Invester Name with Special Characters

MERGE INTO dfn_ntp.t501_payment_detail_c t501
     USING (SELECT t123.t123_investor_name,
                   t501_map.old_payment_detail_id,
                   t501_map.new_payment_detail_id
              FROM mubasher_oms.t123_payment_log@mubasher_db_link t123,
                   t501_payment_detail_c_mappings t501_map
             WHERE t123.t123_id = t501_map.old_payment_detail_id) t123
        ON (t501.t501_id = t123.new_payment_detail_id)
WHEN MATCHED
THEN
    UPDATE SET t501.t501_investor_name = t123.t123_investor_name;

COMMIT;