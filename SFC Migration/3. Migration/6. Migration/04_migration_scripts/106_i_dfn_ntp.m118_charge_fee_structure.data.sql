DECLARE
    l_default_exg_id            NUMBER;
    l_default_exg_code          VARCHAR2 (10);
    l_charge_fee_structure_id   NUMBER;
    l_sqlerrm                   VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_default_exg_code
      FROM migration_params
     WHERE code = 'DEFAULT_EXG_CODE';

    SELECT m01.m01_id
      INTO l_default_exg_id
      FROM dfn_ntp.m01_exchanges m01
     WHERE m01.m01_exchange_code = l_default_exg_code;

    SELECT NVL (MAX (m118_id), 0)
      INTO l_charge_fee_structure_id
      FROM dfn_ntp.m118_charge_fee_structure;

    DELETE FROM error_log
          WHERE mig_table = 'M118_CHARGE_FEE_STRUCTURE';

    FOR i
        IN (SELECT m281.m281_id,
                   m281.m281_charge_amount,
                   m281.m281_currency,
                   m03.m03_id,
                   NVL (m281.m281_broker_vat, 0) AS broker_vat,
                   m97.m97_code,
                   map_m117.new_charge_groups_id,
                   m117.m117_institute_id_m02,
                   m118_map.new_chrg_fee_structure_id
              FROM mubasher_oms.m281_charge_structures@mubasher_db_link m281,
                   mubasher_oms.m41_sub_charges@mubasher_db_link m41_sc_oms,
                   map15_transaction_codes_m97 map15,
                   dfn_ntp.m97_transaction_codes m97,
                   dfn_ntp.m03_currency m03,
                   m117_charge_groups_mappings map_m117,
                   dfn_ntp.m117_charge_groups m117,
                   m118_chrg_fee_struct_mappings m118_map
             WHERE     m281.m281_charge_id = m41_sc_oms.m41_sc_id(+)
                   AND NVL (m41_sc_oms.m41_sc_code, m41_sc_oms.m41_sc_id) =
                           map15.map15_oms_code(+)
                   AND map15.map15_ntp_code = m97.m97_code(+)
                   AND m281.m281_currency = m03.m03_code
                   AND m281.m281_charges_group_id =
                           map_m117.old_charge_groups_id
                   AND map_m117.new_charge_groups_id = m117.m117_id
                   AND m281.m281_id = m118_map.old_chrg_fee_structure_id(+)
                   AND m117.m117_institute_id_m02 =
                           m118_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.m97_code IS NULL
            THEN
                raise_application_error (-20001,
                                         'Transaction Code Not Available',
                                         TRUE);
            END IF;

            IF i.new_chrg_fee_structure_id IS NULL
            THEN
                l_charge_fee_structure_id := l_charge_fee_structure_id + 1;

                INSERT
                  INTO dfn_ntp.m118_charge_fee_structure (
                           m118_id,
                           m118_exchange_code_m01,
                           m118_exchange_id_m01,
                           m118_broker_fee,
                           m118_exchange_fee,
                           m118_group_id_m117,
                           m118_currency_code_m03,
                           m118_currency_id_m03,
                           m118_broker_vat,
                           m118_exchange_vat,
                           m118_charge_code_m97,
                           m118_created_by_id_u17,
                           m118_created_date,
                           m118_modified_by_id_u17,
                           m118_modified_date,
                           m118_custom_type,
                           m118_interest_rate,
                           m118_institute_id_m02)
                VALUES (l_charge_fee_structure_id, -- m118_id
                        l_default_exg_code, -- m118_exchange_code_m01
                        l_default_exg_id, -- m118_exchange_id_m01
                        i.m281_charge_amount, -- m118_broker_fee
                        0, -- m118_exchange_fee | Not Available
                        i.new_charge_groups_id, -- m118_group_id_m117
                        i.m281_currency, -- m118_currency_code_m03
                        i.m03_id, -- m118_currency_id_m03
                        i.broker_vat, -- m118_broker_vat
                        0, -- m118_exchange_vat | Not Available
                        i.m97_code, -- m118_charge_code_m97
                        0, -- m118_created_by_id_u17
                        SYSDATE, -- m118_created_date
                        0, -- m118_modified_by_id_u17
                        SYSDATE, -- m118_modified_date
                        '1', --m118_custom_type
                        0, -- m118_interest_rate
                        i.m117_institute_id_m02 -- m118_institute_id_m02
                                               );

                INSERT INTO m118_chrg_fee_struct_mappings
                     VALUES (
                                i.m281_id,
                                l_charge_fee_structure_id,
                                i.m117_institute_id_m02);
            ELSE
                UPDATE dfn_ntp.m118_charge_fee_structure
                   SET m118_broker_fee = i.m281_charge_amount, -- m118_broker_fee
                       m118_group_id_m117 = i.new_charge_groups_id, -- m118_group_id_m117
                       m118_currency_code_m03 = i.m281_currency, -- m118_currency_code_m03
                       m118_currency_id_m03 = i.m03_id, -- m118_currency_id_m03
                       m118_broker_vat = i.broker_vat, -- m118_broker_vat
                       m118_charge_code_m97 = i.m97_code, -- m118_charge_code_m97
                       m118_institute_id_m02 = i.m117_institute_id_m02, -- m118_institute_id_m02
                       m118_modified_by_id_u17 = 0, -- m118_modified_by_id_u17
                       m118_modified_date = SYSDATE -- m118_modified_date
                 WHERE m118_id = i.new_chrg_fee_structure_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M118_CHARGE_FEE_STRUCTURE',
                                i.m281_id,
                                CASE
                                    WHEN i.new_chrg_fee_structure_id IS NULL
                                    THEN
                                        l_charge_fee_structure_id
                                    ELSE
                                        i.new_chrg_fee_structure_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_chrg_fee_structure_id IS NULL
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