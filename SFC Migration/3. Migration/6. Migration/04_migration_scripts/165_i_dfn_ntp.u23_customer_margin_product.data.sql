DECLARE
    l_u23_customer_margin_product   NUMBER;
    l_default_max_cur               NUMBER;
    l_sqlerrm                       VARCHAR2 (4000);

    l_default_currecny_code         VARCHAR2 (10);
BEGIN
    SELECT NVL (MAX (u23_id), 0)
      INTO l_u23_customer_margin_product
      FROM dfn_ntp.u23_customer_margin_product;

    SELECT VALUE
      INTO l_default_currecny_code
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY_CODE';

    DELETE FROM error_log
          WHERE mig_table = 'U23_CUSTOMER_MARGIN_PRODUCT';

    FOR i
        IN (SELECT u22.u22_id,
                   u01_map.new_customer_id,
                   m73_map.new_margin_products_id,
                   NVL (m74_map.new_margin_int_group_id,
                        m73.m73_margin_interest_grp_id_m74)
                       AS new_margin_int_group_id,
                   u22.u22_max_margin_limit,
                   NVL (u22.u22_max_margin_limit_currency,
                        l_default_currecny_code)
                       AS u22_max_margin_limit_currency,
                   NVL (u22.u22_margin_expiry_date, SYSDATE - 30)
                       AS u22_margin_expiry_date, -- [Onsite : Discussed with Janaka]
                   u22.u22_margin_call_level_1,
                   u22.u22_margin_call_level_2,
                   u22.u22_liquidation_level,
                   NVL (m77_map.new_symbol_margin_grp_id,
                        m73.m73_symbol_margblty_grp_id_m77)
                       AS new_symbol_margin_grp_id,
                   m03.m03_id,
                   map01.map01_ntp_id,
                   NVL (u17_created_by.new_employee_id, 0)
                       AS created_by_new_id,
                   NVL (u22.u22_created_date, SYSDATE) AS created_date,
                   u17_modified_by.new_employee_id AS modified_by_new_id,
                   u22.u22_modified_date AS modified_date,
                   u22.u22_coverage_ratio,
                   u23_map.new_cust_margin_prod_id,
                   CASE
                       WHEN u22.u22_margin_call_status = 7 THEN 3
                       ELSE u22.u22_margin_call_status
                   END
                       AS margin_call_status,
                   u01.u01_institute_id_m02,
                   CASE
                       WHEN u22.u22_margin_expiry_date < TRUNC (SYSDATE)
                       THEN
                           1
                       ELSE
                           0
                   END
                       AS margin_expired,
                   m74.m74_add_or_sub_to_saibor_rate,
                   m74.m74_add_or_sub_rate,
                   m74.m74_flat_fee,
                   m73.m73_stock_concent_grp_id_m75
              FROM mubasher_oms.u22_customer_margin_products@mubasher_db_link u22,
                   mubasher_oms.m265_margin_products@mubasher_db_link m265,
                   map01_approval_status_v01 map01,
                   u01_customer_mappings u01_map,
                   m73_margin_products_mappings m73_map,
                   dfn_ntp.m73_margin_products m73,
                   m74_margin_int_group_mappings m74_map,
                   dfn_ntp.m74_margin_interest_group m74,
                   m77_symbol_margin_grp_mappings m77_map,
                   dfn_ntp.m03_currency m03,
                   dfn_ntp.u01_customer u01,
                   u17_employee_mappings u17_created_by,
                   u17_employee_mappings u17_modified_by,
                   u23_cust_margin_prod_mappings u23_map
             WHERE     u22.u22_margin_product = m265.m265_id
                   AND u22.u22_status = map01.map01_oms_id
                   AND u22.u22_customer_id = u01_map.old_customer_id
                   AND u22.u22_margin_product =
                           m73_map.old_margin_products_id(+)
                   AND NVL (u22.u22_max_margin_limit_currency,
                            l_default_currecny_code) =
                           m73_map.currency_code(+)
                   AND u01.u01_institute_id_m02 = m73_map.new_institute_id(+)
                   AND m73_map.new_margin_products_id = m73.m73_id(+)
                   AND u22.u22_margin_interst_index =
                           m74_map.old_interest_index(+)
                   AND NVL (u22.u22_max_margin_limit_currency,
                            l_default_currecny_code) =
                           m74_map.old_currency(+)
                   AND u01.u01_institute_id_m02 = m74_map.new_institute_id(+)
                   AND m74_map.new_margin_int_group_id = m74.m74_id(+)
                   AND m265.m265_symbol_marginability_grp =
                           m77_map.old_symbol_margin_grp_id(+)
                   AND NVL (u22.u22_max_margin_limit_currency,
                            l_default_currecny_code) = m03.m03_code(+)
                   AND u01_map.new_customer_id = u01.u01_id
                   AND u22.u22_created_by = u17_created_by.old_employee_id(+)
                   AND u22.u22_modified_by =
                           u17_modified_by.old_employee_id(+)
                   AND u22.u22_id = u23_map.old_cust_margin_prod_id(+))
    LOOP
        BEGIN
            IF i.new_margin_products_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Margin Product Not Available',
                                         TRUE);
            END IF;

            IF i.new_symbol_margin_grp_id IS NULL
            THEN
                raise_application_error (
                    -20001,
                    'Symbol Marginability Group Not Available',
                    TRUE);
            END IF;

            IF i.new_cust_margin_prod_id IS NULL
            THEN
                l_u23_customer_margin_product :=
                    l_u23_customer_margin_product + 1;

                INSERT
                  INTO dfn_ntp.u23_customer_margin_product (
                           u23_id,
                           u23_customer_id_u01,
                           u23_margin_product_m73,
                           u23_interest_group_id_m74,
                           u23_max_margin_limit,
                           u23_max_limit_currency_m03,
                           u23_margin_expiry_date,
                           u23_margin_call_level_1,
                           u23_margin_call_level_2,
                           u23_liquidation_level,
                           u23_sym_margin_group_m77,
                           u23_stock_concentration_m75,
                           u23_status_id_v01,
                           u23_created_date,
                           u23_created_by_id_u17,
                           u23_modified_date,
                           u23_modified_by_id_u17,
                           u23_max_limit_currency_id_m03,
                           u23_borrowers_name,
                           u23_default_cash_acc_id_u06,
                           u23_margin_percentage,
                           u23_status_changed_by_id_u17,
                           u23_status_changed_date,
                           u23_other_cash_acc_ids_u06,
                           u23_restore_level,
                           u23_current_margin_call_level,
                           u23_exempt_liquidation,
                           u23_custom_type,
                           u23_institute_id_m02,
                           u23_margin_expired,
                           u23_murabaha_loan_limit,
                           u23_add_or_sub_to_saibor_rate,
                           u23_add_or_sub_rate,
                           u23_flat_fee,
                           u23_allow_los_cat_symbols_b)
                VALUES (l_u23_customer_margin_product, -- u23_id
                        i.new_customer_id, -- u23_customer_id_u01
                        i.new_margin_products_id, -- u23_margin_product_m73
                        i.new_margin_int_group_id, -- u23_interest_group_id_m74
                        i.u22_max_margin_limit, -- u23_max_margin_limit
                        i.u22_max_margin_limit_currency, -- u23_max_limit_currency_m03
                        i.u22_margin_expiry_date, -- u23_margin_expiry_date
                        i.u22_margin_call_level_1, -- u23_margin_call_level_1
                        i.u22_margin_call_level_2, -- u23_margin_call_level_2
                        i.u22_liquidation_level, -- u23_liquidation_level
                        i.new_symbol_margin_grp_id, -- u23_sym_margin_group_m77
                        i.m73_stock_concent_grp_id_m75, -- u23_stock_concentration_m75
                        i.map01_ntp_id, -- u23_status_id_v01
                        i.created_date, -- u23_created_date
                        i.created_by_new_id, -- u23_created_by_id_u17
                        i.modified_date, -- u23_modified_date
                        i.modified_by_new_id, -- u23_modified_by_id_u17
                        i.m03_id, -- u23_max_limit_currency_id_m03
                        NULL, -- u23_borrowers_name | Not Available for AUDI
                        NULL, -- u23_default_cash_acc_id_u06 | Updating in the Post Migration Script
                        i.u22_coverage_ratio, -- u23_margin_percentage
                        0, -- u23_status_changed_by_id_u17
                        SYSDATE, -- u23_status_changed_date
                        NULL, -- u23_other_cash_acc_ids_u06 | Updating in the Post Migration Script
                        i.u22_margin_call_level_2, -- u23_restore_level | In Case Topup Amount Not Available
                        i.margin_call_status, -- u23_current_margin_call_level
                        0, -- u23_exempt_liquidation
                        '1', -- u23_custom_type
                        i.u01_institute_id_m02, -- u23_institute_id_m02
                        i.margin_expired, -- u23_margin_expired
                        NULL, -- u23_murabaha_loan_limit | Updating in the Post Migration Script
                        i.m74_add_or_sub_to_saibor_rate, -- u23_add_or_sub_to_saibor_rate
                        i.m74_add_or_sub_rate, -- u23_add_or_sub_rate
                        i.m74_flat_fee, -- u23_flat_fee
                        0 -- u23_allow_los_cat_symbols_b | Not Available
                         );

                INSERT INTO u23_cust_margin_prod_mappings
                     VALUES (i.u22_id, l_u23_customer_margin_product);
            ELSE
                UPDATE dfn_ntp.u23_customer_margin_product
                   SET u23_customer_id_u01 = i.new_customer_id, -- u23_customer_id_u01
                       u23_margin_product_m73 = i.new_margin_products_id, -- u23_margin_product_m73
                       u23_interest_group_id_m74 = i.new_margin_int_group_id, -- u23_interest_group_id_m74
                       u23_max_margin_limit = i.u22_max_margin_limit, -- u23_max_margin_limit
                       u23_max_limit_currency_m03 =
                           i.u22_max_margin_limit_currency, -- u23_max_limit_currency_m03
                       u23_margin_expiry_date = i.u22_margin_expiry_date, -- u23_margin_expiry_date
                       u23_margin_call_level_1 = i.u22_margin_call_level_1, -- u23_margin_call_level_1
                       u23_margin_call_level_2 = i.u22_margin_call_level_2, -- u23_margin_call_level_2
                       u23_liquidation_level = i.u22_liquidation_level, -- u23_liquidation_level
                       u23_sym_margin_group_m77 = i.new_symbol_margin_grp_id, -- u23_sym_margin_group_m77
                       u23_status_id_v01 = NVL (i.map01_ntp_id, 0), -- u23_status_id_v01
                       u23_modified_date = NVL (i.modified_date, SYSDATE), -- u23_modified_date
                       u23_modified_by_id_u17 = i.modified_by_new_id, -- u23_modified_by_id_u17
                       u23_max_limit_currency_id_m03 = i.m03_id, -- u23_max_limit_currency_id_m03
                       u23_margin_percentage = i.u22_coverage_ratio, -- u23_margin_percentage
                       u23_restore_level = i.u22_margin_call_level_2, -- u23_restore_level | In Case Topup Amount Not Available
                       u23_current_margin_call_level = i.margin_call_status, -- u23_current_margin_call_level
                       u23_institute_id_m02 = i.u01_institute_id_m02, -- u23_institute_id_m02
                       u23_margin_expired = i.margin_expired, -- u23_margin_expired
                       u23_add_or_sub_to_saibor_rate =
                           i.m74_add_or_sub_to_saibor_rate, -- u23_add_or_sub_to_saibor_rate
                       u23_add_or_sub_rate = i.m74_add_or_sub_rate, -- u23_add_or_sub_rate
                       u23_flat_fee = i.m74_flat_fee, -- u23_flat_fee
                       u23_stock_concentration_m75 =
                           i.m73_stock_concent_grp_id_m75 -- u23_stock_concentration_m75
                 WHERE u23_id = i.new_cust_margin_prod_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U23_CUSTOMER_MARGIN_PRODUCT',
                                i.u22_id,
                                CASE
                                    WHEN i.new_cust_margin_prod_id IS NULL
                                    THEN
                                        l_u23_customer_margin_product
                                    ELSE
                                        i.new_cust_margin_prod_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cust_margin_prod_id IS NULL
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