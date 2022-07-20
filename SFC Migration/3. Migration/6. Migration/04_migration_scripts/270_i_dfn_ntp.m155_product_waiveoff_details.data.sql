DECLARE
    l_prd_waiveoff_details_id   NUMBER;
    l_sqlerrm                   VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m155_id), 0)
      INTO l_prd_waiveoff_details_id
      FROM dfn_ntp.m155_product_waiveoff_details;

    DELETE FROM error_log
          WHERE mig_table = 'M155_PRODUCT_WAIVEOFF_DETAILS';

    FOR i
        IN (SELECT m237.m237_id,
                   m152_map.new_product_id,
                   m152.m152_currency_code_m03,
                   m152.m152_currency_id_m03,
                   m237.m237_service_fee,
                   m237.m237_thirdparty_fee,
                   map01.map01_ntp_id,
                   NVL (m237.m237_created_date, SYSDATE) AS m237_created_date,
                   NVL (u17_created.new_employee_id, 0) AS created_by,
                   m237.m237_modified_date AS m237_modified_date,
                   u17_modified.new_employee_id AS modified_by,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by,
                   NVL (m237.m237_status_changed_date, SYSDATE)
                       AS m237_status_changed_date,
                   m154_map.new_waiveoff_grp_id,
                   m155_map.new_prd_waiveoff_dtl_id
              FROM mubasher_oms.m237_cust_subscription_waveoff@mubasher_db_link m237,
                   m152_prd_subs_many_to_one_map m152_many_to_one,
                   m152_products_mappings m152_map,
                   dfn_ntp.m152_products m152,
                   map01_approval_status_v01 map01,
                   m154_sub_waiveoff_grp_mappings m154_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m155_prd_waiveoff_dtl_mappings m155_map
             WHERE     m237.m237_prd_id =
                           m152_many_to_one.from_subs_prd_id(+)
                   AND m152_many_to_one.to_subs_prd_id =
                           m152_map.old_product_id(+)
                   AND m152_map.new_product_id = m152.m152_id(+)
                   AND m237.m237_status = map01.map01_oms_id
                   AND m237.m237_customer_id = m154_map.old_customer_id(+)
                   AND m237.m237_prd_id = m154_map.old_product_id(+)
                   AND m237.m237_created_user_id =
                           u17_created.old_employee_id(+)
                   AND m237.m237_modified_user_id =
                           u17_modified.old_employee_id(+)
                   AND m237.m237_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m237.m237_id =
                           m155_map.old_prd_waiveoff_dtl_id(+))
    LOOP
        BEGIN
            IF i.new_product_id IS NULL
            THEN
                raise_application_error (
                    -20001,
                    'Customer Subscription Product Not Available',
                    TRUE);
            END IF;

            IF i.new_prd_waiveoff_dtl_id IS NULL
            THEN
                l_prd_waiveoff_details_id := l_prd_waiveoff_details_id + 1;

                INSERT
                  INTO dfn_ntp.m155_product_waiveoff_details (
                           m155_id,
                           m155_group_id_m154,
                           m155_product_id_m152,
                           m155_currency_code_m03,
                           m155_currency_id_m03,
                           m155_service_fee_waiveof_amnt,
                           m155_service_fee_waiveof_pct,
                           m155_broker_fee_waiveof_amnt,
                           m155_broker_fee_waiveof_pct,
                           m155_created_date,
                           m155_created_by_id_u17,
                           m155_modified_date,
                           m155_modified_by_id_u17,
                           m155_custom_type,
                           m155_status_id_v01,
                           m155_status_changed_by_id_u17,
                           m155_status_changed_date)
                VALUES (l_prd_waiveoff_details_id, -- m155_id
                        i.new_waiveoff_grp_id, -- m155_group_id_m154
                        i.new_product_id, -- m155_product_id_m152
                        i.m152_currency_code_m03, -- m155_currency_code_m03
                        i.m152_currency_id_m03, -- m155_currency_id_m03
                        i.m237_service_fee, -- m155_service_fee_waiveof_amnt
                        NULL, -- m155_service_fee_waiveof_pct  | Not Available
                        i.m237_thirdparty_fee, -- m155_broker_fee_waiveof_amnt
                        NULL, -- m155_broker_fee_waiveof_pct  | Not Available
                        i.m237_created_date, -- m155_created_date
                        i.created_by, -- m155_created_by_id_u17
                        i.m237_modified_date, -- m155_modified_date
                        i.modified_by, -- m155_modified_by_id_u17
                        '1', -- m155_custom_type
                        i.map01_ntp_id, -- m155_status_id_v01
                        i.status_changed_by, -- m155_status_changed_by_id_u17
                        i.m237_status_changed_date -- m155_status_changed_date
                                                  );

                INSERT
                  INTO m155_prd_waiveoff_dtl_mappings (
                           old_prd_waiveoff_dtl_id,
                           new_prd_waiveoff_dtl_id)
                VALUES (i.m237_id, l_prd_waiveoff_details_id);
            ELSE
                UPDATE dfn_ntp.m155_product_waiveoff_details
                   SET m155_group_id_m154 = i.new_waiveoff_grp_id, -- m155_group_id_m154
                       m155_product_id_m152 = i.new_product_id, -- m155_product_id_m152
                       m155_currency_code_m03 = i.m152_currency_code_m03, -- m155_currency_code_m03
                       m155_currency_id_m03 = i.m152_currency_id_m03, -- m155_currency_id_m03
                       m155_service_fee_waiveof_amnt = i.m237_service_fee, -- m155_service_fee_waiveof_amnt
                       m155_broker_fee_waiveof_amnt = i.m237_thirdparty_fee, -- m155_broker_fee_waiveof_amnt
                       m155_modified_date =
                           NVL (i.m237_modified_date, SYSDATE), -- m155_modified_date
                       m155_modified_by_id_u17 = NVL (i.modified_by, 0), -- m155_modified_by_id_u17
                       m155_status_id_v01 = i.map01_ntp_id, -- m155_status_id_v01
                       m155_status_changed_by_id_u17 = i.status_changed_by, -- m155_status_changed_by_id_u17
                       m155_status_changed_date = i.m237_status_changed_date -- m155_status_changed_date
                 WHERE m155_id = i.new_prd_waiveoff_dtl_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M155_PRODUCT_WAIVEOFF_DETAILS',
                                i.m237_id,
                                CASE
                                    WHEN i.new_prd_waiveoff_dtl_id
                                             IS NULL
                                    THEN
                                        l_prd_waiveoff_details_id
                                    ELSE
                                        i.new_prd_waiveoff_dtl_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_prd_waiveoff_dtl_id
                                             IS NULL
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
