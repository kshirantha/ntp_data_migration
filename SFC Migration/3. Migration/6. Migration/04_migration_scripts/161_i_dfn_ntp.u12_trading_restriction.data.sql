DECLARE
    l_trading_restriction_id   NUMBER;
    l_sqlerrm                  VARCHAR2 (4000);

    l_rec_cnt                  NUMBER := 0;
BEGIN
    SELECT NVL (MAX (u12_id), 0)
      INTO l_trading_restriction_id
      FROM dfn_ntp.u12_trading_restriction;

    DELETE FROM error_log
          WHERE mig_table = 'U12_TRADING_RESTRICTION';

    FOR i
        IN (SELECT restriction.new_trading_account_id,
                   restriction.restriction,
                   u12.u12_id
              FROM (SELECT u07_map.new_trading_account_id,
                           old_restrictions.restriction
                      FROM (  SELECT u06_security_ac_id, restriction
                                FROM (  SELECT u06.u06_security_ac_id, -- Buy
                                               1 AS restriction
                                          FROM mubasher_oms.u06_routing_accounts@mubasher_db_link u06,
                                               mubasher_oms.u05_security_accounts@mubasher_db_link u05
                                         WHERE     u06.u06_security_ac_id =
                                                       u05.u05_id
                                               AND (   u06.u06_trading_restriction IN
                                                           (1, 3)
                                                    OR u05.u05_restrict_entire_account =
                                                           1)
                                      GROUP BY u06.u06_security_ac_id
                                      UNION ALL -- Sell
                                      SELECT u06.u06_security_ac_id,
                                             2 AS restriction
                                        FROM mubasher_oms.u06_routing_accounts@mubasher_db_link u06,
                                             mubasher_oms.u05_security_accounts@mubasher_db_link u05
                                       WHERE     u06.u06_security_ac_id =
                                                     u05.u05_id
                                             AND (   u06.u06_trading_restriction IN
                                                         (2, 3)
                                                  OR u05.u05_restrict_entire_account =
                                                         1)
                                      UNION ALL
                                      SELECT u05.u05_id, -- Stock Withdraw
                                                        7 AS restriction
                                        FROM mubasher_oms.u05_security_accounts@mubasher_db_link u05
                                       WHERE    u05.u05_restrict_entire_account =
                                                    1
                                             OR u05.u05_stock_transfer_restriction IN
                                                    (1, 3)
                                      UNION ALL
                                      SELECT u05.u05_id, -- Stock Deposit
                                                        6 AS restriction
                                        FROM mubasher_oms.u05_security_accounts@mubasher_db_link u05
                                       WHERE    u05.u05_restrict_entire_account =
                                                    1
                                             OR u05.u05_stock_transfer_restriction IN
                                                    (2, 3)
                                      UNION ALL
                                      SELECT u05.u05_id, -- Pledge In
                                                        18 AS restriction
                                        FROM mubasher_oms.u05_security_accounts@mubasher_db_link u05
                                       WHERE u05.u05_restrict_entire_account =
                                                 1
                                      UNION ALL
                                      SELECT u05.u05_id, -- Pledge Out
                                                        19 AS restriction
                                        FROM mubasher_oms.u05_security_accounts@mubasher_db_link u05
                                       WHERE u05.u05_restrict_entire_account =
                                                 1)
                            GROUP BY u06_security_ac_id, restriction) old_restrictions,
                           u07_trading_account_mappings u07_map
                     WHERE old_restrictions.u06_security_ac_id =
                               u07_map.old_trading_account_id -- For All Exchanges
                                                             ) restriction,
                   dfn_ntp.u12_trading_restriction u12
             WHERE     restriction.new_trading_account_id =
                           u12.u12_trading_account_id_u07(+)
                   AND restriction.restriction =
                           u12.u12_restriction_type_id_v31(+))
    LOOP
        BEGIN
            IF i.u12_id IS NULL
            THEN
                l_trading_restriction_id := l_trading_restriction_id + 1;

                INSERT
                  INTO dfn_ntp.u12_trading_restriction (
                           u12_id,
                           u12_restriction_type_id_v31,
                           u12_trading_account_id_u07,
                           u12_narration,
                           u12_narration_lang,
                           u12_restriction_source,
                           u12_custom_type)
                VALUES (l_trading_restriction_id, -- u12_id
                        i.restriction, -- u12_restriction_type_id_v31
                        i.new_trading_account_id, -- u12_trading_account_id_u07
                        NULL, -- u12_narration
                        NULL, -- u12_narration_lang
                        0, -- u12_restriction_source | 0 - Manual
                        '1' -- u12_custom_type
                           );
            ELSE
                UPDATE dfn_ntp.u12_trading_restriction
                   SET u12_restriction_type_id_v31 = i.restriction -- u12_restriction_type_id_v31
                 WHERE u12_id = i.u12_id;
            END IF;

            l_rec_cnt := l_rec_cnt + 1;

            IF MOD (l_rec_cnt, 25000) = 0
            THEN
                COMMIT;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U12_TRADING_RESTRICTION',
                                   'Trading Account : '
                                || i.new_trading_account_id
                                || ' | Restriction : '
                                || i.restriction,
                                CASE
                                    WHEN i.u12_id IS NULL
                                    THEN
                                        l_trading_restriction_id
                                    ELSE
                                        i.u12_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.u12_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
