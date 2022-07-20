DECLARE
    l_bnk_acc_id   NUMBER;
    l_sqlerrm      VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m93_id), 0)
      INTO l_bnk_acc_id
      FROM dfn_ntp.m93_bank_accounts;

    DELETE FROM error_log
          WHERE mig_table = 'M93_BANK_ACCOUNTS';

    FOR i
        IN (SELECT t14.t14_account_id,
                   CASE
                       WHEN t14.t14_account_type = 0 THEN 1
                       WHEN t14.t14_account_type = 1 THEN 2
                       WHEN t14.t14_account_type = 2 THEN 5
                       WHEN t14.t14_account_type = 3 THEN 3
                       WHEN t14.t14_account_type = 4 THEN 4
                       ELSE 1
                   END
                       AS account_type,
                   m16_map.new_bank_id,
                   t14.t14_accountno,
                   t14.t14_acc_name,
                   t14.t14_acc_address_1,
                   t14.t14_acc_address_2,
                   m03.m03_id,
                   t14.t14_branch_name,
                   t14.t14_conact_name,
                   t14.t14_conatt_nos,
                   t14.t14_iban_no,
                   t14.t14_bban_no,
                   t14.t14_online_trans_type,
                   t14.t14_allow_deposit,
                   t14.t14_allow_withdraw,
                   t14.t14_allow_charge,
                   t14.t14_allow_refund,
                   t14.t14_balance,
                   t14.t14_blocked_amount,
                   t14.t14_od_limit,
                   m02_map.new_institute_id,
                   t14.t14_stp_account,
                   t14.t14_stp_acc_rank,
                   t14.t14_acc_country, -- Text Value
                   t14.t14_is_default,
                   map01.map01_ntp_id,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (t14.t14_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   t14.t14_modified_date AS modified_date,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (t14.t14_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   t14.t14_currency,
                   m93_map.new_bank_accounts_id,
                   CASE
                       WHEN t14.t14_eod_settle_ac_type = 0 THEN 0
                       WHEN t14.t14_eod_settle_ac_type = 9 THEN 1
                       WHEN t14.t14_eod_settle_ac_type = 10 THEN 2
                       WHEN t14.t14_eod_settle_ac_type = 11 THEN 3
                   END
                       AS eod_settle_ac_type
              FROM mubasher_oms.t14_bank_accounts@mubasher_db_link t14,
                   map01_approval_status_v01 map01,
                   dfn_ntp.m03_currency m03,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m16_bank_mappings m16_map,
                   m02_institute_mappings m02_map,
                   m93_bank_accounts_mappings m93_map
             WHERE     t14.t14_currency = m03.m03_code
                   AND t14.t14_bank_id = m16_map.old_bank_id
                   AND m02_map.old_institute_id = t14.t14_institution_id
                   AND t14.t14_created_by = u17_created.old_employee_id(+)
                   AND t14.t14_modified_by = u17_modified.old_employee_id(+)
                   AND t14.t14_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND t14.t14_status_id = map01.map01_oms_id
                   AND t14.t14_account_id = m93_map.old_bank_accounts_id(+))
    LOOP
        BEGIN
            IF i.new_bank_accounts_id IS NULL
            THEN
                l_bnk_acc_id := l_bnk_acc_id + 1;

                INSERT
                  INTO dfn_ntp.m93_bank_accounts (
                           m93_id,
                           m93_account_type_id_v01,
                           m93_bank_id_m16,
                           m93_accountno,
                           m93_acc_owner_name,
                           m93_acc_address_1,
                           m93_acc_address_2,
                           m93_currency_id_m03,
                           m93_branch_name,
                           m93_contact_name,
                           m93_contact_numbers,
                           m93_iban_no,
                           m93_bban_no,
                           m93_online_trans_type_id_v01,
                           m93_allow_deposit,
                           m93_allow_withdraw,
                           m93_allow_charge,
                           m93_allow_refund,
                           m93_balance,
                           m93_blocked_amount,
                           m93_od_limit,
                           m93_institution_id_m02,
                           m93_stp_account,
                           m93_stp_acc_rank,
                           m93_acc_country,
                           m93_is_default_omnibus,
                           m93_is_visible,
                           m93_online_trans_fee,
                           m93_status_id_v01,
                           m93_created_by_id_u17,
                           m93_created_date,
                           m93_modified_by_id_u17,
                           m93_modified_date,
                           m93_status_changed_by_id_u17,
                           m93_status_changed_date,
                           m93_currency_code_m03,
                           m93_custom_type,
                           m93_eod_settle_ac_type_id_v01)
                VALUES (l_bnk_acc_id, -- m93_id
                        i.account_type, -- m93_account_type_id_v01
                        i.new_bank_id, -- m93_bank_id_m16
                        i.t14_accountno, -- m93_accountno
                        i.t14_acc_name, -- m93_acc_owner_name
                        i.t14_acc_address_1, -- m93_acc_address_1
                        i.t14_acc_address_2, -- m93_acc_address_2
                        i.m03_id, -- m93_currency_id_m03
                        i.t14_branch_name, -- m93_branch_name
                        i.t14_conact_name, -- m93_contact_name
                        i.t14_conatt_nos, -- m93_contact_numbers
                        i.t14_iban_no, -- m93_iban_no
                        i.t14_bban_no, -- m93_bban_no
                        i.t14_online_trans_type, --m93_online_trans_type_id_v01
                        i.t14_allow_deposit, -- m93_allow_deposit
                        i.t14_allow_withdraw, -- m93_allow_withdraw
                        i.t14_allow_charge, -- m93_allow_charge
                        i.t14_allow_refund, -- m93_allow_refund
                        i.t14_balance, -- m93_balance
                        i.t14_blocked_amount, -- m93_blocked_amount
                        i.t14_od_limit, -- m93_od_limit
                        i.new_institute_id, -- m93_institution_id_m02
                        i.t14_stp_account, -- m93_stp_account
                        i.t14_stp_acc_rank, -- m93_stp_acc_rank
                        i.t14_acc_country, -- m93_acc_country
                        i.t14_is_default, -- m93_is_default_omnibus
                        1, -- m93_is_visible | Not Available
                        0, -- m93_online_trans_fee
                        i.map01_ntp_id, -- m93_status_id_v01
                        i.created_by_new_id, -- m93_created_by_id_u17
                        i.created_date, -- m93_created_date
                        i.modifed_by_new_id, -- m93_modified_by_id_u17
                        i.modified_date, -- m93_modified_date
                        i.status_changed_by_new_id, -- m93_status_changed_by_id_u17
                        i.status_changed_date, -- m93_status_changed_date
                        i.t14_currency, -- m93_currency_code_m03
                        '1', -- m93_custom_type
                        i.eod_settle_ac_type -- m93_eod_settle_ac_type_id_v01
                                            );

                INSERT INTO m93_bank_accounts_mappings
                     VALUES (i.t14_account_id, l_bnk_acc_id);
            ELSE
                UPDATE dfn_ntp.m93_bank_accounts
                   SET m93_account_type_id_v01 = i.account_type, -- m93_account_type_id_v01
                       m93_bank_id_m16 = i.new_bank_id, -- m93_bank_id_m16
                       m93_accountno = i.t14_accountno, -- m93_accountno
                       m93_acc_owner_name = i.t14_acc_name, -- m93_acc_owner_name
                       m93_acc_address_1 = i.t14_acc_address_1, -- m93_acc_address_1
                       m93_acc_address_2 = i.t14_acc_address_2, -- m93_acc_address_2
                       m93_currency_id_m03 = i.m03_id, -- m93_currency_id_m03
                       m93_branch_name = i.t14_branch_name, -- m93_branch_name
                       m93_contact_name = i.t14_conact_name, -- m93_contact_name
                       m93_contact_numbers = i.t14_conatt_nos, -- m93_contact_numbers
                       m93_iban_no = i.t14_iban_no, -- m93_iban_no
                       m93_bban_no = i.t14_bban_no, -- m93_bban_no
                       m93_online_trans_type_id_v01 = i.t14_online_trans_type, --m93_online_trans_type_id_v01
                       m93_allow_deposit = i.t14_allow_deposit, -- m93_allow_deposit
                       m93_allow_withdraw = i.t14_allow_withdraw, -- m93_allow_withdraw
                       m93_allow_charge = i.t14_allow_charge, -- m93_allow_charge
                       m93_allow_refund = i.t14_allow_refund, -- m93_allow_refund
                       m93_balance = i.t14_balance, -- m93_balance
                       m93_blocked_amount = i.t14_blocked_amount, -- m93_blocked_amount
                       m93_od_limit = i.t14_od_limit, -- m93_od_limit
                       m93_institution_id_m02 = i.new_institute_id, -- m93_institution_id_m02
                       m93_stp_account = i.t14_stp_account, -- m93_stp_account
                       m93_stp_acc_rank = i.t14_stp_acc_rank, -- m93_stp_acc_rank
                       m93_acc_country = i.t14_acc_country, -- m93_acc_country
                       m93_is_default_omnibus = i.t14_is_default, -- m93_is_default_omnibus
                       m93_status_id_v01 = i.map01_ntp_id, -- m93_status_id_v01
                       m93_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m93_modified_by_id_u17
                       m93_modified_date = NVL (i.modified_date, SYSDATE), -- m93_modified_date
                       m93_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m93_status_changed_by_id_u17
                       m93_status_changed_date = i.status_changed_date, -- m93_status_changed_date
                       m93_currency_code_m03 = i.t14_currency, -- m93_currency_code_m03
                       m93_eod_settle_ac_type_id_v01 = i.eod_settle_ac_type -- m93_eod_settle_ac_type_id_v01
                 WHERE m93_id = i.new_bank_accounts_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M93_BANK_ACCOUNTS',
                                i.t14_account_id,
                                CASE
                                    WHEN i.new_bank_accounts_id IS NULL
                                    THEN
                                        l_bnk_acc_id
                                    ELSE
                                        i.new_bank_accounts_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_bank_accounts_id IS NULL
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
