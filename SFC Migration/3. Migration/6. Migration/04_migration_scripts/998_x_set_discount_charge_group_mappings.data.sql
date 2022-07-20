-- Concept : Create Cash Accoutn wise Groups and Assing Disounts as Slabs to that Group

DECLARE
    disc_group_id   NUMBER;
    l_sqlerrm       VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m165_id), 0)
      INTO disc_group_id
      FROM dfn_ntp.m165_discount_charge_groups;

    DELETE FROM error_log
          WHERE mig_table = 'M165_DISCOUNT_CHARGE_GROUPS';

    FOR i
        IN (SELECT m282.*, m165_map.new_disc_charge_group_id
              FROM (  SELECT m282.m282_account_id,
                             MAX (m280.m280_name) AS m280_name,
                             MAX (u06_map.new_cash_account_id)
                                 AS new_cash_account_id,
                             MAX (u06.u06_institute_id_m02)
                                 AS u06_institute_id_m02
                        FROM mubasher_oms.m280_charges_groups@mubasher_db_link m280,
                             mubasher_oms.m281_charge_structures@mubasher_db_link m281,
                             mubasher_oms.m282_cust_charge_discounts@mubasher_db_link m282,
                             u06_cash_account_mappings u06_map,
                             dfn_ntp.u06_cash_account u06
                       WHERE     m282.m282_discount > 0
                             AND m282.m282_status_id <> 9
                             AND m282.m282_charges_group_id = m280.m280_id
                             AND m282.m282_charge_struct_id = m281.m281_id
                             AND m282.m282_account_id =
                                     u06_map.old_cash_account_id
                    GROUP BY m282.m282_account_id) m282,
                   m165_disc_charge_grp_mappings m165_map
             WHERE m282.m282_account_id = m165_map.old_cash_account_id(+))
    LOOP
        BEGIN
            IF i.new_disc_charge_group_id IS NULL
            THEN
                disc_group_id := disc_group_id + 1;

                INSERT
                  INTO dfn_ntp.m165_discount_charge_groups (
                           m165_id,
                           m165_name,
                           m165_description,
                           m165_created_date,
                           m165_created_by_id_u17,
                           m165_status_changed_date,
                           m165_status_changed_by_id_u17,
                           m165_modified_date,
                           m165_modified_by_id_u17,
                           m165_status_id_v01,
                           m165_is_default,
                           m165_custom_type,
                           m165_institute_id_m02)
                VALUES (disc_group_id, -- m165_id
                        'Disc. Gropup : ' || i.m280_name, -- m165_description,
                        'Cash A/C: ' || i.new_cash_account_id, -- m165_description
                        SYSDATE, -- m165_created_date
                        0, -- m165_created_by_id_u17
                        SYSDATE, -- m165_status_changed_date
                        0, -- m165_status_changed_by_id_u17
                        NULL, -- m165_modified_date
                        NULL, -- m165_modified_by_id_u17
                        2, -- m165_status_id_v01
                        0, -- m165_is_default
                        1, -- m165_custom_type
                        i.u06_institute_id_m02 -- m165_institute_id_m02
                                              );

                INSERT
                  INTO m165_disc_charge_grp_mappings (old_cash_account_id,
                                                      new_disc_charge_group_id)
                VALUES (i.m282_account_id, disc_group_id);
            ELSE
                UPDATE dfn_ntp.m165_discount_charge_groups
                   SET m165_name = 'Disc. Gropup : ' || i.m280_name, -- m165_name
                       m165_description =
                           'Cash A/C: ' || i.new_cash_account_id, -- m165_description
                       m165_institute_id_m02 = i.u06_institute_id_m02, -- m165_institute_id_m02
                       m165_modified_date = SYSDATE, -- m165_modified_date
                       m165_modified_by_id_u17 = 0 -- m165_modified_by_id_u17
                 WHERE m165_id = i.new_disc_charge_group_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M165_DISCOUNT_CHARGE_GROUPS',
                                   'Disc. Gropup : '
                                || i.m280_name
                                || 'Cash A/C : '
                                || i.new_cash_account_id,
                                CASE
                                    WHEN i.new_disc_charge_group_id IS NULL
                                    THEN
                                        disc_group_id
                                    ELSE
                                        i.new_disc_charge_group_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_disc_charge_group_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                l_sqlerrm);
        END;
    END LOOP;
END;
/

COMMIT;

DECLARE
    disc_struct_id   NUMBER;
    l_sqlerrm        VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m164_id), 0)
      INTO disc_struct_id
      FROM dfn_ntp.m164_cust_charge_discounts;

    DELETE FROM error_log
          WHERE mig_table = 'M164_CUST_CHARGE_DISCOUNTS';

    FOR i
        IN (SELECT m282.m282_charges_group_id,
                   m282.m282_charge_struct_id,
                   m282.m282_discount_type,
                   m282.m282_discount,
                   m282.m282_status_id,
                   map01.map01_ntp_id,
                   m282.m282_created_by,
                   m282.m282_created_date,
                   NVL (u17_created_by.new_employee_id, 0) AS created_by,
                   NVL (m282.m282_created_date, SYSDATE) AS created_date,
                   NVL (u17_status_changed_by.new_employee_id, 0)
                       AS status_changed_by,
                   NVL (m282.m282_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m97.m97_code,
                   m281.m281_currency,
                   m03.m03_id,
                   m165.m165_institute_id_m02,
                   m165.m165_id,
                   m164_id
              FROM mubasher_oms.m282_cust_charge_discounts@mubasher_db_link m282,
                   mubasher_oms.m281_charge_structures@mubasher_db_link m281,
                   mubasher_oms.m280_charges_groups@mubasher_db_link m280,
                   m165_disc_charge_grp_mappings m165_map,
                   dfn_ntp.m165_discount_charge_groups m165,
                   mubasher_oms.m41_sub_charges@mubasher_db_link m41_sc,
                   u17_employee_mappings u17_created_by,
                   u17_employee_mappings u17_status_changed_by,
                   map01_approval_status_v01 map01,
                   dfn_ntp.m03_currency m03,
                   map15_transaction_codes_m97 map15,
                   dfn_ntp.m97_transaction_codes m97,
                   (SELECT m164_id,
                           m164_discount_group_id_m165,
                           m164_currency_id_m03,
                           m164_charge_code_m97,
                           CASE
                               WHEN     (   m164_flat_discount IS NULL
                                         OR m164_flat_discount = 0)
                                    AND (    m164_discount_percentage
                                                 IS NOT NULL
                                         AND m164_discount_percentage <> 0)
                               THEN
                                   1 -- Percentage
                               WHEN     (   m164_flat_discount IS NOT NULL
                                         OR m164_flat_discount <> 0)
                                    AND (   m164_discount_percentage IS NULL
                                         OR m164_discount_percentage = 0)
                               THEN
                                   2 -- Falt
                           END
                               AS discount_type,
                           CASE
                               WHEN (   m164_discount_percentage IS NOT NULL
                                     OR m164_discount_percentage <> 0)
                               THEN
                                   m164_discount_percentage
                               WHEN (   m164_flat_discount IS NOT NULL
                                     OR m164_flat_discount <> 0)
                               THEN
                                   m164_flat_discount
                           END
                               AS discount
                      FROM dfn_ntp.m164_cust_charge_discounts) m164
             WHERE     m282.m282_discount > 0
                   AND m282.m282_status_id <> 9
                   AND m282.m282_charges_group_id = m280.m280_id
                   AND m282.m282_charge_struct_id = m281.m281_id
                   AND m282.m282_account_id = m165_map.old_cash_account_id(+)
                   AND m165_map.new_disc_charge_group_id = m165.m165_id(+)
                   AND m281.m281_charge_id = m41_sc.m41_sc_id(+)
                   AND m282.m282_created_by =
                           u17_created_by.old_employee_id(+)
                   AND m282.m282_status_changed_by =
                           u17_status_changed_by.old_employee_id(+)
                   AND m282.m282_status_id = map01.map01_oms_id
                   AND NVL (m41_sc.m41_sc_code, m41_sc.m41_sc_id) =
                           map15.map15_oms_code(+)
                   AND map15.map15_ntp_code = m97.m97_code(+)
                   AND m281.m281_currency = m03.m03_code(+)
                   AND m165.m165_id = m164.m164_discount_group_id_m165(+)
                   AND m03.m03_id = m164.m164_currency_id_m03(+)
                   AND m97.m97_code = m164.m164_charge_code_m97(+)
                   AND m282.m282_discount_type = m164.discount_type(+)
                   AND m282.m282_discount = m164.discount(+))
    LOOP
        BEGIN
            IF i.m165_id IS NULL
            THEN
                raise_application_error (
                    -20001,
                    'Discount Charge Group Not Available',
                    TRUE);
            END IF;

            IF i.m97_code IS NULL
            THEN
                raise_application_error (-20001,
                                         'Sub Charge Code Not Available',
                                         TRUE);
            END IF;

            IF i.m03_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Currency Not Available',
                                         TRUE);
            END IF;

            IF i.m164_id IS NULL
            THEN
                disc_struct_id := disc_struct_id + 1;

                INSERT
                  INTO dfn_ntp.m164_cust_charge_discounts (
                           m164_id,
                           m164_flat_discount,
                           m164_discount_percentage,
                           m164_status_id_v01,
                           m164_created_by_id_u17,
                           m164_created_date,
                           m164_status_changed_by_id_u17,
                           m164_status_changed_date,
                           m164_modified_date,
                           m164_modified_by_id_u17,
                           m164_custom_type,
                           m164_institute_id_m02,
                           m164_discount_group_id_m165,
                           m164_currency_code_m03,
                           m164_currency_id_m03,
                           m164_charge_code_m97)
                VALUES (
                           disc_struct_id, -- m164_id
                           CASE i.m282_discount_type
                               WHEN 2 THEN i.m282_discount
                               ELSE 0
                           END, -- m164_flat_discount
                           CASE i.m282_discount_type
                               WHEN 1 THEN i.m282_discount
                               ELSE 0
                           END, -- m164_discount_percentage
                           i.map01_ntp_id, -- m164_status_id_v01
                           i.created_by, -- m164_created_by_id_u17
                           i.created_date, -- m164_created_date
                           i.status_changed_by, -- m164_status_changed_by_id_u17
                           i.status_changed_date, -- m164_status_changed_date
                           NULL, -- m164_modified_date
                           NULL, -- m164_modified_by_id_u17
                           '1', -- m164_custom_type
                           i.m165_institute_id_m02, -- m164_institute_id_m02
                           i.m165_id, -- m164_discount_group_id_m165
                           i.m281_currency, -- m164_currency_code_m03
                           i.m03_id, -- m164_currency_id_m03
                           i.m97_code -- m164_charge_code_m97
                                     );
            ELSE
                UPDATE dfn_ntp.m164_cust_charge_discounts
                   SET m164_status_id_v01 = i.map01_ntp_id, -- m164_status_id_v01
                       m164_status_changed_by_id_u17 = i.status_changed_by, -- m164_status_changed_by_id_u17
                       m164_status_changed_date = i.status_changed_date, -- m164_status_changed_date
                       m164_institute_id_m02 = i.m165_institute_id_m02, -- m164_institute_id_m02
                       m164_currency_code_m03 = i.m281_currency, -- m164_currency_code_m03
                       m164_charge_code_m97 = i.m97_code, -- m164_charge_code_m97
                       m164_modified_date = SYSDATE, -- m164_modified_date
                       m164_modified_by_id_u17 = 0 -- m164_modified_by_id_u17
                 WHERE m164_id = i.m164_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M164_CUST_CHARGE_DISCOUNTS',
                                   'Disc. Group : '
                                || i.m165_id
                                || ' | Currency : '
                                || i.m03_id
                                || ' | Sub Charge Code : '
                                || i.m97_code
                                || ' | Disc Type: '
                                || i.m282_discount_type
                                || ' | Discount: '
                                || i.m282_discount,
                                CASE
                                    WHEN i.m164_id IS NULL
                                    THEN
                                        disc_struct_id
                                    ELSE
                                        i.m164_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.m164_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/

COMMIT;

-- Updating Discount Charge Group ID for Cash Accounts

MERGE INTO dfn_ntp.u06_cash_account u06
     USING (SELECT u06_map.new_cash_account_id,
                   m165_map.new_disc_charge_group_id
              FROM u06_cash_account_mappings u06_map,
                   m165_disc_charge_grp_mappings m165_map
             WHERE u06_map.old_cash_account_id = m165_map.old_cash_account_id) disc_chrg_grp
        ON (u06.u06_id = disc_chrg_grp.new_cash_account_id)
WHEN MATCHED
THEN
    UPDATE SET
        u06.u06_discunt_charges_group_m165 =
            disc_chrg_grp.new_disc_charge_group_id;

COMMIT;