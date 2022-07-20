DECLARE
    SQLERRM   VARCHAR2 (4000);
BEGIN
    DELETE FROM error_log
          WHERE mig_table = 'H09_CASH_ACCOUNT_UPDATE';

    FOR i
        IN (SELECT u06_map.new_cash_account_id,
                   a09.a09_investor_acc_no,
                   u01_map.new_customer_id,
                   a09.a09_account_balance,
                   a09.a09_date,
                   h09.h09_cash_acc_id_u06,
                   h09.h09_client_id_u01
              FROM mubasher_oms.a09_cash_account_update@mubasher_db_link a09,
                   u06_cash_account_mappings u06_map,
                   u01_customer_mappings u01_map,
                   dfn_ntp.h09_cash_account_update h09
             WHERE     a09.a09_cassh_acc_id = u06_map.old_cash_account_id
                   AND a09.a09_client_id = u01_map.old_customer_id
                   AND u06_map.new_cash_account_id =
                           h09.h09_cash_acc_id_u06(+)
                   AND u01_map.new_customer_id = h09.h09_client_id_u01(+))
    LOOP
        BEGIN
            IF     i.h09_cash_acc_id_u06 IS NOT NULL
               AND i.h09_client_id_u01 IS NOT NULL
            THEN
                UPDATE dfn_ntp.h09_cash_account_update
                   SET h09_investor_acc_no = i.a09_investor_acc_no, -- h09_investor_acc_no
                       h09_account_balance = i.a09_account_balance, -- h09_account_balance
                       h09_date = i.a09_date -- h09_date
                 WHERE     h09_cash_acc_id_u06 = i.h09_cash_acc_id_u06
                       AND h09_client_id_u01 = i.h09_client_id_u01;
            ELSE
                INSERT
                  INTO dfn_ntp.h09_cash_account_update (h09_cash_acc_id_u06,
                                                        h09_investor_acc_no,
                                                        h09_client_id_u01,
                                                        h09_account_balance,
                                                        h09_date)
                VALUES (i.new_cash_account_id, -- h09_cash_acc_id_u06
                        i.a09_investor_acc_no, -- h09_investor_acc_no
                        i.new_customer_id, -- h09_client_id_u01
                        i.a09_account_balance, -- h09_account_balance
                        i.a09_date -- h09_date
                                  );
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'H09_CASH_ACCOUNT_UPDATE',
                                'Account no - ' || h09_investor_acc_no,
                                CASE
                                    WHEN     i.h09_cash_acc_id_u06
                                                 IS NOT NULL
                                         AND i.h09_client_id_u01 IS NOT NULL
                                    THEN
                                           'Cash Acc Id : '
                                        || i.new_cash_account_id
                                        || ' - '
                                        || 'Client Id : '
                                        || i.h09_client_id_u01
                                    ELSE
                                           'Cash Acc Id : '
                                        || i.u04_channel_id
                                        || ' - '
                                        || 'Client Id : '
                                        || i.new_customer_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN     i.h09_cash_acc_id_u06
                                                 IS NOT NULL
                                         AND i.h09_client_id_u01 IS NOT NULL
                                    THEN
                                        'UPDATE'
                                    ELSE
                                        'INSERT'
                                END,
                                l_sqlerrm);
        END;
    END LOOP;
END;
/
