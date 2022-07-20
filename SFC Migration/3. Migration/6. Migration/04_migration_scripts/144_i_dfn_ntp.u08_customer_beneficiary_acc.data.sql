-- Group By Scenario was Addressd from Onsite

DECLARE
    l_cust_beneficiary_acc_id   NUMBER;
    l_sqlerrm                   VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (u08_id), 0)
      INTO l_cust_beneficiary_acc_id
      FROM dfn_ntp.u08_customer_beneficiary_acc;

    DELETE FROM error_log
          WHERE mig_table = 'U08_CUSTOMER_BENEFICIARY_ACC';

    FOR i IN (  SELECT customer_id,
                       new_bank_id,
                       account_number,
                       bank_account_type,
                       beneficiary_cash_account,
                       MAX (customer_cash_acc) customer_cash_acc,
                       MAX (currency_code) currency_code,
                       MAX (currency_id) currency_id,
                       MAX (old_id) old_id,
                       MAX (institute_id) institute_id,
                       MAX (beneficiary_account_type) beneficiary_account_type,
                       MAX (bank_branch_name) bank_branch_name,
                       MAX (account_name) account_name,
                       MAX (created_by_new_id) created_by_new_id,
                       MAX (created_date) created_date,
                       MAX (map01_ntp_id) map01_ntp_id,
                       MAX (iban_no) iban_no,
                       MAX (is_foreign_bank_acc) is_foreign_bank_acc,
                       MAX (m264_nin) m264_nin,
                       MAX (m264_remarks) m264_remarks,
                       MAX (new_cust_benefcry_acc_id) new_cust_benefcry_acc_id
                  FROM (SELECT m264.m264_id AS old_id,
                               u06.u06_institute_id_m02 AS institute_id,
                               u06.u06_customer_id_u01 AS customer_id,
                               CASE
                                   WHEN m264_type = 0 THEN 1
                                   WHEN m264_type = 1 THEN 2
                                   WHEN m264_type = 2 THEN 3
                                   ELSE NULL
                               END
                                   AS beneficiary_account_type,
                               m16_map.new_bank_id,
                               NVL (m264.m264_account_number, ' ')
                                   AS account_number, -- [Discussed Solution]
                               NULL AS bank_branch_name,
                               NVL (m03.m03_code, u06.u06_currency_code_m03)
                                   AS currency_code, -- [Corrective Actions Discussed]
                               NVL (m03.m03_id, u06.u06_currency_id_m03)
                                   AS currency_id, -- [Corrective Actions Discussed]
                               NVL (m264.m264_account_name,
                                    m264.m264_account_number)
                                   AS account_name,
                               NVL (u17_created_by.new_employee_id, 0)
                                   AS created_by_new_id,
                               NVL (m264.m264_created_date, SYSDATE)
                                   AS created_date,
                               map01.map01_ntp_id,
                               CASE WHEN m264_type IN (2, 3) THEN 3 -- 3 : Investment
                                                                   END
                                   AS bank_account_type,
                               u06.u06_id AS customer_cash_acc,
                               CASE
                                   WHEN m264_type = 0 THEN u06_cash_type.u06_id
                               END
                                   AS beneficiary_cash_account,
                               NULL AS iban_no,
                               NULL AS is_foreign_bank_acc,
                               m264_nin,
                               m264_remarks,
                               u08_map.new_cust_benefcry_acc_id
                          FROM mubasher_oms.m264_beneficiary_accounts@mubasher_db_link m264,
                               u06_cash_account_mappings u06_map,
                               dfn_ntp.u06_cash_account u06,
                               m02_institute_mappings m02_map,
                               dfn_ntp.u06_cash_account u06_cash_type,
                               m16_bank_mappings m16_map,
                               map01_approval_status_v01 map01,
                               dfn_ntp.m03_currency m03,
                               u17_employee_mappings u17_created_by,
                               u08_cust_benefcry_acc_mappings u08_map
                         WHERE     m264.m264_cash_account =
                                       u06_map.old_cash_account_id(+)
                               AND u06_map.new_cash_account_id = u06.u06_id(+)
                               AND u06.u06_institute_id_m02 =
                                       m02_map.new_institute_id
                               AND m264.m264_account_number =
                                       u06_cash_type.u06_display_name(+)
                               AND m264.m264_bank = m16_map.old_bank_id
                               AND m264.m264_currency = m03.m03_code(+)
                               AND m264.m264_status = map01.map01_oms_id
                               AND m264.m264_created_by =
                                       u17_created_by.old_employee_id(+)
                               AND m264.m264_id =
                                       u08_map.old_cust_benefcry_acc_id(+))
              GROUP BY customer_id,
                       new_bank_id,
                       account_number,
                       bank_account_type,
                       beneficiary_cash_account)
    LOOP
        BEGIN
            IF i.customer_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Customer Not Available',
                                         TRUE);
            END IF;

            IF i.currency_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Currency Not Available',
                                         TRUE);
            END IF;

            IF i.account_number IS NULL
            THEN
                raise_application_error (-20001,
                                         'Account No. Not Available',
                                         TRUE);
            END IF;

            IF i.new_cust_benefcry_acc_id IS NULL
            THEN
                l_cust_beneficiary_acc_id := l_cust_beneficiary_acc_id + 1;

                INSERT
                  INTO dfn_ntp.u08_customer_beneficiary_acc (
                           u08_id,
                           u08_institute_id_m02,
                           u08_customer_id_u01,
                           u08_bank_id_m16,
                           u08_account_no,
                           u08_account_type_v01_id,
                           u08_currency_code_m03,
                           u08_account_name,
                           u08_is_default,
                           u08_created_by_id_u17,
                           u08_created_date,
                           u08_status_id_v01,
                           u08_bank_branch_name,
                           u08_iban_no,
                           u08_modified_by_id_u17,
                           u08_modified_date,
                           u08_status_changed_by_id_u17,
                           u08_status_changed_date,
                           u08_currency_id_m03,
                           u08_cash_account_id_u06,
                           u08_account_id,
                           u08_bank_account_type_v01,
                           u08_is_foreign_bank_acc,
                           u08_custom_type,
                           u08_sequence_no_b,
                           u08_id_type_m15,
                           u08_id_no,
                           u08_remarks)
                VALUES (l_cust_beneficiary_acc_id, -- u08_id
                        i.institute_id, -- u08_institute_id_m02
                        i.customer_id, -- u08_customer_id_u01
                        i.new_bank_id, -- u08_bank_id_m16
                        i.account_number, -- u08_account_no
                        i.beneficiary_account_type, -- u08_account_type_v01_id
                        i.currency_code, -- u08_currency_code_m03
                        i.account_name, -- u08_account_name
                        0, -- u08_is_default | Since Migrating from Two Tables
                        i.created_by_new_id, -- u08_created_by_id_u17
                        i.created_date, -- u08_created_date
                        i.map01_ntp_id, -- u08_status_id_v01
                        i.bank_branch_name, -- u08_bank_branch_name
                        i.iban_no, -- u08_iban_no
                        NULL, -- u08_modified_by_id_u17
                        NULL, -- u08_modified_date
                        0, -- u08_status_changed_by_id_u17
                        SYSDATE, -- u08_status_changed_date
                        i.currency_id, -- u08_currency_id_m03
                        i.customer_cash_acc, -- u08_cash_account_id_u06 | Cash Accoount Created Against
                        i.beneficiary_cash_account, -- u08_account_id | Required Only when Type is Cash Account
                        i.bank_account_type, -- u08_bank_account_type_v01
                        i.is_foreign_bank_acc, -- u08_is_foreign_bank_acc
                        '1', -- u08_custom_type
                        NULL, -- u08_sequence_no_b | Not Available
                        1, -- u08_id_type_m15 | Not Available. (1 - NIN)
                        i.m264_nin, -- u08_id_no
                        i.m264_remarks -- u08_remarks
                                      );

                INSERT
                  INTO u08_cust_benefcry_acc_mappings (
                           old_cust_benefcry_acc_id,
                           new_cust_benefcry_acc_id)
                VALUES (i.old_id, l_cust_beneficiary_acc_id);
            ELSE
                UPDATE dfn_ntp.u08_customer_beneficiary_acc
                   SET u08_institute_id_m02 = i.institute_id, -- u08_institute_id_m02
                       u08_customer_id_u01 = i.customer_id, -- u08_customer_id_u01
                       u08_bank_id_m16 = i.new_bank_id, -- u08_bank_id_m16
                       u08_account_no = i.account_number, -- u08_account_no
                       u08_account_type_v01_id = i.beneficiary_account_type, -- u08_account_type_v01_id
                       u08_currency_code_m03 = i.currency_code, -- u08_currency_code_m03
                       u08_account_name = i.account_name, -- u08_account_name
                       u08_status_id_v01 = i.map01_ntp_id, -- u08_status_id_v01
                       u08_bank_branch_name = i.bank_branch_name, -- u08_bank_branch_name
                       u08_iban_no = i.iban_no, -- u08_iban_no
                       u08_currency_id_m03 = i.currency_id, -- u08_currency_id_m03
                       u08_cash_account_id_u06 = i.customer_cash_acc, -- u08_cash_account_id_u06 | Cash Accoount Created Against
                       u08_account_id = i.beneficiary_cash_account, -- u08_account_id | Required Only when Type is Cash Account
                       u08_bank_account_type_v01 = i.bank_account_type, -- u08_bank_account_type_v01
                       u08_is_foreign_bank_acc = i.is_foreign_bank_acc, -- u08_is_foreign_bank_acc
                       u08_modified_by_id_u17 = 0, -- u08_modified_by_id_u17
                       u08_modified_date = SYSDATE, -- u08_modified_date
                       u08_id_type_m15 = 1, -- u08_id_type_m15 | Not Available. (1 - NIN)
                       u08_id_no = i.m264_nin, -- u08_id_no
                       u08_remarks = i.m264_remarks -- u08_remarks
                 WHERE u08_id = i.new_cust_benefcry_acc_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U08_CUSTOMER_BENEFICIARY_ACC',
                                i.old_id,
                                CASE
                                    WHEN i.new_cust_benefcry_acc_id IS NULL
                                    THEN
                                        l_cust_beneficiary_acc_id
                                    ELSE
                                        i.new_cust_benefcry_acc_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cust_benefcry_acc_id IS NULL
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
