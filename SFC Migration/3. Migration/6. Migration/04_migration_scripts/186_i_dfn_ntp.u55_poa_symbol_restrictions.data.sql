DECLARE
    l_poa_sym_restriction_id   NUMBER;
    l_sqlerrm                  VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (u55_id), 0)
      INTO l_poa_sym_restriction_id
      FROM dfn_ntp.u55_poa_symbol_restrictions;

    DELETE FROM error_log
          WHERE mig_table = 'U55_POA_SYMBOL_RESTRICTIONS';

    FOR i
        IN (SELECT m175.m175_id,
                   u47_map.new_power_of_attorney_id,
                   m20_map.new_symbol_id,
                   m20.m20_symbol_code,
                   u07_map.new_trading_account_id,
                   m175.m175_sell,
                   m175.m175_buy,
                   map01.map01_ntp_id,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m175.m175_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m175.m175_modified_date AS modified_date,
                   u55_map.new_poa_sym_restrict_id
              FROM mubasher_oms.m175_cutomer_poa_symbols@mubasher_db_link m175,
                   mubasher_oms.m137_customer_poa@mubasher_db_link m137,
                   map01_approval_status_v01 map01,
                   u07_trading_account_mappings u07_map,
                   m20_symbol_mappings m20_map,
                   u47_power_of_attorney_mappings u47_map,
                   dfn_ntp.m20_symbol m20,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u55_poa_sym_restrict_mappings u55_map
             WHERE     m175.m175_poa = m137.m137_id
                   AND m175.m175_status_id = map01.map01_oms_id
                   AND m175.m175_symbol_id = m20_map.old_symbol_id(+)
                   AND m137.m137_security_ac_id =
                           u07_map.old_trading_account_id(+)
                   AND m20.m20_exchange_code_m01 = u07_map.exchange_code(+)
                   AND m20_map.new_symbol_id = m20.m20_id(+)
                   AND m137.m137_poa = u47_map.old_poa_id(+)
                   AND m137.m137_customer_id = u47_map.old_customer_id(+)
                   AND m175.m175_created_by = u17_created.old_employee_id(+)
                   AND m175.m175_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m175.m175_id = u55_map.old_poa_sym_restrict_id(+))
    LOOP
        BEGIN
            IF i.new_trading_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Trading Account Not Available',
                                         TRUE);
            END IF;

            IF i.new_power_of_attorney_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Power of Attorney Not Available',
                                         TRUE);
            END IF;

            IF i.new_symbol_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Symbol Not Available',
                                         TRUE);
            END IF;

            IF i.new_poa_sym_restrict_id IS NULL
            THEN
                l_poa_sym_restriction_id := l_poa_sym_restriction_id + 1;

                INSERT
                  INTO dfn_ntp.u55_poa_symbol_restrictions (
                           u55_id,
                           u55_poa_id_u47,
                           u55_symbol_id_m20,
                           u55_trading_account_id_u07,
                           u55_buy_restrict,
                           u55_sell_restrict,
                           u55_status_id_v01,
                           u55_created_by_id_u17,
                           u55_modified_by_id_u17,
                           u55_created_date,
                           u55_modified_date,
                           u55_status_changed_date,
                           u55_symbol_code_m20,
                           u55_status_changed_by_id_u17,
                           u55_custom_type)
                VALUES (l_poa_sym_restriction_id, -- u47_id
                        i.new_power_of_attorney_id, -- u55_poa_id_u47
                        i.new_symbol_id, -- u55_symbol_id_m20
                        i.new_trading_account_id, -- u55_trading_account_id_u07
                        i.m175_sell, -- u55_buy_restrict
                        i.m175_buy, -- u55_sell_restrict
                        i.map01_ntp_id, -- u55_status_id_v01
                        i.created_by_new_id, -- u55_created_by_id_u17
                        i.modifed_by_new_id, -- u55_modified_by_id_u17
                        i.created_date, -- u55_created_date
                        i.modified_date, -- u55_modified_date
                        SYSDATE, -- u55_status_changed_date
                        i.m20_symbol_code, -- u55_symbol_code_m20
                        0, -- u55_status_changed_by_id_u17
                        '1' -- u55_custom_type
                           );

                INSERT INTO u55_poa_sym_restrict_mappings
                     VALUES (i.m175_id, l_poa_sym_restriction_id);
            ELSE
                UPDATE dfn_ntp.u55_poa_symbol_restrictions
                   SET u55_poa_id_u47 = i.new_power_of_attorney_id, -- u55_poa_id_u47
                       u55_symbol_id_m20 = i.new_symbol_id, -- u55_symbol_id_m20
                       u55_trading_account_id_u07 = i.new_trading_account_id, -- u55_trading_account_id_u07
                       u55_buy_restrict = i.m175_sell, -- u55_buy_restrict
                       u55_sell_restrict = i.m175_buy, -- u55_sell_restrict
                       u55_status_id_v01 = i.map01_ntp_id, -- u55_status_id_v01
                       u55_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- u55_modified_by_id_u17
                       u55_modified_date = NVL (i.modified_date, SYSDATE), -- u55_modified_date
                       u55_symbol_code_m20 = i.m20_symbol_code -- u55_symbol_code_m20
                 WHERE u55_id = i.new_poa_sym_restrict_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U55_POA_SYMBOL_RESTRICTIONS',
                                i.m175_id,
                                CASE
                                    WHEN i.new_poa_sym_restrict_id IS NULL
                                    THEN
                                        l_poa_sym_restriction_id
                                    ELSE
                                        i.new_poa_sym_restrict_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_poa_sym_restrict_id IS NULL
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
