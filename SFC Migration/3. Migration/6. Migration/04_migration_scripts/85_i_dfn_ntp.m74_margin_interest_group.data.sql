------------------------- SFC Logic -------------------------------

DECLARE
    l_m74_margin_interest_group   NUMBER;
    l_default_currecny_code       VARCHAR2 (10);
    l_sqlerrm                     VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m74_id), 0)
      INTO l_m74_margin_interest_group
      FROM dfn_ntp.m74_margin_interest_group;

    SELECT VALUE
      INTO l_default_currecny_code
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY_CODE';

    DELETE FROM error_log
          WHERE mig_table = 'M74_MARGIN_INTEREST_GROUP';

    FOR i
        IN (SELECT u22.u22_margin_interst_index,
                   m65.m65_description,
                   m65.m65_rate,
                   u22.u22_max_margin_limit_currency,
                   u22.new_institute_id,
                   m03.m03_id,
                   m65_map.new_saibor_basis_rate_id,
                   m74_map.new_margin_int_group_id
              FROM (  SELECT u22.u22_margin_interst_index,
                             NVL (u22.u22_max_margin_limit_currency,
                                  l_default_currecny_code)
                                 AS u22_max_margin_limit_currency,
                             m02_map.new_institute_id
                        FROM mubasher_oms.u22_customer_margin_products@mubasher_db_link u22,
                             mubasher_oms.m01_customer@mubasher_db_link m01,
                             m02_institute_mappings m02_map
                       WHERE     u22.u22_customer_id = m01.m01_customer_id
                             AND m01.m01_owner_id = m02_map.old_institute_id
                             AND u22.u22_margin_interst_index IS NOT NULL
                    GROUP BY u22.u22_margin_interst_index,
                             NVL (u22.u22_max_margin_limit_currency,
                                  l_default_currecny_code),
                             m02_map.new_institute_id) u22,
                   dfn_ntp.m03_currency m03,
                   m65_saibor_basis_rate_mappings m65_map,
                   dfn_ntp.m65_saibor_basis_rates m65,
                   m74_margin_int_group_mappings m74_map
             WHERE     u22.u22_max_margin_limit_currency = m03.m03_code(+)
                   AND u22.u22_margin_interst_index =
                           m65_map.old_saibor_basis_rate_id(+)
                   AND m65_map.new_saibor_basis_rate_id = m65.m65_id(+)
                   AND u22.u22_max_margin_limit_currency =
                           m74_map.old_currency(+)
                   AND u22.u22_margin_interst_index =
                           m74_map.old_interest_index(+)
                   AND u22.new_institute_id = m74_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_saibor_basis_rate_id IS NULL
            THEN
                raise_application_error (
                    -20001,
                    'Saibor Bais Rate Index Not Available',
                    TRUE);
            END IF;

            IF i.m03_id IS NULL
            THEN
                raise_application_error (-20001, 'Curreny Available', TRUE);
            END IF;

            IF i.new_margin_int_group_id IS NULL
            THEN
                l_m74_margin_interest_group := l_m74_margin_interest_group + 1;

                INSERT
                  INTO dfn_ntp.m74_margin_interest_group (
                           m74_id,
                           m74_description,
                           m74_institution_m02,
                           m74_additional_details,
                           m74_interest_basis,
                           m74_capitalization_frequency,
                           m74_flat_fee,
                           m74_currency_id_m03,
                           m74_currency_code_m03,
                           m74_saibor_basis_group_id_m65,
                           m74_add_or_sub_to_saibor_rate,
                           m74_add_or_sub_rate,
                           m74_net_rate,
                           m74_created_by_id_u17,
                           m74_created_date,
                           m74_modified_by_id_u17,
                           m74_modified_date,
                           m74_status_id_v01,
                           m74_status_changed_by_id_u17,
                           m74_status_changed_date,
                           m74_custom_type)
                VALUES (
                           l_m74_margin_interest_group, -- m74_id
                              'Group - '
                           || i.u22_max_margin_limit_currency
                           || ' : '
                           || i.m65_description, -- m74_description
                           i.new_institute_id, -- m74_institution_m02
                           NULL, -- m74_additional_details
                           1, -- m74_interest_basis
                           1, -- m74_capitalization_frequency
                           0, -- m74_flat_fee
                           i.m03_id, -- m74_currency_id_m03
                           i.u22_max_margin_limit_currency, -- m74_currency_code_m03
                           i.new_saibor_basis_rate_id, -- m74_saibor_basis_group_id_m65
                           0, -- m74_add_or_sub_to_saibor_rate | Default 0 (Add)
                           0, -- m74_add_or_sub_rate | Default Value 0
                           i.m65_rate, --  m74_net_rate
                           0, -- m74_created_by_id_u17
                           SYSDATE, -- m74_created_date
                           NULL, -- m74_modified_by_id_u17
                           NULL, -- m74_modified_date
                           2, -- m74_status_id_v01
                           0, -- m74_status_changed_by_id_u17
                           SYSDATE, -- m74_status_changed_date
                           '1' -- m74_custom_type
                              );

                INSERT
                  INTO m74_margin_int_group_mappings (old_currency,
                                                      old_interest_index,
                                                      new_margin_int_group_id,
                                                      new_institute_id)
                VALUES (i.u22_max_margin_limit_currency,
                        i.u22_margin_interst_index,
                        l_m74_margin_interest_group,
                        i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m74_margin_interest_group
                   SET m74_description =
                              'Group - '
                           || i.u22_max_margin_limit_currency
                           || ' : '
                           || i.m65_description, -- m74_description
                       m74_institution_m02 = i.new_institute_id, -- m74_institution_m02
                       m74_currency_id_m03 = i.m03_id, -- m74_currency_id_m03
                       m74_currency_code_m03 = i.u22_max_margin_limit_currency, -- m74_currency_code_m03
                       m74_net_rate = i.m65_rate, --  m74_net_rate
                       m74_saibor_basis_group_id_m65 =
                           i.new_saibor_basis_rate_id -- m74_saibor_basis_group_id_m65
                 WHERE m74_id = i.new_margin_int_group_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M74_MARGIN_INTEREST_GROUP',
                                   'Currency : '
                                || i.u22_max_margin_limit_currency
                                || ' | Interest Index :'
                                || i.u22_margin_interst_index,
                                CASE
                                    WHEN i.new_margin_int_group_id IS NULL
                                    THEN
                                        l_m74_margin_interest_group
                                    ELSE
                                        i.new_margin_int_group_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_margin_int_group_id IS NULL
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

-- Default Margin Interest Groups for Master Margin Product

DECLARE
    l_m74_margin_interest_group   NUMBER;
    l_default_currecny_code       VARCHAR2 (10);
    l_sqlerrm                     VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m74_id), 0)
      INTO l_m74_margin_interest_group
      FROM dfn_ntp.m74_margin_interest_group;

    SELECT VALUE
      INTO l_default_currecny_code
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY_CODE';

    FOR i
        IN (SELECT u22.u22_margin_product,
                   m265.m265_name,
                      'Default Group - '
                   || m265.m265_name
                   || ' - '
                   || u22.u22_max_margin_limit_currency
                       AS default_group_name,
                   u22.u22_max_margin_limit_currency,
                   u22.new_institute_id,
                   m03.m03_id,
                   m74_default.mrgn_int_group
              FROM (  SELECT u22.u22_margin_product,
                             NVL (u22.u22_max_margin_limit_currency, l_default_currecny_code)
                                 AS u22_max_margin_limit_currency,
                             m02_map.new_institute_id
                        FROM mubasher_oms.u22_customer_margin_products@mubasher_db_link u22,
                             mubasher_oms.m01_customer@mubasher_db_link m01,
                             m02_institute_mappings m02_map
                       WHERE     u22.u22_customer_id = m01.m01_customer_id
                             AND m01.m01_owner_id = m02_map.old_institute_id
                    GROUP BY u22.u22_margin_product,
                             NVL (u22.u22_max_margin_limit_currency, l_default_currecny_code),
                             m02_map.new_institute_id) u22,
                   mubasher_oms.m265_margin_products@mubasher_db_link m265,
                   dfn_ntp.m03_currency m03,
                   m74_default_mrgn_int_groups m74_default
             WHERE     u22.u22_margin_product = m265.m265_id
                   AND u22.u22_max_margin_limit_currency = m03.m03_code
                   AND u22.u22_max_margin_limit_currency =
                           m74_default.currency_code(+)
                   AND u22.u22_margin_product = m74_default.margin_product(+)
                   AND u22.new_institute_id = m74_default.institution(+))
    LOOP
        BEGIN
            IF i.mrgn_int_group IS NULL
            THEN
                l_m74_margin_interest_group := l_m74_margin_interest_group + 1;

                INSERT
                  INTO dfn_ntp.m74_margin_interest_group (
                           m74_id,
                           m74_description,
                           m74_institution_m02,
                           m74_additional_details,
                           m74_interest_basis,
                           m74_capitalization_frequency,
                           m74_flat_fee,
                           m74_currency_id_m03,
                           m74_currency_code_m03,
                           m74_saibor_basis_group_id_m65,
                           m74_add_or_sub_to_saibor_rate,
                           m74_add_or_sub_rate,
                           m74_net_rate,
                           m74_created_by_id_u17,
                           m74_created_date,
                           m74_modified_by_id_u17,
                           m74_modified_date,
                           m74_status_id_v01,
                           m74_status_changed_by_id_u17,
                           m74_status_changed_date,
                           m74_custom_type)
                VALUES (l_m74_margin_interest_group, -- m74_id
                        i.default_group_name, -- m74_description
                        i.new_institute_id, -- m74_institution_m02
                        i.default_group_name, -- m74_additional_details
                        1, -- m74_interest_basis
                        1, -- m74_capitalization_frequency
                        0, -- m74_flat_fee
                        i.m03_id, -- m74_currency_id_m03
                        i.u22_max_margin_limit_currency, -- m74_currency_code_m03
                        1, -- m74_saibor_basis_group_id_m65
                        0, -- m74_add_or_sub_to_saibor_rate | Default 0 (Add)
                        0, -- m74_add_or_sub_rate | Default Value 0
                        0, --  m74_net_rate
                        0, -- m74_created_by_id_u17
                        SYSDATE, -- m74_created_date
                        NULL, -- m74_modified_by_id_u17
                        NULL, -- m74_modified_date
                        2, -- m74_status_id_v01
                        0, -- m74_status_changed_by_id_u17
                        SYSDATE, -- m74_status_changed_date
                        '1' -- m74_custom_type
                           );

                INSERT INTO m74_default_mrgn_int_groups (currency_code,
                                                         margin_product,
                                                         mrgn_int_group,
                                                         institution)
                     VALUES (i.u22_max_margin_limit_currency,
                             i.u22_margin_product,
                             l_m74_margin_interest_group,
                             i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m74_margin_interest_group
                   SET m74_description = i.default_group_name, -- m74_description
                       m74_additional_details = i.default_group_name -- m74_additional_details
                 WHERE m74_id = i.mrgn_int_group;
            END IF;
        END;
    END LOOP;
END;
/

------------------------- GBL Logic -------------------------------

/*

DECLARE
    l_m74_margin_interest_group   NUMBER;
    l_default_currecny            NUMBER;
    l_default_currecny_code       VARCHAR2 (10);
    l_sqlerrm                     VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m74_id), 0)
      INTO l_m74_margin_interest_group
      FROM dfn_ntp.m74_margin_interest_group;

    SELECT VALUE
      INTO l_default_currecny
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY';

    SELECT VALUE
      INTO l_default_currecny_code
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY_CODE';

    DELETE FROM error_log
          WHERE mig_table = 'M74_MARGIN_INTEREST_GROUP';

    FOR i
        IN (SELECT m94_id,
                   m94_description,
                   m02_map.new_institute_id,
                   m94_additional_details,
                   m94_flat_fee,
                   NVL (m03_id, l_default_currecny) AS currency_id,
                   NVL (m94_currency, l_default_currecny_code)
                       AS currency_code,
                   new_saibor_basis_rate_id,
                   m94_rate,
                   CASE
                       WHEN NVL (m94_add_or_sub_to_saibor_rate, 0) = 0
                       THEN
                           NVL (m65_rate, 0) + NVL (m94_rate, 0)
                       ELSE
                           NVL (m65_rate, 0) - NVL (m94_rate, 0)
                   END
                       AS net_rate,
                   NVL (m94_add_or_sub_to_saibor_rate, 0)
                       AS m94_add_or_sub_to_saibor_rate, -- [SAME IDs]
                   NVL (u17_created_by.new_employee_id, 0)
                       AS created_by_new_id,
                   NVL (m94_created_date, SYSDATE) AS created_date,
                   u17_modified_by.new_employee_id AS modified_by_new_id,
                   m94_modified_date AS modified_date,
                   NVL (u17_status_changed_by.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m94_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   map01.map01_ntp_id,
                   m94_vat,
                   m74_map.new_margin_int_group_id
              FROM mubasher_oms.m94_margin_inte_rate_group@mubasher_db_link m94,
                   map01_approval_status_v01 map01,
                   dfn_ntp.m03_currency m03,
                   m02_institute_mappings m02_map,
                   m65_saibor_basis_rate_mappings m65_map,
                   dfn_ntp.m65_saibor_basis_rates m65,
                   u17_employee_mappings u17_created_by,
                   u17_employee_mappings u17_modified_by,
                   u17_employee_mappings u17_status_changed_by,
                   m74_margin_int_group_mappings m74_map
             WHERE     m94_status_id = map01.map01_oms_id
                   AND m94.m94_currency = m03.m03_code(+)
                   AND m94.m94_institution = m02_map.old_institute_id
                   AND m94.m94_saibor_basis_group_id =
                           m65_map.old_saibor_basis_rate_id(+)
                   AND m65_map.new_saibor_basis_rate_id = m65.m65_id(+)
                   AND m94.m94_created_by = u17_created_by.old_employee_id(+)
                   AND m94.m94_modified_by =
                           u17_modified_by.old_employee_id(+)
                   AND m94.m94_status_changed_by =
                           u17_status_changed_by.old_employee_id(+)
                   AND m94.m94_id = m74_map.old_margin_int_group_id(+))
    LOOP
        BEGIN
            IF i.new_saibor_basis_rate_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Saibor Bais Rate Not Available',
                                         TRUE);
            END IF;


            IF i.new_margin_int_group_id IS NULL
            THEN
                l_m74_margin_interest_group := l_m74_margin_interest_group + 1;

                INSERT
                  INTO dfn_ntp.m74_margin_interest_group (
                           m74_id,
                           m74_description,
                           m74_institution_m02,
                           m74_additional_details,
                           m74_interest_basis,
                           m74_capitalization_frequency,
                           m74_flat_fee,
                           m74_currency_id_m03,
                           m74_currency_code_m03,
                           m74_saibor_basis_group_id_m65,
                           m74_add_or_sub_to_saibor_rate,
                           m74_add_or_sub_rate,
                           m74_net_rate,
                           m74_created_by_id_u17,
                           m74_created_date,
                           m74_modified_by_id_u17,
                           m74_modified_date,
                           m74_status_id_v01,
                           m74_status_changed_by_id_u17,
                           m74_status_changed_date,
                           m74_custom_type)
                VALUES (l_m74_margin_interest_group, -- m74_id
                        i.m94_description, -- m74_description
                        i.new_institute_id, -- m74_institution_m02
                        i.m94_additional_details, -- m74_additional_details
                        1, -- m74_interest_basis
                        1, -- m74_capitalization_frequency
                        i.m94_flat_fee, -- m74_flat_fee
                        i.currency_id, -- m74_currency_id_m03
                        i.currency_code, -- m74_currency_code_m03
                        i.new_saibor_basis_rate_id, -- m74_saibor_basis_group_id_m65
                        i.m94_add_or_sub_to_saibor_rate, -- m74_add_or_sub_to_saibor_rate
                        i.m94_rate, -- m74_add_or_sub_rate
                        i.net_rate, --  m74_net_rate
                        i.created_by_new_id, -- m74_created_by_id_u17
                        i.created_date, -- m74_created_date
                        i.modified_by_new_id, -- m74_modified_by_id_u17
                        i.modified_date, -- m74_modified_date
                        i.map01_ntp_id, -- m74_status_id_v01
                        i.status_changed_by_new_id, -- m74_status_changed_by_id_u17
                        i.status_changed_date, -- m74_status_changed_date
                        '1' -- m74_custom_type
                                 );

                INSERT INTO m74_margin_int_group_mappings
                     VALUES (i.m94_id, l_m74_margin_interest_group);
            ELSE
                UPDATE dfn_ntp.m74_margin_interest_group
                   SET m74_description = i.m94_description, -- m74_description
                       m74_institution_m02 = i.new_institute_id, -- m74_institution_m02
                       m74_additional_details = i.m94_additional_details, -- m74_additional_details
                       m74_flat_fee = i.m94_flat_fee, -- m74_flat_fee
                       m74_currency_id_m03 = i.currency_id, -- m74_currency_id_m03
                       m74_currency_code_m03 = i.currency_code, -- m74_currency_code_m03
                       m74_saibor_basis_group_id_m65 =
                           i.new_saibor_basis_rate_id, -- m74_saibor_basis_group_id_m65
                       m74_add_or_sub_to_saibor_rate =
                           i.m94_add_or_sub_to_saibor_rate, -- m74_add_or_sub_to_saibor_rate
                       m74_add_or_sub_rate = i.m94_rate, -- m74_add_or_sub_rate
                       m74_net_rate = i.net_rate, --  m74_net_rate
                       m74_modified_by_id_u17 = NVL (i.modified_by_new_id, 0), -- m74_modified_by_id_u17
                       m74_modified_date = NVL (i.modified_date, SYSDATE), -- m74_modified_date
                       m74_status_id_v01 = i.map01_ntp_id, -- m74_status_id_v01
                       m74_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m74_status_changed_by_id_u17
                       m74_status_changed_date = i.status_changed_date -- m74_status_changed_date
                 WHERE m74_id = i.new_margin_int_group_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M74_MARGIN_INTEREST_GROUP',
                                i.m94_id,
                                CASE
                                    WHEN i.new_margin_int_group_id IS NULL
                                    THEN
                                        l_m74_margin_interest_group
                                    ELSE
                                        i.new_margin_int_group_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_margin_int_group_id IS NULL
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
