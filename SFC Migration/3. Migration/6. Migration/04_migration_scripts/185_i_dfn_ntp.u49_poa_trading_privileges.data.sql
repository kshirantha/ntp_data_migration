DECLARE
    l_poa_trd_privileges_id   NUMBER;
    l_log_id                  NUMBER;
    l_sqlerrm                 VARCHAR2 (4000);
    l_table                   VARCHAR2 (100);
    l_source_key              NUMBER;
BEGIN
    SELECT NVL (MAX (u49_id), 0)
      INTO l_poa_trd_privileges_id
      FROM dfn_ntp.u49_poa_trading_privileges;

    -- Delete All Logs as Not Migrated but Generated for Every Previlege

    DELETE FROM dfn_ntp.u52_poa_trad_privilege_pending;

    SELECT NVL (MAX (u52_id), 0)
      INTO l_log_id
      FROM dfn_ntp.u52_poa_trad_privilege_pending;

    DELETE FROM error_log
          WHERE mig_table IN
                    ('U49_POA_TRADING_PRIVILEGES',
                     'U52_POA_TRAD_PRIVILEGE_PENDING');

    FOR i
        IN (SELECT u47_map.new_power_of_attorney_id,
                   u07_map.new_trading_account_id,
                   poa_prvlgs.m137_poa_setdate,
                   poa_prvlgs.m137_poa_expiry_date,
                   poa_prvlgs.u49_privilege_type_id_v31,
                   u49.u49_id,
                   CASE
                       WHEN TRUNC (poa_prvlgs.m137_poa_expiry_date) >
                                TRUNC (SYSDATE)
                       THEN
                           1
                       ELSE
                           0
                   END
                       AS is_active
              FROM (SELECT m137_poa,
                           m137_customer_id,
                           m137_security_ac_id,
                           m137_poa_setdate,
                           m137_poa_expiry_date,
                           20 AS u49_privilege_type_id_v31 -- Buy
                      FROM mubasher_oms.m137_customer_poa@mubasher_db_link
                     WHERE m137_applicable_for_buy = 1
                    UNION ALL
                    SELECT m137_poa,
                           m137_customer_id,
                           m137_security_ac_id,
                           m137_poa_setdate,
                           m137_poa_expiry_date,
                           21 AS u49_privilege_type_id_v31 -- Sell
                      FROM mubasher_oms.m137_customer_poa@mubasher_db_link
                     WHERE m137_applicable_for_sell = 1
                    UNION ALL
                    SELECT m137_poa,
                           m137_customer_id,
                           m137_security_ac_id,
                           m137_poa_setdate,
                           m137_poa_expiry_date,
                           24 AS u49_privilege_type_id_v31 -- Cash Withdraw
                      FROM mubasher_oms.m137_customer_poa@mubasher_db_link
                     WHERE m137_applicable_for_trans = 1
                    UNION ALL
                    SELECT m137_poa,
                           m137_customer_id,
                           m137_security_ac_id,
                           m137_poa_setdate,
                           m137_poa_expiry_date,
                           25 AS u49_privilege_type_id_v31 -- Cash Transfer
                      FROM mubasher_oms.m137_customer_poa@mubasher_db_link
                     WHERE m137_applicable_for_trans = 1) poa_prvlgs,
                   u07_trading_account_mappings u07_map,
                   u47_power_of_attorney_mappings u47_map,
                   dfn_ntp.u49_poa_trading_privileges u49
             WHERE     poa_prvlgs.m137_security_ac_id =
                           u07_map.old_trading_account_id(+) -- Repeating for Assigned All Exchanges as Mapped Exchange Not Available
                   AND poa_prvlgs.m137_poa = u47_map.old_poa_id(+)
                   AND poa_prvlgs.m137_customer_id =
                           u47_map.old_customer_id(+)
                   AND u47_map.new_power_of_attorney_id = u49.u49_id(+)
                   AND u07_map.new_trading_account_id =
                           u49.u49_trading_account_id_u07(+)
                   AND poa_prvlgs.u49_privilege_type_id_v31 =
                           u49.u49_privilege_type_id_v31(+))
    LOOP
        BEGIN
            IF i.new_trading_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Security Account Not Available',
                                         TRUE);
            END IF;

            IF i.u49_id IS NULL
            THEN
                l_poa_trd_privileges_id := l_poa_trd_privileges_id + 1;
                l_table := 'U49_POA_TRADING_PRIVILEGES';
                l_source_key := l_poa_trd_privileges_id;

                INSERT
                  INTO dfn_ntp.u49_poa_trading_privileges (
                           u49_id,
                           u49_poa_id_u47,
                           u49_trading_account_id_u07,
                           u49_privilege_type_id_v31,
                           u49_narration,
                           u49_narration_lang,
                           u49_issue_date,
                           u49_poa_expiry_date,
                           u49_is_active,
                           u49_custom_type)
                VALUES (l_poa_trd_privileges_id, -- u49_id
                        i.new_power_of_attorney_id, -- u49_poa_id_u47
                        i.new_trading_account_id, -- u49_trading_account_id_u07
                        i.u49_privilege_type_id_v31, -- u49_privilege_type_id_v31
                        NULL, -- u49_narration
                        NULL, -- u49_narration_lang
                        i.m137_poa_setdate, -- u49_issue_date
                        i.m137_poa_expiry_date, -- u49_poa_expiry_date
                        i.is_active, -- u49_is_active
                        1 -- u49_custom_type
                         );
            ELSE
                UPDATE dfn_ntp.u49_poa_trading_privileges
                   SET u49_issue_date = i.m137_poa_setdate, -- u49_issue_date
                       u49_poa_expiry_date = i.m137_poa_expiry_date, -- u49_poa_expiry_date
                       u49_is_active = i.is_active -- u49_is_active
                 WHERE u49_id = i.u49_id;
            END IF;

            -- Every POA Trading Privilege Gets Approved Request Entry

            l_log_id := l_log_id + 1;
            l_table := 'U52_POA_TRAD_PRIVILEGE_PENDING';
            l_source_key := l_log_id;

            INSERT
              INTO dfn_ntp.u52_poa_trad_privilege_pending (
                       u52_id,
                       u52_poa_id_u47,
                       u52_trading_account_id_u07,
                       u52_status_id_v01,
                       u52_status_changed_by_id_u17,
                       u52_status_changed_date,
                       u52_custom_type)
            VALUES (l_log_id, -- u52_id
                    i.new_power_of_attorney_id, -- u52_poa_id_u47
                    i.new_trading_account_id, -- u52_trading_account_id_u07
                    2, -- u52_status_id_v01
                    0, -- u52_status_changed_by_id_u17
                    SYSDATE, -- u52_status_changed_date
                    '1' -- u52_custom_type
                       );
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                l_table,
                                l_source_key,
                                CASE
                                    WHEN i.u49_id IS NULL THEN l_source_key
                                    ELSE i.u49_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.u49_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/