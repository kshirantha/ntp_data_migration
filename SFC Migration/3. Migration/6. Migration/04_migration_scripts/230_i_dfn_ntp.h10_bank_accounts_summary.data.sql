DECLARE
    l_sqlerrm   VARCHAR2 (4000);
BEGIN
    DELETE FROM error_log
          WHERE mig_table = 'H10_BANK_ACCOUNTS_SUMMARY';

    FOR i
        IN (SELECT s11_date,
                   m93_map.new_bank_accounts_id,
                   m93.m93_institution_id_m02,
                   s11_accountno,
                   s11_balance,
                   s11_currency,
                   s11_blocked_amount,
                   s11_od_limit,
                   m93_map.old_bank_accounts_id,
                   h10.h10_account_id_m93,
                   h10.h10_institute_id_m02,
                   h10.h10_date
              FROM mubasher_oms.s11_bank_accounts_summary@mubasher_db_link s11,
                   m93_bank_accounts_mappings m93_map,
                   dfn_ntp.m93_bank_accounts m93,
                   dfn_ntp.h10_bank_accounts_summary h10
             WHERE     s11.s11_account_id = m93_map.old_bank_accounts_id(+)
                   AND m93_map.new_bank_accounts_id = m93.m93_id(+)
                   AND m93_map.new_bank_accounts_id =
                           h10.h10_account_id_m93(+)
                   AND m93.m93_institution_id_m02 =
                           h10.h10_institute_id_m02(+)
                   AND s11.s11_date = h10.h10_date(+))
    LOOP
        BEGIN
            IF i.new_bank_accounts_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Bank Account Not Available',
                                         TRUE);
            END IF;

            IF     i.h10_account_id_m93 IS NULL
               AND i.h10_institute_id_m02 IS NULL
               AND i.h10_date IS NULL
            THEN
                INSERT
                  INTO dfn_ntp.h10_bank_accounts_summary (h10_date,
                                                          h10_account_id_m93,
                                                          h10_institute_id_m02,
                                                          h10_account_no,
                                                          h10_balance,
                                                          h10_currency,
                                                          h10_blocked_amount,
                                                          h10_od_limit)
                VALUES (i.s11_date, -- h10_date
                        i.new_bank_accounts_id, -- h10_account_id_m93
                        i.m93_institution_id_m02, -- h10_institute_id_m02
                        i.s11_accountno, -- h10_account_no
                        i.s11_balance, -- h10_balance
                        i.s11_currency, -- h10_currency
                        i.s11_blocked_amount, -- h10_blocked_amount
                        i.s11_od_limit --h 10_od_limit
                                      );
            ELSE
                UPDATE dfn_ntp.h10_bank_accounts_summary
                   SET h10_account_no = i.s11_accountno, -- h10_account_no
                       h10_balance = i.s11_balance, -- h10_balance
                       h10_currency = i.s11_currency, -- h10_currency
                       h10_blocked_amount = i.s11_blocked_amount, -- h10_blocked_amount
                       h10_od_limit = i.s11_od_limit -- h10_od_limit
                 WHERE     h10_account_id_m93 = i.h10_account_id_m93
                       AND h10_institute_id_m02 = i.h10_institute_id_m02
                       AND h10_date = i.s11_date;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'H10_BANK_ACCOUNTS_SUMMARY',
                                i.old_bank_accounts_id,
                                CASE
                                    WHEN     i.h10_account_id_m93 IS NOT NULL
                                         AND i.h10_institute_id_m02
                                                 IS NOT NULL
                                         AND i.s11_date IS NOT NULL
                                    THEN
                                           'Date : '
                                        || i.s11_date
                                        || ' - '
                                        || 'Account Id : '
                                        || i.h10_account_id_m93
                                        || ' - '
                                        || 'Institute : '
                                        || i.h10_institute_id_m02
                                    ELSE
                                           'Date : '
                                        || i.s11_date
                                        || ' - '
                                        || 'Account Id : '
                                        || i.new_bank_accounts_id
                                        || ' - '
                                        || 'Institute : '
                                        || i.m93_institution_id_m02
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN     i.h10_account_id_m93 IS NOT NULL
                                         AND i.h10_institute_id_m02
                                                 IS NOT NULL
                                         AND i.s11_date IS NOT NULL
                                    THEN
                                        'UPDATE'
                                    ELSE
                                        'INSERT'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
