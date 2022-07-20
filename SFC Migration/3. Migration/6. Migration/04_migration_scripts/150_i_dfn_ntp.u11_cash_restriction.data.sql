DECLARE
    l_cash_restriction_id   NUMBER;
    l_sqlerrm               VARCHAR2 (4000);

    l_rec_cnt               NUMBER := 0;
BEGIN
    SELECT NVL (MAX (u11_id), 0)
      INTO l_cash_restriction_id
      FROM dfn_ntp.u11_cash_restriction;

    DELETE FROM error_log
          WHERE mig_table = 'U11_CASH_RESTRICTION';

    FOR i
        IN (SELECT u06_map.new_cash_account_id,
                   restriction.restriction,
                   restriction.narration,
                   u11.u11_id
              FROM (SELECT t03.t03_account_id, --Withdraw
                           10 AS restriction,
                           NULL AS narration
                      FROM mubasher_oms.t03_cash_account@mubasher_db_link t03
                     WHERE t03_transaction_restriction IN (1, 3)
                    UNION ALL
                    SELECT t03.t03_account_id,
                           9 AS restriction, --Deposit
                           NULL AS narration
                      FROM mubasher_oms.t03_cash_account@mubasher_db_link t03
                     WHERE t03_transaction_restriction IN (2, 3)
                    UNION ALL --Currently Offline & Online Restrictions Considered as a Cash Transfer Disabled
                    SELECT t03.t03_account_id,
                           11 AS restriction,
                           t03.t03_online_withdraw_dis_reason AS narration
                      FROM mubasher_oms.t03_cash_account@mubasher_db_link t03
                     WHERE t03.t03_online_withdraw_enabled = 0) restriction,
                   u06_cash_account_mappings u06_map,
                   dfn_ntp.u11_cash_restriction u11
             WHERE     restriction.t03_account_id =
                           u06_map.old_cash_account_id(+)
                   AND restriction.restriction =
                           u11_restriction_type_id_v31(+)
                   AND u06_map.new_cash_account_id =
                           u11_cash_account_id_u06(+))
    LOOP
        BEGIN
            IF i.new_cash_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Cash Account Invaild',
                                         TRUE);
            END IF;

            IF i.u11_id IS NULL
            THEN
                l_cash_restriction_id := l_cash_restriction_id + 1;

                INSERT
                  INTO dfn_ntp.u11_cash_restriction (
                           u11_id,
                           u11_restriction_type_id_v31,
                           u11_cash_account_id_u06,
                           u11_narration,
                           u11_narration_lang,
                           u11_restriction_source,
                           u11_custom_type)
                VALUES (l_cash_restriction_id, -- u11_id
                        i.restriction, -- u11_restriction_type_id_v31
                        i.new_cash_account_id, -- u11_cash_account_id_u06
                        i.narration, -- u11_narration
                        i.narration, -- u11_narration_lang
                        0, -- u11_restriction_source | 0 - Manual
                        '1' -- u11_custom_type
                           );
            ELSE
                UPDATE dfn_ntp.u11_cash_restriction
                   SET u11_narration = i.narration, -- u11_narration
                       u11_narration_lang = i.narration -- u11_narration_lang
                 WHERE u11_id = i.u11_id;
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
                                'U11_CASH_RESTRICTION',
                                   'Cash Account Id : '
                                || i.new_cash_account_id
                                || ' - '
                                || 'Restriction Id : '
                                || i.restriction,
                                CASE
                                    WHEN i.u11_id IS NULL
                                    THEN
                                        l_cash_restriction_id
                                    ELSE
                                        i.u11_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.u11_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
