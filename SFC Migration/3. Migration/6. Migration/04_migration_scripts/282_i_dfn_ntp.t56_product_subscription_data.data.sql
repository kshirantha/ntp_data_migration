DECLARE
    l_prod_subs_data_id   NUMBER;
    l_sqlerrm             VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t56_id), 0)
      INTO l_prod_subs_data_id
      FROM dfn_ntp.t56_product_subscription_data;

    DELETE FROM error_log
          WHERE mig_table = 'T56_PRODUCT_SUBSCRIPTION_DATA';

    FOR i
        IN (SELECT t73.t73_id,
                   u01_map.new_customer_id,
                   u09.u09_id,
                   m152_map.new_product_id,
                   t73.t73_from_date,
                   t73.t73_to_date,
                   t73.t73_status, -- [SAME IDs]
                   t74.t74_no_of_months,
                   t74.t74_service_fee,
                   t74.t74_exchange_fee,
                   t74.t74_other_fee,
                   t74.t74_thirdparty_fee,
                   t74.t74_vat_exchange_fee,
                   t74.t74_vat_service_fee,
                   t74.t74_vat_thirdparty_fee,
                   t74.t74_reject_reason,
                   u09.u09_institute_id_m02,
                   m154_map.new_waiveoff_grp_id,
                   t56_map.new_product_subs_data_id
              FROM mubasher_oms.t73_cust_subscribe_prd@mubasher_db_link t73,
                   mubasher_oms.t74_cust_subscription_request@mubasher_db_link t74,
                   mubasher_oms.m236_price_subscription_fees@mubasher_db_link m236,
                   m152_prd_subs_many_to_one_map m152_many_to_one,
                   m152_products_mappings m152_map,
                   u01_customer_mappings u01_map,
                   m154_sub_waiveoff_grp_mappings m154_map,
                   dfn_ntp.u09_customer_login u09,
                   t56_product_subs_data_mappings t56_map
             WHERE     t73.t73_last_request_id = t74.t74_id(+)
                   AND t73.t73_fee_id = m152_many_to_one.from_subs_prd_id(+) -- T73_FEE_ID (Subscription Product ID)
                   AND m152_many_to_one.to_subs_prd_id = m236.m236_id(+)
                   AND m236.m236_id = m152_map.old_product_id(+)
                   AND t73.t73_customer_id = u01_map.old_customer_id(+)
                   AND u01_map.new_customer_id = u09.u09_customer_id_u01(+)
                   AND t73.t73_customer_id = m154_map.old_customer_id(+)
                   AND t73.t73_prd_id = m154_map.old_product_id(+)
                   AND t73.t73_id = t56_map.old_product_subs_data_id(+))
    LOOP
        BEGIN
            IF i.new_product_id IS NULL
            THEN
                raise_application_error (
                    -20001,
                    'Subscription Product Not Available',
                    TRUE);
            END IF;

            IF i.new_product_subs_data_id IS NULL
            THEN
                l_prod_subs_data_id := l_prod_subs_data_id + 1;

                INSERT
                  INTO dfn_ntp.t56_product_subscription_data (
                           t56_id,
                           t56_customer_id_u01,
                           t56_customer_login_u09,
                           t56_product_id_m152,
                           t56_subfee_waiveof_grp_id_m154,
                           t56_from_date,
                           t56_to_date,
                           t56_status,
                           t56_no_of_months,
                           t56_service_fee,
                           t56_broker_fee,
                           t56_vat_service_fee,
                           t56_vat_broker_fee,
                           t56_reject_reason,
                           t56_datetime,
                           t56_institute_id_m02,
                           t56_service_fee_waiveof_amnt,
                           t56_broker_fee_waiveof_amnt,
                           t56_exchange_fee,
                           t56_vat_exchange_fee,
                           t56_other_fee,
                           t56_vat_other_fee,
                           t56_exchange_fee_waiveof_amnt,
                           t56_other_fee_waiveof_amnt,
                           t56_is_auto_subcription,
                           t56_auto_renew_fail_count,
                           t56_next_auto_renew_date,
                           t56_cash_acc_id_u06,
                           t56_is_subscribed)
                VALUES (l_prod_subs_data_id, -- t56_id
                        i.new_customer_id, -- t56_customer_id_u01
                        i.u09_id, -- t56_customer_login_u09
                        i.new_product_id, -- t56_product_id_m152
                        i.new_waiveoff_grp_id, -- t56_subfee_waiveof_grp_id_m154
                        i.t73_from_date, -- t56_from_date
                        i.t73_to_date, -- t56_to_date
                        i.t73_status, -- t56_status
                        i.t74_no_of_months, -- t56_no_of_months
                        i.t74_service_fee, -- t56_service_fee
                        i.t74_vat_thirdparty_fee, -- t56_broker_fee
                        i.t74_vat_service_fee, -- t56_vat_service_fee
                        i.t74_vat_thirdparty_fee, -- t56_vat_broker_fee
                        i.t74_reject_reason, -- t56_reject_reason
                        i.t73_from_date, -- t56_datetime | Not Available and Hence From Date Used
                        i.u09_institute_id_m02, -- t56_institute_id_m02
                        NULL, -- t56_service_fee_waiveof_amnt | Not Available
                        NULL, -- t56_broker_fee_waiveof_amnt | Not Available
                        i.t74_exchange_fee, -- t56_exchange_fee
                        i.t74_vat_exchange_fee, -- t56_vat_exchange_fee
                        i.t74_other_fee, -- t56_other_fee
                        NULL, -- t56_vat_other_fee | Not Available. Discussed & Need as per Janaka
                        NULL, -- t56_exchange_fee_waiveof_amnt | Not Available. Discussed & Need as per Janaka
                        NULL, -- t56_other_fee_waiveof_amnt | Not Available. Discussed & Need as per Janaka
                        0, -- t56_is_auto_subcription | Not Available
                        NULL, -- t56_auto_renew_fail_count | Not Available. Discussed & Need as per Janaka
                        NULL, -- t56_next_auto_renew_date | Not Available. Discussed & Need as per Janaka
                        NULL, -- t56_cash_acc_id_u06 | Not Available. Discussed & Need as per Janaka
                        0 -- t56_is_subscribed | Not Available
                         );

                INSERT
                  INTO t56_product_subs_data_mappings (
                           old_product_subs_data_id,
                           new_product_subs_data_id)
                VALUES (i.t73_id, l_prod_subs_data_id);
            ELSE
                UPDATE dfn_ntp.t56_product_subscription_data
                   SET t56_customer_id_u01 = i.new_customer_id, -- t56_customer_id_u01
                       t56_customer_login_u09 = i.u09_id, -- t56_customer_login_u09
                       t56_product_id_m152 = i.new_product_id, -- t56_product_id_m152
                       t56_subfee_waiveof_grp_id_m154 = i.new_waiveoff_grp_id, -- t56_subfee_waiveof_grp_id_m154
                       t56_from_date = i.t73_from_date, -- t56_from_date
                       t56_to_date = i.t73_to_date, -- t56_to_date
                       t56_status = i.t73_status, -- t56_status
                       t56_no_of_months = i.t74_no_of_months, -- t56_no_of_months
                       t56_service_fee = i.t74_service_fee, -- t56_service_fee
                       t56_broker_fee = i.t74_vat_thirdparty_fee, -- t56_broker_fee
                       t56_vat_service_fee = i.t74_vat_service_fee, -- t56_vat_service_fee
                       t56_vat_broker_fee = i.t74_vat_thirdparty_fee, -- t56_vat_broker_fee
                       t56_reject_reason = i.t74_reject_reason, -- t56_reject_reason
                       t56_datetime = i.t73_from_date, -- t56_datetime | Not Available and Hence From Date Used
                       t56_institute_id_m02 = i.u09_institute_id_m02, -- t56_institute_id_m02
                       t56_exchange_fee = i.t74_exchange_fee, -- t56_exchange_fee
                       t56_vat_exchange_fee = i.t74_vat_exchange_fee, -- t56_vat_exchange_fee
                       t56_other_fee = i.t74_other_fee -- t56_other_fee
                 WHERE t56_id = i.new_product_subs_data_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T56_PRODUCT_SUBSCRIPTION_DATA',
                                i.t73_id,
                                CASE
                                    WHEN i.new_product_subs_data_id IS NULL
                                    THEN
                                        l_prod_subs_data_id
                                    ELSE
                                        i.new_product_subs_data_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_product_subs_data_id IS NULL
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
    l_prod_subs_log_id   NUMBER;
    l_sqlerrm            VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t59_id), 0)
      INTO l_prod_subs_log_id
      FROM dfn_ntp.t59_product_subscription_log;

    DELETE FROM error_log
          WHERE mig_table = 'T59_PRODUCT_SUBSCRIPTION_LOG';

    FOR i
        IN (SELECT t56.*, t59_map.new_product_subs_log_id
              FROM dfn_ntp.t56_product_subscription_data t56,
                   t59_product_subs_log_mappings t59_map
             WHERE t56.t56_id = t59_map.old_product_subs_log_id(+))
    LOOP
        BEGIN
            IF i.new_product_subs_log_id IS NULL
            THEN
                l_prod_subs_log_id := l_prod_subs_log_id + 1;

                INSERT
                  INTO dfn_ntp.t59_product_subscription_log (
                           t59_id,
                           t59_customer_id_u01,
                           t59_customer_login_u09,
                           t59_cash_acc_id_u06,
                           t59_product_id_m152,
                           t59_subfee_waiveof_grp_id_m154,
                           t59_from_date,
                           t59_to_date,
                           t59_status,
                           t59_no_of_months,
                           t59_service_fee,
                           t59_broker_fee,
                           t59_vat_service_fee,
                           t59_vat_broker_fee,
                           t59_reject_reason,
                           t59_datetime,
                           t59_institute_id_m02,
                           t59_prod_subscription_id_t56,
                           t59_service_fee_waiveof_amnt,
                           t59_broker_fee_waiveof_amnt,
                           t59_exchange_fee_waiveof_amnt,
                           t59_other_fee_waiveof_amnt,
                           t59_exchange_fee,
                           t59_vat_exchange_fee,
                           t59_other_fee,
                           t59_vat_other_fee,
                           t59_sub_agreement_type,
                           t59_is_auto_subcription)
                VALUES (l_prod_subs_log_id, -- t59_id
                        i.t56_customer_id_u01, -- t59_customer_id_u01
                        i.t56_customer_login_u09, -- t59_customer_login_u09
                        NULL, -- t59_cash_acc_id_u06 | Update Later in this Script
                        i.t56_product_id_m152, -- t59_product_id_m152
                        i.t56_subfee_waiveof_grp_id_m154, -- t59_subfee_waiveof_grp_id_m154
                        i.t56_from_date, -- t59_from_date
                        i.t56_to_date, -- t59_to_date
                        i.t56_status, -- t59_status
                        i.t56_no_of_months, -- t59_no_of_months
                        i.t56_service_fee, -- t59_service_fee
                        i.t56_broker_fee, -- t59_broker_fee
                        i.t56_vat_service_fee, -- t59_vat_service_fee
                        i.t56_vat_broker_fee, -- t59_vat_broker_fee
                        i.t56_reject_reason, -- t59_reject_reason
                        i.t56_datetime, -- t59_datetime
                        i.t56_institute_id_m02, -- t59_institute_id_m02
                        i.t56_id, -- t59_prod_subscription_id_t56
                        i.t56_service_fee_waiveof_amnt, -- t59_service_fee_waiveof_amnt
                        i.t56_broker_fee_waiveof_amnt, -- t59_broker_fee_waiveof_amnt
                        NULL, -- t59_exchange_fee_waiveof_amnt | Not Available. Discussed & Need as per Janaka
                        NULL, -- t59_other_fee_waiveof_amnt | Not Available. Discussed & Need as per Janaka
                        i.t56_exchange_fee, -- t59_exchange_fee
                        i.t56_vat_exchange_fee, -- t59_vat_exchange_fee
                        i.t56_other_fee, -- t59_other_fee
                        NULL, -- t59_vat_other_fee | Not Available. Discussed & Need as per Janaka
                        NULL, -- t59_sub_agreement_type | Not Available. Discussed & Need as per Janaka
                        i.t56_is_auto_subcription -- t59_is_auto_subcription
                                                 );

                INSERT
                  INTO t59_product_subs_log_mappings (old_product_subs_log_id,
                                                      new_product_subs_log_id)
                VALUES (i.t56_id, l_prod_subs_log_id);
            ELSE
                UPDATE dfn_ntp.t59_product_subscription_log
                   SET t59_customer_id_u01 = i.t56_customer_id_u01, -- t59_customer_id_u01
                       t59_customer_login_u09 = i.t56_customer_login_u09, -- t59_customer_login_u09
                       t59_product_id_m152 = i.t56_product_id_m152, -- t59_product_id_m152
                       t59_subfee_waiveof_grp_id_m154 =
                           i.t56_subfee_waiveof_grp_id_m154, -- t59_subfee_waiveof_grp_id_m154
                       t59_from_date = i.t56_from_date, -- t59_from_date
                       t59_to_date = i.t56_to_date, -- t59_to_date
                       t59_status = i.t56_status, -- t59_status
                       t59_no_of_months = i.t56_no_of_months, -- t59_no_of_months
                       t59_service_fee = i.t56_service_fee, -- t59_service_fee
                       t59_broker_fee = i.t56_broker_fee, -- t59_broker_fee
                       t59_vat_service_fee = i.t56_vat_service_fee, -- t59_vat_service_fee
                       t59_vat_broker_fee = i.t56_vat_broker_fee, -- t59_vat_broker_fee
                       t59_reject_reason = i.t56_reject_reason, -- t59_reject_reason
                       t59_datetime = i.t56_datetime, -- t59_datetime
                       t59_institute_id_m02 = i.t56_institute_id_m02, -- t59_institute_id_m02
                       t59_prod_subscription_id_t56 = i.t56_id, -- t59_prod_subscription_id_t56
                       t59_service_fee_waiveof_amnt =
                           i.t56_service_fee_waiveof_amnt, -- t59_service_fee_waiveof_amnt
                       t59_broker_fee_waiveof_amnt =
                           i.t56_broker_fee_waiveof_amnt, -- t59_broker_fee_waiveof_amnt
                       t59_exchange_fee = i.t56_exchange_fee, -- t59_exchange_fee
                       t59_vat_exchange_fee = i.t56_vat_exchange_fee, -- t59_vat_exchange_fee
                       t59_other_fee = i.t56_other_fee, -- t59_other_fee
                       t59_is_auto_subcription = i.t56_is_auto_subcription -- t59_is_auto_subcription
                 WHERE t59_id = i.new_product_subs_log_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T59_PRODUCT_SUBSCRIPTION_LOG',
                                i.t56_id,
                                CASE
                                    WHEN i.new_product_subs_log_id IS NULL
                                    THEN
                                        l_prod_subs_log_id
                                    ELSE
                                        i.new_product_subs_log_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_product_subs_log_id IS NULL
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

-- Updating Cash Account for Product Subscription Logs

MERGE INTO dfn_ntp.t59_product_subscription_log t59
     USING (SELECT map_u01.new_customer_id, map_u06.new_cash_account_id
              FROM mubasher_oms.t74_cust_subscription_request@mubasher_db_link t74,
                   u01_customer_mappings map_u01,
                   u06_cash_account_mappings map_u06
             WHERE     t74.t74_customer_id = map_u01.old_customer_id
                   AND t74.t74_cash_account_id = map_u06.old_cash_account_id) t74_cash
        ON (t59.t59_customer_id_u01 = t74_cash.new_customer_id)
WHEN MATCHED
THEN
    UPDATE SET t59_cash_acc_id_u06 = t74_cash.new_cash_account_id;

COMMIT;

