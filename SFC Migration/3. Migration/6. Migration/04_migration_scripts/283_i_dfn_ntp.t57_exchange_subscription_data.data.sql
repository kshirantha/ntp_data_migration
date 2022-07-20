DECLARE
    l_exg_subs_data_id   NUMBER;
    l_sqlerrm            VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t57_id), 0)
      INTO l_exg_subs_data_id
      FROM dfn_ntp.t57_exchange_subscription_data;

    DELETE FROM error_log
          WHERE mig_table = 'T57_EXCHANGE_SUBSCRIPTION_DATA';

    FOR i
        IN (SELECT t73.t73_id,
                   u01_map.new_customer_id,
                   u09.u09_id,
                   m153_map.new_exg_subs_prd_id,
                   t73.t73_from_date,
                   t73.t73_to_date,
                   t73.t73_status, -- [SAME IDs]
                   t74.t74_no_of_months,
                   t74.t74_exchange_fee,
                   t74.t74_vat_exchange_fee,
                   t74.t74_reject_reason,
                   u09.u09_institute_id_m02,
                   m154_map.new_waiveoff_grp_id,
                   t57_map.new_exchange_sub_data_id
              FROM mubasher_oms.t73_cust_subscribe_prd@mubasher_db_link t73,
                   mubasher_oms.t74_cust_subscription_request@mubasher_db_link t74,
                   m153_exg_subs_prd_mappings m153_map,
                   u01_customer_mappings u01_map,
                   dfn_ntp.u09_customer_login u09,
                   m154_sub_waiveoff_grp_mappings m154_map,
                   t57_exchange_sub_data_mappings t57_map
             WHERE     t73.t73_last_request_id = t74.t74_id(+)
                   AND t73.t73_fee_id = m153_map.old_exg_subs_prd_id(+)
                   AND t73.t73_customer_id = u01_map.old_customer_id(+)
                   AND u01_map.new_customer_id = u09.u09_customer_id_u01(+)
                   AND t73.t73_customer_id = m154_map.old_customer_id(+)
                   AND t73.t73_prd_id = m154_map.old_product_id(+)
                   AND t73.t73_id = t57_map.old_exchange_sub_data_id(+))
    LOOP
        BEGIN
            IF i.new_exg_subs_prd_id IS NULL
            THEN
                raise_application_error (
                    -20001,
                    'Exchange Subscription Product Not Available',
                    TRUE);
            END IF;

            IF i.new_exchange_sub_data_id IS NULL
            THEN
                l_exg_subs_data_id := l_exg_subs_data_id + 1;

                INSERT
                  INTO dfn_ntp.t57_exchange_subscription_data (
                           t57_id,
                           t57_customer_id_u01,
                           t57_customer_login_u09,
                           t57_exchange_product_id_m153,
                           t57_subfee_waiveof_grp_id_m154,
                           t57_from_date,
                           t57_to_date,
                           t57_status,
                           t57_no_of_months,
                           t57_exchange_fee,
                           t57_vat_exchange_fee,
                           t57_reject_reason,
                           t57_datetime,
                           t57_institute_id_m02,
                           t57_exchange_fee_waiveof_amnt)
                VALUES (l_exg_subs_data_id, -- t57_id
                        i.new_customer_id, -- t57_customer_id_u01
                        i.u09_id, -- t57_customer_login_u09
                        i.new_exg_subs_prd_id, -- t57_exchange_product_id_m153
                        i.new_waiveoff_grp_id, -- t57_subfee_waiveof_grp_id_m154
                        i.t73_from_date, -- t57_from_date
                        i.t73_to_date, -- t57_to_date
                        i.t73_status, -- t57_status
                        i.t74_no_of_months, -- t57_no_of_months
                        i.t74_exchange_fee, -- t57_exchange_fee
                        i.t74_vat_exchange_fee, -- t57_vat_exchange_fee
                        i.t74_reject_reason, -- t57_reject_reason
                        i.t73_from_date, -- t57_datetime | Not Available and Hence From Date Used
                        i.u09_institute_id_m02, -- t57_institute_id_m02
                        NULL -- t57_exchange_fee_waiveof_amnt | Not Available
                            );

                INSERT
                  INTO t57_exchange_sub_data_mappings (
                           old_exchange_sub_data_id,
                           new_exchange_sub_data_id)
                VALUES (i.t73_id, l_exg_subs_data_id);
            ELSE
                UPDATE dfn_ntp.t57_exchange_subscription_data
                   SET t57_customer_id_u01 = i.new_customer_id, -- t57_customer_id_u01
                       t57_customer_login_u09 = i.u09_id, -- t57_customer_login_u09
                       t57_exchange_product_id_m153 = i.new_exg_subs_prd_id, -- t57_exchange_product_id_m153
                       t57_subfee_waiveof_grp_id_m154 = i.new_waiveoff_grp_id, -- t57_subfee_waiveof_grp_id_m154
                       t57_from_date = i.t73_from_date, -- t57_from_date
                       t57_to_date = i.t73_to_date, -- t57_to_date
                       t57_status = i.t73_status, -- t57_status
                       t57_no_of_months = i.t74_no_of_months, -- t57_no_of_months
                       t57_exchange_fee = i.t74_exchange_fee, -- t57_exchange_fee
                       t57_vat_exchange_fee = i.t74_vat_exchange_fee, -- t57_vat_exchange_fee
                       t57_reject_reason = i.t74_reject_reason, -- t57_reject_reason
                       t57_datetime = i.t73_from_date, -- t57_datetime | Not Available and Hence From Date Used
                       t57_institute_id_m02 = i.u09_institute_id_m02 -- t57_institute_id_m02
                 WHERE t57_id = i.new_exchange_sub_data_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T57_EXCHANGE_SUBSCRIPTION_DATA',
                                i.t73_id,
                                CASE
                                    WHEN i.new_exchange_sub_data_id IS NULL
                                    THEN
                                        l_exg_subs_data_id
                                    ELSE
                                        i.new_exchange_sub_data_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_exchange_sub_data_id IS NULL
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

DECLARE
    l_exg_subs_log_id   NUMBER;
    l_sqlerrm           VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t60_id), 0)
      INTO l_exg_subs_log_id
      FROM dfn_ntp.t60_exchange_subscription_log;

    DELETE FROM error_log
          WHERE mig_table = 'T60_EXCHANGE_SUBSCRIPTION_LOG';

    FOR i
        IN (SELECT t57.*, t60_map.new_exg_subs_log_id
              FROM dfn_ntp.t57_exchange_subscription_data t57,
                   t60_exg_subs_log_mappings t60_map
             WHERE t57.t57_id = t60_map.old_exg_subs_log_id(+))
    LOOP
        BEGIN
            IF i.new_exg_subs_log_id IS NULL
            THEN
                l_exg_subs_log_id := l_exg_subs_log_id + 1;

                INSERT
                  INTO dfn_ntp.t60_exchange_subscription_log (
                           t60_id,
                           t60_customer_id_u01,
                           t60_customer_login_u09,
                           t60_cash_acc_id_u06,
                           t60_exchange_product_id_m153,
                           t60_subfee_waiveof_grp_id_m154,
                           t60_from_date,
                           t60_to_date,
                           t60_status,
                           t60_no_of_months,
                           t60_exchange_fee,
                           t60_vat_exchange_fee,
                           t60_reject_reason,
                           t60_datetime,
                           t60_institute_id_m02,
                           t60_exg_subscription_id_t57,
                           t60_exchange_fee_waiveof_amnt)
                VALUES (l_exg_subs_log_id, -- t60_id
                        i.t57_customer_id_u01, -- t60_customer_id_u01
                        i.t57_customer_login_u09, -- t60_customer_login_u09
                        NULL, -- t60_cash_acc_id_u06 | Update Later in this Script
                        i.t57_exchange_product_id_m153, -- t60_exchange_product_id_m153
                        i.t57_subfee_waiveof_grp_id_m154, -- t60_subfee_waiveof_grp_id_m154
                        i.t57_from_date, -- t60_from_date
                        i.t57_to_date, -- t60_to_date
                        i.t57_status, -- t60_status
                        i.t57_no_of_months, -- t60_no_of_months
                        i.t57_exchange_fee, -- t60_exchange_fee
                        i.t57_vat_exchange_fee, -- t60_vat_exchange_fee
                        i.t57_reject_reason, -- t60_reject_reason
                        i.t57_datetime, -- t60_datetime
                        i.t57_institute_id_m02, -- t60_institute_id_m02
                        i.t57_id, -- t60_exg_subscription_id_t57
                        i.t57_exchange_fee_waiveof_amnt -- t60_exchange_fee_waiveof_amnt
                                                       );

                INSERT
                  INTO t60_exg_subs_log_mappings (old_exg_subs_log_id,
                                                  new_exg_subs_log_id)
                VALUES (i.t57_id, l_exg_subs_log_id);
            ELSE
                UPDATE dfn_ntp.t60_exchange_subscription_log
                   SET t60_customer_id_u01 = i.t57_customer_id_u01, -- t60_customer_id_u01
                       t60_customer_login_u09 = i.t57_customer_login_u09, -- t60_customer_login_u09
                       t60_exchange_product_id_m153 =
                           i.t57_exchange_product_id_m153, -- t60_exchange_product_id_m153
                       t60_subfee_waiveof_grp_id_m154 =
                           i.t57_subfee_waiveof_grp_id_m154, -- t60_subfee_waiveof_grp_id_m154
                       t60_from_date = i.t57_from_date, -- t60_from_date
                       t60_to_date = i.t57_to_date, -- t60_to_date
                       t60_status = i.t57_status, -- t60_status
                       t60_no_of_months = i.t57_no_of_months, -- t60_no_of_months
                       t60_exchange_fee = i.t57_exchange_fee, -- t60_exchange_fee
                       t60_vat_exchange_fee = i.t57_vat_exchange_fee, -- t60_vat_exchange_fee
                       t60_reject_reason = i.t57_reject_reason, -- t60_reject_reason
                       t60_datetime = i.t57_datetime, -- t60_datetime
                       t60_institute_id_m02 = i.t57_institute_id_m02, -- t60_institute_id_m02
                       t60_exg_subscription_id_t57 = i.t57_id, -- t60_exg_subscription_id_t57
                       t60_exchange_fee_waiveof_amnt =
                           i.t57_exchange_fee_waiveof_amnt -- t60_exchange_fee_waiveof_amnt
                 WHERE t60_id = i.new_exg_subs_log_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T60_EXCHANGE_SUBSCRIPTION_LOG',
                                i.t57_id,
                                CASE
                                    WHEN i.new_exg_subs_log_id IS NULL
                                    THEN
                                        l_exg_subs_log_id
                                    ELSE
                                        i.new_exg_subs_log_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_exg_subs_log_id IS NULL
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

-- Updating Cash Account for Exchange Subscription Logs

MERGE INTO dfn_ntp.t60_exchange_subscription_log t60
     USING (SELECT map_u01.new_customer_id, map_u06.new_cash_account_id
              FROM mubasher_oms.t74_cust_subscription_request@mubasher_db_link t74,
                   u01_customer_mappings map_u01,
                   u06_cash_account_mappings map_u06
             WHERE     t74.t74_customer_id = map_u01.old_customer_id
                   AND t74.t74_cash_account_id = map_u06.old_cash_account_id) t74_cash
        ON (t60.t60_customer_id_u01 = t74_cash.new_customer_id)
WHEN MATCHED
THEN
    UPDATE SET t60.t60_cash_acc_id_u06 = t74_cash.new_cash_account_id;

COMMIT;
