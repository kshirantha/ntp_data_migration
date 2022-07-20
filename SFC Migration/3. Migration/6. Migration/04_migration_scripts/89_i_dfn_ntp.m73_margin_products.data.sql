------------------------- SFC Logic -------------------------------

DECLARE
    l_m73_margin_products     NUMBER;
    l_sqlerrm                 VARCHAR2 (4000);

    l_default_currecny_code   VARCHAR2 (10);
BEGIN
    SELECT NVL (MAX (m73_id), 0)
      INTO l_m73_margin_products
      FROM dfn_ntp.m73_margin_products;

    SELECT VALUE
      INTO l_default_currecny_code
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY_CODE';

    DELETE FROM error_log
          WHERE mig_table = 'M73_MARGIN_PRODUCTS';

    FOR i
        IN (SELECT u22.u22_margin_product,
                   u22.new_institute_id,
                      m265.m265_name
                   || ' - '
                   || u22.u22_max_margin_limit_currency
                       AS margin_product_name,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m265_created_date, SYSDATE) AS created_date,
                   CASE
                       WHEN v01.map01_ntp_id = 1
                       THEN
                           NVL (u17_l1_by.new_employee_id, 0)
                       WHEN v01.map01_ntp_id IN (2, 3, 4, 5)
                       THEN
                           NVL (u17_l2_by.new_employee_id, 0)
                   END
                       status_changed_by_new_id,
                   v01.map01_ntp_id,
                   CASE
                       WHEN m265_category = 7 THEN 1 -- Murabaha Margin
                       WHEN m265_category = 8 THEN 1001 -- BFS Margin
                       WHEN m265_category = 9 THEN 1002 -- SFC Margin
                   END
                       AS category, -- V01 = 78
                   m265_type, -- Equation ID [SAME IDs]
                   CASE
                       WHEN m265_category = 7 AND m265_type = 1 THEN 1
                       WHEN m265_category = 7 AND m265_type = 2 THEN 2
                       WHEN m265_category = 8 AND m265_type = 1 THEN 1001
                       WHEN m265_category = 9 AND m265_type = 1 THEN 1002
                       WHEN m265_category = 9 AND m265_type = 2 THEN 1003
                       WHEN m265_category = 9 AND m265_type = 3 THEN 1004
                       WHEN m265_category = 9 AND m265_type = 5 THEN 1005
                   END
                       AS v36_id,
                   NVL (
                       m77_map.new_symbol_margin_grp_id,
                       (SELECT m77_id
                          FROM dfn_ntp.m77_symbol_marginability_grps
                         WHERE     m77_institution_m02 = u22.new_institute_id
                               AND m77_is_default = 1))
                       AS new_symbol_margin_grp_id,
                   m265.m265_display_buying_power,
                   m03.m03_id,
                   u22.u22_max_margin_limit_currency,
                   m265.m265_remarks,
                   m265.m265_max_margin_limit,
                   m75_map.new_stk_conc_grp_id,
                   m74_default.mrgn_int_group,
                   m73_map.new_margin_products_id
              FROM (  SELECT u22.u22_margin_product,
                             NVL (u22.u22_max_margin_limit_currency,
                                  l_default_currecny_code)
                                 AS u22_max_margin_limit_currency,
                             m02_map.new_institute_id
                        FROM mubasher_oms.u22_customer_margin_products@mubasher_db_link u22,
                             mubasher_oms.m01_customer@mubasher_db_link m01,
                             m02_institute_mappings m02_map
                       WHERE     u22.u22_customer_id = m01.m01_customer_id
                             AND m01.m01_owner_id = m02_map.old_institute_id
                    GROUP BY u22.u22_margin_product,
                             NVL (u22.u22_max_margin_limit_currency,
                                  l_default_currecny_code),
                             m02_map.new_institute_id) u22,
                   mubasher_oms.m265_margin_products@mubasher_db_link m265,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_l1_by,
                   u17_employee_mappings u17_l2_by,
                   map01_approval_status_v01 v01,
                   dfn_ntp.u17_employee u17,
                   m77_symbol_margin_grp_mappings m77_map,
                   dfn_ntp.m03_currency m03,
                   m74_default_mrgn_int_groups m74_default,
                   m75_stk_conc_grp_mappings m75_map,
                   m73_margin_products_mappings m73_map
             WHERE     u22.u22_margin_product = m265.m265_id(+)
                   AND m265.m265_created_by = u17_created.old_employee_id(+)
                   AND m265.m265_l1_approve_by = u17_l1_by.old_employee_id(+)
                   AND m265.m265_l2_approve_by = u17_l2_by.old_employee_id(+)
                   AND m265.m265_status = v01.map01_oms_id
                   AND u17_created.new_employee_id = u17.u17_id
                   AND m265.m265_symbol_marginability_grp =
                           m77_map.old_symbol_margin_grp_id(+)
                   AND u22.u22_max_margin_limit_currency = m03.m03_code(+)
                   AND m265.m265_stock_concentration =
                           m75_map.global_concentration_pct(+)
                   AND u22.new_institute_id = m75_map.new_institute_id(+)
                   AND u22.u22_max_margin_limit_currency =
                           m74_default.currency_code(+)
                   AND u22.u22_margin_product = m74_default.margin_product(+)
                   AND u22.new_institute_id = m74_default.institution(+)
                   AND u22.u22_margin_product =
                           m73_map.old_margin_products_id(+)
                   AND u22.u22_max_margin_limit_currency =
                           m73_map.currency_code(+)
                   AND u22.new_institute_id = m73_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_symbol_margin_grp_id IS NULL
            THEN
                raise_application_error (
                    -20001,
                    'Symbol Marginability Group Not Available',
                    TRUE);
            END IF;

            IF i.new_margin_products_id IS NULL
            THEN
                l_m73_margin_products := l_m73_margin_products + 1;

                INSERT
                  INTO dfn_ntp.m73_margin_products (
                           m73_id,
                           m73_institution_m02_id,
                           m73_name,
                           m73_description,
                           m73_risk_owner,
                           m73_equation,
                           m73_product_group,
                           m73_created_by_id_u17,
                           m73_created_date,
                           m73_modified_by_id_u17,
                           m73_modified_date,
                           m73_status_id_v01,
                           m73_status_changed_by_id_u17,
                           m73_status_changed_date,
                           m73_product_type,
                           m73_custom_type,
                           m73_margin_category_id_v01,
                           m73_margin_product_eq_id_v36,
                           m73_margin_product_eq_id_v01,
                           m73_symbol_margblty_grp_id_m77,
                           m73_stock_concent_grp_id_m75,
                           m73_margin_interest_grp_id_m74,
                           m73_display_buying_power,
                           m73_agent_id_u07,
                           m73_profit_type,
                           m73_profit,
                           m73_minimum_trading_experience,
                           m73_online_allowed,
                           m73_min_amount,
                           m73_max_amount,
                           m73_currency_id_m03,
                           m73_currency_code_m03,
                           m73_murabaha_basket_id_m181,
                           m73_risk_approval_limit,
                           m73_remarks,
                           m73_margin_disclaimer,
                           m73_dsclmr_name,
                           m73_dsclmr_lst_uploadby_id_u17,
                           m73_dsclmr_lst_uploaded_date)
                VALUES (l_m73_margin_products, -- m73_id
                        i.new_institute_id, -- m73_institution_m02_id
                        i.margin_product_name, -- m73_name
                        i.margin_product_name, -- m73_description
                        1, -- m73_risk_owner [1 : Broker]
                        i.m265_type, -- m73_equation
                        NULL, -- m73_product_group
                        i.created_by_new_id, -- m73_created_by_id_u17
                        i.created_date, -- m73_created_date
                        NULL, -- m73_modified_by_id_u17
                        SYSDATE, -- m73_modified_date
                        i.map01_ntp_id, -- m73_status_id_v01
                        i.status_changed_by_new_id, -- m73_status_changed_by_id_u17
                        SYSDATE, -- m73_status_changed_date
                        1, -- m73_product_type | 1 : Coverage Ratio for SFC
                        '1', -- m73_custom_type
                        i.category, -- m73_margin_category_id_v01
                        i.v36_id, -- m73_margin_product_eq_id_v36
                        i.m265_type, -- m73_margin_product_eq_id_v01
                        i.new_symbol_margin_grp_id, -- m73_symbol_margblty_grp_id_m77
                        i.new_stk_conc_grp_id, -- m73_stock_concent_grp_id_m75
                        i.mrgn_int_group, -- m73_margin_interest_grp_id_m74
                        i.m265_display_buying_power, -- m73_display_buying_power
                        NULL, -- m73_agent_id_u07 | Not Available
                        NULL, -- m73_profit_type | Not Available
                        NULL, -- m73_profit | Not Available
                        NULL, -- m73_minimum_trading_experience | Not Available
                        0, -- m73_online_allowed | Not Available
                        NULL, -- m73_min_amount | Not Available
                        i.m265_max_margin_limit, -- m73_max_amount
                        i.m03_id, -- m73_currency_id_m03
                        i.u22_max_margin_limit_currency, -- m73_currency_code_m03
                        NULL, -- m73_murabaha_basket_id_m181 | Updating in the Post Migration Script
                        NULL, -- m73_risk_approval_limit | Not Available
                        i.m265_remarks, -- m73_remarks
                        NULL, -- m73_margin_disclaimer | Not Available
                        NULL, -- m73_dsclmr_name | Not Available
                        NULL, -- m73_dsclmr_lst_uploadby_id_u17 | Not Available
                        NULL -- m73_dsclmr_lst_uploaded_date | Not Available
                            );

                INSERT INTO m73_margin_products_mappings
                     VALUES (i.u22_margin_product,
                             i.u22_max_margin_limit_currency,
                             l_m73_margin_products,
                             i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m73_margin_products
                   SET m73_institution_m02_id = i.new_institute_id, -- m73_institution_m02_id
                       m73_name = i.margin_product_name, -- m73_name
                       m73_description = i.margin_product_name, -- m73_description
                       m73_equation = i.m265_type, -- m73_equation
                       m73_status_id_v01 = i.map01_ntp_id, -- m73_status_id_v01
                       m73_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m73_status_changed_by_id_u17
                       m73_margin_category_id_v01 = i.category, -- m73_margin_category_id_v01
                       m73_margin_product_eq_id_v36 = i.v36_id, -- m73_margin_product_eq_id_v36
                       m73_margin_product_eq_id_v01 = i.m265_type, -- m73_margin_product_eq_id_v01
                       m73_symbol_margblty_grp_id_m77 =
                           i.new_symbol_margin_grp_id, -- m73_symbol_margblty_grp_id_m77
                       m73_stock_concent_grp_id_m75 = i.new_stk_conc_grp_id, -- m73_stock_concent_grp_id_m75
                       m73_margin_interest_grp_id_m74 = i.mrgn_int_group, -- m73_margin_interest_grp_id_m74
                       m73_display_buying_power = i.m265_display_buying_power, -- m73_display_buying_power
                       m73_max_amount = i.m265_max_margin_limit, -- m73_max_amount
                       m73_currency_id_m03 = i.m03_id, -- m73_currency_id_m03
                       m73_currency_code_m03 = i.u22_max_margin_limit_currency, -- m73_currency_code_m03
                       m73_remarks = i.m265_remarks, -- m73_remarks
                       m73_modified_by_id_u17 = 0, -- m73_modified_by_id_u17
                       m73_modified_date = SYSDATE -- m73_modified_date
                 WHERE m73_id = i.new_margin_products_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M73_MARGIN_PRODUCTS',
                                i.u22_margin_product,
                                CASE
                                    WHEN i.new_margin_products_id IS NULL
                                    THEN
                                        l_m73_margin_products
                                    ELSE
                                        i.new_margin_products_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_margin_products_id IS NULL
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

------------------------- GBL Logic -------------------------------

/*
DECLARE
    l_m73_margin_products   NUMBER;
    l_sqlerrm               VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m73_id), 0)
      INTO l_m73_margin_products
      FROM dfn_ntp.m73_margin_products;

    DELETE FROM error_log
          WHERE mig_table = 'M73_MARGIN_PRODUCTS';

    FOR i
        IN (SELECT m265.m265_id,
                   m02_map.new_institute_id,
                   m265.m265_name,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m265_created_date, SYSDATE) AS created_date,
                   m73_map.new_margin_products_id,
                   CASE
                       WHEN v01.map01_ntp_id = 1
                       THEN
                           NVL (u17_l1_by.new_employee_id, 0)
                       WHEN v01.map01_ntp_id IN (2, 3, 4, 5)
                       THEN
                           NVL (u17_l2_by.new_employee_id, 0)
                   END
                       status_changed_by_new_id,
                   v01.map01_ntp_id,
                   CASE
                       WHEN m265_category = 7 THEN 1 -- Murabaha Margin
                       WHEN m265_category = 8 THEN 1001 -- BFS Margin
                       WHEN m265_category = 9 THEN 1002 -- SFC Margin
                   END
                       AS category, -- V01 = 78
                   m265_type, -- Equation ID [SAME IDs]
                   CASE
                       WHEN m265_category = 7 AND m265_type = 1 THEN 1
                       WHEN m265_category = 7 AND m265_type = 2 THEN 2
                       WHEN m265_category = 8 AND m265_type = 1 THEN 3
                       WHEN m265_category = 9 AND m265_type = 1 THEN 4
                       WHEN m265_category = 9 AND m265_type = 2 THEN 5
                       WHEN m265_category = 9 AND m265_type = 3 THEN 6
                       WHEN m265_category = 9 AND m265_type = 5 THEN 7
                   END
                       AS v36_id,
                   m77_map.new_symbol_margin_grp_id,
                   m265.m265_display_buying_power,
                   m265.m265_max_margin_limit,
                   m03.m03_id,
                   m265.m265_max_mrg_lmt_currency,
                   m265.m265_remarks,
                   m75.m75_id
              FROM mubasher_oms.m265_margin_products@mubasher_db_link m265,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_l1_by,
                   u17_employee_mappings u17_l2_by,
                   map01_approval_status_v01 v01,
                   dfn_ntp.u17_employee u17,
                   m02_institute_mappings m02_map,
                   m73_margin_products_mappings m73_map,
                   m77_symbol_margin_grp_mappings m77_map,
                   dfn_ntp.m03_currency m03,
                   dfn_ntp.m75_stock_concentration_group m75
             WHERE     m265.m265_created_by = u17_created.old_employee_id(+)
                   AND m265.m265_l1_approve_by = u17_l1_by.old_employee_id(+)
                   AND m265.m265_l2_approve_by = u17_l2_by.old_employee_id(+)
                   AND m265.m265_status = v01.map01_oms_id
                   AND u17_created.new_employee_id = u17.u17_id
                   AND u17.u17_institution_id_m02 = m02_map.new_institute_id
                   AND m265.m265_id = m73_map.old_margin_products_id(+)
                   AND m265.m265_symbol_marginability_grp =
                           m77_map.old_symbol_margin_grp_id(+)
                   AND m265.m265_max_mrg_lmt_currency = m03.m03_code(+)
                   AND m265.m265_stock_concentration =
                           m75.m75_global_concentration_pct(+)
                   AND m02_map.new_institute_id = m75.m75_institute_id_m02(+))
    LOOP
        BEGIN
            IF i.new_margin_products_id IS NULL
            THEN
                l_m73_margin_products := l_m73_margin_products + 1;

                INSERT
                  INTO dfn_ntp.m73_margin_products (
                           m73_id,
                           m73_institution_m02_id,
                           m73_name,
                           m73_description,
                           m73_risk_owner,
                           m73_equation,
                           m73_product_group,
                           m73_created_by_id_u17,
                           m73_created_date,
                           m73_modified_by_id_u17,
                           m73_modified_date,
                           m73_status_id_v01,
                           m73_status_changed_by_id_u17,
                           m73_status_changed_date,
                           m73_product_type,
                           m73_custom_type,
                           m73_margin_category_id_v01,
                           m73_margin_product_eq_id_v36,
                           m73_margin_product_eq_id_v01,
                           m73_symbol_margblty_grp_id_m77,
                           m73_stock_concent_grp_id_m75,
                           m73_margin_interest_grp_id_m74,
                           m73_display_buying_power,
                           m73_agent_id_u07,
                           m73_profit_type,
                           m73_profit,
                           m73_minimum_trading_experience,
                           m73_online_allowed,
                           m73_min_amount,
                           m73_max_amount,
                           m73_currency_id_m03,
                           m73_currency_code_m03,
                           m73_murabaha_basket_id_m181,
                           m73_risk_approval_limit,
                           m73_remarks,
                           m73_margin_disclaimer,
                           m73_dsclmr_name,
                           m73_dsclmr_lst_uploadby_id_u17,
                           m73_dsclmr_lst_uploaded_date)
                VALUES (l_m73_margin_products, -- m73_id
                        i.new_institute_id, -- m73_institution_m02_id
                        i.m265_name, -- m73_name
                        i.m265_name, -- m73_description
                        1, -- m73_risk_owner [1 : Broker]
                        i.m265_type, -- m73_equation
                        NULL, -- m73_product_group
                        i.created_by_new_id, -- m73_created_by_id_u17
                        i.created_date, -- m73_created_date
                        NULL, -- m73_modified_by_id_u17
                        SYSDATE, -- m73_modified_date
                        i.map01_ntp_id, -- m73_status_id_v01
                        i.status_changed_by_new_id, -- m73_status_changed_by_id_u17
                        SYSDATE, -- m73_status_changed_date
                        2, -- m73_product_type
                        '1', -- m73_custom_type
                        i.category, -- m73_margin_category_id_v01
                        i.v36_id, -- m73_margin_product_eq_id_v36
                        i.m265_type, -- m73_margin_product_eq_id_v01
                        i.new_symbol_margin_grp_id, -- m73_symbol_margblty_grp_id_m77
                        i.m75_id, -- m73_stock_concent_grp_id_m75
                        NULL, -- m73_margin_interest_grp_id_m74 | Not Available
                        i.m265_display_buying_power, -- m73_display_buying_power
                        NULL, -- m73_agent_id_u07 | Not Available
                        NULL, -- m73_profit_type | Not Available
                        NULL, -- m73_profit | Not Available
                        NULL, -- m73_minimum_trading_experience | Not Available
                        0, -- m73_online_allowed | Not Available
                        NULL, -- m73_min_amount | Not Available
                        i.m265_max_margin_limit, -- m73_max_amount
                        i.m03_id, -- m73_currency_id_m03
                        i.m265_max_mrg_lmt_currency, -- m73_currency_code_m03
                        NULL, -- m73_murabaha_basket_id_m181 | Updating in the Post Migration Script
                        NULL, -- m73_risk_approval_limit | Not Available
                        i.m265_remarks, -- m73_remarks
                        NULL, -- m73_margin_disclaimer | Not Available
                        NULL, -- m73_dsclmr_name | Not Available
                        NULL, -- m73_dsclmr_lst_uploadby_id_u17 | Not Available
                        NULL -- m73_dsclmr_lst_uploaded_date | Not Available
                            );

                INSERT INTO m73_margin_products_mappings
                     VALUES (i.m265_id, l_m73_margin_products);
            ELSE
                UPDATE dfn_ntp.m73_margin_products
                   SET m73_institution_m02_id = i.new_institute_id, -- m73_institution_m02_id
                       m73_name = i.m265_name, -- m73_name
                       m73_description = i.m265_name, -- m73_description
                       m73_equation = i.m265_type, -- m73_equation
                       m73_status_id_v01 = i.map01_ntp_id, -- m73_status_id_v01
                       m73_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m73_status_changed_by_id_u17
                       m73_margin_category_id_v01 = i.category, -- m73_margin_category_id_v01
                       m73_margin_product_eq_id_v36 = i.v36_id, -- m73_margin_product_eq_id_v36
                       m73_margin_product_eq_id_v01 = i.m265_type, -- m73_margin_product_eq_id_v01
                       m73_symbol_margblty_grp_id_m77 =
                           i.new_symbol_margin_grp_id, -- m73_symbol_margblty_grp_id_m77
                       m73_stock_concent_grp_id_m75 = i.m75_id, -- m73_stock_concent_grp_id_m75
                       m73_display_buying_power = i.m265_display_buying_power, -- m73_display_buying_power
                       m73_max_amount = i.m265_max_margin_limit, -- m73_max_amount
                       m73_currency_id_m03 = i.m03_id, -- m73_currency_id_m03
                       m73_currency_code_m03 = i.m265_max_mrg_lmt_currency, -- m73_currency_code_m03
                       m73_remarks = i.m265_remarks, -- m73_remarks
                       m73_modified_by_id_u17 = 0, -- m73_modified_by_id_u17
                       m73_modified_date = SYSDATE -- m73_modified_date
                 WHERE m73_id = i.new_margin_products_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M73_MARGIN_PRODUCTS',
                                i.m265_id,
                                CASE
                                    WHEN i.new_margin_products_id IS NULL
                                    THEN
                                        l_m73_margin_products
                                    ELSE
                                        i.new_margin_products_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_margin_products_id IS NULL
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
*/
