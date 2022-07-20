DECLARE
    l_sqlerrm   VARCHAR2 (4000);
BEGIN
    DELETE FROM error_log
          WHERE mig_table = 'U59_TRADING_ACC_FIX_LOGINS';

    FOR i
        IN (SELECT u05_id,
                   u05_allowed_fix_channels,
                   m184_id,
                   m67_map.new_fix_logins_id,
                   u07_map.new_trading_account_id,
                   u59.u59_trading_acc_id_u07
              FROM mubasher_oms.u05_security_accounts@mubasher_db_link u05,
                   mubasher_oms.m184_fix_logins@mubasher_db_link m184,
                   m67_fix_logins_mappings m67_map,
                   u07_trading_account_mappings u07_map,
                   dfn_ntp.u59_trading_acc_fix_logins u59
             WHERE     u05.u05_allowed_fix_channels >= 0
                   AND u05.u05_allowed_fix_channels = m184.m184_id(+)
                   AND m184.m184_id = m67_map.old_fix_logins_id(+)
                   AND u05.u05_id = u07_map.old_trading_account_id(+)
                   AND u07_map.new_trading_account_id =
                           u59.u59_trading_acc_id_u07(+)
                   AND m67_map.new_fix_logins_id =
                           u59.u59_fix_login_id_m67(+))
    LOOP
        BEGIN
            IF i.new_trading_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Trading Account Not Available',
                                         TRUE);
            END IF;

            IF i.new_fix_logins_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Fix Login Not Available',
                                         TRUE);
            END IF;

            IF i.u59_trading_acc_id_u07 IS NULL
            THEN
                INSERT
                  INTO dfn_ntp.u59_trading_acc_fix_logins (
                           u59_trading_acc_id_u07,
                           u59_fix_login_id_m67,
                           u59_custom_type)
                VALUES (i.new_trading_account_id, i.new_fix_logins_id, '1');
            ELSE
                NULL; -- Nothing to Update
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U59_TRADING_ACC_FIX_LOGINS',
                                i.m184_id,
                                CASE
                                    WHEN i.u59_trading_acc_id_u07 IS NULL
                                    THEN
                                        i.new_trading_account_id
                                    ELSE
                                        i.u59_trading_acc_id_u07
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.u59_trading_acc_id_u07 IS NULL
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