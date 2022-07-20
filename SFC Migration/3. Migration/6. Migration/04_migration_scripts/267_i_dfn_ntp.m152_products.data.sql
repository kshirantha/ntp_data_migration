-- Setup One to Many Mapping for Subscription Products Based on (Product + Currency + Customer Group) after Discussion

BEGIN
    FOR i
        IN (SELECT main.m236_id AS from_id, grouped.m236_id AS to_id
              FROM mubasher_oms.m236_price_subscription_fees@mubasher_db_link main,
                   (  SELECT MAX (m236_id) AS m236_id,
                             m236_prd_id,
                             m236_currency,
                             m236_customer_group_id
                        FROM mubasher_oms.m236_price_subscription_fees@mubasher_db_link
                    GROUP BY m236_prd_id,
                             m236_currency,
                             m236_customer_group_id) grouped
             WHERE     main.m236_prd_id = grouped.m236_prd_id(+)
                   AND main.m236_currency = grouped.m236_currency(+)
                   AND main.m236_customer_group_id =
                           grouped.m236_customer_group_id(+)
                   AND main.m236_id NOT IN
                           (SELECT mapping.from_subs_prd_id
                              FROM m152_prd_subs_many_to_one_map mapping))
    LOOP
        INSERT
          INTO m152_prd_subs_many_to_one_map (from_subs_prd_id, to_subs_prd_id)
        VALUES (i.from_id, i.to_id);
    END LOOP;
END;
/

-- Actual Subscription Product Migration

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_product_id             NUMBER;
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

    SELECT NVL (MAX (m152_id), 0)
      INTO l_product_id
      FROM dfn_ntp.m152_products;

    DELETE FROM error_log
          WHERE mig_table = 'M152_PRODUCTS';

    FOR i
        IN (SELECT m236.m236_id,
                   m238.m238_product_code,
                   m238.m238_product_name,
                   m238.m238_product_name_ar,
                   m238.m238_rank,
                   m238.m238_status, -- [SAME IDs]
                   m238.m238_premium_product,
                   m236.m236_service_fee,
                   m236.m236_thirdparty_fee,
                   m236.m236_currency,
                   m03.m03_id,
                   m236.m236_fee_duration_in_months,
                   NVL (m236.m236_created_date, SYSDATE) AS m236_created_date,
                   NVL (u17_created.new_employee_id, 0) AS created_by,
                   m236.m236_modified_date AS m236_modified_date,
                   u17_modified.new_employee_id AS modified_by,
                   m236.m236_status,
                   NVL (m236.m236_status_changed_date, SYSDATE)
                       AS m236_status_changed_date,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by,
                   m236.m236_exchange_fee,
                   v35.v35_id,
                   m152_map.new_product_id
              FROM (  SELECT MAX (m236_id) AS m236_id,
                             m236_prd_id,
                             m236_currency,
                             m236_customer_group_id,
                             MAX (m236_created_user_id) AS m236_created_user_id,
                             MAX (m236_created_date) AS m236_created_date,
                             MAX (m236_modified_user_id)
                                 AS m236_modified_user_id,
                             MAX (m236_modified_date) AS m236_modified_date,
                             MAX (m236_service_fee) AS m236_service_fee,
                             MAX (m236_thirdparty_fee) AS m236_thirdparty_fee,
                             MAX (m236_fee_duration_in_months)
                                 AS m236_fee_duration_in_months,
                             MAX (m236_status) AS m236_status,
                             MAX (m236_status_changed_by)
                                 AS m236_status_changed_by,
                             MAX (m236_status_changed_date)
                                 AS m236_status_changed_date,
                             MAX (m236_exchange_fee) AS m236_exchange_fee
                        FROM mubasher_oms.m236_price_subscription_fees@mubasher_db_link
                    GROUP BY m236_prd_id,
                             m236_currency,
                             m236_customer_group_id) m236, -- Since Customer Type is Not Available in M152
                   mubasher_oms.m238_products@mubasher_db_link m238,
                   dfn_ntp.m03_currency m03,
                   dfn_ntp.v35_products v35,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m152_products_mappings m152_map
             WHERE     m236.m236_prd_id = m238.m238_id
                   AND m236.m236_currency = m03.m03_code(+)
                   AND m238.m238_product_code = v35.v35_product_code(+)
                   AND m236.m236_created_user_id =
                           u17_created.old_employee_id(+)
                   AND m236.m236_modified_user_id =
                           u17_modified.old_employee_id(+)
                   AND m236.m236_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m236.m236_id = m152_map.old_product_id(+))
    LOOP
        BEGIN
            IF i.v35_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Product Code Not Available',
                                         TRUE);
            END IF;

            IF i.m03_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Currency Not Available',
                                         TRUE);
            END IF;

            IF i.new_product_id IS NULL
            THEN
                l_product_id := l_product_id + 1;

                INSERT
                  INTO dfn_ntp.m152_products (m152_id,
                                              m152_product_code,
                                              m152_product_name,
                                              m152_product_name_lang,
                                              m152_institution_id_m02,
                                              m152_is_active,
                                              m152_rank,
                                              m152_premium_product,
                                              m152_currency_code_m03,
                                              m152_currency_id_m03,
                                              m152_duration,
                                              m152_service_fee,
                                              m152_broker_fee,
                                              m152_vat_pct,
                                              m152_created_date,
                                              m152_created_by_id_u17,
                                              m152_modified_date,
                                              m152_modified_by_id_u17,
                                              m152_custom_type,
                                              m152_product_id_v35,
                                              m152_status_id_v01,
                                              m152_status_changed_by_id_u17,
                                              m152_status_changed_date,
                                              m152_sub_agreement_type,
                                              m152_exchange_fee,
                                              m152_other_fee,
                                              m152_product_id_m144,
                                              m152_description)
                VALUES (l_product_id, -- m152_id
                        i.m238_product_code, -- m152_product_code
                        i.m238_product_name, -- m152_product_name
                        i.m238_product_name_ar, -- m152_product_name_lang
                        l_primary_institute_id, -- m152_institution_id_m02 | As Instiute Details Not Available and Can Not Refer Customer Group Due to Duplication of TDWL and None TDWL
                        i.m238_status, -- m152_is_active
                        i.m238_rank, -- m152_rank
                        i.m238_premium_product, -- m152_premium_product
                        i.m236_currency, -- m152_currency_code_m03
                        i.m03_id, -- m152_currency_id_m03
                        i.m236_fee_duration_in_months, -- m152_duration
                        i.m236_service_fee, -- m152_service_fee
                        i.m236_thirdparty_fee, -- m152_broker_fee
                        NULL, -- m152_vat_pct | Not Available
                        i.m236_created_date, -- m152_created_date
                        i.created_by, -- m152_created_by_id_u17
                        i.m236_modified_date, -- m152_modified_date
                        i.modified_by, -- m152_modified_by_id_u17
                        '1', -- m152_custom_type
                        i.v35_id, -- m152_product_id_v35
                        i.m236_status, -- m152_status_id_v01
                        i.status_changed_by, -- m152_status_changed_by_id_u17
                        i.m236_status_changed_date, -- m152_status_changed_date
                        NULL, -- m152_sub_agreement_type | Not Available. Discussed & Need as per Janaka
                        i.m236_exchange_fee, -- m152_exchange_fee
                        NULL, -- m152_other_fee | Not Available. Discussed & Need as per Janaka
                        NULL, -- m152_product_id_m144 | Not Available. Discussed & Need as per Janaka
                        NULL -- m152_description | Not Available
                            );

                INSERT
                  INTO m152_products_mappings (old_product_id, new_product_id)
                VALUES (i.m236_id, l_product_id);
            ELSE
                UPDATE dfn_ntp.m152_products
                   SET m152_product_code = i.m238_product_code, -- m152_product_code
                       m152_product_name = i.m238_product_name, -- m152_product_name
                       m152_product_name_lang = i.m238_product_name_ar, -- m152_product_name_lang
                       m152_is_active = i.m238_status, -- m152_is_active
                       m152_rank = i.m238_rank, -- m152_rank
                       m152_premium_product = i.m238_premium_product, -- m152_premium_product
                       m152_currency_code_m03 = i.m236_currency, -- m152_currency_code_m03
                       m152_currency_id_m03 = i.m03_id, -- m152_currency_id_m03
                       m152_duration = i.m236_fee_duration_in_months, -- m152_duration
                       m152_service_fee = i.m236_service_fee, -- m152_service_fee
                       m152_broker_fee = i.m236_thirdparty_fee, -- m152_broker_fee
                       m152_modified_date =
                           NVL (i.m236_modified_date, SYSDATE), -- m152_modified_date
                       m152_modified_by_id_u17 = NVL (i.modified_by, 0), -- m152_modified_by_id_u17
                       m152_product_id_v35 = i.v35_id, -- m152_product_id_v35
                       m152_status_id_v01 = i.m236_status, -- m152_status_id_v01
                       m152_status_changed_by_id_u17 = i.status_changed_by, -- m152_status_changed_by_id_u17
                       m152_status_changed_date = i.m236_status_changed_date, -- m152_status_changed_date
                       m152_exchange_fee = i.m236_exchange_fee -- m152_exchange_fee
                 WHERE m152_id = i.new_product_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M152_PRODUCTS',
                                i.m236_id,
                                CASE
                                    WHEN i.new_product_id IS NULL
                                    THEN
                                        l_product_id
                                    ELSE
                                        i.new_product_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_product_id IS NULL
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

-- Updating Institute Default Product ID & Product Channels Configuration (30 - HTML 5 Web)

DECLARE
    l_broker_id            NUMBER;
    l_highest_rank         NUMBER;
    l_default_product_id   NUMBER;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT MAX (m152_rank) INTO l_highest_rank FROM dfn_ntp.m152_products;

    SELECT m152_id
      INTO l_default_product_id
      FROM dfn_ntp.m152_products
     WHERE m152_rank = l_highest_rank;

    UPDATE dfn_ntp.m02_institute m02
       SET m02.m02_default_product_id_m152 = l_default_product_id
     WHERE m02.m02_broker_id_m150 = l_broker_id;

    FOR i
        IN (SELECT m152.m152_id, m157.m157_subs_prd_id_m152
              FROM dfn_ntp.m152_products m152,
                   dfn_ntp.m157_subcription_prd_channels m157
             WHERE m152.m152_id = m157.m157_subs_prd_id_m152)
    LOOP
        IF i.m157_subs_prd_id_m152 IS NULL
        THEN
            INSERT INTO dfn_ntp.m157_subcription_prd_channels
                 VALUES (i.m152_id, 30);
        ELSE
            UPDATE dfn_ntp.m157_subcription_prd_channels
               SET m157_channel_id_v29 = 30
             WHERE m157_subs_prd_id_m152 = i.m152_id;
        END IF;
    END LOOP;
END;
/

COMMIT;