DECLARE
    l_login_cash_acc_id   NUMBER;
    l_sqlerrm             VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (u30_id), 0)
      INTO l_login_cash_acc_id
      FROM dfn_ntp.u30_login_cash_acc;

    DELETE FROM error_log
          WHERE mig_table = 'U30_LOGIN_CASH_ACC';

    FOR i
        IN (SELECT u09.u09_id,
                   u06.u06_id,
                   u06.u06_pending_restriction,
                   u30.u30_id
              FROM dfn_ntp.u06_cash_account u06,
                   dfn_ntp.u01_customer u01,
                   dfn_ntp.u09_customer_login u09,
                   dfn_ntp.u30_login_cash_acc u30
             WHERE     u06_customer_id_u01 = u01.u01_id
                   AND u01.u01_id = u09.u09_customer_id_u01
                   AND u09.u09_id = u30.u30_login_id_u09(+)
                   AND u06.u06_id = u30.u30_cash_acc_id_u06(+))
    LOOP
        BEGIN
            IF i.u30_id IS NULL
            THEN
                l_login_cash_acc_id := l_login_cash_acc_id + 1;

                INSERT
                  INTO dfn_ntp.u30_login_cash_acc (
                           u30_id,
                           u30_login_id_u09,
                           u30_cash_acc_id_u06,
                           u30_created_by_id_u17,
                           u30_created_date,
                           u30_deposit,
                           u30_withdraw,
                           u30_transfer,
                           u30_pending_restriction,
                           u30_custom_type,
                           u30_status_id_v01,
                           u30_status_changed_by_id_u17,
                           u30_status_changed_date)
                VALUES (l_login_cash_acc_id, -- u30_id
                        i.u09_id, -- u30_login_id_u09
                        i.u06_id, -- u30_cash_acc_id_u06
                        0, -- u30_created_by_id_u17,
                        SYSDATE, -- u30_created_date
                        0, -- u30_deposit | Updating in the Post Migration Script
                        0, -- u30_withdraw | Updating in the Post Migration Script
                        0, -- u30_transfer | Updating in the Post Migration Script
                        i.u06_pending_restriction, -- u30_pending_restriction
                        '1', -- u30_custom_type
                        2, -- u30_status_id_v01
                        0, -- u30_status_changed_by_id_u17
                        SYSDATE -- u30_status_changed_date
                               );
            ELSE
                UPDATE dfn_ntp.u30_login_cash_acc
                   SET u30_pending_restriction = i.u06_pending_restriction -- u30_pending_restriction
                 WHERE u30_id = i.u30_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U30_LOGIN_CASH_ACC',
                                   'Login Id : '
                                || i.u09_id
                                || ' Cash Account Id : '
                                || i.u06_id,
                                CASE
                                    WHEN i.u30_id IS NULL
                                    THEN
                                        l_login_cash_acc_id
                                    ELSE
                                        i.u30_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.u30_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
