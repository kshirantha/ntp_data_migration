DECLARE
    l_login_trading_acc_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (u10_id), 0)
      INTO l_login_trading_acc_id
      FROM dfn_ntp.u10_login_trading_acc;

    DELETE FROM error_log
          WHERE mig_table = 'U10_LOGIN_TRADING_ACC';

    FOR i
        IN (SELECT u09.u09_id,
                   u07.u07_id,
                   u07.u07_pending_restriction,
                   u10.u10_id
              FROM dfn_ntp.u07_trading_account u07,
                   dfn_ntp.u01_customer u01,
                   dfn_ntp.u09_customer_login u09,
                   dfn_ntp.u10_login_trading_acc u10
             WHERE     u07_customer_id_u01 = u01.u01_id
                   AND u01.u01_id = u09.u09_customer_id_u01
                   AND u07.u07_id = u10_trading_acc_id_u07(+)
                   AND u09.u09_id = u10_login_id_u09(+))
    LOOP
        BEGIN
            IF i.u10_id IS NULL
            THEN
                l_login_trading_acc_id := l_login_trading_acc_id + 1;

                INSERT
                  INTO dfn_ntp.u10_login_trading_acc (
                           u10_id,
                           u10_login_id_u09,
                           u10_trading_acc_id_u07,
                           u10_created_by_id_u17,
                           u10_created_date,
                           u10_buy,
                           u10_sell,
                           u10_deposit,
                           u10_withdraw,
                           u10_transfer,
                           u10_pending_restriction,
                           u10_custom_type,
                           u10_status_id_v01,
                           u10_status_changed_by_id_u17,
                           u10_status_changed_date)
                VALUES (l_login_trading_acc_id, -- u10_id
                        i.u09_id, -- u10_login_id_u09
                        i.u07_id, -- u10_trading_acc_id_u07
                        0, -- u10_created_by_id_u17
                        SYSDATE, -- u10_created_date
                        0, -- u10_buy | Updating in the Post Migration Script
                        0, -- u10_sell | Updating in the Post Migration Script
                        0, -- u10_deposit | Updating in the Post Migration Script
                        0, -- u10_withdraw | Updating in the Post Migration Script
                        0, -- u10_transfer | Updating in the Post Migration Script
                        i.u07_pending_restriction, -- u10_pending_restriction
                        '1', -- u10_custom_type
                        2, -- u10_status_id_v01
                        0, -- u10_status_changed_by_id_u17
                        SYSDATE -- u10_status_changed_date
                               );
            ELSE
                UPDATE dfn_ntp.u10_login_trading_acc
                   SET u10_pending_restriction = i.u07_pending_restriction -- u10_pending_restriction
                 WHERE u10_id = i.u10_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U10_LOGIN_TRADING_ACC',
                                   'Login Id : '
                                || i.u09_id
                                || ' Trading Account Id : '
                                || i.u07_id,
                                CASE
                                    WHEN i.u10_id IS NULL
                                    THEN
                                        l_login_trading_acc_id
                                    ELSE
                                        i.u10_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.u10_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
