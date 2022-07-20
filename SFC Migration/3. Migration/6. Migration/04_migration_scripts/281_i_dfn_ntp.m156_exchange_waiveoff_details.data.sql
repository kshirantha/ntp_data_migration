DECLARE
    l_exg_waiveoff_details_id   NUMBER;
    l_sqlerrm                   VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m156_id), 0)
      INTO l_exg_waiveoff_details_id
      FROM dfn_ntp.m156_exchange_waiveoff_details;

    DELETE FROM error_log
          WHERE mig_table = 'M156_EXCHANGE_WAIVEOFF_DETAILS';

    FOR i
        IN (SELECT m237.m237_id,
                   m153_map.new_exg_subs_prd_id,
                   m153.m153_currency_code_m03,
                   m153.m153_currency_id_m03,
                   m237.m237_exchange_fee,
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
                   m156_map.new_exg_waiveoff_dtl_id
              FROM mubasher_oms.m237_cust_subscription_waveoff@mubasher_db_link m237,
                   m153_exg_subs_prd_mappings m153_map,
                   dfn_ntp.m153_exchange_subscription_prd m153,
                   map01_approval_status_v01 map01,
                   m154_sub_waiveoff_grp_mappings m154_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m156_exg_waiveoff_dtl_mappings m156_map
             WHERE     m237.m237_prd_id =
                           m153_map.old_exg_subs_prd_id(+)
                   AND m153_map.new_exg_subs_prd_id = m153.m153_id(+)
                   AND m237.m237_status = map01.map01_oms_id(+)
                   AND m237.m237_customer_id = m154_map.old_customer_id(+)
                   AND m237.m237_prd_id = m154_map.old_product_id(+)
                   AND m237.m237_created_user_id =
                           u17_created.old_employee_id(+)
                   AND m237.m237_modified_user_id =
                           u17_modified.old_employee_id(+)
                   AND m237.m237_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m237.m237_id = m156_map.old_exg_waiveoff_dtl_id(+))
    LOOP
        BEGIN
            IF i.new_exg_subs_prd_id IS NULL
            THEN
                raise_application_error (
                    -20001,
                    'Exchange Subscription Product Not Available',
                    TRUE);
            END IF;

            IF i.new_exg_waiveoff_dtl_id IS NULL
            THEN
                l_exg_waiveoff_details_id := l_exg_waiveoff_details_id + 1;

                INSERT
                  INTO dfn_ntp.m156_exchange_waiveoff_details (
                           m156_id,
                           m156_group_id_m154,
                           m156_exchange_prd_id_m153,
                           m156_currency_code_m03,
                           m156_currency_id_m03,
                           m156_exchange_fee_waiveof_amnt,
                           m156_exchange_fee_waiveof_pct,
                           m156_created_date,
                           m156_created_by_id_u17,
                           m156_modified_date,
                           m156_modified_by_id_u17,
                           m156_custom_type,
                           m156_status_id_v01,
                           m156_status_changed_by_id_u17,
                           m156_status_changed_date)
                VALUES (l_exg_waiveoff_details_id, -- m156_id
                        i.new_waiveoff_grp_id, -- m156_group_id_m154
                        i.new_exg_subs_prd_id, -- m156_exchange_prd_id_m153
                        i.m153_currency_code_m03, -- m156_currency_code_m03
                        i.m153_currency_id_m03, -- m156_currency_id_m03
                        i.m237_exchange_fee, -- m156_exchange_fee_waiveof_amnt
                        NULL, -- m156_exchange_fee_waiveof_pct | Not Available
                        i.m237_created_date, -- m156_created_date
                        i.created_by, -- m156_created_by_id_u17
                        i.m237_modified_date, -- m156_modified_date
                        i.modified_by, -- m156_modified_by_id_u17
                        '1', -- m156_custom_type
                        i.map01_ntp_id, -- m156_status_id_v01
                        i.status_changed_by, -- m156_status_changed_by_id_u17
                        i.m237_status_changed_date -- m156_status_changed_date
                                                  );

                INSERT
                  INTO m156_exg_waiveoff_dtl_mappings (
                           old_exg_waiveoff_dtl_id,
                           new_exg_waiveoff_dtl_id)
                VALUES (i.m237_id, l_exg_waiveoff_details_id);
            ELSE
                UPDATE dfn_ntp.m156_exchange_waiveoff_details
                   SET m156_group_id_m154 = i.new_waiveoff_grp_id, -- m156_group_id_m154
                       m156_exchange_prd_id_m153 = i.new_exg_subs_prd_id, -- m156_exchange_prd_id_m153
                       m156_currency_code_m03 = i.m153_currency_code_m03, -- m156_currency_code_m03
                       m156_currency_id_m03 = i.m153_currency_id_m03, -- m156_currency_id_m03
                       m156_exchange_fee_waiveof_amnt = i.m237_exchange_fee, -- m156_exchange_fee_waiveof_amnt
                       m156_modified_date =
                           NVL (i.m237_modified_date, SYSDATE), -- m156_modified_date
                       m156_modified_by_id_u17 = NVL (i.modified_by, 0), -- m156_modified_by_id_u17
                       m156_status_id_v01 = i.map01_ntp_id, -- m156_status_id_v01
                       m156_status_changed_by_id_u17 = i.status_changed_by, -- m156_status_changed_by_id_u17
                       m156_status_changed_date = i.m237_status_changed_date -- m156_status_changed_date
                 WHERE m156_id = i.new_exg_waiveoff_dtl_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M156_EXCHANGE_WAIVEOFF_DETAILS',
                                i.m237_id,
                                CASE
                                    WHEN i.new_exg_waiveoff_dtl_id
                                             IS NULL
                                    THEN
                                        l_exg_waiveoff_details_id
                                    ELSE
                                        i.new_exg_waiveoff_dtl_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_exg_waiveoff_dtl_id
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
