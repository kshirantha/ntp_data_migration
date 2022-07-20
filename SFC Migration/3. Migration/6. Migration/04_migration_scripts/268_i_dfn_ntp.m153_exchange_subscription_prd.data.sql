-- Not Used the One to many Mapping as Customer Type is Available

DECLARE
    l_broker_id                     NUMBER;
    l_primary_institute_id          NUMBER;
    l_default_exg_code              VARCHAR2 (25);
    l_default_exg_id                NUMBER;
    l_exg_subscription_product_id   NUMBER;
    l_sqlerrm                       VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT VALUE
      INTO l_default_exg_code
      FROM migration_params
     WHERE code = 'DEFAULT_EXG_CODE';

    SELECT m01.m01_id
      INTO l_default_exg_id
      FROM dfn_ntp.m01_exchanges m01
     WHERE m01.m01_exchange_code = l_default_exg_code;

    SELECT NVL (MAX (m153_id), 0)
      INTO l_exg_subscription_product_id
      FROM dfn_ntp.m153_exchange_subscription_prd;

    DELETE FROM error_log
          WHERE mig_table = 'M153_EXCHANGE_SUBSCRIPTION_PRD';

    FOR i
        IN (SELECT m236.m236_id,
                   m236.m236_customer_type,
                   m238.m238_status, -- [SAME IDs]
                   m238.m238_premium_product,
                   m236.m236_exchange_fee,
                   m236.m236_vat_exchange_fee,
                   m236.m236_currency,
                   m03.m03_id,
                   m236.m236_fee_duration_in_months,
                   NVL (m236.m236_created_date, SYSDATE) AS m236_created_date,
                   NVL (u17_created.new_employee_id, 0) AS created_by,
                   m236.m236_modified_date AS m236_modified_date,
                   u17_modified.new_employee_id AS modified_by,
                   v35.v35_id,
                   m153_map.new_exg_subs_prd_id
              FROM mubasher_oms.m236_price_subscription_fees@mubasher_db_link m236,
                   mubasher_oms.m238_products@mubasher_db_link m238,
                   dfn_ntp.m03_currency m03,
                   dfn_ntp.v35_products v35,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   m153_exg_subs_prd_mappings m153_map
             WHERE     m236.m236_prd_id = m238.m238_id
                   AND m236.m236_currency = m03.m03_code
                   AND m238.m238_product_code = v35.v35_product_code(+)
                   AND m236.m236_created_user_id =
                           u17_created.old_employee_id(+)
                   AND m236.m236_modified_user_id =
                           u17_modified.old_employee_id(+)
                   AND m236.m236_id = m153_map.old_exg_subs_prd_id(+))
    LOOP
        BEGIN
            IF i.new_exg_subs_prd_id IS NULL
            THEN
                l_exg_subscription_product_id :=
                    l_exg_subscription_product_id + 1;

                INSERT
                  INTO dfn_ntp.m153_exchange_subscription_prd (
                           m153_id,
                           m153_exchange_id_m01,
                           m153_exchange_code_m01,
                           m153_institution_id_m02,
                           m153_customer_type,
                           m153_premium_product,
                           m153_is_active,
                           m153_duration,
                           m153_exchange_fee,
                           m153_vat_pct,
                           m153_currency_code_m03,
                           m153_currency_id_m03,
                           m153_created_date,
                           m153_created_by_id_u17,
                           m153_modified_date,
                           m153_modified_by_id_u17,
                           m153_custom_type)
                VALUES (l_exg_subscription_product_id, -- m153_id
                        l_default_exg_id, -- m153_exchange_id_m01
                        l_default_exg_code, -- m153_exchange_code_m01
                        l_primary_institute_id, -- m153_institution_id_m02 | As Instiute Details Not Available and Can Not Refer Customer Group Due to Duplication of TDWL and None TDWL
                        i.m236_customer_type, -- m153_customer_type
                        i.m238_premium_product, -- m153_premium_product
                        i.m238_status, -- m153_is_active
                        i.m236_fee_duration_in_months, -- m153_duration
                        i.m236_exchange_fee, -- m153_exchange_fee
                        i.m236_vat_exchange_fee, -- m153_vat_pct
                        i.m236_currency, -- m153_currency_code_m03
                        i.m03_id, -- m153_currency_id_m03
                        i.m236_created_date, -- m153_created_date
                        i.created_by, -- m153_created_by_id_u17
                        i.m236_modified_date, -- m153_modified_date
                        i.modified_by, -- m153_modified_by_id_u17
                        '1' -- m153_custom_type
                           );

                INSERT
                  INTO m153_exg_subs_prd_mappings (old_exg_subs_prd_id,
                                                   new_exg_subs_prd_id)
                VALUES (i.m236_id, l_exg_subscription_product_id);
            ELSE
                UPDATE dfn_ntp.m153_exchange_subscription_prd
                   SET m153_customer_type = i.m236_customer_type, -- m153_customer_type
                       m153_premium_product = i.m238_premium_product, -- m153_premium_product
                       m153_is_active = i.m238_status, -- m153_is_active
                       m153_duration = i.m236_fee_duration_in_months, -- m153_duration
                       m153_exchange_fee = i.m236_exchange_fee, -- m153_exchange_fee
                       m153_vat_pct = i.m236_vat_exchange_fee, -- m153_vat_pct
                       m153_currency_code_m03 = i.m236_currency, -- m153_currency_code_m03
                       m153_currency_id_m03 = i.m03_id, -- m153_currency_id_m03
                       m153_modified_date =
                           NVL (i.m236_modified_date, SYSDATE), -- m153_modified_date
                       m153_modified_by_id_u17 = NVL (i.modified_by, 0) -- m153_modified_by_id_u17
                 WHERE m153_id = i.new_exg_subs_prd_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M153_EXCHANGE_SUBSCRIPTION_PRD',
                                i.m236_id,
                                CASE
                                    WHEN i.new_exg_subs_prd_id IS NULL
                                    THEN
                                        l_exg_subscription_product_id
                                    ELSE
                                        i.new_exg_subs_prd_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_exg_subs_prd_id IS NULL
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
